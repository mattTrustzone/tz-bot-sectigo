#!/bin/bash
# Use ':-' to ensure the default is used if BOT_SCRIPT_LOCATION is unset or empty.
BOT_SCRIPT_LOCATION=${BOT_SCRIPT_LOCATION:-"https://raw.githubusercontent.com/mattTrustzone/tz-bot-sectigo/master/tz-bot.sh"}

# Check if lego is installed; if not, install it.
if ! command -v lego >/dev/null 2>&1; then
    echo "lego is not installed. Checking for Go..."

    # Check if Go is installed and is at least version 1.23
    if ! command -v go >/dev/null 2>&1 || [[ $(go version | awk '{print $3}' | cut -d. -f2) -lt 23 ]]; then
        echo "Go is not installed or is too old. Installing the latest version of Go..."

        # Download and install the latest version of Go
        sudo rm -rf /usr/local/go
        curl -s https://go.dev/dl/go1.22.3.linux-amd64.tar.gz | sudo tar -C /usr/local -xz
        export PATH=$PATH:/usr/local/go/bin

        # Verify Go installation
        if ! command -v go >/dev/null 2>&1; then
            echo "Go installation failed. Please install Go manually and rerun this script."
            exit 1
        fi
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
    if ! curl -sf "$BOT_SCRIPT_LOCATION" -o /tmp/tz-bot; then
        echo "Error: Unable to download file from $BOT_SCRIPT_LOCATION"
        exit 1
    fi
    sudo mkdir -p /usr/local/bin
    sudo mv /tmp/tz-bot /usr/local/bin/tz-bot
    sudo chmod +x /usr/local/bin/tz-bot
}

install_tzbot
