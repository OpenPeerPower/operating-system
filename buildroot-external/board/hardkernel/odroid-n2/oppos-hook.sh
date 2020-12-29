#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local UBOOT_G12B="${BINARIES_DIR}/u-boot.g12b"
    local SPL_IMG="$(path_spl_img)"

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    cp "${BINARIES_DIR}"/*.dtb "${BOOT_DATA}/"

    echo "console=tty0 console=ttyAML0,115200n8" > "${BOOT_DATA}/cmdline.txt"

    # SPL
    create_spl_image

	dd if="${UBOOT_G12B}" of="${SPL_IMG}" conv=notrunc bs=512 seek=1
}


function hassos_post_image() {
    convert_disk_image_xz
}

