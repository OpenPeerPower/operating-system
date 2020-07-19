#!/bin/bash
# shellcheck disable=SC2155

function oppos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    mkdir -p "${BOOT_DATA}/EFI/BOOT"
    mkdir -p "${BOOT_DATA}/EFI/barebox"

    cp "${BINARIES_DIR}/barebox.bin" "${BOOT_DATA}/EFI/BOOT/BOOTx64.EFI"
    cp "${BR2_EXTERNAL_OPPOS_PATH}/bootloader/barebox-state-efi.dtb" "${BOOT_DATA}/EFI/barebox/state.dtb"

    echo "console=tty1" > "${BOOT_DATA}/cmdline.txt"
}


function oppos_post_image() {
    local HDD_IMG="$(oppos_image_name img)"
    local HDD_OVA="$(oppos_image_name ova)"
    local OVA_DATA="${BINARIES_DIR}/ova"

    # Virtual Disk images
    convert_disk_image_virtual

    convert_disk_image_gz vmdk
    convert_disk_image_gz vhdx
    convert_disk_image_gz vdi
    convert_disk_image_gz qcow2

    # OVA
    mkdir -p "${OVA_DATA}"
    rm -f "${HDD_OVA}"

    cp -a ${BOARD_DIR}/open-peer-power.ovf "${OVA_DATA}/open-peer-power.ovf"
    qemu-img convert -O vmdk -o subformat=streamOptimized "${HDD_IMG}" "${OVA_DATA}/open-peer-power.vmdk"
    (cd "${OVA_DATA}"; sha256sum --tag open-peer-power.* >open-peer-power.mf)
    tar -C "${OVA_DATA}" --owner=root --group=root -cf "${HDD_OVA}" open-peer-power.ovf open-peer-power.vmdk open-peer-power.mf

    # Cleanup
    rm -f "${HDD_IMG}"
}
