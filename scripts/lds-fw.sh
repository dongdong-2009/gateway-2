#/bin/sh
#
# lds-g402 # Own Multi Protocol Gateway
# Gateway_Host_Uboot_QCA4531_CQ_LDS_DK_010700001_ZB-ControlBridge-D0000_20181011_V4.01.bin
# Gateway_Host_Uboot_QCA4531_CQ_LDS_DK_010700001_ZB-ControlBridge-D0000_20181011_V4.01.flash
# Gateway_Host_Kernel_QCA4531_CQ_LDS_DK_010700001_ZB-ControlBridge-D0000_20181011_V4.01.bin
# Gateway_Host_Rootfs_QCA4531_CQ_LDS_DK_010700001_ZB-ControlBridge-D0000_20181011_V4.01.bin
# Gateway_Host_Sysupgrage_QCA4531_CQ_LDS_DK_010700001_ZB-ControlBridge-D0000_20181011_V4.01.bin
#
# lds-g104 # Education Gateway
# Gateway_Host_Uboot_QCA4531_CQ_LDS_DK_010700006_ZB-ControlBridge-D0002_20181011_V4.01.bin
# Gateway_Host_Uboot_QCA4531_CQ_LDS_DK_010700006_ZB-ControlBridge-D0002_20181011_V4.01.flash
# Gateway_Host_Kernel_QCA4531_CQ_LDS_DK_010700006_ZB-ControlBridge-D0002_20181011_V4.01.bin
# Gateway_Host_Rootfs_QCA4531_CQ_LDS_DK_010700006_ZB-ControlBridge-D0002_20181011_V4.01.bin
# Gateway_Host_Sysupgrage_QCA4531_CQ_LDS_DK_010700006_ZB-ControlBridge-D0002_20181011_V4.01.bin
#
# lds-g151 # The Home Depot (A023)
# Gateway_Host_Uboot_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000_20180929_V2.06.bin
# Gateway_Host_Uboot_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000_20180929_V2.06.flash
# Gateway_Host_Kernel_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000_20180929_V2.06.bin
# Gateway_Host_Rootfs_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000_20180929_V2.06.bin
# Gateway_Host_Sysupgrade_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000_20180929_V2.06.bin
#
# lds-g152 # Own Siren Hub
# Gateway_Host_Uboot_QCA4531_CQ_LDS_NK_010700005_ZB-ControlBridge-D0001_20180929_V2.06.bin
# Gateway_Host_Uboot_QCA4531_CQ_LDS_NK_010700005_ZB-ControlBridge-D0001_20180929_V2.06.flash
# Gateway_Host_Kernel_QCA4531_CQ_LDS_NK_010700005_ZB-ControlBridge-D0001_20180929_V2.06.bin
# Gateway_Host_Rootfs_QCA4531_CQ_LDS_NK_010700005_ZB-ControlBridge-D0001_20180929_V2.06.bin
# Gateway_Host_Sysupgrade_QCA4531_CQ_LDS_NK_010700005_ZB-ControlBridge-D0001_20180929_V2.06.bin
#

# exit 0

DATE=`date "+%Y%m%d"`
BIN_ART=${TOPDIR}/qca/src/lds/art/MulTi_art_4531.bin
BIN_EXTEND=${TOPDIR}/qca/src/lds/extend/extend.bin

echo DATE: ${DATE}
echo TOPDIR: ${TOPDIR}
echo VERSION_NUMBER: ${VERSION_NUMBER}
echo REVISION: ${REVISION}
echo BOARD_NAME: ${BOARD_NAME}
echo BIN_UBOOT: ${BIN_UBOOT}
echo BIN_KERNEL: ${BIN_KERNEL}
echo BIN_ROOTFS: ${BIN_ROOTFS}
echo BIN_SYSUPGRADE: ${BIN_SYSUPGRADE}

TARGET_UBOOT="u-boot.bin"
TARGET_UBOOT_FLASH="u-boot.flash"
TARGET_KERNEL="kernel.bin"
TARGET_ROOTFS="root.bin"
TARGET_SYSUPGRADE="sysupgrade.bin"
TARGET_FIRMWARE_FLASH="firmware.flash"
TARGET_EXTEND="extend.bin"

case "$BOARD_NAME" in

lds-g402) # Own Multi Protocol Gateway
	TARGET_UBOOT=${TOPDIR}/release/"Gateway_Host_Uboot_QCA4531_CQ_LDS_DK_010700001_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_UBOOT_FLASH=${TOPDIR}/release/"Gateway_Host_Uboot_QCA4531_CQ_LDS_DK_010700001_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.flash
	TARGET_KERNEL=${TOPDIR}/release/"Gateway_Host_Kernel_QCA4531_CQ_LDS_DK_010700001_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_ROOTFS=${TOPDIR}/release/"Gateway_Host_Rootfs_QCA4531_CQ_LDS_DK_010700001_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_SYSUPGRADE=${TOPDIR}/release/"Gateway_Host_Sysupgrage_QCA4531_CQ_LDS_DK_010700001_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_FIRMWARE_FLASH=${TOPDIR}/release/"Gateway_Host_Firmware_QCA4531_CQ_LDS_DK_010700001_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.flash
	TARGET_EXTEND=${TOPDIR}/release/extend.bin
	;;

lds-g104) # Education Gateway
	TARGET_UBOOT=${TOPDIR}/release/"Gateway_Host_Uboot_QCA4531_CQ_LDS_DK_010700006_ZB-ControlBridge-D0002"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_UBOOT_FLASH=${TOPDIR}/release/"Gateway_Host_Uboot_QCA4531_CQ_LDS_DK_010700006_ZB-ControlBridge-D0002"_${DATE}_V${VERSION_NUMBER}.flash
	TARGET_KERNEL=${TOPDIR}/release/"Gateway_Host_Kernel_QCA4531_CQ_LDS_DK_010700006_ZB-ControlBridge-D0002"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_ROOTFS=${TOPDIR}/release/"Gateway_Host_Rootfs_QCA4531_CQ_LDS_DK_010700006_ZB-ControlBridge-D0002"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_SYSUPGRADE=${TOPDIR}/release/"Gateway_Host_Sysupgrage_QCA4531_CQ_LDS_DK_010700006_ZB-ControlBridge-D0002"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_FIRMWARE_FLASH=${TOPDIR}/release/"Gateway_Host_Firmware_QCA4531_CQ_LDS_DK_010700006_ZB-ControlBridge-D0002"_${DATE}_V${VERSION_NUMBER}.flash
	TARGET_EXTEND=${TOPDIR}/release/extend.bin
	;;

lds-g151) # The Home Depot (A023)
	TARGET_UBOOT=${TOPDIR}/release/"Gateway_Host_Uboot_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_UBOOT_FLASH=${TOPDIR}/release/"Gateway_Host_Uboot_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.flash
	TARGET_KERNEL=${TOPDIR}/release/"Gateway_Host_Kernel_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_ROOTFS=${TOPDIR}/release/"Gateway_Host_Rootfs_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_SYSUPGRADE=${TOPDIR}/release/"Gateway_Host_Sysupgrade_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_FIRMWARE_FLASH=${TOPDIR}/release/"Gateway_Host_Firmware_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.flash
	TARGET_EXTEND=${TOPDIR}/release/extend.bin
	;;

lds-g152) # Own Siren Hub
	TARGET_UBOOT=${TOPDIR}/release/"Gateway_Host_Uboot_QCA4531_CQ_LDS_NK_010700005_ZB-ControlBridge-D0001"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_UBOOT_FLASH=${TOPDIR}/release/"Gateway_Host_Uboot_QCA4531_CQ_LDS_NK_010700005_ZB-ControlBridge-D0001"_${DATE}_V${VERSION_NUMBER}.flash
	TARGET_KERNEL=${TOPDIR}/release/"Gateway_Host_Kernel_QCA4531_CQ_LDS_NK_010700005_ZB-ControlBridge-D0001"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_ROOTFS=${TOPDIR}/release/"Gateway_Host_Rootfs_QCA4531_CQ_LDS_NK_010700005_ZB-ControlBridge-D0001"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_SYSUPGRADE=${TOPDIR}/release/"Gateway_Host_Sysupgrade_QCA4531_CQ_LDS_NK_010700005_ZB-ControlBridge-D0001"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_FIRMWARE_FLASH=${TOPDIR}/release/"Gateway_Host_Firmware_QCA4531_CQ_LDS_NK_010700005_ZB-ControlBridge-D0001"_${DATE}_V${VERSION_NUMBER}.flash
	TARGET_EXTEND=${TOPDIR}/release/extend.bin
	;;

*)
	echo "Unsupported board : $BOARD_NAME"
	exit 1
	;;

esac

gen_firmware()
{
	rm  -rf ${TOPDIR}/release >> /dev/null
	mkdir -p ${TOPDIR}/release
	
	echo TARGET_UBOOT: ${TARGET_UBOOT}
	echo TARGET_UBOOT_FLASH: ${TARGET_UBOOT_FLASH}
	echo TARGET_KERNEL: ${TARGET_KERNEL}
	echo TARGET_ROOTFS: ${TARGET_ROOTFS}
	echo TARGET_SYSUPGRADE: ${TARGET_SYSUPGRADE}
	echo TARGET_FIRMWARE_FLASH: ${TARGET_FIRMWARE_FLASH}
	echo TARGET_EXTEND: ${TARGET_EXTEND}
	
	cp -fpR ${BIN_UBOOT} ${TARGET_UBOOT}
	cp -fpR ${BIN_KERNEL} ${TARGET_KERNEL}
	cp -fpR ${BIN_ROOTFS} ${TARGET_ROOTFS}
	cp -fpR ${BIN_SYSUPGRADE} ${TARGET_SYSUPGRADE}
	cp -fpR ${BIN_EXTEND} ${TARGET_EXTEND}
	
	( dd if=${BIN_UBOOT} bs=262144 count=1 conv=sync;\
	dd if=/dev/zero  bs=65536 count=1 conv=sync;\
	dd if=/dev/zero  bs=65536 count=1 conv=sync;\
	dd if=/dev/zero  bs=65536 count=1 conv=sync;\
	dd if=${BIN_ART} bs=65536 count=1 conv=sync ) > ${TARGET_UBOOT_FLASH}
	
#	We don't need the whole flash firmware
#	( dd if=${BIN_KERNEL} bs=2097152 count=1 conv=sync;\
#	dd if=${BIN_ROOTFS} bs=33554432 count=1 conv=sync;\
#	dd if=${BIN_KERNEL} bs=2097152 count=1 conv=sync;\
#	dd if=${BIN_ROOTFS} bs=33554432 count=1 conv=sync;\
#	dd if=${BIN_EXTEND} bs=62914560 count=1 conv=sync ) > ${TARGET_FIRMWARE_FLASH}
	
	cd ${TOPDIR}/release/
	find -maxdepth 1 -type f \! -name 'md5sums'  -printf "%P\n" | sort | xargs md5sum --binary > md5sums 
	cd -
}

gen_firmware

exit 0
