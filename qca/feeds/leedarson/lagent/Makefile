include $(TOPDIR)/rules.mk

PKG_NAME:=lagent
PKG_SOURCE_PROTO:=git
PKG_BRANCH:=develop
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://192.168.5.29:8090/gateway/lagent.git

LOCAL_SRC:=$(TOPDIR)/qca/src/lds-lagent
include $(INCLUDE_DIR)/local-development.mk

ifeq ($(DUMP)$(PKG_VERSION),)
  PKG_REV:=$(shell git ls-remote $(PKG_SOURCE_URL) $(PKG_BRANCH) | cut -b -7)
  PKG_VERSION:=g$(PKG_REV)
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_MAINTAINER:=liguowang <liguowang@leedarson.com>

LOCAL_VARIANT=$(patsubst lagent-%,%,$(patsubst lagent-%,%,$(BUILD_VARIANT)))

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/lagent
	SECTION:=leedarson
	CATEGORY:=Leedarson
	TITLE:= Communication for LAN/CLOUD/LOCAL
	DEPENDS:=+libopenssl +libjson-c +libsqlite3 +libubox +libubus +libblobmsg-json +libmosquitto +libuuid +libustream-openssl +libuci +libcurl
endef

define Package/lagent/description
	Device agent is a program running on device to execute user demand. Moreover, it can
parse and execute pre-set smart home commands in right time right place. Device agent will
also notify user when a predicted situation was happen.
endef

define Package/lagent/conffiles
/etc/config/lagent
endef

define Package/lagent/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/lagent $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/lagent.init $(1)/etc/init.d/lagent
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/lagent.config $(1)/etc/config/lagent
	$(INSTALL_DIR) $(1)/etc/lagent
	$(INSTALL_CONF) ./files/rootCA*.crt $(1)/etc/lagent/
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_DATA) ./files/lagent.hotplug $(1)/etc/hotplug.d/iface/26-lagent
	$(INSTALL_DIR) $(1)/usr/libexec/rpcd
	$(INSTALL_BIN) ./files/lagent.helper $(1)/usr/libexec/rpcd/lagent.helper
	$(STAGING_DIR_HOST)/bin/c_rehash  $(1)/etc/lagent/
endef

$(eval $(call BuildPackage,lagent))
