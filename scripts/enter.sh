#!/bin/bash
BUILDER_UID="$(id -u)"
BUILDER_GID="$(id -g)"
CACHE_DIR="${CACHE_DIR:-$HOME/oppos-cache}"
ARGS="$*"
COMMAND="${ARGS:-bash}"

sudo mkdir -p "${CACHE_DIR}"
sudo chown -R "${BUILDER_UID}:${BUILDER_GID}" "${CACHE_DIR}"
sudo docker build -t oppos:local .

# Make sure loop devices are present before starting the container
sudo losetup -f > /dev/null

# shellcheck disable=SC2086
sudo docker run -it --rm --privileged \
  -v "$(pwd):/build" -v "${CACHE_DIR}:/cache" \
  -e BUILDER_UID="${BUILDER_UID}" -e BUILDER_GID="${BUILDER_GID}" \
  oppos:local ${COMMAND}
