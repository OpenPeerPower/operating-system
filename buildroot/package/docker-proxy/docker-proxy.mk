################################################################################
#
# docker-proxy
#
################################################################################

DOCKER_PROXY_VERSION = 1ea375d2b54d2e914e41970a04553ad55ef39b62
DOCKER_PROXY_SITE = $(call github,moby,libnetwork,$(DOCKER_PROXY_VERSION))

DOCKER_PROXY_LICENSE = Apache-2.0
DOCKER_PROXY_LICENSE_FILES = LICENSE

DOCKER_PROXY_DEPENDENCIES = host-pkgconf

DOCKER_PROXY_BUILD_TARGETS = cmd/proxy

define DOCKER_PROXY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/proxy $(TARGET_DIR)/usr/bin/docker-proxy
endef

$(eval $(golang-package))
