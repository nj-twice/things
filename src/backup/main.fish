# Imports
source utils.fish

if not check-commands
    raise-error "Some commands are not in \$PATH"
end

print-info "All commands were found"

# Try to unmount in case the last run didn't end gracefully
# e.g. force stopped/killed
#### set mount_dir $HOME/mnt/borg_backup
#### fusermount -u $mount_dir

# First, collect all dirs in $HOME (inclduing hidden) and assign a handler
# If the dir has .stfolder dir, handler=st
# If it has nothing
# - traverse to find a sub ST dir
# - if one dir has an ST subdir, assign handler=st and exclude it from the next operations
# - if it's the ~/repos dir, we use the special script
# - for all dirs without handlers, we assign handler=borg

# Handle Syncthing
# use `syncthing cli` to get status + operations
# Assert: no ignores + minimal versioning enabled + reports as synced

# Handle git

# Handle borg
# Test:
# - the drive is reachable
# - it's the UUID we defined in an env variable
# If not, do not error, warn that directories for borg will not be saved
# Use busctl (better than dbus-send)

set partition_uuid (get-partition-uuid)

if test "$partition_uuid" != "$NJ_BACKUP_PARTITION_UUID"
    raise-error "Configured partition UUID (\"$NJ_BACKUP_PARTITION_UUID\") for /dev/$BLOCK_DEVICE doesn't match the one found (\"$partition_uuid\")"
end
