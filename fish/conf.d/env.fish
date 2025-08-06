set -x GOPATH $HOME/go
set -x PATH $GOPATH/bin $PATH
set -Ux PATH $PATH /opt/kafka/bin
set -Ux PATH $HOME/.config/rofi/scripts $PATH
set PATH $HOME/.cargo/bin/ $PATH
# set -Ux STARSHIP_CONFIG ~/.config/starship/starship.toml
set -Ux EDITOR nvim
set -Ux PATH $HOME/go/bin $PATH


set -Ux FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border --preview-window=right:60%'
set -Ux FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --color=fg+:yellow,preview-bg:0"
