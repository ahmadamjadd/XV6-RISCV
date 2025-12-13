#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"
#include "kernel/fs.h"

int
main()
{
  char buf[BSIZE];
  int fd, blocks;

  fd = open("big", O_CREATE | O_WRONLY);
  if(fd < 0){
    printf("bigfile: cannot open big\n");
    exit(1);
  }

  blocks = 0;
  while(1){
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
      printf(".");
    if(blocks == 65803) {
    printf("bigfile: passed\n");
    printf("blocks wrote: %d", blocks);
    close(fd);
    unlink("big");
    exit(0);
  }
  }
  
}