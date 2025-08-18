abbr -a gs 'git status'
abbr -a gco 'git checkout'

abbr -a vim nvim
abbr -a kls 'kubectl get all'
abbr -a jump 'nvim (fzf -m --preview="bat --color=always {}")'
abbr -a ls 'eza -l --icons --level=1 --tree --git --color=always --sort=Name'
abbr -a search 'eval "~/.local/bin/search.sh"'
abbr -a cod 'code .'

# Tmux
abbr -a t 'tmux new -s '
abbr -a tt 'tmux a -t'
abbr -a fbat 'fzf --preview \'bat --style=numbers --color=always --line-range :500 {}\''

abbr -a seek pacseek
abbr -a y yazi
abbr -a ci cdi

# Path navigations
abbr -a .... 'cd ../..'
abbr -a .. 'cd ..'
abbr -a ~ 'cd ~'

abbr -a st systemctl-tui
