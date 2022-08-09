#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char* argv[])
{
	int i,j;
	int k = 0;
	int l = 0;
	int m = 0;
	char block[32];
	char buf[32];
	char* p = buf;
	char* linesplit[32];
	for(i = 1; i < argc; i++)
		linesplit[k++] = argv[i];
	while((j=read(0,block,sizeof(block)))>0)
	{
		for(l=0;l<j;l++)
		{
			if(block[l] == '\n')
			{
				buf[m]=0;
				m=0;
				linesplit[k++] = p;
				p=buf;
				k=argc-1;
				if(fork()==0)
					exec(argv[1],linesplit);
				wait(0);
			}
			else if (block[l] == ' ')
			{
				buf[m++] = 0;
				linesplit[k++] = p;
				p = &buf[m];
			}
			else
				buf[m++]=block[l];
		}
	}
	exit(0);
}
