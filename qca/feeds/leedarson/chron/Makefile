include $(TOPDIR)/rules.mk

PKG_NAME:=chron
PKG_SOURCE_PROTO:=git
PKG_BRANCH:=develop
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://192.168.5.29:8090/gateway/chron.git

LOCAL_SRC:=$(TOPDIR)/qca/src/lds-chron
include $(INCLUDE_DIR)/local-development.mk
ifeq ($(DUMP)$(PKG_VERSION),)
  PKG_REV:=$(shell git ls-remote $(PKG_SOURCE_URL) $(PKG_BRANCH) | cut -b -7)
  PKG_VERSION:=g$(PKG_REV)
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_MAINTAINER:=liguowang <liguowang@leedarson.com>

LOCAL_VARIANT=$(patsubst chron-%,%,$(patsubst chron-%,%,$(BUILD_VARIANT)))

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
