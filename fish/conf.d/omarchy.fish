# Omarchy checkout. shell.qml resolves every path off OMARCHY_PATH, and the
# omarchy-* helpers live in the checkout's bin/ rather than being packaged.
set -gx OMARCHY_PATH $HOME/omarchy
fish_add_path $HOME/omarchy/bin
