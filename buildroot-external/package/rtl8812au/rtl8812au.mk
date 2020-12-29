################################################################################
#
# Realtek RTL8812AU driver
#
################################################################################

RTL8812AU_VERSION = cc4c64deef8090515a3dea8b709bfff0a1007d8b
RTL8812AU_SITE = $(call github,aircrack-ng,rtl8812au,$(RTL8812AU_VERSION))
RTL8812AU_LICENSE = GPL-2.0
RTL8812AU_LICENSE_FILES = COPYING
#RTL8812AU_MODULE_SUBDIRS = src

RTL8812AU_MODULE_MAKE_OPTS = \
	CONFIG_88XXAU=m \
	KVER=$(LINUX_VERSION_PROBED) \
	KSRC=$(LINUX_DIR)

$(eval $(kernel-module))
$(eval $(generic-package))
