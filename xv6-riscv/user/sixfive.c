#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

char *separators = " -\r\t\n./,";

void
process(int fd)
{
  char buf;
  char token[128];     
  int len = 0;       
  int is_valid_num = 1;

  while(read(fd, &buf, 1) > 0){
    
    if(strchr(separators, buf)){

      if(len > 0 && is_valid_num){
        token[len] = 0;
        int n = atoi(token);
        
        if(n % 5 == 0 || n % 6 == 0){
          printf("%d\n", n);
        }
      }

      len = 0;
      is_valid_num = 1;
    } 
    else {
      
      if(buf >= '0' && buf <= '9'){
        if(len < sizeof(token) - 1){
          token[len++] = buf;
        }
      } else {
        is_valid_num = 0;
      }
    }
  }

  if(len > 0 && is_valid_num){
    token[len] = 0;
    int n = atoi(token);
    if(n % 5 == 0 || n % 6 == 0){
      printf("%d\n", n);
    }
  }
}

int
main(int argc, char *argv[])
{
  int fd;

  if(argc <= 1){
    fprintf(2, "usage: sixfive [files...]\n");
    exit(1);
  }

  for(int i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
      fprintf(2, "sixfive: cannot open %s\n", argv[i]);
      exit(1);
    }
    process(fd);
    close(fd);
  }

  exit(0);
}