#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load_env.sh" || exit 1
require_env INSURGENCY_SERVER_PATH || exit 1

SERVER_USER="${SERVER_USER:-steam}"
TMUX_SESSION="${TMUX_SESSION:-game}"
server_uid=$(id -u "$SERVER_USER") || exit 1
if [[ "$server_uid" -eq 0 ]]; then
    printf 'SERVER_USER must be a non-root user.\n' >&2
    exit 1
fi

# Quote the configured path and session name before passing them to the shell.
printf -v launch_command 'cd -- %q || exit 1
if [[ ! -r startup.sh || ! -r load_env.sh || ! -r .env ]]; then
    printf "Cannot read startup.sh, load_env.sh, or .env in %%s\\n" "$PWD" >&2
    exit 1
fi
exec tmux new-session -d -s %q %q' \
    "$INSURGENCY_SERVER_PATH" "$TMUX_SESSION" 'exec bash ./startup.sh'

current_uid=$(id -u) || exit 1
if [[ "$current_uid" -eq 0 ]]; then
    su --login --shell /bin/bash --command "$launch_command" "$SERVER_USER"
elif [[ "$current_uid" -eq "$server_uid" ]]; then
    bash -c "$launch_command"
else
    printf 'Run this script as root or %s.\n' "$SERVER_USER" >&2
    exit 1
fi || exit $?

printf 'Started tmux session %s as %s.\n' "$TMUX_SESSION" "$SERVER_USER"
printf -v attach_command 'tmux attach-session -t %q' "=$TMUX_SESSION"
printf 'Attach from root: su - %q -c %q\n' "$SERVER_USER" "$attach_command"
