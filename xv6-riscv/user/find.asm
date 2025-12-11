
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/fs.h"
#include "kernel/param.h"

void
find(char *path, char *target, char **exec_args)
{
   0:	c9010113          	addi	sp,sp,-880
   4:	36113423          	sd	ra,872(sp)
   8:	36813023          	sd	s0,864(sp)
   c:	34913c23          	sd	s1,856(sp)
  10:	35313423          	sd	s3,840(sp)
  14:	35413023          	sd	s4,832(sp)
  18:	1e80                	addi	s0,sp,880
  1a:	84aa                	mv	s1,a0
  1c:	89ae                	mv	s3,a1
  1e:	8a32                	mv	s4,a2
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  20:	4581                	li	a1,0
  22:	51e000ef          	jal	540 <open>
  26:	04054963          	bltz	a0,78 <find+0x78>
  2a:	35213823          	sd	s2,848(sp)
  2e:	892a                	mv	s2,a0
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  30:	d9840593          	addi	a1,s0,-616
  34:	524000ef          	jal	558 <fstat>
  38:	04054963          	bltz	a0,8a <find+0x8a>
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  3c:	da041783          	lh	a5,-608(s0)
  40:	4705                	li	a4,1
  42:	10e78063          	beq	a5,a4,142 <find+0x142>
  46:	4709                	li	a4,2
  48:	10e79b63          	bne	a5,a4,15e <find+0x15e>
  case T_FILE:
    char *name = path;
    for(int i = strlen(path) - 1; i >= 0; i--){
  4c:	8526                	mv	a0,s1
  4e:	276000ef          	jal	2c4 <strlen>
  52:	fff5079b          	addiw	a5,a0,-1
  56:	0607c863          	bltz	a5,c6 <find+0xc6>
      if(path[i] == '/'){
  5a:	02f00693          	li	a3,47
  5e:	00f48733          	add	a4,s1,a5
  62:	00074703          	lbu	a4,0(a4)
  66:	04d70063          	beq	a4,a3,a6 <find+0xa6>
    for(int i = strlen(path) - 1; i >= 0; i--){
  6a:	17fd                	addi	a5,a5,-1
  6c:	02079713          	slli	a4,a5,0x20
  70:	fe0757e3          	bgez	a4,5e <find+0x5e>
    char *name = path;
  74:	8526                	mv	a0,s1
  76:	a81d                	j	ac <find+0xac>
    fprintf(2, "find: cannot open %s\n", path);
  78:	8626                	mv	a2,s1
  7a:	00001597          	auipc	a1,0x1
  7e:	a6658593          	addi	a1,a1,-1434 # ae0 <malloc+0xfc>
  82:	4509                	li	a0,2
  84:	083000ef          	jal	906 <fprintf>
    return;
  88:	a0c5                	j	168 <find+0x168>
    fprintf(2, "find: cannot stat %s\n", path);
  8a:	8626                	mv	a2,s1
  8c:	00001597          	auipc	a1,0x1
  90:	a7458593          	addi	a1,a1,-1420 # b00 <malloc+0x11c>
  94:	4509                	li	a0,2
  96:	071000ef          	jal	906 <fprintf>
    close(fd);
  9a:	854a                	mv	a0,s2
  9c:	48c000ef          	jal	528 <close>
    return;
  a0:	35013903          	ld	s2,848(sp)
  a4:	a0d1                	j	168 <find+0x168>
        name = path + i + 1;
  a6:	0785                	addi	a5,a5,1
  a8:	00f48533          	add	a0,s1,a5
        break;
      }
    }

    if(strcmp(name, target) == 0){
  ac:	85ce                	mv	a1,s3
  ae:	1ea000ef          	jal	298 <strcmp>
  b2:	e555                	bnez	a0,15e <find+0x15e>
      if(exec_args == 0){
  b4:	000a0b63          	beqz	s4,ca <find+0xca>
        printf("%s\n", path);
      } else {
        int pid = fork();
  b8:	440000ef          	jal	4f8 <fork>
        if(pid == 0){
  bc:	cd19                	beqz	a0,da <find+0xda>
            argv[i] = 0;
            exec(argv[0], argv);
            fprintf(2, "exec %s failed\n", argv[0]);
            exit(1);
        } else {
            wait(0);
  be:	4501                	li	a0,0
  c0:	448000ef          	jal	508 <wait>
  c4:	a869                	j	15e <find+0x15e>
    char *name = path;
  c6:	8526                	mv	a0,s1
  c8:	b7d5                	j	ac <find+0xac>
        printf("%s\n", path);
  ca:	85a6                	mv	a1,s1
  cc:	00001517          	auipc	a0,0x1
  d0:	a4c50513          	addi	a0,a0,-1460 # b18 <malloc+0x134>
  d4:	05d000ef          	jal	930 <printf>
  d8:	a059                	j	15e <find+0x15e>
  da:	33513c23          	sd	s5,824(sp)
  de:	33613823          	sd	s6,816(sp)
  e2:	c9840713          	addi	a4,s0,-872
        if(pid == 0){
  e6:	4781                	li	a5,0
            while(exec_args[i] != 0 && i < MAXARG - 1){
  e8:	467d                	li	a2,31
  ea:	a021                	j	f2 <find+0xf2>
                argv[i] = exec_args[i];
  ec:	e314                	sd	a3,0(a4)
                i++;
  ee:	0785                	addi	a5,a5,1
  f0:	0721                	addi	a4,a4,8
            while(exec_args[i] != 0 && i < MAXARG - 1){
  f2:	00379693          	slli	a3,a5,0x3
  f6:	96d2                	add	a3,a3,s4
  f8:	6294                	ld	a3,0(a3)
  fa:	c299                	beqz	a3,100 <find+0x100>
  fc:	fec798e3          	bne	a5,a2,ec <find+0xec>
 100:	2781                	sext.w	a5,a5
            argv[i] = path;
 102:	00379713          	slli	a4,a5,0x3
 106:	fc070713          	addi	a4,a4,-64
 10a:	9722                	add	a4,a4,s0
 10c:	cc973c23          	sd	s1,-808(a4)
            argv[i] = 0;
 110:	2785                	addiw	a5,a5,1
 112:	078e                	slli	a5,a5,0x3
 114:	fc078793          	addi	a5,a5,-64
 118:	97a2                	add	a5,a5,s0
 11a:	cc07bc23          	sd	zero,-808(a5)
            exec(argv[0], argv);
 11e:	c9840593          	addi	a1,s0,-872
 122:	c9843503          	ld	a0,-872(s0)
 126:	412000ef          	jal	538 <exec>
            fprintf(2, "exec %s failed\n", argv[0]);
 12a:	c9843603          	ld	a2,-872(s0)
 12e:	00001597          	auipc	a1,0x1
 132:	9f258593          	addi	a1,a1,-1550 # b20 <malloc+0x13c>
 136:	4509                	li	a0,2
 138:	7ce000ef          	jal	906 <fprintf>
            exit(1);
 13c:	4505                	li	a0,1
 13e:	3c2000ef          	jal	500 <exit>
      }
    }
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)){
 142:	8526                	mv	a0,s1
 144:	180000ef          	jal	2c4 <strlen>
 148:	2541                	addiw	a0,a0,16
 14a:	20000793          	li	a5,512
 14e:	02a7fa63          	bgeu	a5,a0,182 <find+0x182>
      printf("find: path too long\n");
 152:	00001517          	auipc	a0,0x1
 156:	9de50513          	addi	a0,a0,-1570 # b30 <malloc+0x14c>
 15a:	7d6000ef          	jal	930 <printf>
        continue;
      find(buf, target, exec_args);
    }
    break;
  }
  close(fd);
 15e:	854a                	mv	a0,s2
 160:	3c8000ef          	jal	528 <close>
 164:	35013903          	ld	s2,848(sp)
}
 168:	36813083          	ld	ra,872(sp)
 16c:	36013403          	ld	s0,864(sp)
 170:	35813483          	ld	s1,856(sp)
 174:	34813983          	ld	s3,840(sp)
 178:	34013a03          	ld	s4,832(sp)
 17c:	37010113          	addi	sp,sp,880
 180:	8082                	ret
 182:	33513c23          	sd	s5,824(sp)
 186:	33613823          	sd	s6,816(sp)
    strcpy(buf, path);
 18a:	85a6                	mv	a1,s1
 18c:	dc040513          	addi	a0,s0,-576
 190:	0ec000ef          	jal	27c <strcpy>
    p = buf + strlen(buf);
 194:	dc040513          	addi	a0,s0,-576
 198:	12c000ef          	jal	2c4 <strlen>
 19c:	1502                	slli	a0,a0,0x20
 19e:	9101                	srli	a0,a0,0x20
 1a0:	dc040793          	addi	a5,s0,-576
 1a4:	00a784b3          	add	s1,a5,a0
    *p++ = '/';
 1a8:	00148a93          	addi	s5,s1,1
 1ac:	02f00793          	li	a5,47
 1b0:	00f48023          	sb	a5,0(s1)
      if(strcmp(p, ".") == 0 || strcmp(p, "..") == 0)
 1b4:	00001b17          	auipc	s6,0x1
 1b8:	994b0b13          	addi	s6,s6,-1644 # b48 <malloc+0x164>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1bc:	4641                	li	a2,16
 1be:	db040593          	addi	a1,s0,-592
 1c2:	854a                	mv	a0,s2
 1c4:	354000ef          	jal	518 <read>
 1c8:	47c1                	li	a5,16
 1ca:	04f51163          	bne	a0,a5,20c <find+0x20c>
      if(de.inum == 0)
 1ce:	db045783          	lhu	a5,-592(s0)
 1d2:	d7ed                	beqz	a5,1bc <find+0x1bc>
      memmove(p, de.name, DIRSIZ);
 1d4:	4639                	li	a2,14
 1d6:	db240593          	addi	a1,s0,-590
 1da:	8556                	mv	a0,s5
 1dc:	24a000ef          	jal	426 <memmove>
      p[DIRSIZ] = 0;
 1e0:	000487a3          	sb	zero,15(s1)
      if(strcmp(p, ".") == 0 || strcmp(p, "..") == 0)
 1e4:	85da                	mv	a1,s6
 1e6:	8556                	mv	a0,s5
 1e8:	0b0000ef          	jal	298 <strcmp>
 1ec:	d961                	beqz	a0,1bc <find+0x1bc>
 1ee:	00001597          	auipc	a1,0x1
 1f2:	96258593          	addi	a1,a1,-1694 # b50 <malloc+0x16c>
 1f6:	8556                	mv	a0,s5
 1f8:	0a0000ef          	jal	298 <strcmp>
 1fc:	d161                	beqz	a0,1bc <find+0x1bc>
      find(buf, target, exec_args);
 1fe:	8652                	mv	a2,s4
 200:	85ce                	mv	a1,s3
 202:	dc040513          	addi	a0,s0,-576
 206:	dfbff0ef          	jal	0 <find>
 20a:	bf4d                	j	1bc <find+0x1bc>
 20c:	33813a83          	ld	s5,824(sp)
 210:	33013b03          	ld	s6,816(sp)
 214:	b7a9                	j	15e <find+0x15e>

0000000000000216 <main>:

int
main(int argc, char *argv[])
{
 216:	1101                	addi	sp,sp,-32
 218:	ec06                	sd	ra,24(sp)
 21a:	e822                	sd	s0,16(sp)
 21c:	1000                	addi	s0,sp,32
  if(argc < 3){
 21e:	4789                	li	a5,2
 220:	00a7df63          	bge	a5,a0,23e <main+0x28>
 224:	e426                	sd	s1,8(sp)
 226:	84ae                	mv	s1,a1
    fprintf(2, "usage: find <path> <name> [-exec cmd...]\n");
    exit(1);
  }

  char **exec_args = 0;
  if(argc > 3 && strcmp(argv[3], "-exec") == 0){
 228:	478d                	li	a5,3
  char **exec_args = 0;
 22a:	4601                	li	a2,0
  if(argc > 3 && strcmp(argv[3], "-exec") == 0){
 22c:	02a7c463          	blt	a5,a0,254 <main+0x3e>
    exec_args = &argv[4];
  }

  find(argv[1], argv[2], exec_args);
 230:	688c                	ld	a1,16(s1)
 232:	6488                	ld	a0,8(s1)
 234:	dcdff0ef          	jal	0 <find>
  exit(0);
 238:	4501                	li	a0,0
 23a:	2c6000ef          	jal	500 <exit>
 23e:	e426                	sd	s1,8(sp)
    fprintf(2, "usage: find <path> <name> [-exec cmd...]\n");
 240:	00001597          	auipc	a1,0x1
 244:	91858593          	addi	a1,a1,-1768 # b58 <malloc+0x174>
 248:	4509                	li	a0,2
 24a:	6bc000ef          	jal	906 <fprintf>
    exit(1);
 24e:	4505                	li	a0,1
 250:	2b0000ef          	jal	500 <exit>
  if(argc > 3 && strcmp(argv[3], "-exec") == 0){
 254:	00001597          	auipc	a1,0x1
 258:	93458593          	addi	a1,a1,-1740 # b88 <malloc+0x1a4>
 25c:	6c88                	ld	a0,24(s1)
 25e:	03a000ef          	jal	298 <strcmp>
  char **exec_args = 0;
 262:	4601                	li	a2,0
  if(argc > 3 && strcmp(argv[3], "-exec") == 0){
 264:	f571                	bnez	a0,230 <main+0x1a>
    exec_args = &argv[4];
 266:	02048613          	addi	a2,s1,32
 26a:	b7d9                	j	230 <main+0x1a>

000000000000026c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 274:	fa3ff0ef          	jal	216 <main>
  exit(r);
 278:	288000ef          	jal	500 <exit>

000000000000027c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e422                	sd	s0,8(sp)
 280:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 282:	87aa                	mv	a5,a0
 284:	0585                	addi	a1,a1,1
 286:	0785                	addi	a5,a5,1
 288:	fff5c703          	lbu	a4,-1(a1)
 28c:	fee78fa3          	sb	a4,-1(a5)
 290:	fb75                	bnez	a4,284 <strcpy+0x8>
    ;
  return os;
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret

0000000000000298 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	cb91                	beqz	a5,2b6 <strcmp+0x1e>
 2a4:	0005c703          	lbu	a4,0(a1)
 2a8:	00f71763          	bne	a4,a5,2b6 <strcmp+0x1e>
    p++, q++;
 2ac:	0505                	addi	a0,a0,1
 2ae:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2b0:	00054783          	lbu	a5,0(a0)
 2b4:	fbe5                	bnez	a5,2a4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b6:	0005c503          	lbu	a0,0(a1)
}
 2ba:	40a7853b          	subw	a0,a5,a0
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret

00000000000002c4 <strlen>:

uint
strlen(const char *s)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	cf91                	beqz	a5,2ea <strlen+0x26>
 2d0:	0505                	addi	a0,a0,1
 2d2:	87aa                	mv	a5,a0
 2d4:	86be                	mv	a3,a5
 2d6:	0785                	addi	a5,a5,1
 2d8:	fff7c703          	lbu	a4,-1(a5)
 2dc:	ff65                	bnez	a4,2d4 <strlen+0x10>
 2de:	40a6853b          	subw	a0,a3,a0
 2e2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret
  for(n = 0; s[n]; n++)
 2ea:	4501                	li	a0,0
 2ec:	bfe5                	j	2e4 <strlen+0x20>

00000000000002ee <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e422                	sd	s0,8(sp)
 2f2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f4:	ca19                	beqz	a2,30a <memset+0x1c>
 2f6:	87aa                	mv	a5,a0
 2f8:	1602                	slli	a2,a2,0x20
 2fa:	9201                	srli	a2,a2,0x20
 2fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 300:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 304:	0785                	addi	a5,a5,1
 306:	fee79de3          	bne	a5,a4,300 <memset+0x12>
  }
  return dst;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <strchr>:

char*
strchr(const char *s, char c)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  for(; *s; s++)
 316:	00054783          	lbu	a5,0(a0)
 31a:	cb99                	beqz	a5,330 <strchr+0x20>
    if(*s == c)
 31c:	00f58763          	beq	a1,a5,32a <strchr+0x1a>
  for(; *s; s++)
 320:	0505                	addi	a0,a0,1
 322:	00054783          	lbu	a5,0(a0)
 326:	fbfd                	bnez	a5,31c <strchr+0xc>
      return (char*)s;
  return 0;
 328:	4501                	li	a0,0
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  return 0;
 330:	4501                	li	a0,0
 332:	bfe5                	j	32a <strchr+0x1a>

0000000000000334 <gets>:

char*
gets(char *buf, int max)
{
 334:	711d                	addi	sp,sp,-96
 336:	ec86                	sd	ra,88(sp)
 338:	e8a2                	sd	s0,80(sp)
 33a:	e4a6                	sd	s1,72(sp)
 33c:	e0ca                	sd	s2,64(sp)
 33e:	fc4e                	sd	s3,56(sp)
 340:	f852                	sd	s4,48(sp)
 342:	f456                	sd	s5,40(sp)
 344:	f05a                	sd	s6,32(sp)
 346:	ec5e                	sd	s7,24(sp)
 348:	1080                	addi	s0,sp,96
 34a:	8baa                	mv	s7,a0
 34c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34e:	892a                	mv	s2,a0
 350:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 352:	4aa9                	li	s5,10
 354:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 356:	89a6                	mv	s3,s1
 358:	2485                	addiw	s1,s1,1
 35a:	0344d663          	bge	s1,s4,386 <gets+0x52>
    cc = read(0, &c, 1);
 35e:	4605                	li	a2,1
 360:	faf40593          	addi	a1,s0,-81
 364:	4501                	li	a0,0
 366:	1b2000ef          	jal	518 <read>
    if(cc < 1)
 36a:	00a05e63          	blez	a0,386 <gets+0x52>
    buf[i++] = c;
 36e:	faf44783          	lbu	a5,-81(s0)
 372:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 376:	01578763          	beq	a5,s5,384 <gets+0x50>
 37a:	0905                	addi	s2,s2,1
 37c:	fd679de3          	bne	a5,s6,356 <gets+0x22>
    buf[i++] = c;
 380:	89a6                	mv	s3,s1
 382:	a011                	j	386 <gets+0x52>
 384:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 386:	99de                	add	s3,s3,s7
 388:	00098023          	sb	zero,0(s3)
  return buf;
}
 38c:	855e                	mv	a0,s7
 38e:	60e6                	ld	ra,88(sp)
 390:	6446                	ld	s0,80(sp)
 392:	64a6                	ld	s1,72(sp)
 394:	6906                	ld	s2,64(sp)
 396:	79e2                	ld	s3,56(sp)
 398:	7a42                	ld	s4,48(sp)
 39a:	7aa2                	ld	s5,40(sp)
 39c:	7b02                	ld	s6,32(sp)
 39e:	6be2                	ld	s7,24(sp)
 3a0:	6125                	addi	sp,sp,96
 3a2:	8082                	ret

00000000000003a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a4:	1101                	addi	sp,sp,-32
 3a6:	ec06                	sd	ra,24(sp)
 3a8:	e822                	sd	s0,16(sp)
 3aa:	e04a                	sd	s2,0(sp)
 3ac:	1000                	addi	s0,sp,32
 3ae:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b0:	4581                	li	a1,0
 3b2:	18e000ef          	jal	540 <open>
  if(fd < 0)
 3b6:	02054263          	bltz	a0,3da <stat+0x36>
 3ba:	e426                	sd	s1,8(sp)
 3bc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3be:	85ca                	mv	a1,s2
 3c0:	198000ef          	jal	558 <fstat>
 3c4:	892a                	mv	s2,a0
  close(fd);
 3c6:	8526                	mv	a0,s1
 3c8:	160000ef          	jal	528 <close>
  return r;
 3cc:	64a2                	ld	s1,8(sp)
}
 3ce:	854a                	mv	a0,s2
 3d0:	60e2                	ld	ra,24(sp)
 3d2:	6442                	ld	s0,16(sp)
 3d4:	6902                	ld	s2,0(sp)
 3d6:	6105                	addi	sp,sp,32
 3d8:	8082                	ret
    return -1;
 3da:	597d                	li	s2,-1
 3dc:	bfcd                	j	3ce <stat+0x2a>

00000000000003de <atoi>:

int
atoi(const char *s)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e422                	sd	s0,8(sp)
 3e2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e4:	00054683          	lbu	a3,0(a0)
 3e8:	fd06879b          	addiw	a5,a3,-48
 3ec:	0ff7f793          	zext.b	a5,a5
 3f0:	4625                	li	a2,9
 3f2:	02f66863          	bltu	a2,a5,422 <atoi+0x44>
 3f6:	872a                	mv	a4,a0
  n = 0;
 3f8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3fa:	0705                	addi	a4,a4,1
 3fc:	0025179b          	slliw	a5,a0,0x2
 400:	9fa9                	addw	a5,a5,a0
 402:	0017979b          	slliw	a5,a5,0x1
 406:	9fb5                	addw	a5,a5,a3
 408:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 40c:	00074683          	lbu	a3,0(a4)
 410:	fd06879b          	addiw	a5,a3,-48
 414:	0ff7f793          	zext.b	a5,a5
 418:	fef671e3          	bgeu	a2,a5,3fa <atoi+0x1c>
  return n;
}
 41c:	6422                	ld	s0,8(sp)
 41e:	0141                	addi	sp,sp,16
 420:	8082                	ret
  n = 0;
 422:	4501                	li	a0,0
 424:	bfe5                	j	41c <atoi+0x3e>

0000000000000426 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 426:	1141                	addi	sp,sp,-16
 428:	e422                	sd	s0,8(sp)
 42a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 42c:	02b57463          	bgeu	a0,a1,454 <memmove+0x2e>
    while(n-- > 0)
 430:	00c05f63          	blez	a2,44e <memmove+0x28>
 434:	1602                	slli	a2,a2,0x20
 436:	9201                	srli	a2,a2,0x20
 438:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 43c:	872a                	mv	a4,a0
      *dst++ = *src++;
 43e:	0585                	addi	a1,a1,1
 440:	0705                	addi	a4,a4,1
 442:	fff5c683          	lbu	a3,-1(a1)
 446:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 44a:	fef71ae3          	bne	a4,a5,43e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 44e:	6422                	ld	s0,8(sp)
 450:	0141                	addi	sp,sp,16
 452:	8082                	ret
    dst += n;
 454:	00c50733          	add	a4,a0,a2
    src += n;
 458:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 45a:	fec05ae3          	blez	a2,44e <memmove+0x28>
 45e:	fff6079b          	addiw	a5,a2,-1
 462:	1782                	slli	a5,a5,0x20
 464:	9381                	srli	a5,a5,0x20
 466:	fff7c793          	not	a5,a5
 46a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 46c:	15fd                	addi	a1,a1,-1
 46e:	177d                	addi	a4,a4,-1
 470:	0005c683          	lbu	a3,0(a1)
 474:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 478:	fee79ae3          	bne	a5,a4,46c <memmove+0x46>
 47c:	bfc9                	j	44e <memmove+0x28>

000000000000047e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 47e:	1141                	addi	sp,sp,-16
 480:	e422                	sd	s0,8(sp)
 482:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 484:	ca05                	beqz	a2,4b4 <memcmp+0x36>
 486:	fff6069b          	addiw	a3,a2,-1
 48a:	1682                	slli	a3,a3,0x20
 48c:	9281                	srli	a3,a3,0x20
 48e:	0685                	addi	a3,a3,1
 490:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 492:	00054783          	lbu	a5,0(a0)
 496:	0005c703          	lbu	a4,0(a1)
 49a:	00e79863          	bne	a5,a4,4aa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 49e:	0505                	addi	a0,a0,1
    p2++;
 4a0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4a2:	fed518e3          	bne	a0,a3,492 <memcmp+0x14>
  }
  return 0;
 4a6:	4501                	li	a0,0
 4a8:	a019                	j	4ae <memcmp+0x30>
      return *p1 - *p2;
 4aa:	40e7853b          	subw	a0,a5,a4
}
 4ae:	6422                	ld	s0,8(sp)
 4b0:	0141                	addi	sp,sp,16
 4b2:	8082                	ret
  return 0;
 4b4:	4501                	li	a0,0
 4b6:	bfe5                	j	4ae <memcmp+0x30>

00000000000004b8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b8:	1141                	addi	sp,sp,-16
 4ba:	e406                	sd	ra,8(sp)
 4bc:	e022                	sd	s0,0(sp)
 4be:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4c0:	f67ff0ef          	jal	426 <memmove>
}
 4c4:	60a2                	ld	ra,8(sp)
 4c6:	6402                	ld	s0,0(sp)
 4c8:	0141                	addi	sp,sp,16
 4ca:	8082                	ret

00000000000004cc <sbrk>:

char *
sbrk(int n) {
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e406                	sd	ra,8(sp)
 4d0:	e022                	sd	s0,0(sp)
 4d2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4d4:	4585                	li	a1,1
 4d6:	0b2000ef          	jal	588 <sys_sbrk>
}
 4da:	60a2                	ld	ra,8(sp)
 4dc:	6402                	ld	s0,0(sp)
 4de:	0141                	addi	sp,sp,16
 4e0:	8082                	ret

00000000000004e2 <sbrklazy>:

char *
sbrklazy(int n) {
 4e2:	1141                	addi	sp,sp,-16
 4e4:	e406                	sd	ra,8(sp)
 4e6:	e022                	sd	s0,0(sp)
 4e8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4ea:	4589                	li	a1,2
 4ec:	09c000ef          	jal	588 <sys_sbrk>
}
 4f0:	60a2                	ld	ra,8(sp)
 4f2:	6402                	ld	s0,0(sp)
 4f4:	0141                	addi	sp,sp,16
 4f6:	8082                	ret

00000000000004f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4f8:	4885                	li	a7,1
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <exit>:
.global exit
exit:
 li a7, SYS_exit
 500:	4889                	li	a7,2
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <wait>:
.global wait
wait:
 li a7, SYS_wait
 508:	488d                	li	a7,3
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 510:	4891                	li	a7,4
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <read>:
.global read
read:
 li a7, SYS_read
 518:	4895                	li	a7,5
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <write>:
.global write
write:
 li a7, SYS_write
 520:	48c1                	li	a7,16
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <close>:
.global close
close:
 li a7, SYS_close
 528:	48d5                	li	a7,21
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <kill>:
.global kill
kill:
 li a7, SYS_kill
 530:	4899                	li	a7,6
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <exec>:
.global exec
exec:
 li a7, SYS_exec
 538:	489d                	li	a7,7
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <open>:
.global open
open:
 li a7, SYS_open
 540:	48bd                	li	a7,15
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 548:	48c5                	li	a7,17
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 550:	48c9                	li	a7,18
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 558:	48a1                	li	a7,8
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <link>:
.global link
link:
 li a7, SYS_link
 560:	48cd                	li	a7,19
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 568:	48d1                	li	a7,20
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 570:	48a5                	li	a7,9
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <dup>:
.global dup
dup:
 li a7, SYS_dup
 578:	48a9                	li	a7,10
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 580:	48ad                	li	a7,11
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 588:	48b1                	li	a7,12
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <pause>:
.global pause
pause:
 li a7, SYS_pause
 590:	48b5                	li	a7,13
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 598:	48b9                	li	a7,14
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <kmemfree>:
.global kmemfree
kmemfree:
 li a7, SYS_kmemfree
 5a0:	48d9                	li	a7,22
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a8:	1101                	addi	sp,sp,-32
 5aa:	ec06                	sd	ra,24(sp)
 5ac:	e822                	sd	s0,16(sp)
 5ae:	1000                	addi	s0,sp,32
 5b0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5b4:	4605                	li	a2,1
 5b6:	fef40593          	addi	a1,s0,-17
 5ba:	f67ff0ef          	jal	520 <write>
}
 5be:	60e2                	ld	ra,24(sp)
 5c0:	6442                	ld	s0,16(sp)
 5c2:	6105                	addi	sp,sp,32
 5c4:	8082                	ret

00000000000005c6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5c6:	715d                	addi	sp,sp,-80
 5c8:	e486                	sd	ra,72(sp)
 5ca:	e0a2                	sd	s0,64(sp)
 5cc:	f84a                	sd	s2,48(sp)
 5ce:	0880                	addi	s0,sp,80
 5d0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5d2:	c299                	beqz	a3,5d8 <printint+0x12>
 5d4:	0805c363          	bltz	a1,65a <printint+0x94>
  neg = 0;
 5d8:	4881                	li	a7,0
 5da:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5de:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5e0:	00000517          	auipc	a0,0x0
 5e4:	5b850513          	addi	a0,a0,1464 # b98 <digits>
 5e8:	883e                	mv	a6,a5
 5ea:	2785                	addiw	a5,a5,1
 5ec:	02c5f733          	remu	a4,a1,a2
 5f0:	972a                	add	a4,a4,a0
 5f2:	00074703          	lbu	a4,0(a4)
 5f6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5fa:	872e                	mv	a4,a1
 5fc:	02c5d5b3          	divu	a1,a1,a2
 600:	0685                	addi	a3,a3,1
 602:	fec773e3          	bgeu	a4,a2,5e8 <printint+0x22>
  if(neg)
 606:	00088b63          	beqz	a7,61c <printint+0x56>
    buf[i++] = '-';
 60a:	fd078793          	addi	a5,a5,-48
 60e:	97a2                	add	a5,a5,s0
 610:	02d00713          	li	a4,45
 614:	fee78423          	sb	a4,-24(a5)
 618:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 61c:	02f05a63          	blez	a5,650 <printint+0x8a>
 620:	fc26                	sd	s1,56(sp)
 622:	f44e                	sd	s3,40(sp)
 624:	fb840713          	addi	a4,s0,-72
 628:	00f704b3          	add	s1,a4,a5
 62c:	fff70993          	addi	s3,a4,-1
 630:	99be                	add	s3,s3,a5
 632:	37fd                	addiw	a5,a5,-1
 634:	1782                	slli	a5,a5,0x20
 636:	9381                	srli	a5,a5,0x20
 638:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 63c:	fff4c583          	lbu	a1,-1(s1)
 640:	854a                	mv	a0,s2
 642:	f67ff0ef          	jal	5a8 <putc>
  while(--i >= 0)
 646:	14fd                	addi	s1,s1,-1
 648:	ff349ae3          	bne	s1,s3,63c <printint+0x76>
 64c:	74e2                	ld	s1,56(sp)
 64e:	79a2                	ld	s3,40(sp)
}
 650:	60a6                	ld	ra,72(sp)
 652:	6406                	ld	s0,64(sp)
 654:	7942                	ld	s2,48(sp)
 656:	6161                	addi	sp,sp,80
 658:	8082                	ret
    x = -xx;
 65a:	40b005b3          	neg	a1,a1
    neg = 1;
 65e:	4885                	li	a7,1
    x = -xx;
 660:	bfad                	j	5da <printint+0x14>

0000000000000662 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 662:	711d                	addi	sp,sp,-96
 664:	ec86                	sd	ra,88(sp)
 666:	e8a2                	sd	s0,80(sp)
 668:	e0ca                	sd	s2,64(sp)
 66a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 66c:	0005c903          	lbu	s2,0(a1)
 670:	28090663          	beqz	s2,8fc <vprintf+0x29a>
 674:	e4a6                	sd	s1,72(sp)
 676:	fc4e                	sd	s3,56(sp)
 678:	f852                	sd	s4,48(sp)
 67a:	f456                	sd	s5,40(sp)
 67c:	f05a                	sd	s6,32(sp)
 67e:	ec5e                	sd	s7,24(sp)
 680:	e862                	sd	s8,16(sp)
 682:	e466                	sd	s9,8(sp)
 684:	8b2a                	mv	s6,a0
 686:	8a2e                	mv	s4,a1
 688:	8bb2                	mv	s7,a2
  state = 0;
 68a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 68c:	4481                	li	s1,0
 68e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 690:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 694:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 698:	06c00c93          	li	s9,108
 69c:	a005                	j	6bc <vprintf+0x5a>
        putc(fd, c0);
 69e:	85ca                	mv	a1,s2
 6a0:	855a                	mv	a0,s6
 6a2:	f07ff0ef          	jal	5a8 <putc>
 6a6:	a019                	j	6ac <vprintf+0x4a>
    } else if(state == '%'){
 6a8:	03598263          	beq	s3,s5,6cc <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6ac:	2485                	addiw	s1,s1,1
 6ae:	8726                	mv	a4,s1
 6b0:	009a07b3          	add	a5,s4,s1
 6b4:	0007c903          	lbu	s2,0(a5)
 6b8:	22090a63          	beqz	s2,8ec <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 6bc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6c0:	fe0994e3          	bnez	s3,6a8 <vprintf+0x46>
      if(c0 == '%'){
 6c4:	fd579de3          	bne	a5,s5,69e <vprintf+0x3c>
        state = '%';
 6c8:	89be                	mv	s3,a5
 6ca:	b7cd                	j	6ac <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6cc:	00ea06b3          	add	a3,s4,a4
 6d0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6d4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6d6:	c681                	beqz	a3,6de <vprintf+0x7c>
 6d8:	9752                	add	a4,a4,s4
 6da:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6de:	05878363          	beq	a5,s8,724 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6e2:	05978d63          	beq	a5,s9,73c <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6e6:	07500713          	li	a4,117
 6ea:	0ee78763          	beq	a5,a4,7d8 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6ee:	07800713          	li	a4,120
 6f2:	12e78963          	beq	a5,a4,824 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6f6:	07000713          	li	a4,112
 6fa:	14e78e63          	beq	a5,a4,856 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 6fe:	06300713          	li	a4,99
 702:	18e78e63          	beq	a5,a4,89e <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 706:	07300713          	li	a4,115
 70a:	1ae78463          	beq	a5,a4,8b2 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 70e:	02500713          	li	a4,37
 712:	04e79563          	bne	a5,a4,75c <vprintf+0xfa>
        putc(fd, '%');
 716:	02500593          	li	a1,37
 71a:	855a                	mv	a0,s6
 71c:	e8dff0ef          	jal	5a8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 720:	4981                	li	s3,0
 722:	b769                	j	6ac <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 724:	008b8913          	addi	s2,s7,8
 728:	4685                	li	a3,1
 72a:	4629                	li	a2,10
 72c:	000ba583          	lw	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	e95ff0ef          	jal	5c6 <printint>
 736:	8bca                	mv	s7,s2
      state = 0;
 738:	4981                	li	s3,0
 73a:	bf8d                	j	6ac <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 73c:	06400793          	li	a5,100
 740:	02f68963          	beq	a3,a5,772 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 744:	06c00793          	li	a5,108
 748:	04f68263          	beq	a3,a5,78c <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 74c:	07500793          	li	a5,117
 750:	0af68063          	beq	a3,a5,7f0 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 754:	07800793          	li	a5,120
 758:	0ef68263          	beq	a3,a5,83c <vprintf+0x1da>
        putc(fd, '%');
 75c:	02500593          	li	a1,37
 760:	855a                	mv	a0,s6
 762:	e47ff0ef          	jal	5a8 <putc>
        putc(fd, c0);
 766:	85ca                	mv	a1,s2
 768:	855a                	mv	a0,s6
 76a:	e3fff0ef          	jal	5a8 <putc>
      state = 0;
 76e:	4981                	li	s3,0
 770:	bf35                	j	6ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 772:	008b8913          	addi	s2,s7,8
 776:	4685                	li	a3,1
 778:	4629                	li	a2,10
 77a:	000bb583          	ld	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	e47ff0ef          	jal	5c6 <printint>
        i += 1;
 784:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 786:	8bca                	mv	s7,s2
      state = 0;
 788:	4981                	li	s3,0
        i += 1;
 78a:	b70d                	j	6ac <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 78c:	06400793          	li	a5,100
 790:	02f60763          	beq	a2,a5,7be <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 794:	07500793          	li	a5,117
 798:	06f60963          	beq	a2,a5,80a <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 79c:	07800793          	li	a5,120
 7a0:	faf61ee3          	bne	a2,a5,75c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a4:	008b8913          	addi	s2,s7,8
 7a8:	4681                	li	a3,0
 7aa:	4641                	li	a2,16
 7ac:	000bb583          	ld	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	e15ff0ef          	jal	5c6 <printint>
        i += 2;
 7b6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b8:	8bca                	mv	s7,s2
      state = 0;
 7ba:	4981                	li	s3,0
        i += 2;
 7bc:	bdc5                	j	6ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4685                	li	a3,1
 7c4:	4629                	li	a2,10
 7c6:	000bb583          	ld	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	dfbff0ef          	jal	5c6 <printint>
        i += 2;
 7d0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d2:	8bca                	mv	s7,s2
      state = 0;
 7d4:	4981                	li	s3,0
        i += 2;
 7d6:	bdd9                	j	6ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7d8:	008b8913          	addi	s2,s7,8
 7dc:	4681                	li	a3,0
 7de:	4629                	li	a2,10
 7e0:	000be583          	lwu	a1,0(s7)
 7e4:	855a                	mv	a0,s6
 7e6:	de1ff0ef          	jal	5c6 <printint>
 7ea:	8bca                	mv	s7,s2
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	bd7d                	j	6ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f0:	008b8913          	addi	s2,s7,8
 7f4:	4681                	li	a3,0
 7f6:	4629                	li	a2,10
 7f8:	000bb583          	ld	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	dc9ff0ef          	jal	5c6 <printint>
        i += 1;
 802:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 804:	8bca                	mv	s7,s2
      state = 0;
 806:	4981                	li	s3,0
        i += 1;
 808:	b555                	j	6ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 80a:	008b8913          	addi	s2,s7,8
 80e:	4681                	li	a3,0
 810:	4629                	li	a2,10
 812:	000bb583          	ld	a1,0(s7)
 816:	855a                	mv	a0,s6
 818:	dafff0ef          	jal	5c6 <printint>
        i += 2;
 81c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 81e:	8bca                	mv	s7,s2
      state = 0;
 820:	4981                	li	s3,0
        i += 2;
 822:	b569                	j	6ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 824:	008b8913          	addi	s2,s7,8
 828:	4681                	li	a3,0
 82a:	4641                	li	a2,16
 82c:	000be583          	lwu	a1,0(s7)
 830:	855a                	mv	a0,s6
 832:	d95ff0ef          	jal	5c6 <printint>
 836:	8bca                	mv	s7,s2
      state = 0;
 838:	4981                	li	s3,0
 83a:	bd8d                	j	6ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 83c:	008b8913          	addi	s2,s7,8
 840:	4681                	li	a3,0
 842:	4641                	li	a2,16
 844:	000bb583          	ld	a1,0(s7)
 848:	855a                	mv	a0,s6
 84a:	d7dff0ef          	jal	5c6 <printint>
        i += 1;
 84e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 850:	8bca                	mv	s7,s2
      state = 0;
 852:	4981                	li	s3,0
        i += 1;
 854:	bda1                	j	6ac <vprintf+0x4a>
 856:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 858:	008b8d13          	addi	s10,s7,8
 85c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 860:	03000593          	li	a1,48
 864:	855a                	mv	a0,s6
 866:	d43ff0ef          	jal	5a8 <putc>
  putc(fd, 'x');
 86a:	07800593          	li	a1,120
 86e:	855a                	mv	a0,s6
 870:	d39ff0ef          	jal	5a8 <putc>
 874:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 876:	00000b97          	auipc	s7,0x0
 87a:	322b8b93          	addi	s7,s7,802 # b98 <digits>
 87e:	03c9d793          	srli	a5,s3,0x3c
 882:	97de                	add	a5,a5,s7
 884:	0007c583          	lbu	a1,0(a5)
 888:	855a                	mv	a0,s6
 88a:	d1fff0ef          	jal	5a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 88e:	0992                	slli	s3,s3,0x4
 890:	397d                	addiw	s2,s2,-1
 892:	fe0916e3          	bnez	s2,87e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 896:	8bea                	mv	s7,s10
      state = 0;
 898:	4981                	li	s3,0
 89a:	6d02                	ld	s10,0(sp)
 89c:	bd01                	j	6ac <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 89e:	008b8913          	addi	s2,s7,8
 8a2:	000bc583          	lbu	a1,0(s7)
 8a6:	855a                	mv	a0,s6
 8a8:	d01ff0ef          	jal	5a8 <putc>
 8ac:	8bca                	mv	s7,s2
      state = 0;
 8ae:	4981                	li	s3,0
 8b0:	bbf5                	j	6ac <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8b2:	008b8993          	addi	s3,s7,8
 8b6:	000bb903          	ld	s2,0(s7)
 8ba:	00090f63          	beqz	s2,8d8 <vprintf+0x276>
        for(; *s; s++)
 8be:	00094583          	lbu	a1,0(s2)
 8c2:	c195                	beqz	a1,8e6 <vprintf+0x284>
          putc(fd, *s);
 8c4:	855a                	mv	a0,s6
 8c6:	ce3ff0ef          	jal	5a8 <putc>
        for(; *s; s++)
 8ca:	0905                	addi	s2,s2,1
 8cc:	00094583          	lbu	a1,0(s2)
 8d0:	f9f5                	bnez	a1,8c4 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 8d2:	8bce                	mv	s7,s3
      state = 0;
 8d4:	4981                	li	s3,0
 8d6:	bbd9                	j	6ac <vprintf+0x4a>
          s = "(null)";
 8d8:	00000917          	auipc	s2,0x0
 8dc:	2b890913          	addi	s2,s2,696 # b90 <malloc+0x1ac>
        for(; *s; s++)
 8e0:	02800593          	li	a1,40
 8e4:	b7c5                	j	8c4 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 8e6:	8bce                	mv	s7,s3
      state = 0;
 8e8:	4981                	li	s3,0
 8ea:	b3c9                	j	6ac <vprintf+0x4a>
 8ec:	64a6                	ld	s1,72(sp)
 8ee:	79e2                	ld	s3,56(sp)
 8f0:	7a42                	ld	s4,48(sp)
 8f2:	7aa2                	ld	s5,40(sp)
 8f4:	7b02                	ld	s6,32(sp)
 8f6:	6be2                	ld	s7,24(sp)
 8f8:	6c42                	ld	s8,16(sp)
 8fa:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8fc:	60e6                	ld	ra,88(sp)
 8fe:	6446                	ld	s0,80(sp)
 900:	6906                	ld	s2,64(sp)
 902:	6125                	addi	sp,sp,96
 904:	8082                	ret

0000000000000906 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 906:	715d                	addi	sp,sp,-80
 908:	ec06                	sd	ra,24(sp)
 90a:	e822                	sd	s0,16(sp)
 90c:	1000                	addi	s0,sp,32
 90e:	e010                	sd	a2,0(s0)
 910:	e414                	sd	a3,8(s0)
 912:	e818                	sd	a4,16(s0)
 914:	ec1c                	sd	a5,24(s0)
 916:	03043023          	sd	a6,32(s0)
 91a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 91e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 922:	8622                	mv	a2,s0
 924:	d3fff0ef          	jal	662 <vprintf>
}
 928:	60e2                	ld	ra,24(sp)
 92a:	6442                	ld	s0,16(sp)
 92c:	6161                	addi	sp,sp,80
 92e:	8082                	ret

0000000000000930 <printf>:

void
printf(const char *fmt, ...)
{
 930:	711d                	addi	sp,sp,-96
 932:	ec06                	sd	ra,24(sp)
 934:	e822                	sd	s0,16(sp)
 936:	1000                	addi	s0,sp,32
 938:	e40c                	sd	a1,8(s0)
 93a:	e810                	sd	a2,16(s0)
 93c:	ec14                	sd	a3,24(s0)
 93e:	f018                	sd	a4,32(s0)
 940:	f41c                	sd	a5,40(s0)
 942:	03043823          	sd	a6,48(s0)
 946:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 94a:	00840613          	addi	a2,s0,8
 94e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 952:	85aa                	mv	a1,a0
 954:	4505                	li	a0,1
 956:	d0dff0ef          	jal	662 <vprintf>
}
 95a:	60e2                	ld	ra,24(sp)
 95c:	6442                	ld	s0,16(sp)
 95e:	6125                	addi	sp,sp,96
 960:	8082                	ret

0000000000000962 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 962:	1141                	addi	sp,sp,-16
 964:	e422                	sd	s0,8(sp)
 966:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 968:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96c:	00000797          	auipc	a5,0x0
 970:	6947b783          	ld	a5,1684(a5) # 1000 <freep>
 974:	a02d                	j	99e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 976:	4618                	lw	a4,8(a2)
 978:	9f2d                	addw	a4,a4,a1
 97a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 97e:	6398                	ld	a4,0(a5)
 980:	6310                	ld	a2,0(a4)
 982:	a83d                	j	9c0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 984:	ff852703          	lw	a4,-8(a0)
 988:	9f31                	addw	a4,a4,a2
 98a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 98c:	ff053683          	ld	a3,-16(a0)
 990:	a091                	j	9d4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 992:	6398                	ld	a4,0(a5)
 994:	00e7e463          	bltu	a5,a4,99c <free+0x3a>
 998:	00e6ea63          	bltu	a3,a4,9ac <free+0x4a>
{
 99c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99e:	fed7fae3          	bgeu	a5,a3,992 <free+0x30>
 9a2:	6398                	ld	a4,0(a5)
 9a4:	00e6e463          	bltu	a3,a4,9ac <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a8:	fee7eae3          	bltu	a5,a4,99c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9ac:	ff852583          	lw	a1,-8(a0)
 9b0:	6390                	ld	a2,0(a5)
 9b2:	02059813          	slli	a6,a1,0x20
 9b6:	01c85713          	srli	a4,a6,0x1c
 9ba:	9736                	add	a4,a4,a3
 9bc:	fae60de3          	beq	a2,a4,976 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9c4:	4790                	lw	a2,8(a5)
 9c6:	02061593          	slli	a1,a2,0x20
 9ca:	01c5d713          	srli	a4,a1,0x1c
 9ce:	973e                	add	a4,a4,a5
 9d0:	fae68ae3          	beq	a3,a4,984 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9d4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9d6:	00000717          	auipc	a4,0x0
 9da:	62f73523          	sd	a5,1578(a4) # 1000 <freep>
}
 9de:	6422                	ld	s0,8(sp)
 9e0:	0141                	addi	sp,sp,16
 9e2:	8082                	ret

00000000000009e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e4:	7139                	addi	sp,sp,-64
 9e6:	fc06                	sd	ra,56(sp)
 9e8:	f822                	sd	s0,48(sp)
 9ea:	f426                	sd	s1,40(sp)
 9ec:	ec4e                	sd	s3,24(sp)
 9ee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f0:	02051493          	slli	s1,a0,0x20
 9f4:	9081                	srli	s1,s1,0x20
 9f6:	04bd                	addi	s1,s1,15
 9f8:	8091                	srli	s1,s1,0x4
 9fa:	0014899b          	addiw	s3,s1,1
 9fe:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a00:	00000517          	auipc	a0,0x0
 a04:	60053503          	ld	a0,1536(a0) # 1000 <freep>
 a08:	c915                	beqz	a0,a3c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0c:	4798                	lw	a4,8(a5)
 a0e:	08977a63          	bgeu	a4,s1,aa2 <malloc+0xbe>
 a12:	f04a                	sd	s2,32(sp)
 a14:	e852                	sd	s4,16(sp)
 a16:	e456                	sd	s5,8(sp)
 a18:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a1a:	8a4e                	mv	s4,s3
 a1c:	0009871b          	sext.w	a4,s3
 a20:	6685                	lui	a3,0x1
 a22:	00d77363          	bgeu	a4,a3,a28 <malloc+0x44>
 a26:	6a05                	lui	s4,0x1
 a28:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a2c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a30:	00000917          	auipc	s2,0x0
 a34:	5d090913          	addi	s2,s2,1488 # 1000 <freep>
  if(p == SBRK_ERROR)
 a38:	5afd                	li	s5,-1
 a3a:	a081                	j	a7a <malloc+0x96>
 a3c:	f04a                	sd	s2,32(sp)
 a3e:	e852                	sd	s4,16(sp)
 a40:	e456                	sd	s5,8(sp)
 a42:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a44:	00000797          	auipc	a5,0x0
 a48:	5cc78793          	addi	a5,a5,1484 # 1010 <base>
 a4c:	00000717          	auipc	a4,0x0
 a50:	5af73a23          	sd	a5,1460(a4) # 1000 <freep>
 a54:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a56:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a5a:	b7c1                	j	a1a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a5c:	6398                	ld	a4,0(a5)
 a5e:	e118                	sd	a4,0(a0)
 a60:	a8a9                	j	aba <malloc+0xd6>
  hp->s.size = nu;
 a62:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a66:	0541                	addi	a0,a0,16
 a68:	efbff0ef          	jal	962 <free>
  return freep;
 a6c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a70:	c12d                	beqz	a0,ad2 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a72:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a74:	4798                	lw	a4,8(a5)
 a76:	02977263          	bgeu	a4,s1,a9a <malloc+0xb6>
    if(p == freep)
 a7a:	00093703          	ld	a4,0(s2)
 a7e:	853e                	mv	a0,a5
 a80:	fef719e3          	bne	a4,a5,a72 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a84:	8552                	mv	a0,s4
 a86:	a47ff0ef          	jal	4cc <sbrk>
  if(p == SBRK_ERROR)
 a8a:	fd551ce3          	bne	a0,s5,a62 <malloc+0x7e>
        return 0;
 a8e:	4501                	li	a0,0
 a90:	7902                	ld	s2,32(sp)
 a92:	6a42                	ld	s4,16(sp)
 a94:	6aa2                	ld	s5,8(sp)
 a96:	6b02                	ld	s6,0(sp)
 a98:	a03d                	j	ac6 <malloc+0xe2>
 a9a:	7902                	ld	s2,32(sp)
 a9c:	6a42                	ld	s4,16(sp)
 a9e:	6aa2                	ld	s5,8(sp)
 aa0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aa2:	fae48de3          	beq	s1,a4,a5c <malloc+0x78>
        p->s.size -= nunits;
 aa6:	4137073b          	subw	a4,a4,s3
 aaa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aac:	02071693          	slli	a3,a4,0x20
 ab0:	01c6d713          	srli	a4,a3,0x1c
 ab4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ab6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aba:	00000717          	auipc	a4,0x0
 abe:	54a73323          	sd	a0,1350(a4) # 1000 <freep>
      return (void*)(p + 1);
 ac2:	01078513          	addi	a0,a5,16
  }
}
 ac6:	70e2                	ld	ra,56(sp)
 ac8:	7442                	ld	s0,48(sp)
 aca:	74a2                	ld	s1,40(sp)
 acc:	69e2                	ld	s3,24(sp)
 ace:	6121                	addi	sp,sp,64
 ad0:	8082                	ret
 ad2:	7902                	ld	s2,32(sp)
 ad4:	6a42                	ld	s4,16(sp)
 ad6:	6aa2                	ld	s5,8(sp)
 ad8:	6b02                	ld	s6,0(sp)
 ada:	b7f5                	j	ac6 <malloc+0xe2>
