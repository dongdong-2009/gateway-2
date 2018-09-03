include $(TOPDIR)/rules.mk

PKG:=sigma-dut
PKG_NAME:=sigma-dut-open
PKG_VERSION:=20170223
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/qca/sigma-dut.git
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG)-$(PKG_VERSION)

WIFI_ath9k:=PACKAGE_kmod-ath9k
WIFI_ath10k:=PACKAGE_kmod-ath10k
WIFI_OPEN:=$(WIFI_ath9k)||$(WIFI_ath10k)


include $(INCLUDE_DIR)/local-development.mk
include $(INCLUDE_DIR)/package-version-override.mk

ifeq ($(DUMP)$(PKG_VERSION),)
  PKG_REV:=$(shell git ls-remote $(PKG_SOURCE_URL) $(PKG_BRANCH) | cut -b -7)
  PKG_VERSION:=g$(PKG_REV)
endif

PKG_SOURCE_SUBDIR:=$(PKG)-$(PKG_VERSION)
PKG_SOURCE_VERSION=9981b5112d07252e27d59665460dd08a442de8bc
PKG_SOURCE:=$(PKG)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=QCA
  CATEGORY:=QCA software
  DEPENDS:=+libpthread @$(WIFI_OPEN)
  TITLE:=Sigma DUT
endef

define Package/$(PKG_NAME)/description
  $(PKG_NAME) is a control agent for automating Wi-Fi Alliance certification tests
endef

define Package/$(PKG_NAME)/config
$(call Package/$(PKG_NAME)/override_source_path,$(PKG_NAME))
$(call Package/$(PKG_NAME)/override_version,$(PKG_NAME),$(PKG_SUPPORTED_VERSION))
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/sigma_dut $(1)/usr/sbin
	$(INSTALL_BIN) ./files/sigma_dut.init $(1)/etc/init.d/$(PKG)
	$(INSTALL_BIN) ./files/$(PKG).config $(1)/etc/config/$(PKG)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
