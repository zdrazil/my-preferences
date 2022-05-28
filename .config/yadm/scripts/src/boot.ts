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

const exec = promisify(child_process.exec);

const homePath = os.homedir();
const configPath = `${homePath}/.config/`;
const binHomePath = `${homePath}/.local/bin`;

const createDirs = pipe(
  [configPath, binHomePath],
  array.map((dirPath: string) =>
    taskEither.tryCatch(
      () => access(dirPath).catch(() => mkdir(dirPath)),
      (e) => e as NodeJS.ErrnoException
    )
  )
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
  await Promise.all([
    // installHomebrew(),
    // installScripts(),
    // installVimPlug(),
    // clonePackages(),
  ]);
}

void main();

const installHomebrew = pipe(
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

const installScripts = pipe(
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
            ]).then(([script]) => writeFile(filePath, script, { mode: 0o755 })),
          (e) => e as Error | ExecException | NodeJS.ErrnoException
        )
      ),
      taskEither.flatten
    );
  })
);

function clonePackages() {
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
    array.map(async ({ path, args }) => {
      console.log(`Cloning ${path}...`);
      const fullPath = `${homePath}${path}`;
      fs.rmSync(fullPath, { recursive: true, force: true });
      await exec(`git clone ${args.join(" ")} ${fullPath}`);
    }),
    async (p) => {
      await Promise.all(p);
      console.log("Cloning complete. Configuring cloned packages...");
      await Promise.all([
        configureAsdf(),
        exec(
          `${homePath}/.fzf/install --key-bindings --completion --no-update-rc`
        ),
      ]);
    }
  );
}

async function configureAsdf() {
  console.log("Configuring asdf...");
  const asdfBin = `${homePath}/.asdf/bin/asdf`;
  return pipe(
    ["nodejs", "python", "yarn", "ruby", "haskell"],
    array.map(async (names) => {
      for (const name of names) {
        console.log(`Configuring asdf ${name}...`);
        await exec(`${asdfBin} plugin-add ${name}`);
      }
      await exec(`${asdfBin} install}`);
    })
  );
}

async function installVimPlug() {
  console.log("Installing vim-plug...");

  const filePath = `${homePath}/.vim/autoload/plug.vim`;
  const file = await fetch(
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  ).then((res) => res.text());
  try {
    fs.rmSync(filePath, { force: true });
    fs.writeFileSync(filePath, file);
  } catch (e) {
    console.log(e?.stderr);
  }

  await exec('vim -es -u .vimrc -i NONE -c "PlugInstall" -c "qa"');
}
