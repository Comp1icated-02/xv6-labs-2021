#include <kernel/types.h>
#include <user/user.h>
int main()
{
	int pipe1[2];
	int pipe2[2];
	//pipe1:parent of "write" ,child of "read"
	//pipe2:similarly.
	char buffer[] = {'A'};
	long length = sizeof(buffer);
	// length of array(char)
	pipe(pipe1);
	pipe(pipe2);
	//parent write child read
	//vice versa.
	if (fork() == 0)
	{
		close(pipe1[1]);
		close(pipe2[0]);//close useless pipes
		if(read(pipe1[0],buffer,length) != length)
		{
			printf("a->b read error!");
			exit(1);
		}
		printf("%d: received ping\n",getpid());//print
		if(write(pipe2[1],buffer,length) != length)
		{
			printf("a->b write error");
			exit(1);
		}
		exit(0);

	}
	close(pipe1[0]);
	close(pipe2[1]);
	if(write(pipe1[1],buffer,length) != length)//parent write to pipe1 write end
	{
		printf("a->b write error!");
		exit(1);
	}
	if(read(pipe2[0],buffer,length) != length)//parent read from pipe2 read end
	{
		 printf("a->b read error!");
		 exit(1);
	}							                
	printf("%d: received pong\n",getpid());
	wait(0);//wait for the child to end
	exit(0);
}
