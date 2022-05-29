#!/usr/bin/env ts-node
import os from "os";
import { access, rm, writeFile } from "fs/promises";
import child_process, { ExecException } from "child_process";
import { promisify } from "util";
import fetch, { FetchError } from "node-fetch";

import { Lazy, pipe } from "fp-ts/lib/function";
import { taskEither, taskOption, apply, array } from "fp-ts";
import yargs, { option } from "yargs";
import { hideBin } from "yargs/helpers";
import { taskify } from "fp-ts/lib/TaskEither";
import got from "got";

// https://grossbart.github.io/fp-ts-recipes/#/async?a=work-with-a-list-of-tasks-in-parallel&id=tasks-that-may-fail

const exec = promisify(child_process.exec);

interface OutputStreams {
  stderr: string;
  stdout: string;
}
type ExecPromiseError = ExecException & OutputStreams;

interface Options {
  forceReinstall: boolean;
}

const taskExec = (cmd: string) =>
  taskEither.tryCatch(
    () => exec(cmd),
    (e) => e as ExecPromiseError
  );

const TETryCatch = <A>(f: Lazy<Promise<A>>) =>
  taskEither.tryCatch(f, (e) => e as Error);

const emptyOutput = { stderr: "", stdout: "" };

const homePath = os.homedir();
const configPath = `${homePath}/.config/`;
const binHomePath = `${homePath}/.local/bin`;

function installHomebrew() {
  const brewScriptUrl =
    "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh";

  const installBrew = pipe(
    taskExec("command -v brew"),
    taskEither.foldW(
      () =>
        pipe(
          TETryCatch(() => fetch(brewScriptUrl).then((res) => res.text())),
          taskEither.chainW((brewScript) => taskExec(`sudo bash ${brewScript}`))
        ),
      () =>
        taskEither.right({
          stdout: "Command brew already exists. Skipping installation.",
          stderr: "",
        })
    )
  );

  const installBrewPackages =
    process.platform === "darwin"
      ? pipe(
          [
            taskExec(
              "brew install bash coreutils findutils gnu-sed tmux yadm zsh tmux"
            ),
            taskExec(
              `brew bundle --verbose --file "${configPath}/packages/Brewfile"`
            ),
          ],
          taskEither.sequenceSeqArray
        )
      : taskEither.right({
          stderr: "",
          stdout: "No homebrew packages to install\n",
        });

  return apply.sequenceT(taskEither.ApplySeq)(installBrew, installBrewPackages);
}

function installScripts({ forceReinstall }: Options) {
  const scripts = [
    { name: "chtsh", url: "https://cht.sh/:cht.sh" },
    {
      name: "theme-sh",
      url: "https://raw.githubusercontent.com/lemnos/theme.sh/master/bin/theme.sh",
    },
  ];
  return pipe(
    scripts,
    array.map((script) => ({
      ...script,
      filePath: `${binHomePath}/${script.name}`,
    })),
    taskEither.traverseArray(({ filePath, url }) => {
      const installScript = TETryCatch(() =>
        fetch(url)
          .then((res) => res.text())
          .then((script) => writeFile(filePath, script, { mode: 0o755 }))
      );

      return pipe(
        [
          taskOption.tryCatch(() => access(filePath)),
          taskOption.guard(!forceReinstall),
        ],
        taskOption.sequenceArray,
        taskOption.foldW(
          () => installScript,
          () => taskEither.right(null)
        )
      );
    })
  );
}
function clonePackages({ forceReinstall }: Options) {
  const packages = [
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
  ];
  const cloneAll = pipe(
    packages,
    array.map((appPackage) => ({
      ...appPackage,
      fullPath: `${homePath}${appPackage.path}`,
    })),
    taskEither.traverseSeqArray(({ fullPath, args }) => {
      const installScript = apply.sequenceT(taskEither.ApplySeq)(
        TETryCatch(() => rm(fullPath, { recursive: true, force: true })),
        taskExec(`git clone ${args.join(" ")} ${fullPath}`)
      );

      return pipe(
        [
          taskOption.tryCatch(() => access(fullPath)),
          taskOption.guard(!forceReinstall),
        ],
        taskOption.sequenceArray,
        taskOption.foldW(
          () => installScript,
          () => taskEither.right(null)
        )
      );
    })
  );
  const afterClone = apply.sequenceT(taskEither.ApplyPar)(
    taskExec(
      `${homePath}/.fzf/install --key-bindings --completion --no-update-rc`
    ),
    configureAsdf()
  );

  return apply.sequenceT(taskEither.ApplySeq)(cloneAll, afterClone);
}

function configureAsdf() {
  const asdfBin = `${homePath}/.asdf/bin/asdf`;
  const addPlugins = pipe(
    ["nodejs", "python", "yarn", "ruby", "haskell"],
    taskEither.traverseSeqArray((name) =>
      taskExec(`${asdfBin} plugin-add ${name}`)
    )
  );

  return apply.sequenceT(taskEither.ApplySeq)(
    addPlugins,
    taskExec(`${asdfBin} install}`)
  );
}

function installVimPlug({ forceReinstall }: Options) {
  const filePath = `${homePath}/.vim/autoload/plug.vim`;
  const downloadPlug = TETryCatch(() =>
    fetch("https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
      .then((res) => res.text())
      .then((file) =>
        rm(filePath, { force: true }).then(() => writeFile(filePath, file))
      )
  );

  const installPlugPlugins = taskExec(
    'vim -es -u .vimrc -i NONE -c "PlugInstall" -c "qa"'
  );
  const check = pipe(
    [
      taskOption.tryCatch(() => access(filePath)),
      taskOption.guard(!forceReinstall),
    ],
    taskOption.sequenceArray,
    taskEither.fromTaskOption(() => new Error("Skip"))
  );
  return apply.sequenceT(taskEither.ApplySeq)(
    check,
    downloadPlug,
    installPlugPlugins
  );
}

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
  const forceReinstall = args.reinstall;
  const result = await tasks();
  console.log(result);
}
// eslint-disable-next-line functional/no-expression-statement
void main();
