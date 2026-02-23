#!/usr/bin/env bash
set -euo pipefail

INSTALL_PATH="/usr/local/bin/vfetch"
URL="https://raw.githubusercontent.com/ColinZeDev/vfetch/main/vfetch.sh"

printf "\033[1m\033[38;5;46m=> Installing vFETCH to: $INSTALL_PATH\033[0m"

if [[ -f "$INSTALL_PATH" ]]; then
  read -rp "\033[1m\033[38;5;214mvFETCH already exists. Overwrite? [y/N]:\033[0m " answer
  case "$answer" in
    [yY][eE][sS]|[yY]) ;;
    *)
      echo "\033[1m\033[38;5;160mInstallation cancelled.\033[0m"
      exit 0
      ;;
  esac
fi

sudo curl -fsSL "$URL" -o "$INSTALL_PATH"
sudo chmod 755 "$INSTALL_PATH"

printf "\033[1m\033[38;5;46m=> Installation complete!\033[0m"
