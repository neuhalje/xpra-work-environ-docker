#!/bin/bash
#
# Start xpra listening for SSL only connections
#

set -e

XPRA_PORT=$1
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
			 -out  "${CERT_FILE}"    \
			 -keyout "${KEY_FILE}"  \
			 -sha256
}

start_xpra() {
               xpra start \
	       \
	       --bind-ssl=0.0.0.0:${XPRA_PORT} \
	       \
	       --ssl=on \
               --ssl-protocol=TLSv1_2 \
               --ssl-ciphers=ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384  \
               --ssl-cert="${CERT_FILE}" \
               --ssl-key="${KEY_FILE}" \
	       \
	       --attach=no \
	       --bell=no \
	       --daemon=no \
	       --exit-with-children=no \
	       --html=off \
	       --mdns=no \
	       --notifications=no \
	       --pulseaudio=no \
	       --start=screen \
	       --xvfb="/usr/bin/Xvfb +extension Composite -screen 0 1920x1080x24+32 -nolisten tcp -noreset" \
	       :100
}

if ! [[  -f ${KEY_FILE} && -f ${CERT_FILE} ]]; then
	generate_certificates
fi

printf '\nCertificates\n=========================================================================\n\nThis container used the following certificate:\n\n'
cat "${CERT_FILE}"

printf '\n\nOr use directly:

xpra attach ssl:localhost:%d \\
           --ssl-protocol=TLSv1_2 \\
           --ssl-check-hostname=no \\
	   --ssl-ca-data=%s \\
	   --start-child=gnome-terminal\n' \
  ${XPRA_PORT} \
  $(xxd  -ps  "${CERT_FILE}"| tr -d '\n' )

printf '\n\n=========================================================================\n'

start_xpra

