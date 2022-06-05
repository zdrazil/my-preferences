#!/usr/bin/env ts-node
import {
  apply,
  array,
  either,
  option,
  record,
  string,
  task,
  taskEither,
} from "fp-ts";
import { Either } from "fp-ts/Either";
import { constVoid, identity, Lazy, pipe } from "fp-ts/function";
import { TaskEither } from "fp-ts/TaskEither";
import child_process from "node:child_process";
import { accessSync } from "node:fs";
import { mkdir, rm, writeFile } from "node:fs/promises";
import os from "node:os";
import { promisify } from "node:util";
import fetch from "node-fetch";
import yargs from "yargs";
import { hideBin } from "yargs/helpers";

// https://grossbart.github.io/fp-ts-recipes/#/async?a=work-with-a-list-of-tasks-in-parallel&id=tasks-that-may-fail

/**
 * HELPERS, TYPES AND CONSTANTS
 **/

const execSync = promisify(child_process.execSync);

interface Dependencies {
  binHomePath: string;
  configPath: string;
  forceReinstall: boolean;
  homePath: string;
  spawn: ReturnType<typeof createSpawn>;
}

function fromThunk<A>(thunk: Lazy<Promise<A>>): TaskEither<Error, A> {
  return taskEither.tryCatch(thunk, either.toError);
}

const TEfetchText = (...args: Parameters<typeof fetch>) =>
  fromThunk(() => fetch(...args).then((res) => res.text()));

interface SpawnOptions {
  ignoredErrors?: number[];
}

const createSpawn = () => {
  const abortController = new AbortController();
  process.on("uncaughtException", () => abortController.abort());
  process.on("SIGINT", () => abortController.abort());
  process.on("SIGTERM", () => abortController.abort());

  return (
      cmd: string,
      args?: string,
      options?: SpawnOptions,
    ): taskEither.TaskEither<Error, void> =>
    () =>
      new Promise((resolve) => {
        const childProc = child_process.spawn(
          cmd + (args ? ` ${args}` : ""),
          [],
          {
            shell: true,
            signal: abortController.signal,
          },
        );

        childProc.stdout.on("data", (data: Buffer) => {
          console.log(cmd);
          console.log(data.toString());
        });

        childProc.stderr.on("data", (data: Buffer) => {
          console.error(cmd);
          console.error(data.toString());
        });

        const ignoredErrors: Array<number | null> =
          options?.ignoredErrors || [];
        childProc.on("close", (code, signal) => {
          if (code === 0 || ignoredErrors.includes(code)) {
            resolve(either.right(undefined));
            return;
          }

          const error = new Error(
            `${cmd} process exited with ${JSON.stringify({ code, signal })}`,
          );

          console.error(error.message);
          resolve(either.left(error));
        });
      });
};

const commandExists = (command: string): boolean =>
  pipe(
    option.tryCatch(() => execSync(`command -v ${command}`)),
    option.isSome,
  );

const isAccessible = (...args: Parameters<typeof accessSync>): boolean =>
  pipe(
    option.tryCatch(() => accessSync(...args)),
    option.isSome,
  );

const filterNonExisting = <T extends { fullPath: string }>(o: T[]) =>
  pipe(
    o,
    array.filterMap((a) =>
      isAccessible(a.fullPath) ? option.none : option.some(a),
    ),
  );

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const tapLog = <T>(value: T): T => {
  console.log(value);
  return value;
};

/**
 * PACKAGERS
 */

function installHomebrew({ configPath, spawn }: Dependencies) {
  const brewScriptUrl =
    "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh";

  const installBrew = !commandExists("brew")
    ? pipe(
        TEfetchText(brewScriptUrl),
        taskEither.chain((brewScript) => spawn("sudo bash", `${brewScript}`)),
      )
    : taskEither.of(constVoid());

  const darwinBrew = pipe(
    taskEither.of(constVoid()),
    taskEither.apFirst(
      spawn(
        "brew install",
        "bash coreutils findutils gnu-sed tmux yadm zsh tmux",
      ),
    ),
    taskEither.apFirst(
      spawn(
        "brew bundle",
        `--verbose --file "${configPath}/packages/Brewfile"`,
      ),
    ),
  );

  return pipe(
    [installBrew, darwinBrew],
    taskEither.sequenceArray,
    taskEither.map(constVoid),
  );
}

interface Script {
  url: string;
  fullPath: string;
}

function installScripts({ binHomePath, forceReinstall }: Dependencies) {
  const scripts = [
    { name: "chtsh", url: "https://cht.sh/:cht.sh" },
    {
      name: "theme-sh",
      url: "https://raw.githubusercontent.com/lemnos/theme.sh/master/bin/theme.sh",
    },
  ];

  const installScript = ({ url, fullPath }: Script) =>
    pipe(
      { url, fullPath },
      taskEither.of,
      taskEither.apS("scriptFile", TEfetchText(url)),
      taskEither.chain(({ scriptFile }) =>
        fromThunk(() => writeFile(fullPath, scriptFile, { mode: 0o755 })),
      ),
    );

  const tasks = pipe(
    scripts,
    array.map((script) => ({
      ...script,
      fullPath: `${binHomePath}/${script.name}`,
    })),
    forceReinstall ? identity : filterNonExisting,
    taskEither.traverseArray(installScript),
    taskEither.map(constVoid),
  );

  return tasks;
}

function clonePackages({ homePath, forceReinstall, spawn }: Dependencies) {
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

  interface Package {
    fullPath: string;
    args: string[];
  }

  const clonePackage = ({ fullPath, args }: Package) =>
    pipe(
      [
        fromThunk(() => rm(fullPath, { recursive: true, force: true })),
        spawn(`git clone`, `${args.join(" ")} ${fullPath}`),
      ],
      taskEither.sequenceSeqArray,
      taskEither.map(constVoid),
    );

  const cloneAll = pipe(
    packages,
    array.map((appPackage) => ({
      ...appPackage,
      fullPath: `${homePath}${appPackage.path}`,
    })),
    forceReinstall ? identity : filterNonExisting,
    taskEither.traverseArray(clonePackage),
    taskEither.map(constVoid),
  );

  const installFzf = spawn(
    `${homePath}/.fzf/install`,
    "--key-bindings --completion --no-update-rc",
  );

  const afterClone = pipe(
    [installFzf, configureAsdf({ homePath, spawn })],
    taskEither.sequenceArray,
    taskEither.map(constVoid),
  );

  return pipe(
    [cloneAll, afterClone],
    taskEither.sequenceSeqArray,
    taskEither.map(constVoid),
  );
}

function configureAsdf({
  homePath,
  spawn,
}: Pick<Dependencies, "spawn" | "homePath">) {
  const asdfBin = `${homePath}/.asdf/bin/asdf`;
  const addPlugin = (name: string) =>
    spawn(`${asdfBin} plugin-add`, name, { ignoredErrors: [2] });

  const addPlugins = pipe(
    ["nodejs", "python", "yarn", "ruby", "haskell"],
    taskEither.traverseSeqArray(addPlugin),
    taskEither.map(constVoid),
  );

  const asdfInstall = spawn(`${asdfBin} install`);

  return pipe(
    [addPlugins, asdfInstall],
    taskEither.sequenceSeqArray,
    taskEither.map(constVoid),
  );
}

function installVimPlug({ forceReinstall, homePath, spawn }: Dependencies) {
  const filePath = `${homePath}/.vim/autoload/plug.vim`;
  const downloadPlug = pipe(
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
    TEfetchText,
    taskEither.chainFirst((file) =>
      fromThunk(() =>
        rm(filePath, { recursive: true, force: true })
          .then(() => mkdir(filePath, { recursive: true }))
          .then(() => writeFile(filePath, file)),
      ),
    ),
    taskEither.map(constVoid),
  );

  const installPlugPlugins = spawn("vim", "+'PlugInstall --sync' +qa");

  return pipe(
    !isAccessible(filePath) || forceReinstall
      ? [downloadPlug, installPlugPlugins]
      : [],
    taskEither.sequenceSeqArray,
    taskEither.map(constVoid),
  );
}

/**
 * MAIN
 **/

const logError = (name: string, error: Either<Error, void>) =>
  pipe(
    error,
    either.orElse((e) => {
      console.error(`${name} installation failed: ${e.toString()}`);
      return either.left(e);
    }),
  );

const runTasks = async (dependencies: Dependencies) => {
  const tasks = apply.sequenceS(task.ApplicativePar)({
    homeBrew: installHomebrew(dependencies),
    scripts: installScripts(dependencies),
    vimPlug: installVimPlug(dependencies),
    cloned: clonePackages(dependencies),
  });

  return pipe(
    await tasks(),
    record.mapWithIndex(logError),
    record.collect(string.Ord)((k, v) => v),
    either.sequenceArray,
    either.getOrElseW(() => process.exit(1)),
  );
};

async function main() {
  const args = await yargs(hideBin(process.argv)).options({
    reinstall: {
      type: "boolean",
      default: false,
      alias: "r",
      describe: "Reinstall all packages",
    },
  }).argv;

  const spawn = createSpawn();
  const forceReinstall = args.reinstall;
  const homePath = os.homedir();
  const binHomePath = `${homePath}/.local/bin`;
  const configPath = `${homePath}/.config/`;

  await runTasks({
    forceReinstall,
    configPath,
    homePath,
    binHomePath,
    spawn,
  });
}
void main();
