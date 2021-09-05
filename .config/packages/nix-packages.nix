# nix-env -i -f "$HOME/.config/packages/nix-packages.nix"
let
  pkgs = import <nixpkgs> {};
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
  linuxPkgs = [
    pkgs.clojure-lsp
    pkgs.thefuck
    pkgs.termpdfpy
    pkgs.starship
    pkgs.elinks
  ];
  darwinPkgs = [
    pkgs.ack
    pkgs.curl
    pkgs.dos2unix
    pkgs.entr
    pkgs.ffmpeg
    pkgs.findutils
    pkgs.fzf
    pkgs.gawk
    pkgs.git-extras
    pkgs.gnupg
    pkgs.graphviz
    pkgs.gron
    pkgs.highlight
    pkgs.htop
    pkgs.imagemagick
    pkgs.jq
    pkgs.leiningen
    pkgs.moreutils
    pkgs.mosh
    pkgs.ncdu
    pkgs.nodePackages.prettier
    pkgs.nodejs-14_x
    pkgs.p7zip
    pkgs.pandoc
    pkgs.perl
    pkgs.pwgen
    pkgs.python3
    pkgs.ranger
    pkgs.readline
    pkgs.rlwrap
    pkgs.shellcheck
    pkgs.silver-searcher
    pkgs.speedtest-cli
    pkgs.stack
    pkgs.tig
    pkgs.tldr
    pkgs.tmux
    pkgs.trash-cli
    pkgs.tree
    pkgs.universal-ctags
    pkgs.up
    pkgs.w3m
    pkgs.watch
    pkgs.watchman
    pkgs.wget
    unstable.dasht
    # Fun
    pkgs.cmatrix
    pkgs.cowsay
    pkgs.doge
    pkgs.figlet
    pkgs.fortune
    pkgs.lolcat
    pkgs.nyancat
    pkgs.mdcat
    pkgs.nnn
    pkgs.timg
  ];
  genericPkgs = [
    pkgs.bat
    pkgs.direnv
    pkgs.fd
    pkgs.flavours
    pkgs.fx
    pkgs.gh
    pkgs.gifski
    pkgs.gitAndTools.delta
    pkgs.haskellPackages.hoogle
    pkgs.nix-direnv
    pkgs.nodePackages.eslint_d
    pkgs.nodePackages.fixjson
    pkgs.ripgrep
    pkgs.shfmt
    unstable.youtube-dl
    # Fun
    pkgs.gti
    pkgs.sl
  ];
  allLinuxPkgs = genericPkgs ++ linuxPkgs;
  allDarwinPkgs = genericPkgs ++ darwinPkgs;
  inherit (pkgs) buildEnv;

in buildEnv {
  name = "user-tools";
  paths = if pkgs.stdenv.isDarwin then allDarwinPkgs else allLinuxPkgs;
}

