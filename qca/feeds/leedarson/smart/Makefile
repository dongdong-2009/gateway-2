include $(TOPDIR)/rules.mk

PKG_NAME:=smart
PKG_SOURCE_PROTO:=git
PKG_BRANCH:=init_import
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://192.168.5.29:8090/gateway/smart.git

LOCAL_SRC:=$(TOPDIR)/qca/src/lds-smart
include $(INCLUDE_DIR)/local-development.mk

ifeq ($(DUMP)$(PKG_VERSION),)
  PKG_REV:=$(shell git ls-remote $(PKG_SOURCE_URL) $(PKG_BRANCH) | cut -b -7)
  PKG_VERSION:=g$(PKG_REV)
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_MAINTAINER:=teddy zheng

LOCAL_VARIANT=$(patsubst smart-%,%,$(patsubst smart-%,%,$(BUILD_VARIANT)))

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/smart
	SECTION:=leedarson
	CATEGORY:=Leedarson
	TITLE:=smart module
	DEPENDS:=+libjson-c +libsqlite3 +libubox +libubus +libblobmsg-json +libpthread
endef

define Package/smart/description
	ifttt scene group
endef

define Package/smart/conffiles
/etc/config/smart
endef

define Package/smart/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/smart $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/proj/openwrt/files/smart.init $(1)/etc/init.d/smart
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/proj/openwrt/files/smart.config $(1)/etc/config/smart
endef

$(eval $(call BuildPackage,smart))
