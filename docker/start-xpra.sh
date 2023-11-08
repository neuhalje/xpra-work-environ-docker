#!/bin/bash
#
# Start xpra listening for SSL only connections
#

set -e

# TLS currently fails with  an error indicating that
# "ssl-cert" needs to be used (but it already is)
USE_TLS=0

#
# fix Brotli compression error
export XPRA_MIN_CLIPBOARD_COMPRESS_SIZE=99999999

XPRA_PORT=${1:-9876}

if [ -z "${XPRA_PASSWORD}" ]; then
    XPRA_PASSWORD=${XPRA_PASSWORD:-$(openssl rand -base64 32)}
    printf '\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\nThe following password has been generated:\n\n\t%s\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n' "${XPRA_PASSWORD}"
else
    printf '\nUsing the password passed in XPRA_PASSWORD\n\n'
fi
export XPRA_PASSWORD

# TLS only
CERT_SAN="${CERT_SAN:-DNS:localhost,IP:127.0.0.1}"
CERT_STORAGE=/run/xpra/pki
CERT_FILE=${CERT_STORAGE}/cert.pem
KEY_FILE=${CERT_STORAGE}/key.pem

generate_certificates() {
    [ -d ${CERT_STORAGE} ] || mkdir -p ${CERT_STORAGE}
    chmod 700 ${CERT_STORAGE}
    openssl req -new \
        -x509 \
        -days 90 \
        -newkey rsa:4096 \
        -nodes \
        -subj "/C=DE/ST=NRW/L=Bonn/O=playground/OU=Jens Neuhalfen/CN=xpra" \
        -addext "subjectAltName = ${CERT_SAN}" \
        -out "${CERT_FILE}" \
        -keyout "${KEY_FILE}" \
        -sha256
}

start_xpra_tls() {
    xpra start \
        --attach=no \
        --bell=no \
        --bind-ssl=0.0.0.0:${XPRA_PORT} \
        --clipboard-direction=both \
        --clipboard=auto \
        --daemon=no \
        --exit-with-children=no \
        --file-transfer=on \
        --html=off \
        --mdns=no \
        --notifications=no \
        --pulseaudio=no \
        --ssl-auth=env:name=XPRA_PASSWORD \
        --ssl-cert="${CERT_FILE}" \
        --ssl-ciphers=ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384 \
        --ssl-key="${KEY_FILE}" \
        --ssl-protocol=TLSv1_2 \
        --ssl=on \
        --start=/usr/bin/screen \
        --webcam=no \
        :100
}

start_xpra_tcp() {
   #     --bind-tcp=0.0.0.0:${XPRA_PORT},auth=env 
    xpra start \
        --attach=no \
        --bell=no \
        --bind-tcp=0.0.0.0:9876 \
        --tcp-auth=env \
        --clipboard-direction=both \
        --clipboard=auto \
        --daemon=no \
        --exit-with-children=no \
        --file-transfer=on \
        --html=off \
        --mdns=no \
        --notifications=no \
        --pulseaudio=no \
        --start=/usr/bin/screen \
        --webcam=no \
        :100
}

if [ $USE_TLS -gt 0 ]; then
    if ! [[ -f ${key_file} && -f ${cert_file} ]]; then
        generate_certificates
    fi

    printf '\ncertificates\n=========================================================================\n\nthis container used the following certificate:\n\n'
    cat "${cert_file}"

    printf '\n\nor use directly:

    xpra attach ssl:localhost:%d \\
        --ssl-protocol=tlsv1_2 \\
        --ssl-check-hostname=yes \\
        --ssl-ca-data=%s \\
        --start-child=gnome-terminal\n' ${XPRA_PORT} "$(xxd -ps "${cert_file}" | tr -d '\n')"

    printf '\n\n=========================================================================\n'

    start_xpra_tls
else
    echo 2

    printf 'Now run the client:

    xpra attach tcp:localhost:%d \\
        --start-child=gnome-terminal\n' ${XPRA_PORT}
    start_xpra_tcp
fi
