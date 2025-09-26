#!/bin/bash
# Use ':-' to ensure the default is used if BOT_SCRIPT_LOCATION is unset or empty.
BOT_SCRIPT_LOCATION=${BOT_SCRIPT_LOCATION:-"https://raw.githubusercontent.com/mattTrustzone/tz-bot-sectigo/master/tz-bot.sh"}

# Check if lego is installed; if not, install it.
if ! command -v lego >/dev/null 2>&1; then
    echo "lego is not installed. Checking for Go..."

    # Check if Go is installed; if not, install it.
    if ! command -v go >/dev/null 2>&1; then
        echo "Go is not installed. Attempting to install Go..."
        # Detect the OS and install Go accordingly
        if command -v apt-get >/dev/null 2>&1; then
            # Debian/Ubuntu
            sudo apt-get update
            sudo apt-get install -y golang
        elif command -v yum >/dev/null 2>&1; then
            # RHEL/CentOS
            sudo yum install -y golang
        elif command -v brew >/dev/null 2>&1; then
            # macOS
            brew install go
        else
            echo "Unsupported system for automatic Go installation. Please install Go manually and rerun this script."
            exit 1
        fi
        # Ensure Go binaries are in PATH
        export PATH=$PATH:/usr/local/go/bin
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
