#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=chron
PKG_VERSION:=2019-01-17
PKG_RELEASE=$(PKG_SOURCE_VERSION)
PKG_BRANCH:=develop

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=http://192.168.5.29:8090/gateway/chron.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=$(shell git ls-remote $(PKG_SOURCE_URL) $(PKG_BRANCH) | cut -f1)

PKG_MAINTAINER:=liguowang <liguowang@leedarson.com>
PKG_LICENSE:=LGPL-2.1

include $(INCLUDE_DIR)/package-seccomp.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/chron
	SECTION:=leedarson
	CATEGORY:=Leedarson
	TITLE:=Scheduled Utility
	DEPENDS:=+libjson-c +libsqlite3 +libuci +libubox +libubus +libblobmsg-json
endef

define Package/chron/description
	scheduled utility for smart.ifttt
endef

define Package/chron/conffiles
/etc/config/chron
endef

define Package/chron/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/chron $(1)/usr/bin/
	$(INSTALL_BIN) ./files/chron.init $(1)/etc/init.d/chron
	$(INSTALL_CONF) ./files/chron.config $(1)/etc/config/chron
endef

$(eval $(call BuildPackage,chron))
