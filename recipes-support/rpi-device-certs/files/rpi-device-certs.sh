#!/bin/sh
# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Embetrix Embedded Systems Solutions <ayoub.zaki@embetrix.com>
#
# Generate device certificates
# Usage: rpi-device-certs.sh [--force]
#   --force: regenerate all device certificates even if they already exist

CERT_FILE="rpi-device-cert.pem"
CERT_VALID_DAYS="${RPI_DEVICE_CERT_VALID_DAYS:-365}"
CERT_RENEW_DAYS="${RPI_DEVICE_CERT_RENEW_DAYS:-30}"


if [ "$1" = "--force" ]; then
    echo "Force mode: regenerating all device certificates"
    rm -f *.pem
fi

case "$CERT_RENEW_DAYS" in
    ''|*[!0-9]*)
        echo "Invalid RPI_DEVICE_CERT_RENEW_DAYS: $CERT_RENEW_DAYS"
        exit 1
        ;;
esac

case "$CERT_VALID_DAYS" in
    ''|*[!0-9]*)
        echo "Invalid RPI_DEVICE_CERT_VALID_DAYS: $CERT_VALID_DAYS"
        exit 1
        ;;
esac

RENEW_SECONDS=$((CERT_RENEW_DAYS * 86400))

if [ -f "$CERT_FILE" ] && ! openssl x509 -in "$CERT_FILE" -checkend "$RENEW_SECONDS" -noout >/dev/null 2>&1; then
    echo "Certificate expires in less than ${CERT_RENEW_DAYS} day(s); regenerating"
    rm -f "$CERT_FILE"
fi

# Get device IPv4 address
DEVICE_IP=$(networkctl status | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | grep -v '^127\.' | head -1)
if ! echo "$DEVICE_IP" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
    echo "Invalid device IP: $DEVICE_IP"
    exit 1
fi

HOSTNAME=$(hostname)

# Generate a self-signed device certificate whose private key lives in the
# RPi OTP-backed PKCS#11 token (no key material ever stored on disk).
# Override the token name / key id with PKCS11_TOKEN / SERVER_KEY_ID.
PKCS11_TOKEN="${PKCS11_TOKEN:-RPi%20OTP%20key}"
SERVER_KEY_ID="${SERVER_KEY_ID:-%01}"
SERVER_KEY_URI="pkcs11:object=${PKCS11_TOKEN};id=${SERVER_KEY_ID};type=private"

if [ ! -f "$CERT_FILE" ]; then
    # pkcs11-provider reconstructs EC keys with explicit curve parameters:
    # browsers reject these so reencode as named curve (prime256v1)
    openssl pkey -provider pkcs11 -provider default -pubin \
            -in "pkcs11:object=${PKCS11_TOKEN};id=${SERVER_KEY_ID};type=public" \
            -pubout | \
    openssl ec -pubin -param_enc named_curve -out rpi-device-pubkey.pem || exit 1

    openssl req -new -provider pkcs11 -provider default \
            -key "$SERVER_KEY_URI" \
            -subj "/C=DE/ST=BW/O=Embetrix/OU=DeviceCert/CN=$HOSTNAME" \
            -addext "subjectAltName=DNS:$HOSTNAME,DNS:localhost,IP:$DEVICE_IP,IP:127.0.0.1" \
            -addext "keyUsage=digitalSignature" \
            -addext "extendedKeyUsage=serverAuth" \
            -out rpi-device-cert.csr || exit 1

    openssl x509 -req -in rpi-device-cert.csr \
            -force_pubkey rpi-device-pubkey.pem \
            -signkey "$SERVER_KEY_URI" \
            -provider pkcs11 -provider default \
            -out "$CERT_FILE" -days "$CERT_VALID_DAYS" \
            -copy_extensions copyall || exit 1

    rm -f rpi-device-pubkey.pem rpi-device-cert.csr
fi

chmod 644 *.pem
