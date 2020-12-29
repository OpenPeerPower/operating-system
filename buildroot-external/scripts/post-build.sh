#!/bin/bash
# shellcheck disable=SC1090
set -e

SCRIPT_DIR=${BR2_EXTERNAL_OPPOS_PATH}/scripts
BOARD_DIR=${2}

. "${BR2_EXTERNAL_OPPOS_PATH}/meta"
. "${BOARD_DIR}/meta"

. "${SCRIPT_DIR}/rootfs-layer.sh"
. "${SCRIPT_DIR}/name.sh"
. "${SCRIPT_DIR}/rauc.sh"


# OppOS tasks
fix_rootfs
install_tini_docker
install_oppos_cli

# Write os-release
# shellcheck disable=SC2153
(
    echo "NAME=\"${OPPOS_NAME}\""
    echo "VERSION=\"$(oppos_version) (${BOARD_NAME})\""
    echo "ID=${OPPOS_ID}"
    echo "VERSION_ID=$(oppos_version)"
    echo "PRETTY_NAME=\"${OPPOS_NAME} $(oppos_version)\""
    echo "CPE_NAME=cpe:2.3:o:open_peer_power:${OPPOS_ID}:$(oppos_version):*:${DEPLOYMENT}:*:*:*:${BOARD_ID}:*"
    echo "HOME_URL=https://opp.io/"
    echo "VARIANT=\"${OPPOS_NAME} ${BOARD_NAME}\""
    echo "VARIANT_ID=${BOARD_ID}"
    echo "SUPERVISOR_MACHINE=${SUPERVISOR_MACHINE}"
    echo "SUPERVISOR_ARCH=${SUPERVISOR_ARCH}"
) > "${TARGET_DIR}/usr/lib/os-release"

# Write machine-info
(
    echo "CHASSIS=${CHASSIS}"
    echo "DEPLOYMENT=${DEPLOYMENT}"
) > "${TARGET_DIR}/etc/machine-info"


# Setup RAUC
write_rauc_config
install_rauc_certs
install_bootloader_config

# Fix overlay presets
"${HOST_DIR}/bin/systemctl" --root="${TARGET_DIR}" preset-all
