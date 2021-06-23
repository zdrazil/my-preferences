# nix-env -i -f "$HOME/.config/packages/nix-packages.nix"
let
  pkgs = import <nixpkgs> {};
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
  linuxPkgs = [
    pkgs.clojure-lsp
    # pkgs.fish
    # pkgs.git
    pkgs.mpv
    pkgs.thefuck
    pkgs.termpdfpy
    # "pkgs.glibc-locales"
  ];
  darwinPkgs = [
    # pkgs.bash
    # pkgs.bash-completion
    # pkgs.coreutils
    pkgs.elinks
    pkgs.gawk
    # pkgs.gnugrep
    # pkgs.gnused
    pkgs.ranger
    pkgs.readline
    # pkgs.zsh
  ];
  genericPkgs = [
    pkgs.ack
    pkgs.bat
    pkgs.curl
    unstable.dasht
    pkgs.direnv
    pkgs.dos2unix
    pkgs.entr
    pkgs.ffmpeg
    pkgs.fd
    pkgs.findutils
    pkgs.fzf
    pkgs.gifski
    pkgs.gitAndTools.delta
    pkgs.graphviz
    pkgs.gron
    pkgs.gnupg
    pkgs.highlight
    pkgs.htop
    pkgs.imagemagick
    pkgs.jq
    pkgs.leiningen
    pkgs.lorri
    pkgs.moreutils
    pkgs.mosh
    pkgs.ncdu
    pkgs.nodejs-14_x
    pkgs.nodePackages.eslint_d
    pkgs.nodePackages.prettier
    pkgs.perl
    pkgs.p7zip
    pkgs.pandoc
    pkgs.pwgen
    pkgs.python3
    pkgs.ripgrep
    pkgs.rlwrap
    pkgs.shellcheck
    pkgs.shfmt
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
    pkgs.yarn
    pkgs.fx
    pkgs.nodePackages.fixjson
    unstable.youtube-dl
    pkgs.git-extras
    pkgs.haskellPackages.hoogle
    # Fun
    pkgs.cmatrix
    pkgs.cowsay
    pkgs.doge
    pkgs.figlet
    pkgs.fortune
    pkgs.gti
    pkgs.lolcat
    pkgs.nyancat
    pkgs.sl
    pkgs.mdcat
    pkgs.nnn
    pkgs.timg
  ];
  allLinuxPkgs = genericPkgs ++ linuxPkgs;
  allDarwinPkgs = genericPkgs ++ darwinPkgs;
  inherit (pkgs) buildEnv;

in buildEnv {
  name = "user-tools";
  paths = if pkgs.stdenv.isDarwin then allDarwinPkgs else allLinuxPkgs;
}

