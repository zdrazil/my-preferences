#!/usr/bin/env ts-node
import os from "os";
import fsPromise, { access, mkdir, rm, writeFile } from "fs/promises";
import fs, { mkdirSync } from "fs";
import child_process, { ExecException } from "child_process";
import { promisify } from "util";
import fetch from "node-fetch";
import { constVoid, identity, pipe } from "fp-ts/lib/function";
import { array, io, ioEither, task, taskEither, taskOption } from "fp-ts";
import yargs, { config } from "yargs";
import { hideBin } from "yargs/helpers";
import { mainModule } from "process";
import { sequenceArray, sequenceSeqArray } from "fp-ts/lib/TaskEither";
import { sequence } from "fp-ts/lib/Traversable";

// https://grossbart.github.io/fp-ts-recipes/#/async?a=work-with-a-list-of-tasks-in-parallel&id=tasks-that-may-fail

const exec = promisify(child_process.exec);

const homePath = os.homedir();
const configPath = `${homePath}/.config/`;
const binHomePath = `${homePath}/.local/bin`;

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

  const tasks = [
    installHomebrew(),
    installScripts(),
    installVimPlug(),
    clonePackages(),
  ];

  const result = await Promise.all(tasks);
}

// void main();

const installHomebrew = () =>
  pipe(
    taskOption.tryCatch(() => exec("command -v brew")),
    taskOption.fold(
      () =>
        taskEither.tryCatch(
          () =>
            fetch(
              "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
            )
              .then((res) => res.text())
              .then((brewScript) => exec(`sudo bash ${brewScript}`))
              .then(() => null),
          (e) => e as Error | ExecException
        ),
      () => taskEither.right(null)
    ),
    taskEither.map(() =>
      process.platform === "darwin"
        ? taskEither.tryCatch(
            () =>
              exec(
                "brew install bash coreutils findutils gnu-sed tmux yadm zsh tmux"
              ).then(() =>
                exec(
                  `brew bundle --verbose --file "${configPath}/packages/Brewfile"`
                ).then(() => null)
              ),
            (e) => e as ExecException
          )
        : taskEither.right(null)
    ),
    taskEither.flatten
  );

const installScripts = () =>
  pipe(
    [
      { name: "chtsh", url: "https://cht.sh/:cht.sh" },
      {
        name: "theme-sh",
        url: "https://raw.githubusercontent.com/lemnos/theme.sh/master/bin/theme.sh",
      },
    ],
    array.map(({ name, url }) => {
      const filePath = `${binHomePath}/${name}`;
      return pipe(
        taskOption.tryCatch(() => access(filePath)),
        taskOption.fold(
          () => taskEither.right(null),
          () => taskEither.left(null)
        ),
        taskEither.map(() =>
          taskEither.tryCatch(
            () =>
              Promise.all([
                fetch(url).then((res) => res.text()),
                rm(filePath, { recursive: true, force: true }),
              ]).then(([script]) =>
                writeFile(filePath, script, { mode: 0o755 })
              ),
            (e) => e as Error | ExecException | NodeJS.ErrnoException
          )
        ),
        taskEither.flatten
      );
    })
  );

const clonePackages = () => {
  return pipe(
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
    array.map(({ path, args }) => {
      const fullPath = `${homePath}${path}`;
      return pipe(
        taskEither.tryCatch(
          () =>
            rm(fullPath, { recursive: true, force: true }).then(() =>
              exec(`git clone ${args.join(" ")} ${fullPath}`)
            ),
          (e) => e as NodeJS.ErrnoException
        )
      );
    }),
    taskEither.sequenceArray,
    taskEither.map(() => {
      return [
        taskEither.tryCatch(
          () =>
            exec(
              `${homePath}/.fzf/install --key-bindings --completion --no-update-rc`
            ),
          (e) => e as ExecException
        ),
        configureAsdf,
      ];
    }),
    (a) => a
  );
};

const configureAsdf = () => {
  const asdfBin = `${homePath}/.asdf/bin/asdf`;
  return pipe(
    ["nodejs", "python", "yarn", "ruby", "haskell"],
    array.map((name) => {
      return taskEither.tryCatch(
        () => exec(`${asdfBin} plugin-add ${name}`),
        (e) => e as ExecException
      );
    }),
    taskEither.sequenceArray,
    taskEither.chain(() =>
      taskEither.tryCatch(
        () => exec(`${asdfBin} install}`),
        (e) => e as ExecException
      )
    )
  );
};

const installVimPlug = () => {
  const filePath = `${homePath}/.vim/autoload/plug.vim`;
  return pipe(
    taskEither.tryCatch(
      () =>
        fetch(
          "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        )
          .then((res) => res.text())
          .then((file) =>
            rm(filePath, { force: true }).then(() => writeFile(filePath, file))
          ),
      (e) => e as Error | ExecException
    ),
    taskEither.map(() => {
      return taskEither.tryCatch(
        () => exec('vim -es -u .vimrc -i NONE -c "PlugInstall" -c "qa"'),
        (e) => e as ExecException
      );
    })
  );
};
