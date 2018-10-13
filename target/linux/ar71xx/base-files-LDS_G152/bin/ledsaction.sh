#!/bin/sh
# Copyright (C) 2015 fanp

. /lib/functions.sh

usage() {
    cat <<EOF
Usage: $0 [name]
enables (default), leds configuration.
EOF
	exit 1
}

leds_ap()
{
	local ifname=$2
	uci -q set system.led_lan.trigger='timer'
	uci -q set system.led_lan.delayon='1000'
	uci -q set system.led_lan.delayoff='1000'
	uci commit system
	/etc/init.d/led restart
}

leds_sta()
{
	local ifname=$2
	uci -q set system.led_lan.trigger='netdev'
	uci -q set system.led_lan.dev="$ifname"
	uci -q set system.led_lan.mode='link tx rx'
	uci commit system
	/etc/init.d/led restart
}

leds_power()
{
	uci -q set system.led_power.trigger='default-on'
	uci commit system
	/etc/init.d/led restart
}

case "$1" in
	ap) leds_ap "$@";;
	sta) leds_sta "$@";;
	power) leds_power "$@";;
	--help|help) usage;;
	*) echo "The operation of the unknown!";;
esac

exit 0


