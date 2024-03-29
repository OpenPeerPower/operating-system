#!/bin/bash
set -e

ARCH=
MACHINE=
DATA_IMG="/export/data.ext4"
VERSION_URL="https://github.com/OpenPeerPower/version/releases/download/v1.0.0/stable.json"
APPARMOR_URL="https://github.com/OpenPeerPower/version/releases/download/v1.0.0/apparmor.txt"

# Parse
while [[ $# -gt 0 ]]; do
    key=$1
    case $key in 
        --arch)
            ARCH=$2
            shift
            ;;
        --machine)
            MACHINE=$2
            shift
            ;;
        *)
            exit 1
            ;;
    esac
    shift
done

SUPERVISOR="openpeerpower/${ARCH}-oppio-supervisor"
DNS="openpeerpower/${ARCH}-oppio-dns"
AUDIO="openpeerpower/${ARCH}-oppio-audio"
CLI="openpeerpower/${ARCH}-oppio-cli"
MULTICAST="openpeerpower/${ARCH}-oppio-multicast"
OBSERVER="openpeerpower/${ARCH}-oppio-observer"
LANDINGPAGE="openpeerpower/${MACHINE}-openpeerpower:landingpage"

SUPERVISOR_VERSION=$(curl -sL ${VERSION_URL} | jq -e -r '.supervisor')
DNS_VERSION=$(curl -sL ${VERSION_URL} | jq -e -r '.dns')
CLI_VERSION=$(curl -sL ${VERSION_URL} | jq -e -r '.cli')
AUDIO_VERSION=$(curl -sL ${VERSION_URL} | jq -e -r '.audio')
MULTICAST_VERSION=$(curl -sL ${VERSION_URL} | jq -e -r '.multicast')
OBSERVER_VERSION=$(curl -sL ${VERSION_URL} | jq -e -r '.observer')

# Make image
dd if=/dev/zero of=${DATA_IMG} bs=1G count=1
mkfs.ext4 -L "oppos-data" -E lazy_itable_init=0,lazy_journal_init=0 ${DATA_IMG}

# Setup local user
if [ "${BUILDER_UID:0}" -ne 0 ] && [ "${BUILDER_GID:0}" -ne 0 ]; then
  groupadd -g "${BUILDER_GID}" builder
  useradd -m -u "${BUILDER_UID}" -g "${BUILDER_GID}" -G docker builder
  chown builder:builder ${DATA_IMG}
fi

# Mount / init file structs
mkdir -p /mnt/data/
mount -o loop ${DATA_IMG} /mnt/data
mkdir -p /mnt/data/docker

# Run dockerd
dockerd -s overlay2 -g /mnt/data/docker &
DOCKER_PID=$!

DOCKER_COUNT=0
until docker info >/dev/null 2>&1; do
    if [ ${DOCKER_COUNT} -gt 30 ]; then
        exit 1
    fi
        
    sleep 1
    DOCKER_COUNT=$((DOCKER_COUNT + 1))
done

# Install supervisor
docker pull "${SUPERVISOR}:${SUPERVISOR_VERSION}"
docker tag "${SUPERVISOR}:${SUPERVISOR_VERSION}" "${SUPERVISOR}:latest"

# Install Plugins
docker pull "${CLI}:${CLI_VERSION}"
docker pull "${DNS}:${DNS_VERSION}"
docker pull "${AUDIO}:${AUDIO_VERSION}"
docker pull "${MULTICAST}:${MULTICAST_VERSION}"
docker pull "${OBSERVER}:${OBSERVER_VERSION}"

# Install landing page
docker pull "${LANDINGPAGE}"

# Setup AppArmor
mkdir -p "/mnt/data/supervisor/apparmor"
curl -sL -o "/mnt/data/supervisor/apparmor/oppio-supervisor" "${APPARMOR_URL}"

# Finish
kill $DOCKER_PID && wait $DOCKER_PID

# Unmount resource
if ! umount /mnt/data; then
    umount -f /mnt/data || echo "umount force fails!"
fi

exit 0
