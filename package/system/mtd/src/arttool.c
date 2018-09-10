#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stddef.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <string.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <mtd/mtd-user.h>
#include "mtd.h"
#include "arttool.h"

#define ART_MTD "/dev/mtd4"
#define ETH0_DEV "eth0"
#define ETH1_DEV "eth1"
#define RADIO0_DEV "radio0"
#define BLE0_DEV "ble0"
#define BLE1_DEV "ble1"
#define PLC_DEV "plc"
#define R16_DEV "r16"
#define ETH0_OFFSET 0x0
#define ETH1_OFFSET 0x6
#define RADIO0_OFFSET 0x1002
#define BLE0_OFFSET 0xF020
#define BLE1_OFFSET 0xF026
#define PLC_OFFSET 0xF030
#define R16_OFFSET 0xF040
#define MAC_LEN 6

unsigned char a2x(const char c)  
{  
    switch(c) {  
    case '0'...'9':  
        return (unsigned char)atoi(&c);  
    case 'a'...'f':  
        return 0xa + (c-'a');  
    case 'A'...'F':  
        return 0xa + (c-'A');  
    default:  
        goto error;  
    }  
error:  
    exit(0);  
}  
  
/*convert a string,which length is 12, to a macaddress data type.*/  
#define MAC_LEN_IN_BYTE 6  
#define COPY_STR2MAC(mac,str)  \  
    do { \  
        int i;\
        for(i = 0; i < MAC_LEN_IN_BYTE; i++) {\  
            mac[i] = (a2x(str[i*2]) << 4) + a2x(str[i*2 + 1]);\  
        }\  
    } while(0)  

/*return--hex:1*/
int validateHex(char *data)
{
	int i=0;
    for(i = 0; data[i] != 0; i++)
    {	
    	if(isxdigit(data[i])){
			continue;
    	}else{
			return 0;
    	}
    }
	return 1;
}
		
static int mtd_mac_write(char *nic, char *value, int count)
{    
    unsigned int size = 0;
    char *buf, *ptr = NULL;
    unsigned char hexmac[MAC_LEN] = {0};

    int fd = mtd_check_open(ART_MTD); 

    if (fd < 0)
    {
        return -1;
    }
        
    size = erasesize;

    buf = (char *)malloc(size);
    if (NULL == buf)
    {
        printf("Allocate memory for size failed.\n");
        close(fd);
        return -1;        
    }

    if (read(fd, buf, size) != size)
    {
        printf("read() %s failed\n", ART_MTD);
        goto rw_fail;
    }
        
    if (0 == strcmp(nic, ETH0_DEV))
    {
        ptr = buf + ETH0_OFFSET;
    }
    else if(0 == strcmp(nic, ETH1_DEV))
    {
        ptr = buf + ETH1_OFFSET;
    }
    else if(0 == strcmp(nic, RADIO0_DEV))
    {
        ptr = buf + RADIO0_OFFSET;
    }
    else if(0 == strcmp(nic, BLE0_DEV))
    {
        ptr = buf + BLE0_OFFSET;
    }
    else if(0 == strcmp(nic, BLE1_DEV))
    {
        ptr = buf + BLE1_OFFSET;
    }
    else if(0 == strcmp(nic, PLC_DEV))
    {
        ptr = buf + PLC_OFFSET;
    }
    else if(0 == strcmp(nic, R16_DEV))
    {
        ptr = buf + R16_OFFSET;
    }
    else
    {
    	printf("The operation of the unknown!\n");
        goto rw_fail;
    }
	if(!validateHex(value)){
		printf("Write the MAC failed!%s is not a hexadecimal number!\n",value);
		goto rw_fail;
	}
	if(strlen(value)!=12){
		printf("Write the MAC failed!%s must be 12 digits!\n",value);
		goto rw_fail;
	}

    COPY_STR2MAC(hexmac, value);

    printf("write %s mac to eeprom: %02x%02x%02x%02x%02x%02x\n", nic, hexmac[0], hexmac[1],hexmac[2],hexmac[3],hexmac[4],hexmac[5]);

    memcpy(ptr, hexmac, MAC_LEN);
	
    if (mtd_erase_block(fd, 0) < 0)
    { 
        goto rw_fail;
    }

    mtd_write_buffer(fd, buf, 0, size);

    close(fd);
    free(buf);
    return 0;

rw_fail:
	close(fd);
	free(buf);
	return -1;
}

static int mtd_mac_read(const char *nic)
{    
    unsigned int offset = 0;
    unsigned char mac[MAC_LEN] = {0};

    int fd = mtd_check_open(ART_MTD); 

    if (fd < 0)
    {
        return -1;
    }
        
    if (0 == strcmp(nic, ETH0_DEV))
    {
        offset = ETH0_OFFSET;
    }
    else if(0 == strcmp(nic, ETH1_DEV))
    {
        offset = ETH1_OFFSET;
    }
    else if(0 == strcmp(nic, RADIO0_DEV))
    {
        offset = RADIO0_OFFSET;
    }
	else if(0 == strcmp(nic, BLE0_DEV))
    {
        offset = BLE0_OFFSET;
    }
    else if(0 == strcmp(nic, BLE1_DEV))
    {
        offset = BLE1_OFFSET;
    }
    else if(0 == strcmp(nic, PLC_DEV))
    {
        offset = PLC_OFFSET;
    }
    else if(0 == strcmp(nic, R16_DEV))
    {
        offset = R16_OFFSET;
    }
    else
    {
        return -1;
    }

    lseek(fd, offset, SEEK_SET);
    read(fd, mac, MAC_LEN);
     
    printf("%02x%02x%02x%02x%02x%02x\n",mac[0], mac[1],mac[2],mac[3],mac[4],mac[5]);

    close(fd);

    return 0;
}

int arttool(const char *cmd, const char* device, const char *param)
{
    char cmd_prefix[16] = {0};
    char cmd_suffix[16] = {0};

    sscanf(cmd, "%[0-9,a-z,A-Z]_%[0-9,a-z,A-Z]", cmd_prefix, cmd_suffix);

    if ((0 == strcmp(cmd_prefix, "set")) && (param != NULL))
    {
        return mtd_mac_write(device, param, strlen(param));
    }
    else if (0 == strcmp(cmd_prefix, "get"))
    {
        return mtd_mac_read(device);
    }

    return -1;
}
