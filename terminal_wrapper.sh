#!/bin/sh

# path:   /home/klassiker/.local/share/repos/terminal-wrapper/terminal_wrapper.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/terminal-wrapper
# date:   2025-08-12T04:18:09+0200

# color variables
reset="\033[0m"
red="\033[31m"
green="\033[32m"
blue="\033[94m"

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
        status=$?
        [ $status -eq 0 ] \
            && color="$green" \
            || color="$red"
        status_msg="The command exited with status [$color$status$reset]."
        key=""
        printf "\n%b\n" "$status_msg"
        while true; do
            printf "\r%s %b %s %b %s" \
                "Press" \
                "[${blue}q$reset]${blue}uit$reset" \
                "to exit this window or" \
                "[${blue}s$reset]${blue}hell$reset" \
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
                    status_msg=""
                    ;;
            esac
        done
        ;;
esac
