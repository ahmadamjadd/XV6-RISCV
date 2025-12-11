#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/param.h" 

void
find(char *path, char *target, char **xargv)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  char *name = path;
  for(int i = strlen(path) - 1; i >= 0; i--){
    if(path[i] == '/'){
      name = path + i + 1;
      break;
    }
  }

  if(strcmp(name, target) == 0){
    if(xargv == 0){

      printf("%s\n", path);
    } else {

      int pid = fork();
      if(pid == 0){
     
        char *args[MAXARG];
        int i = 0;
        
        while(xargv[i] != 0 && i < MAXARG - 2){
          args[i] = xargv[i];
          i++;
        }
     
        args[i++] = path;
        args[i] = 0;

        exec(args[0], args);
        fprintf(2, "find: exec failed\n");
        exit(1);
      } else {
        wait(0);
      }
    }
  }

  if(st.type == T_DIR){
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)){
      printf("find: path too long\n");
      close(fd);
      return;
    }
    strcpy(buf, path);
    p = buf + strlen(buf);
    *p++ = '/';
    
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
        continue;
      
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      
      find(buf, target, xargv);
    }
  }
  close(fd);
}

int
main(int argc, char *argv[])
{
  if(argc < 3){
    fprintf(2, "Usage: find <path> <target> [-exec cmd ...]\n");
    exit(1);
  }

  char **xargv = 0;
  
  if(argc > 3 && strcmp(argv[3], "-exec") == 0){
    if(argc < 5){
      fprintf(2, "find: -exec needs a command\n");
      exit(1);
    }
    xargv = &argv[4];
  }
  find(argv[1], argv[2], xargv);
  exit(0);
}