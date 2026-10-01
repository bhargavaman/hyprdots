function update_auto_path --on-variable PWD --description "Temporarily add current directory to PATH if it contains executables"

    # Remove the previously added directory from PATH
    if set -q __auto_path_dir
        if set -l idx (contains -i -- $__auto_path_dir $PATH)
            set -e PATH[$idx]
        end
        set -e __auto_path_dir
    end

    # Check whether the current directory contains any executable files
    if fd --type executable --max-depth 1 . "$PWD" >/dev/null 2>&1

        # Avoid duplicates
        if not contains -- "$PWD" $PATH
            set -gx PATH "$PWD" $PATH
            set -g __auto_path_dir "$PWD"
        end
    end
end
