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

get_ih_dcrc() 
{
	(get_image "$@" | dd bs=4 skip=6 count=1 | hexdump -v -n 4 -e '1/1 "%02x"') 2>/dev/null
}

get_ih_size() 
{
	(get_image "$@" | dd bs=4 skip=3 count=1 | hexdump -v -n 4 -e '1/1 "%02x"') 2>/dev/null
}
ckcrc32_ih_dcrc() 
{
	local ih_size=0x"$(get_ih_size "$1")"
	ih_size=$(printf "%d" $ih_size)
	
	(( get_image "$@" | dd bs=1 skip=64 count=$ih_size ) | gzip -1 | tail -c 8 | head -c 4 | hexdump -e '1/4 "%08x"') 2>/dev/null
}

# determine size of the main firmware partition
platform_get_firmware_size() 
{
	local dev size erasesize name
	while read dev size erasesize name; do
		name=${name#'"'}; name=${name%'"'}
		case "$name" in
			firmware*)
				printf "%d" "0x$size"
				break
			;;
		esac
	done < /proc/mtd
}

get_filesize() 
{
	wc -c "$1" | while read image_size _n ; do echo $image_size ; break; done
}

platform_check_image_lds() 
{
	local ih_magic="$(get_ih_magic "$1")"
	
	case "$ih_magic" in
	"27051956")
		
		local ih_hcrc_n="$(get_ih_hcrc "$1")"
		local ih_hcrc_h=$(constant_swap32 $ih_hcrc_n)
		local ih_hcrc_ck="$(ckcrc32_ih_hcrc "$1")"
		
		[ "$ih_hcrc_ck" != "$ih_hcrc_h" ] && {
			echo "ih_hcrc mismatch ih_hcrc_ck:$ih_hcrc_ck ih_hcrc_h:$ih_hcrc_h"
			return 1
		}
		
		local ih_dcrc_n="$(get_ih_dcrc "$1")"
		local ih_dcrc_h=$(constant_swap32 $ih_dcrc_n)
		local ih_dcrc_ck="$(ckcrc32_ih_dcrc "$1")"
		
		[ "$ih_dcrc_ck" != "$ih_dcrc_h" ] && {
			echo "ih_dcrc mismatch ih_dcrc_ck:$ih_dcrc_ck ih_dcrc_h:$ih_dcrc_h"
			return 1
		}
		
		local image_size=$( get_filesize "$1" )
		local firmware_size=$( platform_get_firmware_size )
		
		[ $image_size -ge $firmware_size ] && {
			echo "upgrade image is too big (${image_size}B > ${firmware_size}B)"
			return 1
		}
		
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


lds_get_target_firmware() 
{
	cur_boot_part=`/usr/sbin/fw_printenv -n bootslot`
	target_firmware=""
	if [ "$cur_boot_part" = "0" ]
	then
		# current primary boot - update alt boot
		target_firmware="firmware1"
	elif [ "$cur_boot_part" = "1" ]
	then
		# current alt boot - update primary boot
		target_firmware="firmware0"
	fi
	
	echo "$target_firmware"
}

platform_do_upgrade_lds() 
{
	echo "Performing platform_do_upgrade_lds ..."
	
	mkdir -p /var/lock
	local part_label="$(lds_get_target_firmware)"
	touch /var/lock/fw_printenv.lock
	
	if [ ! -n "$part_label" ]
	then
		echo "cannot find target partition"
		exit 1
	fi
	
	GOT_SYSUPGRADE_BIN="/tmp/sysupgrade.bin"
	
	get_image "$1" > $GOT_SYSUPGRADE_BIN
	
	mtd erase $part_label
	mtd -n write $GOT_SYSUPGRADE_BIN $part_label
	
	local STRING=$(mtd verify $GOT_SYSUPGRADE_BIN $part_label 2>&1)
	local SUBSTRING="Success"
	if test "${STRING#*$SUBSTRING}" != "$STRING"
	then
		echo "Verifying mtd is SUCCESS"
		
		local cur_boot_part=`/usr/sbin/fw_printenv -n bootslot`
		if [ "$cur_boot_part" = "0" ]
		then
			fw_setenv bootslot 1
		elif [ "$cur_boot_part" = "1" ]
		then
			fw_setenv bootslot 0
		fi
		
	else
		echo "Verifying mtd is FAILED"
	fi	

}
