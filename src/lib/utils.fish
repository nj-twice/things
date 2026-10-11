function assert-commands
    for cmd in $argv
        if not command -q $cmd
            raise-error "Some commands (e.g. $cmd) are not in \$PATH."
        end
    end
    print-info "All commands were found."
end

function assert-envvars
    for varname in $argv
        if test -z $$varname
            raise-error "Some environment variables (e.g. \$$varname) are underfined or empty."
        end
    end
    print-info "All environment variables are defined."
end

function assert-files
    for file in $argv
        if test ! -e $file
            raise-error "Some files (e.g. $file) don't exist."
        end
    end
    print-info "All files were found."
end

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
