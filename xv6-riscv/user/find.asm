
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "../kernel/fcntl.h"
#include "user.h"


char* fmtname(char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  char *p;
  for(p=path+strlen(path); p >= path && *p != '/'; p--);
   c:	2e0000ef          	jal	2ec <strlen>
  10:	1502                	slli	a0,a0,0x20
  12:	9101                	srli	a0,a0,0x20
  14:	9526                	add	a0,a0,s1
  16:	02f00713          	li	a4,47
  1a:	00956963          	bltu	a0,s1,2c <fmtname+0x2c>
  1e:	00054783          	lbu	a5,0(a0)
  22:	00e78563          	beq	a5,a4,2c <fmtname+0x2c>
  26:	157d                	addi	a0,a0,-1
  28:	fe957be3          	bgeu	a0,s1,1e <fmtname+0x1e>
  p++;
  return p;

}
  2c:	0505                	addi	a0,a0,1
  2e:	60e2                	ld	ra,24(sp)
  30:	6442                	ld	s0,16(sp)
  32:	64a2                	ld	s1,8(sp)
  34:	6105                	addi	sp,sp,32
  36:	8082                	ret

0000000000000038 <find>:


void find(char *path, char *filename, char *files[], int *i)
{
  38:	d8010113          	addi	sp,sp,-640
  3c:	26113c23          	sd	ra,632(sp)
  40:	26813823          	sd	s0,624(sp)
  44:	27213023          	sd	s2,608(sp)
  48:	25313c23          	sd	s3,600(sp)
  4c:	25413823          	sd	s4,592(sp)
  50:	25513423          	sd	s5,584(sp)
  54:	0500                	addi	s0,sp,640
  56:	892a                	mv	s2,a0
  58:	8aae                	mv	s5,a1
  5a:	8a32                	mv	s4,a2
  5c:	89b6                	mv	s3,a3
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, O_RDONLY)) < 0)
  5e:	4581                	li	a1,0
  60:	508000ef          	jal	568 <open>
  64:	06054063          	bltz	a0,c4 <find+0x8c>
  68:	26913423          	sd	s1,616(sp)
  6c:	84aa                	mv	s1,a0
  {
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }
  
  if(fstat(fd, &st) < 0)
  6e:	d8840593          	addi	a1,s0,-632
  72:	50e000ef          	jal	580 <fstat>
  76:	06054063          	bltz	a0,d6 <find+0x9e>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }
  
  switch(st.type)
  7a:	d9041783          	lh	a5,-624(s0)
  7e:	4705                	li	a4,1
  80:	0ce78763          	beq	a5,a4,14e <find+0x116>
  84:	37f9                	addiw	a5,a5,-2
  86:	17c2                	slli	a5,a5,0x30
  88:	93c1                	srli	a5,a5,0x30
  8a:	00f76963          	bltu	a4,a5,9c <find+0x64>
  {
    case T_DEVICE:
    case T_FILE:
    {
      if (!strcmp(fmtname(path), filename))
  8e:	854a                	mv	a0,s2
  90:	f71ff0ef          	jal	0 <fmtname>
  94:	85d6                	mv	a1,s5
  96:	22a000ef          	jal	2c0 <strcmp>
  9a:	cd21                	beqz	a0,f2 <find+0xba>
      }
      break;

    }
  }
  close(fd);
  9c:	8526                	mv	a0,s1
  9e:	4b2000ef          	jal	550 <close>
  a2:	26813483          	ld	s1,616(sp)
}
  a6:	27813083          	ld	ra,632(sp)
  aa:	27013403          	ld	s0,624(sp)
  ae:	26013903          	ld	s2,608(sp)
  b2:	25813983          	ld	s3,600(sp)
  b6:	25013a03          	ld	s4,592(sp)
  ba:	24813a83          	ld	s5,584(sp)
  be:	28010113          	addi	sp,sp,640
  c2:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
  c4:	864a                	mv	a2,s2
  c6:	00001597          	auipc	a1,0x1
  ca:	a4a58593          	addi	a1,a1,-1462 # b10 <malloc+0xfc>
  ce:	4509                	li	a0,2
  d0:	067000ef          	jal	936 <fprintf>
    return;
  d4:	bfc9                	j	a6 <find+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
  d6:	864a                	mv	a2,s2
  d8:	00001597          	auipc	a1,0x1
  dc:	a5058593          	addi	a1,a1,-1456 # b28 <malloc+0x114>
  e0:	4509                	li	a0,2
  e2:	055000ef          	jal	936 <fprintf>
    close(fd);
  e6:	8526                	mv	a0,s1
  e8:	468000ef          	jal	550 <close>
    return;
  ec:	26813483          	ld	s1,616(sp)
  f0:	bf5d                	j	a6 <find+0x6e>
  f2:	25613023          	sd	s6,576(sp)
        int len = strlen(path) + 1;                    
  f6:	854a                	mv	a0,s2
  f8:	1f4000ef          	jal	2ec <strlen>
  fc:	00150b1b          	addiw	s6,a0,1
        files[*i] = (char*)malloc(len);
 100:	0009aa83          	lw	s5,0(s3)
 104:	0a8e                	slli	s5,s5,0x3
 106:	9ad2                	add	s5,s5,s4
 108:	000b051b          	sext.w	a0,s6
 10c:	109000ef          	jal	a14 <malloc>
 110:	00aab023          	sd	a0,0(s5)
        if (files[*i] == 0) 
 114:	0009a783          	lw	a5,0(s3)
 118:	078e                	slli	a5,a5,0x3
 11a:	97d2                	add	a5,a5,s4
 11c:	6388                	ld	a0,0(a5)
 11e:	cd11                	beqz	a0,13a <find+0x102>
        memmove(files[*i], path, len);
 120:	000b061b          	sext.w	a2,s6
 124:	85ca                	mv	a1,s2
 126:	328000ef          	jal	44e <memmove>
        (*i)++;
 12a:	0009a783          	lw	a5,0(s3)
 12e:	2785                	addiw	a5,a5,1
 130:	00f9a023          	sw	a5,0(s3)
 134:	24013b03          	ld	s6,576(sp)
 138:	b795                	j	9c <find+0x64>
          fprintf(2, "find: malloc failed\n");
 13a:	00001597          	auipc	a1,0x1
 13e:	a0658593          	addi	a1,a1,-1530 # b40 <malloc+0x12c>
 142:	4509                	li	a0,2
 144:	7f2000ef          	jal	936 <fprintf>
          break; 
 148:	24013b03          	ld	s6,576(sp)
 14c:	bf81                	j	9c <find+0x64>
      if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 14e:	854a                	mv	a0,s2
 150:	19c000ef          	jal	2ec <strlen>
 154:	2541                	addiw	a0,a0,16
 156:	20000793          	li	a5,512
 15a:	00a7f963          	bgeu	a5,a0,16c <find+0x134>
        printf("ls: path too long\n");
 15e:	00001517          	auipc	a0,0x1
 162:	9fa50513          	addi	a0,a0,-1542 # b58 <malloc+0x144>
 166:	7fa000ef          	jal	960 <printf>
        break;
 16a:	bf0d                	j	9c <find+0x64>
 16c:	25613023          	sd	s6,576(sp)
 170:	23713c23          	sd	s7,568(sp)
      strcpy(buf, path);
 174:	85ca                	mv	a1,s2
 176:	db040513          	addi	a0,s0,-592
 17a:	12a000ef          	jal	2a4 <strcpy>
      p = buf + strlen(buf);
 17e:	db040513          	addi	a0,s0,-592
 182:	16a000ef          	jal	2ec <strlen>
 186:	1502                	slli	a0,a0,0x20
 188:	9101                	srli	a0,a0,0x20
 18a:	db040793          	addi	a5,s0,-592
 18e:	00a78933          	add	s2,a5,a0
      *p++ = '/';
 192:	00190b93          	addi	s7,s2,1
 196:	02f00793          	li	a5,47
 19a:	00f90023          	sb	a5,0(s2)
        if(!strcmp(de.name, ".") || !strcmp(de.name, ".."))
 19e:	00001b17          	auipc	s6,0x1
 1a2:	9d2b0b13          	addi	s6,s6,-1582 # b70 <malloc+0x15c>
      while(read(fd, &de, sizeof(de)) == sizeof(de))
 1a6:	4641                	li	a2,16
 1a8:	da040593          	addi	a1,s0,-608
 1ac:	8526                	mv	a0,s1
 1ae:	392000ef          	jal	540 <read>
 1b2:	47c1                	li	a5,16
 1b4:	04f51463          	bne	a0,a5,1fc <find+0x1c4>
        if(de.inum == 0)
 1b8:	da045783          	lhu	a5,-608(s0)
 1bc:	d7ed                	beqz	a5,1a6 <find+0x16e>
        memmove(p, de.name, DIRSIZ);
 1be:	4639                	li	a2,14
 1c0:	da240593          	addi	a1,s0,-606
 1c4:	855e                	mv	a0,s7
 1c6:	288000ef          	jal	44e <memmove>
        p[DIRSIZ] = 0;
 1ca:	000907a3          	sb	zero,15(s2)
        if(!strcmp(de.name, ".") || !strcmp(de.name, ".."))
 1ce:	85da                	mv	a1,s6
 1d0:	da240513          	addi	a0,s0,-606
 1d4:	0ec000ef          	jal	2c0 <strcmp>
 1d8:	d579                	beqz	a0,1a6 <find+0x16e>
 1da:	00001597          	auipc	a1,0x1
 1de:	99e58593          	addi	a1,a1,-1634 # b78 <malloc+0x164>
 1e2:	da240513          	addi	a0,s0,-606
 1e6:	0da000ef          	jal	2c0 <strcmp>
 1ea:	dd55                	beqz	a0,1a6 <find+0x16e>
        find(buf, filename, files, i);
 1ec:	86ce                	mv	a3,s3
 1ee:	8652                	mv	a2,s4
 1f0:	85d6                	mv	a1,s5
 1f2:	db040513          	addi	a0,s0,-592
 1f6:	e43ff0ef          	jal	38 <find>
 1fa:	b775                	j	1a6 <find+0x16e>
 1fc:	24013b03          	ld	s6,576(sp)
 200:	23813b83          	ld	s7,568(sp)
 204:	bd61                	j	9c <find+0x64>

0000000000000206 <main>:




int main(int argc, char *argv[])
{
 206:	ca010113          	addi	sp,sp,-864
 20a:	34113c23          	sd	ra,856(sp)
 20e:	34813823          	sd	s0,848(sp)
 212:	1680                	addi	s0,sp,864
  if(argc != 3)
 214:	470d                	li	a4,3
 216:	02e50263          	beq	a0,a4,23a <main+0x34>
 21a:	34913423          	sd	s1,840(sp)
 21e:	35213023          	sd	s2,832(sp)
 222:	33313c23          	sd	s3,824(sp)
  {
    fprintf(2, "Usage: find <path> <filename>\n");
 226:	00001597          	auipc	a1,0x1
 22a:	95a58593          	addi	a1,a1,-1702 # b80 <malloc+0x16c>
 22e:	4509                	li	a0,2
 230:	706000ef          	jal	936 <fprintf>
    exit(1);
 234:	4505                	li	a0,1
 236:	2f2000ef          	jal	528 <exit>
 23a:	34913423          	sd	s1,840(sp)
 23e:	35213023          	sd	s2,832(sp)
 242:	33313c23          	sd	s3,824(sp)
 246:	87ae                	mv	a5,a1
  }
  
    char *found_files[100];
    int file_index = 0;
 248:	ca042623          	sw	zero,-852(s0)
      
    find(argv[1], argv[2], found_files, &file_index);
 24c:	cac40693          	addi	a3,s0,-852
 250:	cb040613          	addi	a2,s0,-848
 254:	698c                	ld	a1,16(a1)
 256:	6788                	ld	a0,8(a5)
 258:	de1ff0ef          	jal	38 <find>
  
    for (int j = 0; j < file_index; j++) 
 25c:	cac42783          	lw	a5,-852(s0)
 260:	02f05763          	blez	a5,28e <main+0x88>
 264:	cb040493          	addi	s1,s0,-848
 268:	4901                	li	s2,0
    {
        fprintf(1, "%s\n", found_files[j]);
 26a:	00001997          	auipc	s3,0x1
 26e:	8b698993          	addi	s3,s3,-1866 # b20 <malloc+0x10c>
 272:	6090                	ld	a2,0(s1)
 274:	85ce                	mv	a1,s3
 276:	4505                	li	a0,1
 278:	6be000ef          	jal	936 <fprintf>
        free(found_files[j]); 
 27c:	6088                	ld	a0,0(s1)
 27e:	714000ef          	jal	992 <free>
    for (int j = 0; j < file_index; j++) 
 282:	2905                	addiw	s2,s2,1
 284:	04a1                	addi	s1,s1,8
 286:	cac42783          	lw	a5,-852(s0)
 28a:	fef944e3          	blt	s2,a5,272 <main+0x6c>
    }
  
    exit(0);
 28e:	4501                	li	a0,0
 290:	298000ef          	jal	528 <exit>

0000000000000294 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 29c:	f6bff0ef          	jal	206 <main>
  exit(r);
 2a0:	288000ef          	jal	528 <exit>

00000000000002a4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2aa:	87aa                	mv	a5,a0
 2ac:	0585                	addi	a1,a1,1
 2ae:	0785                	addi	a5,a5,1
 2b0:	fff5c703          	lbu	a4,-1(a1)
 2b4:	fee78fa3          	sb	a4,-1(a5)
 2b8:	fb75                	bnez	a4,2ac <strcpy+0x8>
    ;
  return os;
}
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c6:	00054783          	lbu	a5,0(a0)
 2ca:	cb91                	beqz	a5,2de <strcmp+0x1e>
 2cc:	0005c703          	lbu	a4,0(a1)
 2d0:	00f71763          	bne	a4,a5,2de <strcmp+0x1e>
    p++, q++;
 2d4:	0505                	addi	a0,a0,1
 2d6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2d8:	00054783          	lbu	a5,0(a0)
 2dc:	fbe5                	bnez	a5,2cc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2de:	0005c503          	lbu	a0,0(a1)
}
 2e2:	40a7853b          	subw	a0,a5,a0
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <strlen>:

uint
strlen(const char *s)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f2:	00054783          	lbu	a5,0(a0)
 2f6:	cf91                	beqz	a5,312 <strlen+0x26>
 2f8:	0505                	addi	a0,a0,1
 2fa:	87aa                	mv	a5,a0
 2fc:	86be                	mv	a3,a5
 2fe:	0785                	addi	a5,a5,1
 300:	fff7c703          	lbu	a4,-1(a5)
 304:	ff65                	bnez	a4,2fc <strlen+0x10>
 306:	40a6853b          	subw	a0,a3,a0
 30a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret
  for(n = 0; s[n]; n++)
 312:	4501                	li	a0,0
 314:	bfe5                	j	30c <strlen+0x20>

0000000000000316 <memset>:

void*
memset(void *dst, int c, uint n)
{
 316:	1141                	addi	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 31c:	ca19                	beqz	a2,332 <memset+0x1c>
 31e:	87aa                	mv	a5,a0
 320:	1602                	slli	a2,a2,0x20
 322:	9201                	srli	a2,a2,0x20
 324:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 328:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 32c:	0785                	addi	a5,a5,1
 32e:	fee79de3          	bne	a5,a4,328 <memset+0x12>
  }
  return dst;
}
 332:	6422                	ld	s0,8(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret

0000000000000338 <strchr>:

char*
strchr(const char *s, char c)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 33e:	00054783          	lbu	a5,0(a0)
 342:	cb99                	beqz	a5,358 <strchr+0x20>
    if(*s == c)
 344:	00f58763          	beq	a1,a5,352 <strchr+0x1a>
  for(; *s; s++)
 348:	0505                	addi	a0,a0,1
 34a:	00054783          	lbu	a5,0(a0)
 34e:	fbfd                	bnez	a5,344 <strchr+0xc>
      return (char*)s;
  return 0;
 350:	4501                	li	a0,0
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret
  return 0;
 358:	4501                	li	a0,0
 35a:	bfe5                	j	352 <strchr+0x1a>

000000000000035c <gets>:

char*
gets(char *buf, int max)
{
 35c:	711d                	addi	sp,sp,-96
 35e:	ec86                	sd	ra,88(sp)
 360:	e8a2                	sd	s0,80(sp)
 362:	e4a6                	sd	s1,72(sp)
 364:	e0ca                	sd	s2,64(sp)
 366:	fc4e                	sd	s3,56(sp)
 368:	f852                	sd	s4,48(sp)
 36a:	f456                	sd	s5,40(sp)
 36c:	f05a                	sd	s6,32(sp)
 36e:	ec5e                	sd	s7,24(sp)
 370:	1080                	addi	s0,sp,96
 372:	8baa                	mv	s7,a0
 374:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 376:	892a                	mv	s2,a0
 378:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 37a:	4aa9                	li	s5,10
 37c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 37e:	89a6                	mv	s3,s1
 380:	2485                	addiw	s1,s1,1
 382:	0344d663          	bge	s1,s4,3ae <gets+0x52>
    cc = read(0, &c, 1);
 386:	4605                	li	a2,1
 388:	faf40593          	addi	a1,s0,-81
 38c:	4501                	li	a0,0
 38e:	1b2000ef          	jal	540 <read>
    if(cc < 1)
 392:	00a05e63          	blez	a0,3ae <gets+0x52>
    buf[i++] = c;
 396:	faf44783          	lbu	a5,-81(s0)
 39a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 39e:	01578763          	beq	a5,s5,3ac <gets+0x50>
 3a2:	0905                	addi	s2,s2,1
 3a4:	fd679de3          	bne	a5,s6,37e <gets+0x22>
    buf[i++] = c;
 3a8:	89a6                	mv	s3,s1
 3aa:	a011                	j	3ae <gets+0x52>
 3ac:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ae:	99de                	add	s3,s3,s7
 3b0:	00098023          	sb	zero,0(s3)
  return buf;
}
 3b4:	855e                	mv	a0,s7
 3b6:	60e6                	ld	ra,88(sp)
 3b8:	6446                	ld	s0,80(sp)
 3ba:	64a6                	ld	s1,72(sp)
 3bc:	6906                	ld	s2,64(sp)
 3be:	79e2                	ld	s3,56(sp)
 3c0:	7a42                	ld	s4,48(sp)
 3c2:	7aa2                	ld	s5,40(sp)
 3c4:	7b02                	ld	s6,32(sp)
 3c6:	6be2                	ld	s7,24(sp)
 3c8:	6125                	addi	sp,sp,96
 3ca:	8082                	ret

00000000000003cc <stat>:

int
stat(const char *n, struct stat *st)
{
 3cc:	1101                	addi	sp,sp,-32
 3ce:	ec06                	sd	ra,24(sp)
 3d0:	e822                	sd	s0,16(sp)
 3d2:	e04a                	sd	s2,0(sp)
 3d4:	1000                	addi	s0,sp,32
 3d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d8:	4581                	li	a1,0
 3da:	18e000ef          	jal	568 <open>
  if(fd < 0)
 3de:	02054263          	bltz	a0,402 <stat+0x36>
 3e2:	e426                	sd	s1,8(sp)
 3e4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3e6:	85ca                	mv	a1,s2
 3e8:	198000ef          	jal	580 <fstat>
 3ec:	892a                	mv	s2,a0
  close(fd);
 3ee:	8526                	mv	a0,s1
 3f0:	160000ef          	jal	550 <close>
  return r;
 3f4:	64a2                	ld	s1,8(sp)
}
 3f6:	854a                	mv	a0,s2
 3f8:	60e2                	ld	ra,24(sp)
 3fa:	6442                	ld	s0,16(sp)
 3fc:	6902                	ld	s2,0(sp)
 3fe:	6105                	addi	sp,sp,32
 400:	8082                	ret
    return -1;
 402:	597d                	li	s2,-1
 404:	bfcd                	j	3f6 <stat+0x2a>

0000000000000406 <atoi>:

int
atoi(const char *s)
{
 406:	1141                	addi	sp,sp,-16
 408:	e422                	sd	s0,8(sp)
 40a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 40c:	00054683          	lbu	a3,0(a0)
 410:	fd06879b          	addiw	a5,a3,-48
 414:	0ff7f793          	zext.b	a5,a5
 418:	4625                	li	a2,9
 41a:	02f66863          	bltu	a2,a5,44a <atoi+0x44>
 41e:	872a                	mv	a4,a0
  n = 0;
 420:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 422:	0705                	addi	a4,a4,1
 424:	0025179b          	slliw	a5,a0,0x2
 428:	9fa9                	addw	a5,a5,a0
 42a:	0017979b          	slliw	a5,a5,0x1
 42e:	9fb5                	addw	a5,a5,a3
 430:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 434:	00074683          	lbu	a3,0(a4)
 438:	fd06879b          	addiw	a5,a3,-48
 43c:	0ff7f793          	zext.b	a5,a5
 440:	fef671e3          	bgeu	a2,a5,422 <atoi+0x1c>
  return n;
}
 444:	6422                	ld	s0,8(sp)
 446:	0141                	addi	sp,sp,16
 448:	8082                	ret
  n = 0;
 44a:	4501                	li	a0,0
 44c:	bfe5                	j	444 <atoi+0x3e>

000000000000044e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 44e:	1141                	addi	sp,sp,-16
 450:	e422                	sd	s0,8(sp)
 452:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 454:	02b57463          	bgeu	a0,a1,47c <memmove+0x2e>
    while(n-- > 0)
 458:	00c05f63          	blez	a2,476 <memmove+0x28>
 45c:	1602                	slli	a2,a2,0x20
 45e:	9201                	srli	a2,a2,0x20
 460:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 464:	872a                	mv	a4,a0
      *dst++ = *src++;
 466:	0585                	addi	a1,a1,1
 468:	0705                	addi	a4,a4,1
 46a:	fff5c683          	lbu	a3,-1(a1)
 46e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 472:	fef71ae3          	bne	a4,a5,466 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 476:	6422                	ld	s0,8(sp)
 478:	0141                	addi	sp,sp,16
 47a:	8082                	ret
    dst += n;
 47c:	00c50733          	add	a4,a0,a2
    src += n;
 480:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 482:	fec05ae3          	blez	a2,476 <memmove+0x28>
 486:	fff6079b          	addiw	a5,a2,-1
 48a:	1782                	slli	a5,a5,0x20
 48c:	9381                	srli	a5,a5,0x20
 48e:	fff7c793          	not	a5,a5
 492:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 494:	15fd                	addi	a1,a1,-1
 496:	177d                	addi	a4,a4,-1
 498:	0005c683          	lbu	a3,0(a1)
 49c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4a0:	fee79ae3          	bne	a5,a4,494 <memmove+0x46>
 4a4:	bfc9                	j	476 <memmove+0x28>

00000000000004a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e422                	sd	s0,8(sp)
 4aa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ac:	ca05                	beqz	a2,4dc <memcmp+0x36>
 4ae:	fff6069b          	addiw	a3,a2,-1
 4b2:	1682                	slli	a3,a3,0x20
 4b4:	9281                	srli	a3,a3,0x20
 4b6:	0685                	addi	a3,a3,1
 4b8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4ba:	00054783          	lbu	a5,0(a0)
 4be:	0005c703          	lbu	a4,0(a1)
 4c2:	00e79863          	bne	a5,a4,4d2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4c6:	0505                	addi	a0,a0,1
    p2++;
 4c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4ca:	fed518e3          	bne	a0,a3,4ba <memcmp+0x14>
  }
  return 0;
 4ce:	4501                	li	a0,0
 4d0:	a019                	j	4d6 <memcmp+0x30>
      return *p1 - *p2;
 4d2:	40e7853b          	subw	a0,a5,a4
}
 4d6:	6422                	ld	s0,8(sp)
 4d8:	0141                	addi	sp,sp,16
 4da:	8082                	ret
  return 0;
 4dc:	4501                	li	a0,0
 4de:	bfe5                	j	4d6 <memcmp+0x30>

00000000000004e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4e0:	1141                	addi	sp,sp,-16
 4e2:	e406                	sd	ra,8(sp)
 4e4:	e022                	sd	s0,0(sp)
 4e6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4e8:	f67ff0ef          	jal	44e <memmove>
}
 4ec:	60a2                	ld	ra,8(sp)
 4ee:	6402                	ld	s0,0(sp)
 4f0:	0141                	addi	sp,sp,16
 4f2:	8082                	ret

00000000000004f4 <sbrk>:

char *
sbrk(int n) {
 4f4:	1141                	addi	sp,sp,-16
 4f6:	e406                	sd	ra,8(sp)
 4f8:	e022                	sd	s0,0(sp)
 4fa:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4fc:	4585                	li	a1,1
 4fe:	0b2000ef          	jal	5b0 <sys_sbrk>
}
 502:	60a2                	ld	ra,8(sp)
 504:	6402                	ld	s0,0(sp)
 506:	0141                	addi	sp,sp,16
 508:	8082                	ret

000000000000050a <sbrklazy>:

char *
sbrklazy(int n) {
 50a:	1141                	addi	sp,sp,-16
 50c:	e406                	sd	ra,8(sp)
 50e:	e022                	sd	s0,0(sp)
 510:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 512:	4589                	li	a1,2
 514:	09c000ef          	jal	5b0 <sys_sbrk>
}
 518:	60a2                	ld	ra,8(sp)
 51a:	6402                	ld	s0,0(sp)
 51c:	0141                	addi	sp,sp,16
 51e:	8082                	ret

0000000000000520 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 520:	4885                	li	a7,1
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <exit>:
.global exit
exit:
 li a7, SYS_exit
 528:	4889                	li	a7,2
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <wait>:
.global wait
wait:
 li a7, SYS_wait
 530:	488d                	li	a7,3
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 538:	4891                	li	a7,4
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <read>:
.global read
read:
 li a7, SYS_read
 540:	4895                	li	a7,5
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <write>:
.global write
write:
 li a7, SYS_write
 548:	48c1                	li	a7,16
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <close>:
.global close
close:
 li a7, SYS_close
 550:	48d5                	li	a7,21
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <kill>:
.global kill
kill:
 li a7, SYS_kill
 558:	4899                	li	a7,6
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <exec>:
.global exec
exec:
 li a7, SYS_exec
 560:	489d                	li	a7,7
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <open>:
.global open
open:
 li a7, SYS_open
 568:	48bd                	li	a7,15
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 570:	48c5                	li	a7,17
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 578:	48c9                	li	a7,18
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 580:	48a1                	li	a7,8
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <link>:
.global link
link:
 li a7, SYS_link
 588:	48cd                	li	a7,19
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 590:	48d1                	li	a7,20
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 598:	48a5                	li	a7,9
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5a0:	48a9                	li	a7,10
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a8:	48ad                	li	a7,11
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5b0:	48b1                	li	a7,12
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5b8:	48b5                	li	a7,13
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5c0:	48b9                	li	a7,14
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <kmemfree>:
.global kmemfree
kmemfree:
 li a7, SYS_kmemfree
 5c8:	48d9                	li	a7,22
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 5d0:	48dd                	li	a7,23
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5d8:	1101                	addi	sp,sp,-32
 5da:	ec06                	sd	ra,24(sp)
 5dc:	e822                	sd	s0,16(sp)
 5de:	1000                	addi	s0,sp,32
 5e0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5e4:	4605                	li	a2,1
 5e6:	fef40593          	addi	a1,s0,-17
 5ea:	f5fff0ef          	jal	548 <write>
}
 5ee:	60e2                	ld	ra,24(sp)
 5f0:	6442                	ld	s0,16(sp)
 5f2:	6105                	addi	sp,sp,32
 5f4:	8082                	ret

00000000000005f6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5f6:	715d                	addi	sp,sp,-80
 5f8:	e486                	sd	ra,72(sp)
 5fa:	e0a2                	sd	s0,64(sp)
 5fc:	f84a                	sd	s2,48(sp)
 5fe:	0880                	addi	s0,sp,80
 600:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 602:	c299                	beqz	a3,608 <printint+0x12>
 604:	0805c363          	bltz	a1,68a <printint+0x94>
  neg = 0;
 608:	4881                	li	a7,0
 60a:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 60e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 610:	00000517          	auipc	a0,0x0
 614:	59850513          	addi	a0,a0,1432 # ba8 <digits>
 618:	883e                	mv	a6,a5
 61a:	2785                	addiw	a5,a5,1
 61c:	02c5f733          	remu	a4,a1,a2
 620:	972a                	add	a4,a4,a0
 622:	00074703          	lbu	a4,0(a4)
 626:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 62a:	872e                	mv	a4,a1
 62c:	02c5d5b3          	divu	a1,a1,a2
 630:	0685                	addi	a3,a3,1
 632:	fec773e3          	bgeu	a4,a2,618 <printint+0x22>
  if(neg)
 636:	00088b63          	beqz	a7,64c <printint+0x56>
    buf[i++] = '-';
 63a:	fd078793          	addi	a5,a5,-48
 63e:	97a2                	add	a5,a5,s0
 640:	02d00713          	li	a4,45
 644:	fee78423          	sb	a4,-24(a5)
 648:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 64c:	02f05a63          	blez	a5,680 <printint+0x8a>
 650:	fc26                	sd	s1,56(sp)
 652:	f44e                	sd	s3,40(sp)
 654:	fb840713          	addi	a4,s0,-72
 658:	00f704b3          	add	s1,a4,a5
 65c:	fff70993          	addi	s3,a4,-1
 660:	99be                	add	s3,s3,a5
 662:	37fd                	addiw	a5,a5,-1
 664:	1782                	slli	a5,a5,0x20
 666:	9381                	srli	a5,a5,0x20
 668:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 66c:	fff4c583          	lbu	a1,-1(s1)
 670:	854a                	mv	a0,s2
 672:	f67ff0ef          	jal	5d8 <putc>
  while(--i >= 0)
 676:	14fd                	addi	s1,s1,-1
 678:	ff349ae3          	bne	s1,s3,66c <printint+0x76>
 67c:	74e2                	ld	s1,56(sp)
 67e:	79a2                	ld	s3,40(sp)
}
 680:	60a6                	ld	ra,72(sp)
 682:	6406                	ld	s0,64(sp)
 684:	7942                	ld	s2,48(sp)
 686:	6161                	addi	sp,sp,80
 688:	8082                	ret
    x = -xx;
 68a:	40b005b3          	neg	a1,a1
    neg = 1;
 68e:	4885                	li	a7,1
    x = -xx;
 690:	bfad                	j	60a <printint+0x14>

0000000000000692 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 692:	711d                	addi	sp,sp,-96
 694:	ec86                	sd	ra,88(sp)
 696:	e8a2                	sd	s0,80(sp)
 698:	e0ca                	sd	s2,64(sp)
 69a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 69c:	0005c903          	lbu	s2,0(a1)
 6a0:	28090663          	beqz	s2,92c <vprintf+0x29a>
 6a4:	e4a6                	sd	s1,72(sp)
 6a6:	fc4e                	sd	s3,56(sp)
 6a8:	f852                	sd	s4,48(sp)
 6aa:	f456                	sd	s5,40(sp)
 6ac:	f05a                	sd	s6,32(sp)
 6ae:	ec5e                	sd	s7,24(sp)
 6b0:	e862                	sd	s8,16(sp)
 6b2:	e466                	sd	s9,8(sp)
 6b4:	8b2a                	mv	s6,a0
 6b6:	8a2e                	mv	s4,a1
 6b8:	8bb2                	mv	s7,a2
  state = 0;
 6ba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6bc:	4481                	li	s1,0
 6be:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6c8:	06c00c93          	li	s9,108
 6cc:	a005                	j	6ec <vprintf+0x5a>
        putc(fd, c0);
 6ce:	85ca                	mv	a1,s2
 6d0:	855a                	mv	a0,s6
 6d2:	f07ff0ef          	jal	5d8 <putc>
 6d6:	a019                	j	6dc <vprintf+0x4a>
    } else if(state == '%'){
 6d8:	03598263          	beq	s3,s5,6fc <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6dc:	2485                	addiw	s1,s1,1
 6de:	8726                	mv	a4,s1
 6e0:	009a07b3          	add	a5,s4,s1
 6e4:	0007c903          	lbu	s2,0(a5)
 6e8:	22090a63          	beqz	s2,91c <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 6ec:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6f0:	fe0994e3          	bnez	s3,6d8 <vprintf+0x46>
      if(c0 == '%'){
 6f4:	fd579de3          	bne	a5,s5,6ce <vprintf+0x3c>
        state = '%';
 6f8:	89be                	mv	s3,a5
 6fa:	b7cd                	j	6dc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6fc:	00ea06b3          	add	a3,s4,a4
 700:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 704:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 706:	c681                	beqz	a3,70e <vprintf+0x7c>
 708:	9752                	add	a4,a4,s4
 70a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 70e:	05878363          	beq	a5,s8,754 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 712:	05978d63          	beq	a5,s9,76c <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 716:	07500713          	li	a4,117
 71a:	0ee78763          	beq	a5,a4,808 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 71e:	07800713          	li	a4,120
 722:	12e78963          	beq	a5,a4,854 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 726:	07000713          	li	a4,112
 72a:	14e78e63          	beq	a5,a4,886 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 72e:	06300713          	li	a4,99
 732:	18e78e63          	beq	a5,a4,8ce <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 736:	07300713          	li	a4,115
 73a:	1ae78463          	beq	a5,a4,8e2 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 73e:	02500713          	li	a4,37
 742:	04e79563          	bne	a5,a4,78c <vprintf+0xfa>
        putc(fd, '%');
 746:	02500593          	li	a1,37
 74a:	855a                	mv	a0,s6
 74c:	e8dff0ef          	jal	5d8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 750:	4981                	li	s3,0
 752:	b769                	j	6dc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 754:	008b8913          	addi	s2,s7,8
 758:	4685                	li	a3,1
 75a:	4629                	li	a2,10
 75c:	000ba583          	lw	a1,0(s7)
 760:	855a                	mv	a0,s6
 762:	e95ff0ef          	jal	5f6 <printint>
 766:	8bca                	mv	s7,s2
      state = 0;
 768:	4981                	li	s3,0
 76a:	bf8d                	j	6dc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 76c:	06400793          	li	a5,100
 770:	02f68963          	beq	a3,a5,7a2 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 774:	06c00793          	li	a5,108
 778:	04f68263          	beq	a3,a5,7bc <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 77c:	07500793          	li	a5,117
 780:	0af68063          	beq	a3,a5,820 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 784:	07800793          	li	a5,120
 788:	0ef68263          	beq	a3,a5,86c <vprintf+0x1da>
        putc(fd, '%');
 78c:	02500593          	li	a1,37
 790:	855a                	mv	a0,s6
 792:	e47ff0ef          	jal	5d8 <putc>
        putc(fd, c0);
 796:	85ca                	mv	a1,s2
 798:	855a                	mv	a0,s6
 79a:	e3fff0ef          	jal	5d8 <putc>
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bf35                	j	6dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a2:	008b8913          	addi	s2,s7,8
 7a6:	4685                	li	a3,1
 7a8:	4629                	li	a2,10
 7aa:	000bb583          	ld	a1,0(s7)
 7ae:	855a                	mv	a0,s6
 7b0:	e47ff0ef          	jal	5f6 <printint>
        i += 1;
 7b4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b6:	8bca                	mv	s7,s2
      state = 0;
 7b8:	4981                	li	s3,0
        i += 1;
 7ba:	b70d                	j	6dc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7bc:	06400793          	li	a5,100
 7c0:	02f60763          	beq	a2,a5,7ee <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7c4:	07500793          	li	a5,117
 7c8:	06f60963          	beq	a2,a5,83a <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7cc:	07800793          	li	a5,120
 7d0:	faf61ee3          	bne	a2,a5,78c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d4:	008b8913          	addi	s2,s7,8
 7d8:	4681                	li	a3,0
 7da:	4641                	li	a2,16
 7dc:	000bb583          	ld	a1,0(s7)
 7e0:	855a                	mv	a0,s6
 7e2:	e15ff0ef          	jal	5f6 <printint>
        i += 2;
 7e6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e8:	8bca                	mv	s7,s2
      state = 0;
 7ea:	4981                	li	s3,0
        i += 2;
 7ec:	bdc5                	j	6dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ee:	008b8913          	addi	s2,s7,8
 7f2:	4685                	li	a3,1
 7f4:	4629                	li	a2,10
 7f6:	000bb583          	ld	a1,0(s7)
 7fa:	855a                	mv	a0,s6
 7fc:	dfbff0ef          	jal	5f6 <printint>
        i += 2;
 800:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 802:	8bca                	mv	s7,s2
      state = 0;
 804:	4981                	li	s3,0
        i += 2;
 806:	bdd9                	j	6dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 808:	008b8913          	addi	s2,s7,8
 80c:	4681                	li	a3,0
 80e:	4629                	li	a2,10
 810:	000be583          	lwu	a1,0(s7)
 814:	855a                	mv	a0,s6
 816:	de1ff0ef          	jal	5f6 <printint>
 81a:	8bca                	mv	s7,s2
      state = 0;
 81c:	4981                	li	s3,0
 81e:	bd7d                	j	6dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 820:	008b8913          	addi	s2,s7,8
 824:	4681                	li	a3,0
 826:	4629                	li	a2,10
 828:	000bb583          	ld	a1,0(s7)
 82c:	855a                	mv	a0,s6
 82e:	dc9ff0ef          	jal	5f6 <printint>
        i += 1;
 832:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 834:	8bca                	mv	s7,s2
      state = 0;
 836:	4981                	li	s3,0
        i += 1;
 838:	b555                	j	6dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 83a:	008b8913          	addi	s2,s7,8
 83e:	4681                	li	a3,0
 840:	4629                	li	a2,10
 842:	000bb583          	ld	a1,0(s7)
 846:	855a                	mv	a0,s6
 848:	dafff0ef          	jal	5f6 <printint>
        i += 2;
 84c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 84e:	8bca                	mv	s7,s2
      state = 0;
 850:	4981                	li	s3,0
        i += 2;
 852:	b569                	j	6dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 854:	008b8913          	addi	s2,s7,8
 858:	4681                	li	a3,0
 85a:	4641                	li	a2,16
 85c:	000be583          	lwu	a1,0(s7)
 860:	855a                	mv	a0,s6
 862:	d95ff0ef          	jal	5f6 <printint>
 866:	8bca                	mv	s7,s2
      state = 0;
 868:	4981                	li	s3,0
 86a:	bd8d                	j	6dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 86c:	008b8913          	addi	s2,s7,8
 870:	4681                	li	a3,0
 872:	4641                	li	a2,16
 874:	000bb583          	ld	a1,0(s7)
 878:	855a                	mv	a0,s6
 87a:	d7dff0ef          	jal	5f6 <printint>
        i += 1;
 87e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 880:	8bca                	mv	s7,s2
      state = 0;
 882:	4981                	li	s3,0
        i += 1;
 884:	bda1                	j	6dc <vprintf+0x4a>
 886:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 888:	008b8d13          	addi	s10,s7,8
 88c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 890:	03000593          	li	a1,48
 894:	855a                	mv	a0,s6
 896:	d43ff0ef          	jal	5d8 <putc>
  putc(fd, 'x');
 89a:	07800593          	li	a1,120
 89e:	855a                	mv	a0,s6
 8a0:	d39ff0ef          	jal	5d8 <putc>
 8a4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8a6:	00000b97          	auipc	s7,0x0
 8aa:	302b8b93          	addi	s7,s7,770 # ba8 <digits>
 8ae:	03c9d793          	srli	a5,s3,0x3c
 8b2:	97de                	add	a5,a5,s7
 8b4:	0007c583          	lbu	a1,0(a5)
 8b8:	855a                	mv	a0,s6
 8ba:	d1fff0ef          	jal	5d8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8be:	0992                	slli	s3,s3,0x4
 8c0:	397d                	addiw	s2,s2,-1
 8c2:	fe0916e3          	bnez	s2,8ae <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 8c6:	8bea                	mv	s7,s10
      state = 0;
 8c8:	4981                	li	s3,0
 8ca:	6d02                	ld	s10,0(sp)
 8cc:	bd01                	j	6dc <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 8ce:	008b8913          	addi	s2,s7,8
 8d2:	000bc583          	lbu	a1,0(s7)
 8d6:	855a                	mv	a0,s6
 8d8:	d01ff0ef          	jal	5d8 <putc>
 8dc:	8bca                	mv	s7,s2
      state = 0;
 8de:	4981                	li	s3,0
 8e0:	bbf5                	j	6dc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8e2:	008b8993          	addi	s3,s7,8
 8e6:	000bb903          	ld	s2,0(s7)
 8ea:	00090f63          	beqz	s2,908 <vprintf+0x276>
        for(; *s; s++)
 8ee:	00094583          	lbu	a1,0(s2)
 8f2:	c195                	beqz	a1,916 <vprintf+0x284>
          putc(fd, *s);
 8f4:	855a                	mv	a0,s6
 8f6:	ce3ff0ef          	jal	5d8 <putc>
        for(; *s; s++)
 8fa:	0905                	addi	s2,s2,1
 8fc:	00094583          	lbu	a1,0(s2)
 900:	f9f5                	bnez	a1,8f4 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 902:	8bce                	mv	s7,s3
      state = 0;
 904:	4981                	li	s3,0
 906:	bbd9                	j	6dc <vprintf+0x4a>
          s = "(null)";
 908:	00000917          	auipc	s2,0x0
 90c:	29890913          	addi	s2,s2,664 # ba0 <malloc+0x18c>
        for(; *s; s++)
 910:	02800593          	li	a1,40
 914:	b7c5                	j	8f4 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 916:	8bce                	mv	s7,s3
      state = 0;
 918:	4981                	li	s3,0
 91a:	b3c9                	j	6dc <vprintf+0x4a>
 91c:	64a6                	ld	s1,72(sp)
 91e:	79e2                	ld	s3,56(sp)
 920:	7a42                	ld	s4,48(sp)
 922:	7aa2                	ld	s5,40(sp)
 924:	7b02                	ld	s6,32(sp)
 926:	6be2                	ld	s7,24(sp)
 928:	6c42                	ld	s8,16(sp)
 92a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 92c:	60e6                	ld	ra,88(sp)
 92e:	6446                	ld	s0,80(sp)
 930:	6906                	ld	s2,64(sp)
 932:	6125                	addi	sp,sp,96
 934:	8082                	ret

0000000000000936 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 936:	715d                	addi	sp,sp,-80
 938:	ec06                	sd	ra,24(sp)
 93a:	e822                	sd	s0,16(sp)
 93c:	1000                	addi	s0,sp,32
 93e:	e010                	sd	a2,0(s0)
 940:	e414                	sd	a3,8(s0)
 942:	e818                	sd	a4,16(s0)
 944:	ec1c                	sd	a5,24(s0)
 946:	03043023          	sd	a6,32(s0)
 94a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 94e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 952:	8622                	mv	a2,s0
 954:	d3fff0ef          	jal	692 <vprintf>
}
 958:	60e2                	ld	ra,24(sp)
 95a:	6442                	ld	s0,16(sp)
 95c:	6161                	addi	sp,sp,80
 95e:	8082                	ret

0000000000000960 <printf>:

void
printf(const char *fmt, ...)
{
 960:	711d                	addi	sp,sp,-96
 962:	ec06                	sd	ra,24(sp)
 964:	e822                	sd	s0,16(sp)
 966:	1000                	addi	s0,sp,32
 968:	e40c                	sd	a1,8(s0)
 96a:	e810                	sd	a2,16(s0)
 96c:	ec14                	sd	a3,24(s0)
 96e:	f018                	sd	a4,32(s0)
 970:	f41c                	sd	a5,40(s0)
 972:	03043823          	sd	a6,48(s0)
 976:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 97a:	00840613          	addi	a2,s0,8
 97e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 982:	85aa                	mv	a1,a0
 984:	4505                	li	a0,1
 986:	d0dff0ef          	jal	692 <vprintf>
}
 98a:	60e2                	ld	ra,24(sp)
 98c:	6442                	ld	s0,16(sp)
 98e:	6125                	addi	sp,sp,96
 990:	8082                	ret

0000000000000992 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 992:	1141                	addi	sp,sp,-16
 994:	e422                	sd	s0,8(sp)
 996:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 998:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99c:	00000797          	auipc	a5,0x0
 9a0:	6647b783          	ld	a5,1636(a5) # 1000 <freep>
 9a4:	a02d                	j	9ce <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9a6:	4618                	lw	a4,8(a2)
 9a8:	9f2d                	addw	a4,a4,a1
 9aa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9ae:	6398                	ld	a4,0(a5)
 9b0:	6310                	ld	a2,0(a4)
 9b2:	a83d                	j	9f0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9b4:	ff852703          	lw	a4,-8(a0)
 9b8:	9f31                	addw	a4,a4,a2
 9ba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9bc:	ff053683          	ld	a3,-16(a0)
 9c0:	a091                	j	a04 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c2:	6398                	ld	a4,0(a5)
 9c4:	00e7e463          	bltu	a5,a4,9cc <free+0x3a>
 9c8:	00e6ea63          	bltu	a3,a4,9dc <free+0x4a>
{
 9cc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ce:	fed7fae3          	bgeu	a5,a3,9c2 <free+0x30>
 9d2:	6398                	ld	a4,0(a5)
 9d4:	00e6e463          	bltu	a3,a4,9dc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d8:	fee7eae3          	bltu	a5,a4,9cc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9dc:	ff852583          	lw	a1,-8(a0)
 9e0:	6390                	ld	a2,0(a5)
 9e2:	02059813          	slli	a6,a1,0x20
 9e6:	01c85713          	srli	a4,a6,0x1c
 9ea:	9736                	add	a4,a4,a3
 9ec:	fae60de3          	beq	a2,a4,9a6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9f0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9f4:	4790                	lw	a2,8(a5)
 9f6:	02061593          	slli	a1,a2,0x20
 9fa:	01c5d713          	srli	a4,a1,0x1c
 9fe:	973e                	add	a4,a4,a5
 a00:	fae68ae3          	beq	a3,a4,9b4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a04:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a06:	00000717          	auipc	a4,0x0
 a0a:	5ef73d23          	sd	a5,1530(a4) # 1000 <freep>
}
 a0e:	6422                	ld	s0,8(sp)
 a10:	0141                	addi	sp,sp,16
 a12:	8082                	ret

0000000000000a14 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a14:	7139                	addi	sp,sp,-64
 a16:	fc06                	sd	ra,56(sp)
 a18:	f822                	sd	s0,48(sp)
 a1a:	f426                	sd	s1,40(sp)
 a1c:	ec4e                	sd	s3,24(sp)
 a1e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a20:	02051493          	slli	s1,a0,0x20
 a24:	9081                	srli	s1,s1,0x20
 a26:	04bd                	addi	s1,s1,15
 a28:	8091                	srli	s1,s1,0x4
 a2a:	0014899b          	addiw	s3,s1,1
 a2e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a30:	00000517          	auipc	a0,0x0
 a34:	5d053503          	ld	a0,1488(a0) # 1000 <freep>
 a38:	c915                	beqz	a0,a6c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a3a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a3c:	4798                	lw	a4,8(a5)
 a3e:	08977a63          	bgeu	a4,s1,ad2 <malloc+0xbe>
 a42:	f04a                	sd	s2,32(sp)
 a44:	e852                	sd	s4,16(sp)
 a46:	e456                	sd	s5,8(sp)
 a48:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a4a:	8a4e                	mv	s4,s3
 a4c:	0009871b          	sext.w	a4,s3
 a50:	6685                	lui	a3,0x1
 a52:	00d77363          	bgeu	a4,a3,a58 <malloc+0x44>
 a56:	6a05                	lui	s4,0x1
 a58:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a5c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a60:	00000917          	auipc	s2,0x0
 a64:	5a090913          	addi	s2,s2,1440 # 1000 <freep>
  if(p == SBRK_ERROR)
 a68:	5afd                	li	s5,-1
 a6a:	a081                	j	aaa <malloc+0x96>
 a6c:	f04a                	sd	s2,32(sp)
 a6e:	e852                	sd	s4,16(sp)
 a70:	e456                	sd	s5,8(sp)
 a72:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a74:	00000797          	auipc	a5,0x0
 a78:	59c78793          	addi	a5,a5,1436 # 1010 <base>
 a7c:	00000717          	auipc	a4,0x0
 a80:	58f73223          	sd	a5,1412(a4) # 1000 <freep>
 a84:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a86:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a8a:	b7c1                	j	a4a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a8c:	6398                	ld	a4,0(a5)
 a8e:	e118                	sd	a4,0(a0)
 a90:	a8a9                	j	aea <malloc+0xd6>
  hp->s.size = nu;
 a92:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a96:	0541                	addi	a0,a0,16
 a98:	efbff0ef          	jal	992 <free>
  return freep;
 a9c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 aa0:	c12d                	beqz	a0,b02 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa4:	4798                	lw	a4,8(a5)
 aa6:	02977263          	bgeu	a4,s1,aca <malloc+0xb6>
    if(p == freep)
 aaa:	00093703          	ld	a4,0(s2)
 aae:	853e                	mv	a0,a5
 ab0:	fef719e3          	bne	a4,a5,aa2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 ab4:	8552                	mv	a0,s4
 ab6:	a3fff0ef          	jal	4f4 <sbrk>
  if(p == SBRK_ERROR)
 aba:	fd551ce3          	bne	a0,s5,a92 <malloc+0x7e>
        return 0;
 abe:	4501                	li	a0,0
 ac0:	7902                	ld	s2,32(sp)
 ac2:	6a42                	ld	s4,16(sp)
 ac4:	6aa2                	ld	s5,8(sp)
 ac6:	6b02                	ld	s6,0(sp)
 ac8:	a03d                	j	af6 <malloc+0xe2>
 aca:	7902                	ld	s2,32(sp)
 acc:	6a42                	ld	s4,16(sp)
 ace:	6aa2                	ld	s5,8(sp)
 ad0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ad2:	fae48de3          	beq	s1,a4,a8c <malloc+0x78>
        p->s.size -= nunits;
 ad6:	4137073b          	subw	a4,a4,s3
 ada:	c798                	sw	a4,8(a5)
        p += p->s.size;
 adc:	02071693          	slli	a3,a4,0x20
 ae0:	01c6d713          	srli	a4,a3,0x1c
 ae4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ae6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aea:	00000717          	auipc	a4,0x0
 aee:	50a73b23          	sd	a0,1302(a4) # 1000 <freep>
      return (void*)(p + 1);
 af2:	01078513          	addi	a0,a5,16
  }
}
 af6:	70e2                	ld	ra,56(sp)
 af8:	7442                	ld	s0,48(sp)
 afa:	74a2                	ld	s1,40(sp)
 afc:	69e2                	ld	s3,24(sp)
 afe:	6121                	addi	sp,sp,64
 b00:	8082                	ret
 b02:	7902                	ld	s2,32(sp)
 b04:	6a42                	ld	s4,16(sp)
 b06:	6aa2                	ld	s5,8(sp)
 b08:	6b02                	ld	s6,0(sp)
 b0a:	b7f5                	j	af6 <malloc+0xe2>
