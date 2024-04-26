#!/bin/sh

# path:   /home/klassiker/.local/share/repos/terminal-wrapper/terminal_wrapper.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/terminal-wrapper
# date:   2024-04-25T11:05:19+0200

# color variables
red="\033[31m"
green="\033[32m"
blue="\033[94m"
reset="\033[0m"

script=$(basename "$0")
help="$script [-h/--help] -- script to execute command in new terminal window
  Usage:
    $script [command]

  Examples:
    $script git status"

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
        error=$?
        [ $error -eq 0 ] \
            && status="${green}status $error$reset" \
            || status="${red}status $error$reset"
        cmd_status="The command exited with $status."
        key=""
        printf "\n%b\n" "$cmd_status"
        while true; do
            printf "\r%s %b %s %b %s" \
                "Press" \
                "[${blue}q${reset}]${blue}uit${reset}" \
                "to exit this window or" \
                "[${blue}s${reset}]${blue}hell${reset}" \
                "to run $SHELL..." \
                && read_c "key"
            case "$key" in
                q|Q)
                    exit 0
                    ;;
                s|S)
                    $SHELL \
                    && exit 0
                    ;;
                *)
                    cmd_status=""
                    ;;
            esac
        done
        ;;
esac
