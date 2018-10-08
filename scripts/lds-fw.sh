#/bin/sh
# 
# lds-g151 (A023)
# "Gateway_Host_All_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000_"${DATE}_${VER_NUM}
# Gateway_Host_Uboot_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000_20180929_V2.06.bin
# Gateway_Host_Uboot_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000_20180929_V2.06.flash
# Gateway_Host_Kernel_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000_20180929_V2.06.bin      
# Gateway_Host_Rootfs_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000_20180929_V2.06.bin      
# Gateway_Host_Sysupgrade_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000_20180929_V2.06.bin
# 
# 
# lds-g104 
# Gateway-Host-MulTi-QCA4531-NPA-LDS-NK-CQ-HW-SVN7187-V1.43-u-boot.bin
# Gateway-Host-MulTi-QCA4531-NPA-LDS-NK-CQ-HW-SVN7187-V1.43-uboot_art.flash
# Gateway-Host-MulTi-QCA4531-NPA-LDS-NK-CQ-HW-SVN7187-V1.43-kernel.bin
# Gateway-Host-MulTi-QCA4531-NPA-LDS-NK-CQ-HW-SVN7187-V1.43-rootfs.bin    
# Gateway-Host-MulTi-QCA4531-NPA-LDS-NK-CQ-HW-SVN7187-V1.43-sysupgrade.bin 
# 
# 
# 
# 
# 

# exit 0

DATE=`date "+%Y%m%d"`

echo "=================lds-fw.sh==========================="
echo DATE: ${DATE}
echo TOPDIR: ${TOPDIR}
echo VERSION_NUMBER: ${VERSION_NUMBER}
echo REVISION: ${REVISION}
echo BOARD_NAME: ${BOARD_NAME}
echo BIN_UBOOT: ${BIN_UBOOT}
echo BIN_KERNEL: ${BIN_KERNEL}
echo BIN_ROOTFS: ${BIN_ROOTFS}
echo BIN_SYSUPGRADE: ${BIN_SYSUPGRADE}

TARGET_UBOOT=""
TARGET_UBOOT_FLASH=""
TARGET_KERNEL=""
TARGET_ROOTFS=""
TARGET_SYSUPGRADE=""

case "$BOARD_NAME" in
lds-g104) # 教育照明
	
	REVISION=`echo ${REVISION} | tr '[:lower:]' '[:upper:]'`
	IMG_PREFIX="Gateway-Host-MulTi-QCA4531-NPA-LDS-NK-CQ-HW-${REVISION}-V${VERSION_NUMBER}"
	TARGET_UBOOT=${TOPDIR}/release/${IMG_PREFIX}-u-boot.bin
	TARGET_UBOOT_FLASH=${TOPDIR}/release/${IMG_PREFIX}-uboot_art.flash
	TARGET_KERNEL=${TOPDIR}/release/${IMG_PREFIX}-kernel.bin
	TARGET_ROOTFS=${TOPDIR}/release/${IMG_PREFIX}-rootfs.bin
	TARGET_SYSUPGRADE=${TOPDIR}/release/${IMG_PREFIX}-sysupgrade.bin
	;;
	
lds-g151) # A023 Siren Hub
	TARGET_UBOOT=${TOPDIR}/release/"Gateway_Host_Uboot_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_UBOOT_FLASH=${TOPDIR}/release/"Gateway_Host_Uboot_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.flash
	TARGET_KERNEL=${TOPDIR}/release/"Gateway_Host_Kernel_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_ROOTFS=${TOPDIR}/release/"Gateway_Host_Rootfs_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.bin
	TARGET_SYSUPGRADE=${TOPDIR}/release/"Gateway_Host_Sysupgrade_QCA4531_CQ_A023_NK_010700003_ZB-ControlBridge-D0000"_${DATE}_V${VERSION_NUMBER}.bin
	;;
	
lds-g152) # 自主Siren Hub
	
	;;
	
lds-g402) # 自主多协议网关
	
	;;
	
*)
	echo "Unsupported board : $BOARD_NAME"
	exit 1
	;;
	
esac

usage() 
{
	cat <<EOF
Usage: $0 
generate image.
EOF
	exit 1
}

gen_firmware()
{
	rm  -rf ${TOPDIR}/release >> /dev/null
	mkdir -p ${TOPDIR}/release
	
	echo TARGET_UBOOT: ${TARGET_UBOOT}
	echo TARGET_UBOOT_FLASH: ${TARGET_UBOOT_FLASH}
	echo TARGET_KERNEL: ${TARGET_KERNEL}
	echo TARGET_ROOTFS: ${TARGET_ROOTFS}
	echo TARGET_SYSUPGRADE: ${TARGET_SYSUPGRADE}
	
}

gen_firmware

exit 0
