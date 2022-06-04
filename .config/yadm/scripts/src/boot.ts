#!/usr/bin/env ts-node
import child_process, { ChildProcess } from "child_process";
import { apply, array, either, option, record, task, taskEither } from "fp-ts";
import { constVoid, identity, Lazy, pipe } from "fp-ts/function";
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
 * PROCESS CLEANUP
 **/

/**
 * HELPERS, TYPES AND CONSTANTS
 **/

const execSync = promisify(child_process.execSync);

interface Options {
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

const createCleanupProcess = () => {
  const childProcesses: Set<ChildProcess> = new Set();
  const killChildProcesses = () =>
    childProcesses.forEach((worker) =>
      worker.pid ? process.kill(worker.pid) : null
    );

  process.on("uncaughtException", killChildProcesses);
  process.on("SIGINT", killChildProcesses);
  process.on("SIGTERM", killChildProcesses);

  return {
    add: (childProcess: ChildProcess) => childProcesses.add(childProcess),
    delete: (childProcess: ChildProcess) => childProcesses.delete(childProcess),
  };
};

interface SpawnOptions {
  ignoredErrors?: number[];
}

const createSpawn = () => {
  const cleanupProcess = createCleanupProcess();
  return (cmd: string, args?: string, options?: SpawnOptions) =>
    pipe(
      () =>
        new Promise<void>((resolve, reject) => {
          const command = child_process.spawn(
            cmd + (args ? ` ${args}` : ""),
            [],
            {
              shell: true,
            }
          );
          cleanupProcess.add(command);

          command.stdout.on("data", (data: Buffer) => {
            console.log(cmd);
            console.log(data.toString());
          });

          command.stderr.on("data", (data: Buffer) => {
            console.error(cmd);
            console.error(data.toString());
          });

          const ignoredErrors: Array<number | null> =
            options?.ignoredErrors || [];
          command.on("close", (code = 0) => {
            cleanupProcess.delete(command);
            if (code !== 0 && !ignoredErrors.includes(code)) {
              console.error(
                `${cmd} process exited with code ${code ?? "undefined"}`
              );
              reject(`${cmd} process exited with code ${code ?? "undefined"}`);
            }
            resolve();
          });
        }),
      fromThunk
    );
};

const commandExists = (command: string): boolean =>
  pipe(
    option.tryCatch(() => execSync(`command -v ${command}`)),
    option.isSome
  );

const isAccessible = (...args: Parameters<typeof accessSync>): boolean =>
  pipe(
    option.tryCatch(() => accessSync(...args)),
    option.isSome
  );

const filterNonExisting = <T extends { fullPath: string }>(o: T[]) =>
  pipe(
    o,
    array.filterMap((a) =>
      isAccessible(a.fullPath) ? option.none : option.some(a)
    )
  );

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const tapLog = <T>(value: T): T => {
  console.log(value);
  return value;
};

/**
 * PACKAGERS
 */

function installHomebrew({ configPath, spawn }: Options) {
  const brewScriptUrl =
    "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh";

  const installBrew = commandExists("brew")
    ? pipe(
        TEfetchText(brewScriptUrl),
        taskEither.chain((brewScript) => spawn("sudo bash", `${brewScript}`))
      )
    : taskEither.of(constVoid());

  const darwinBrew = pipe(
    taskEither.of(constVoid()),
    taskEither.apFirst(
      spawn(
        "brew install",
        "bash coreutils findutils gnu-sed tmux yadm zsh tmux"
      )
    ),
    taskEither.apFirst(
      spawn("brew bundle", `--verbose --file "${configPath}/packages/Brewfile"`)
    )
  );

  return pipe(
    [installBrew, darwinBrew],
    taskEither.sequenceArray,
    taskEither.map(constVoid)
  );
}

interface Script {
  url: string;
  fullPath: string;
}

function installScripts({ binHomePath, forceReinstall }: Options) {
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
        fromThunk(() => writeFile(fullPath, scriptFile, { mode: 0o755 }))
      )
    );

  const tasks = pipe(
    scripts,
    array.map((script) => ({
      ...script,
      fullPath: `${binHomePath}/${script.name}`,
    })),
    forceReinstall ? identity : filterNonExisting,
    taskEither.traverseArray(installScript),
    taskEither.map(constVoid)
  );

  return tasks;
}

function clonePackages({ homePath, forceReinstall, spawn }: Options) {
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
      taskEither.map(constVoid)
    );

  const cloneAll = pipe(
    packages,
    array.map((appPackage) => ({
      ...appPackage,
      fullPath: `${homePath}${appPackage.path}`,
    })),
    forceReinstall ? identity : filterNonExisting,
    taskEither.traverseArray(clonePackage),
    taskEither.map(constVoid)
  );

  const installFzf = spawn(
    `${homePath}/.fzf/install`,
    "--key-bindings --completion --no-update-rc"
  );

  const afterClone = pipe(
    [installFzf, configureAsdf({ homePath, spawn })],
    taskEither.sequenceArray,
    taskEither.map(constVoid)
  );

  return pipe(
    [cloneAll, afterClone],
    taskEither.sequenceSeqArray,
    taskEither.map(constVoid)
  );
}

function configureAsdf({
  homePath,
  spawn,
}: Pick<Options, "spawn" | "homePath">) {
  const asdfBin = `${homePath}/.asdf/bin/asdf`;
  const addPlugin = (name: string) =>
    spawn(`${asdfBin} plugin-add`, name, { ignoredErrors: [2] });

  const addPlugins = pipe(
    ["nodejs", "python", "yarn", "ruby", "haskell"],
    taskEither.traverseSeqArray(addPlugin),
    taskEither.map(constVoid)
  );

  const asdfInstall = spawn(`${asdfBin} install`);

  return pipe(
    [addPlugins, asdfInstall],
    taskEither.sequenceSeqArray,
    taskEither.map(constVoid)
  );
}

function installVimPlug({ forceReinstall, homePath, spawn }: Options) {
  const filePath = `${homePath}/.vim/autoload/plug.vim`;
  const downloadPlug = pipe(
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
    TEfetchText,
    taskEither.chainFirst((file) =>
      fromThunk(() =>
        rm(filePath, { recursive: true, force: true })
          .then(() => mkdir(filePath, { recursive: true }))
          .then(() => writeFile(filePath, file))
      )
    ),
    taskEither.map(constVoid)
  );

  const installPlugPlugins = spawn("vim", "+'PlugInstall --sync' +qa");

  if (!isAccessible(filePath) || forceReinstall) {
    return taskEither.right<Error, void>(undefined);
  }
  return pipe(
    [downloadPlug, installPlugPlugins],
    taskEither.sequenceArray,
    taskEither.map(constVoid)
  );
}

/**
 * MAIN
 **/

const logError = (name: string) => (error: Error) => {
  console.error(`${name} installation failed: ${error.toString()}`);
};

const runTasks = async (options: Options) => {
  const tasks = apply.sequenceS(task.ApplicativePar)({
    homeBrew: installHomebrew(options),
    scripts: installScripts(options),
    vimPlug: installVimPlug(options),
    cloned: clonePackages(options),
  });

  pipe(
    await tasks(),
    record.toEntries,
    array.map(([name]) => either.getOrElse(logError(name)))
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
