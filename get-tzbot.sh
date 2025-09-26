#!/bin/bash
# Use ':-' to ensure the default is used if BOT_SCRIPT_LOCATION is unset or empty.
BOT_SCRIPT_LOCATION=${BOT_SCRIPT_LOCATION:-"https://raw.githubusercontent.com/mattTrustzone/tz-bot-sectigo/master/tz-bot.sh"}

# Check if lego is installed; if not, install it.
if ! command -v lego >/dev/null 2>&1; then
    echo "lego is not installed. Checking for Go..."

    # Check if Go is installed and is at least version 1.23
    if ! command -v go >/dev/null 2>&1; then
        echo "Go is not installed."
        echo "Please install Go 1.23 or later from https://go.dev/dl/ and rerun this script."
        exit 1
    fi

    # Check Go version
    GO_VERSION=$(go version 2>/dev/null | awk '{print $3}')
    GO_MAJOR=$(echo "$GO_VERSION" | cut -d. -f2)
    if [[ "$GO_MAJOR" -lt 23 ]]; then
        echo "Go version $GO_VERSION is too old. lego requires Go 1.23 or later."
        echo "Please upgrade Go from https://go.dev/dl/ and rerun this script."
        exit 1
    fi

    # Install lego using go install
    echo "Installing lego..."
    go install github.com/go-acme/lego/v4/cmd/lego@latest

    # Re-check if lego is now installed.
    if ! command -v lego >/dev/null 2>&1; then
        echo "lego installation failed. Please install lego manually."
        exit 1
    fi
fi

function install_tzbot() {
    if ! curl -sfL "$BOT_SCRIPT_LOCATION" -o /tmp/tz-bot; then
        echo "Error: Unable to download file from $BOT_SCRIPT_LOCATION"
        exit 1
    fi
    sudo mkdir -p /usr/local/bin
    sudo mv /tmp/tz-bot /usr/local/bin/tz-bot
    sudo chmod +x /usr/local/bin/tz-bot
}

install_tzbot
