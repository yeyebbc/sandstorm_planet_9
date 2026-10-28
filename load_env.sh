#!/usr/bin/env bash
# Shared configuration loader. Source this file from the other scripts.

ENV_FILE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/.env"
if [[ ! -f "$ENV_FILE" ]]; then
    printf 'Missing configuration: %s\nCopy .env.example to .env and fill in your settings.\n' "$ENV_FILE" >&2
    return 1
fi

set -a
source "$ENV_FILE" || { set +a; return 1; }
set +a

export CONFIG_PATH="${CONFIG_PATH:-$(dirname -- "$ENV_FILE")}"

require_env() {
    local name
    for name in "$@"; do
        if [[ -z "${!name:-}" ]]; then
            printf 'Set %s in %s before running this script.\n' "$name" "$ENV_FILE" >&2
            return 1
        fi
    done
}
