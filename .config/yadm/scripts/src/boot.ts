#!/usr/bin/env ts-node
import os from "os";
import fsPromise from "fs/promises";
import fs from "fs";
import child_process, { ExecException } from "child_process";
import { promisify } from "util";
import fetch from "node-fetch";
import { pipe } from "fp-ts/lib/function.js";
import { array } from "fp-ts";
import yargs from "yargs";
import { hideBin } from "yargs/helpers";

const exec = promisify(child_process.exec);

const isMac = process.platform === "darwin";
const homePath = os.homedir();
const configPath = `${homePath}/.config/`;
const binHomePath = `${homePath}/.local/bin`;

if (!fs.existsSync(configPath)) fs.mkdirSync(configPath);
if (!fs.existsSync(binHomePath)) fs.mkdirSync(binHomePath);

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

main();

async function installHomebrew() {
  try {
    await exec("command -v brew");
    console.log("Homebrew already installed. Skipping installation...");
  } catch (e) {
    try {
      console.log("Installing Homebrew...");
      const brewScript = await fetch(
        "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
      ).then((res) => res.text());
      await exec(`sudo bash ${brewScript}`);
    } catch (e) {
      console.log(e.stderr);
      return;
    }
  }

  try {
    if (isMac) {
      console.log("Installing core Homebrew packages...");
      await exec(
        "brew install bash coreutils findutils gnu-sed tmux yadm zsh tmux"
      );
      console.log("Installing and updating rest of the homebrew packages...");
      await exec(
        `brew bundle --verbose --file "${configPath}/packages/Brewfile"`
      );
    }
  } catch (e) {
    console.log("Homebrew installation failed.");
    console.log(e.stderr);
    return;
  }
}

async function installScripts() {
  return pipe(
    [
      { name: "chtsh", url: "https://cht.sh/:cht.sh" },
      {
        name: "theme-sh",
        url: "https://raw.githubusercontent.com/lemnos/theme.sh/master/bin/theme.sh",
      },
    ],
    array.map(async ({ name, url }) => {
      const filePath = `${binHomePath}/${name}`;
      if (fs.existsSync(filePath) || !shouldReinstall) {
        console.log(`${name} already installed. Skipping installation...`);
        return;
      }
      try {
        console.log(`Installing ${name}...`);
        const file = await fetch(url).then((res) => res.text());
        fs.rmSync(filePath, { recursive: true, force: true });
        fs.writeFileSync(filePath, file);
        await fsPromise.chmod(filePath, 0o755);
      } catch (e) {
        console.log(e.stderr);
      }
    }),
    (p) => Promise.all(p)
  );
}

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
