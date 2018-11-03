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

platform_do_upgrade_lds() 
{
	echo "Performing platform_do_upgrade_lds ..."
	
	local file=$1
	local name=$2
	local fw="firmware1"
	local rootfs="root-1"
	local rootfs_data="rootfs_data"
	local ubi_vol="0"
	local ubi_ctrl_dev="/dev/ubi_ctrl"
	local target_bootslot="1"
	local cur_bootslot=`/usr/sbin/fw_printenv -n bootslot`
	
	[ "$cur_bootslot" = "1" ] && {
		fw="firmware0"
		rootfs="root-0"
		target_bootslot="0"
	}
	
	sync
	
	mtd_fw=$(cat /proc/mtd |grep $fw |cut -f1 -d ":")
	mtd_dev="/dev/$mtd_fw"
	
	ubidetach -d $ubi_vol $ubi_ctrl_dev
	mtd erase $mtd_dev
	mtd_ubi_rootfs="$(cat /proc/mtd |grep $rootfs |cut -f1 -d ":"|grep -Eo '[0-9]+'|head -1)"
	dd if=$file bs=2048 | nandwrite -p $mtd_dev -
	ubiattach -m $mtd_ubi_rootfs -d $ubi_vol $ubi_ctrl_dev
	sleep 2
	mtd_ubi_rootfs_data="$(cat /proc/mtd |grep $rootfs_data |cut -f1 -d ":" | awk ' // {sub(/mtd/, "", $0);print("/dev/mtdblock"$0)}')"
	echo $mtd_ubi_rootfs_data
	mount -t jffs2 $mtd_ubi_rootfs_data /mnt
	echo $CONF_TAR
	[ -d /mnt/upper ] || mkdir /mnt/upper
	tar xzf $CONF_TAR -C /mnt/upper
	sync
	umount /mnt
	
	fw_setenv bootslot "$target_bootslot"
}
