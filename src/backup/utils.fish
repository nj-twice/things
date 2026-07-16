set -g style_set_bold "\033[1m"
set -g style_set_normal "\033[0m"

set -g BLOCK_DEVICE sdb1

function print-info
    echo -ne "$style_set_bold""[INFO] "$argv"$style_set_normal\n"
end

function raise-error
    set_color red & echo -e "$style_set_bold""[ERROR] $argv"
    set_color white
    exit 1
end

function check-commands
    command -q borg
    and command -q fd
    and command -q rg
    and command -q busctl
    and command -q jq
end

function get-partition-uuid
    set result (busctl --json=short call org.freedesktop.UDisks2 /org/freedesktop/UDisks2/block_devices/$BLOCK_DEVICE org.freedesktop.DBus.Properties Get ss "org.freedesktop.UDisks2.Partition" UUID)
    or exit $status
    echo $result | jq ".data.[0].data" | string trim -c '"'
end
