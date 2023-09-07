# Don't use change-theme, it takes longer to execute
switch (uname)
    case Darwin
        set --local color_theme (defaults read -g AppleInterfaceStyle 2>/dev/null)

        if test "$color_theme" != Dark
            set -gx BACKGROUND_THEME light
        else
            set -gx BACKGROUND_THEME dark
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
                case '*Mews*'
                    theme-sh solarized-dark &
                case '*'
                    theme-sh oceanic-next &
            end
    end
end
