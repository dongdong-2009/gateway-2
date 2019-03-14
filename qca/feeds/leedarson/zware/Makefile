#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=zware
PKG_SOURCE_PROTO:=git
PKG_BRANCH:=master
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://192.168.5.29:8090/gateway/zware.git

PKG_LICENSE:=LGPL-2.1

LOCAL_SRC:=$(TOPDIR)/qca/src/lds-zware
include $(INCLUDE_DIR)/local-development.mk

ifeq ($(DUMP)$(PKG_VERSION),)
  PKG_REV:=$(shell git ls-remote $(PKG_SOURCE_URL) $(PKG_BRANCH) | cut -b -7)
  PKG_VERSION:=g$(PKG_REV)
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)

LOCAL_VARIANT=$(patsubst zware-%,%,$(patsubst zware-%,%,$(BUILD_VARIANT)))

PKG_MAINTAINER:=yjm

include $(INCLUDE_DIR)/package-seccomp.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/$(PKG_NAME)
	SECTION:=leedarson
	CATEGORY:=Leedarson
	TITLE:= Z-Ware Library
	DEPENDS:=+libopenssl +libpthread +librt +libblobmsg-json +libubox +libubus +libjson-c
endef

define Package/$(PKG_NAME)/config
	source "$(SOURCE)/Config.in"
endef

define Package/$(PKG_NAME)/description
	The Z-Ware Library is a Z/IP (Z-Wave over Internet Protocol) Gateway (ZIPGW) client and abstracts
Z-Wave Command Classes (CC) into controllable and monitorable interfaces over a C API (Application
Programming Interface) for easier development and certification of Z-Wave controller applications. One
such Z-Ware Library Client is the Z-Ware Web Server.
endef


define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/app/zware.h $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/app/libzware.a $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/zware/libzwareapi.a $(1)/usr/lib/
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR)	$(1)/etc/zware $(1)/usr/bin
ifeq ($(CONFIG_ZWAVE_FW_US),y)
	$(INSTALL_BIN)	./files/firmware_us.bin $(1)/etc/zware/firmware.bin
endif
ifeq ($(CONFIG_ZWAVE_FW_EU),y)
	$(INSTALL_BIN)	./files/firmware_eu.bin $(1)/etc/zware/firmware.bin
endif
	$(INSTALL_BIN)	$(PKG_BUILD_DIR)/app/zware_test $(1)/usr/bin/zware_test
	$(INSTALL_BIN) 	$(PKG_BUILD_DIR)/app/ZWFactoryTest $(1)/usr/bin/ZWFactoryTest
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

