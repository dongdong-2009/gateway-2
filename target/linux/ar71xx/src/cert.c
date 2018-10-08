
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <string.h>

#define BLOCK_SIZE  4096

void usage(void)
{
	printf("cert tool be use for read/write cert/pem file");
	printf("certdump  read/write number  file_path\n");
	printf("reserved partition is 64k, each file max file length is 4096, so number from 0-15\n");
	printf("type , type be set to 1  cert operation, type be set to 2 pem operation\n");
	printf("do read  , file_path is the be store file path\n");
	printf("do write  , file_path is the be store file path\n");
	
	printf("Usage: Usage: cert {read | write} [0~15] <filepath>\n");
	printf("cert read 0 ./privkey.pem \n");
	printf("cert read 1 ./cert.pem \n");
	printf("cert write 0 ./privkey.pem \n");
	printf("cert write 1 ./cert.pem \n");
}

int main(int argc , char *argv[])
{
	char *rw = NULL;
	int index = 0;
	char *filepath = NULL;
	
	if(argc != 4 )
	{
		usage();
		return -1;
	}
	
	rw = argv[1];	
	if(strcmp("read", rw) != 0 && strcmp("write", rw) != 0)
	{
		printf("no read or write command\n");
		return  -1;
	}
	
	index = atoi(argv[2]);	
	if(index < 0 || index > 15)
	{
		printf("read&write number is unvalid\n");
		return -1;
	}
	
	filepath = argv[3];
	
	unsigned char context[BLOCK_SIZE] = { 0 };
	struct stat stat = { 0 };
	int mtd_fd = 0;
	int file_fd = 0;	
	int pos  = 0;
	int len = 0, file_size = 0;
	int i = 0;
	int ret = 0;
	
	pos  = BLOCK_SIZE * index;
	
	if(0 == strcmp(rw, "read"))	
	{
		mtd_fd = open("/dev/mtdblock3", O_RDWR, 0644);
		
		lseek(mtd_fd, pos, SEEK_SET);
		
		len = read(mtd_fd, context, BLOCK_SIZE);
		if(len <= 0)
		{
			printf("mtd read error\n");
			close(mtd_fd);
			return -1;
		}
		
		for(i = 0; i < len; i++)
		{
			if(context[i] == 0xff || context[i] == 0x00)
			{
				context[i] = 0;
				break;
			}
		}
		
		printf("read len: %d \n", strlen(context));
		
		file_fd = open(filepath, O_CREAT | O_WRONLY | O_TRUNC, 0777);
		if(file_fd <  0)
		{
			close(file_fd);
			printf("create file %s fail\n",argv[3]);
			return -1;
		}
		
		write(file_fd, context, strlen(context));
		
		close(mtd_fd);
		close(file_fd);
	}
	else if(0 == strcmp(rw, "write"))
	{
		file_fd = open(filepath, O_RDONLY);
		if( file_fd  <  0 )
		{
			printf("open %s failed\n", filepath);
			return -1;
		}
		
		ret = fstat(file_fd, &stat);
		if(ret == -1)
		{
			printf("state error\n");
			close(file_fd);
			return -1;
		}
		
		file_size = stat.st_size;
		if(file_size > BLOCK_SIZE )
		{
			printf("file size error\n");
			close(file_fd);
			return -1;
		}
		
		ret = read(file_fd, context, BLOCK_SIZE);
		if(ret < 0)
		{
			printf("read error\n");
			close(file_fd);
			return -1;
		}
		
		mtd_fd = open("/dev/mtdblock3", O_RDWR, 0644);
		
		lseek(mtd_fd, pos, SEEK_SET);
		
		write(mtd_fd, context, BLOCK_SIZE);
		
		lseek(mtd_fd, pos, SEEK_SET);
		len = write(mtd_fd, context, sizeof(context));
		printf("write flash len: %d/%d \n", stat.st_size, len);
		
		close(file_fd);
		close(mtd_fd);
	}
	
	return 0;
}

