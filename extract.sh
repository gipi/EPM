#!/bin/bash
set -e

usage() {
    cat <<-EOF
    usage $0 <mail message>
EOF
    exit 1
}

test $# -lt 1 && usage

MAIL_SHA1=$(sha1sum "$1" | cut -d" " -f1)

# return DER data
extract_xml_value() {
    local filepath="$1"
    local tag="$2"

    xmlstarlet sel --noblanks -t -v //$tag "${filepath}" 2>/dev/null | base64 -d
}

extract_xml_value "$1" "ReceiptSignature" > "${MAIL_SHA1}"-receiptsignature.der
extract_xml_value "$1" "TimeStampToken" > "${MAIL_SHA1}"-timestamptoken.der
