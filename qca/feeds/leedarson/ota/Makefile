#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ota
PKG_SOURCE_PROTO:=git
PKG_BRANCH:=develop
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://192.168.5.29:8090/gateway/ota.git

LOCAL_SRC:=$(TOPDIR)/qca/src/lds-ota
include $(INCLUDE_DIR)/local-development.mk

ifeq ($(DUMP)$(PKG_VERSION),)
  PKG_REV:=$(shell git ls-remote $(PKG_SOURCE_URL) $(PKG_BRANCH) | cut -b -7)
  PKG_VERSION:=g$(PKG_REV)
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_MAINTAINER:=yangyiguo <yangyiguo@leedarson.com>

LOCAL_VARIANT=$(patsubst chron-%,%,$(patsubst chron-%,%,$(BUILD_VARIANT)))

include $(INCLUDE_DIR)/package-seccomp.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/ota
	SECTION:=leedarson
	CATEGORY:=Leedarson
	TITLE:=OTA Management 
	DEPENDS:=+libjson-c +libsqlite3 +libuci +libubox +libubus +libblobmsg-json +libmosquitto +libpthread +librt +libopenssl +libuuid +libcurl +libz
endef 

define Package/ota/config
	source "$(SOURCE)/Config.in"
endef

define Package/ota/description
	ota management daemon
endef

ifeq ($(CONFIG_OTA_G151_ENABLE),y)
	TARGET_CFLAGS += -DFIRMWARE_MODEL_G151
endif

ifeq ($(CONFIG_OTA_G152_ENABLE),y)
	TARGET_CFLAGS += -DFIRMWARE_MODEL_G152
endif

ifeq ($(CONFIG_OTA_G104_ENABLE),y)
	TARGET_CFLAGS += -DFIRMWARE_MODEL_G104 
endif

ifeq ($(CONFIG_OTA_G402_ENABLE),y)
	TARGET_CFLAGS += -DFIRMWARE_MODEL_G402
endif

define Package/ota/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ota $(1)/usr/bin/
	$(INSTALL_BIN) ./files/ota.init $(1)/etc/init.d/ota
	$(INSTALL_CONF) ./files/ota.config $(1)/etc/config/ota
endef

$(eval $(call BuildPackage,ota))
