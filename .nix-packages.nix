let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) buildEnv;

in buildEnv {
  name = "user-tools";
  paths = [ 
    # "pkgs.glibc-locales"
    # pkgs.bash
    # pkgs.bash-completion
    # pkgs.ctags
    # pkgs.git
    # pkgs.nodejs-12_x
    # pkgs.vimHugeX
    # pkgs.yarn
    # pkgs.zsh
    # pkgs.zsh-completions
    pkgs.ddgr
    pkgs.ack
    pkgs.up
    pkgs.entr
    pkgs.highlight
    pkgs.autojump
    pkgs.pandoc
    pkgs.browsh
    pkgs.coreutils
    pkgs.dos2unix
    pkgs.exercism
    pkgs.fd
    pkgs.findutils
    pkgs.fish
    pkgs.fzf
    pkgs.gawk
    pkgs.gifski
    pkgs.git-quick-stats
    pkgs.gitAndTools.git-extras
    pkgs.gitAndTools.git-fame
    pkgs.gitAndTools.git-open
    pkgs.gnugrep
    pkgs.gnused
    pkgs.graphviz
    pkgs.htop
    pkgs.jq
    pkgs.leiningen
    pkgs.moreutils
    pkgs.mpv
    pkgs.ncdu
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
    pkgs.tree
    pkgs.universal-ctags
    pkgs.w3m
    pkgs.watch
    pkgs.watchman
    pkgs.wget
    pkgs.xz
    pkgs.youtube-dl
    # Fun
    pkgs.bb
    pkgs.cmatrix
    pkgs.cowsay
    pkgs.doge
    pkgs.figlet
    pkgs.fortune
    pkgs.gti
    pkgs.lolcat
    pkgs.nyancat
    pkgs.sl
    pkgs.thefuck
    ];
}

