define Build/Compile
	$(call Build/Compile/Default)
	$(TARGET_CC) -o $(PKG_BUILD_DIR)/cert $(PLATFORM_DIR)/src/cert.c
endef

define Package/base-files/install-target
	mkdir -p $(1)/sbin
	$(CP) $(PKG_BUILD_DIR)/cert $(1)/sbin
	rm -f $(1)/etc/config/network
endef
