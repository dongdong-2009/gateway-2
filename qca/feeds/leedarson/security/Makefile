#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=security
PKG_SOURCE_PROTO:=git
PKG_BRANCH:=master
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://192.168.5.29:8090/gateway/security.git

PKG_LICENSE:=LGPL-2.1

LOCAL_SRC:=$(TOPDIR)/qca/src/lds-security
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



define Package/$(PKG_NAME)
  SECTION:=leedarson
  CATEGORY:=Leedarson
  TITLE:= gateway security module
  URL:=http://www.leedarson.com/
  MAINTAINER:=yjm
  DEPENDS:=+libblobmsg-json +libubox +libubus +libpthread +libjson-c +libstdcpp
endef

#TARGET_CFLAGS += -I$(LINUX_DIR)/include -I$(LINUX_DIR)/include/linux -L$(STAGING_DIR)/usr/lib 
TARGET_CFLAGS += -L$(STAGING_DIR)/root-ar71xx/usr/lib

define Package/$(PKG_NAME)/description
  gateway security module
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/usr/lib $(1)/etc/init.d
	$(INSTALL_BIN) ./files/security.init $(1)/etc/init.d/security
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/security $(1)/usr/bin/security
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ubus_sub $(1)/usr/bin/sec_sub
	$(INSTALL_BIN) ./files/ubus_sub.sh $(1)/usr/bin/ubus_sub
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
