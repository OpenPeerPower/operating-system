#!/bin/bash

function oppos_image_name() {
    echo "${BINARIES_DIR}/${OPPOS_ID}_${BOARD_ID}-$(oppos_version).${1}"
}

function oppos_rauc_compatible() {
    echo "${OPPOS_ID}-${BOARD_ID}"
}

function oppos_version() {
    if [ -z "${VERSION_DEV}" ]; then
        echo "${VERSION_MAJOR}.${VERSION_BUILD}"
    else
        echo "${VERSION_MAJOR}.${VERSION_BUILD}.${VERSION_DEV}"
    fi
}

function path_spl_img() {
    echo "${BINARIES_DIR}/spl.img"
}

function path_kernel_img() {
    echo "${BINARIES_DIR}/kernel.ext4"
}

function path_boot_img() {
    echo "${BINARIES_DIR}/boot.vfat"
}

function path_boot_dir() {
    echo "${BINARIES_DIR}/boot"
}

function path_data_img() {
    echo "${BINARIES_DIR}/data.ext4"
}

function path_overlay_img() {
    echo "${BINARIES_DIR}/overlay.ext4"
}

function path_rootfs_img() {
    echo "${BINARIES_DIR}/rootfs.squashfs"
}

