# Imports
source utils.fish
# ---------

if not check-commands
    raise-error "Some commands are not in \$PATH"
end

print-info "All commands were found"

set partition_uuid (get-partition-uuid)

# Checks

if test "$partition_uuid" != "$NJ_BACKUP_PARTITION_UUID"
    raise-error "Configured partition UUID (\"$NJ_BACKUP_PARTITION_UUID\") for /dev/$BLOCK_DEVICE doesn't match the one found (\"$partition_uuid\")"
end

if test -z $FILTER_FILE
    print-error "\$FILTER_FILE undefined!"
end
if test ! -e $FILTER_FILE
    print-error "The file $FILTER_FILE doesn't exist"
end

# Mount the drive and get the mount point

set mount_point (busctl --json=short call org.freedesktop.UDisks2 /org/freedesktop/UDisks2/block_devices/$BLOCK_DEVICE org.freedesktop.UDisks2.Filesystem Mount 'a{sv}' 0 | jq '.data.[0]' | string trim -c '"')

if test -z $mount_point
    raise-error "Error while mounting. You may need to unmount manually."
end

# Do Borg backup

set --export BORG_REPO $mount_point/backup
set --export BORG_PASSPHRASE "..."

set archive_name (date +%s)

print-info "Starting Borg backup"

borg create \
    --dry-run \
    --stats \
    --list \
    --filter AMCE \
    --progress \
    --exclude-caches \
    ::$archive_name --patterns-from "$FILTER_FILE"

# Save the status for later

set borg_status $status

# First, unconditionally unmount

busctl --json=short call org.freedesktop.UDisks2 /org/freedesktop/UDisks2/block_devices/$BLOCK_DEVICE org.freedesktop.UDisks2.Filesystem Unmount 'a{sv}' 0

# Did the backup succeed?

if test $borg_status -ne 0
    raise-error "Borg backup failed"
end

print-info "Borg backup succeeded!"
