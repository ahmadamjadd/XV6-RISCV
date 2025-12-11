#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void
memdump(char *fmt, char *data)
{
  while(*fmt){
    switch(*fmt){
      case 'i': {
        int val = *(int*)data;
        printf("%d\n", val);
        data += 4;
        break;
      }
      case 'p': {
       
        uint64 val = *(uint64*)data;
        printf("%lx\n", val); 
        data += 8;
        break;
      }
      case 'h': {
        
        short val = *(short*)data;
        printf("%d\n", val);
        data += 2;
        break;
      }
      case 'c': {
        
        char val = *data;
        printf("%c\n", val);
        data += 1;
        break;
      }
      case 's': {
        
        char *s = *(char**)data;
        printf("%s\n", s);
        data += 8;
        break;
      }
      case 'S': {
        
        printf("%s\n", data);
        
        return; 
      }
    }
    fmt++;
  }
}

struct e4 {
  short s;      
  uint64 l;    
  int i;       
  char c;      
} __attribute__((packed)); 

int
main(int argc, char *argv[])
{
  if(argc > 1){
 
    char buf[1024];
    int n = read(0, buf, sizeof(buf));
    if(n > 0){
      memdump(argv[1], buf);
    }
    exit(0);
  }

  printf("example 1 \n");
  struct { int a; int b; } e1 = {61810, 2025};
  memdump("ii", (char*)&e1);

  printf("example 2 \n");
  char *str = "a string";
  memdump("s", (char*)&str);

  printf("example 3 \n");
  memdump("S", "another");

  printf("example 4 \n");
  struct e4 val;
  val.s = 0x0BD0;
  val.l = 1819438967;
  val.i = 100;
  val.c = 'z';
  memdump("hpic", (char*)&val);

  printf("\nexample 5 \n");
  memdump("cccccS", "helloworld"); 
  
  exit(0);
}