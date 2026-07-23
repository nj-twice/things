source ../commons/utils.fish

set root_dir $HOME/repos

cd $root_dir

for dir in */
    print-info "Checking $dir"
    builtin cd "$root_dir/$dir"

    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1
        print-warning "Not a git repo, skipping."
        continue
    end

    set current_branch (git branch --show-current)

    if test -z "$current_branch"
        print-warning "Detached HEAD, skipping."
        continue
    end

    if ! git rev-parse --abbrev-ref '@{upstream}' >/dev/null 2>&1
        print-warning "No upstream configured for $current_branch, skipping."
        continue
    end

    # Update remote-tracking refs.
    git fetch --quiet

    set ahead_count (git rev-list --count "@{upstream}..HEAD")

    if test "$ahead_count" -gt 0
        print-info "$ahead_count unpushed commit(s), pushing..."
        git push
    else
        print-info "Nothing to push."
    end
end
