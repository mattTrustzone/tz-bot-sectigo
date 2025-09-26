#!/usr/bin/env bash
set -euo pipefail

if ! command -v lego >/dev/null 2>&1; then
    echo "Error: lego is not installed. See https://github.com/go-acme/lego" >&2
    exit 1
fi

_API_KEY=""
LEGO_ARGS=()

# Function to prompt for EAB credentials
prompt_for_eab_credentials() {
    read -p "Enter EAB KID: " _EAB_KID
    read -s -p "Enter EAB HMAC Key: " _EAB_HMAC_KEY
    echo  # Move to a new line after secret input
    if [ -z "$_EAB_KID" ] || [ -z "$_EAB_HMAC_KEY" ]; then
        echo "Error: EAB KID and HMAC Key cannot be empty." >&2
        exit 1
    fi
    LEGO_ARGS+=(
        --eab
        --kid "$_EAB_KID"
        --hmac "$_EAB_HMAC_KEY"
    )
}

# Parse arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        --tz-api-key=*) _API_KEY="${1#*=}" ;;
        --tz-api-key|-z)
            _API_KEY="$2"
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--tz-api-key=API_KEY] [LEGO_ARGS...]"
            echo "Example: $0 --email your@email.com --domains example.com --dns globalsign run"
            exit 0
            ;;
        *) LEGO_ARGS+=("$1") ;;
    esac
    shift
done

# Always prompt for EAB credentials
prompt_for_eab_credentials

# Set default ACME server for GlobalSign
LEGO_ARGS+=(
    --server "https://emea.acme.atlas.globalsign.com/directory"
)

# Debug: Print the lego command (without sensitive data)
echo "lego command: lego ${LEGO_ARGS[@]/--hmac */--hmac ***}"

# Run lego
lego "${LEGO_ARGS[@]}"
