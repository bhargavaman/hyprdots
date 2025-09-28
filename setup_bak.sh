#!/bin/bash

set -euo pipefail

cat <<EOF
  _________       __   ____ ___
 /   _____/ _____/  |_|    |   \______
 \_____  \_/ __ \   __\    |   /\____ \
 /        \  ___/|  | |    |  / |  |_> >>>>
/_______  /\___  >__| |______/  |   __/
        \/     \/               |__|

EOF

if [ "$EUID" -eq 0 ]; then
  echo "❌ Do not run this script as root or with sudo."
  echo "Run it as your normal user. The script will ask for sudo when needed."
  exit 1
fi

# Determine real home directory and script path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS="cava kitty dunst fastfetch pacseek hypr hypridle rofi starship tmux waybar yazi"

BACKUP_DIR="$HOME/.config_backup"
LOCAL_BIN="$HOME/.local/bin"
FONT_DIR="$HOME/.local/share/fonts"
DOTS_DIR="$HOME/hyprdots"
ZSHRC="$HOME/.zshrc"

echo "==> Backing up existing config files..."
mkdir -p "$BACKUP_DIR"
for dir in $CONFIGS; do
  if [ -d "$HOME/.config/$dir" ]; then
    echo "=> Backing up $dir to $BACKUP_DIR"
    cp -r "$HOME/.config/$dir" "$BACKUP_DIR/$dir"
    rm -rf "$HOME/.config/$dir"
  fi
done

echo "==> Copying new config files..."
for dir in $CONFIGS; do
  cp -r "$SCRIPT_DIR/$dir" "$HOME/.config/"
done

echo "==> Making Waybar and Rofi scripts executable..."
[ -d "$HOME/.config/waybar/scripts" ] && chmod +x "$HOME/.config/waybar/scripts/"* || true
[ -d "$HOME/.config/rofi" ] && chmod +x "$HOME/.config/rofi/"* || true

echo "==> Copying binaries..."
mkdir -p "$LOCAL_BIN"
[ -d "$SCRIPT_DIR/bin" ] && cp -r "$SCRIPT_DIR/bin/"* "$LOCAL_BIN"
chmod +x "$LOCAL_BIN/"* || true

echo "==> Copying .zshrc..."
cp "$SCRIPT_DIR/zsh/.zshrc" "$ZSHRC"

echo "==> Making scripts executable..."
chmod +x "$DOTS_DIR"/* || true

# Font Awesome Installation
FA_DIR="$FONT_DIR/fontawesome"
mkdir -p "$FA_DIR"

echo "==> Installing Font Awesome (v5 & v6)..."
if [[ ! -d "$FA_DIR" || -z "$(ls -A "$FA_DIR"/*.otf 2>/dev/null)" ]]; then
  wget -q https://use.fontawesome.com/releases/v6.7.2/fontawesome-free-6.7.2-desktop.zip
  unzip -q fontawesome-free-6.7.2-desktop.zip
  mv fontawesome-free-6.7.2-desktop/otfs/*.otf "$FA_DIR/"
  rm -rf fontawesome-free-6.7.2-desktop*

  wget -q https://use.fontawesome.com/releases/v5.15.4/fontawesome-free-5.15.4-desktop.zip
  unzip -q fontawesome-free-5.15.4-desktop.zip
  mv fontawesome-free-5.15.4-desktop/otfs/*.otf "$FA_DIR/"
  rm -rf fontawesome-free-5.15.4-desktop*
else
  echo "✔️ Font Awesome already installed, skipping."
fi

# JetBrains Nerd Font Installation
JB_FONT_DIR="$FONT_DIR/JetBrainsMono"
mkdir -p "$JB_FONT_DIR"

echo "==> Installing JetBrains Nerd Fonts..."
if [[ ! -f "$JB_FONT_DIR/JetBrainsMono-Regular.ttf" ]]; then
  wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip
  unzip -q JetBrainsMono.zip -d JetBrainsMono
  mv JetBrainsMono/*.ttf "$JB_FONT_DIR/"
  rm -rf JetBrainsMono JetBrainsMono.zip
else
  echo "✔️ JetBrains Nerd Font already installed, skipping."
fi

echo "==> Refreshing font cache..."
fc-cache -f || echo "⚠️ Font cache update skipped or failed."

echo -e "\n✅ Base setup completed successfully!"

# Create wallpaper directory
echo "==> Creating wallpaper directory..."
mkdir -p "$HOME/Pictures/Wallpaper"

# Install yay if not already installed
if ! command -v yay &>/dev/null; then
  echo "==> Installing AUR package manager (yay)..."
  sudo pacman -S --needed git base-devel || {
    echo "❌ Failed to install base-devel"
    exit 1
  }

  YAY_DIR=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$YAY_DIR"
  cd "$YAY_DIR"
  makepkg -si --noconfirm || {
    echo "❌ yay installation failed"
    exit 1
  }
  cd -
  rm -rf "$YAY_DIR"
else
  echo "✔️ yay is already installed."
fi

# Install useful packages from yay and pacman
echo "==> Installing core packages..."
yay -S --noconfirm \
  pacseek \
  zoxide \
  fzf \
  unzip \
  zsh \
  starship \
  atuin \
  eza \
  acpi \
  playerctl \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zsh-history-substring-search

sudo pacman -S --noconfirm \
  dunst \
  libnotify \
  waybar \
  wl-clipboard \
  xdg-desktop-portal-hyprland \
  xdg-desktop-portal \
  brightnessctl \
  pavucontrol \
  tmux \
  slurp \
  grim \
  hyprlock \
  pamixer

# Set zsh as default shell if not already
if [[ "$SHELL" != "$(which zsh)" ]]; then
  echo "==> Changing default shell to zsh..."
  sudo chsh -s "$(which zsh)" "$USER"
fi

# Ensure Zsh plugins and tools are sourced
echo "==> Configuring Zsh plugins and tools..."
{
  echo -e "\n# Zsh Plugins and Tools"
  echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
  echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  echo "source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
  echo 'eval "$(zoxide init zsh)"'
  echo 'eval "$(atuin init zsh)"'
  echo 'eval "$(starship init zsh)"'
} >>"$ZSHRC"

echo -e "\n✅ All packages and Zsh plugins configured successfully!"
