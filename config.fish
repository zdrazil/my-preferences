set -xg PATH /usr/local/bin ~/bin $PATH

[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

export HOMEBREW_NO_ANALYTICS=1

# Source config files that are not to be public (API tokens etc.) 
if [ -r ~/.not-public ]
    source ~/.not-public
end

export EDITOR=vim

alias yt-music-download='youtube-dl -x --audio-format m4a --embed-thumbnail --add-metadata'
alias subliminal-download='subliminal download -l cs -f -s -v'
alias iflicks="open -a 'iFlicks 2'"

# Mac Specific Aliases
switch (uname)
case Darwin
    alias suz='su -l zdraz'
    alias mac-lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
    alias mac-restart="osascript -e 'tell app "loginwindow" to «event aevtrrst»'"
    alias mac-sleep='pmset sleepnow'
    alias mac-shutdown="osascript -e 'tell app "loginwindow" to «event aevtrsdn»'"
    alias mac-showFiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
    alias mac-hideFiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"
    alias mac-screensaver='open -a /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'
    alias mac-eject-all="osascript -e 'tell application "Finder" to eject (every disk whose executable is true)'"
    alias mac-battery='pmset -g batt'
    alias mac-preventing-sleep='pmset -g assertions'
    alias mac-mouse-acceleration-disable='defaults write .GlobalPreferences com.apple.mouse.scaling -1'
    alias mac-mouse-acceleration-enable='defaults write .GlobalPreferences com.apple.mouse.scaling 0.875'

    alias vncwindows='wakeonlan d8:cb:8a:e4:01:dd; sleep 2; open vnc://windows-pc.local:36154'
    alias vncmacmini='open vnc://Mac-mini.local'
    alias vncmacbookpro='open vnc://macbook-pro.local'
    alias vncimac='open vnc://imac.local'
    alias vnclocal='open vnc://localhost:5901'
    alias firefox-cmd='nohup /Applications/Firefox.app/Contents/MacOS/firefox-bin
    -profile CommandLine --no-remote >/dev/null &'

    alias brewgrade='brew update; and brew upgrade'

    alias wolwindows='wakeonlan d8:cb:8a:e4:01:dd'

    #    alias subl='open -a "Sublime Text"'
    alias vcode='open -a "Visual Studio Code"'

    # invert colors
    alias mac-invert-colors='osascript -e "tell application \"System Events\"" -e "key code 28 using {control down, option down, command down}" -e "end tell"'

    # open man-page(s) in its own window. Use: "manx" instead of "man" (OS X)

    # open man-page(s) in its own window. Use: "manx" instead of "man" (OS X)
    function manx
        open x-man-page://$argv
    end

    alias zeal='~/Applications/Zeal.app/Contents/MacOS/Zeal'

end
