#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

void
testsymlink(void)
{
  int r, fd1;
  char buf[4];

  printf("Start: test symlinks\n");

  // 1. Create a regular file 'a' containing "abc"
  fd1 = open("testsymlink/a", O_CREATE | O_RDWR);
  if(fd1 < 0) {
    printf("testsymlink: cannot create testsymlink/a\n");
    exit(1);
  }
  write(fd1, "abc", 3);
  close(fd1);

  // 2. Create a symlink 'b' pointing to 'a'
  r = symlink("testsymlink/a", "testsymlink/b");
  if(r < 0) {
    printf("testsymlink: symlink b -> a failed\n");
    exit(1);
  }

  // 3. Open 'b'. It should follow the link and open 'a'.
  fd1 = open("testsymlink/b", O_RDONLY);
  if(fd1 < 0) {
    printf("testsymlink: open b failed\n");
    exit(1);
  }
  read(fd1, buf, 4);
  if(buf[0] != 'a') {
    printf("testsymlink: read b failed\n");
    exit(1);
  }
  close(fd1);

  // 4. Create symlink 'c' -> 'b'. (Recursive: c->b->a)
  r = symlink("testsymlink/b", "testsymlink/c");
  if(r < 0) {
    printf("testsymlink: symlink c -> b failed\n");
    exit(1);
  }

  // 5. Open 'c'. It should resolve to 'a'.
  fd1 = open("testsymlink/c", O_RDONLY);
  if(fd1 < 0) {
    printf("testsymlink: open c failed\n");
    exit(1);
  }
  read(fd1, buf, 4);
  if(buf[0] != 'a') {
    printf("testsymlink: read c failed\n");
    exit(1);
  }
  close(fd1);

  // 6. Test O_NOFOLLOW. Open 'b' with NOFOLLOW. 
  // It should NOT fail, but we can't easily check the inode type 
  // from userspace without fstat (which assumes you updated fstat).
  // But if it succeeds, it means it opened *something*.
  fd1 = open("testsymlink/b", O_RDONLY | O_NOFOLLOW);
  if(fd1 < 0) {
    printf("testsymlink: open b (nofollow) failed\n");
    exit(1);
  }
  close(fd1);

  printf("test symlinks: ok\n");
}

void
testsymlinkloop(void)
{
  int r;

  printf("Start: test symlink loop\n");

  // Create infinite loop: a -> b -> a
  r = symlink("testsymlink/b", "testsymlink/a");
  if(r < 0){
    printf("testsymlinkloop: symlink a -> b failed\n");
    exit(1);
  }
  r = symlink("testsymlink/a", "testsymlink/b");
  if(r < 0){
    printf("testsymlinkloop: symlink b -> a failed\n");
    exit(1);
  }

  // Attempt to open. Should fail after 10 depths.
  int fd = open("testsymlink/a", O_RDONLY);
  if(fd >= 0){
    printf("testsymlinkloop: open loop passed (should fail)\n");
    exit(1);
  }

  printf("test symlink loop: ok\n");
}
int
main(int argc, char *argv[])
{
  mkdir("testsymlink");
  
  // 1. Run the first test
  testsymlink();
  
  // --- FIX: Clean up files from the first test ---
  unlink("testsymlink/a");
  unlink("testsymlink/b");
  unlink("testsymlink/c");
  // -----------------------------------------------

  // 2. Run the second test (Loop test)
  testsymlinkloop();
  
  // 3. Final Clean up
  unlink("testsymlink/a");
  unlink("testsymlink/b");
  unlink("testsymlink");
  
  exit(0);
}