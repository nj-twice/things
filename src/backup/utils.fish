set -g style_set_bold "\033[1m"
set -g style_set_normal "\033[0m"

function print-info
    echo -ne "$style_set_bold""[INFO] "$argv"$style_set_normal\n"
end

function print-error
    set_color red & echo -e "$style_set_bold""[ERROR] $argv"
    set_color white
end

function check-commands
    command -q borg &&
        command -q fd &&
        command -q rg
end
