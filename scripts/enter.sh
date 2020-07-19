#!/bin/bash
BUILDER_UID="$(id -u)"
BUILDER_GID="$(id -g)"
CACHE_DIR="${CACHE_DIR:-$HOME/oppos-cache}"

sudo mkdir -p "${CACHE_DIR}"
sudo chown -R "${BUILDER_UID}:${BUILDER_GID}" "${CACHE_DIR}"
sudo docker build -t oppos:local .
sudo docker run -it --rm --privileged \
  -v "$(pwd):/build" -v "${CACHE_DIR}:/cache" \
  -e BUILDER_UID="${BUILDER_UID}" -e BUILDER_GID="${BUILDER_GID}" \
  oppos:local bash
