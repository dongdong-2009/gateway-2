#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=zipgateway
PKG_SOURCE_PROTO:=git
PKG_BRANCH:=master
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://192.168.5.29:8090/gateway/zipgateway.git

PKG_LICENSE:=LGPL-2.1

LOCAL_SRC:=$(TOPDIR)/qca/src/lds-zipgateway
include $(INCLUDE_DIR)/local-development.mk

ifeq ($(DUMP)$(PKG_VERSION),)
  PKG_REV:=$(shell git ls-remote $(PKG_SOURCE_URL) $(PKG_BRANCH) | cut -b -7)
  PKG_VERSION:=g$(PKG_REV)
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)

LOCAL_VARIANT=$(patsubst device-%,%,$(patsubst device-%,%,$(BUILD_VARIANT)))

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk



# Specify package information for this program. 
# The variables defined here should be self explanatory.
# If you are running Kamikaze, delete the DESCRIPTION 
# variable below and uncomment the Kamikaze define
# directive for the description below

#CONFIG_GCC_VERSION


define Package/zipgateway
	SECTION:=leedarson
	CATEGORY:=Leedarson
	TITLE:=ZIP Router for Z-Wave Devices
	DEPENDS:=+kmod-tun +kmod-ipv6 +ip +libopenssl +libusb-1.0
endef


# Uncomment portion below for Kamikaze and delete DESCRIPTION variable above
define Package/zipgateway/description
	ZIP Router for Z-Wave Devices. Make a possible to Z-Wave Devices to reach internet.
endef


# Specify what needs to be done to prepare for building the package.
# In our case, we need to copy the source files to the build directory.
# This is NOT the default.  The default uses the PKG_SOURCE_URL and the
# PKG_SOURCE which is not defined here to download the source from the web.
# In order to just build a simple program that we have just written, it is
# much easier to do it this way.



# This helps to remove dead code from the binrary.
#
#TARGET_CFLAGS+=-fdata-sections -ffunction-sections
#TARGET_LDFLAGS+=--gc-
define Build/Compile
	$(call Build/Compile/Default, \
		CC=$(TARGET_CC) LD=$(TARGET_CC)  )
endef

define Package/zipgateway/install
	$(INSTALL_DIR) $(1)/usr/lib/lua $(1)/usr/bin $(1)/etc $(1)/etc/init.d $(1)/etc/config 
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/zipgateway $(1)/usr/bin/zipgateway
	$(INSTALL_BIN)  ./files/zipgateway.init $(1)/etc/init.d/zipgateway
	$(INSTALL_BIN)  ./files/zipgateway.tun $(1)/etc/zipgateway.tun
	$(INSTALL_BIN)  ./files/zipgateway.fin $(1)/etc/zipgateway.fin
	$(INSTALL_CONF) ./files/zipgateway.cfg $(1)/etc/zipgateway.cfg
	$(INSTALL_CONF) ./files/zipgateway.config $(1)/etc/config/zipgateway

	sed -i "s/@NAME@/zipgateway/g" $(1)/etc/config/zipgateway
	sed -i "s/@NAME@/zipgateway/g" $(1)/etc/init.d/zipgateway

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/admin $(1)/usr/lib/lua/luci/model/cbi/zipgateway
	$(INSTALL_BIN) files/luci/controller/admin/zipgateway.lua $(1)/usr/lib/lua/luci/controller/admin/zipgateway.lua
	$(INSTALL_BIN) files/luci/model/cbi/zipgateway/setup.lua $(1)/usr/lib/lua/luci/model/cbi/zipgateway/setup.lua
	sed -i "s/@NAME@/zipgateway/g" $(1)/usr/lib/lua/luci/controller/admin/zipgateway.lua
	sed -i "s/@NAME@/zipgateway/g" $(1)/usr/lib/lua/luci/model/cbi/zipgateway/setup.lua

	$(INSTALL_CONF) ./files/ZIPR.x509_1024.pem $(1)/etc/zipgateway.x509_1024.pem
	$(INSTALL_CONF) ./files/ZIPR.key_1024.pem $(1)/etc/zipgateway.key_1024.pem
	$(INSTALL_CONF) ./files/Portal.ca_x509.pem $(1)/etc/zipgateway.CA_x509.pem
endef


# This line executes the necessary commands to compile our program.
# The above define directives specify all the information needed, but this
# line calls BuildPackage which in turn actually uses this information to
# build a package.
$(eval $(call BuildPackage,zipgateway,+libopenssl))