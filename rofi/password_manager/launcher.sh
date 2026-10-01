#!/usr/bin/env bash

set -euo pipefail

STORE="${PASSWORD_STORE_DIR:-$HOME/work/side/pass}"
export PASSWORD_STORE_DIR="$STORE"

ROFI_DIR="$HOME/config_bak/rofi/password_manager"
THEME="style"

PENDING_FILE="/tmp/pass-rofi-pending"
LOG_FILE="/tmp/pass-rofi.log"

if [[ -n "${WAYLAND_DISPLAY:-}" || -n "${DISPLAY:-}" ]]; then
  DMENU="rofi -dmenu -theme ${ROFI_DIR}/${THEME}.rasi"
else
  notify-send -a "Pass" "No graphical session found"
  exit 1
fi

copy_clipboard() {
  printf '%s' "$1" | wl-copy
}

copy_password() {
  local secret="$1"
  local password

  if ! password="$(pass show "$secret" 2>>"$LOG_FILE" | head -n1)"; then
    notify-send \
      -a "Pass" \
      "Failed to decrypt" \
      "$secret"

    rm -f "$PENDING_FILE"
    exit 1
  fi

  copy_clipboard "$password"

  (
    sleep 45

    current="$(wl-paste 2>/dev/null || true)"

    if [[ "$current" == "$password" ]]; then
      printf '' | wl-copy
    fi
  ) &

  notify-send \
    --expire-time=10000 \
    -a "Pass" \
    "Password Copied" \
    "$secret"

  rm -f "$PENDING_FILE"
}

copy_username() {
  local secret="$1"
  local username

  username="$(basename "$secret")"

  copy_clipboard "$username"

  printf '%s' "$secret" >"$PENDING_FILE"

  notify-send \
    --expire-time=10000 \
    -a "Pass" \
    "Username Copied" \
    "Run shortcut again for password"
}

# Second keybind press → password
if [[ -f "$PENDING_FILE" ]]; then
  secret="$(cat "$PENDING_FILE")"
  copy_password "$secret"
  exit 0
fi

search_store() {
  local selected

  selected=$(
    find "$STORE" -type f -name "*.gpg" |
      sed "s|^$STORE/||" |
      sed 's/\.gpg$//' |
      sort |
      $DMENU -p "Search"
  )

  [[ -n "$selected" ]] || return

  copy_username "$selected"
  exit 0
}

current="$STORE"

while true; do
  entries=()

  [[ "$current" != "$STORE" ]] && entries+=("⬅ Back")

  entries+=("  Search entire store")

  while IFS= read -r dir; do
    entries+=("  $(basename "$dir")/")
  done < <(
    find "$current" \
      -mindepth 1 \
      -maxdepth 1 \
      -type d \
      ! -name '.*' |
      sort
  )

  while IFS= read -r file; do
    entries+=("  $(basename "${file%.gpg}")")
  done < <(
    find "$current" \
      -mindepth 1 \
      -maxdepth 1 \
      -type f \
      -name "*.gpg" |
      sort
  )

  selection=$(
    printf '%s\n' "${entries[@]}" |
      $DMENU -p "$(basename "$current")"
  )

  [[ -n "$selection" ]] || exit 0

  case "$selection" in
  "⬅ Back")
    current="$(dirname "$current")"
    ;;

  "  Search entire store")
    search_store
    ;;

  "  "*)
    dir="${selection#  }"
    dir="${dir%/}"
    current="$current/$dir"
    ;;

  "  "*)
    secret="${selection#  }"

    rel="${current#"$STORE"/}/$secret"
    rel="${rel#/}"

    copy_username "$rel"
    exit 0
    ;;
  esac
done
