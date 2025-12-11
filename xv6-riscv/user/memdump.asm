
user/_memdump:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <memdump>:
#include "user/user.h"

void
memdump(char *fmt, char *data)
{
  while(*fmt){
   0:	00054783          	lbu	a5,0(a0)
   4:	c3f1                	beqz	a5,c8 <memdump+0xc8>
{
   6:	7179                	addi	sp,sp,-48
   8:	f406                	sd	ra,40(sp)
   a:	f022                	sd	s0,32(sp)
   c:	ec26                	sd	s1,24(sp)
   e:	e84a                	sd	s2,16(sp)
  10:	e44e                	sd	s3,8(sp)
  12:	e052                	sd	s4,0(sp)
  14:	1800                	addi	s0,sp,48
  16:	84aa                	mv	s1,a0
  18:	892e                	mv	s2,a1
    switch(*fmt){
  1a:	02000a13          	li	s4,32
  1e:	00001997          	auipc	s3,0x1
  22:	b1a98993          	addi	s3,s3,-1254 # b38 <malloc+0x1c0>
  26:	a831                	j	42 <memdump+0x42>
      case 'i': {
        int val = *(int*)data;
        printf("%d\n", val);
  28:	00092583          	lw	a1,0(s2)
  2c:	00001517          	auipc	a0,0x1
  30:	a4450513          	addi	a0,a0,-1468 # a70 <malloc+0xf8>
  34:	091000ef          	jal	8c4 <printf>
        data += 4;
  38:	0911                	addi	s2,s2,4
        printf("%s\n", data);
        
        return; 
      }
    }
    fmt++;
  3a:	0485                	addi	s1,s1,1
  while(*fmt){
  3c:	0004c783          	lbu	a5,0(s1)
  40:	cfa5                	beqz	a5,b8 <memdump+0xb8>
    switch(*fmt){
  42:	fad7879b          	addiw	a5,a5,-83
  46:	0ff7f713          	zext.b	a4,a5
  4a:	feea68e3          	bltu	s4,a4,3a <memdump+0x3a>
  4e:	00271793          	slli	a5,a4,0x2
  52:	97ce                	add	a5,a5,s3
  54:	439c                	lw	a5,0(a5)
  56:	97ce                	add	a5,a5,s3
  58:	8782                	jr	a5
        printf("%lx\n", val); 
  5a:	00093583          	ld	a1,0(s2)
  5e:	00001517          	auipc	a0,0x1
  62:	a1a50513          	addi	a0,a0,-1510 # a78 <malloc+0x100>
  66:	05f000ef          	jal	8c4 <printf>
        data += 8;
  6a:	0921                	addi	s2,s2,8
        break;
  6c:	b7f9                	j	3a <memdump+0x3a>
        printf("%d\n", val);
  6e:	00091583          	lh	a1,0(s2)
  72:	00001517          	auipc	a0,0x1
  76:	9fe50513          	addi	a0,a0,-1538 # a70 <malloc+0xf8>
  7a:	04b000ef          	jal	8c4 <printf>
        data += 2;
  7e:	0909                	addi	s2,s2,2
        break;
  80:	bf6d                	j	3a <memdump+0x3a>
        printf("%c\n", val);
  82:	00094583          	lbu	a1,0(s2)
  86:	00001517          	auipc	a0,0x1
  8a:	9fa50513          	addi	a0,a0,-1542 # a80 <malloc+0x108>
  8e:	037000ef          	jal	8c4 <printf>
        data += 1;
  92:	0905                	addi	s2,s2,1
        break;
  94:	b75d                	j	3a <memdump+0x3a>
        printf("%s\n", s);
  96:	00093583          	ld	a1,0(s2)
  9a:	00001517          	auipc	a0,0x1
  9e:	9ee50513          	addi	a0,a0,-1554 # a88 <malloc+0x110>
  a2:	023000ef          	jal	8c4 <printf>
        data += 8;
  a6:	0921                	addi	s2,s2,8
        break;
  a8:	bf49                	j	3a <memdump+0x3a>
        printf("%s\n", data);
  aa:	85ca                	mv	a1,s2
  ac:	00001517          	auipc	a0,0x1
  b0:	9dc50513          	addi	a0,a0,-1572 # a88 <malloc+0x110>
  b4:	011000ef          	jal	8c4 <printf>
  }
}
  b8:	70a2                	ld	ra,40(sp)
  ba:	7402                	ld	s0,32(sp)
  bc:	64e2                	ld	s1,24(sp)
  be:	6942                	ld	s2,16(sp)
  c0:	69a2                	ld	s3,8(sp)
  c2:	6a02                	ld	s4,0(sp)
  c4:	6145                	addi	sp,sp,48
  c6:	8082                	ret
  c8:	8082                	ret

00000000000000ca <main>:
  char c;      
} __attribute__((packed)); 

int
main(int argc, char *argv[])
{
  ca:	bc010113          	addi	sp,sp,-1088
  ce:	42113c23          	sd	ra,1080(sp)
  d2:	42813823          	sd	s0,1072(sp)
  d6:	44010413          	addi	s0,sp,1088
  if(argc > 1){
  da:	4785                	li	a5,1
  dc:	02a7d763          	bge	a5,a0,10a <main+0x40>
  e0:	42913423          	sd	s1,1064(sp)
  e4:	84ae                	mv	s1,a1
 
    char buf[1024];
    int n = read(0, buf, sizeof(buf));
  e6:	40000613          	li	a2,1024
  ea:	bc040593          	addi	a1,s0,-1088
  ee:	4501                	li	a0,0
  f0:	3bc000ef          	jal	4ac <read>
    if(n > 0){
  f4:	00a04563          	bgtz	a0,fe <main+0x34>
      memdump(argv[1], buf);
    }
    exit(0);
  f8:	4501                	li	a0,0
  fa:	39a000ef          	jal	494 <exit>
      memdump(argv[1], buf);
  fe:	bc040593          	addi	a1,s0,-1088
 102:	6488                	ld	a0,8(s1)
 104:	efdff0ef          	jal	0 <memdump>
 108:	bfc5                	j	f8 <main+0x2e>
 10a:	42913423          	sd	s1,1064(sp)
  }

  printf("example 1 \n");
 10e:	00001517          	auipc	a0,0x1
 112:	98250513          	addi	a0,a0,-1662 # a90 <malloc+0x118>
 116:	7ae000ef          	jal	8c4 <printf>
  struct { int a; int b; } e1 = {61810, 2025};
 11a:	67bd                	lui	a5,0xf
 11c:	17278793          	addi	a5,a5,370 # f172 <base+0xe162>
 120:	fcf42c23          	sw	a5,-40(s0)
 124:	7e900793          	li	a5,2025
 128:	fcf42e23          	sw	a5,-36(s0)
  memdump("ii", (char*)&e1);
 12c:	fd840593          	addi	a1,s0,-40
 130:	00001517          	auipc	a0,0x1
 134:	97050513          	addi	a0,a0,-1680 # aa0 <malloc+0x128>
 138:	ec9ff0ef          	jal	0 <memdump>

  printf("example 2 \n");
 13c:	00001517          	auipc	a0,0x1
 140:	96c50513          	addi	a0,a0,-1684 # aa8 <malloc+0x130>
 144:	780000ef          	jal	8c4 <printf>
  char *str = "a string";
 148:	00001797          	auipc	a5,0x1
 14c:	97078793          	addi	a5,a5,-1680 # ab8 <malloc+0x140>
 150:	fcf43823          	sd	a5,-48(s0)
  memdump("s", (char*)&str);
 154:	fd040593          	addi	a1,s0,-48
 158:	00001517          	auipc	a0,0x1
 15c:	97050513          	addi	a0,a0,-1680 # ac8 <malloc+0x150>
 160:	ea1ff0ef          	jal	0 <memdump>

  printf("example 3 \n");
 164:	00001517          	auipc	a0,0x1
 168:	96c50513          	addi	a0,a0,-1684 # ad0 <malloc+0x158>
 16c:	758000ef          	jal	8c4 <printf>
  memdump("S", "another");
 170:	00001597          	auipc	a1,0x1
 174:	97058593          	addi	a1,a1,-1680 # ae0 <malloc+0x168>
 178:	00001517          	auipc	a0,0x1
 17c:	97050513          	addi	a0,a0,-1680 # ae8 <malloc+0x170>
 180:	e81ff0ef          	jal	0 <memdump>

  printf("example 4 \n");
 184:	00001517          	auipc	a0,0x1
 188:	96c50513          	addi	a0,a0,-1684 # af0 <malloc+0x178>
 18c:	738000ef          	jal	8c4 <printf>
  struct e4 val;
  val.s = 0x0BD0;
 190:	6785                	lui	a5,0x1
 192:	bd078793          	addi	a5,a5,-1072 # bd0 <digits+0x10>
 196:	fcf41023          	sh	a5,-64(s0)
  val.l = 1819438967;
 19a:	679d                	lui	a5,0x7
 19c:	f7778793          	addi	a5,a5,-137 # 6f77 <base+0x5f67>
 1a0:	fcf41123          	sh	a5,-62(s0)
 1a4:	679d                	lui	a5,0x7
 1a6:	c7278793          	addi	a5,a5,-910 # 6c72 <base+0x5c62>
 1aa:	fcf41223          	sh	a5,-60(s0)
 1ae:	fc041323          	sh	zero,-58(s0)
 1b2:	fc041423          	sh	zero,-56(s0)
  val.i = 100;
 1b6:	06400793          	li	a5,100
 1ba:	fcf41523          	sh	a5,-54(s0)
 1be:	fc041623          	sh	zero,-52(s0)
  val.c = 'z';
 1c2:	07a00793          	li	a5,122
 1c6:	fcf40723          	sb	a5,-50(s0)
  memdump("hpic", (char*)&val);
 1ca:	fc040593          	addi	a1,s0,-64
 1ce:	00001517          	auipc	a0,0x1
 1d2:	93250513          	addi	a0,a0,-1742 # b00 <malloc+0x188>
 1d6:	e2bff0ef          	jal	0 <memdump>

  printf("\nexample 5 \n");
 1da:	00001517          	auipc	a0,0x1
 1de:	92e50513          	addi	a0,a0,-1746 # b08 <malloc+0x190>
 1e2:	6e2000ef          	jal	8c4 <printf>
  memdump("cccccS", "helloworld"); 
 1e6:	00001597          	auipc	a1,0x1
 1ea:	93258593          	addi	a1,a1,-1742 # b18 <malloc+0x1a0>
 1ee:	00001517          	auipc	a0,0x1
 1f2:	93a50513          	addi	a0,a0,-1734 # b28 <malloc+0x1b0>
 1f6:	e0bff0ef          	jal	0 <memdump>
  
  exit(0);
 1fa:	4501                	li	a0,0
 1fc:	298000ef          	jal	494 <exit>

0000000000000200 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 200:	1141                	addi	sp,sp,-16
 202:	e406                	sd	ra,8(sp)
 204:	e022                	sd	s0,0(sp)
 206:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 208:	ec3ff0ef          	jal	ca <main>
  exit(r);
 20c:	288000ef          	jal	494 <exit>

0000000000000210 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 216:	87aa                	mv	a5,a0
 218:	0585                	addi	a1,a1,1
 21a:	0785                	addi	a5,a5,1
 21c:	fff5c703          	lbu	a4,-1(a1)
 220:	fee78fa3          	sb	a4,-1(a5)
 224:	fb75                	bnez	a4,218 <strcpy+0x8>
    ;
  return os;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret

000000000000022c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e422                	sd	s0,8(sp)
 230:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 232:	00054783          	lbu	a5,0(a0)
 236:	cb91                	beqz	a5,24a <strcmp+0x1e>
 238:	0005c703          	lbu	a4,0(a1)
 23c:	00f71763          	bne	a4,a5,24a <strcmp+0x1e>
    p++, q++;
 240:	0505                	addi	a0,a0,1
 242:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 244:	00054783          	lbu	a5,0(a0)
 248:	fbe5                	bnez	a5,238 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 24a:	0005c503          	lbu	a0,0(a1)
}
 24e:	40a7853b          	subw	a0,a5,a0
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret

0000000000000258 <strlen>:

uint
strlen(const char *s)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 25e:	00054783          	lbu	a5,0(a0)
 262:	cf91                	beqz	a5,27e <strlen+0x26>
 264:	0505                	addi	a0,a0,1
 266:	87aa                	mv	a5,a0
 268:	86be                	mv	a3,a5
 26a:	0785                	addi	a5,a5,1
 26c:	fff7c703          	lbu	a4,-1(a5)
 270:	ff65                	bnez	a4,268 <strlen+0x10>
 272:	40a6853b          	subw	a0,a3,a0
 276:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 278:	6422                	ld	s0,8(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
  for(n = 0; s[n]; n++)
 27e:	4501                	li	a0,0
 280:	bfe5                	j	278 <strlen+0x20>

0000000000000282 <memset>:

void*
memset(void *dst, int c, uint n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e422                	sd	s0,8(sp)
 286:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 288:	ca19                	beqz	a2,29e <memset+0x1c>
 28a:	87aa                	mv	a5,a0
 28c:	1602                	slli	a2,a2,0x20
 28e:	9201                	srli	a2,a2,0x20
 290:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 294:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 298:	0785                	addi	a5,a5,1
 29a:	fee79de3          	bne	a5,a4,294 <memset+0x12>
  }
  return dst;
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret

00000000000002a4 <strchr>:

char*
strchr(const char *s, char c)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	cb99                	beqz	a5,2c4 <strchr+0x20>
    if(*s == c)
 2b0:	00f58763          	beq	a1,a5,2be <strchr+0x1a>
  for(; *s; s++)
 2b4:	0505                	addi	a0,a0,1
 2b6:	00054783          	lbu	a5,0(a0)
 2ba:	fbfd                	bnez	a5,2b0 <strchr+0xc>
      return (char*)s;
  return 0;
 2bc:	4501                	li	a0,0
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <strchr+0x1a>

00000000000002c8 <gets>:

char*
gets(char *buf, int max)
{
 2c8:	711d                	addi	sp,sp,-96
 2ca:	ec86                	sd	ra,88(sp)
 2cc:	e8a2                	sd	s0,80(sp)
 2ce:	e4a6                	sd	s1,72(sp)
 2d0:	e0ca                	sd	s2,64(sp)
 2d2:	fc4e                	sd	s3,56(sp)
 2d4:	f852                	sd	s4,48(sp)
 2d6:	f456                	sd	s5,40(sp)
 2d8:	f05a                	sd	s6,32(sp)
 2da:	ec5e                	sd	s7,24(sp)
 2dc:	1080                	addi	s0,sp,96
 2de:	8baa                	mv	s7,a0
 2e0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e2:	892a                	mv	s2,a0
 2e4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2e6:	4aa9                	li	s5,10
 2e8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2ea:	89a6                	mv	s3,s1
 2ec:	2485                	addiw	s1,s1,1
 2ee:	0344d663          	bge	s1,s4,31a <gets+0x52>
    cc = read(0, &c, 1);
 2f2:	4605                	li	a2,1
 2f4:	faf40593          	addi	a1,s0,-81
 2f8:	4501                	li	a0,0
 2fa:	1b2000ef          	jal	4ac <read>
    if(cc < 1)
 2fe:	00a05e63          	blez	a0,31a <gets+0x52>
    buf[i++] = c;
 302:	faf44783          	lbu	a5,-81(s0)
 306:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 30a:	01578763          	beq	a5,s5,318 <gets+0x50>
 30e:	0905                	addi	s2,s2,1
 310:	fd679de3          	bne	a5,s6,2ea <gets+0x22>
    buf[i++] = c;
 314:	89a6                	mv	s3,s1
 316:	a011                	j	31a <gets+0x52>
 318:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 31a:	99de                	add	s3,s3,s7
 31c:	00098023          	sb	zero,0(s3)
  return buf;
}
 320:	855e                	mv	a0,s7
 322:	60e6                	ld	ra,88(sp)
 324:	6446                	ld	s0,80(sp)
 326:	64a6                	ld	s1,72(sp)
 328:	6906                	ld	s2,64(sp)
 32a:	79e2                	ld	s3,56(sp)
 32c:	7a42                	ld	s4,48(sp)
 32e:	7aa2                	ld	s5,40(sp)
 330:	7b02                	ld	s6,32(sp)
 332:	6be2                	ld	s7,24(sp)
 334:	6125                	addi	sp,sp,96
 336:	8082                	ret

0000000000000338 <stat>:

int
stat(const char *n, struct stat *st)
{
 338:	1101                	addi	sp,sp,-32
 33a:	ec06                	sd	ra,24(sp)
 33c:	e822                	sd	s0,16(sp)
 33e:	e04a                	sd	s2,0(sp)
 340:	1000                	addi	s0,sp,32
 342:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 344:	4581                	li	a1,0
 346:	18e000ef          	jal	4d4 <open>
  if(fd < 0)
 34a:	02054263          	bltz	a0,36e <stat+0x36>
 34e:	e426                	sd	s1,8(sp)
 350:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 352:	85ca                	mv	a1,s2
 354:	198000ef          	jal	4ec <fstat>
 358:	892a                	mv	s2,a0
  close(fd);
 35a:	8526                	mv	a0,s1
 35c:	160000ef          	jal	4bc <close>
  return r;
 360:	64a2                	ld	s1,8(sp)
}
 362:	854a                	mv	a0,s2
 364:	60e2                	ld	ra,24(sp)
 366:	6442                	ld	s0,16(sp)
 368:	6902                	ld	s2,0(sp)
 36a:	6105                	addi	sp,sp,32
 36c:	8082                	ret
    return -1;
 36e:	597d                	li	s2,-1
 370:	bfcd                	j	362 <stat+0x2a>

0000000000000372 <atoi>:

int
atoi(const char *s)
{
 372:	1141                	addi	sp,sp,-16
 374:	e422                	sd	s0,8(sp)
 376:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 378:	00054683          	lbu	a3,0(a0)
 37c:	fd06879b          	addiw	a5,a3,-48
 380:	0ff7f793          	zext.b	a5,a5
 384:	4625                	li	a2,9
 386:	02f66863          	bltu	a2,a5,3b6 <atoi+0x44>
 38a:	872a                	mv	a4,a0
  n = 0;
 38c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 38e:	0705                	addi	a4,a4,1
 390:	0025179b          	slliw	a5,a0,0x2
 394:	9fa9                	addw	a5,a5,a0
 396:	0017979b          	slliw	a5,a5,0x1
 39a:	9fb5                	addw	a5,a5,a3
 39c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3a0:	00074683          	lbu	a3,0(a4)
 3a4:	fd06879b          	addiw	a5,a3,-48
 3a8:	0ff7f793          	zext.b	a5,a5
 3ac:	fef671e3          	bgeu	a2,a5,38e <atoi+0x1c>
  return n;
}
 3b0:	6422                	ld	s0,8(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret
  n = 0;
 3b6:	4501                	li	a0,0
 3b8:	bfe5                	j	3b0 <atoi+0x3e>

00000000000003ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e422                	sd	s0,8(sp)
 3be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c0:	02b57463          	bgeu	a0,a1,3e8 <memmove+0x2e>
    while(n-- > 0)
 3c4:	00c05f63          	blez	a2,3e2 <memmove+0x28>
 3c8:	1602                	slli	a2,a2,0x20
 3ca:	9201                	srli	a2,a2,0x20
 3cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d0:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d2:	0585                	addi	a1,a1,1
 3d4:	0705                	addi	a4,a4,1
 3d6:	fff5c683          	lbu	a3,-1(a1)
 3da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3de:	fef71ae3          	bne	a4,a5,3d2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e2:	6422                	ld	s0,8(sp)
 3e4:	0141                	addi	sp,sp,16
 3e6:	8082                	ret
    dst += n;
 3e8:	00c50733          	add	a4,a0,a2
    src += n;
 3ec:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ee:	fec05ae3          	blez	a2,3e2 <memmove+0x28>
 3f2:	fff6079b          	addiw	a5,a2,-1
 3f6:	1782                	slli	a5,a5,0x20
 3f8:	9381                	srli	a5,a5,0x20
 3fa:	fff7c793          	not	a5,a5
 3fe:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 400:	15fd                	addi	a1,a1,-1
 402:	177d                	addi	a4,a4,-1
 404:	0005c683          	lbu	a3,0(a1)
 408:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 40c:	fee79ae3          	bne	a5,a4,400 <memmove+0x46>
 410:	bfc9                	j	3e2 <memmove+0x28>

0000000000000412 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 412:	1141                	addi	sp,sp,-16
 414:	e422                	sd	s0,8(sp)
 416:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 418:	ca05                	beqz	a2,448 <memcmp+0x36>
 41a:	fff6069b          	addiw	a3,a2,-1
 41e:	1682                	slli	a3,a3,0x20
 420:	9281                	srli	a3,a3,0x20
 422:	0685                	addi	a3,a3,1
 424:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 426:	00054783          	lbu	a5,0(a0)
 42a:	0005c703          	lbu	a4,0(a1)
 42e:	00e79863          	bne	a5,a4,43e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 432:	0505                	addi	a0,a0,1
    p2++;
 434:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 436:	fed518e3          	bne	a0,a3,426 <memcmp+0x14>
  }
  return 0;
 43a:	4501                	li	a0,0
 43c:	a019                	j	442 <memcmp+0x30>
      return *p1 - *p2;
 43e:	40e7853b          	subw	a0,a5,a4
}
 442:	6422                	ld	s0,8(sp)
 444:	0141                	addi	sp,sp,16
 446:	8082                	ret
  return 0;
 448:	4501                	li	a0,0
 44a:	bfe5                	j	442 <memcmp+0x30>

000000000000044c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 44c:	1141                	addi	sp,sp,-16
 44e:	e406                	sd	ra,8(sp)
 450:	e022                	sd	s0,0(sp)
 452:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 454:	f67ff0ef          	jal	3ba <memmove>
}
 458:	60a2                	ld	ra,8(sp)
 45a:	6402                	ld	s0,0(sp)
 45c:	0141                	addi	sp,sp,16
 45e:	8082                	ret

0000000000000460 <sbrk>:

char *
sbrk(int n) {
 460:	1141                	addi	sp,sp,-16
 462:	e406                	sd	ra,8(sp)
 464:	e022                	sd	s0,0(sp)
 466:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 468:	4585                	li	a1,1
 46a:	0b2000ef          	jal	51c <sys_sbrk>
}
 46e:	60a2                	ld	ra,8(sp)
 470:	6402                	ld	s0,0(sp)
 472:	0141                	addi	sp,sp,16
 474:	8082                	ret

0000000000000476 <sbrklazy>:

char *
sbrklazy(int n) {
 476:	1141                	addi	sp,sp,-16
 478:	e406                	sd	ra,8(sp)
 47a:	e022                	sd	s0,0(sp)
 47c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 47e:	4589                	li	a1,2
 480:	09c000ef          	jal	51c <sys_sbrk>
}
 484:	60a2                	ld	ra,8(sp)
 486:	6402                	ld	s0,0(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret

000000000000048c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 48c:	4885                	li	a7,1
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <exit>:
.global exit
exit:
 li a7, SYS_exit
 494:	4889                	li	a7,2
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <wait>:
.global wait
wait:
 li a7, SYS_wait
 49c:	488d                	li	a7,3
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4a4:	4891                	li	a7,4
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <read>:
.global read
read:
 li a7, SYS_read
 4ac:	4895                	li	a7,5
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <write>:
.global write
write:
 li a7, SYS_write
 4b4:	48c1                	li	a7,16
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <close>:
.global close
close:
 li a7, SYS_close
 4bc:	48d5                	li	a7,21
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4c4:	4899                	li	a7,6
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 4cc:	489d                	li	a7,7
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <open>:
.global open
open:
 li a7, SYS_open
 4d4:	48bd                	li	a7,15
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4dc:	48c5                	li	a7,17
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4e4:	48c9                	li	a7,18
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4ec:	48a1                	li	a7,8
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <link>:
.global link
link:
 li a7, SYS_link
 4f4:	48cd                	li	a7,19
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4fc:	48d1                	li	a7,20
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 504:	48a5                	li	a7,9
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <dup>:
.global dup
dup:
 li a7, SYS_dup
 50c:	48a9                	li	a7,10
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 514:	48ad                	li	a7,11
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 51c:	48b1                	li	a7,12
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <pause>:
.global pause
pause:
 li a7, SYS_pause
 524:	48b5                	li	a7,13
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 52c:	48b9                	li	a7,14
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <kmemfree>:
.global kmemfree
kmemfree:
 li a7, SYS_kmemfree
 534:	48d9                	li	a7,22
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 53c:	1101                	addi	sp,sp,-32
 53e:	ec06                	sd	ra,24(sp)
 540:	e822                	sd	s0,16(sp)
 542:	1000                	addi	s0,sp,32
 544:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 548:	4605                	li	a2,1
 54a:	fef40593          	addi	a1,s0,-17
 54e:	f67ff0ef          	jal	4b4 <write>
}
 552:	60e2                	ld	ra,24(sp)
 554:	6442                	ld	s0,16(sp)
 556:	6105                	addi	sp,sp,32
 558:	8082                	ret

000000000000055a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 55a:	715d                	addi	sp,sp,-80
 55c:	e486                	sd	ra,72(sp)
 55e:	e0a2                	sd	s0,64(sp)
 560:	f84a                	sd	s2,48(sp)
 562:	0880                	addi	s0,sp,80
 564:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 566:	c299                	beqz	a3,56c <printint+0x12>
 568:	0805c363          	bltz	a1,5ee <printint+0x94>
  neg = 0;
 56c:	4881                	li	a7,0
 56e:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 572:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 574:	00000517          	auipc	a0,0x0
 578:	64c50513          	addi	a0,a0,1612 # bc0 <digits>
 57c:	883e                	mv	a6,a5
 57e:	2785                	addiw	a5,a5,1
 580:	02c5f733          	remu	a4,a1,a2
 584:	972a                	add	a4,a4,a0
 586:	00074703          	lbu	a4,0(a4)
 58a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 58e:	872e                	mv	a4,a1
 590:	02c5d5b3          	divu	a1,a1,a2
 594:	0685                	addi	a3,a3,1
 596:	fec773e3          	bgeu	a4,a2,57c <printint+0x22>
  if(neg)
 59a:	00088b63          	beqz	a7,5b0 <printint+0x56>
    buf[i++] = '-';
 59e:	fd078793          	addi	a5,a5,-48
 5a2:	97a2                	add	a5,a5,s0
 5a4:	02d00713          	li	a4,45
 5a8:	fee78423          	sb	a4,-24(a5)
 5ac:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 5b0:	02f05a63          	blez	a5,5e4 <printint+0x8a>
 5b4:	fc26                	sd	s1,56(sp)
 5b6:	f44e                	sd	s3,40(sp)
 5b8:	fb840713          	addi	a4,s0,-72
 5bc:	00f704b3          	add	s1,a4,a5
 5c0:	fff70993          	addi	s3,a4,-1
 5c4:	99be                	add	s3,s3,a5
 5c6:	37fd                	addiw	a5,a5,-1
 5c8:	1782                	slli	a5,a5,0x20
 5ca:	9381                	srli	a5,a5,0x20
 5cc:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 5d0:	fff4c583          	lbu	a1,-1(s1)
 5d4:	854a                	mv	a0,s2
 5d6:	f67ff0ef          	jal	53c <putc>
  while(--i >= 0)
 5da:	14fd                	addi	s1,s1,-1
 5dc:	ff349ae3          	bne	s1,s3,5d0 <printint+0x76>
 5e0:	74e2                	ld	s1,56(sp)
 5e2:	79a2                	ld	s3,40(sp)
}
 5e4:	60a6                	ld	ra,72(sp)
 5e6:	6406                	ld	s0,64(sp)
 5e8:	7942                	ld	s2,48(sp)
 5ea:	6161                	addi	sp,sp,80
 5ec:	8082                	ret
    x = -xx;
 5ee:	40b005b3          	neg	a1,a1
    neg = 1;
 5f2:	4885                	li	a7,1
    x = -xx;
 5f4:	bfad                	j	56e <printint+0x14>

00000000000005f6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5f6:	711d                	addi	sp,sp,-96
 5f8:	ec86                	sd	ra,88(sp)
 5fa:	e8a2                	sd	s0,80(sp)
 5fc:	e0ca                	sd	s2,64(sp)
 5fe:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 600:	0005c903          	lbu	s2,0(a1)
 604:	28090663          	beqz	s2,890 <vprintf+0x29a>
 608:	e4a6                	sd	s1,72(sp)
 60a:	fc4e                	sd	s3,56(sp)
 60c:	f852                	sd	s4,48(sp)
 60e:	f456                	sd	s5,40(sp)
 610:	f05a                	sd	s6,32(sp)
 612:	ec5e                	sd	s7,24(sp)
 614:	e862                	sd	s8,16(sp)
 616:	e466                	sd	s9,8(sp)
 618:	8b2a                	mv	s6,a0
 61a:	8a2e                	mv	s4,a1
 61c:	8bb2                	mv	s7,a2
  state = 0;
 61e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 620:	4481                	li	s1,0
 622:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 624:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 628:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 62c:	06c00c93          	li	s9,108
 630:	a005                	j	650 <vprintf+0x5a>
        putc(fd, c0);
 632:	85ca                	mv	a1,s2
 634:	855a                	mv	a0,s6
 636:	f07ff0ef          	jal	53c <putc>
 63a:	a019                	j	640 <vprintf+0x4a>
    } else if(state == '%'){
 63c:	03598263          	beq	s3,s5,660 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 640:	2485                	addiw	s1,s1,1
 642:	8726                	mv	a4,s1
 644:	009a07b3          	add	a5,s4,s1
 648:	0007c903          	lbu	s2,0(a5)
 64c:	22090a63          	beqz	s2,880 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 650:	0009079b          	sext.w	a5,s2
    if(state == 0){
 654:	fe0994e3          	bnez	s3,63c <vprintf+0x46>
      if(c0 == '%'){
 658:	fd579de3          	bne	a5,s5,632 <vprintf+0x3c>
        state = '%';
 65c:	89be                	mv	s3,a5
 65e:	b7cd                	j	640 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 660:	00ea06b3          	add	a3,s4,a4
 664:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 668:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 66a:	c681                	beqz	a3,672 <vprintf+0x7c>
 66c:	9752                	add	a4,a4,s4
 66e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 672:	05878363          	beq	a5,s8,6b8 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 676:	05978d63          	beq	a5,s9,6d0 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 67a:	07500713          	li	a4,117
 67e:	0ee78763          	beq	a5,a4,76c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 682:	07800713          	li	a4,120
 686:	12e78963          	beq	a5,a4,7b8 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 68a:	07000713          	li	a4,112
 68e:	14e78e63          	beq	a5,a4,7ea <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 692:	06300713          	li	a4,99
 696:	18e78e63          	beq	a5,a4,832 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 69a:	07300713          	li	a4,115
 69e:	1ae78463          	beq	a5,a4,846 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6a2:	02500713          	li	a4,37
 6a6:	04e79563          	bne	a5,a4,6f0 <vprintf+0xfa>
        putc(fd, '%');
 6aa:	02500593          	li	a1,37
 6ae:	855a                	mv	a0,s6
 6b0:	e8dff0ef          	jal	53c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b769                	j	640 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6b8:	008b8913          	addi	s2,s7,8
 6bc:	4685                	li	a3,1
 6be:	4629                	li	a2,10
 6c0:	000ba583          	lw	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	e95ff0ef          	jal	55a <printint>
 6ca:	8bca                	mv	s7,s2
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bf8d                	j	640 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6d0:	06400793          	li	a5,100
 6d4:	02f68963          	beq	a3,a5,706 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d8:	06c00793          	li	a5,108
 6dc:	04f68263          	beq	a3,a5,720 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 6e0:	07500793          	li	a5,117
 6e4:	0af68063          	beq	a3,a5,784 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 6e8:	07800793          	li	a5,120
 6ec:	0ef68263          	beq	a3,a5,7d0 <vprintf+0x1da>
        putc(fd, '%');
 6f0:	02500593          	li	a1,37
 6f4:	855a                	mv	a0,s6
 6f6:	e47ff0ef          	jal	53c <putc>
        putc(fd, c0);
 6fa:	85ca                	mv	a1,s2
 6fc:	855a                	mv	a0,s6
 6fe:	e3fff0ef          	jal	53c <putc>
      state = 0;
 702:	4981                	li	s3,0
 704:	bf35                	j	640 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 706:	008b8913          	addi	s2,s7,8
 70a:	4685                	li	a3,1
 70c:	4629                	li	a2,10
 70e:	000bb583          	ld	a1,0(s7)
 712:	855a                	mv	a0,s6
 714:	e47ff0ef          	jal	55a <printint>
        i += 1;
 718:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 71a:	8bca                	mv	s7,s2
      state = 0;
 71c:	4981                	li	s3,0
        i += 1;
 71e:	b70d                	j	640 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 720:	06400793          	li	a5,100
 724:	02f60763          	beq	a2,a5,752 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 728:	07500793          	li	a5,117
 72c:	06f60963          	beq	a2,a5,79e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 730:	07800793          	li	a5,120
 734:	faf61ee3          	bne	a2,a5,6f0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 738:	008b8913          	addi	s2,s7,8
 73c:	4681                	li	a3,0
 73e:	4641                	li	a2,16
 740:	000bb583          	ld	a1,0(s7)
 744:	855a                	mv	a0,s6
 746:	e15ff0ef          	jal	55a <printint>
        i += 2;
 74a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 74c:	8bca                	mv	s7,s2
      state = 0;
 74e:	4981                	li	s3,0
        i += 2;
 750:	bdc5                	j	640 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 752:	008b8913          	addi	s2,s7,8
 756:	4685                	li	a3,1
 758:	4629                	li	a2,10
 75a:	000bb583          	ld	a1,0(s7)
 75e:	855a                	mv	a0,s6
 760:	dfbff0ef          	jal	55a <printint>
        i += 2;
 764:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 766:	8bca                	mv	s7,s2
      state = 0;
 768:	4981                	li	s3,0
        i += 2;
 76a:	bdd9                	j	640 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 76c:	008b8913          	addi	s2,s7,8
 770:	4681                	li	a3,0
 772:	4629                	li	a2,10
 774:	000be583          	lwu	a1,0(s7)
 778:	855a                	mv	a0,s6
 77a:	de1ff0ef          	jal	55a <printint>
 77e:	8bca                	mv	s7,s2
      state = 0;
 780:	4981                	li	s3,0
 782:	bd7d                	j	640 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 784:	008b8913          	addi	s2,s7,8
 788:	4681                	li	a3,0
 78a:	4629                	li	a2,10
 78c:	000bb583          	ld	a1,0(s7)
 790:	855a                	mv	a0,s6
 792:	dc9ff0ef          	jal	55a <printint>
        i += 1;
 796:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 798:	8bca                	mv	s7,s2
      state = 0;
 79a:	4981                	li	s3,0
        i += 1;
 79c:	b555                	j	640 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 79e:	008b8913          	addi	s2,s7,8
 7a2:	4681                	li	a3,0
 7a4:	4629                	li	a2,10
 7a6:	000bb583          	ld	a1,0(s7)
 7aa:	855a                	mv	a0,s6
 7ac:	dafff0ef          	jal	55a <printint>
        i += 2;
 7b0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b2:	8bca                	mv	s7,s2
      state = 0;
 7b4:	4981                	li	s3,0
        i += 2;
 7b6:	b569                	j	640 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7b8:	008b8913          	addi	s2,s7,8
 7bc:	4681                	li	a3,0
 7be:	4641                	li	a2,16
 7c0:	000be583          	lwu	a1,0(s7)
 7c4:	855a                	mv	a0,s6
 7c6:	d95ff0ef          	jal	55a <printint>
 7ca:	8bca                	mv	s7,s2
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	bd8d                	j	640 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d0:	008b8913          	addi	s2,s7,8
 7d4:	4681                	li	a3,0
 7d6:	4641                	li	a2,16
 7d8:	000bb583          	ld	a1,0(s7)
 7dc:	855a                	mv	a0,s6
 7de:	d7dff0ef          	jal	55a <printint>
        i += 1;
 7e2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e4:	8bca                	mv	s7,s2
      state = 0;
 7e6:	4981                	li	s3,0
        i += 1;
 7e8:	bda1                	j	640 <vprintf+0x4a>
 7ea:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7ec:	008b8d13          	addi	s10,s7,8
 7f0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7f4:	03000593          	li	a1,48
 7f8:	855a                	mv	a0,s6
 7fa:	d43ff0ef          	jal	53c <putc>
  putc(fd, 'x');
 7fe:	07800593          	li	a1,120
 802:	855a                	mv	a0,s6
 804:	d39ff0ef          	jal	53c <putc>
 808:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 80a:	00000b97          	auipc	s7,0x0
 80e:	3b6b8b93          	addi	s7,s7,950 # bc0 <digits>
 812:	03c9d793          	srli	a5,s3,0x3c
 816:	97de                	add	a5,a5,s7
 818:	0007c583          	lbu	a1,0(a5)
 81c:	855a                	mv	a0,s6
 81e:	d1fff0ef          	jal	53c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 822:	0992                	slli	s3,s3,0x4
 824:	397d                	addiw	s2,s2,-1
 826:	fe0916e3          	bnez	s2,812 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 82a:	8bea                	mv	s7,s10
      state = 0;
 82c:	4981                	li	s3,0
 82e:	6d02                	ld	s10,0(sp)
 830:	bd01                	j	640 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 832:	008b8913          	addi	s2,s7,8
 836:	000bc583          	lbu	a1,0(s7)
 83a:	855a                	mv	a0,s6
 83c:	d01ff0ef          	jal	53c <putc>
 840:	8bca                	mv	s7,s2
      state = 0;
 842:	4981                	li	s3,0
 844:	bbf5                	j	640 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 846:	008b8993          	addi	s3,s7,8
 84a:	000bb903          	ld	s2,0(s7)
 84e:	00090f63          	beqz	s2,86c <vprintf+0x276>
        for(; *s; s++)
 852:	00094583          	lbu	a1,0(s2)
 856:	c195                	beqz	a1,87a <vprintf+0x284>
          putc(fd, *s);
 858:	855a                	mv	a0,s6
 85a:	ce3ff0ef          	jal	53c <putc>
        for(; *s; s++)
 85e:	0905                	addi	s2,s2,1
 860:	00094583          	lbu	a1,0(s2)
 864:	f9f5                	bnez	a1,858 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 866:	8bce                	mv	s7,s3
      state = 0;
 868:	4981                	li	s3,0
 86a:	bbd9                	j	640 <vprintf+0x4a>
          s = "(null)";
 86c:	00000917          	auipc	s2,0x0
 870:	2c490913          	addi	s2,s2,708 # b30 <malloc+0x1b8>
        for(; *s; s++)
 874:	02800593          	li	a1,40
 878:	b7c5                	j	858 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 87a:	8bce                	mv	s7,s3
      state = 0;
 87c:	4981                	li	s3,0
 87e:	b3c9                	j	640 <vprintf+0x4a>
 880:	64a6                	ld	s1,72(sp)
 882:	79e2                	ld	s3,56(sp)
 884:	7a42                	ld	s4,48(sp)
 886:	7aa2                	ld	s5,40(sp)
 888:	7b02                	ld	s6,32(sp)
 88a:	6be2                	ld	s7,24(sp)
 88c:	6c42                	ld	s8,16(sp)
 88e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 890:	60e6                	ld	ra,88(sp)
 892:	6446                	ld	s0,80(sp)
 894:	6906                	ld	s2,64(sp)
 896:	6125                	addi	sp,sp,96
 898:	8082                	ret

000000000000089a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 89a:	715d                	addi	sp,sp,-80
 89c:	ec06                	sd	ra,24(sp)
 89e:	e822                	sd	s0,16(sp)
 8a0:	1000                	addi	s0,sp,32
 8a2:	e010                	sd	a2,0(s0)
 8a4:	e414                	sd	a3,8(s0)
 8a6:	e818                	sd	a4,16(s0)
 8a8:	ec1c                	sd	a5,24(s0)
 8aa:	03043023          	sd	a6,32(s0)
 8ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8b2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b6:	8622                	mv	a2,s0
 8b8:	d3fff0ef          	jal	5f6 <vprintf>
}
 8bc:	60e2                	ld	ra,24(sp)
 8be:	6442                	ld	s0,16(sp)
 8c0:	6161                	addi	sp,sp,80
 8c2:	8082                	ret

00000000000008c4 <printf>:

void
printf(const char *fmt, ...)
{
 8c4:	711d                	addi	sp,sp,-96
 8c6:	ec06                	sd	ra,24(sp)
 8c8:	e822                	sd	s0,16(sp)
 8ca:	1000                	addi	s0,sp,32
 8cc:	e40c                	sd	a1,8(s0)
 8ce:	e810                	sd	a2,16(s0)
 8d0:	ec14                	sd	a3,24(s0)
 8d2:	f018                	sd	a4,32(s0)
 8d4:	f41c                	sd	a5,40(s0)
 8d6:	03043823          	sd	a6,48(s0)
 8da:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8de:	00840613          	addi	a2,s0,8
 8e2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8e6:	85aa                	mv	a1,a0
 8e8:	4505                	li	a0,1
 8ea:	d0dff0ef          	jal	5f6 <vprintf>
}
 8ee:	60e2                	ld	ra,24(sp)
 8f0:	6442                	ld	s0,16(sp)
 8f2:	6125                	addi	sp,sp,96
 8f4:	8082                	ret

00000000000008f6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f6:	1141                	addi	sp,sp,-16
 8f8:	e422                	sd	s0,8(sp)
 8fa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8fc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 900:	00000797          	auipc	a5,0x0
 904:	7007b783          	ld	a5,1792(a5) # 1000 <freep>
 908:	a02d                	j	932 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 90a:	4618                	lw	a4,8(a2)
 90c:	9f2d                	addw	a4,a4,a1
 90e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 912:	6398                	ld	a4,0(a5)
 914:	6310                	ld	a2,0(a4)
 916:	a83d                	j	954 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 918:	ff852703          	lw	a4,-8(a0)
 91c:	9f31                	addw	a4,a4,a2
 91e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 920:	ff053683          	ld	a3,-16(a0)
 924:	a091                	j	968 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 926:	6398                	ld	a4,0(a5)
 928:	00e7e463          	bltu	a5,a4,930 <free+0x3a>
 92c:	00e6ea63          	bltu	a3,a4,940 <free+0x4a>
{
 930:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 932:	fed7fae3          	bgeu	a5,a3,926 <free+0x30>
 936:	6398                	ld	a4,0(a5)
 938:	00e6e463          	bltu	a3,a4,940 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93c:	fee7eae3          	bltu	a5,a4,930 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 940:	ff852583          	lw	a1,-8(a0)
 944:	6390                	ld	a2,0(a5)
 946:	02059813          	slli	a6,a1,0x20
 94a:	01c85713          	srli	a4,a6,0x1c
 94e:	9736                	add	a4,a4,a3
 950:	fae60de3          	beq	a2,a4,90a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 954:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 958:	4790                	lw	a2,8(a5)
 95a:	02061593          	slli	a1,a2,0x20
 95e:	01c5d713          	srli	a4,a1,0x1c
 962:	973e                	add	a4,a4,a5
 964:	fae68ae3          	beq	a3,a4,918 <free+0x22>
    p->s.ptr = bp->s.ptr;
 968:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 96a:	00000717          	auipc	a4,0x0
 96e:	68f73b23          	sd	a5,1686(a4) # 1000 <freep>
}
 972:	6422                	ld	s0,8(sp)
 974:	0141                	addi	sp,sp,16
 976:	8082                	ret

0000000000000978 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 978:	7139                	addi	sp,sp,-64
 97a:	fc06                	sd	ra,56(sp)
 97c:	f822                	sd	s0,48(sp)
 97e:	f426                	sd	s1,40(sp)
 980:	ec4e                	sd	s3,24(sp)
 982:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 984:	02051493          	slli	s1,a0,0x20
 988:	9081                	srli	s1,s1,0x20
 98a:	04bd                	addi	s1,s1,15
 98c:	8091                	srli	s1,s1,0x4
 98e:	0014899b          	addiw	s3,s1,1
 992:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 994:	00000517          	auipc	a0,0x0
 998:	66c53503          	ld	a0,1644(a0) # 1000 <freep>
 99c:	c915                	beqz	a0,9d0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a0:	4798                	lw	a4,8(a5)
 9a2:	08977a63          	bgeu	a4,s1,a36 <malloc+0xbe>
 9a6:	f04a                	sd	s2,32(sp)
 9a8:	e852                	sd	s4,16(sp)
 9aa:	e456                	sd	s5,8(sp)
 9ac:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9ae:	8a4e                	mv	s4,s3
 9b0:	0009871b          	sext.w	a4,s3
 9b4:	6685                	lui	a3,0x1
 9b6:	00d77363          	bgeu	a4,a3,9bc <malloc+0x44>
 9ba:	6a05                	lui	s4,0x1
 9bc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9c0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9c4:	00000917          	auipc	s2,0x0
 9c8:	63c90913          	addi	s2,s2,1596 # 1000 <freep>
  if(p == SBRK_ERROR)
 9cc:	5afd                	li	s5,-1
 9ce:	a081                	j	a0e <malloc+0x96>
 9d0:	f04a                	sd	s2,32(sp)
 9d2:	e852                	sd	s4,16(sp)
 9d4:	e456                	sd	s5,8(sp)
 9d6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9d8:	00000797          	auipc	a5,0x0
 9dc:	63878793          	addi	a5,a5,1592 # 1010 <base>
 9e0:	00000717          	auipc	a4,0x0
 9e4:	62f73023          	sd	a5,1568(a4) # 1000 <freep>
 9e8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ea:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ee:	b7c1                	j	9ae <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9f0:	6398                	ld	a4,0(a5)
 9f2:	e118                	sd	a4,0(a0)
 9f4:	a8a9                	j	a4e <malloc+0xd6>
  hp->s.size = nu;
 9f6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9fa:	0541                	addi	a0,a0,16
 9fc:	efbff0ef          	jal	8f6 <free>
  return freep;
 a00:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a04:	c12d                	beqz	a0,a66 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a06:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a08:	4798                	lw	a4,8(a5)
 a0a:	02977263          	bgeu	a4,s1,a2e <malloc+0xb6>
    if(p == freep)
 a0e:	00093703          	ld	a4,0(s2)
 a12:	853e                	mv	a0,a5
 a14:	fef719e3          	bne	a4,a5,a06 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a18:	8552                	mv	a0,s4
 a1a:	a47ff0ef          	jal	460 <sbrk>
  if(p == SBRK_ERROR)
 a1e:	fd551ce3          	bne	a0,s5,9f6 <malloc+0x7e>
        return 0;
 a22:	4501                	li	a0,0
 a24:	7902                	ld	s2,32(sp)
 a26:	6a42                	ld	s4,16(sp)
 a28:	6aa2                	ld	s5,8(sp)
 a2a:	6b02                	ld	s6,0(sp)
 a2c:	a03d                	j	a5a <malloc+0xe2>
 a2e:	7902                	ld	s2,32(sp)
 a30:	6a42                	ld	s4,16(sp)
 a32:	6aa2                	ld	s5,8(sp)
 a34:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a36:	fae48de3          	beq	s1,a4,9f0 <malloc+0x78>
        p->s.size -= nunits;
 a3a:	4137073b          	subw	a4,a4,s3
 a3e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a40:	02071693          	slli	a3,a4,0x20
 a44:	01c6d713          	srli	a4,a3,0x1c
 a48:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a4a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a4e:	00000717          	auipc	a4,0x0
 a52:	5aa73923          	sd	a0,1458(a4) # 1000 <freep>
      return (void*)(p + 1);
 a56:	01078513          	addi	a0,a5,16
  }
}
 a5a:	70e2                	ld	ra,56(sp)
 a5c:	7442                	ld	s0,48(sp)
 a5e:	74a2                	ld	s1,40(sp)
 a60:	69e2                	ld	s3,24(sp)
 a62:	6121                	addi	sp,sp,64
 a64:	8082                	ret
 a66:	7902                	ld	s2,32(sp)
 a68:	6a42                	ld	s4,16(sp)
 a6a:	6aa2                	ld	s5,8(sp)
 a6c:	6b02                	ld	s6,0(sp)
 a6e:	b7f5                	j	a5a <malloc+0xe2>
