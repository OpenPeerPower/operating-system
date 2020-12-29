################################################################################
#
# Bluetooth BCM43xx
#
################################################################################

BLUETOOTH_BCM43XX_VERSION = 1.0.0
BLUETOOTH_BCM43XX_LICENSE = Apache License 2.0
BLUETOOTH_BCM43XX_LICENSE_FILES = $(BR2_EXTERNAL_HASSOS_PATH)/../LICENSE
BLUETOOTH_BCM43XX_SITE = $(BR2_EXTERNAL_HASSOS_PATH)/package/bluetooth-bcm43xx
BLUETOOTH_BCM43XX_SITE_METHOD = local

define BLUETOOTH_BCM43XX_BUILD_CMDS
	curl -L -o $(@D)/BCM43430A1.hcd https://raw.githubusercontent.com/RPi-Distro/bluez-firmware/a4e08822e3f24a6211f6ac94bc98b7ef87700c70/broadcom/BCM43430A1.hcd
	curl -L -o $(@D)/BCM4345C0.hcd https://raw.githubusercontent.com/RPi-Distro/bluez-firmware/a4e08822e3f24a6211f6ac94bc98b7ef87700c70/broadcom/BCM4345C0.hcd
	curl -L -o $(@D)/btuart https://raw.githubusercontent.com/RPi-Distro/pi-bluetooth/cbdbcb66bcc5b9af05f1a9fffe2254c872bb0ace/usr/bin/btuart
	curl -L -o $(@D)/bthelper https://raw.githubusercontent.com/RPi-Distro/pi-bluetooth/cbdbcb66bcc5b9af05f1a9fffe2254c872bb0ace/usr/bin/bthelper
	curl -L -o $(@D)/90-pi-bluetooth.rules https://raw.githubusercontent.com/RPi-Distro/pi-bluetooth/cbdbcb66bcc5b9af05f1a9fffe2254c872bb0ace/lib/udev/rules.d/90-pi-bluetooth.rules

	patch $(@D)/btuart $(@D)/0001-btuart-reduced-baud-rate-rpi3b.patch
endef

define BLUETOOTH_BCM43XX_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/etc/systemd/system/hassos-hardware.target.wants
	$(INSTALL) -m 0644 $(@D)/bluetooth-bcm43xx.service $(TARGET_DIR)/usr/lib/systemd/system/
	$(INSTALL) -m 0644 $(@D)/bthelper@.service $(TARGET_DIR)/usr/lib/systemd/system/

	$(INSTALL) -d $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/btuart $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 $(@D)/bthelper $(TARGET_DIR)/usr/bin/

	$(INSTALL) -d $(TARGET_DIR)/lib/firmware/brcm
	$(INSTALL) -m 0644 $(@D)/*.hcd $(TARGET_DIR)/lib/firmware/brcm/

	$(INSTALL) -d $(TARGET_DIR)/usr/lib/udev/rules.d
	$(INSTALL) -m 0644 $(@D)/90-pi-bluetooth.rules $(TARGET_DIR)/usr/lib/udev/rules.d/
endef

$(eval $(generic-package))
