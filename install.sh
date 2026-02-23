#!/usr/bin/env bash
set -euo pipefail

INSTALL_PATH="/usr/local/bin/vfetch"
URL="https://raw.githubusercontent.com/ColinZeDev/vfetch/main/vfetch.sh"

GREEN="\033[1;38;5;46m"
ORANGE="\033[1;38;5;214m"
RED="\033[1;38;5;160m"
RESET="\033[0m"

printf "${GREEN}=> Installing vFETCH to: %s${RESET}\n" "$INSTALL_PATH"

if [[ -f "$INSTALL_PATH" ]]; then
  printf "${ORANGE}vFETCH already exists. Overwrite? [y/N]: ${RESET}"
  read -r answer
  case "$answer" in
    [yY][eE][sS]|[yY]) ;;
    *)
      printf "${RED}Installation cancelled.${RESET}\n"
      exit 0
      ;;
  esac
fi

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

curl -fsSL "$URL" -o "$tmp_file"
sudo install -m 755 "$tmp_file" "$INSTALL_PATH"

printf "${GREEN}=> Installation complete!${RESET}\n"
