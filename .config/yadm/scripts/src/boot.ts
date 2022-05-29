#!/usr/bin/env ts-node
import os from "os";
import { access, rm, writeFile } from "fs/promises";
import child_process, { ExecException } from "child_process";
import { promisify } from "util";
import fetch from "node-fetch";
import { pipe } from "fp-ts/lib/function";
import { taskEither, taskOption, apply } from "fp-ts";
import yargs from "yargs";
import { hideBin } from "yargs/helpers";

// https://grossbart.github.io/fp-ts-recipes/#/async?a=work-with-a-list-of-tasks-in-parallel&id=tasks-that-may-fail

const exec = promisify(child_process.exec);

const homePath = os.homedir();
const configPath = `${homePath}/.config/`;
const binHomePath = `${homePath}/.local/bin`;

const installHomebrew = () => {
  const downloadBrew = pipe(
    taskOption.tryCatch(() => exec("command -v brew")),
    taskOption.foldW(
      () =>
        taskEither.tryCatch(
          () =>
            fetch(
              "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
            )
              .then((res) => res.text())
              .then((brewScript) => exec(`sudo bash ${brewScript}`)),
          (e) => e as Error | ExecException
        ),
      () => taskEither.right(null)
    )
  );
  const installBrewPackages =
    process.platform === "darwin"
      ? taskEither.tryCatch(
          () =>
            exec(
              "brew install bash coreutils findutils gnu-sed tmux yadm zsh tmux"
            ).then(() =>
              exec(
                `brew bundle --verbose --file "${configPath}/packages/Brewfile"`
              )
            ),
          (e) => e as ExecException
        )
      : taskEither.right(null);

  return apply.sequenceT(taskEither.ApplySeq)(
    downloadBrew,
    installBrewPackages
  );

  // taskEither.sequenceSeqArray([downloadBrew, installBrewPackages]);
};

const installScripts = () =>
  pipe(
    [
      { name: "chtsh", url: "https://cht.sh/:cht.sh" },
      {
        name: "theme-sh",
        url: "https://raw.githubusercontent.com/lemnos/theme.sh/master/bin/theme.sh",
      },
    ],
    taskEither.traverseArray(({ name, url }) => {
      const filePath = `${binHomePath}/${name}`;
      return pipe(
        taskOption.tryCatch(() => access(filePath)),
        taskOption.foldW(
          () =>
            taskEither.tryCatch(
              () =>
                Promise.all([
                  fetch(url).then((res) => res.text()),
                  rm(filePath, { recursive: true, force: true }),
                ]).then(([script]) =>
                  writeFile(filePath, script, { mode: 0o755 })
                ),
              (e) => e as Error | ExecException | NodeJS.ErrnoException
            ),
          () => taskEither.right(null)
        )
      );
    })
  );

const clonePackages = () => {
  const cloneAll = pipe(
    [
      {
        path: "/.fzf",
        args: ["--depth", "1", "https://github.com/junegunn/fzf.git"],
      },
      {
        path: "/.tmux/plugins/tpm",
        args: ["https://github.com/tmux-plugins/tpm"],
      },
      {
        path: "/.zgen",
        args: ["https://github.com/tarjoilija/zgen.git"],
      },
      {
        path: "/.asdf",
        args: ["--branch", "v0.10.0", "https://github.com/asdf-vm/asdf.git"],
      },
    ],
    taskEither.traverseArray(({ path, args }) => {
      const fullPath = `${homePath}${path}`;
      return pipe(
        taskEither.tryCatch(
          () =>
            rm(fullPath, { recursive: true, force: true }).then(() =>
              exec(`git clone ${args.join(" ")} ${fullPath}`)
            ),
          (e) => e as Error
        )
      );
    })
  );
  const afterClone = apply.sequenceT(taskEither.ApplyPar)(
    configureFzf,
    configureAsdf()
  );

  return apply.sequenceT(taskEither.ApplySeq)(cloneAll, afterClone);
};

const configureFzf = taskEither.tryCatch(
  () =>
    exec(`${homePath}/.fzf/install --key-bindings --completion --no-update-rc`),
  (e) => e as ExecException
);

const configureAsdf = () => {
  const asdfBin = `${homePath}/.asdf/bin/asdf`;
  const addPlugins = pipe(
    ["nodejs", "python", "yarn", "ruby", "haskell"],
    taskEither.traverseSeqArray((name) =>
      taskEither.tryCatch(
        () => exec(`${asdfBin} plugin-add ${name}`),
        (e) => e as ExecException
      )
    )
  );

  const installPlugins = taskEither.tryCatch(
    () => exec(`${asdfBin} install}`),
    (e) => e as ExecException
  );

  return apply.sequenceT(taskEither.ApplySeq)(addPlugins, installPlugins);
};

const installVimPlug = () => {
  const filePath = `${homePath}/.vim/autoload/plug.vim`;
  const downloadPlug = taskEither.tryCatch(
    () =>
      fetch(
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
      )
        .then((res) => res.text())
        .then((file) =>
          rm(filePath, { force: true }).then(() => writeFile(filePath, file))
        ),
    (e) => e as Error | ExecException
  );
  const installPlug = taskEither.tryCatch(
    () => exec('vim -es -u .vimrc -i NONE -c "PlugInstall" -c "qa"'),
    (e) => e as Error | ExecException
  );
  return apply.sequenceT(taskEither.ApplySeq)(downloadPlug, installPlug);
};

const tasks = apply.sequenceT(taskEither.ApplyPar)(
  // installHomebrew(),
  installScripts()
  // installVimPlug(),
  // clonePackages()
);

async function main() {
  const args = await yargs(hideBin(process.argv)).options({
    reinstall: {
      type: "boolean",
      default: true,
      alias: "r",
      describe: "Reinstall all packages",
    },
  }).argv;
  const shouldReinstall = args.reinstall;
  const result = await tasks();
  console.log(result);
}
// eslint-disable-next-line functional/no-expression-statement
void main();
