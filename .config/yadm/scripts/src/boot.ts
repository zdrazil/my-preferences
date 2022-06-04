#!/usr/bin/env ts-node
import child_process, { ChildProcess } from "child_process";
import { apply, array, either, option, task, taskEither } from "fp-ts";
import { constVoid, flow, identity, Lazy, pipe } from "fp-ts/function";
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

const execSync = promisify(child_process.execSync);

interface Options {
  forceReinstall: boolean;
}

const workers: ChildProcess[] = [];
const killWorkers = () =>
  workers.forEach((worker) => (worker.pid ? process.kill(worker.pid) : null));

process.on("uncaughtException", killWorkers);
process.on("SIGINT", killWorkers);
process.on("SIGTERM", killWorkers);

interface SpawnOptions {
  ignoredErrors?: number[];
}

const spawn = (cmd: string, args?: string, options?: SpawnOptions) =>
  new Promise<void>((resolve, reject) => {
    const command = child_process.spawn(cmd + (args ? ` ${args}` : ""), [], {
      shell: true,
    });
    workers.push(command);

    command.stdout.on("data", (data: Buffer) => {
      console.log(cmd);
      console.log(data.toString());
    });

    command.stderr.on("data", (data: Buffer) => {
      console.error(cmd);
      console.error(data.toString());
    });

    const ignoredErrors: Array<number | null> = options?.ignoredErrors || [];
    command.on("close", (code = 0) => {
      if (code !== 0 && !ignoredErrors.includes(code)) {
        console.error(`${cmd} process exited with code ${code ?? "undefined"}`);
        reject(`${cmd} process exited with code ${code ?? "undefined"}`);
      }
      resolve();
    });
  });

const TETryCatch = <A, B extends Lazy<Promise<A>>>(f: B) =>
  taskEither.tryCatch(
    () => f().then(constVoid),
    (e) => e as Error
  );

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

const homePath = os.homedir();
const configPath = `${homePath}/.config/`;
const binHomePath = `${homePath}/.local/bin`;

/**
 * PACKAGERS
 */

function installHomebrew() {
  const brewScriptUrl =
    "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh";

  const install = async () => {
    if (!commandExists("brew")) {
      const brewScript = await fetch(brewScriptUrl).then((res) => res.text());
      await spawn(`sudo bash`, `${brewScript}`);
    }

    if (process.platform === "darwin") {
      await spawn(
        "brew install",
        "bash coreutils findutils gnu-sed tmux yadm zsh tmux"
      );
      await spawn(
        `brew bundle`,
        `--verbose --file "${configPath}/packages/Brewfile"`
      );
    }
  };

  return TETryCatch(install);
}

interface Script {
  url: string;
  fullPath: string;
}

function installScripts({ forceReinstall }: Options) {
  const scripts = [
    { name: "chtsh", url: "https://cht.sh/:cht.sh" },
    {
      name: "theme-sh",
      url: "https://raw.githubusercontent.com/lemnos/theme.sh/master/bin/theme.sh",
    },
  ];

  const installScript = ({ url, fullPath }: Script) =>
    TETryCatch(() =>
      fetch(url)
        .then((res) => res.text())
        .then((script) => writeFile(fullPath, script, { mode: 0o755 }))
    );

  const tasks = pipe(
    scripts,
    array.map((script) => ({
      ...script,
      fullPath: `${binHomePath}/${script.name}`,
    })),
    forceReinstall ? identity : filterNonExisting,
    taskEither.traverseArray(installScript)
  );

  return tasks;
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

  interface Package {
    fullPath: string;
    args: string[];
  }

  const clonePackage = ({ fullPath, args }: Package) =>
    TETryCatch(async () => {
      await rm(fullPath, { recursive: true, force: true });
      await spawn(`git clone`, `${args.join(" ")} ${fullPath}`);
    });

  const cloneAll = pipe(
    packages,
    array.map((appPackage) => ({
      ...appPackage,
      fullPath: `${homePath}${appPackage.path}`,
    })),
    forceReinstall ? identity : filterNonExisting,
    taskEither.traverseArray(flow(clonePackage, TETryCatch))
  );

  const installFzf = TETryCatch(() =>
    spawn(
      `${homePath}/.fzf/install`,
      `--key-bindings --completion --no-update-rc`
    )
  );

  const afterClone = apply.sequenceS(taskEither.ApplicativePar)({
    installFzf,
    configureAsdf: configureAsdf(),
  });

  return apply.sequenceS(taskEither.ApplicativeSeq)({ cloneAll, afterClone });
}

function configureAsdf() {
  const asdfBin = `${homePath}/.asdf/bin/asdf`;
  const addPlugin = (name: string) =>
    TETryCatch(() =>
      spawn(`${asdfBin} plugin-add`, `${name}`, { ignoredErrors: [2] })
    );

  const addPlugins = pipe(
    ["nodejs", "python", "yarn", "ruby", "haskell"],
    taskEither.traverseSeqArray(addPlugin)
  );

  const asdfInstall = TETryCatch(() => spawn(`${asdfBin} install`));

  return apply.sequenceS(taskEither.ApplicativeSeq)({
    addPlugins,
    asdfInstall,
  });
}

function installVimPlug({ forceReinstall }: Options) {
  const filePath = `${homePath}/.vim/autoload/plug.vim`;
  const downloadPlug = TETryCatch(() =>
    fetch("https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
      .then((res) => res.text())
      .then((file) =>
        rm(filePath, { recursive: true, force: true })
          .then(() => mkdir(filePath, { recursive: true }))
          .then(() => writeFile(filePath, file))
      )
  );
  const installPlugPlugins = TETryCatch(() =>
    spawn("vim", "+'PlugInstall --sync' +qa")
  );

  if (!isAccessible(filePath) || forceReinstall) {
    return taskEither.right<Error, void>(undefined);
  }
  return apply.sequenceS(taskEither.ApplicativeSeq)({
    downloadPlug,
    installPlugPlugins,
  });
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

  const tasks = apply.sequenceS(task.ApplicativePar)({
    homeBrew: installHomebrew(),
    scripts: installScripts({ forceReinstall }),
    vimPlug: installVimPlug({ forceReinstall }),
    cloned: clonePackages({ forceReinstall }),
  });
  const results = await tasks();

  const logError = (name: string) => (error: Error) => {
    console.error(`${name} installation failed: ${error.toString()}`);
  };

  pipe(results, ({ homeBrew, scripts, vimPlug, cloned }) => {
    pipe(homeBrew, either.getOrElse(logError("Homebrew")));
    pipe(
      vimPlug,
      either.getOrElse<
        Error,
        { downloadPlug: void; installPlugPlugins: void } | void
      >(logError("vimPlug"))
    );
    pipe(
      scripts,
      either.getOrElse<Error, void | readonly void[]>(logError("scripts"))
    );
    pipe(
      cloned,
      either.getOrElse<
        Error,
        {
          cloneAll: readonly void[];
          afterClone: {
            installFzf: void;
            configureAsdf: { addPlugins: readonly void[]; asdfInstall: void };
          };
        } | void
      >(logError("cloned"))
    );
  });
}
void main();
