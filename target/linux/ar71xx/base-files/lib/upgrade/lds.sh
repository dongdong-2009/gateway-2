# Copyright (c) 2015 The Linux Foundation. All rights reserved.
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

get_ih_magic() 
{
	(get_image "$@" | dd bs=4 count=1 | hexdump -v -n 4 -e '1/1 "%02x"') 2>/dev/null
}

get_ih_hcrc() 
{
	(get_image "$@" | dd bs=4 skip=1 count=1 | hexdump -v -n 4 -e '1/1 "%02x"') 2>/dev/null
}

ckcrc32_ih_hcrc() 
{
	(( get_image "$@" | dd bs=4 count=1; \
	dd if=/dev/zero bs=4 count=1;\
	get_image "$@" | dd bs=4 skip=2 count=14; ) | gzip -1 | tail -c 8 | head -c 4 | hexdump -e '1/4 "%08x"') 2>/dev/null
}

constant_swap32()
{
	local x=0x"$1"
	
	local x0=$(( $(( $x & 0xff000000 )) >> 24 ))
	local x1=$(( $(( $x & 0x00ff0000 )) >> 8  ))
	local x2=$(( $(( $x & 0x0000ff00 )) << 8  ))
	local x3=$(( $(( $x & 0x000000ff )) << 24 ))
	
	local r=$(( $x0 | $x1 | $x2 | $x3 ))
	
	printf "%08x" $r
}

platform_check_image_lds() 
{
	local ih_magic="$(get_ih_magic "$1")"
	
	case "$ih_magic" in
	"27051956")
		echo "It is linux header magic. " "$ih_magic"
		
		local ih_hcrc_n="$(get_ih_hcrc "$1")"
		local ih_hcrc_h=$(constant_swap32 $ih_hcrc_n)
		local ih_crc32="$(ckcrc32_ih_hcrc "$1")"
		
		echo "ih_hcrc_n: $ih_hcrc_n ih_hcrc_h: $ih_hcrc_h ih_crc32:$ih_crc32"
		
		[ "$ih_crc32" != "$ih_hcrc_h" ] && {
			echo "ih_hcrc mismatch ih_crc32:$ih_crc32 ih_hcrc_h: $ih_hcrc_h"
			return 1
		}
		
		
		
		
		;;
	"43493030")
		echo "Unsupported. This is a test."
		return 1
		;;
	*)
		echo "Unsupported image format."
		return 1
		;;
	esac

	return 0
}


# make sure we got the tools we need during the fw upgrade process
platform_add_ramfs_lds_tools()
{
	install_bin /usr/sbin/fw_printenv /usr/sbin/fw_setenv
	install_bin /bin/busybox /usr/bin/cut /usr/bin/sed /usr/bin/head
	install_bin /usr/bin/md5sum
	install_bin /usr/sbin/nandwrite
	install_bin /usr/sbin/ubiattach
	install_bin /usr/sbin/ubidetach
	install_file /etc/fw_env.config
}
append sysupgrade_pre_upgrade platform_add_ramfs_lds_tools

platform_do_upgrade_lds() 
{
	echo "Performing system upgrade..."
	
}
