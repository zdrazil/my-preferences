#!/usr/bin/env ts-node
import child_process, { ExecException } from "child_process";
import { apply, array, either, option, taskEither } from "fp-ts";
import { identity, Lazy, pipe } from "fp-ts/lib/function";
import { TaskEither } from "fp-ts/lib/TaskEither";
import { accessSync } from "fs";
import { mkdir, rm, writeFile } from "fs/promises";
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

const isExecPromiseError = (e: Error): e is ExecPromiseError => {
  return (e as ExecPromiseError).stderr !== undefined;
};

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
    option.tryCatch(() => execSync(`command -v ${command}`)),
    option.isSome
  );

const filterNonExisting = <T extends { fullPath: string }>(o: T[]) =>
  pipe(
    o,
    array.filterMap((a) =>
      isAccessible(a.fullPath) ? option.none : option.some(a)
    )
  );

const homePath = os.homedir();
const configPath = `${homePath}/.config/`;
const binHomePath = `${homePath}/.local/bin`;

/**
 * PACKAGERS
 */

const createExecError = (e: Error): ExecPromiseError => {
  (e as ExecPromiseError).stderr = e.name + e.message;
  (e as ExecPromiseError).stderr = "";

  return e as ExecPromiseError;
};

const mergeOutputStreams = (
  outputStreams: Readonly<OutputStreams[]>
): Readonly<OutputStreams> =>
  pipe(
    [...outputStreams],
    array.reduce(
      {
        stderr: "",
        stdout: "",
      },
      (acc, { stderr, stdout }) => {
        const append = (prev: string, curr: string) => {
          if (prev === "") return curr;
          else if (curr === "") return prev;
          else return `${prev}\n${curr}`;
        };

        return {
          stderr: append(acc.stderr, stderr),
          stdout: append(acc.stdout, stdout),
        };
      }
    )
  );
type FinalType = TaskEither<ExecPromiseError, OutputStreams>;

function installHomebrew(): FinalType {
  const brewScriptUrl =
    "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh";

  const installBrew: FinalType = !commandExists("brew")
    ? pipe(
        TETryCatch(() => fetch(brewScriptUrl).then((res) => res.text())),
        taskEither.chainW((brewScript) => taskExec(`sudo bash ${brewScript}`)),
        taskEither.mapLeft((e) =>
          isExecPromiseError(e) ? e : createExecError(e)
        )
      )
    : taskEither.right({ stdout: "Homebrew already installed", stderr: "" });

  const installBrewPackages: FinalType =
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
          taskEither.sequenceSeqArray,
          taskEither.map(mergeOutputStreams)
        )
      : taskEither.right({
          stderr: "",
          stdout: "No homebrew packages to install\n",
        });

  const result = pipe(
    apply.sequenceT(taskEither.ApplySeq)(installBrew, installBrewPackages),
    taskEither.map(mergeOutputStreams)
  );
  return result;
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const tapLog = <T>(value: T): T => {
  console.log(value);
  return value;
};

function installScripts({ forceReinstall }: Options): FinalType {
  const scripts = [
    { name: "chtsh", url: "https://cht.sh/:cht.sh" },
    {
      name: "theme-sh",
      url: "https://raw.githubusercontent.com/lemnos/theme.sh/master/bin/theme.sh",
    },
  ];

  const result = pipe(
    scripts,
    array.map((script) => ({
      ...script,
      fullPath: `${binHomePath}/${script.name}`,
    })),
    forceReinstall ? identity : filterNonExisting,
    taskEither.traverseArray(({ fullPath, url }) =>
      pipe(
        TETryCatch(() =>
          fetch(url)
            .then((res) => res.text())
            .then((script) => writeFile(fullPath, script, { mode: 0o755 }))
        ),
        taskEither.map(() => ({ stdout: `Installed ${fullPath}`, stderr: "" }))
      )
    ),
    taskEither.mapLeft((e) => (isExecPromiseError(e) ? e : createExecError(e))),
    taskEither.map(mergeOutputStreams)
  );

  return result;
}

function clonePackages({ forceReinstall }: Options): FinalType {
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
    forceReinstall ? identity : filterNonExisting,
    taskEither.traverseSeqArray(({ fullPath, args }) =>
      apply.sequenceT(taskEither.ApplySeq)(
        pipe(
          TETryCatch(() => rm(fullPath, { recursive: true, force: true })),
          taskEither.map(() => ({ stdout: `Removed ${fullPath}`, stderr: "" }))
        ),
        taskExec(`git clone ${args.join(" ")} ${fullPath}`)
      )
    ),
    taskEither.map((a) => pipe([...a], array.flatten, mergeOutputStreams))
  );
  const afterClone = pipe(
    apply.sequenceT(taskEither.ApplyPar)(
      taskExec(
        `${homePath}/.fzf/install --key-bindings --completion --no-update-rc`
      ),
      configureAsdf()
    ),
    taskEither.map(mergeOutputStreams)
  );

  const result = pipe(
    apply.sequenceT(taskEither.ApplySeq)(cloneAll, afterClone),
    taskEither.mapLeft((e) => (isExecPromiseError(e) ? e : createExecError(e))),
    taskEither.map(mergeOutputStreams)
  );
  return result;
}

function configureAsdf(): FinalType {
  const asdfBin = `${homePath}/.asdf/bin/asdf`;
  const addPlugins = pipe(
    ["nodejs", "python", "yarn", "ruby", "haskell"],
    taskEither.traverseSeqArray((name) =>
      taskExec(`${asdfBin} plugin-add ${name}`)
    ),
    taskEither.map(mergeOutputStreams),
    taskEither.match((e) => ({ stderr: "", stdout: e.stderr }), identity),
    (a) => taskEither.rightTask<ExecPromiseError, OutputStreams>(a)
  );

  const result = pipe(
    apply.sequenceT(taskEither.ApplySeq)(
      addPlugins,
      taskExec(`${asdfBin} install`)
    ),
    taskEither.map(mergeOutputStreams)
  );

  return result;
}

function installVimPlug({ forceReinstall }: Options): FinalType {
  const filePath = `${homePath}/.vim/autoload/plug.vim`;
  const downloadPlug = pipe(
    TETryCatch(() =>
      fetch(
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
      )
        .then((res) => res.text())
        .then((file) =>
          rm(filePath, { force: true })
            .then(() => mkdir(filePath, { recursive: true }))
            .then(() => writeFile(filePath, file))
        )
    ),
    taskEither.map(() => ({ stdout: `Installed ${filePath}`, stderr: "" })),
    taskEither.mapLeft((e) => (isExecPromiseError(e) ? e : createExecError(e)))
  );

  const installPlugPlugins = taskExec("vim +'PlugInstall --sync' +qa");
  const result =
    !isAccessible(filePath) || forceReinstall
      ? pipe(
          apply.sequenceT(taskEither.ApplySeq)(
            downloadPlug,
            installPlugPlugins
          ),
          taskEither.map(mergeOutputStreams)
        )
      : taskEither.right({
          stdout: "VimPlug is already installed. Skipped installation.",
          stderr: "",
        });
  return result;
}

/**
 * MAIN
 **/
async function main() {
  const args = await yargs(hideBin(process.argv)).options({
    reinstall: {
      type: "boolean",
      default: false,
      alias: "r",
      describe: "Reinstall all packages",
    },
  }).argv;
  const forceReinstall = args.reinstall;

  const tasks = apply.sequenceT(taskEither.ApplyPar)(
    installHomebrew(),
    installScripts({ forceReinstall }),
    installVimPlug({ forceReinstall }),
    clonePackages({ forceReinstall })
  );
  const results = await tasks();

  pipe(
    results,
    either.matchW(
      (e) => console.log(e.stderr),
      (tasks) => {
        tasks.forEach((task) => console.log(task.stdout));
      }
    )
  );
}
void main();
