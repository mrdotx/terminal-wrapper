#!/bin/sh

# path:   /home/klassiker/.local/share/repos/terminal-wrapper/terminal_wrapper.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/terminal-wrapper
# date:   2023-08-17T12:33:30+0200

# color variables
yellow=$(tput setaf 3)
blue=$(tput setaf 12)
reset=$(tput sgr0)

script=$(basename "$0")
help="$script [-h/--help] -- script to execute command in new terminal window
  Usage:
    $script [command]

  Examples:
    $script git status"

status="The command exited with ${yellow}status $?${reset}."
keys="Press [${blue}q${reset}]${blue}uit${reset} \
to exit this window or [${blue}s${reset}]${blue}hell${reset} to run $SHELL..."

read_c() {
    [ -t 0 ] \
        && save_tty_set=$(stty -g) \
        && stty -icanon min 1 time 0
    eval "$1="
    while
        c=$(dd bs=1 count=1 2> /dev/null; printf .)
        c=${c%.}
        [ -n "$c" ] &&
            eval "$1=\${$1}"'$c
                [ "$(($(printf %s "${'"$1"'}" | wc -m)))" -eq 0 ]'; do
        continue
    done
    printf "\r"
    [ -t 0 ] \
        && stty "$save_tty_set"
}

case "$1" in
    -h | --help | "")
        printf "%s\n" "$help"
        exit 1
        ;;
    *)
        "$@"
        key=""
        printf "\n%s\n" "$status"
        while true; do
            printf "\r%s" "$keys" && read_c "key"
            case "$key" in
                q|Q)
                    exit 0
                    ;;
                s|S)
                    $SHELL \
                    && exit 0
                    ;;
                *)
                    status=""
                    ;;
            esac
        done
        ;;
esac
