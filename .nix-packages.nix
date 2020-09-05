let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) buildEnv;

in buildEnv {
  name = "user-tools";
  paths = [ 
    # "pkgs.glibc-locales"
    pkgs.ack
    pkgs.autojump
    pkgs.bash
    pkgs.bash-completion
    pkgs.coreutils
    pkgs.ctags
    pkgs.dos2unix
    pkgs.exercism
    pkgs.fd
    pkgs.findutils
    pkgs.fish
    pkgs.fzf
    pkgs.gawk
    pkgs.gifski
    pkgs.git
    pkgs.gnugrep
    pkgs.gnused
    pkgs.graphviz
    pkgs.htop
    pkgs.jq
    pkgs.leiningen
    pkgs.moreutils
    pkgs.mpv
    pkgs.ncdu
    pkgs.nodejs-12_x
    pkgs.p7zip
    pkgs.pwgen
    pkgs.python
    pkgs.python38Packages.wakeonlan
    pkgs.ranger
    pkgs.readline
    pkgs.ripgrep
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.silver-searcher
    pkgs.speedtest-cli
    pkgs.stack
    pkgs.tig
    pkgs.tldr
    pkgs.tmux
    pkgs.trash-cli
    # pkgs.vimHugeX
    pkgs.watch
    pkgs.watchman
    pkgs.wget
    pkgs.xz
    pkgs.yarn
    pkgs.youtube-dl
    pkgs.zsh
    pkgs.zsh-completions
    ];
}

