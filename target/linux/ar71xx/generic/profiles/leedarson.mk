#
# Copyright (c) 2015 The Linux Foundation. All rights reserved.
#

IOE_BASE:=luci uhttpd luci-app-upnp mcproxy rp-pppoe-relay \
	  -dnsmasq dnsmasq-dhcpv6 radvd wide-dhcpv6-client bridge \
	  -swconfig luci-app-ddns ddns-scripts luci-app-qos \
	  kmod-nf-nathelper-extra kmod-ipt-nathelper-rtsp kmod-ipv6 \
	  kmod-usb2 kmod-i2c-gpio-custom kmod-button-hotplug

TEST_TOOLS:=sysstat devmem2 ethtool i2c-tools ip ip6tables iperf

WIFI_OPEN:=-kmod-ath5k -kmod-qca-ath -kmod-qca-ath9k -kmod-qca-ath10k \
	   kmod-ath kmod-ath9k hostapd hostapd-utils iwinfo wpa-supplicant-p2p \
	   wpa-cli wireless-tools -wpad-mini

define Profile/LDS_G104
	NAME:=Leedarson LDS-G104 board
	PACKAGES:=$(IOE_BASE) $(TEST_TOOLS) $(WIFI_OPEN) \
			kmod-usb-serial kmod-usb-serial-pl2303 kmod-ath10k \
			qca-legacy-uboot-lds-g104
endef

define Profile/LDS_G104/Description
	Package set optimized for the Leedarson G104 device.
	It's Leedarson Education Gateway.And its model is lds.gateway.g104
endef

$(eval $(call Profile,LDS_G104))
