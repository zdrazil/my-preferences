switch (hostname)
    case Vladimirs-Mews-MacBook-Pro.local
        set -gx MY_THEME solarized-dark
    case VladimisMewsMBP
        set -gx MY_THEME solarized-dark
    case '*'
        set -gx MY_THEME oceanic-next
end

set -gx MY_LIGHT_THEME cupertino
set -gx BACKGROUND_THEME (change-theme)
set -gx BAT_THEME ansi
