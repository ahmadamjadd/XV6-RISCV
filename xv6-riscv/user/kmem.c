#include "kernel/types.h"
#include "user/user.h"
#include "kernel/stat.h"

int main(int argc, char *argv[]) {
  printf("System Call Verification:\n");
  
  // Call your new system call
  int free_bytes = kmemfree();
  
  printf("Free memory: %d bytes\n", free_bytes);
  
  exit(0);
}