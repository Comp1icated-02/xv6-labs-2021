#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "user/user.h"

char* fmt_name(char* path)//turn the path to file name
{
	static char buf[DIRSIZ+1];
	char* p;
	for (p = path +strlen(path);p >= path && *p != '/';p--);//find the first character after the slasj
	p++;// if path_name = ./file1/a/b/file_c  then p-> "file_c"
	memmove(buf,p,strlen(p)+1);
	return buf;
}

void eq_print(char* filename, char* findname)//if the name matches, print the path
{
	if(strcmp(fmt_name(filename),findname) == 0)
		printf("%s\n",filename);
}

void find (char* path, char* findname)
{
	int fd;
	struct stat st;
	if((fd = open(path,O_RDONLY)) < 0)
	{
		fprintf(2,"find:cannot open %s\n",path);
		return;
	
	}
	if(fstat(fd,&st)<0)
	{
		fprintf(2,"find:cannot stat %s\n",path);
		close(fd);
		return;
	}
	char buf[512], *p;
	struct dirent de;
	switch(st.type)
	{
		case T_FILE:
			eq_print(path,findname);
			break;
		case T_DIR:
			if(strlen(path)+1+DIRSIZ+1 > sizeof buf)
			{
				printf("find:path too long\n");
				break;
			}
			strcpy(buf,path);
			p = buf +strlen(buf);
			*p++ = '/';
			while(read(fd,&de,sizeof(de)) == sizeof(de))
			{
				if(de.inum==0||de.inum==1||strcmp(de.name,".")==0||strcmp(de.name,"..")==0)
					continue;
				memmove(p,de.name,strlen(de.name));
				p[strlen(de.name)]=0;
				find (buf,findname);
			}
			break;
			
	}
	close(fd);
}
int main(int argc,char* argv[])
{
	if(argc<3)
	{
		printf("find:find<path><filename>\n");
		exit(0);
	}
	find(argv[1],argv[2]);
	exit(0);
}
