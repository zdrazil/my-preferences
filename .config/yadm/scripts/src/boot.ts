#!/usr/bin/env ts-node
import child_process, { ExecException } from "child_process";
import { apply, array, either, option, taskEither } from "fp-ts";
import { identity, Lazy, pipe } from "fp-ts/lib/function";
import { accessSync } from "fs";
import { rm, writeFile } from "fs/promises";
import fetch from "node-fetch";
import os from "os";
import { promisify } from "util";
import yargs from "yargs";
import { hideBin } from "yargs/helpers";

// https://grossbart.github.io/fp-ts-recipes/#/async?a=work-with-a-list-of-tasks-in-parallel&id=tasks-that-may-fail

/**
 * HELPERS, TYPES AND CONSTANTS
 **/

const exec = promisify(child_process.exec);
const execSync = promisify(child_process.execSync);

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

const isAccessible = (...args: Parameters<typeof accessSync>): boolean =>
  pipe(
    option.tryCatch(() => accessSync(...args)),
    option.isSome
  );

const commandExists = (command: string): boolean =>
  pipe(
    option.tryCatch(() => execSync(`command -v brew ${command}`)),
    option.isSome
  );

const filterExisting = <T extends { fullPath: string }>(o: T[]) =>
  pipe(
    o,
    array.filterMap((a) =>
      isAccessible(a.fullPath) ? option.some(a) : option.none
    )
  );

const homePath = os.homedir();
const configPath = `${homePath}/.config/`;
const binHomePath = `${homePath}/.local/bin`;

/**
 * PACKAGERS
 */

function installHomebrew():  {
  const brewScriptUrl =
    "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh";

  const installBrew = commandExists("brew")
    ? pipe(
        TETryCatch(() => fetch(brewScriptUrl).then((res) => res.text())),
        taskEither.chainW((brewScript) => taskExec(`sudo bash ${brewScript}`))
      )
    : taskEither.right({ stdout: "", stderr: "" });

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
      fullPath: `${binHomePath}/${script.name}`,
    })),
    forceReinstall ? identity : filterExisting,
    taskEither.traverseArray(({ fullPath, url }) =>
      TETryCatch(() =>
        fetch(url)
          .then((res) => res.text())
          .then((script) => writeFile(fullPath, script, { mode: 0o755 }))
      )
    )
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
    forceReinstall ? identity : filterExisting,
    taskEither.traverseSeqArray(({ fullPath, args }) =>
      apply.sequenceT(taskEither.ApplySeq)(
        TETryCatch(() => rm(fullPath, { recursive: true, force: true })),
        taskExec(`git clone ${args.join(" ")} ${fullPath}`)
      )
    )
  );
  const afterClone = apply.sequenceS(taskEither.ApplyPar)({
    fzf: taskExec(
      `${homePath}/.fzf/install --key-bindings --completion --no-update-rc`
    ),
    asdf: configureAsdf(),
  });

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

  return !isAccessible(filePath) || forceReinstall
    ? apply.sequenceT(taskEither.ApplySeq)(downloadPlug, installPlugPlugins)
    : taskEither.right({
        stdout: "Plug already exists. Skipped installation.",
        stderr: "",
      });
}

/**
 * MAIN
 **/
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
  const tasks = apply.sequenceS(taskEither.ApplyPar)({
    homebrew: installHomebrew(),
    scripts: installScripts({ forceReinstall }),
    vimPlug: installVimPlug({ forceReinstall }),
    packages: clonePackages({ forceReinstall }),
  });
  const results = await tasks();

  const b = pipe(
    results,
    either.matchW(
      (e) => console.log(e),
      ({ homebrew, scripts, vimPlug, packages }) => "a"
    )
  );
  console.log(result);
}
void main();
