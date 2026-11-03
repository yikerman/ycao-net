#!/bin/sh
cd "$(dirname "$0")" || exit 1
tmux new-session 'watch racket main.rkt' \; \
  split-window -h -c "$PWD/dist" 'python -m http.server'
