let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) buildEnv;

in buildEnv {
  name = "user-tools";
  paths = [ 
    pkgs.autojump
    pkgs.ctags
    pkgs.fd
    pkgs.fzf
    pkgs.git
    pkgs.htop
    pkgs.jq
    pkgs.leiningen
    pkgs.mpv
    pkgs.ncdu
    pkgs.ranger
    pkgs.ripgrep
    pkgs.shfmt
    pkgs.silver-searcher
    pkgs.speedtest-cli
    pkgs.tig
    pkgs.tldr
    pkgs.tmux
    pkgs.watch
    pkgs.vimHugeX
    pkgs.youtube-dl
    pkgs.stack
    ];
}
