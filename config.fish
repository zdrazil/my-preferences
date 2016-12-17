set -xg PATH /opt/local/bin /opt/local/sbin ~/bin /Users/zdrazil/Library/Python/2.7/bin/ /Users/zdrazil/.gem/ruby/2.0.0/bin $PATH

alias sshmacmini='ssh zdraz@Mac-mini.local'
alias sshmacbookpro='ssh zdrazil@macbook-pro.local'
alias sshimac='ssh zdrazil@imac.local'

alias vncwindows='wakeonlan d8:cb:8a:e4:01:dd; and open vnc://windows-pc.local:36154'
alias vncmacmini='open vnc://Mac-mini.local'
alias vncmacbookpro='open vnc://macbook-pro.local'
alias vncimac='open vnc://imac.local'
alias vnclocal='open vnc://localhost:5901'
alias firefox-cmd='nohup /Applications/Firefox.app/Contents/MacOS/firefox-bin
-profile CommandLine --no-remote >/dev/null &'

alias brewgrade='brew update; and brew upgrade'

alias wolwindows='wakeonlan d8:cb:8a:e4:01:dd'

alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

alias subl='open -a "Sublime Text"'

# open man-page(s) in its own window. Use: "manx" instead of "man" (OS X)
function manx
    open x-man-page://$argv
end
