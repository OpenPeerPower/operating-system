#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local BL1="${BINARIES_DIR}/bl1.bin.hardkernel"
    local UBOOT_GXBB="${BINARIES_DIR}/u-boot.gxbb"
    local SPL_IMG="$(path_spl_img)"

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    cp "${BOARD_DIR}/boot-env.txt" "${BOOT_DATA}/config.txt"
    cp "${BINARIES_DIR}/meson-gxbb-odroidc2.dtb" "${BOOT_DATA}/meson-gxbb-odroidc2.dtb"

    echo "console=tty0 console=ttyAML0,115200n8" > "${BOOT_DATA}/cmdline.txt"

    # SPL
    create_spl_image

    dd if="${BL1}" of="${SPL_IMG}" conv=notrunc bs=1 count=440
    dd if="${BL1}" of="${SPL_IMG}" conv=notrunc bs=512 skip=1 seek=1
    dd if="${UBOOT_GXBB}" of="${SPL_IMG}" conv=notrunc bs=512 seek=97
}


function hassos_post_image() {
    convert_disk_image_gz
}

