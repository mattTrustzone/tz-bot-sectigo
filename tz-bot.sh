#!/bin/bash

if [ ! -x "$(which certbot)" ]; then
   echo "You have to install certbot"
   exit 1
fi

CERTBOT_ARGS=()

# New function to prompt for EAB credentials
function prompt_for_eab_credentials() {
    read -p "Enter EAB KID: " _EAB_KID
    read -p "Enter EAB HMAC Key: " _EAB_HMAC_KEY
    CERTBOT_ARGS+=(--eab-kid "${_EAB_KID:?}" --eab-hmac-key "${_EAB_HMAC_KEY:?}" --key-type rsa --agree-tos --register-unsafely-without-email --no-eff-email)
    echo "EAB credentials added to CERTBOT_ARGS"
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --tz-api-key=*)
            _API_KEY=${1#*=}
            echo "API Key set to $_API_KEY"
        ;;
        --tz-api-key|-z)
           _API_KEY=$2
           shift
           echo "API Key set to $_API_KEY"
        ;;
        *) CERTBOT_ARGS+=("$1") ;;
    esac
    shift
done

# Explicitly set the ACME server
CERTBOT_ARGS+=(--server "https://acme.sectigo.com/v2/DV")
echo "ACME server set in CERTBOT_ARGS"

set -- "${CERTBOT_ARGS[@]}"

# Always prompt for EAB credentials
prompt_for_eab_credentials

# Debug: Print the Certbot command with arguments
echo "Certbot command: certbot ${CERTBOT_ARGS[@]}"

certbot "${CERTBOT_ARGS[@]}"
