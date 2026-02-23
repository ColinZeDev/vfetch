#!/bin/bash

# vfetch -- a fetch command exclusive to void linux users

if ! grep -qP '^ID="?void"?' /etc/os-release 2>/dev/null; then
    echo "\033[38;5;196mvfetch is exclusive to Void Linux.\033[0m" >&2
    exit 1
fi

R=$'\033[0m'
B=$'\033[1m'
U=$'\033[4m'
G=$'\033[38;5;070m'
DG=$'\033[38;5;2m'
L=$'\033[38;5;118m'
W=$'\033[97m'
D=$'\033[38;5;238m'

user="$(whoami)"
full_name="$(getent passwd "$user" | cut -d: -f5 | cut -d, -f1)"
[[ -n "$full_name" ]] && user_display="${full_name} (${user})" || user_display="$user"

host="$(hostname)"

kernel="$(uname -s) $(uname -r)"

uptime_raw="$(uptime -p | sed 's/up //')"

xbps_pkgs="$(xbps-query -l 2>/dev/null | wc -l)"
flatpak_pkgs=""
if command -v flatpak &>/dev/null; then
    fp_count="$(flatpak list 2>/dev/null | tail -n +2 | wc -l)"
    [[ $fp_count -gt 0 ]] && flatpak_pkgs=" | ${fp_count} (flatpak)"
fi
pkgs="${xbps_pkgs} (xbps)${flatpak_pkgs}"

local_ip="$(ip -o -f inet addr show | awk '$2 != "lo" {print $4; exit}')"

de="${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-unknown}}"

declare -A shell_names=(
    [zsh]="Z Shell"
    [bash]="GNU Bash"
    [fish]="Fish"
    [dash]="Dash"
    [ksh]="KornShell"
    [tcsh]="tcsh"
)
shell_bin="${SHELL##*/}"
shell_pretty="${shell_names[$shell_bin]:-$shell_bin}"
shell="$shell_pretty $("$SHELL" --version 2>&1 | head -1 | grep -oP '\d+\.\d+(\.\d+)?')"

read mem_total mem_avail < <(awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf "%.0f %.0f", t/1024, a/1024}' /proc/meminfo)
mem_used=$(( mem_total - mem_avail ))
mem_pct=$(( mem_used * 100 / mem_total ))
bar_filled=$(( mem_pct * 10 / 100 ))
bar=""
for ((i=0; i<10; i++)); do
    [[ $i -lt $bar_filled ]] && bar+="${G}█" || bar+="${D}░"
done
memory="${mem_used}MiB / ${mem_total}MiB [${bar}${R}]"

svc_count="$(ls /var/service | wc -l)"
init="runit | ${svc_count} services running"

term="${TERM_PROGRAM:-${VTE_VERSION:+VTE}}"
[[ -z "$term" ]] && term="${TERM:-unknown}"

art=(
    "   _______   "
    "_ \______ -  "
    "| \  ___  \ |"
    "| | /   \ | |"
    "| | \___/ | |"
    "| \______ \_|"
    " -_______\   "
    "             "
    "             "
    "             "
    "             "
    "             "
    "             "
)

info=(
    "${B}${U}${DG}Enter the void${R}${B}${DG}.${R}"
    "$(printf "${L}%-12.9s${R}%s" "OS"       "Void GNU/Linux")"
    "$(printf "${L}%-12.9s${R}%s" "User"     "${full_name} (${user})")"
    "$(printf "${L}%-12.9s${R}%s" "Hostname" "${host}")"
    "$(printf "${L}%-12.9s${R}%s" "Kernel"   "${kernel}")"
    "$(printf "${L}%-12.9s${R}%s" "Init"     "${init}")"
    "$(printf "${L}%-12.9s${R}%s" "Shell"    "${shell} (${shell_bin})")"
    "$(printf "${L}%-12.9s${R}%s" "DE/WM"    "${de}")"
    "$(printf "${L}%-12.9s${R}%s" "Terminal" "${term}")"
    "$(printf "${L}%-12.9s${R}%s" "Uptime"   "${uptime_raw}")"
    "$(printf "${L}%-12.9s${R}%s" "PKGS"     "${pkgs}")"
    "$(printf "${L}%-12.9s${R}%s" "Memory"   "${memory}")"
    "$(printf "${L}%-12.9s${R}%s" "Local IP" "${local_ip}")"
)

echo
for ((i=0; i<${#art[@]}; i++)); do
    printf "${B}${G}%s    %s${R}\n" "${art[$i]}" "${info[$i]}"
done
echo
