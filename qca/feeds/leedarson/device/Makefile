#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=device
PKG_SOURCE_PROTO:=git
PKG_BRANCH:=develop
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://192.168.5.29:8090/gateway/device.git

PKG_LICENSE:=LGPL-2.1

LOCAL_SRC:=$(TOPDIR)/qca/src/lds-device
include $(INCLUDE_DIR)/local-development.mk

ifeq ($(DUMP)$(PKG_VERSION),)
  PKG_REV:=$(shell git ls-remote $(PKG_SOURCE_URL) $(PKG_BRANCH) | cut -b -7)
  PKG_VERSION:=g$(PKG_REV)
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)

LOCAL_VARIANT=$(patsubst device-%,%,$(patsubst device-%,%,$(BUILD_VARIANT)))

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk



define Package/device
	SECTION:=leedarson
	CATEGORY:=Leedarson
	TITLE:=device Utility
	DEPENDS:=+libjson-c +libuci +libubox +libubus +libblobmsg-json
endef

define Package/device/config
	source "$(SOURCE)/Config.in"
endef

define Package/device/description
	device utility 
endef


ifeq ($(CONFIG_DEVICE_WITH_SIREN_HUB),y)
	TARGET_CFLAGS += -DDEVICE_WITH_SIREN_HUB
endif


define Package/device/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d $(1)/etc/config $(1)/etc/device
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/device $(1)/usr/bin/
	$(INSTALL_BIN) ./files/device.init $(1)/etc/init.d/device
	$(INSTALL_BIN) ./files/device_watch.sh $(1)/usr/bin/
	$(INSTALL_CONF) ./files/device.config $(1)/etc/config/device
endef

$(eval $(call BuildPackage,device))

