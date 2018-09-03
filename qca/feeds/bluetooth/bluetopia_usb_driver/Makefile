include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=bluetopia-usb-driver
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE:=bluetopia-drivers-3890508aa49701d039879dfa83cde552f938afb2.tar.bz2
PKG_SOURCE_SUBDIR:=bluetopia-drivers
PKG_SOURCE_URL:=git://codeaurora.org/external/bluetopia-drivers/linux
PKG_SOURCE_VERSION:=3890508aa49701d039879dfa83cde552f938afb2
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)


export C_FLAGS:=$(TARGET_CFLAGS)
export LD_FLAGS:=$(TARGET_LDFLAGS)

include $(INCLUDE_DIR)/package.mk

define KernelPackage/$(PKG_NAME)
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=USB Support
  TITLE:=QCA Bluetopia USB driver
  DEPENDS:=+kmod-usb-core
  FILES:=$(PKG_BUILD_DIR)/SS1BTUSB/SS1BTUSBM.ko
endef

define KernelPackage/$(PKG_NAME)/description
  This package contains Bleutopia USB driver
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/SS1BTUSB \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		ARCH="$(LINUX_KARCH)" \
		KERNELDIR="$(LINUX_DIR)" \
		EXTRA_CFLAGS="$(EXTRA_CFLAGS)" modules
endef

define KernelPackage/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/lib/bluetopia-usb-driver
	$(INSTALL_DATA) ./files/bind_driver.sh $(1)/lib/bluetopia-usb-driver/bind-driver.sh
endef

$(eval $(call KernelPackage,$(PKG_NAME)))
