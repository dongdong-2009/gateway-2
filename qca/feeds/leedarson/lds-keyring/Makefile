#
# Copyright (C) 2009-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=lds-keyring
PKG_REV:=bb05e580cfd34250f554b2880d3d576c1d8cebcf
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://192.168.5.29:8090/gateway/keyring.git
PKG_SOURCE_BRANCH:=gitlab/master
PKG_SOURCE_PROTO:=git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_MIRROR_MD5SUM:=f183a6762c1d4b86ac08921a6622a298

PKG_MAINTAINER:=liguowang <liguowang@leedarson.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/lds-keyring
  SECTION:=leedarson
  CATEGORY:=Leedarson
  TITLE:=Leedarson usign key for Gateway OTA
endef

define Package/lds-keyring/description
  The keyring of with the developer using and gpg public keys.
endef

Build/Compile=

define Package/lds-keyring/install
	$(INSTALL_DIR) $(1)/etc/opkg/keys/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/usign/* $(1)/etc/opkg/keys/
endef

$(eval $(call BuildPackage,lds-keyring))
