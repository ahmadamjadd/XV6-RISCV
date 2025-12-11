
user/_sixfive:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <process>:

char *separators = " -\r\t\n./,";

void
process(int fd)
{
   0:	7115                	addi	sp,sp,-224
   2:	ed86                	sd	ra,216(sp)
   4:	e9a2                	sd	s0,208(sp)
   6:	e5a6                	sd	s1,200(sp)
   8:	e1ca                	sd	s2,192(sp)
   a:	fd4e                	sd	s3,184(sp)
   c:	f952                	sd	s4,176(sp)
   e:	f556                	sd	s5,168(sp)
  10:	f15a                	sd	s6,160(sp)
  12:	ed5e                	sd	s7,152(sp)
  14:	e962                	sd	s8,144(sp)
  16:	1180                	addi	s0,sp,224
  18:	89aa                	mv	s3,a0
  char buf;
  char token[128];     
  int len = 0;       
  int is_valid_num = 1;
  1a:	4905                	li	s2,1
  int len = 0;       
  1c:	4481                	li	s1,0

  while(read(fd, &buf, 1) > 0){
    
    if(strchr(separators, buf)){
  1e:	00001a17          	auipc	s4,0x1
  22:	fe2a0a13          	addi	s4,s4,-30 # 1000 <separators>
      len = 0;
      is_valid_num = 1;
    } 
    else {
      
      if(buf >= '0' && buf <= '9'){
  26:	4b25                	li	s6,9
        if(len < sizeof(token) - 1){
          token[len++] = buf;
        }
      } else {
        is_valid_num = 0;
  28:	4a81                	li	s5,0
        if(len < sizeof(token) - 1){
  2a:	07e00b93          	li	s7,126
        if(n % 5 == 0 || n % 6 == 0){
  2e:	4c15                	li	s8,5
  while(read(fd, &buf, 1) > 0){
  30:	a08d                	j	92 <process+0x92>
        token[len] = 0;
  32:	fb048793          	addi	a5,s1,-80
  36:	008784b3          	add	s1,a5,s0
  3a:	f6048c23          	sb	zero,-136(s1)
        int n = atoi(token);
  3e:	f2840513          	addi	a0,s0,-216
  42:	2c6000ef          	jal	308 <atoi>
  46:	85aa                	mv	a1,a0
        if(n % 5 == 0 || n % 6 == 0){
  48:	038567bb          	remw	a5,a0,s8
  4c:	c791                	beqz	a5,58 <process+0x58>
  4e:	4799                	li	a5,6
  50:	02f567bb          	remw	a5,a0,a5
      len = 0;
  54:	4481                	li	s1,0
        if(n % 5 == 0 || n % 6 == 0){
  56:	ef95                	bnez	a5,92 <process+0x92>
          printf("%d\n", n);
  58:	00001517          	auipc	a0,0x1
  5c:	9b850513          	addi	a0,a0,-1608 # a10 <malloc+0x102>
  60:	7fa000ef          	jal	85a <printf>
      len = 0;
  64:	4481                	li	s1,0
  66:	a035                	j	92 <process+0x92>
      if(buf >= '0' && buf <= '9'){
  68:	faf44703          	lbu	a4,-81(s0)
  6c:	fd07079b          	addiw	a5,a4,-48
  70:	0ff7f793          	zext.b	a5,a5
  74:	04fb6563          	bltu	s6,a5,be <process+0xbe>
        if(len < sizeof(token) - 1){
  78:	0004879b          	sext.w	a5,s1
  7c:	00fbeb63          	bltu	s7,a5,92 <process+0x92>
          token[len++] = buf;
  80:	fb048793          	addi	a5,s1,-80
  84:	97a2                	add	a5,a5,s0
  86:	f6e78c23          	sb	a4,-136(a5)
  8a:	2485                	addiw	s1,s1,1
  8c:	a019                	j	92 <process+0x92>
      is_valid_num = 1;
  8e:	4905                	li	s2,1
      len = 0;
  90:	84d6                	mv	s1,s5
  while(read(fd, &buf, 1) > 0){
  92:	4605                	li	a2,1
  94:	faf40593          	addi	a1,s0,-81
  98:	854e                	mv	a0,s3
  9a:	3a8000ef          	jal	442 <read>
  9e:	02a05263          	blez	a0,c2 <process+0xc2>
    if(strchr(separators, buf)){
  a2:	faf44583          	lbu	a1,-81(s0)
  a6:	000a3503          	ld	a0,0(s4)
  aa:	190000ef          	jal	23a <strchr>
  ae:	dd4d                	beqz	a0,68 <process+0x68>
      if(len > 0 && is_valid_num){
  b0:	fc905fe3          	blez	s1,8e <process+0x8e>
  b4:	f6091fe3          	bnez	s2,32 <process+0x32>
      len = 0;
  b8:	84ca                	mv	s1,s2
      is_valid_num = 1;
  ba:	4905                	li	s2,1
  bc:	bfd9                	j	92 <process+0x92>
        is_valid_num = 0;
  be:	8956                	mv	s2,s5
  c0:	bfc9                	j	92 <process+0x92>
      }
    }
  }

  if(len > 0 && is_valid_num){
  c2:	00905463          	blez	s1,ca <process+0xca>
  c6:	00091e63          	bnez	s2,e2 <process+0xe2>
    int n = atoi(token);
    if(n % 5 == 0 || n % 6 == 0){
      printf("%d\n", n);
    }
  }
}
  ca:	60ee                	ld	ra,216(sp)
  cc:	644e                	ld	s0,208(sp)
  ce:	64ae                	ld	s1,200(sp)
  d0:	690e                	ld	s2,192(sp)
  d2:	79ea                	ld	s3,184(sp)
  d4:	7a4a                	ld	s4,176(sp)
  d6:	7aaa                	ld	s5,168(sp)
  d8:	7b0a                	ld	s6,160(sp)
  da:	6bea                	ld	s7,152(sp)
  dc:	6c4a                	ld	s8,144(sp)
  de:	612d                	addi	sp,sp,224
  e0:	8082                	ret
    token[len] = 0;
  e2:	fb048793          	addi	a5,s1,-80
  e6:	008784b3          	add	s1,a5,s0
  ea:	f6048c23          	sb	zero,-136(s1)
    int n = atoi(token);
  ee:	f2840513          	addi	a0,s0,-216
  f2:	216000ef          	jal	308 <atoi>
  f6:	85aa                	mv	a1,a0
    if(n % 5 == 0 || n % 6 == 0){
  f8:	4795                	li	a5,5
  fa:	02f567bb          	remw	a5,a0,a5
  fe:	c789                	beqz	a5,108 <process+0x108>
 100:	4799                	li	a5,6
 102:	02f567bb          	remw	a5,a0,a5
 106:	f3f1                	bnez	a5,ca <process+0xca>
      printf("%d\n", n);
 108:	00001517          	auipc	a0,0x1
 10c:	90850513          	addi	a0,a0,-1784 # a10 <malloc+0x102>
 110:	74a000ef          	jal	85a <printf>
}
 114:	bf5d                	j	ca <process+0xca>

0000000000000116 <main>:

int
main(int argc, char *argv[])
{
 116:	7179                	addi	sp,sp,-48
 118:	f406                	sd	ra,40(sp)
 11a:	f022                	sd	s0,32(sp)
 11c:	1800                	addi	s0,sp,48
  int fd;

  if(argc <= 1){
 11e:	4785                	li	a5,1
 120:	04a7d263          	bge	a5,a0,164 <main+0x4e>
 124:	ec26                	sd	s1,24(sp)
 126:	e84a                	sd	s2,16(sp)
 128:	e44e                	sd	s3,8(sp)
 12a:	00858913          	addi	s2,a1,8
 12e:	ffe5099b          	addiw	s3,a0,-2
 132:	02099793          	slli	a5,s3,0x20
 136:	01d7d993          	srli	s3,a5,0x1d
 13a:	05c1                	addi	a1,a1,16
 13c:	99ae                	add	s3,s3,a1
    fprintf(2, "usage: sixfive [files...]\n");
    exit(1);
  }

  for(int i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 13e:	4581                	li	a1,0
 140:	00093503          	ld	a0,0(s2)
 144:	326000ef          	jal	46a <open>
 148:	84aa                	mv	s1,a0
 14a:	02054a63          	bltz	a0,17e <main+0x68>
      fprintf(2, "sixfive: cannot open %s\n", argv[i]);
      exit(1);
    }
    process(fd);
 14e:	eb3ff0ef          	jal	0 <process>
    close(fd);
 152:	8526                	mv	a0,s1
 154:	2fe000ef          	jal	452 <close>
  for(int i = 1; i < argc; i++){
 158:	0921                	addi	s2,s2,8
 15a:	ff3912e3          	bne	s2,s3,13e <main+0x28>
  }

  exit(0);
 15e:	4501                	li	a0,0
 160:	2ca000ef          	jal	42a <exit>
 164:	ec26                	sd	s1,24(sp)
 166:	e84a                	sd	s2,16(sp)
 168:	e44e                	sd	s3,8(sp)
    fprintf(2, "usage: sixfive [files...]\n");
 16a:	00001597          	auipc	a1,0x1
 16e:	8ae58593          	addi	a1,a1,-1874 # a18 <malloc+0x10a>
 172:	4509                	li	a0,2
 174:	6bc000ef          	jal	830 <fprintf>
    exit(1);
 178:	4505                	li	a0,1
 17a:	2b0000ef          	jal	42a <exit>
      fprintf(2, "sixfive: cannot open %s\n", argv[i]);
 17e:	00093603          	ld	a2,0(s2)
 182:	00001597          	auipc	a1,0x1
 186:	8b658593          	addi	a1,a1,-1866 # a38 <malloc+0x12a>
 18a:	4509                	li	a0,2
 18c:	6a4000ef          	jal	830 <fprintf>
      exit(1);
 190:	4505                	li	a0,1
 192:	298000ef          	jal	42a <exit>

0000000000000196 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 196:	1141                	addi	sp,sp,-16
 198:	e406                	sd	ra,8(sp)
 19a:	e022                	sd	s0,0(sp)
 19c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 19e:	f79ff0ef          	jal	116 <main>
  exit(r);
 1a2:	288000ef          	jal	42a <exit>

00000000000001a6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ac:	87aa                	mv	a5,a0
 1ae:	0585                	addi	a1,a1,1
 1b0:	0785                	addi	a5,a5,1
 1b2:	fff5c703          	lbu	a4,-1(a1)
 1b6:	fee78fa3          	sb	a4,-1(a5)
 1ba:	fb75                	bnez	a4,1ae <strcpy+0x8>
    ;
  return os;
}
 1bc:	6422                	ld	s0,8(sp)
 1be:	0141                	addi	sp,sp,16
 1c0:	8082                	ret

00000000000001c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c2:	1141                	addi	sp,sp,-16
 1c4:	e422                	sd	s0,8(sp)
 1c6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	cb91                	beqz	a5,1e0 <strcmp+0x1e>
 1ce:	0005c703          	lbu	a4,0(a1)
 1d2:	00f71763          	bne	a4,a5,1e0 <strcmp+0x1e>
    p++, q++;
 1d6:	0505                	addi	a0,a0,1
 1d8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1da:	00054783          	lbu	a5,0(a0)
 1de:	fbe5                	bnez	a5,1ce <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1e0:	0005c503          	lbu	a0,0(a1)
}
 1e4:	40a7853b          	subw	a0,a5,a0
 1e8:	6422                	ld	s0,8(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret

00000000000001ee <strlen>:

uint
strlen(const char *s)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f4:	00054783          	lbu	a5,0(a0)
 1f8:	cf91                	beqz	a5,214 <strlen+0x26>
 1fa:	0505                	addi	a0,a0,1
 1fc:	87aa                	mv	a5,a0
 1fe:	86be                	mv	a3,a5
 200:	0785                	addi	a5,a5,1
 202:	fff7c703          	lbu	a4,-1(a5)
 206:	ff65                	bnez	a4,1fe <strlen+0x10>
 208:	40a6853b          	subw	a0,a3,a0
 20c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
  for(n = 0; s[n]; n++)
 214:	4501                	li	a0,0
 216:	bfe5                	j	20e <strlen+0x20>

0000000000000218 <memset>:

void*
memset(void *dst, int c, uint n)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 21e:	ca19                	beqz	a2,234 <memset+0x1c>
 220:	87aa                	mv	a5,a0
 222:	1602                	slli	a2,a2,0x20
 224:	9201                	srli	a2,a2,0x20
 226:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 22a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 22e:	0785                	addi	a5,a5,1
 230:	fee79de3          	bne	a5,a4,22a <memset+0x12>
  }
  return dst;
}
 234:	6422                	ld	s0,8(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret

000000000000023a <strchr>:

char*
strchr(const char *s, char c)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 240:	00054783          	lbu	a5,0(a0)
 244:	cb99                	beqz	a5,25a <strchr+0x20>
    if(*s == c)
 246:	00f58763          	beq	a1,a5,254 <strchr+0x1a>
  for(; *s; s++)
 24a:	0505                	addi	a0,a0,1
 24c:	00054783          	lbu	a5,0(a0)
 250:	fbfd                	bnez	a5,246 <strchr+0xc>
      return (char*)s;
  return 0;
 252:	4501                	li	a0,0
}
 254:	6422                	ld	s0,8(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret
  return 0;
 25a:	4501                	li	a0,0
 25c:	bfe5                	j	254 <strchr+0x1a>

000000000000025e <gets>:

char*
gets(char *buf, int max)
{
 25e:	711d                	addi	sp,sp,-96
 260:	ec86                	sd	ra,88(sp)
 262:	e8a2                	sd	s0,80(sp)
 264:	e4a6                	sd	s1,72(sp)
 266:	e0ca                	sd	s2,64(sp)
 268:	fc4e                	sd	s3,56(sp)
 26a:	f852                	sd	s4,48(sp)
 26c:	f456                	sd	s5,40(sp)
 26e:	f05a                	sd	s6,32(sp)
 270:	ec5e                	sd	s7,24(sp)
 272:	1080                	addi	s0,sp,96
 274:	8baa                	mv	s7,a0
 276:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 278:	892a                	mv	s2,a0
 27a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 27c:	4aa9                	li	s5,10
 27e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 280:	89a6                	mv	s3,s1
 282:	2485                	addiw	s1,s1,1
 284:	0344d663          	bge	s1,s4,2b0 <gets+0x52>
    cc = read(0, &c, 1);
 288:	4605                	li	a2,1
 28a:	faf40593          	addi	a1,s0,-81
 28e:	4501                	li	a0,0
 290:	1b2000ef          	jal	442 <read>
    if(cc < 1)
 294:	00a05e63          	blez	a0,2b0 <gets+0x52>
    buf[i++] = c;
 298:	faf44783          	lbu	a5,-81(s0)
 29c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2a0:	01578763          	beq	a5,s5,2ae <gets+0x50>
 2a4:	0905                	addi	s2,s2,1
 2a6:	fd679de3          	bne	a5,s6,280 <gets+0x22>
    buf[i++] = c;
 2aa:	89a6                	mv	s3,s1
 2ac:	a011                	j	2b0 <gets+0x52>
 2ae:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2b0:	99de                	add	s3,s3,s7
 2b2:	00098023          	sb	zero,0(s3)
  return buf;
}
 2b6:	855e                	mv	a0,s7
 2b8:	60e6                	ld	ra,88(sp)
 2ba:	6446                	ld	s0,80(sp)
 2bc:	64a6                	ld	s1,72(sp)
 2be:	6906                	ld	s2,64(sp)
 2c0:	79e2                	ld	s3,56(sp)
 2c2:	7a42                	ld	s4,48(sp)
 2c4:	7aa2                	ld	s5,40(sp)
 2c6:	7b02                	ld	s6,32(sp)
 2c8:	6be2                	ld	s7,24(sp)
 2ca:	6125                	addi	sp,sp,96
 2cc:	8082                	ret

00000000000002ce <stat>:

int
stat(const char *n, struct stat *st)
{
 2ce:	1101                	addi	sp,sp,-32
 2d0:	ec06                	sd	ra,24(sp)
 2d2:	e822                	sd	s0,16(sp)
 2d4:	e04a                	sd	s2,0(sp)
 2d6:	1000                	addi	s0,sp,32
 2d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2da:	4581                	li	a1,0
 2dc:	18e000ef          	jal	46a <open>
  if(fd < 0)
 2e0:	02054263          	bltz	a0,304 <stat+0x36>
 2e4:	e426                	sd	s1,8(sp)
 2e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e8:	85ca                	mv	a1,s2
 2ea:	198000ef          	jal	482 <fstat>
 2ee:	892a                	mv	s2,a0
  close(fd);
 2f0:	8526                	mv	a0,s1
 2f2:	160000ef          	jal	452 <close>
  return r;
 2f6:	64a2                	ld	s1,8(sp)
}
 2f8:	854a                	mv	a0,s2
 2fa:	60e2                	ld	ra,24(sp)
 2fc:	6442                	ld	s0,16(sp)
 2fe:	6902                	ld	s2,0(sp)
 300:	6105                	addi	sp,sp,32
 302:	8082                	ret
    return -1;
 304:	597d                	li	s2,-1
 306:	bfcd                	j	2f8 <stat+0x2a>

0000000000000308 <atoi>:

int
atoi(const char *s)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30e:	00054683          	lbu	a3,0(a0)
 312:	fd06879b          	addiw	a5,a3,-48
 316:	0ff7f793          	zext.b	a5,a5
 31a:	4625                	li	a2,9
 31c:	02f66863          	bltu	a2,a5,34c <atoi+0x44>
 320:	872a                	mv	a4,a0
  n = 0;
 322:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 324:	0705                	addi	a4,a4,1
 326:	0025179b          	slliw	a5,a0,0x2
 32a:	9fa9                	addw	a5,a5,a0
 32c:	0017979b          	slliw	a5,a5,0x1
 330:	9fb5                	addw	a5,a5,a3
 332:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 336:	00074683          	lbu	a3,0(a4)
 33a:	fd06879b          	addiw	a5,a3,-48
 33e:	0ff7f793          	zext.b	a5,a5
 342:	fef671e3          	bgeu	a2,a5,324 <atoi+0x1c>
  return n;
}
 346:	6422                	ld	s0,8(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret
  n = 0;
 34c:	4501                	li	a0,0
 34e:	bfe5                	j	346 <atoi+0x3e>

0000000000000350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 350:	1141                	addi	sp,sp,-16
 352:	e422                	sd	s0,8(sp)
 354:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 356:	02b57463          	bgeu	a0,a1,37e <memmove+0x2e>
    while(n-- > 0)
 35a:	00c05f63          	blez	a2,378 <memmove+0x28>
 35e:	1602                	slli	a2,a2,0x20
 360:	9201                	srli	a2,a2,0x20
 362:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 366:	872a                	mv	a4,a0
      *dst++ = *src++;
 368:	0585                	addi	a1,a1,1
 36a:	0705                	addi	a4,a4,1
 36c:	fff5c683          	lbu	a3,-1(a1)
 370:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 374:	fef71ae3          	bne	a4,a5,368 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
    dst += n;
 37e:	00c50733          	add	a4,a0,a2
    src += n;
 382:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 384:	fec05ae3          	blez	a2,378 <memmove+0x28>
 388:	fff6079b          	addiw	a5,a2,-1
 38c:	1782                	slli	a5,a5,0x20
 38e:	9381                	srli	a5,a5,0x20
 390:	fff7c793          	not	a5,a5
 394:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 396:	15fd                	addi	a1,a1,-1
 398:	177d                	addi	a4,a4,-1
 39a:	0005c683          	lbu	a3,0(a1)
 39e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3a2:	fee79ae3          	bne	a5,a4,396 <memmove+0x46>
 3a6:	bfc9                	j	378 <memmove+0x28>

00000000000003a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a8:	1141                	addi	sp,sp,-16
 3aa:	e422                	sd	s0,8(sp)
 3ac:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3ae:	ca05                	beqz	a2,3de <memcmp+0x36>
 3b0:	fff6069b          	addiw	a3,a2,-1
 3b4:	1682                	slli	a3,a3,0x20
 3b6:	9281                	srli	a3,a3,0x20
 3b8:	0685                	addi	a3,a3,1
 3ba:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3bc:	00054783          	lbu	a5,0(a0)
 3c0:	0005c703          	lbu	a4,0(a1)
 3c4:	00e79863          	bne	a5,a4,3d4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3c8:	0505                	addi	a0,a0,1
    p2++;
 3ca:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3cc:	fed518e3          	bne	a0,a3,3bc <memcmp+0x14>
  }
  return 0;
 3d0:	4501                	li	a0,0
 3d2:	a019                	j	3d8 <memcmp+0x30>
      return *p1 - *p2;
 3d4:	40e7853b          	subw	a0,a5,a4
}
 3d8:	6422                	ld	s0,8(sp)
 3da:	0141                	addi	sp,sp,16
 3dc:	8082                	ret
  return 0;
 3de:	4501                	li	a0,0
 3e0:	bfe5                	j	3d8 <memcmp+0x30>

00000000000003e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3e2:	1141                	addi	sp,sp,-16
 3e4:	e406                	sd	ra,8(sp)
 3e6:	e022                	sd	s0,0(sp)
 3e8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ea:	f67ff0ef          	jal	350 <memmove>
}
 3ee:	60a2                	ld	ra,8(sp)
 3f0:	6402                	ld	s0,0(sp)
 3f2:	0141                	addi	sp,sp,16
 3f4:	8082                	ret

00000000000003f6 <sbrk>:

char *
sbrk(int n) {
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e406                	sd	ra,8(sp)
 3fa:	e022                	sd	s0,0(sp)
 3fc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3fe:	4585                	li	a1,1
 400:	0b2000ef          	jal	4b2 <sys_sbrk>
}
 404:	60a2                	ld	ra,8(sp)
 406:	6402                	ld	s0,0(sp)
 408:	0141                	addi	sp,sp,16
 40a:	8082                	ret

000000000000040c <sbrklazy>:

char *
sbrklazy(int n) {
 40c:	1141                	addi	sp,sp,-16
 40e:	e406                	sd	ra,8(sp)
 410:	e022                	sd	s0,0(sp)
 412:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 414:	4589                	li	a1,2
 416:	09c000ef          	jal	4b2 <sys_sbrk>
}
 41a:	60a2                	ld	ra,8(sp)
 41c:	6402                	ld	s0,0(sp)
 41e:	0141                	addi	sp,sp,16
 420:	8082                	ret

0000000000000422 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 422:	4885                	li	a7,1
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <exit>:
.global exit
exit:
 li a7, SYS_exit
 42a:	4889                	li	a7,2
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <wait>:
.global wait
wait:
 li a7, SYS_wait
 432:	488d                	li	a7,3
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 43a:	4891                	li	a7,4
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <read>:
.global read
read:
 li a7, SYS_read
 442:	4895                	li	a7,5
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <write>:
.global write
write:
 li a7, SYS_write
 44a:	48c1                	li	a7,16
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <close>:
.global close
close:
 li a7, SYS_close
 452:	48d5                	li	a7,21
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <kill>:
.global kill
kill:
 li a7, SYS_kill
 45a:	4899                	li	a7,6
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <exec>:
.global exec
exec:
 li a7, SYS_exec
 462:	489d                	li	a7,7
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <open>:
.global open
open:
 li a7, SYS_open
 46a:	48bd                	li	a7,15
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 472:	48c5                	li	a7,17
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 47a:	48c9                	li	a7,18
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 482:	48a1                	li	a7,8
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <link>:
.global link
link:
 li a7, SYS_link
 48a:	48cd                	li	a7,19
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 492:	48d1                	li	a7,20
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 49a:	48a5                	li	a7,9
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4a2:	48a9                	li	a7,10
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4aa:	48ad                	li	a7,11
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4b2:	48b1                	li	a7,12
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <pause>:
.global pause
pause:
 li a7, SYS_pause
 4ba:	48b5                	li	a7,13
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4c2:	48b9                	li	a7,14
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <kmemfree>:
.global kmemfree
kmemfree:
 li a7, SYS_kmemfree
 4ca:	48d9                	li	a7,22
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d2:	1101                	addi	sp,sp,-32
 4d4:	ec06                	sd	ra,24(sp)
 4d6:	e822                	sd	s0,16(sp)
 4d8:	1000                	addi	s0,sp,32
 4da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4de:	4605                	li	a2,1
 4e0:	fef40593          	addi	a1,s0,-17
 4e4:	f67ff0ef          	jal	44a <write>
}
 4e8:	60e2                	ld	ra,24(sp)
 4ea:	6442                	ld	s0,16(sp)
 4ec:	6105                	addi	sp,sp,32
 4ee:	8082                	ret

00000000000004f0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4f0:	715d                	addi	sp,sp,-80
 4f2:	e486                	sd	ra,72(sp)
 4f4:	e0a2                	sd	s0,64(sp)
 4f6:	f84a                	sd	s2,48(sp)
 4f8:	0880                	addi	s0,sp,80
 4fa:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4fc:	c299                	beqz	a3,502 <printint+0x12>
 4fe:	0805c363          	bltz	a1,584 <printint+0x94>
  neg = 0;
 502:	4881                	li	a7,0
 504:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 508:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 50a:	00000517          	auipc	a0,0x0
 50e:	56650513          	addi	a0,a0,1382 # a70 <digits>
 512:	883e                	mv	a6,a5
 514:	2785                	addiw	a5,a5,1
 516:	02c5f733          	remu	a4,a1,a2
 51a:	972a                	add	a4,a4,a0
 51c:	00074703          	lbu	a4,0(a4)
 520:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 524:	872e                	mv	a4,a1
 526:	02c5d5b3          	divu	a1,a1,a2
 52a:	0685                	addi	a3,a3,1
 52c:	fec773e3          	bgeu	a4,a2,512 <printint+0x22>
  if(neg)
 530:	00088b63          	beqz	a7,546 <printint+0x56>
    buf[i++] = '-';
 534:	fd078793          	addi	a5,a5,-48
 538:	97a2                	add	a5,a5,s0
 53a:	02d00713          	li	a4,45
 53e:	fee78423          	sb	a4,-24(a5)
 542:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 546:	02f05a63          	blez	a5,57a <printint+0x8a>
 54a:	fc26                	sd	s1,56(sp)
 54c:	f44e                	sd	s3,40(sp)
 54e:	fb840713          	addi	a4,s0,-72
 552:	00f704b3          	add	s1,a4,a5
 556:	fff70993          	addi	s3,a4,-1
 55a:	99be                	add	s3,s3,a5
 55c:	37fd                	addiw	a5,a5,-1
 55e:	1782                	slli	a5,a5,0x20
 560:	9381                	srli	a5,a5,0x20
 562:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 566:	fff4c583          	lbu	a1,-1(s1)
 56a:	854a                	mv	a0,s2
 56c:	f67ff0ef          	jal	4d2 <putc>
  while(--i >= 0)
 570:	14fd                	addi	s1,s1,-1
 572:	ff349ae3          	bne	s1,s3,566 <printint+0x76>
 576:	74e2                	ld	s1,56(sp)
 578:	79a2                	ld	s3,40(sp)
}
 57a:	60a6                	ld	ra,72(sp)
 57c:	6406                	ld	s0,64(sp)
 57e:	7942                	ld	s2,48(sp)
 580:	6161                	addi	sp,sp,80
 582:	8082                	ret
    x = -xx;
 584:	40b005b3          	neg	a1,a1
    neg = 1;
 588:	4885                	li	a7,1
    x = -xx;
 58a:	bfad                	j	504 <printint+0x14>

000000000000058c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 58c:	711d                	addi	sp,sp,-96
 58e:	ec86                	sd	ra,88(sp)
 590:	e8a2                	sd	s0,80(sp)
 592:	e0ca                	sd	s2,64(sp)
 594:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 596:	0005c903          	lbu	s2,0(a1)
 59a:	28090663          	beqz	s2,826 <vprintf+0x29a>
 59e:	e4a6                	sd	s1,72(sp)
 5a0:	fc4e                	sd	s3,56(sp)
 5a2:	f852                	sd	s4,48(sp)
 5a4:	f456                	sd	s5,40(sp)
 5a6:	f05a                	sd	s6,32(sp)
 5a8:	ec5e                	sd	s7,24(sp)
 5aa:	e862                	sd	s8,16(sp)
 5ac:	e466                	sd	s9,8(sp)
 5ae:	8b2a                	mv	s6,a0
 5b0:	8a2e                	mv	s4,a1
 5b2:	8bb2                	mv	s7,a2
  state = 0;
 5b4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5b6:	4481                	li	s1,0
 5b8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5ba:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5be:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5c2:	06c00c93          	li	s9,108
 5c6:	a005                	j	5e6 <vprintf+0x5a>
        putc(fd, c0);
 5c8:	85ca                	mv	a1,s2
 5ca:	855a                	mv	a0,s6
 5cc:	f07ff0ef          	jal	4d2 <putc>
 5d0:	a019                	j	5d6 <vprintf+0x4a>
    } else if(state == '%'){
 5d2:	03598263          	beq	s3,s5,5f6 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5d6:	2485                	addiw	s1,s1,1
 5d8:	8726                	mv	a4,s1
 5da:	009a07b3          	add	a5,s4,s1
 5de:	0007c903          	lbu	s2,0(a5)
 5e2:	22090a63          	beqz	s2,816 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5e6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5ea:	fe0994e3          	bnez	s3,5d2 <vprintf+0x46>
      if(c0 == '%'){
 5ee:	fd579de3          	bne	a5,s5,5c8 <vprintf+0x3c>
        state = '%';
 5f2:	89be                	mv	s3,a5
 5f4:	b7cd                	j	5d6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5f6:	00ea06b3          	add	a3,s4,a4
 5fa:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5fe:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 600:	c681                	beqz	a3,608 <vprintf+0x7c>
 602:	9752                	add	a4,a4,s4
 604:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 608:	05878363          	beq	a5,s8,64e <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 60c:	05978d63          	beq	a5,s9,666 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 610:	07500713          	li	a4,117
 614:	0ee78763          	beq	a5,a4,702 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 618:	07800713          	li	a4,120
 61c:	12e78963          	beq	a5,a4,74e <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 620:	07000713          	li	a4,112
 624:	14e78e63          	beq	a5,a4,780 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 628:	06300713          	li	a4,99
 62c:	18e78e63          	beq	a5,a4,7c8 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 630:	07300713          	li	a4,115
 634:	1ae78463          	beq	a5,a4,7dc <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 638:	02500713          	li	a4,37
 63c:	04e79563          	bne	a5,a4,686 <vprintf+0xfa>
        putc(fd, '%');
 640:	02500593          	li	a1,37
 644:	855a                	mv	a0,s6
 646:	e8dff0ef          	jal	4d2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 64a:	4981                	li	s3,0
 64c:	b769                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 64e:	008b8913          	addi	s2,s7,8
 652:	4685                	li	a3,1
 654:	4629                	li	a2,10
 656:	000ba583          	lw	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	e95ff0ef          	jal	4f0 <printint>
 660:	8bca                	mv	s7,s2
      state = 0;
 662:	4981                	li	s3,0
 664:	bf8d                	j	5d6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 666:	06400793          	li	a5,100
 66a:	02f68963          	beq	a3,a5,69c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 66e:	06c00793          	li	a5,108
 672:	04f68263          	beq	a3,a5,6b6 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 676:	07500793          	li	a5,117
 67a:	0af68063          	beq	a3,a5,71a <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 67e:	07800793          	li	a5,120
 682:	0ef68263          	beq	a3,a5,766 <vprintf+0x1da>
        putc(fd, '%');
 686:	02500593          	li	a1,37
 68a:	855a                	mv	a0,s6
 68c:	e47ff0ef          	jal	4d2 <putc>
        putc(fd, c0);
 690:	85ca                	mv	a1,s2
 692:	855a                	mv	a0,s6
 694:	e3fff0ef          	jal	4d2 <putc>
      state = 0;
 698:	4981                	li	s3,0
 69a:	bf35                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4685                	li	a3,1
 6a2:	4629                	li	a2,10
 6a4:	000bb583          	ld	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	e47ff0ef          	jal	4f0 <printint>
        i += 1;
 6ae:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b0:	8bca                	mv	s7,s2
      state = 0;
 6b2:	4981                	li	s3,0
        i += 1;
 6b4:	b70d                	j	5d6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6b6:	06400793          	li	a5,100
 6ba:	02f60763          	beq	a2,a5,6e8 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6be:	07500793          	li	a5,117
 6c2:	06f60963          	beq	a2,a5,734 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6c6:	07800793          	li	a5,120
 6ca:	faf61ee3          	bne	a2,a5,686 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4641                	li	a2,16
 6d6:	000bb583          	ld	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	e15ff0ef          	jal	4f0 <printint>
        i += 2;
 6e0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
        i += 2;
 6e6:	bdc5                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e8:	008b8913          	addi	s2,s7,8
 6ec:	4685                	li	a3,1
 6ee:	4629                	li	a2,10
 6f0:	000bb583          	ld	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	dfbff0ef          	jal	4f0 <printint>
        i += 2;
 6fa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6fc:	8bca                	mv	s7,s2
      state = 0;
 6fe:	4981                	li	s3,0
        i += 2;
 700:	bdd9                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 702:	008b8913          	addi	s2,s7,8
 706:	4681                	li	a3,0
 708:	4629                	li	a2,10
 70a:	000be583          	lwu	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	de1ff0ef          	jal	4f0 <printint>
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
 718:	bd7d                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71a:	008b8913          	addi	s2,s7,8
 71e:	4681                	li	a3,0
 720:	4629                	li	a2,10
 722:	000bb583          	ld	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	dc9ff0ef          	jal	4f0 <printint>
        i += 1;
 72c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 72e:	8bca                	mv	s7,s2
      state = 0;
 730:	4981                	li	s3,0
        i += 1;
 732:	b555                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	008b8913          	addi	s2,s7,8
 738:	4681                	li	a3,0
 73a:	4629                	li	a2,10
 73c:	000bb583          	ld	a1,0(s7)
 740:	855a                	mv	a0,s6
 742:	dafff0ef          	jal	4f0 <printint>
        i += 2;
 746:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 748:	8bca                	mv	s7,s2
      state = 0;
 74a:	4981                	li	s3,0
        i += 2;
 74c:	b569                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 74e:	008b8913          	addi	s2,s7,8
 752:	4681                	li	a3,0
 754:	4641                	li	a2,16
 756:	000be583          	lwu	a1,0(s7)
 75a:	855a                	mv	a0,s6
 75c:	d95ff0ef          	jal	4f0 <printint>
 760:	8bca                	mv	s7,s2
      state = 0;
 762:	4981                	li	s3,0
 764:	bd8d                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 766:	008b8913          	addi	s2,s7,8
 76a:	4681                	li	a3,0
 76c:	4641                	li	a2,16
 76e:	000bb583          	ld	a1,0(s7)
 772:	855a                	mv	a0,s6
 774:	d7dff0ef          	jal	4f0 <printint>
        i += 1;
 778:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 77a:	8bca                	mv	s7,s2
      state = 0;
 77c:	4981                	li	s3,0
        i += 1;
 77e:	bda1                	j	5d6 <vprintf+0x4a>
 780:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 782:	008b8d13          	addi	s10,s7,8
 786:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 78a:	03000593          	li	a1,48
 78e:	855a                	mv	a0,s6
 790:	d43ff0ef          	jal	4d2 <putc>
  putc(fd, 'x');
 794:	07800593          	li	a1,120
 798:	855a                	mv	a0,s6
 79a:	d39ff0ef          	jal	4d2 <putc>
 79e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7a0:	00000b97          	auipc	s7,0x0
 7a4:	2d0b8b93          	addi	s7,s7,720 # a70 <digits>
 7a8:	03c9d793          	srli	a5,s3,0x3c
 7ac:	97de                	add	a5,a5,s7
 7ae:	0007c583          	lbu	a1,0(a5)
 7b2:	855a                	mv	a0,s6
 7b4:	d1fff0ef          	jal	4d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b8:	0992                	slli	s3,s3,0x4
 7ba:	397d                	addiw	s2,s2,-1
 7bc:	fe0916e3          	bnez	s2,7a8 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7c0:	8bea                	mv	s7,s10
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	6d02                	ld	s10,0(sp)
 7c6:	bd01                	j	5d6 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7c8:	008b8913          	addi	s2,s7,8
 7cc:	000bc583          	lbu	a1,0(s7)
 7d0:	855a                	mv	a0,s6
 7d2:	d01ff0ef          	jal	4d2 <putc>
 7d6:	8bca                	mv	s7,s2
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	bbf5                	j	5d6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7dc:	008b8993          	addi	s3,s7,8
 7e0:	000bb903          	ld	s2,0(s7)
 7e4:	00090f63          	beqz	s2,802 <vprintf+0x276>
        for(; *s; s++)
 7e8:	00094583          	lbu	a1,0(s2)
 7ec:	c195                	beqz	a1,810 <vprintf+0x284>
          putc(fd, *s);
 7ee:	855a                	mv	a0,s6
 7f0:	ce3ff0ef          	jal	4d2 <putc>
        for(; *s; s++)
 7f4:	0905                	addi	s2,s2,1
 7f6:	00094583          	lbu	a1,0(s2)
 7fa:	f9f5                	bnez	a1,7ee <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7fc:	8bce                	mv	s7,s3
      state = 0;
 7fe:	4981                	li	s3,0
 800:	bbd9                	j	5d6 <vprintf+0x4a>
          s = "(null)";
 802:	00000917          	auipc	s2,0x0
 806:	26690913          	addi	s2,s2,614 # a68 <malloc+0x15a>
        for(; *s; s++)
 80a:	02800593          	li	a1,40
 80e:	b7c5                	j	7ee <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 810:	8bce                	mv	s7,s3
      state = 0;
 812:	4981                	li	s3,0
 814:	b3c9                	j	5d6 <vprintf+0x4a>
 816:	64a6                	ld	s1,72(sp)
 818:	79e2                	ld	s3,56(sp)
 81a:	7a42                	ld	s4,48(sp)
 81c:	7aa2                	ld	s5,40(sp)
 81e:	7b02                	ld	s6,32(sp)
 820:	6be2                	ld	s7,24(sp)
 822:	6c42                	ld	s8,16(sp)
 824:	6ca2                	ld	s9,8(sp)
    }
  }
}
 826:	60e6                	ld	ra,88(sp)
 828:	6446                	ld	s0,80(sp)
 82a:	6906                	ld	s2,64(sp)
 82c:	6125                	addi	sp,sp,96
 82e:	8082                	ret

0000000000000830 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 830:	715d                	addi	sp,sp,-80
 832:	ec06                	sd	ra,24(sp)
 834:	e822                	sd	s0,16(sp)
 836:	1000                	addi	s0,sp,32
 838:	e010                	sd	a2,0(s0)
 83a:	e414                	sd	a3,8(s0)
 83c:	e818                	sd	a4,16(s0)
 83e:	ec1c                	sd	a5,24(s0)
 840:	03043023          	sd	a6,32(s0)
 844:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 848:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 84c:	8622                	mv	a2,s0
 84e:	d3fff0ef          	jal	58c <vprintf>
}
 852:	60e2                	ld	ra,24(sp)
 854:	6442                	ld	s0,16(sp)
 856:	6161                	addi	sp,sp,80
 858:	8082                	ret

000000000000085a <printf>:

void
printf(const char *fmt, ...)
{
 85a:	711d                	addi	sp,sp,-96
 85c:	ec06                	sd	ra,24(sp)
 85e:	e822                	sd	s0,16(sp)
 860:	1000                	addi	s0,sp,32
 862:	e40c                	sd	a1,8(s0)
 864:	e810                	sd	a2,16(s0)
 866:	ec14                	sd	a3,24(s0)
 868:	f018                	sd	a4,32(s0)
 86a:	f41c                	sd	a5,40(s0)
 86c:	03043823          	sd	a6,48(s0)
 870:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 874:	00840613          	addi	a2,s0,8
 878:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 87c:	85aa                	mv	a1,a0
 87e:	4505                	li	a0,1
 880:	d0dff0ef          	jal	58c <vprintf>
}
 884:	60e2                	ld	ra,24(sp)
 886:	6442                	ld	s0,16(sp)
 888:	6125                	addi	sp,sp,96
 88a:	8082                	ret

000000000000088c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88c:	1141                	addi	sp,sp,-16
 88e:	e422                	sd	s0,8(sp)
 890:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 892:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 896:	00000797          	auipc	a5,0x0
 89a:	77a7b783          	ld	a5,1914(a5) # 1010 <freep>
 89e:	a02d                	j	8c8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8a0:	4618                	lw	a4,8(a2)
 8a2:	9f2d                	addw	a4,a4,a1
 8a4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a8:	6398                	ld	a4,0(a5)
 8aa:	6310                	ld	a2,0(a4)
 8ac:	a83d                	j	8ea <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ae:	ff852703          	lw	a4,-8(a0)
 8b2:	9f31                	addw	a4,a4,a2
 8b4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8b6:	ff053683          	ld	a3,-16(a0)
 8ba:	a091                	j	8fe <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8bc:	6398                	ld	a4,0(a5)
 8be:	00e7e463          	bltu	a5,a4,8c6 <free+0x3a>
 8c2:	00e6ea63          	bltu	a3,a4,8d6 <free+0x4a>
{
 8c6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c8:	fed7fae3          	bgeu	a5,a3,8bc <free+0x30>
 8cc:	6398                	ld	a4,0(a5)
 8ce:	00e6e463          	bltu	a3,a4,8d6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d2:	fee7eae3          	bltu	a5,a4,8c6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8d6:	ff852583          	lw	a1,-8(a0)
 8da:	6390                	ld	a2,0(a5)
 8dc:	02059813          	slli	a6,a1,0x20
 8e0:	01c85713          	srli	a4,a6,0x1c
 8e4:	9736                	add	a4,a4,a3
 8e6:	fae60de3          	beq	a2,a4,8a0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8ea:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ee:	4790                	lw	a2,8(a5)
 8f0:	02061593          	slli	a1,a2,0x20
 8f4:	01c5d713          	srli	a4,a1,0x1c
 8f8:	973e                	add	a4,a4,a5
 8fa:	fae68ae3          	beq	a3,a4,8ae <free+0x22>
    p->s.ptr = bp->s.ptr;
 8fe:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 900:	00000717          	auipc	a4,0x0
 904:	70f73823          	sd	a5,1808(a4) # 1010 <freep>
}
 908:	6422                	ld	s0,8(sp)
 90a:	0141                	addi	sp,sp,16
 90c:	8082                	ret

000000000000090e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 90e:	7139                	addi	sp,sp,-64
 910:	fc06                	sd	ra,56(sp)
 912:	f822                	sd	s0,48(sp)
 914:	f426                	sd	s1,40(sp)
 916:	ec4e                	sd	s3,24(sp)
 918:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 91a:	02051493          	slli	s1,a0,0x20
 91e:	9081                	srli	s1,s1,0x20
 920:	04bd                	addi	s1,s1,15
 922:	8091                	srli	s1,s1,0x4
 924:	0014899b          	addiw	s3,s1,1
 928:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 92a:	00000517          	auipc	a0,0x0
 92e:	6e653503          	ld	a0,1766(a0) # 1010 <freep>
 932:	c915                	beqz	a0,966 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 934:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 936:	4798                	lw	a4,8(a5)
 938:	08977a63          	bgeu	a4,s1,9cc <malloc+0xbe>
 93c:	f04a                	sd	s2,32(sp)
 93e:	e852                	sd	s4,16(sp)
 940:	e456                	sd	s5,8(sp)
 942:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 944:	8a4e                	mv	s4,s3
 946:	0009871b          	sext.w	a4,s3
 94a:	6685                	lui	a3,0x1
 94c:	00d77363          	bgeu	a4,a3,952 <malloc+0x44>
 950:	6a05                	lui	s4,0x1
 952:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 956:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 95a:	00000917          	auipc	s2,0x0
 95e:	6b690913          	addi	s2,s2,1718 # 1010 <freep>
  if(p == SBRK_ERROR)
 962:	5afd                	li	s5,-1
 964:	a081                	j	9a4 <malloc+0x96>
 966:	f04a                	sd	s2,32(sp)
 968:	e852                	sd	s4,16(sp)
 96a:	e456                	sd	s5,8(sp)
 96c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 96e:	00000797          	auipc	a5,0x0
 972:	6b278793          	addi	a5,a5,1714 # 1020 <base>
 976:	00000717          	auipc	a4,0x0
 97a:	68f73d23          	sd	a5,1690(a4) # 1010 <freep>
 97e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 980:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 984:	b7c1                	j	944 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 986:	6398                	ld	a4,0(a5)
 988:	e118                	sd	a4,0(a0)
 98a:	a8a9                	j	9e4 <malloc+0xd6>
  hp->s.size = nu;
 98c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 990:	0541                	addi	a0,a0,16
 992:	efbff0ef          	jal	88c <free>
  return freep;
 996:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 99a:	c12d                	beqz	a0,9fc <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 99e:	4798                	lw	a4,8(a5)
 9a0:	02977263          	bgeu	a4,s1,9c4 <malloc+0xb6>
    if(p == freep)
 9a4:	00093703          	ld	a4,0(s2)
 9a8:	853e                	mv	a0,a5
 9aa:	fef719e3          	bne	a4,a5,99c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9ae:	8552                	mv	a0,s4
 9b0:	a47ff0ef          	jal	3f6 <sbrk>
  if(p == SBRK_ERROR)
 9b4:	fd551ce3          	bne	a0,s5,98c <malloc+0x7e>
        return 0;
 9b8:	4501                	li	a0,0
 9ba:	7902                	ld	s2,32(sp)
 9bc:	6a42                	ld	s4,16(sp)
 9be:	6aa2                	ld	s5,8(sp)
 9c0:	6b02                	ld	s6,0(sp)
 9c2:	a03d                	j	9f0 <malloc+0xe2>
 9c4:	7902                	ld	s2,32(sp)
 9c6:	6a42                	ld	s4,16(sp)
 9c8:	6aa2                	ld	s5,8(sp)
 9ca:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9cc:	fae48de3          	beq	s1,a4,986 <malloc+0x78>
        p->s.size -= nunits;
 9d0:	4137073b          	subw	a4,a4,s3
 9d4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9d6:	02071693          	slli	a3,a4,0x20
 9da:	01c6d713          	srli	a4,a3,0x1c
 9de:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9e0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9e4:	00000717          	auipc	a4,0x0
 9e8:	62a73623          	sd	a0,1580(a4) # 1010 <freep>
      return (void*)(p + 1);
 9ec:	01078513          	addi	a0,a5,16
  }
}
 9f0:	70e2                	ld	ra,56(sp)
 9f2:	7442                	ld	s0,48(sp)
 9f4:	74a2                	ld	s1,40(sp)
 9f6:	69e2                	ld	s3,24(sp)
 9f8:	6121                	addi	sp,sp,64
 9fa:	8082                	ret
 9fc:	7902                	ld	s2,32(sp)
 9fe:	6a42                	ld	s4,16(sp)
 a00:	6aa2                	ld	s5,8(sp)
 a02:	6b02                	ld	s6,0(sp)
 a04:	b7f5                	j	9f0 <malloc+0xe2>
