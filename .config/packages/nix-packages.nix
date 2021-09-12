# nix-env -i -f "$HOME/.config/packages/nix-packages.nix"
let
  pkgs = import <nixpkgs> {};
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
  linuxPkgs = [
    # pkgs.bat
    # pkgs.clojure-lsp
    # pkgs.elinks
    # pkgs.fx
    # pkgs.gh
    # pkgs.ripgrep
    # pkgs.shfmt
    # pkgs.starship
    # pkgs.termpdfpy
    # pkgs.thefuck
    # pkgs.vim-vint
  ];
  darwinPkgs = [
    # pkgs.ack
    # pkgs.curl
    # pkgs.dos2unix
    # pkgs.fzf
    # pkgs.gawk
    # pkgs.git-extras
    # pkgs.gnupg
    # pkgs.graphviz
    # pkgs.gron
    # pkgs.highlight
    # pkgs.htop
    # pkgs.imagemagick
    # pkgs.jq
    # pkgs.leiningen
    # pkgs.moreutils
    # pkgs.mosh
    # pkgs.ncdu
    # pkgs.nodePackages.prettier
    # pkgs.nodejs-14_x
    # pkgs.p7zip
    # pkgs.pandoc
    # pkgs.perl
    # pkgs.pwgen
    # pkgs.python3
    # pkgs.ranger
    # pkgs.readline
    # pkgs.rlwrap
    # pkgs.shellcheck
    # pkgs.silver-searcher
    # pkgs.speedtest-cli
    # pkgs.stack
    # pkgs.tig
    # pkgs.tldr
    # pkgs.trash-cli
    # pkgs.tree
    # pkgs.universal-ctags
    # pkgs.up
    # pkgs.w3m
    # pkgs.watch
    # pkgs.watchman
    # pkgs.wget
    # unstable.dasht
    # Fun
    # pkgs.doge
    # pkgs.gti
    # pkgs.lolcat
    # pkgs.nyancat
  ];
  genericPkgs = [
    # pkgs.direnv
    # pkgs.flavours
    # pkgs.gifski
    # pkgs.haskellPackages.hoogle
    # pkgs.nix-direnv
    # pkgs.nodePackages.eslint_d
    # pkgs.nodePackages.fixjson
    # unstable.youtube-dl
  ];
  allLinuxPkgs = genericPkgs ++ linuxPkgs;
  allDarwinPkgs = genericPkgs ++ darwinPkgs;
  inherit (pkgs) buildEnv;

in buildEnv {
  name = "user-tools";
  paths = if pkgs.stdenv.isDarwin then allDarwinPkgs else allLinuxPkgs;
}

