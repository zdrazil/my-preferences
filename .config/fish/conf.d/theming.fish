# Don't use change-theme, it takes longer to execute
switch (uname)
    case Darwin
        set --local is_dark (osascript -e 'tell application "System Events" to get dark mode of appearance preferences')

        if test "$is_dark" = true
            set -gx BACKGROUND_THEME dark
        else
            set -gx BACKGROUND_THEME light
        end
end

# theme-sh adds around 25 ms startup delay, on the other hand it's universal for all modern terminals, so for now it's worth it.
# We mitigate the problem by running it in the background with `&`.
if command -v theme-sh >/dev/null
    switch $BACKGROUND_THEME
        case light
            theme-sh cupertino &
        case '*'
            switch (hostname)
                case M-CXR99QW0TP
                    theme-sh solarized-dark &
                case '*'
                    theme-sh oceanic-next &
            end
    end
end
