set -g style_set_bold "\033[1m"
set -g style_set_normal "\033[0m"

function print-info
    echo -ne "$style_set_bold""[INFO] "$argv"$style_set_normal\n"
end

function print-warning
    set_color yellow & echo -ne $style_set_bold"[WARN] $argv\n"
    set_color --reset white
end

function print-hint
    set_color brgreen & echo -ne $style_set_bold"[HINT] $argv\n"
    set_color --reset white
end

function raise-error
    set_color red & echo -e "$style_set_bold""[ERROR] $argv"
    set_color --reset white
    exit 1
end
