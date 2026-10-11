# Imports
source (path resolve (status dirname))/utils.fish
# ---------

assert-commands borg busctl jq
assert-envvars BORG_PASSPHRASE NJ_BACKUP_BLOCK_DEVICE NJ_BACKUP_PARTITION_UUID NJ_BACKUP_FILTER_FILE
assert-files $NJ_BACKUP_FILTER_FILE

set partition_uuid (get-partition-uuid)
if test "$partition_uuid" != "$NJ_BACKUP_PARTITION_UUID"
    raise-error "Configured partition UUID (\"$NJ_BACKUP_PARTITION_UUID\") for /dev/$NJ_BACKUP_BLOCK_DEVICE doesn't match the one found (\"$partition_uuid\")"
end

# Mount the drive and get the mount point

set mount_point (busctl --json=short call org.freedesktop.UDisks2 /org/freedesktop/UDisks2/block_devices/$NJ_BACKUP_BLOCK_DEVICE org.freedesktop.UDisks2.Filesystem Mount 'a{sv}' 0 | jq '.data.[0]' | string trim -c '"')

if test -z $mount_point
    raise-error "Error while mounting. You may need to unmount manually."
end

print-info "Drive mounted"

# Do Borg backup

set --export BORG_REPO $mount_point/backup

set archive_name (date +%s)

print-info "Starting Borg backup"

borg create \
    # --dry-run \
    --stats \
    --list \
    --filter AMCE \
    --progress \
    --exclude-caches \
    ::$archive_name --patterns-from "$NJ_BACKUP_FILTER_FILE"

# Save the status for later

set borg_status $status

# First, unconditionally unmount

unmount-drive

# Did the backup succeed?

if test $borg_status -ne 0
    raise-error "Borg backup failed"
end

print-info "Borg backup succeeded!"
