#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=subdevice
PKG_SOURCE_PROTO:=git
PKG_BRANCH:=master
PKG_RELEASE:=1.0
PKG_SOURCE_URL:=http://192.168.5.29:8090/gateway/subdevice.git

PKG_MAINTAINER:=louis <zhanghuawei@leedarson.com>
PKG_LICENSE:=LGPL-2.1

LOCAL_SRC:=$(TOPDIR)/qca/src/subdevice
include $(INCLUDE_DIR)/local-development.mk

ifeq ($(DUMP)$(PKG_VERSION),)
  PKG_REV:=$(shell git ls-remote $(PKG_SOURCE_URL) $(PKG_BRANCH) | cut -b -7)
  PKG_VERSION:=g$(PKG_REV)
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)

LOCAL_VARIANT=$(patsubst subdevice-%,%,$(patsubst subdevice-%,%,$(BUILD_VARIANT)))

include $(INCLUDE_DIR)/package-seccomp.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/$(PKG_NAME)
	SECTION:=leedarson
	CATEGORY:=Leedarson
	TITLE:=Subdevice Management 
	DEPENDS:=+libjson-c +libsqlite3 +libuci +libubox +libubus +libblobmsg-json +libmosquitto +libpthread +librt +libopenssl +libuuid +zware
endef

#define Package/$(PKG_NAME)/config
	#source "$(SOURCE)/Config.in"
#endef

define Package/$(PKG_NAME)/description
	subdevice management daemon
endef

#ifeq ($(CONFIG_SUBDEVICE_ZWAVE_ENABLE),y)
	#TARGET_CFLAGS += -DZWAVE_ENABLE 
#endif

ifeq ($(CONFIG_TARGET_ar71xx_generic_LDS_G151),y)
	TARGET_CFLAGS += -DZIGBEE_BRANCH_A023 
endif

ifeq ($(CONFIG_TARGET_ar71xx_generic_LDS_G152),y)
	TARGET_CFLAGS += -DZIGBEE_BRANCH_A023 
endif

ifeq ($(CONFIG_TARGET_ar71xx_generic_LDS_G402),y)
	TARGET_CFLAGS += -DZIGBEE_BRANCH_MULTIPLE 
	TARGET_CFLAGS += -DZWAVE_ENABLE
endif

ifeq ($(CONFIG_TARGET_ar71xx_generic_LDS_G104),y)
	TARGET_CFLAGS += -DZIGBEE_BRANCH_EDU 
endif

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d $(1)/etc/config $(1)/etc/subdevice
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/subdevice $(1)/usr/bin/
	$(INSTALL_BIN) ./files/subdevice.init $(1)/etc/init.d/subdevice
	$(INSTALL_CONF) ./files/subdevice.config $(1)/etc/config/subdevice
	$(INSTALL_CONF) ./files/devbink.json $(1)/etc/subdevice/
	$(INSTALL_CONF) ./files/devbink_edu.json $(1)/etc/subdevice/
	$(INSTALL_CONF) ./files/zwave_device_rec.txt $(1)/etc/subdevice/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
