function print-info
    echo -ne (set_color -o)"[INFO]"(set_color --reset)" $argv\n"
    set_color --reset
end

function print-warning
    echo -ne (set_color -o yellow)"[WARN]"(set_color --reset yellow)" $argv\n"
    set_color --reset
end

function print-hint
    echo -ne (set_color -o brgreen)"[HINT]"(set_color --reset brgreen)" $argv\n"
    set_color --reset
end

function raise-error
    echo -ne (set_color -o red)"[ERROR]"(set_color --reset red)" $argv\n"
    set_color --reset
    exit 1
end
