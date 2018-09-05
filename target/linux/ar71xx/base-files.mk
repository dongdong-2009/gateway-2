define Package/base-files/install-target
	rm -f $(1)/etc/config/network

	for inittab in $(1)/etc/inittab*; do \
		if [ -f "$$$$inittab" ]; then \
			rm -f "$$$$inittab"; \
		fi \
	done

ifeq ($(CONFIG_TARGET_ar71xx_generic_LDS_G104),y)

	if [ -f $(PLATFORM_DIR)/base-files/etc/inittab_lds_g104 ]; then \
		$(CP) $(PLATFORM_DIR)/base-files/etc/inittab_lds_g104 $(1)/etc/inittab; \
	fi

endif

ifeq ($(CONFIG_TARGET_ar71xx_generic_LDS_G151),y)

	if [ -f $(PLATFORM_DIR)/base-files/etc/inittab_lds_g151 ]; then \
		$(CP) $(PLATFORM_DIR)/base-files/etc/inittab_lds_g151 $(1)/etc/inittab; \
	fi

endif

	if [ ! -e $(1)/etc/inittab ]; then \
		$(CP) $(PLATFORM_DIR)/base-files/etc/inittab $(1)/etc/inittab; \
	fi

endef
