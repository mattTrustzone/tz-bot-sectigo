#!/bin/bash
set -u

# Use ':-' to ensure the default is used if BOT_SCRIPT_LOCATION is unset or empty.
BOT_SCRIPT_LOCATION=${BOT_SCRIPT_LOCATION:-"https://raw.githubusercontent.com/mattTrustzone/tz-bot-sectigo/master/tz-bot.sh"}

# Function to print error and continue
error_exit() {
    echo "$1" >&2
    return 1
}

# Check if lego is installed; if not, install it.
if ! command -v lego >/dev/null 2>&1; then
    echo "lego is not installed. Checking for Go..." >&2

    # Check if Go is installed
    if ! command -v go >/dev/null 2>&1; then
        error_exit "Go is not installed. Please install Go 1.23 or later from https://go.dev/dl/ and rerun this script."
        # Do not exit, just return and let the user see the message
    fi

    # Check Go version
    GO_VERSION=$(go version 2>/dev/null | awk '{print $3}')
    GO_MAJOR=$(echo "$GO_VERSION" | cut -d. -f2)
    if [[ "$GO_MAJOR" -lt 23 ]]; then
        error_exit "Go version $GO_VERSION is too old. lego requires Go 1.23 or later. Please upgrade Go from https://go.dev/dl/ and rerun this script."
        # Do not exit, just return
    fi

    # Install lego using go install
    echo "Installing lego..." >&2
    if ! go install github.com/go-acme/lego/v4/cmd/lego@latest; then
        error_exit "lego installation failed. Please install lego manually."
        # Do not exit, just return
    fi
fi

# Install tz-bot
if ! curl -sfL "$BOT_SCRIPT_LOCATION" -o /tmp/tz-bot; then
    error_exit "Error: Unable to download file from $BOT_SCRIPT_LOCATION"
else
    mkdir -p "$HOME/.local/bin"
    mv /tmp/tz-bot "$HOME/.local/bin/tz-bot"
    chmod +x "$HOME/.local/bin/tz-bot"
    echo "Successfully installed tz-bot to $HOME/.local/bin/tz-bot" >&2
    echo "Make sure $HOME/.local/bin is in your PATH." >&2
fi
