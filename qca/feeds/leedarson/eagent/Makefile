include $(TOPDIR)/rules.mk

PKG_NAME:=eagent
PKG_SOURCE_PROTO:=git
PKG_BRANCH:=develop
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://192.168.5.29:8090/gateway/eagent.git

LOCAL_SRC:=$(TOPDIR)/qca/src/lds-eagent
include $(INCLUDE_DIR)/local-development.mk

ifeq ($(DUMP)$(PKG_VERSION),)
  PKG_REV:=$(shell git ls-remote $(PKG_SOURCE_URL) $(PKG_BRANCH) | cut -b -7)
  PKG_VERSION:=g$(PKG_REV)
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_MAINTAINER:=liguowang <liguowang@leedarson.com>

LOCAL_VARIANT=$(patsubst eagent-%,%,$(patsubst eagent-%,%,$(BUILD_VARIANT)))

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/eagent
	SECTION:=leedarson
	CATEGORY:=Leedarson
	TITLE:= education gateway agent
	DEPENDS:=+libopenssl +libjson-c +libsqlite3 +libubox +libubus +libblobmsg-json +libmosquitto +libuuid +libustream-openssl +libuci
endef

define Package/eagent/description
	Device agent is a program running on device to execute user demand. Moreover, it can
parse and execute pre-set smart home commands in right time right place. Device agent will
also notify user when a predicted situation was happen.
endef

TARGET_CFLAGS += -L$(STAGING_DIR_ROOT)/usr/lib

define Package/eagent/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/eagent $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/eagent.init $(1)/etc/init.d/eagent
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/eagent.config $(1)/etc/config/eagent
	$(INSTALL_DIR) $(1)/etc/eagent
	$(INSTALL_CONF) ./files/rootCA.crt $(1)/etc/eagent/
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_DATA) ./files/eagent.hotplug $(1)/etc/hotplug.d/iface/26-eagent
	$(INSTALL_DIR) $(1)/usr/libexec/rpcd
	$(INSTALL_DATA) ./files/eagent.helper $(1)/usr/libexec/rpcd/eagent.helper
endef

$(eval $(call BuildPackage,eagent))
