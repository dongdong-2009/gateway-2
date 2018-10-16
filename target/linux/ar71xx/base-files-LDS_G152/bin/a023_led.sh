#!/bin/sh
# Copyright (C) 2015 fanp

. /lib/functions.sh

usage() {
    cat <<EOF
Usage: $0 [restart]
enables (default), disables or detects a wifi led configuration.
EOF
	exit 1
}

wifiApCount=0;
wifiStaCount=0;
wifiIfnCount=0;
handle_interface() { 
	local config="$1" 
	local custom="$2" 
	local ifmode 
	local ifndisable="" 
	
	config_get ifmode "$config" mode 
	config_get ifndisable "$config" disabled 
	if [ "$ifmode" == "ap" -a "$ifndisable" != "1" ]; then
		wifiApCount=`expr $wifiApCount + 1`
	fi 
	if [ "$ifmode" == "sta" -a "$ifndisable" != "1" ]; then
		wifiStaCount=`expr $wifiStaCount + 1`
	fi
	wifiIfnCount=`expr $wifiIfnCount + 1`
} 

wifi_run()
{
	config_load wireless 
	config_foreach handle_interface wifi-iface led
	if [ $wifiStaCount -gt 0 ];then
		/bin/ledsaction.sh sta wlan0-1
		echo "wifi sta runing"
	elif [ $wifiApCount -gt 0 ];then
		/bin/ledsaction.sh ap wlan0
		echo "wifi ap runing"
	fi
}

case "$1" in
	restart) wifi_run "$@";;
	--help|help) usage;;
	*) echo "The operation of the unknown!";;
esac

exit 0


