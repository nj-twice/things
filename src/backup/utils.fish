source (path resolve (status dirname))/../commons/utils.fish

set -g NJ_BACKUP_BLOCK_DEVICE sdb1
set -g NJ_BACKUP_FILTER_FILE "$HOME/.config/borg/backup_patterns.filter"

function check-commands
    command -q borg
    and command -q busctl
    and command -q jq
end

function get-partition-uuid
    set result (busctl --json=short call org.freedesktop.UDisks2 /org/freedesktop/UDisks2/block_devices/$NJ_BACKUP_BLOCK_DEVICE org.freedesktop.DBus.Properties Get ss "org.freedesktop.UDisks2.Partition" UUID)
    or exit $status
    echo $result | jq ".data.[0].data" | string trim -c '"'
end

function unmount-drive
    busctl --json=short call org.freedesktop.UDisks2 /org/freedesktop/UDisks2/block_devices/$NJ_BACKUP_BLOCK_DEVICE org.freedesktop.UDisks2.Filesystem Unmount 'a{sv}' 0
end

function backup-interrupted --on-signal SIGINT
    unmount-drive
    raise-error "Process interrupted. Drive unmounted."
end
