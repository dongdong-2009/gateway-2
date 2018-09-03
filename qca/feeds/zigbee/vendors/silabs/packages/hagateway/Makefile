
include $(TOPDIR)/rules.mk

PKG_NAME:=hagateway
PKG_RELEASE=1.0

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)


include $(INCLUDE_DIR)/package.mk

define Package/hagateway
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Zigbee
  TITLE:=ZigBee Home Gateway sample applications
  DEPENDS:=+lm +lpthread +libncurses +libreadline +libuuid +mosquitto-nossl
endef

define Package/hagateway/description
  This provides the ZigBee Home Gateway sample application program.
endef

PKG_SRC_PATH = ../../src

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) -r $(PKG_SRC_PATH)/* $(PKG_BUILD_DIR)/
endef

TARGET_BUILD_ARGS= \
	-D__linux__ -D__mips__ \
	-DNO_READLINE \
	-lm -lpthread -luuid

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/ -lm -lpthread \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS) $(TARGET_CPPFLAGS)" \
	LD="$(TARGET_CROSS)gcc $(TARGET_BUILD_ARGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	AR="$(TARGET_CROSS)ar"
endef


define Package/hagateway/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) $(BUILD_DIR)/toolchain/ipkg-ar71xx/libpthread/lib/libpthread.so.0 $(1)/usr/sbin
	$(CP) $(PKG_BUILD_DIR)/app/builder/HaGatewayReference/build/exe/HaGatewayReference $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,hagateway))
