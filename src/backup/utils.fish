source (path resolve (status dirname))/../lib/utils.fish

function get-partition-uuid
    set result (busctl --json=short call org.freedesktop.UDisks2 /org/freedesktop/UDisks2/block_devices/$THINGS_BACKUP_BLOCK_DEVICE org.freedesktop.DBus.Properties Get ss "org.freedesktop.UDisks2.Partition" UUID)
    or exit $status
    echo $result | jq ".data.[0].data" | string trim -c '"'
end

function unmount-drive
    busctl --json=short call org.freedesktop.UDisks2 /org/freedesktop/UDisks2/block_devices/$THINGS_BACKUP_BLOCK_DEVICE org.freedesktop.UDisks2.Filesystem Unmount 'a{sv}' 0
end

function backup-interrupted --on-signal SIGINT
    unmount-drive
    raise-error "Process interrupted. Drive unmounted."
end
