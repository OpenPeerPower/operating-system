################################################################################
#
# OppOS
#
################################################################################

OPPIO_VERSION = 1.0.0
OPPIO_LICENSE = Apache License 2.0
OPPIO_LICENSE_FILES = $(BR2_EXTERNAL_OPPOS_PATH)/../LICENSE
OPPIO_SITE = $(BR2_EXTERNAL_OPPOS_PATH)/package/oppio
OPPIO_SITE_METHOD = local

define OPPIO_BUILD_CMDS
	docker build --tag oppos-hostapps $(@D)/builder
endef

define OPPIO_INSTALL_TARGET_CMDS
	docker run --rm --privileged \
		-e BUILDER_UID="$(shell id -u)" -e BUILDER_GID="$(shell id -g)" \
		-v $(BINARIES_DIR):/export \
		oppos-hostapps \
		--arch $(BR2_PACKAGE_OPPIO_ARCH) \
		--machine $(BR2_PACKAGE_OPPIO_MACHINE)
endef

$(eval $(generic-package))
