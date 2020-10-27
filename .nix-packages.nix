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
    pkgs.ack
    pkgs.autojump
    pkgs.browsh
    pkgs.coreutils
    # pkgs.clojure-lsp
    pkgs.ddgr
    pkgs.dos2unix
    pkgs.entr
    pkgs.exercism
    pkgs.fd
    pkgs.findutils
    pkgs.fzf
    pkgs.gawk
    pkgs.gifski
    pkgs.git-quick-stats
    pkgs.gitAndTools.git-extras
    pkgs.gitAndTools.git-fame
    pkgs.gitAndTools.git-open
    pkgs.gitAndTools.delta
    pkgs.gnugrep
    pkgs.gnused
    pkgs.graphviz
    pkgs.gron
    pkgs.highlight
    pkgs.htop
    pkgs.jq
    # pkgs.languagetool
    pkgs.leiningen
    pkgs.moreutils
    pkgs.mpv
    pkgs.ncdu
    pkgs.p7zip
    pkgs.pandoc
    pkgs.pwgen
    pkgs.python
    # pkgs.python38Packages.wakeonlan
    pkgs.ranger
    pkgs.readline
    pkgs.ripgrep
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.silver-searcher
    pkgs.speedtest-cli
    pkgs.tldr
    pkgs.tig
    pkgs.tmux
    pkgs.trash-cli
    pkgs.tree
    pkgs.universal-ctags
    pkgs.up
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

