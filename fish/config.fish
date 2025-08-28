function fish_greeting
    # fastfetch
    # misfortune
    wakafetch-sqlite heatmap
end

fish_vi_key_bindings
set -g fish_autosuggestion_enabled 1
# set -gx TERM xterm-256color

# set -g theme_color_scheme catppuccin
# set -g fish_prompt_pwd_dir_length 1
# set -g theme_display_user yes
# set -g theme_hide_hostname no
# set -g theme_hostname always

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

atuin init fish | source
starship init fish | source
zoxide init fish --cmd cd | source

source ~/.config/fish/conf.d/git.fish
source ~/.config/fish/conf.d/functions.fish
source ~/.config/fish/conf.d/abbr.fish
source ~/.config/fish/conf.d/env.fish
source ~/.config/fish/conf.d/gdr.fish
