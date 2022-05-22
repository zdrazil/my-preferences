#!/usr/bin/env -S deno run --allow-net --allow-run --allow-read --allow-env --allow-write

import { array } from "https://deno.land/x/fp_ts@v2.11.4/index.ts";
import { pipe } from "https://deno.land/x/fp_ts@v2.11.4/function.ts";
import { writableStreamFromWriter } from "https://deno.land/std@0.140.0/streams/mod.ts";
import { emptyDir } from "https://deno.land/std/fs/mod.ts";

const homePath = Deno.env.get("HOME");
const binHome = homePath + "/.local/bin";
const configHome = homePath + "/.config";
const isMac = Deno.build.os === "darwin";

await Promise.all([
  installHomebrew(),
  // installScripts(),
  // installVimPlug(),
  // clonePackages(),
]);

async function installHomebrew() {
  console.log("Checking if Homebrew is already installed...");
  const status = await Deno.run({
    cmd: ["command", "-v", "brew"],
    stdout: "null",
    stderr: "null",
  })
    .status();

  if (status.success) {
    console.log("Brew is already installed. Skipping installation...");
  } else {
    console.log("Installing Homebrew...");
    await fetch(
      "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh",
    )
      .then((res) => res.text())
      .then((text) => Deno.run({ cmd: ["/bin/bash", "-c", text] }).status());
  }

  if (isMac) {
    const brewPackages = "bash coreutils findutils gnu-sed tmux yadm zsh tmux";

    console.log(`Installing ${brewPackages}...`);
    await Deno.run({
      cmd: ["brew", "install", brewPackages],
    }).status();

    console.log(`Installing brew bundle packages...`);
    await Deno.run({
      cmd: [
        "brew",
        "bundle",
        "--verbose",
        "--file",
        configHome + "/packages/Brewfile",
      ],
    }).status();
  }
}

async function installScripts() {
  await pipe(
    [
      { "name": "chtsh", url: "https://cht.sh/:cht.sh" },
      {
        name: "theme-sh",
        url:
          "https://raw.githubusercontent.com/lemnos/theme.sh/master/bin/theme.sh",
      },
    ],
    array.map(async ({ url, name }: { url: string; name: string }) => {
      console.log(`Installing ${name}...`);

      const filePath = `${binHome}/${name}`;
      await downloadFile({ url, filePath });
      await Deno.chmod(filePath, 0o755);
    }),
    (p) => Promise.all(p),
  );
}

async function clonePackages() {
  await pipe(
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
        args: [
          "--branch",
          "v0.10.0",
          "https://github.com/asdf-vm/asdf.git",
        ],
      },
    ],
    array.map(async ({ path, args }) => {
      console.log("Cloning " + path + "...");
      const fullPath = `${homePath}${path}`;
      await emptyDir(fullPath);
      await Deno.run({ cmd: ["git", "clone", ...args, fullPath] }).status();
    }),
    async (p) => {
      await Promise.all(p);
      console.log("Cloning complete. Configuring cloned packages...");
      await Promise.all([
        configureAsdf(),
        Deno.run({
          cmd: [
            homePath + "/.fzf/install",
            "--key-bindings",
            "--completion",
            "--no-update-rc",
          ],
        }).status(),
      ]);
    },
  );
}

async function configureAsdf() {
  console.log("Configuring asdf...");

  const asdfBin = homePath + "/.asdf/bin/asdf";
  await pipe(
    ["nodejs", "python", "yarn", "ruby", "haskell"],
    async (names) => {
      for (const name of names) {
        console.log(`Configuring asdf ${name}...`);
        await Deno.run({ cmd: [asdfBin, "plugin-add", name] }).status();
      }
      await Deno.run({ cmd: [asdfBin, "install"] }).status();
    },
  );
}

async function installVimPlug() {
  console.log("Installing vim-plug...");
  console.error(homePath);
  await downloadFile({
    url: "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
    filePath: homePath + "/.vim/autoload/plug.vim",
  });

  await Deno.run({
    cmd: [
      "vim",
      "-es",
      "-u",
      ".vimrc",
      "-i",
      "NONE",
      "-c",
      "PlugInstall",
      "-c",
      "qa",
    ],
  }).status();
}

/*  Change to the new shell
 *  echo "Set zsh as default shell"
 *  sudo sh -c "echo "$(brew --prefix)/bin/zsh" >>/etc/shells"
 *  chsh -s $(brew --prefix)/bin/bash
 */

// Utility functions

async function downloadFile(
  { url, filePath }: { url: string; filePath: string },
) {
  const fileResponse = await fetch(url);

  if (fileResponse.body != null) {
    const file = await Deno.open(filePath, {
      write: true,
      create: true,
    });
    const writableStream = writableStreamFromWriter(file);
    await fileResponse.body.pipeTo(writableStream);
  }
}
