# function open
#     if test -z "$argv[1]" -o "$argv[1]" = "."
#         set PROJECT_DIR (pwd)
#     else
#         set PROJECT_DIR "$argv[1]"
#     end
#
#     set SESSION_NAME (basename "$PROJECT_DIR")
#
#     cd "$PROJECT_DIR"
#
#     if tmux has-session -t "$SESSION_NAME" ^/dev/null
#         tmux attach-session -t "$SESSION_NAME"
#         return
#     end
#
#     # Create session + main window
#     tmux new-session -d -s "$SESSION_NAME" -n main -c "$PROJECT_DIR"
#
#     # Worker windows
#     tmux new-window -t "$SESSION_NAME":1 -n worker1 -c "$PROJECT_DIR"
#     tmux new-window -t "$SESSION_NAME":2 -n worker1 -c "$PROJECT_DIR"
#     # tmux new-window -t "$SESSION_NAME":2 -n worker2 -c "$PROJECT_DIR" "nvim $PROJECT_DIR"
#
#     # Logs windows
#     # tmux new-window -t "$SESSION_NAME":3 -n logs -c "$PROJECT_DIR" yazi
#     tmux new-window -t "$SESSION_NAME":3 -n worker1 -c "$PROJECT_DIR"
#     tmux new-window -t "$SESSION_NAME":4 -n logs -c "$PROJECT_DIR"
#
#     # Start on worker1
#     tmux select-window -t "$SESSION_NAME":1
#
#     tmux attach-session -t "$SESSION_NAME"
# end

function wall
    gowall convert ~/Pictures/Wallpaper/$argv[1] -t catppuccin
end

function ms
    touch "$argv[1]"
    chmod +x "$argv[1]"
end

function edit
    cd ~/.config/$argv[1]
    nvim
end

function cpcf
    set file (fzf --query="$argv[1]" --preview 'bat --color=always {}' --preview-window 'right:60%' --bind 'ctrl-d:preview-page-down,ctrl-u:preview-page-up')

    if test -n "$file"
        cat "$file" | wl-copy
        echo "Copied: $file"
    else
        echo "No file selected."
    end
end

function mount_gdrive
    rclone mount gdrive: ~/mnt/gdrive
end

function backup_dots
    exec syncAll.sh
end

function fcd
    set dir (find (or $argv[1] .) -type d -not -path '*/\.*' 2> /dev/null | fzf +m)
    if test -n "$dir"
        cd "$dir"
    end
end

function extract
    if test -f "$argv[1]"
        switch "$argv[1]"
            case '*.tar.gz'
                tar -xzf "$argv[1]"
            case '*.tar.xz'
                tar -xf "$argv[1]"
            case '*.tar.bz2'
                tar -xjf "$argv[1]"
            case '*.gz'
                gunzip "$argv[1]"
            case '*.bz2'
                bunzip2 "$argv[1]"
            case '*.zip'
                unzip "$argv[1]"
            case '*.Z'
                uncompress "$argv[1]"
            case '*.7z'
                7z x "$argv[1]"
            case '*'
                echo "'$argv[1]' cannot be extracted"
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

function killp
    ps aux | fzf | awk '{print $2}' | xargs kill -9
end

function j
    set dir (eza -1 --color=always --icons --group-directories-first | fzf --ansi)
    if test -n "$dir"
        cd (echo "$dir" | awk '{print $NF}')
    end
end

function take
    mkdir -p "$argv[1]"
    cd "$argv[1]"
end

function c
    cd "$argv[1]"
    ls
end

function music
    xdg-open https://music.youtube.com/
end

function goInit
    if test (count $argv) -eq 0
        echo "Usage: goInit <directory-name>"
        return 1
    end

    set dir $argv[1]
    mkdir -p $dir
    cd $dir
    go mod init $dir
    touch main.go
    go mod tidy
    nvim
end
