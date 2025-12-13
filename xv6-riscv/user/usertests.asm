
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
       e:	00008797          	auipc	a5,0x8
      12:	8d278793          	addi	a5,a5,-1838 # 78e0 <malloc+0x267a>
      16:	638c                	ld	a1,0(a5)
      18:	6790                	ld	a2,8(a5)
      1a:	6b94                	ld	a3,16(a5)
      1c:	6f98                	ld	a4,24(a5)
      1e:	739c                	ld	a5,32(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      34:	fa840493          	addi	s1,s0,-88
      38:	fd040993          	addi	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3c:	0004b903          	ld	s2,0(s1)
      40:	20100593          	li	a1,513
      44:	854a                	mv	a0,s2
      46:	575040ef          	jal	4dba <open>
    if(fd >= 0){
      4a:	00055c63          	bgez	a0,62 <copyinstr1+0x62>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      4e:	04a1                	addi	s1,s1,8
      50:	ff3496e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      54:	60e6                	ld	ra,88(sp)
      56:	6446                	ld	s0,80(sp)
      58:	64a6                	ld	s1,72(sp)
      5a:	6906                	ld	s2,64(sp)
      5c:	79e2                	ld	s3,56(sp)
      5e:	6125                	addi	sp,sp,96
      60:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      62:	862a                	mv	a2,a0
      64:	85ca                	mv	a1,s2
      66:	00005517          	auipc	a0,0x5
      6a:	2fa50513          	addi	a0,a0,762 # 5360 <malloc+0xfa>
      6e:	144050ef          	jal	51b2 <printf>
      exit(1);
      72:	4505                	li	a0,1
      74:	507040ef          	jal	4d7a <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      78:	00009797          	auipc	a5,0x9
      7c:	53078793          	addi	a5,a5,1328 # 95a8 <uninit>
      80:	0000c697          	auipc	a3,0xc
      84:	c3868693          	addi	a3,a3,-968 # bcb8 <buf>
    if(uninit[i] != '\0'){
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      8e:	0785                	addi	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
{
      96:	1141                	addi	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      9e:	85aa                	mv	a1,a0
      a0:	00005517          	auipc	a0,0x5
      a4:	2e050513          	addi	a0,a0,736 # 5380 <malloc+0x11a>
      a8:	10a050ef          	jal	51b2 <printf>
      exit(1);
      ac:	4505                	li	a0,1
      ae:	4cd040ef          	jal	4d7a <exit>

00000000000000b2 <opentest>:
{
      b2:	1101                	addi	sp,sp,-32
      b4:	ec06                	sd	ra,24(sp)
      b6:	e822                	sd	s0,16(sp)
      b8:	e426                	sd	s1,8(sp)
      ba:	1000                	addi	s0,sp,32
      bc:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      be:	4581                	li	a1,0
      c0:	00005517          	auipc	a0,0x5
      c4:	2d850513          	addi	a0,a0,728 # 5398 <malloc+0x132>
      c8:	4f3040ef          	jal	4dba <open>
  if(fd < 0){
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
  close(fd);
      d0:	4d3040ef          	jal	4da2 <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	2e250513          	addi	a0,a0,738 # 53b8 <malloc+0x152>
      de:	4dd040ef          	jal	4dba <open>
  if(fd >= 0){
      e2:	02055163          	bgez	a0,104 <opentest+0x52>
}
      e6:	60e2                	ld	ra,24(sp)
      e8:	6442                	ld	s0,16(sp)
      ea:	64a2                	ld	s1,8(sp)
      ec:	6105                	addi	sp,sp,32
      ee:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f0:	85a6                	mv	a1,s1
      f2:	00005517          	auipc	a0,0x5
      f6:	2ae50513          	addi	a0,a0,686 # 53a0 <malloc+0x13a>
      fa:	0b8050ef          	jal	51b2 <printf>
    exit(1);
      fe:	4505                	li	a0,1
     100:	47b040ef          	jal	4d7a <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	2c250513          	addi	a0,a0,706 # 53c8 <malloc+0x162>
     10e:	0a4050ef          	jal	51b2 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	467040ef          	jal	4d7a <exit>

0000000000000118 <truncate2>:
{
     118:	7179                	addi	sp,sp,-48
     11a:	f406                	sd	ra,40(sp)
     11c:	f022                	sd	s0,32(sp)
     11e:	ec26                	sd	s1,24(sp)
     120:	e84a                	sd	s2,16(sp)
     122:	e44e                	sd	s3,8(sp)
     124:	1800                	addi	s0,sp,48
     126:	89aa                	mv	s3,a0
  unlink("truncfile");
     128:	00005517          	auipc	a0,0x5
     12c:	2c850513          	addi	a0,a0,712 # 53f0 <malloc+0x18a>
     130:	49b040ef          	jal	4dca <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	2b850513          	addi	a0,a0,696 # 53f0 <malloc+0x18a>
     140:	47b040ef          	jal	4dba <open>
     144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	2b858593          	addi	a1,a1,696 # 5400 <malloc+0x19a>
     150:	44b040ef          	jal	4d9a <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	29850513          	addi	a0,a0,664 # 53f0 <malloc+0x18a>
     160:	45b040ef          	jal	4dba <open>
     164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	2a058593          	addi	a1,a1,672 # 5408 <malloc+0x1a2>
     170:	8526                	mv	a0,s1
     172:	429040ef          	jal	4d9a <write>
  if(n != -1){
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
  unlink("truncfile");
     17c:	00005517          	auipc	a0,0x5
     180:	27450513          	addi	a0,a0,628 # 53f0 <malloc+0x18a>
     184:	447040ef          	jal	4dca <unlink>
  close(fd1);
     188:	8526                	mv	a0,s1
     18a:	419040ef          	jal	4da2 <close>
  close(fd2);
     18e:	854a                	mv	a0,s2
     190:	413040ef          	jal	4da2 <close>
}
     194:	70a2                	ld	ra,40(sp)
     196:	7402                	ld	s0,32(sp)
     198:	64e2                	ld	s1,24(sp)
     19a:	6942                	ld	s2,16(sp)
     19c:	69a2                	ld	s3,8(sp)
     19e:	6145                	addi	sp,sp,48
     1a0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a2:	862a                	mv	a2,a0
     1a4:	85ce                	mv	a1,s3
     1a6:	00005517          	auipc	a0,0x5
     1aa:	26a50513          	addi	a0,a0,618 # 5410 <malloc+0x1aa>
     1ae:	004050ef          	jal	51b2 <printf>
    exit(1);
     1b2:	4505                	li	a0,1
     1b4:	3c7040ef          	jal	4d7a <exit>

00000000000001b8 <createtest>:
{
     1b8:	7179                	addi	sp,sp,-48
     1ba:	f406                	sd	ra,40(sp)
     1bc:	f022                	sd	s0,32(sp)
     1be:	ec26                	sd	s1,24(sp)
     1c0:	e84a                	sd	s2,16(sp)
     1c2:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1c4:	06100793          	li	a5,97
     1c8:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1cc:	fc040d23          	sb	zero,-38(s0)
     1d0:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     1d4:	06400913          	li	s2,100
    name[1] = '0' + i;
     1d8:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1dc:	20200593          	li	a1,514
     1e0:	fd840513          	addi	a0,s0,-40
     1e4:	3d7040ef          	jal	4dba <open>
    close(fd);
     1e8:	3bb040ef          	jal	4da2 <close>
  for(i = 0; i < N; i++){
     1ec:	2485                	addiw	s1,s1,1
     1ee:	0ff4f493          	zext.b	s1,s1
     1f2:	ff2493e3          	bne	s1,s2,1d8 <createtest+0x20>
  name[0] = 'a';
     1f6:	06100793          	li	a5,97
     1fa:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1fe:	fc040d23          	sb	zero,-38(s0)
     202:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     206:	06400913          	li	s2,100
    name[1] = '0' + i;
     20a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     20e:	fd840513          	addi	a0,s0,-40
     212:	3b9040ef          	jal	4dca <unlink>
  for(i = 0; i < N; i++){
     216:	2485                	addiw	s1,s1,1
     218:	0ff4f493          	zext.b	s1,s1
     21c:	ff2497e3          	bne	s1,s2,20a <createtest+0x52>
}
     220:	70a2                	ld	ra,40(sp)
     222:	7402                	ld	s0,32(sp)
     224:	64e2                	ld	s1,24(sp)
     226:	6942                	ld	s2,16(sp)
     228:	6145                	addi	sp,sp,48
     22a:	8082                	ret

000000000000022c <bigwrite>:
{
     22c:	715d                	addi	sp,sp,-80
     22e:	e486                	sd	ra,72(sp)
     230:	e0a2                	sd	s0,64(sp)
     232:	fc26                	sd	s1,56(sp)
     234:	f84a                	sd	s2,48(sp)
     236:	f44e                	sd	s3,40(sp)
     238:	f052                	sd	s4,32(sp)
     23a:	ec56                	sd	s5,24(sp)
     23c:	e85a                	sd	s6,16(sp)
     23e:	e45e                	sd	s7,8(sp)
     240:	0880                	addi	s0,sp,80
     242:	8baa                	mv	s7,a0
  unlink("bigwrite");
     244:	00005517          	auipc	a0,0x5
     248:	1f450513          	addi	a0,a0,500 # 5438 <malloc+0x1d2>
     24c:	37f040ef          	jal	4dca <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     254:	00005a97          	auipc	s5,0x5
     258:	1e4a8a93          	addi	s5,s5,484 # 5438 <malloc+0x1d2>
      int cc = write(fd, buf, sz);
     25c:	0000ca17          	auipc	s4,0xc
     260:	a5ca0a13          	addi	s4,s4,-1444 # bcb8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	addi	s6,s6,457 # 31c9 <rmdot+0x13>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	34b040ef          	jal	4dba <open>
     274:	892a                	mv	s2,a0
    if(fd < 0){
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	31d040ef          	jal	4d9a <write>
     282:	89aa                	mv	s3,a0
      if(cc != sz){
     284:	04a49863          	bne	s1,a0,2d4 <bigwrite+0xa8>
      int cc = write(fd, buf, sz);
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	30d040ef          	jal	4d9a <write>
      if(cc != sz){
     292:	04951263          	bne	a0,s1,2d6 <bigwrite+0xaa>
    close(fd);
     296:	854a                	mv	a0,s2
     298:	30b040ef          	jal	4da2 <close>
    unlink("bigwrite");
     29c:	8556                	mv	a0,s5
     29e:	32d040ef          	jal	4dca <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a2:	1d74849b          	addiw	s1,s1,471
     2a6:	fd6492e3          	bne	s1,s6,26a <bigwrite+0x3e>
}
     2aa:	60a6                	ld	ra,72(sp)
     2ac:	6406                	ld	s0,64(sp)
     2ae:	74e2                	ld	s1,56(sp)
     2b0:	7942                	ld	s2,48(sp)
     2b2:	79a2                	ld	s3,40(sp)
     2b4:	7a02                	ld	s4,32(sp)
     2b6:	6ae2                	ld	s5,24(sp)
     2b8:	6b42                	ld	s6,16(sp)
     2ba:	6ba2                	ld	s7,8(sp)
     2bc:	6161                	addi	sp,sp,80
     2be:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2c0:	85de                	mv	a1,s7
     2c2:	00005517          	auipc	a0,0x5
     2c6:	18650513          	addi	a0,a0,390 # 5448 <malloc+0x1e2>
     2ca:	6e9040ef          	jal	51b2 <printf>
      exit(1);
     2ce:	4505                	li	a0,1
     2d0:	2ab040ef          	jal	4d7a <exit>
      if(cc != sz){
     2d4:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2d6:	86aa                	mv	a3,a0
     2d8:	864e                	mv	a2,s3
     2da:	85de                	mv	a1,s7
     2dc:	00005517          	auipc	a0,0x5
     2e0:	18c50513          	addi	a0,a0,396 # 5468 <malloc+0x202>
     2e4:	6cf040ef          	jal	51b2 <printf>
        exit(1);
     2e8:	4505                	li	a0,1
     2ea:	291040ef          	jal	4d7a <exit>

00000000000002ee <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     2ee:	7179                	addi	sp,sp,-48
     2f0:	f406                	sd	ra,40(sp)
     2f2:	f022                	sd	s0,32(sp)
     2f4:	ec26                	sd	s1,24(sp)
     2f6:	e84a                	sd	s2,16(sp)
     2f8:	e44e                	sd	s3,8(sp)
     2fa:	e052                	sd	s4,0(sp)
     2fc:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     2fe:	00005517          	auipc	a0,0x5
     302:	18250513          	addi	a0,a0,386 # 5480 <malloc+0x21a>
     306:	2c5040ef          	jal	4dca <unlink>
     30a:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     30e:	00005997          	auipc	s3,0x5
     312:	17298993          	addi	s3,s3,370 # 5480 <malloc+0x21a>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     316:	5a7d                	li	s4,-1
     318:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     31c:	20100593          	li	a1,513
     320:	854e                	mv	a0,s3
     322:	299040ef          	jal	4dba <open>
     326:	84aa                	mv	s1,a0
    if(fd < 0){
     328:	04054d63          	bltz	a0,382 <badwrite+0x94>
    write(fd, (char*)0xffffffffffL, 1);
     32c:	4605                	li	a2,1
     32e:	85d2                	mv	a1,s4
     330:	26b040ef          	jal	4d9a <write>
    close(fd);
     334:	8526                	mv	a0,s1
     336:	26d040ef          	jal	4da2 <close>
    unlink("junk");
     33a:	854e                	mv	a0,s3
     33c:	28f040ef          	jal	4dca <unlink>
  for(int i = 0; i < assumed_free; i++){
     340:	397d                	addiw	s2,s2,-1
     342:	fc091de3          	bnez	s2,31c <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     346:	20100593          	li	a1,513
     34a:	00005517          	auipc	a0,0x5
     34e:	13650513          	addi	a0,a0,310 # 5480 <malloc+0x21a>
     352:	269040ef          	jal	4dba <open>
     356:	84aa                	mv	s1,a0
  if(fd < 0){
     358:	02054e63          	bltz	a0,394 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     35c:	4605                	li	a2,1
     35e:	00005597          	auipc	a1,0x5
     362:	0aa58593          	addi	a1,a1,170 # 5408 <malloc+0x1a2>
     366:	235040ef          	jal	4d9a <write>
     36a:	4785                	li	a5,1
     36c:	02f50d63          	beq	a0,a5,3a6 <badwrite+0xb8>
    printf("write failed\n");
     370:	00005517          	auipc	a0,0x5
     374:	13050513          	addi	a0,a0,304 # 54a0 <malloc+0x23a>
     378:	63b040ef          	jal	51b2 <printf>
    exit(1);
     37c:	4505                	li	a0,1
     37e:	1fd040ef          	jal	4d7a <exit>
      printf("open junk failed\n");
     382:	00005517          	auipc	a0,0x5
     386:	10650513          	addi	a0,a0,262 # 5488 <malloc+0x222>
     38a:	629040ef          	jal	51b2 <printf>
      exit(1);
     38e:	4505                	li	a0,1
     390:	1eb040ef          	jal	4d7a <exit>
    printf("open junk failed\n");
     394:	00005517          	auipc	a0,0x5
     398:	0f450513          	addi	a0,a0,244 # 5488 <malloc+0x222>
     39c:	617040ef          	jal	51b2 <printf>
    exit(1);
     3a0:	4505                	li	a0,1
     3a2:	1d9040ef          	jal	4d7a <exit>
  }
  close(fd);
     3a6:	8526                	mv	a0,s1
     3a8:	1fb040ef          	jal	4da2 <close>
  unlink("junk");
     3ac:	00005517          	auipc	a0,0x5
     3b0:	0d450513          	addi	a0,a0,212 # 5480 <malloc+0x21a>
     3b4:	217040ef          	jal	4dca <unlink>

  exit(0);
     3b8:	4501                	li	a0,0
     3ba:	1c1040ef          	jal	4d7a <exit>

00000000000003be <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3be:	715d                	addi	sp,sp,-80
     3c0:	e486                	sd	ra,72(sp)
     3c2:	e0a2                	sd	s0,64(sp)
     3c4:	fc26                	sd	s1,56(sp)
     3c6:	f84a                	sd	s2,48(sp)
     3c8:	f44e                	sd	s3,40(sp)
     3ca:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3cc:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3ce:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     3d2:	40000993          	li	s3,1024
    name[0] = 'z';
     3d6:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     3da:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     3de:	41f4d71b          	sraiw	a4,s1,0x1f
     3e2:	01b7571b          	srliw	a4,a4,0x1b
     3e6:	009707bb          	addw	a5,a4,s1
     3ea:	4057d69b          	sraiw	a3,a5,0x5
     3ee:	0306869b          	addiw	a3,a3,48
     3f2:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     3f6:	8bfd                	andi	a5,a5,31
     3f8:	9f99                	subw	a5,a5,a4
     3fa:	0307879b          	addiw	a5,a5,48
     3fe:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     402:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     406:	fb040513          	addi	a0,s0,-80
     40a:	1c1040ef          	jal	4dca <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     40e:	60200593          	li	a1,1538
     412:	fb040513          	addi	a0,s0,-80
     416:	1a5040ef          	jal	4dba <open>
    if(fd < 0){
     41a:	00054763          	bltz	a0,428 <outofinodes+0x6a>
      // failure is eventually expected.
      break;
    }
    close(fd);
     41e:	185040ef          	jal	4da2 <close>
  for(int i = 0; i < nzz; i++){
     422:	2485                	addiw	s1,s1,1
     424:	fb3499e3          	bne	s1,s3,3d6 <outofinodes+0x18>
     428:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     42a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     42e:	40000993          	li	s3,1024
    name[0] = 'z';
     432:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     436:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     43a:	41f4d71b          	sraiw	a4,s1,0x1f
     43e:	01b7571b          	srliw	a4,a4,0x1b
     442:	009707bb          	addw	a5,a4,s1
     446:	4057d69b          	sraiw	a3,a5,0x5
     44a:	0306869b          	addiw	a3,a3,48
     44e:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     452:	8bfd                	andi	a5,a5,31
     454:	9f99                	subw	a5,a5,a4
     456:	0307879b          	addiw	a5,a5,48
     45a:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     45e:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     462:	fb040513          	addi	a0,s0,-80
     466:	165040ef          	jal	4dca <unlink>
  for(int i = 0; i < nzz; i++){
     46a:	2485                	addiw	s1,s1,1
     46c:	fd3493e3          	bne	s1,s3,432 <outofinodes+0x74>
  }
}
     470:	60a6                	ld	ra,72(sp)
     472:	6406                	ld	s0,64(sp)
     474:	74e2                	ld	s1,56(sp)
     476:	7942                	ld	s2,48(sp)
     478:	79a2                	ld	s3,40(sp)
     47a:	6161                	addi	sp,sp,80
     47c:	8082                	ret

000000000000047e <copyin>:
{
     47e:	7159                	addi	sp,sp,-112
     480:	f486                	sd	ra,104(sp)
     482:	f0a2                	sd	s0,96(sp)
     484:	eca6                	sd	s1,88(sp)
     486:	e8ca                	sd	s2,80(sp)
     488:	e4ce                	sd	s3,72(sp)
     48a:	e0d2                	sd	s4,64(sp)
     48c:	fc56                	sd	s5,56(sp)
     48e:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     490:	00007797          	auipc	a5,0x7
     494:	45078793          	addi	a5,a5,1104 # 78e0 <malloc+0x267a>
     498:	638c                	ld	a1,0(a5)
     49a:	6790                	ld	a2,8(a5)
     49c:	6b94                	ld	a3,16(a5)
     49e:	6f98                	ld	a4,24(a5)
     4a0:	739c                	ld	a5,32(a5)
     4a2:	f8b43c23          	sd	a1,-104(s0)
     4a6:	fac43023          	sd	a2,-96(s0)
     4aa:	fad43423          	sd	a3,-88(s0)
     4ae:	fae43823          	sd	a4,-80(s0)
     4b2:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4b6:	f9840913          	addi	s2,s0,-104
     4ba:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4be:	00005a17          	auipc	s4,0x5
     4c2:	ff2a0a13          	addi	s4,s4,-14 # 54b0 <malloc+0x24a>
    uint64 addr = addrs[ai];
     4c6:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4ca:	20100593          	li	a1,513
     4ce:	8552                	mv	a0,s4
     4d0:	0eb040ef          	jal	4dba <open>
     4d4:	84aa                	mv	s1,a0
    if(fd < 0){
     4d6:	06054763          	bltz	a0,544 <copyin+0xc6>
    int n = write(fd, (void*)addr, 8192);
     4da:	6609                	lui	a2,0x2
     4dc:	85ce                	mv	a1,s3
     4de:	0bd040ef          	jal	4d9a <write>
    if(n >= 0){
     4e2:	06055a63          	bgez	a0,556 <copyin+0xd8>
    close(fd);
     4e6:	8526                	mv	a0,s1
     4e8:	0bb040ef          	jal	4da2 <close>
    unlink("copyin1");
     4ec:	8552                	mv	a0,s4
     4ee:	0dd040ef          	jal	4dca <unlink>
    n = write(1, (char*)addr, 8192);
     4f2:	6609                	lui	a2,0x2
     4f4:	85ce                	mv	a1,s3
     4f6:	4505                	li	a0,1
     4f8:	0a3040ef          	jal	4d9a <write>
    if(n > 0){
     4fc:	06a04863          	bgtz	a0,56c <copyin+0xee>
    if(pipe(fds) < 0){
     500:	f9040513          	addi	a0,s0,-112
     504:	087040ef          	jal	4d8a <pipe>
     508:	06054d63          	bltz	a0,582 <copyin+0x104>
    n = write(fds[1], (char*)addr, 8192);
     50c:	6609                	lui	a2,0x2
     50e:	85ce                	mv	a1,s3
     510:	f9442503          	lw	a0,-108(s0)
     514:	087040ef          	jal	4d9a <write>
    if(n > 0){
     518:	06a04e63          	bgtz	a0,594 <copyin+0x116>
    close(fds[0]);
     51c:	f9042503          	lw	a0,-112(s0)
     520:	083040ef          	jal	4da2 <close>
    close(fds[1]);
     524:	f9442503          	lw	a0,-108(s0)
     528:	07b040ef          	jal	4da2 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     52c:	0921                	addi	s2,s2,8
     52e:	f9591ce3          	bne	s2,s5,4c6 <copyin+0x48>
}
     532:	70a6                	ld	ra,104(sp)
     534:	7406                	ld	s0,96(sp)
     536:	64e6                	ld	s1,88(sp)
     538:	6946                	ld	s2,80(sp)
     53a:	69a6                	ld	s3,72(sp)
     53c:	6a06                	ld	s4,64(sp)
     53e:	7ae2                	ld	s5,56(sp)
     540:	6165                	addi	sp,sp,112
     542:	8082                	ret
      printf("open(copyin1) failed\n");
     544:	00005517          	auipc	a0,0x5
     548:	f7450513          	addi	a0,a0,-140 # 54b8 <malloc+0x252>
     54c:	467040ef          	jal	51b2 <printf>
      exit(1);
     550:	4505                	li	a0,1
     552:	029040ef          	jal	4d7a <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     556:	862a                	mv	a2,a0
     558:	85ce                	mv	a1,s3
     55a:	00005517          	auipc	a0,0x5
     55e:	f7650513          	addi	a0,a0,-138 # 54d0 <malloc+0x26a>
     562:	451040ef          	jal	51b2 <printf>
      exit(1);
     566:	4505                	li	a0,1
     568:	013040ef          	jal	4d7a <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     56c:	862a                	mv	a2,a0
     56e:	85ce                	mv	a1,s3
     570:	00005517          	auipc	a0,0x5
     574:	f9050513          	addi	a0,a0,-112 # 5500 <malloc+0x29a>
     578:	43b040ef          	jal	51b2 <printf>
      exit(1);
     57c:	4505                	li	a0,1
     57e:	7fc040ef          	jal	4d7a <exit>
      printf("pipe() failed\n");
     582:	00005517          	auipc	a0,0x5
     586:	fae50513          	addi	a0,a0,-82 # 5530 <malloc+0x2ca>
     58a:	429040ef          	jal	51b2 <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	7ea040ef          	jal	4d7a <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     594:	862a                	mv	a2,a0
     596:	85ce                	mv	a1,s3
     598:	00005517          	auipc	a0,0x5
     59c:	fa850513          	addi	a0,a0,-88 # 5540 <malloc+0x2da>
     5a0:	413040ef          	jal	51b2 <printf>
      exit(1);
     5a4:	4505                	li	a0,1
     5a6:	7d4040ef          	jal	4d7a <exit>

00000000000005aa <copyout>:
{
     5aa:	7119                	addi	sp,sp,-128
     5ac:	fc86                	sd	ra,120(sp)
     5ae:	f8a2                	sd	s0,112(sp)
     5b0:	f4a6                	sd	s1,104(sp)
     5b2:	f0ca                	sd	s2,96(sp)
     5b4:	ecce                	sd	s3,88(sp)
     5b6:	e8d2                	sd	s4,80(sp)
     5b8:	e4d6                	sd	s5,72(sp)
     5ba:	e0da                	sd	s6,64(sp)
     5bc:	0100                	addi	s0,sp,128
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     5be:	00007797          	auipc	a5,0x7
     5c2:	32278793          	addi	a5,a5,802 # 78e0 <malloc+0x267a>
     5c6:	7788                	ld	a0,40(a5)
     5c8:	7b8c                	ld	a1,48(a5)
     5ca:	7f90                	ld	a2,56(a5)
     5cc:	63b4                	ld	a3,64(a5)
     5ce:	67b8                	ld	a4,72(a5)
     5d0:	6bbc                	ld	a5,80(a5)
     5d2:	f8a43823          	sd	a0,-112(s0)
     5d6:	f8b43c23          	sd	a1,-104(s0)
     5da:	fac43023          	sd	a2,-96(s0)
     5de:	fad43423          	sd	a3,-88(s0)
     5e2:	fae43823          	sd	a4,-80(s0)
     5e6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     5ea:	f9040913          	addi	s2,s0,-112
     5ee:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
     5f2:	00005a17          	auipc	s4,0x5
     5f6:	f7ea0a13          	addi	s4,s4,-130 # 5570 <malloc+0x30a>
    n = write(fds[1], "x", 1);
     5fa:	00005a97          	auipc	s5,0x5
     5fe:	e0ea8a93          	addi	s5,s5,-498 # 5408 <malloc+0x1a2>
    uint64 addr = addrs[ai];
     602:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     606:	4581                	li	a1,0
     608:	8552                	mv	a0,s4
     60a:	7b0040ef          	jal	4dba <open>
     60e:	84aa                	mv	s1,a0
    if(fd < 0){
     610:	06054763          	bltz	a0,67e <copyout+0xd4>
    int n = read(fd, (void*)addr, 8192);
     614:	6609                	lui	a2,0x2
     616:	85ce                	mv	a1,s3
     618:	77a040ef          	jal	4d92 <read>
    if(n > 0){
     61c:	06a04a63          	bgtz	a0,690 <copyout+0xe6>
    close(fd);
     620:	8526                	mv	a0,s1
     622:	780040ef          	jal	4da2 <close>
    if(pipe(fds) < 0){
     626:	f8840513          	addi	a0,s0,-120
     62a:	760040ef          	jal	4d8a <pipe>
     62e:	06054c63          	bltz	a0,6a6 <copyout+0xfc>
    n = write(fds[1], "x", 1);
     632:	4605                	li	a2,1
     634:	85d6                	mv	a1,s5
     636:	f8c42503          	lw	a0,-116(s0)
     63a:	760040ef          	jal	4d9a <write>
    if(n != 1){
     63e:	4785                	li	a5,1
     640:	06f51c63          	bne	a0,a5,6b8 <copyout+0x10e>
    n = read(fds[0], (void*)addr, 8192);
     644:	6609                	lui	a2,0x2
     646:	85ce                	mv	a1,s3
     648:	f8842503          	lw	a0,-120(s0)
     64c:	746040ef          	jal	4d92 <read>
    if(n > 0){
     650:	06a04d63          	bgtz	a0,6ca <copyout+0x120>
    close(fds[0]);
     654:	f8842503          	lw	a0,-120(s0)
     658:	74a040ef          	jal	4da2 <close>
    close(fds[1]);
     65c:	f8c42503          	lw	a0,-116(s0)
     660:	742040ef          	jal	4da2 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     664:	0921                	addi	s2,s2,8
     666:	f9691ee3          	bne	s2,s6,602 <copyout+0x58>
}
     66a:	70e6                	ld	ra,120(sp)
     66c:	7446                	ld	s0,112(sp)
     66e:	74a6                	ld	s1,104(sp)
     670:	7906                	ld	s2,96(sp)
     672:	69e6                	ld	s3,88(sp)
     674:	6a46                	ld	s4,80(sp)
     676:	6aa6                	ld	s5,72(sp)
     678:	6b06                	ld	s6,64(sp)
     67a:	6109                	addi	sp,sp,128
     67c:	8082                	ret
      printf("open(README) failed\n");
     67e:	00005517          	auipc	a0,0x5
     682:	efa50513          	addi	a0,a0,-262 # 5578 <malloc+0x312>
     686:	32d040ef          	jal	51b2 <printf>
      exit(1);
     68a:	4505                	li	a0,1
     68c:	6ee040ef          	jal	4d7a <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     690:	862a                	mv	a2,a0
     692:	85ce                	mv	a1,s3
     694:	00005517          	auipc	a0,0x5
     698:	efc50513          	addi	a0,a0,-260 # 5590 <malloc+0x32a>
     69c:	317040ef          	jal	51b2 <printf>
      exit(1);
     6a0:	4505                	li	a0,1
     6a2:	6d8040ef          	jal	4d7a <exit>
      printf("pipe() failed\n");
     6a6:	00005517          	auipc	a0,0x5
     6aa:	e8a50513          	addi	a0,a0,-374 # 5530 <malloc+0x2ca>
     6ae:	305040ef          	jal	51b2 <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	6c6040ef          	jal	4d7a <exit>
      printf("pipe write failed\n");
     6b8:	00005517          	auipc	a0,0x5
     6bc:	f0850513          	addi	a0,a0,-248 # 55c0 <malloc+0x35a>
     6c0:	2f3040ef          	jal	51b2 <printf>
      exit(1);
     6c4:	4505                	li	a0,1
     6c6:	6b4040ef          	jal	4d7a <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6ca:	862a                	mv	a2,a0
     6cc:	85ce                	mv	a1,s3
     6ce:	00005517          	auipc	a0,0x5
     6d2:	f0a50513          	addi	a0,a0,-246 # 55d8 <malloc+0x372>
     6d6:	2dd040ef          	jal	51b2 <printf>
      exit(1);
     6da:	4505                	li	a0,1
     6dc:	69e040ef          	jal	4d7a <exit>

00000000000006e0 <truncate1>:
{
     6e0:	711d                	addi	sp,sp,-96
     6e2:	ec86                	sd	ra,88(sp)
     6e4:	e8a2                	sd	s0,80(sp)
     6e6:	e4a6                	sd	s1,72(sp)
     6e8:	e0ca                	sd	s2,64(sp)
     6ea:	fc4e                	sd	s3,56(sp)
     6ec:	f852                	sd	s4,48(sp)
     6ee:	f456                	sd	s5,40(sp)
     6f0:	1080                	addi	s0,sp,96
     6f2:	8aaa                	mv	s5,a0
  unlink("truncfile");
     6f4:	00005517          	auipc	a0,0x5
     6f8:	cfc50513          	addi	a0,a0,-772 # 53f0 <malloc+0x18a>
     6fc:	6ce040ef          	jal	4dca <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     700:	60100593          	li	a1,1537
     704:	00005517          	auipc	a0,0x5
     708:	cec50513          	addi	a0,a0,-788 # 53f0 <malloc+0x18a>
     70c:	6ae040ef          	jal	4dba <open>
     710:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     712:	4611                	li	a2,4
     714:	00005597          	auipc	a1,0x5
     718:	cec58593          	addi	a1,a1,-788 # 5400 <malloc+0x19a>
     71c:	67e040ef          	jal	4d9a <write>
  close(fd1);
     720:	8526                	mv	a0,s1
     722:	680040ef          	jal	4da2 <close>
  int fd2 = open("truncfile", O_RDONLY);
     726:	4581                	li	a1,0
     728:	00005517          	auipc	a0,0x5
     72c:	cc850513          	addi	a0,a0,-824 # 53f0 <malloc+0x18a>
     730:	68a040ef          	jal	4dba <open>
     734:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     736:	02000613          	li	a2,32
     73a:	fa040593          	addi	a1,s0,-96
     73e:	654040ef          	jal	4d92 <read>
  if(n != 4){
     742:	4791                	li	a5,4
     744:	0af51863          	bne	a0,a5,7f4 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     748:	40100593          	li	a1,1025
     74c:	00005517          	auipc	a0,0x5
     750:	ca450513          	addi	a0,a0,-860 # 53f0 <malloc+0x18a>
     754:	666040ef          	jal	4dba <open>
     758:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     75a:	4581                	li	a1,0
     75c:	00005517          	auipc	a0,0x5
     760:	c9450513          	addi	a0,a0,-876 # 53f0 <malloc+0x18a>
     764:	656040ef          	jal	4dba <open>
     768:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     76a:	02000613          	li	a2,32
     76e:	fa040593          	addi	a1,s0,-96
     772:	620040ef          	jal	4d92 <read>
     776:	8a2a                	mv	s4,a0
  if(n != 0){
     778:	e949                	bnez	a0,80a <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     77a:	02000613          	li	a2,32
     77e:	fa040593          	addi	a1,s0,-96
     782:	8526                	mv	a0,s1
     784:	60e040ef          	jal	4d92 <read>
     788:	8a2a                	mv	s4,a0
  if(n != 0){
     78a:	e155                	bnez	a0,82e <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     78c:	4619                	li	a2,6
     78e:	00005597          	auipc	a1,0x5
     792:	eda58593          	addi	a1,a1,-294 # 5668 <malloc+0x402>
     796:	854e                	mv	a0,s3
     798:	602040ef          	jal	4d9a <write>
  n = read(fd3, buf, sizeof(buf));
     79c:	02000613          	li	a2,32
     7a0:	fa040593          	addi	a1,s0,-96
     7a4:	854a                	mv	a0,s2
     7a6:	5ec040ef          	jal	4d92 <read>
  if(n != 6){
     7aa:	4799                	li	a5,6
     7ac:	0af51363          	bne	a0,a5,852 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     7b0:	02000613          	li	a2,32
     7b4:	fa040593          	addi	a1,s0,-96
     7b8:	8526                	mv	a0,s1
     7ba:	5d8040ef          	jal	4d92 <read>
  if(n != 2){
     7be:	4789                	li	a5,2
     7c0:	0af51463          	bne	a0,a5,868 <truncate1+0x188>
  unlink("truncfile");
     7c4:	00005517          	auipc	a0,0x5
     7c8:	c2c50513          	addi	a0,a0,-980 # 53f0 <malloc+0x18a>
     7cc:	5fe040ef          	jal	4dca <unlink>
  close(fd1);
     7d0:	854e                	mv	a0,s3
     7d2:	5d0040ef          	jal	4da2 <close>
  close(fd2);
     7d6:	8526                	mv	a0,s1
     7d8:	5ca040ef          	jal	4da2 <close>
  close(fd3);
     7dc:	854a                	mv	a0,s2
     7de:	5c4040ef          	jal	4da2 <close>
}
     7e2:	60e6                	ld	ra,88(sp)
     7e4:	6446                	ld	s0,80(sp)
     7e6:	64a6                	ld	s1,72(sp)
     7e8:	6906                	ld	s2,64(sp)
     7ea:	79e2                	ld	s3,56(sp)
     7ec:	7a42                	ld	s4,48(sp)
     7ee:	7aa2                	ld	s5,40(sp)
     7f0:	6125                	addi	sp,sp,96
     7f2:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     7f4:	862a                	mv	a2,a0
     7f6:	85d6                	mv	a1,s5
     7f8:	00005517          	auipc	a0,0x5
     7fc:	e1050513          	addi	a0,a0,-496 # 5608 <malloc+0x3a2>
     800:	1b3040ef          	jal	51b2 <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	574040ef          	jal	4d7a <exit>
    printf("aaa fd3=%d\n", fd3);
     80a:	85ca                	mv	a1,s2
     80c:	00005517          	auipc	a0,0x5
     810:	e1c50513          	addi	a0,a0,-484 # 5628 <malloc+0x3c2>
     814:	19f040ef          	jal	51b2 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     818:	8652                	mv	a2,s4
     81a:	85d6                	mv	a1,s5
     81c:	00005517          	auipc	a0,0x5
     820:	e1c50513          	addi	a0,a0,-484 # 5638 <malloc+0x3d2>
     824:	18f040ef          	jal	51b2 <printf>
    exit(1);
     828:	4505                	li	a0,1
     82a:	550040ef          	jal	4d7a <exit>
    printf("bbb fd2=%d\n", fd2);
     82e:	85a6                	mv	a1,s1
     830:	00005517          	auipc	a0,0x5
     834:	e2850513          	addi	a0,a0,-472 # 5658 <malloc+0x3f2>
     838:	17b040ef          	jal	51b2 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     83c:	8652                	mv	a2,s4
     83e:	85d6                	mv	a1,s5
     840:	00005517          	auipc	a0,0x5
     844:	df850513          	addi	a0,a0,-520 # 5638 <malloc+0x3d2>
     848:	16b040ef          	jal	51b2 <printf>
    exit(1);
     84c:	4505                	li	a0,1
     84e:	52c040ef          	jal	4d7a <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     852:	862a                	mv	a2,a0
     854:	85d6                	mv	a1,s5
     856:	00005517          	auipc	a0,0x5
     85a:	e1a50513          	addi	a0,a0,-486 # 5670 <malloc+0x40a>
     85e:	155040ef          	jal	51b2 <printf>
    exit(1);
     862:	4505                	li	a0,1
     864:	516040ef          	jal	4d7a <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     868:	862a                	mv	a2,a0
     86a:	85d6                	mv	a1,s5
     86c:	00005517          	auipc	a0,0x5
     870:	e2450513          	addi	a0,a0,-476 # 5690 <malloc+0x42a>
     874:	13f040ef          	jal	51b2 <printf>
    exit(1);
     878:	4505                	li	a0,1
     87a:	500040ef          	jal	4d7a <exit>

000000000000087e <writetest>:
{
     87e:	7139                	addi	sp,sp,-64
     880:	fc06                	sd	ra,56(sp)
     882:	f822                	sd	s0,48(sp)
     884:	f426                	sd	s1,40(sp)
     886:	f04a                	sd	s2,32(sp)
     888:	ec4e                	sd	s3,24(sp)
     88a:	e852                	sd	s4,16(sp)
     88c:	e456                	sd	s5,8(sp)
     88e:	e05a                	sd	s6,0(sp)
     890:	0080                	addi	s0,sp,64
     892:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     894:	20200593          	li	a1,514
     898:	00005517          	auipc	a0,0x5
     89c:	e1850513          	addi	a0,a0,-488 # 56b0 <malloc+0x44a>
     8a0:	51a040ef          	jal	4dba <open>
  if(fd < 0){
     8a4:	08054f63          	bltz	a0,942 <writetest+0xc4>
     8a8:	892a                	mv	s2,a0
     8aa:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8ac:	00005997          	auipc	s3,0x5
     8b0:	e2c98993          	addi	s3,s3,-468 # 56d8 <malloc+0x472>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8b4:	00005a97          	auipc	s5,0x5
     8b8:	e5ca8a93          	addi	s5,s5,-420 # 5710 <malloc+0x4aa>
  for(i = 0; i < N; i++){
     8bc:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8c0:	4629                	li	a2,10
     8c2:	85ce                	mv	a1,s3
     8c4:	854a                	mv	a0,s2
     8c6:	4d4040ef          	jal	4d9a <write>
     8ca:	47a9                	li	a5,10
     8cc:	08f51563          	bne	a0,a5,956 <writetest+0xd8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8d0:	4629                	li	a2,10
     8d2:	85d6                	mv	a1,s5
     8d4:	854a                	mv	a0,s2
     8d6:	4c4040ef          	jal	4d9a <write>
     8da:	47a9                	li	a5,10
     8dc:	08f51863          	bne	a0,a5,96c <writetest+0xee>
  for(i = 0; i < N; i++){
     8e0:	2485                	addiw	s1,s1,1
     8e2:	fd449fe3          	bne	s1,s4,8c0 <writetest+0x42>
  close(fd);
     8e6:	854a                	mv	a0,s2
     8e8:	4ba040ef          	jal	4da2 <close>
  fd = open("small", O_RDONLY);
     8ec:	4581                	li	a1,0
     8ee:	00005517          	auipc	a0,0x5
     8f2:	dc250513          	addi	a0,a0,-574 # 56b0 <malloc+0x44a>
     8f6:	4c4040ef          	jal	4dba <open>
     8fa:	84aa                	mv	s1,a0
  if(fd < 0){
     8fc:	08054363          	bltz	a0,982 <writetest+0x104>
  i = read(fd, buf, N*SZ*2);
     900:	7d000613          	li	a2,2000
     904:	0000b597          	auipc	a1,0xb
     908:	3b458593          	addi	a1,a1,948 # bcb8 <buf>
     90c:	486040ef          	jal	4d92 <read>
  if(i != N*SZ*2){
     910:	7d000793          	li	a5,2000
     914:	08f51163          	bne	a0,a5,996 <writetest+0x118>
  close(fd);
     918:	8526                	mv	a0,s1
     91a:	488040ef          	jal	4da2 <close>
  if(unlink("small") < 0){
     91e:	00005517          	auipc	a0,0x5
     922:	d9250513          	addi	a0,a0,-622 # 56b0 <malloc+0x44a>
     926:	4a4040ef          	jal	4dca <unlink>
     92a:	08054063          	bltz	a0,9aa <writetest+0x12c>
}
     92e:	70e2                	ld	ra,56(sp)
     930:	7442                	ld	s0,48(sp)
     932:	74a2                	ld	s1,40(sp)
     934:	7902                	ld	s2,32(sp)
     936:	69e2                	ld	s3,24(sp)
     938:	6a42                	ld	s4,16(sp)
     93a:	6aa2                	ld	s5,8(sp)
     93c:	6b02                	ld	s6,0(sp)
     93e:	6121                	addi	sp,sp,64
     940:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     942:	85da                	mv	a1,s6
     944:	00005517          	auipc	a0,0x5
     948:	d7450513          	addi	a0,a0,-652 # 56b8 <malloc+0x452>
     94c:	067040ef          	jal	51b2 <printf>
    exit(1);
     950:	4505                	li	a0,1
     952:	428040ef          	jal	4d7a <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     956:	8626                	mv	a2,s1
     958:	85da                	mv	a1,s6
     95a:	00005517          	auipc	a0,0x5
     95e:	d8e50513          	addi	a0,a0,-626 # 56e8 <malloc+0x482>
     962:	051040ef          	jal	51b2 <printf>
      exit(1);
     966:	4505                	li	a0,1
     968:	412040ef          	jal	4d7a <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     96c:	8626                	mv	a2,s1
     96e:	85da                	mv	a1,s6
     970:	00005517          	auipc	a0,0x5
     974:	db050513          	addi	a0,a0,-592 # 5720 <malloc+0x4ba>
     978:	03b040ef          	jal	51b2 <printf>
      exit(1);
     97c:	4505                	li	a0,1
     97e:	3fc040ef          	jal	4d7a <exit>
    printf("%s: error: open small failed!\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	dc450513          	addi	a0,a0,-572 # 5748 <malloc+0x4e2>
     98c:	027040ef          	jal	51b2 <printf>
    exit(1);
     990:	4505                	li	a0,1
     992:	3e8040ef          	jal	4d7a <exit>
    printf("%s: read failed\n", s);
     996:	85da                	mv	a1,s6
     998:	00005517          	auipc	a0,0x5
     99c:	dd050513          	addi	a0,a0,-560 # 5768 <malloc+0x502>
     9a0:	013040ef          	jal	51b2 <printf>
    exit(1);
     9a4:	4505                	li	a0,1
     9a6:	3d4040ef          	jal	4d7a <exit>
    printf("%s: unlink small failed\n", s);
     9aa:	85da                	mv	a1,s6
     9ac:	00005517          	auipc	a0,0x5
     9b0:	dd450513          	addi	a0,a0,-556 # 5780 <malloc+0x51a>
     9b4:	7fe040ef          	jal	51b2 <printf>
    exit(1);
     9b8:	4505                	li	a0,1
     9ba:	3c0040ef          	jal	4d7a <exit>

00000000000009be <writebig>:
{
     9be:	7139                	addi	sp,sp,-64
     9c0:	fc06                	sd	ra,56(sp)
     9c2:	f822                	sd	s0,48(sp)
     9c4:	f426                	sd	s1,40(sp)
     9c6:	f04a                	sd	s2,32(sp)
     9c8:	ec4e                	sd	s3,24(sp)
     9ca:	e852                	sd	s4,16(sp)
     9cc:	e456                	sd	s5,8(sp)
     9ce:	0080                	addi	s0,sp,64
     9d0:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9d2:	20200593          	li	a1,514
     9d6:	00005517          	auipc	a0,0x5
     9da:	dca50513          	addi	a0,a0,-566 # 57a0 <malloc+0x53a>
     9de:	3dc040ef          	jal	4dba <open>
     9e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e6:	0000b917          	auipc	s2,0xb
     9ea:	2d290913          	addi	s2,s2,722 # bcb8 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ee:	6a41                	lui	s4,0x10
     9f0:	10ba0a13          	addi	s4,s4,267 # 1010b <base+0x1453>
  if(fd < 0){
     9f4:	06054463          	bltz	a0,a5c <writebig+0x9e>
    ((int*)buf)[0] = i;
     9f8:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fc:	40000613          	li	a2,1024
     a00:	85ca                	mv	a1,s2
     a02:	854e                	mv	a0,s3
     a04:	396040ef          	jal	4d9a <write>
     a08:	40000793          	li	a5,1024
     a0c:	06f51263          	bne	a0,a5,a70 <writebig+0xb2>
  for(i = 0; i < MAXFILE; i++){
     a10:	2485                	addiw	s1,s1,1
     a12:	ff4493e3          	bne	s1,s4,9f8 <writebig+0x3a>
  close(fd);
     a16:	854e                	mv	a0,s3
     a18:	38a040ef          	jal	4da2 <close>
  fd = open("big", O_RDONLY);
     a1c:	4581                	li	a1,0
     a1e:	00005517          	auipc	a0,0x5
     a22:	d8250513          	addi	a0,a0,-638 # 57a0 <malloc+0x53a>
     a26:	394040ef          	jal	4dba <open>
     a2a:	89aa                	mv	s3,a0
  n = 0;
     a2c:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2e:	0000b917          	auipc	s2,0xb
     a32:	28a90913          	addi	s2,s2,650 # bcb8 <buf>
  if(fd < 0){
     a36:	04054863          	bltz	a0,a86 <writebig+0xc8>
    i = read(fd, buf, BSIZE);
     a3a:	40000613          	li	a2,1024
     a3e:	85ca                	mv	a1,s2
     a40:	854e                	mv	a0,s3
     a42:	350040ef          	jal	4d92 <read>
    if(i == 0){
     a46:	c931                	beqz	a0,a9a <writebig+0xdc>
    } else if(i != BSIZE){
     a48:	40000793          	li	a5,1024
     a4c:	08f51b63          	bne	a0,a5,ae2 <writebig+0x124>
    if(((int*)buf)[0] != n){
     a50:	00092683          	lw	a3,0(s2)
     a54:	0a969263          	bne	a3,s1,af8 <writebig+0x13a>
    n++;
     a58:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a5a:	b7c5                	j	a3a <writebig+0x7c>
    printf("%s: error: creat big failed!\n", s);
     a5c:	85d6                	mv	a1,s5
     a5e:	00005517          	auipc	a0,0x5
     a62:	d4a50513          	addi	a0,a0,-694 # 57a8 <malloc+0x542>
     a66:	74c040ef          	jal	51b2 <printf>
    exit(1);
     a6a:	4505                	li	a0,1
     a6c:	30e040ef          	jal	4d7a <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     a70:	8626                	mv	a2,s1
     a72:	85d6                	mv	a1,s5
     a74:	00005517          	auipc	a0,0x5
     a78:	d5450513          	addi	a0,a0,-684 # 57c8 <malloc+0x562>
     a7c:	736040ef          	jal	51b2 <printf>
      exit(1);
     a80:	4505                	li	a0,1
     a82:	2f8040ef          	jal	4d7a <exit>
    printf("%s: error: open big failed!\n", s);
     a86:	85d6                	mv	a1,s5
     a88:	00005517          	auipc	a0,0x5
     a8c:	d6850513          	addi	a0,a0,-664 # 57f0 <malloc+0x58a>
     a90:	722040ef          	jal	51b2 <printf>
    exit(1);
     a94:	4505                	li	a0,1
     a96:	2e4040ef          	jal	4d7a <exit>
      if(n != MAXFILE){
     a9a:	67c1                	lui	a5,0x10
     a9c:	10b78793          	addi	a5,a5,267 # 1010b <base+0x1453>
     aa0:	02f49663          	bne	s1,a5,acc <writebig+0x10e>
  close(fd);
     aa4:	854e                	mv	a0,s3
     aa6:	2fc040ef          	jal	4da2 <close>
  if(unlink("big") < 0){
     aaa:	00005517          	auipc	a0,0x5
     aae:	cf650513          	addi	a0,a0,-778 # 57a0 <malloc+0x53a>
     ab2:	318040ef          	jal	4dca <unlink>
     ab6:	04054c63          	bltz	a0,b0e <writebig+0x150>
}
     aba:	70e2                	ld	ra,56(sp)
     abc:	7442                	ld	s0,48(sp)
     abe:	74a2                	ld	s1,40(sp)
     ac0:	7902                	ld	s2,32(sp)
     ac2:	69e2                	ld	s3,24(sp)
     ac4:	6a42                	ld	s4,16(sp)
     ac6:	6aa2                	ld	s5,8(sp)
     ac8:	6121                	addi	sp,sp,64
     aca:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     acc:	8626                	mv	a2,s1
     ace:	85d6                	mv	a1,s5
     ad0:	00005517          	auipc	a0,0x5
     ad4:	d4050513          	addi	a0,a0,-704 # 5810 <malloc+0x5aa>
     ad8:	6da040ef          	jal	51b2 <printf>
        exit(1);
     adc:	4505                	li	a0,1
     ade:	29c040ef          	jal	4d7a <exit>
      printf("%s: read failed %d\n", s, i);
     ae2:	862a                	mv	a2,a0
     ae4:	85d6                	mv	a1,s5
     ae6:	00005517          	auipc	a0,0x5
     aea:	d5250513          	addi	a0,a0,-686 # 5838 <malloc+0x5d2>
     aee:	6c4040ef          	jal	51b2 <printf>
      exit(1);
     af2:	4505                	li	a0,1
     af4:	286040ef          	jal	4d7a <exit>
      printf("%s: read content of block %d is %d\n", s,
     af8:	8626                	mv	a2,s1
     afa:	85d6                	mv	a1,s5
     afc:	00005517          	auipc	a0,0x5
     b00:	d5450513          	addi	a0,a0,-684 # 5850 <malloc+0x5ea>
     b04:	6ae040ef          	jal	51b2 <printf>
      exit(1);
     b08:	4505                	li	a0,1
     b0a:	270040ef          	jal	4d7a <exit>
    printf("%s: unlink big failed\n", s);
     b0e:	85d6                	mv	a1,s5
     b10:	00005517          	auipc	a0,0x5
     b14:	d6850513          	addi	a0,a0,-664 # 5878 <malloc+0x612>
     b18:	69a040ef          	jal	51b2 <printf>
    exit(1);
     b1c:	4505                	li	a0,1
     b1e:	25c040ef          	jal	4d7a <exit>

0000000000000b22 <unlinkread>:
{
     b22:	7179                	addi	sp,sp,-48
     b24:	f406                	sd	ra,40(sp)
     b26:	f022                	sd	s0,32(sp)
     b28:	ec26                	sd	s1,24(sp)
     b2a:	e84a                	sd	s2,16(sp)
     b2c:	e44e                	sd	s3,8(sp)
     b2e:	1800                	addi	s0,sp,48
     b30:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b32:	20200593          	li	a1,514
     b36:	00005517          	auipc	a0,0x5
     b3a:	d5a50513          	addi	a0,a0,-678 # 5890 <malloc+0x62a>
     b3e:	27c040ef          	jal	4dba <open>
  if(fd < 0){
     b42:	0a054f63          	bltz	a0,c00 <unlinkread+0xde>
     b46:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b48:	4615                	li	a2,5
     b4a:	00005597          	auipc	a1,0x5
     b4e:	d7658593          	addi	a1,a1,-650 # 58c0 <malloc+0x65a>
     b52:	248040ef          	jal	4d9a <write>
  close(fd);
     b56:	8526                	mv	a0,s1
     b58:	24a040ef          	jal	4da2 <close>
  fd = open("unlinkread", O_RDWR);
     b5c:	4589                	li	a1,2
     b5e:	00005517          	auipc	a0,0x5
     b62:	d3250513          	addi	a0,a0,-718 # 5890 <malloc+0x62a>
     b66:	254040ef          	jal	4dba <open>
     b6a:	84aa                	mv	s1,a0
  if(fd < 0){
     b6c:	0a054463          	bltz	a0,c14 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     b70:	00005517          	auipc	a0,0x5
     b74:	d2050513          	addi	a0,a0,-736 # 5890 <malloc+0x62a>
     b78:	252040ef          	jal	4dca <unlink>
     b7c:	e555                	bnez	a0,c28 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b7e:	20200593          	li	a1,514
     b82:	00005517          	auipc	a0,0x5
     b86:	d0e50513          	addi	a0,a0,-754 # 5890 <malloc+0x62a>
     b8a:	230040ef          	jal	4dba <open>
     b8e:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b90:	460d                	li	a2,3
     b92:	00005597          	auipc	a1,0x5
     b96:	d7658593          	addi	a1,a1,-650 # 5908 <malloc+0x6a2>
     b9a:	200040ef          	jal	4d9a <write>
  close(fd1);
     b9e:	854a                	mv	a0,s2
     ba0:	202040ef          	jal	4da2 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ba4:	660d                	lui	a2,0x3
     ba6:	0000b597          	auipc	a1,0xb
     baa:	11258593          	addi	a1,a1,274 # bcb8 <buf>
     bae:	8526                	mv	a0,s1
     bb0:	1e2040ef          	jal	4d92 <read>
     bb4:	4795                	li	a5,5
     bb6:	08f51363          	bne	a0,a5,c3c <unlinkread+0x11a>
  if(buf[0] != 'h'){
     bba:	0000b717          	auipc	a4,0xb
     bbe:	0fe74703          	lbu	a4,254(a4) # bcb8 <buf>
     bc2:	06800793          	li	a5,104
     bc6:	08f71563          	bne	a4,a5,c50 <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     bca:	4629                	li	a2,10
     bcc:	0000b597          	auipc	a1,0xb
     bd0:	0ec58593          	addi	a1,a1,236 # bcb8 <buf>
     bd4:	8526                	mv	a0,s1
     bd6:	1c4040ef          	jal	4d9a <write>
     bda:	47a9                	li	a5,10
     bdc:	08f51463          	bne	a0,a5,c64 <unlinkread+0x142>
  close(fd);
     be0:	8526                	mv	a0,s1
     be2:	1c0040ef          	jal	4da2 <close>
  unlink("unlinkread");
     be6:	00005517          	auipc	a0,0x5
     bea:	caa50513          	addi	a0,a0,-854 # 5890 <malloc+0x62a>
     bee:	1dc040ef          	jal	4dca <unlink>
}
     bf2:	70a2                	ld	ra,40(sp)
     bf4:	7402                	ld	s0,32(sp)
     bf6:	64e2                	ld	s1,24(sp)
     bf8:	6942                	ld	s2,16(sp)
     bfa:	69a2                	ld	s3,8(sp)
     bfc:	6145                	addi	sp,sp,48
     bfe:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c00:	85ce                	mv	a1,s3
     c02:	00005517          	auipc	a0,0x5
     c06:	c9e50513          	addi	a0,a0,-866 # 58a0 <malloc+0x63a>
     c0a:	5a8040ef          	jal	51b2 <printf>
    exit(1);
     c0e:	4505                	li	a0,1
     c10:	16a040ef          	jal	4d7a <exit>
    printf("%s: open unlinkread failed\n", s);
     c14:	85ce                	mv	a1,s3
     c16:	00005517          	auipc	a0,0x5
     c1a:	cb250513          	addi	a0,a0,-846 # 58c8 <malloc+0x662>
     c1e:	594040ef          	jal	51b2 <printf>
    exit(1);
     c22:	4505                	li	a0,1
     c24:	156040ef          	jal	4d7a <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c28:	85ce                	mv	a1,s3
     c2a:	00005517          	auipc	a0,0x5
     c2e:	cbe50513          	addi	a0,a0,-834 # 58e8 <malloc+0x682>
     c32:	580040ef          	jal	51b2 <printf>
    exit(1);
     c36:	4505                	li	a0,1
     c38:	142040ef          	jal	4d7a <exit>
    printf("%s: unlinkread read failed", s);
     c3c:	85ce                	mv	a1,s3
     c3e:	00005517          	auipc	a0,0x5
     c42:	cd250513          	addi	a0,a0,-814 # 5910 <malloc+0x6aa>
     c46:	56c040ef          	jal	51b2 <printf>
    exit(1);
     c4a:	4505                	li	a0,1
     c4c:	12e040ef          	jal	4d7a <exit>
    printf("%s: unlinkread wrong data\n", s);
     c50:	85ce                	mv	a1,s3
     c52:	00005517          	auipc	a0,0x5
     c56:	cde50513          	addi	a0,a0,-802 # 5930 <malloc+0x6ca>
     c5a:	558040ef          	jal	51b2 <printf>
    exit(1);
     c5e:	4505                	li	a0,1
     c60:	11a040ef          	jal	4d7a <exit>
    printf("%s: unlinkread write failed\n", s);
     c64:	85ce                	mv	a1,s3
     c66:	00005517          	auipc	a0,0x5
     c6a:	cea50513          	addi	a0,a0,-790 # 5950 <malloc+0x6ea>
     c6e:	544040ef          	jal	51b2 <printf>
    exit(1);
     c72:	4505                	li	a0,1
     c74:	106040ef          	jal	4d7a <exit>

0000000000000c78 <linktest>:
{
     c78:	1101                	addi	sp,sp,-32
     c7a:	ec06                	sd	ra,24(sp)
     c7c:	e822                	sd	s0,16(sp)
     c7e:	e426                	sd	s1,8(sp)
     c80:	e04a                	sd	s2,0(sp)
     c82:	1000                	addi	s0,sp,32
     c84:	892a                	mv	s2,a0
  unlink("lf1");
     c86:	00005517          	auipc	a0,0x5
     c8a:	cea50513          	addi	a0,a0,-790 # 5970 <malloc+0x70a>
     c8e:	13c040ef          	jal	4dca <unlink>
  unlink("lf2");
     c92:	00005517          	auipc	a0,0x5
     c96:	ce650513          	addi	a0,a0,-794 # 5978 <malloc+0x712>
     c9a:	130040ef          	jal	4dca <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     c9e:	20200593          	li	a1,514
     ca2:	00005517          	auipc	a0,0x5
     ca6:	cce50513          	addi	a0,a0,-818 # 5970 <malloc+0x70a>
     caa:	110040ef          	jal	4dba <open>
  if(fd < 0){
     cae:	0c054f63          	bltz	a0,d8c <linktest+0x114>
     cb2:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     cb4:	4615                	li	a2,5
     cb6:	00005597          	auipc	a1,0x5
     cba:	c0a58593          	addi	a1,a1,-1014 # 58c0 <malloc+0x65a>
     cbe:	0dc040ef          	jal	4d9a <write>
     cc2:	4795                	li	a5,5
     cc4:	0cf51e63          	bne	a0,a5,da0 <linktest+0x128>
  close(fd);
     cc8:	8526                	mv	a0,s1
     cca:	0d8040ef          	jal	4da2 <close>
  if(link("lf1", "lf2") < 0){
     cce:	00005597          	auipc	a1,0x5
     cd2:	caa58593          	addi	a1,a1,-854 # 5978 <malloc+0x712>
     cd6:	00005517          	auipc	a0,0x5
     cda:	c9a50513          	addi	a0,a0,-870 # 5970 <malloc+0x70a>
     cde:	0fc040ef          	jal	4dda <link>
     ce2:	0c054963          	bltz	a0,db4 <linktest+0x13c>
  unlink("lf1");
     ce6:	00005517          	auipc	a0,0x5
     cea:	c8a50513          	addi	a0,a0,-886 # 5970 <malloc+0x70a>
     cee:	0dc040ef          	jal	4dca <unlink>
  if(open("lf1", 0) >= 0){
     cf2:	4581                	li	a1,0
     cf4:	00005517          	auipc	a0,0x5
     cf8:	c7c50513          	addi	a0,a0,-900 # 5970 <malloc+0x70a>
     cfc:	0be040ef          	jal	4dba <open>
     d00:	0c055463          	bgez	a0,dc8 <linktest+0x150>
  fd = open("lf2", 0);
     d04:	4581                	li	a1,0
     d06:	00005517          	auipc	a0,0x5
     d0a:	c7250513          	addi	a0,a0,-910 # 5978 <malloc+0x712>
     d0e:	0ac040ef          	jal	4dba <open>
     d12:	84aa                	mv	s1,a0
  if(fd < 0){
     d14:	0c054463          	bltz	a0,ddc <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d18:	660d                	lui	a2,0x3
     d1a:	0000b597          	auipc	a1,0xb
     d1e:	f9e58593          	addi	a1,a1,-98 # bcb8 <buf>
     d22:	070040ef          	jal	4d92 <read>
     d26:	4795                	li	a5,5
     d28:	0cf51463          	bne	a0,a5,df0 <linktest+0x178>
  close(fd);
     d2c:	8526                	mv	a0,s1
     d2e:	074040ef          	jal	4da2 <close>
  if(link("lf2", "lf2") >= 0){
     d32:	00005597          	auipc	a1,0x5
     d36:	c4658593          	addi	a1,a1,-954 # 5978 <malloc+0x712>
     d3a:	852e                	mv	a0,a1
     d3c:	09e040ef          	jal	4dda <link>
     d40:	0c055263          	bgez	a0,e04 <linktest+0x18c>
  unlink("lf2");
     d44:	00005517          	auipc	a0,0x5
     d48:	c3450513          	addi	a0,a0,-972 # 5978 <malloc+0x712>
     d4c:	07e040ef          	jal	4dca <unlink>
  if(link("lf2", "lf1") >= 0){
     d50:	00005597          	auipc	a1,0x5
     d54:	c2058593          	addi	a1,a1,-992 # 5970 <malloc+0x70a>
     d58:	00005517          	auipc	a0,0x5
     d5c:	c2050513          	addi	a0,a0,-992 # 5978 <malloc+0x712>
     d60:	07a040ef          	jal	4dda <link>
     d64:	0a055a63          	bgez	a0,e18 <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     d68:	00005597          	auipc	a1,0x5
     d6c:	c0858593          	addi	a1,a1,-1016 # 5970 <malloc+0x70a>
     d70:	00005517          	auipc	a0,0x5
     d74:	d1050513          	addi	a0,a0,-752 # 5a80 <malloc+0x81a>
     d78:	062040ef          	jal	4dda <link>
     d7c:	0a055863          	bgez	a0,e2c <linktest+0x1b4>
}
     d80:	60e2                	ld	ra,24(sp)
     d82:	6442                	ld	s0,16(sp)
     d84:	64a2                	ld	s1,8(sp)
     d86:	6902                	ld	s2,0(sp)
     d88:	6105                	addi	sp,sp,32
     d8a:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     d8c:	85ca                	mv	a1,s2
     d8e:	00005517          	auipc	a0,0x5
     d92:	bf250513          	addi	a0,a0,-1038 # 5980 <malloc+0x71a>
     d96:	41c040ef          	jal	51b2 <printf>
    exit(1);
     d9a:	4505                	li	a0,1
     d9c:	7df030ef          	jal	4d7a <exit>
    printf("%s: write lf1 failed\n", s);
     da0:	85ca                	mv	a1,s2
     da2:	00005517          	auipc	a0,0x5
     da6:	bf650513          	addi	a0,a0,-1034 # 5998 <malloc+0x732>
     daa:	408040ef          	jal	51b2 <printf>
    exit(1);
     dae:	4505                	li	a0,1
     db0:	7cb030ef          	jal	4d7a <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     db4:	85ca                	mv	a1,s2
     db6:	00005517          	auipc	a0,0x5
     dba:	bfa50513          	addi	a0,a0,-1030 # 59b0 <malloc+0x74a>
     dbe:	3f4040ef          	jal	51b2 <printf>
    exit(1);
     dc2:	4505                	li	a0,1
     dc4:	7b7030ef          	jal	4d7a <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     dc8:	85ca                	mv	a1,s2
     dca:	00005517          	auipc	a0,0x5
     dce:	c0650513          	addi	a0,a0,-1018 # 59d0 <malloc+0x76a>
     dd2:	3e0040ef          	jal	51b2 <printf>
    exit(1);
     dd6:	4505                	li	a0,1
     dd8:	7a3030ef          	jal	4d7a <exit>
    printf("%s: open lf2 failed\n", s);
     ddc:	85ca                	mv	a1,s2
     dde:	00005517          	auipc	a0,0x5
     de2:	c2250513          	addi	a0,a0,-990 # 5a00 <malloc+0x79a>
     de6:	3cc040ef          	jal	51b2 <printf>
    exit(1);
     dea:	4505                	li	a0,1
     dec:	78f030ef          	jal	4d7a <exit>
    printf("%s: read lf2 failed\n", s);
     df0:	85ca                	mv	a1,s2
     df2:	00005517          	auipc	a0,0x5
     df6:	c2650513          	addi	a0,a0,-986 # 5a18 <malloc+0x7b2>
     dfa:	3b8040ef          	jal	51b2 <printf>
    exit(1);
     dfe:	4505                	li	a0,1
     e00:	77b030ef          	jal	4d7a <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e04:	85ca                	mv	a1,s2
     e06:	00005517          	auipc	a0,0x5
     e0a:	c2a50513          	addi	a0,a0,-982 # 5a30 <malloc+0x7ca>
     e0e:	3a4040ef          	jal	51b2 <printf>
    exit(1);
     e12:	4505                	li	a0,1
     e14:	767030ef          	jal	4d7a <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e18:	85ca                	mv	a1,s2
     e1a:	00005517          	auipc	a0,0x5
     e1e:	c3e50513          	addi	a0,a0,-962 # 5a58 <malloc+0x7f2>
     e22:	390040ef          	jal	51b2 <printf>
    exit(1);
     e26:	4505                	li	a0,1
     e28:	753030ef          	jal	4d7a <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e2c:	85ca                	mv	a1,s2
     e2e:	00005517          	auipc	a0,0x5
     e32:	c5a50513          	addi	a0,a0,-934 # 5a88 <malloc+0x822>
     e36:	37c040ef          	jal	51b2 <printf>
    exit(1);
     e3a:	4505                	li	a0,1
     e3c:	73f030ef          	jal	4d7a <exit>

0000000000000e40 <validatetest>:
{
     e40:	7139                	addi	sp,sp,-64
     e42:	fc06                	sd	ra,56(sp)
     e44:	f822                	sd	s0,48(sp)
     e46:	f426                	sd	s1,40(sp)
     e48:	f04a                	sd	s2,32(sp)
     e4a:	ec4e                	sd	s3,24(sp)
     e4c:	e852                	sd	s4,16(sp)
     e4e:	e456                	sd	s5,8(sp)
     e50:	e05a                	sd	s6,0(sp)
     e52:	0080                	addi	s0,sp,64
     e54:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e56:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     e58:	00005997          	auipc	s3,0x5
     e5c:	c5098993          	addi	s3,s3,-944 # 5aa8 <malloc+0x842>
     e60:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e62:	6a85                	lui	s5,0x1
     e64:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     e68:	85a6                	mv	a1,s1
     e6a:	854e                	mv	a0,s3
     e6c:	76f030ef          	jal	4dda <link>
     e70:	01251f63          	bne	a0,s2,e8e <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e74:	94d6                	add	s1,s1,s5
     e76:	ff4499e3          	bne	s1,s4,e68 <validatetest+0x28>
}
     e7a:	70e2                	ld	ra,56(sp)
     e7c:	7442                	ld	s0,48(sp)
     e7e:	74a2                	ld	s1,40(sp)
     e80:	7902                	ld	s2,32(sp)
     e82:	69e2                	ld	s3,24(sp)
     e84:	6a42                	ld	s4,16(sp)
     e86:	6aa2                	ld	s5,8(sp)
     e88:	6b02                	ld	s6,0(sp)
     e8a:	6121                	addi	sp,sp,64
     e8c:	8082                	ret
      printf("%s: link should not succeed\n", s);
     e8e:	85da                	mv	a1,s6
     e90:	00005517          	auipc	a0,0x5
     e94:	c2850513          	addi	a0,a0,-984 # 5ab8 <malloc+0x852>
     e98:	31a040ef          	jal	51b2 <printf>
      exit(1);
     e9c:	4505                	li	a0,1
     e9e:	6dd030ef          	jal	4d7a <exit>

0000000000000ea2 <bigdir>:
{
     ea2:	715d                	addi	sp,sp,-80
     ea4:	e486                	sd	ra,72(sp)
     ea6:	e0a2                	sd	s0,64(sp)
     ea8:	fc26                	sd	s1,56(sp)
     eaa:	f84a                	sd	s2,48(sp)
     eac:	f44e                	sd	s3,40(sp)
     eae:	f052                	sd	s4,32(sp)
     eb0:	ec56                	sd	s5,24(sp)
     eb2:	e85a                	sd	s6,16(sp)
     eb4:	0880                	addi	s0,sp,80
     eb6:	89aa                	mv	s3,a0
  unlink("bd");
     eb8:	00005517          	auipc	a0,0x5
     ebc:	c2050513          	addi	a0,a0,-992 # 5ad8 <malloc+0x872>
     ec0:	70b030ef          	jal	4dca <unlink>
  fd = open("bd", O_CREATE);
     ec4:	20000593          	li	a1,512
     ec8:	00005517          	auipc	a0,0x5
     ecc:	c1050513          	addi	a0,a0,-1008 # 5ad8 <malloc+0x872>
     ed0:	6eb030ef          	jal	4dba <open>
  if(fd < 0){
     ed4:	0c054163          	bltz	a0,f96 <bigdir+0xf4>
  close(fd);
     ed8:	6cb030ef          	jal	4da2 <close>
  for(i = 0; i < N; i++){
     edc:	4901                	li	s2,0
    name[0] = 'x';
     ede:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     ee2:	00005a17          	auipc	s4,0x5
     ee6:	bf6a0a13          	addi	s4,s4,-1034 # 5ad8 <malloc+0x872>
  for(i = 0; i < N; i++){
     eea:	1f400b13          	li	s6,500
    name[0] = 'x';
     eee:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     ef2:	41f9571b          	sraiw	a4,s2,0x1f
     ef6:	01a7571b          	srliw	a4,a4,0x1a
     efa:	012707bb          	addw	a5,a4,s2
     efe:	4067d69b          	sraiw	a3,a5,0x6
     f02:	0306869b          	addiw	a3,a3,48
     f06:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f0a:	03f7f793          	andi	a5,a5,63
     f0e:	9f99                	subw	a5,a5,a4
     f10:	0307879b          	addiw	a5,a5,48
     f14:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f18:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     f1c:	fb040593          	addi	a1,s0,-80
     f20:	8552                	mv	a0,s4
     f22:	6b9030ef          	jal	4dda <link>
     f26:	84aa                	mv	s1,a0
     f28:	e149                	bnez	a0,faa <bigdir+0x108>
  for(i = 0; i < N; i++){
     f2a:	2905                	addiw	s2,s2,1
     f2c:	fd6911e3          	bne	s2,s6,eee <bigdir+0x4c>
  unlink("bd");
     f30:	00005517          	auipc	a0,0x5
     f34:	ba850513          	addi	a0,a0,-1112 # 5ad8 <malloc+0x872>
     f38:	693030ef          	jal	4dca <unlink>
    name[0] = 'x';
     f3c:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
     f40:	1f400a13          	li	s4,500
    name[0] = 'x';
     f44:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f48:	41f4d71b          	sraiw	a4,s1,0x1f
     f4c:	01a7571b          	srliw	a4,a4,0x1a
     f50:	009707bb          	addw	a5,a4,s1
     f54:	4067d69b          	sraiw	a3,a5,0x6
     f58:	0306869b          	addiw	a3,a3,48
     f5c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f60:	03f7f793          	andi	a5,a5,63
     f64:	9f99                	subw	a5,a5,a4
     f66:	0307879b          	addiw	a5,a5,48
     f6a:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f6e:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
     f72:	fb040513          	addi	a0,s0,-80
     f76:	655030ef          	jal	4dca <unlink>
     f7a:	e529                	bnez	a0,fc4 <bigdir+0x122>
  for(i = 0; i < N; i++){
     f7c:	2485                	addiw	s1,s1,1
     f7e:	fd4493e3          	bne	s1,s4,f44 <bigdir+0xa2>
}
     f82:	60a6                	ld	ra,72(sp)
     f84:	6406                	ld	s0,64(sp)
     f86:	74e2                	ld	s1,56(sp)
     f88:	7942                	ld	s2,48(sp)
     f8a:	79a2                	ld	s3,40(sp)
     f8c:	7a02                	ld	s4,32(sp)
     f8e:	6ae2                	ld	s5,24(sp)
     f90:	6b42                	ld	s6,16(sp)
     f92:	6161                	addi	sp,sp,80
     f94:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     f96:	85ce                	mv	a1,s3
     f98:	00005517          	auipc	a0,0x5
     f9c:	b4850513          	addi	a0,a0,-1208 # 5ae0 <malloc+0x87a>
     fa0:	212040ef          	jal	51b2 <printf>
    exit(1);
     fa4:	4505                	li	a0,1
     fa6:	5d5030ef          	jal	4d7a <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     faa:	fb040693          	addi	a3,s0,-80
     fae:	864a                	mv	a2,s2
     fb0:	85ce                	mv	a1,s3
     fb2:	00005517          	auipc	a0,0x5
     fb6:	b4e50513          	addi	a0,a0,-1202 # 5b00 <malloc+0x89a>
     fba:	1f8040ef          	jal	51b2 <printf>
      exit(1);
     fbe:	4505                	li	a0,1
     fc0:	5bb030ef          	jal	4d7a <exit>
      printf("%s: bigdir unlink failed", s);
     fc4:	85ce                	mv	a1,s3
     fc6:	00005517          	auipc	a0,0x5
     fca:	b6250513          	addi	a0,a0,-1182 # 5b28 <malloc+0x8c2>
     fce:	1e4040ef          	jal	51b2 <printf>
      exit(1);
     fd2:	4505                	li	a0,1
     fd4:	5a7030ef          	jal	4d7a <exit>

0000000000000fd8 <pgbug>:
{
     fd8:	7179                	addi	sp,sp,-48
     fda:	f406                	sd	ra,40(sp)
     fdc:	f022                	sd	s0,32(sp)
     fde:	ec26                	sd	s1,24(sp)
     fe0:	1800                	addi	s0,sp,48
  argv[0] = 0;
     fe2:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     fe6:	00007497          	auipc	s1,0x7
     fea:	01a48493          	addi	s1,s1,26 # 8000 <big>
     fee:	fd840593          	addi	a1,s0,-40
     ff2:	6088                	ld	a0,0(s1)
     ff4:	5bf030ef          	jal	4db2 <exec>
  pipe(big);
     ff8:	6088                	ld	a0,0(s1)
     ffa:	591030ef          	jal	4d8a <pipe>
  exit(0);
     ffe:	4501                	li	a0,0
    1000:	57b030ef          	jal	4d7a <exit>

0000000000001004 <badarg>:
{
    1004:	7139                	addi	sp,sp,-64
    1006:	fc06                	sd	ra,56(sp)
    1008:	f822                	sd	s0,48(sp)
    100a:	f426                	sd	s1,40(sp)
    100c:	f04a                	sd	s2,32(sp)
    100e:	ec4e                	sd	s3,24(sp)
    1010:	0080                	addi	s0,sp,64
    1012:	64b1                	lui	s1,0xc
    1014:	35048493          	addi	s1,s1,848 # c350 <buf+0x698>
    argv[0] = (char*)0xffffffff;
    1018:	597d                	li	s2,-1
    101a:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    101e:	00004997          	auipc	s3,0x4
    1022:	37a98993          	addi	s3,s3,890 # 5398 <malloc+0x132>
    argv[0] = (char*)0xffffffff;
    1026:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    102a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    102e:	fc040593          	addi	a1,s0,-64
    1032:	854e                	mv	a0,s3
    1034:	57f030ef          	jal	4db2 <exec>
  for(int i = 0; i < 50000; i++){
    1038:	34fd                	addiw	s1,s1,-1
    103a:	f4f5                	bnez	s1,1026 <badarg+0x22>
  exit(0);
    103c:	4501                	li	a0,0
    103e:	53d030ef          	jal	4d7a <exit>

0000000000001042 <copyinstr2>:
{
    1042:	7155                	addi	sp,sp,-208
    1044:	e586                	sd	ra,200(sp)
    1046:	e1a2                	sd	s0,192(sp)
    1048:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    104a:	f6840793          	addi	a5,s0,-152
    104e:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    1052:	07800713          	li	a4,120
    1056:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    105a:	0785                	addi	a5,a5,1
    105c:	fed79de3          	bne	a5,a3,1056 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    1060:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1064:	f6840513          	addi	a0,s0,-152
    1068:	563030ef          	jal	4dca <unlink>
  if(ret != -1){
    106c:	57fd                	li	a5,-1
    106e:	0cf51263          	bne	a0,a5,1132 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    1072:	20100593          	li	a1,513
    1076:	f6840513          	addi	a0,s0,-152
    107a:	541030ef          	jal	4dba <open>
  if(fd != -1){
    107e:	57fd                	li	a5,-1
    1080:	0cf51563          	bne	a0,a5,114a <copyinstr2+0x108>
  ret = link(b, b);
    1084:	f6840593          	addi	a1,s0,-152
    1088:	852e                	mv	a0,a1
    108a:	551030ef          	jal	4dda <link>
  if(ret != -1){
    108e:	57fd                	li	a5,-1
    1090:	0cf51963          	bne	a0,a5,1162 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    1094:	00006797          	auipc	a5,0x6
    1098:	be478793          	addi	a5,a5,-1052 # 6c78 <malloc+0x1a12>
    109c:	f4f43c23          	sd	a5,-168(s0)
    10a0:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10a4:	f5840593          	addi	a1,s0,-168
    10a8:	f6840513          	addi	a0,s0,-152
    10ac:	507030ef          	jal	4db2 <exec>
  if(ret != -1){
    10b0:	57fd                	li	a5,-1
    10b2:	0cf51563          	bne	a0,a5,117c <copyinstr2+0x13a>
  int pid = fork();
    10b6:	4bd030ef          	jal	4d72 <fork>
  if(pid < 0){
    10ba:	0c054d63          	bltz	a0,1194 <copyinstr2+0x152>
  if(pid == 0){
    10be:	0e051863          	bnez	a0,11ae <copyinstr2+0x16c>
    10c2:	00007797          	auipc	a5,0x7
    10c6:	4de78793          	addi	a5,a5,1246 # 85a0 <big.0>
    10ca:	00008697          	auipc	a3,0x8
    10ce:	4d668693          	addi	a3,a3,1238 # 95a0 <big.0+0x1000>
      big[i] = 'x';
    10d2:	07800713          	li	a4,120
    10d6:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    10da:	0785                	addi	a5,a5,1
    10dc:	fed79de3          	bne	a5,a3,10d6 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    10e0:	00008797          	auipc	a5,0x8
    10e4:	4c078023          	sb	zero,1216(a5) # 95a0 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    10e8:	00006797          	auipc	a5,0x6
    10ec:	7f878793          	addi	a5,a5,2040 # 78e0 <malloc+0x267a>
    10f0:	6fb0                	ld	a2,88(a5)
    10f2:	73b4                	ld	a3,96(a5)
    10f4:	77b8                	ld	a4,104(a5)
    10f6:	7bbc                	ld	a5,112(a5)
    10f8:	f2c43823          	sd	a2,-208(s0)
    10fc:	f2d43c23          	sd	a3,-200(s0)
    1100:	f4e43023          	sd	a4,-192(s0)
    1104:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1108:	f3040593          	addi	a1,s0,-208
    110c:	00004517          	auipc	a0,0x4
    1110:	28c50513          	addi	a0,a0,652 # 5398 <malloc+0x132>
    1114:	49f030ef          	jal	4db2 <exec>
    if(ret != -1){
    1118:	57fd                	li	a5,-1
    111a:	08f50663          	beq	a0,a5,11a6 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    111e:	55fd                	li	a1,-1
    1120:	00005517          	auipc	a0,0x5
    1124:	ab050513          	addi	a0,a0,-1360 # 5bd0 <malloc+0x96a>
    1128:	08a040ef          	jal	51b2 <printf>
      exit(1);
    112c:	4505                	li	a0,1
    112e:	44d030ef          	jal	4d7a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1132:	862a                	mv	a2,a0
    1134:	f6840593          	addi	a1,s0,-152
    1138:	00005517          	auipc	a0,0x5
    113c:	a1050513          	addi	a0,a0,-1520 # 5b48 <malloc+0x8e2>
    1140:	072040ef          	jal	51b2 <printf>
    exit(1);
    1144:	4505                	li	a0,1
    1146:	435030ef          	jal	4d7a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    114a:	862a                	mv	a2,a0
    114c:	f6840593          	addi	a1,s0,-152
    1150:	00005517          	auipc	a0,0x5
    1154:	a1850513          	addi	a0,a0,-1512 # 5b68 <malloc+0x902>
    1158:	05a040ef          	jal	51b2 <printf>
    exit(1);
    115c:	4505                	li	a0,1
    115e:	41d030ef          	jal	4d7a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1162:	86aa                	mv	a3,a0
    1164:	f6840613          	addi	a2,s0,-152
    1168:	85b2                	mv	a1,a2
    116a:	00005517          	auipc	a0,0x5
    116e:	a1e50513          	addi	a0,a0,-1506 # 5b88 <malloc+0x922>
    1172:	040040ef          	jal	51b2 <printf>
    exit(1);
    1176:	4505                	li	a0,1
    1178:	403030ef          	jal	4d7a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    117c:	567d                	li	a2,-1
    117e:	f6840593          	addi	a1,s0,-152
    1182:	00005517          	auipc	a0,0x5
    1186:	a2e50513          	addi	a0,a0,-1490 # 5bb0 <malloc+0x94a>
    118a:	028040ef          	jal	51b2 <printf>
    exit(1);
    118e:	4505                	li	a0,1
    1190:	3eb030ef          	jal	4d7a <exit>
    printf("fork failed\n");
    1194:	00006517          	auipc	a0,0x6
    1198:	03c50513          	addi	a0,a0,60 # 71d0 <malloc+0x1f6a>
    119c:	016040ef          	jal	51b2 <printf>
    exit(1);
    11a0:	4505                	li	a0,1
    11a2:	3d9030ef          	jal	4d7a <exit>
    exit(747); // OK
    11a6:	2eb00513          	li	a0,747
    11aa:	3d1030ef          	jal	4d7a <exit>
  int st = 0;
    11ae:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    11b2:	f5440513          	addi	a0,s0,-172
    11b6:	3cd030ef          	jal	4d82 <wait>
  if(st != 747){
    11ba:	f5442703          	lw	a4,-172(s0)
    11be:	2eb00793          	li	a5,747
    11c2:	00f71663          	bne	a4,a5,11ce <copyinstr2+0x18c>
}
    11c6:	60ae                	ld	ra,200(sp)
    11c8:	640e                	ld	s0,192(sp)
    11ca:	6169                	addi	sp,sp,208
    11cc:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    11ce:	00005517          	auipc	a0,0x5
    11d2:	a2a50513          	addi	a0,a0,-1494 # 5bf8 <malloc+0x992>
    11d6:	7dd030ef          	jal	51b2 <printf>
    exit(1);
    11da:	4505                	li	a0,1
    11dc:	39f030ef          	jal	4d7a <exit>

00000000000011e0 <truncate3>:
{
    11e0:	7159                	addi	sp,sp,-112
    11e2:	f486                	sd	ra,104(sp)
    11e4:	f0a2                	sd	s0,96(sp)
    11e6:	e8ca                	sd	s2,80(sp)
    11e8:	1880                	addi	s0,sp,112
    11ea:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    11ec:	60100593          	li	a1,1537
    11f0:	00004517          	auipc	a0,0x4
    11f4:	20050513          	addi	a0,a0,512 # 53f0 <malloc+0x18a>
    11f8:	3c3030ef          	jal	4dba <open>
    11fc:	3a7030ef          	jal	4da2 <close>
  pid = fork();
    1200:	373030ef          	jal	4d72 <fork>
  if(pid < 0){
    1204:	06054663          	bltz	a0,1270 <truncate3+0x90>
  if(pid == 0){
    1208:	e55d                	bnez	a0,12b6 <truncate3+0xd6>
    120a:	eca6                	sd	s1,88(sp)
    120c:	e4ce                	sd	s3,72(sp)
    120e:	e0d2                	sd	s4,64(sp)
    1210:	fc56                	sd	s5,56(sp)
    1212:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1216:	00004a17          	auipc	s4,0x4
    121a:	1daa0a13          	addi	s4,s4,474 # 53f0 <malloc+0x18a>
      int n = write(fd, "1234567890", 10);
    121e:	00005a97          	auipc	s5,0x5
    1222:	a3aa8a93          	addi	s5,s5,-1478 # 5c58 <malloc+0x9f2>
      int fd = open("truncfile", O_WRONLY);
    1226:	4585                	li	a1,1
    1228:	8552                	mv	a0,s4
    122a:	391030ef          	jal	4dba <open>
    122e:	84aa                	mv	s1,a0
      if(fd < 0){
    1230:	04054e63          	bltz	a0,128c <truncate3+0xac>
      int n = write(fd, "1234567890", 10);
    1234:	4629                	li	a2,10
    1236:	85d6                	mv	a1,s5
    1238:	363030ef          	jal	4d9a <write>
      if(n != 10){
    123c:	47a9                	li	a5,10
    123e:	06f51163          	bne	a0,a5,12a0 <truncate3+0xc0>
      close(fd);
    1242:	8526                	mv	a0,s1
    1244:	35f030ef          	jal	4da2 <close>
      fd = open("truncfile", O_RDONLY);
    1248:	4581                	li	a1,0
    124a:	8552                	mv	a0,s4
    124c:	36f030ef          	jal	4dba <open>
    1250:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1252:	02000613          	li	a2,32
    1256:	f9840593          	addi	a1,s0,-104
    125a:	339030ef          	jal	4d92 <read>
      close(fd);
    125e:	8526                	mv	a0,s1
    1260:	343030ef          	jal	4da2 <close>
    for(int i = 0; i < 100; i++){
    1264:	39fd                	addiw	s3,s3,-1
    1266:	fc0990e3          	bnez	s3,1226 <truncate3+0x46>
    exit(0);
    126a:	4501                	li	a0,0
    126c:	30f030ef          	jal	4d7a <exit>
    1270:	eca6                	sd	s1,88(sp)
    1272:	e4ce                	sd	s3,72(sp)
    1274:	e0d2                	sd	s4,64(sp)
    1276:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1278:	85ca                	mv	a1,s2
    127a:	00005517          	auipc	a0,0x5
    127e:	9ae50513          	addi	a0,a0,-1618 # 5c28 <malloc+0x9c2>
    1282:	731030ef          	jal	51b2 <printf>
    exit(1);
    1286:	4505                	li	a0,1
    1288:	2f3030ef          	jal	4d7a <exit>
        printf("%s: open failed\n", s);
    128c:	85ca                	mv	a1,s2
    128e:	00005517          	auipc	a0,0x5
    1292:	9b250513          	addi	a0,a0,-1614 # 5c40 <malloc+0x9da>
    1296:	71d030ef          	jal	51b2 <printf>
        exit(1);
    129a:	4505                	li	a0,1
    129c:	2df030ef          	jal	4d7a <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    12a0:	862a                	mv	a2,a0
    12a2:	85ca                	mv	a1,s2
    12a4:	00005517          	auipc	a0,0x5
    12a8:	9c450513          	addi	a0,a0,-1596 # 5c68 <malloc+0xa02>
    12ac:	707030ef          	jal	51b2 <printf>
        exit(1);
    12b0:	4505                	li	a0,1
    12b2:	2c9030ef          	jal	4d7a <exit>
    12b6:	eca6                	sd	s1,88(sp)
    12b8:	e4ce                	sd	s3,72(sp)
    12ba:	e0d2                	sd	s4,64(sp)
    12bc:	fc56                	sd	s5,56(sp)
    12be:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12c2:	00004a17          	auipc	s4,0x4
    12c6:	12ea0a13          	addi	s4,s4,302 # 53f0 <malloc+0x18a>
    int n = write(fd, "xxx", 3);
    12ca:	00005a97          	auipc	s5,0x5
    12ce:	9bea8a93          	addi	s5,s5,-1602 # 5c88 <malloc+0xa22>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12d2:	60100593          	li	a1,1537
    12d6:	8552                	mv	a0,s4
    12d8:	2e3030ef          	jal	4dba <open>
    12dc:	84aa                	mv	s1,a0
    if(fd < 0){
    12de:	02054d63          	bltz	a0,1318 <truncate3+0x138>
    int n = write(fd, "xxx", 3);
    12e2:	460d                	li	a2,3
    12e4:	85d6                	mv	a1,s5
    12e6:	2b5030ef          	jal	4d9a <write>
    if(n != 3){
    12ea:	478d                	li	a5,3
    12ec:	04f51063          	bne	a0,a5,132c <truncate3+0x14c>
    close(fd);
    12f0:	8526                	mv	a0,s1
    12f2:	2b1030ef          	jal	4da2 <close>
  for(int i = 0; i < 150; i++){
    12f6:	39fd                	addiw	s3,s3,-1
    12f8:	fc099de3          	bnez	s3,12d2 <truncate3+0xf2>
  wait(&xstatus);
    12fc:	fbc40513          	addi	a0,s0,-68
    1300:	283030ef          	jal	4d82 <wait>
  unlink("truncfile");
    1304:	00004517          	auipc	a0,0x4
    1308:	0ec50513          	addi	a0,a0,236 # 53f0 <malloc+0x18a>
    130c:	2bf030ef          	jal	4dca <unlink>
  exit(xstatus);
    1310:	fbc42503          	lw	a0,-68(s0)
    1314:	267030ef          	jal	4d7a <exit>
      printf("%s: open failed\n", s);
    1318:	85ca                	mv	a1,s2
    131a:	00005517          	auipc	a0,0x5
    131e:	92650513          	addi	a0,a0,-1754 # 5c40 <malloc+0x9da>
    1322:	691030ef          	jal	51b2 <printf>
      exit(1);
    1326:	4505                	li	a0,1
    1328:	253030ef          	jal	4d7a <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    132c:	862a                	mv	a2,a0
    132e:	85ca                	mv	a1,s2
    1330:	00005517          	auipc	a0,0x5
    1334:	96050513          	addi	a0,a0,-1696 # 5c90 <malloc+0xa2a>
    1338:	67b030ef          	jal	51b2 <printf>
      exit(1);
    133c:	4505                	li	a0,1
    133e:	23d030ef          	jal	4d7a <exit>

0000000000001342 <exectest>:
{
    1342:	715d                	addi	sp,sp,-80
    1344:	e486                	sd	ra,72(sp)
    1346:	e0a2                	sd	s0,64(sp)
    1348:	f84a                	sd	s2,48(sp)
    134a:	0880                	addi	s0,sp,80
    134c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    134e:	00004797          	auipc	a5,0x4
    1352:	04a78793          	addi	a5,a5,74 # 5398 <malloc+0x132>
    1356:	fcf43023          	sd	a5,-64(s0)
    135a:	00005797          	auipc	a5,0x5
    135e:	95678793          	addi	a5,a5,-1706 # 5cb0 <malloc+0xa4a>
    1362:	fcf43423          	sd	a5,-56(s0)
    1366:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    136a:	00005517          	auipc	a0,0x5
    136e:	94e50513          	addi	a0,a0,-1714 # 5cb8 <malloc+0xa52>
    1372:	259030ef          	jal	4dca <unlink>
  pid = fork();
    1376:	1fd030ef          	jal	4d72 <fork>
  if(pid < 0) {
    137a:	02054f63          	bltz	a0,13b8 <exectest+0x76>
    137e:	fc26                	sd	s1,56(sp)
    1380:	84aa                	mv	s1,a0
  if(pid == 0) {
    1382:	e935                	bnez	a0,13f6 <exectest+0xb4>
    close(1);
    1384:	4505                	li	a0,1
    1386:	21d030ef          	jal	4da2 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    138a:	20100593          	li	a1,513
    138e:	00005517          	auipc	a0,0x5
    1392:	92a50513          	addi	a0,a0,-1750 # 5cb8 <malloc+0xa52>
    1396:	225030ef          	jal	4dba <open>
    if(fd < 0) {
    139a:	02054a63          	bltz	a0,13ce <exectest+0x8c>
    if(fd != 1) {
    139e:	4785                	li	a5,1
    13a0:	04f50163          	beq	a0,a5,13e2 <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    13a4:	85ca                	mv	a1,s2
    13a6:	00005517          	auipc	a0,0x5
    13aa:	93250513          	addi	a0,a0,-1742 # 5cd8 <malloc+0xa72>
    13ae:	605030ef          	jal	51b2 <printf>
      exit(1);
    13b2:	4505                	li	a0,1
    13b4:	1c7030ef          	jal	4d7a <exit>
    13b8:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    13ba:	85ca                	mv	a1,s2
    13bc:	00005517          	auipc	a0,0x5
    13c0:	86c50513          	addi	a0,a0,-1940 # 5c28 <malloc+0x9c2>
    13c4:	5ef030ef          	jal	51b2 <printf>
     exit(1);
    13c8:	4505                	li	a0,1
    13ca:	1b1030ef          	jal	4d7a <exit>
      printf("%s: create failed\n", s);
    13ce:	85ca                	mv	a1,s2
    13d0:	00005517          	auipc	a0,0x5
    13d4:	8f050513          	addi	a0,a0,-1808 # 5cc0 <malloc+0xa5a>
    13d8:	5db030ef          	jal	51b2 <printf>
      exit(1);
    13dc:	4505                	li	a0,1
    13de:	19d030ef          	jal	4d7a <exit>
    if(exec("echo", echoargv) < 0){
    13e2:	fc040593          	addi	a1,s0,-64
    13e6:	00004517          	auipc	a0,0x4
    13ea:	fb250513          	addi	a0,a0,-78 # 5398 <malloc+0x132>
    13ee:	1c5030ef          	jal	4db2 <exec>
    13f2:	00054d63          	bltz	a0,140c <exectest+0xca>
  if (wait(&xstatus) != pid) {
    13f6:	fdc40513          	addi	a0,s0,-36
    13fa:	189030ef          	jal	4d82 <wait>
    13fe:	02951163          	bne	a0,s1,1420 <exectest+0xde>
  if(xstatus != 0)
    1402:	fdc42503          	lw	a0,-36(s0)
    1406:	c50d                	beqz	a0,1430 <exectest+0xee>
    exit(xstatus);
    1408:	173030ef          	jal	4d7a <exit>
      printf("%s: exec echo failed\n", s);
    140c:	85ca                	mv	a1,s2
    140e:	00005517          	auipc	a0,0x5
    1412:	8da50513          	addi	a0,a0,-1830 # 5ce8 <malloc+0xa82>
    1416:	59d030ef          	jal	51b2 <printf>
      exit(1);
    141a:	4505                	li	a0,1
    141c:	15f030ef          	jal	4d7a <exit>
    printf("%s: wait failed!\n", s);
    1420:	85ca                	mv	a1,s2
    1422:	00005517          	auipc	a0,0x5
    1426:	8de50513          	addi	a0,a0,-1826 # 5d00 <malloc+0xa9a>
    142a:	589030ef          	jal	51b2 <printf>
    142e:	bfd1                	j	1402 <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    1430:	4581                	li	a1,0
    1432:	00005517          	auipc	a0,0x5
    1436:	88650513          	addi	a0,a0,-1914 # 5cb8 <malloc+0xa52>
    143a:	181030ef          	jal	4dba <open>
  if(fd < 0) {
    143e:	02054463          	bltz	a0,1466 <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    1442:	4609                	li	a2,2
    1444:	fb840593          	addi	a1,s0,-72
    1448:	14b030ef          	jal	4d92 <read>
    144c:	4789                	li	a5,2
    144e:	02f50663          	beq	a0,a5,147a <exectest+0x138>
    printf("%s: read failed\n", s);
    1452:	85ca                	mv	a1,s2
    1454:	00004517          	auipc	a0,0x4
    1458:	31450513          	addi	a0,a0,788 # 5768 <malloc+0x502>
    145c:	557030ef          	jal	51b2 <printf>
    exit(1);
    1460:	4505                	li	a0,1
    1462:	119030ef          	jal	4d7a <exit>
    printf("%s: open failed\n", s);
    1466:	85ca                	mv	a1,s2
    1468:	00004517          	auipc	a0,0x4
    146c:	7d850513          	addi	a0,a0,2008 # 5c40 <malloc+0x9da>
    1470:	543030ef          	jal	51b2 <printf>
    exit(1);
    1474:	4505                	li	a0,1
    1476:	105030ef          	jal	4d7a <exit>
  unlink("echo-ok");
    147a:	00005517          	auipc	a0,0x5
    147e:	83e50513          	addi	a0,a0,-1986 # 5cb8 <malloc+0xa52>
    1482:	149030ef          	jal	4dca <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1486:	fb844703          	lbu	a4,-72(s0)
    148a:	04f00793          	li	a5,79
    148e:	00f71863          	bne	a4,a5,149e <exectest+0x15c>
    1492:	fb944703          	lbu	a4,-71(s0)
    1496:	04b00793          	li	a5,75
    149a:	00f70c63          	beq	a4,a5,14b2 <exectest+0x170>
    printf("%s: wrong output\n", s);
    149e:	85ca                	mv	a1,s2
    14a0:	00005517          	auipc	a0,0x5
    14a4:	87850513          	addi	a0,a0,-1928 # 5d18 <malloc+0xab2>
    14a8:	50b030ef          	jal	51b2 <printf>
    exit(1);
    14ac:	4505                	li	a0,1
    14ae:	0cd030ef          	jal	4d7a <exit>
    exit(0);
    14b2:	4501                	li	a0,0
    14b4:	0c7030ef          	jal	4d7a <exit>

00000000000014b8 <pipe1>:
{
    14b8:	711d                	addi	sp,sp,-96
    14ba:	ec86                	sd	ra,88(sp)
    14bc:	e8a2                	sd	s0,80(sp)
    14be:	fc4e                	sd	s3,56(sp)
    14c0:	1080                	addi	s0,sp,96
    14c2:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    14c4:	fa840513          	addi	a0,s0,-88
    14c8:	0c3030ef          	jal	4d8a <pipe>
    14cc:	e92d                	bnez	a0,153e <pipe1+0x86>
    14ce:	e4a6                	sd	s1,72(sp)
    14d0:	f852                	sd	s4,48(sp)
    14d2:	84aa                	mv	s1,a0
  pid = fork();
    14d4:	09f030ef          	jal	4d72 <fork>
    14d8:	8a2a                	mv	s4,a0
  if(pid == 0){
    14da:	c151                	beqz	a0,155e <pipe1+0xa6>
  } else if(pid > 0){
    14dc:	14a05e63          	blez	a0,1638 <pipe1+0x180>
    14e0:	e0ca                	sd	s2,64(sp)
    14e2:	f456                	sd	s5,40(sp)
    close(fds[1]);
    14e4:	fac42503          	lw	a0,-84(s0)
    14e8:	0bb030ef          	jal	4da2 <close>
    total = 0;
    14ec:	8a26                	mv	s4,s1
    cc = 1;
    14ee:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    14f0:	0000aa97          	auipc	s5,0xa
    14f4:	7c8a8a93          	addi	s5,s5,1992 # bcb8 <buf>
    14f8:	864a                	mv	a2,s2
    14fa:	85d6                	mv	a1,s5
    14fc:	fa842503          	lw	a0,-88(s0)
    1500:	093030ef          	jal	4d92 <read>
    1504:	0ea05a63          	blez	a0,15f8 <pipe1+0x140>
      for(i = 0; i < n; i++){
    1508:	0000a717          	auipc	a4,0xa
    150c:	7b070713          	addi	a4,a4,1968 # bcb8 <buf>
    1510:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1514:	00074683          	lbu	a3,0(a4)
    1518:	0ff4f793          	zext.b	a5,s1
    151c:	2485                	addiw	s1,s1,1
    151e:	0af69d63          	bne	a3,a5,15d8 <pipe1+0x120>
      for(i = 0; i < n; i++){
    1522:	0705                	addi	a4,a4,1
    1524:	fec498e3          	bne	s1,a2,1514 <pipe1+0x5c>
      total += n;
    1528:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    152c:	0019179b          	slliw	a5,s2,0x1
    1530:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    1534:	670d                	lui	a4,0x3
    1536:	fd2771e3          	bgeu	a4,s2,14f8 <pipe1+0x40>
        cc = sizeof(buf);
    153a:	690d                	lui	s2,0x3
    153c:	bf75                	j	14f8 <pipe1+0x40>
    153e:	e4a6                	sd	s1,72(sp)
    1540:	e0ca                	sd	s2,64(sp)
    1542:	f852                	sd	s4,48(sp)
    1544:	f456                	sd	s5,40(sp)
    1546:	f05a                	sd	s6,32(sp)
    1548:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    154a:	85ce                	mv	a1,s3
    154c:	00004517          	auipc	a0,0x4
    1550:	7e450513          	addi	a0,a0,2020 # 5d30 <malloc+0xaca>
    1554:	45f030ef          	jal	51b2 <printf>
    exit(1);
    1558:	4505                	li	a0,1
    155a:	021030ef          	jal	4d7a <exit>
    155e:	e0ca                	sd	s2,64(sp)
    1560:	f456                	sd	s5,40(sp)
    1562:	f05a                	sd	s6,32(sp)
    1564:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1566:	fa842503          	lw	a0,-88(s0)
    156a:	039030ef          	jal	4da2 <close>
    for(n = 0; n < N; n++){
    156e:	0000ab17          	auipc	s6,0xa
    1572:	74ab0b13          	addi	s6,s6,1866 # bcb8 <buf>
    1576:	416004bb          	negw	s1,s6
    157a:	0ff4f493          	zext.b	s1,s1
    157e:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1582:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1584:	6a85                	lui	s5,0x1
    1586:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0xeb>
{
    158a:	87da                	mv	a5,s6
        buf[i] = seq++;
    158c:	0097873b          	addw	a4,a5,s1
    1590:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1594:	0785                	addi	a5,a5,1
    1596:	ff279be3          	bne	a5,s2,158c <pipe1+0xd4>
    159a:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    159e:	40900613          	li	a2,1033
    15a2:	85de                	mv	a1,s7
    15a4:	fac42503          	lw	a0,-84(s0)
    15a8:	7f2030ef          	jal	4d9a <write>
    15ac:	40900793          	li	a5,1033
    15b0:	00f51a63          	bne	a0,a5,15c4 <pipe1+0x10c>
    for(n = 0; n < N; n++){
    15b4:	24a5                	addiw	s1,s1,9
    15b6:	0ff4f493          	zext.b	s1,s1
    15ba:	fd5a18e3          	bne	s4,s5,158a <pipe1+0xd2>
    exit(0);
    15be:	4501                	li	a0,0
    15c0:	7ba030ef          	jal	4d7a <exit>
        printf("%s: pipe1 oops 1\n", s);
    15c4:	85ce                	mv	a1,s3
    15c6:	00004517          	auipc	a0,0x4
    15ca:	78250513          	addi	a0,a0,1922 # 5d48 <malloc+0xae2>
    15ce:	3e5030ef          	jal	51b2 <printf>
        exit(1);
    15d2:	4505                	li	a0,1
    15d4:	7a6030ef          	jal	4d7a <exit>
          printf("%s: pipe1 oops 2\n", s);
    15d8:	85ce                	mv	a1,s3
    15da:	00004517          	auipc	a0,0x4
    15de:	78650513          	addi	a0,a0,1926 # 5d60 <malloc+0xafa>
    15e2:	3d1030ef          	jal	51b2 <printf>
          return;
    15e6:	64a6                	ld	s1,72(sp)
    15e8:	6906                	ld	s2,64(sp)
    15ea:	7a42                	ld	s4,48(sp)
    15ec:	7aa2                	ld	s5,40(sp)
}
    15ee:	60e6                	ld	ra,88(sp)
    15f0:	6446                	ld	s0,80(sp)
    15f2:	79e2                	ld	s3,56(sp)
    15f4:	6125                	addi	sp,sp,96
    15f6:	8082                	ret
    if(total != N * SZ){
    15f8:	6785                	lui	a5,0x1
    15fa:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0xeb>
    15fe:	00fa0f63          	beq	s4,a5,161c <pipe1+0x164>
    1602:	f05a                	sd	s6,32(sp)
    1604:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1606:	8652                	mv	a2,s4
    1608:	85ce                	mv	a1,s3
    160a:	00004517          	auipc	a0,0x4
    160e:	76e50513          	addi	a0,a0,1902 # 5d78 <malloc+0xb12>
    1612:	3a1030ef          	jal	51b2 <printf>
      exit(1);
    1616:	4505                	li	a0,1
    1618:	762030ef          	jal	4d7a <exit>
    161c:	f05a                	sd	s6,32(sp)
    161e:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1620:	fa842503          	lw	a0,-88(s0)
    1624:	77e030ef          	jal	4da2 <close>
    wait(&xstatus);
    1628:	fa440513          	addi	a0,s0,-92
    162c:	756030ef          	jal	4d82 <wait>
    exit(xstatus);
    1630:	fa442503          	lw	a0,-92(s0)
    1634:	746030ef          	jal	4d7a <exit>
    1638:	e0ca                	sd	s2,64(sp)
    163a:	f456                	sd	s5,40(sp)
    163c:	f05a                	sd	s6,32(sp)
    163e:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1640:	85ce                	mv	a1,s3
    1642:	00004517          	auipc	a0,0x4
    1646:	75650513          	addi	a0,a0,1878 # 5d98 <malloc+0xb32>
    164a:	369030ef          	jal	51b2 <printf>
    exit(1);
    164e:	4505                	li	a0,1
    1650:	72a030ef          	jal	4d7a <exit>

0000000000001654 <exitwait>:
{
    1654:	7139                	addi	sp,sp,-64
    1656:	fc06                	sd	ra,56(sp)
    1658:	f822                	sd	s0,48(sp)
    165a:	f426                	sd	s1,40(sp)
    165c:	f04a                	sd	s2,32(sp)
    165e:	ec4e                	sd	s3,24(sp)
    1660:	e852                	sd	s4,16(sp)
    1662:	0080                	addi	s0,sp,64
    1664:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1666:	4901                	li	s2,0
    1668:	06400993          	li	s3,100
    pid = fork();
    166c:	706030ef          	jal	4d72 <fork>
    1670:	84aa                	mv	s1,a0
    if(pid < 0){
    1672:	02054863          	bltz	a0,16a2 <exitwait+0x4e>
    if(pid){
    1676:	c525                	beqz	a0,16de <exitwait+0x8a>
      if(wait(&xstate) != pid){
    1678:	fcc40513          	addi	a0,s0,-52
    167c:	706030ef          	jal	4d82 <wait>
    1680:	02951b63          	bne	a0,s1,16b6 <exitwait+0x62>
      if(i != xstate) {
    1684:	fcc42783          	lw	a5,-52(s0)
    1688:	05279163          	bne	a5,s2,16ca <exitwait+0x76>
  for(i = 0; i < 100; i++){
    168c:	2905                	addiw	s2,s2,1 # 3001 <subdir+0x439>
    168e:	fd391fe3          	bne	s2,s3,166c <exitwait+0x18>
}
    1692:	70e2                	ld	ra,56(sp)
    1694:	7442                	ld	s0,48(sp)
    1696:	74a2                	ld	s1,40(sp)
    1698:	7902                	ld	s2,32(sp)
    169a:	69e2                	ld	s3,24(sp)
    169c:	6a42                	ld	s4,16(sp)
    169e:	6121                	addi	sp,sp,64
    16a0:	8082                	ret
      printf("%s: fork failed\n", s);
    16a2:	85d2                	mv	a1,s4
    16a4:	00004517          	auipc	a0,0x4
    16a8:	58450513          	addi	a0,a0,1412 # 5c28 <malloc+0x9c2>
    16ac:	307030ef          	jal	51b2 <printf>
      exit(1);
    16b0:	4505                	li	a0,1
    16b2:	6c8030ef          	jal	4d7a <exit>
        printf("%s: wait wrong pid\n", s);
    16b6:	85d2                	mv	a1,s4
    16b8:	00004517          	auipc	a0,0x4
    16bc:	6f850513          	addi	a0,a0,1784 # 5db0 <malloc+0xb4a>
    16c0:	2f3030ef          	jal	51b2 <printf>
        exit(1);
    16c4:	4505                	li	a0,1
    16c6:	6b4030ef          	jal	4d7a <exit>
        printf("%s: wait wrong exit status\n", s);
    16ca:	85d2                	mv	a1,s4
    16cc:	00004517          	auipc	a0,0x4
    16d0:	6fc50513          	addi	a0,a0,1788 # 5dc8 <malloc+0xb62>
    16d4:	2df030ef          	jal	51b2 <printf>
        exit(1);
    16d8:	4505                	li	a0,1
    16da:	6a0030ef          	jal	4d7a <exit>
      exit(i);
    16de:	854a                	mv	a0,s2
    16e0:	69a030ef          	jal	4d7a <exit>

00000000000016e4 <twochildren>:
{
    16e4:	1101                	addi	sp,sp,-32
    16e6:	ec06                	sd	ra,24(sp)
    16e8:	e822                	sd	s0,16(sp)
    16ea:	e426                	sd	s1,8(sp)
    16ec:	e04a                	sd	s2,0(sp)
    16ee:	1000                	addi	s0,sp,32
    16f0:	892a                	mv	s2,a0
    16f2:	3e800493          	li	s1,1000
    int pid1 = fork();
    16f6:	67c030ef          	jal	4d72 <fork>
    if(pid1 < 0){
    16fa:	02054663          	bltz	a0,1726 <twochildren+0x42>
    if(pid1 == 0){
    16fe:	cd15                	beqz	a0,173a <twochildren+0x56>
      int pid2 = fork();
    1700:	672030ef          	jal	4d72 <fork>
      if(pid2 < 0){
    1704:	02054d63          	bltz	a0,173e <twochildren+0x5a>
      if(pid2 == 0){
    1708:	c529                	beqz	a0,1752 <twochildren+0x6e>
        wait(0);
    170a:	4501                	li	a0,0
    170c:	676030ef          	jal	4d82 <wait>
        wait(0);
    1710:	4501                	li	a0,0
    1712:	670030ef          	jal	4d82 <wait>
  for(int i = 0; i < 1000; i++){
    1716:	34fd                	addiw	s1,s1,-1
    1718:	fcf9                	bnez	s1,16f6 <twochildren+0x12>
}
    171a:	60e2                	ld	ra,24(sp)
    171c:	6442                	ld	s0,16(sp)
    171e:	64a2                	ld	s1,8(sp)
    1720:	6902                	ld	s2,0(sp)
    1722:	6105                	addi	sp,sp,32
    1724:	8082                	ret
      printf("%s: fork failed\n", s);
    1726:	85ca                	mv	a1,s2
    1728:	00004517          	auipc	a0,0x4
    172c:	50050513          	addi	a0,a0,1280 # 5c28 <malloc+0x9c2>
    1730:	283030ef          	jal	51b2 <printf>
      exit(1);
    1734:	4505                	li	a0,1
    1736:	644030ef          	jal	4d7a <exit>
      exit(0);
    173a:	640030ef          	jal	4d7a <exit>
        printf("%s: fork failed\n", s);
    173e:	85ca                	mv	a1,s2
    1740:	00004517          	auipc	a0,0x4
    1744:	4e850513          	addi	a0,a0,1256 # 5c28 <malloc+0x9c2>
    1748:	26b030ef          	jal	51b2 <printf>
        exit(1);
    174c:	4505                	li	a0,1
    174e:	62c030ef          	jal	4d7a <exit>
        exit(0);
    1752:	628030ef          	jal	4d7a <exit>

0000000000001756 <forkfork>:
{
    1756:	7179                	addi	sp,sp,-48
    1758:	f406                	sd	ra,40(sp)
    175a:	f022                	sd	s0,32(sp)
    175c:	ec26                	sd	s1,24(sp)
    175e:	1800                	addi	s0,sp,48
    1760:	84aa                	mv	s1,a0
    int pid = fork();
    1762:	610030ef          	jal	4d72 <fork>
    if(pid < 0){
    1766:	02054b63          	bltz	a0,179c <forkfork+0x46>
    if(pid == 0){
    176a:	c139                	beqz	a0,17b0 <forkfork+0x5a>
    int pid = fork();
    176c:	606030ef          	jal	4d72 <fork>
    if(pid < 0){
    1770:	02054663          	bltz	a0,179c <forkfork+0x46>
    if(pid == 0){
    1774:	cd15                	beqz	a0,17b0 <forkfork+0x5a>
    wait(&xstatus);
    1776:	fdc40513          	addi	a0,s0,-36
    177a:	608030ef          	jal	4d82 <wait>
    if(xstatus != 0) {
    177e:	fdc42783          	lw	a5,-36(s0)
    1782:	ebb9                	bnez	a5,17d8 <forkfork+0x82>
    wait(&xstatus);
    1784:	fdc40513          	addi	a0,s0,-36
    1788:	5fa030ef          	jal	4d82 <wait>
    if(xstatus != 0) {
    178c:	fdc42783          	lw	a5,-36(s0)
    1790:	e7a1                	bnez	a5,17d8 <forkfork+0x82>
}
    1792:	70a2                	ld	ra,40(sp)
    1794:	7402                	ld	s0,32(sp)
    1796:	64e2                	ld	s1,24(sp)
    1798:	6145                	addi	sp,sp,48
    179a:	8082                	ret
      printf("%s: fork failed", s);
    179c:	85a6                	mv	a1,s1
    179e:	00004517          	auipc	a0,0x4
    17a2:	64a50513          	addi	a0,a0,1610 # 5de8 <malloc+0xb82>
    17a6:	20d030ef          	jal	51b2 <printf>
      exit(1);
    17aa:	4505                	li	a0,1
    17ac:	5ce030ef          	jal	4d7a <exit>
{
    17b0:	0c800493          	li	s1,200
        int pid1 = fork();
    17b4:	5be030ef          	jal	4d72 <fork>
        if(pid1 < 0){
    17b8:	00054b63          	bltz	a0,17ce <forkfork+0x78>
        if(pid1 == 0){
    17bc:	cd01                	beqz	a0,17d4 <forkfork+0x7e>
        wait(0);
    17be:	4501                	li	a0,0
    17c0:	5c2030ef          	jal	4d82 <wait>
      for(int j = 0; j < 200; j++){
    17c4:	34fd                	addiw	s1,s1,-1
    17c6:	f4fd                	bnez	s1,17b4 <forkfork+0x5e>
      exit(0);
    17c8:	4501                	li	a0,0
    17ca:	5b0030ef          	jal	4d7a <exit>
          exit(1);
    17ce:	4505                	li	a0,1
    17d0:	5aa030ef          	jal	4d7a <exit>
          exit(0);
    17d4:	5a6030ef          	jal	4d7a <exit>
      printf("%s: fork in child failed", s);
    17d8:	85a6                	mv	a1,s1
    17da:	00004517          	auipc	a0,0x4
    17de:	61e50513          	addi	a0,a0,1566 # 5df8 <malloc+0xb92>
    17e2:	1d1030ef          	jal	51b2 <printf>
      exit(1);
    17e6:	4505                	li	a0,1
    17e8:	592030ef          	jal	4d7a <exit>

00000000000017ec <reparent2>:
{
    17ec:	1101                	addi	sp,sp,-32
    17ee:	ec06                	sd	ra,24(sp)
    17f0:	e822                	sd	s0,16(sp)
    17f2:	e426                	sd	s1,8(sp)
    17f4:	1000                	addi	s0,sp,32
    17f6:	32000493          	li	s1,800
    int pid1 = fork();
    17fa:	578030ef          	jal	4d72 <fork>
    if(pid1 < 0){
    17fe:	00054b63          	bltz	a0,1814 <reparent2+0x28>
    if(pid1 == 0){
    1802:	c115                	beqz	a0,1826 <reparent2+0x3a>
    wait(0);
    1804:	4501                	li	a0,0
    1806:	57c030ef          	jal	4d82 <wait>
  for(int i = 0; i < 800; i++){
    180a:	34fd                	addiw	s1,s1,-1
    180c:	f4fd                	bnez	s1,17fa <reparent2+0xe>
  exit(0);
    180e:	4501                	li	a0,0
    1810:	56a030ef          	jal	4d7a <exit>
      printf("fork failed\n");
    1814:	00006517          	auipc	a0,0x6
    1818:	9bc50513          	addi	a0,a0,-1604 # 71d0 <malloc+0x1f6a>
    181c:	197030ef          	jal	51b2 <printf>
      exit(1);
    1820:	4505                	li	a0,1
    1822:	558030ef          	jal	4d7a <exit>
      fork();
    1826:	54c030ef          	jal	4d72 <fork>
      fork();
    182a:	548030ef          	jal	4d72 <fork>
      exit(0);
    182e:	4501                	li	a0,0
    1830:	54a030ef          	jal	4d7a <exit>

0000000000001834 <createdelete>:
{
    1834:	7175                	addi	sp,sp,-144
    1836:	e506                	sd	ra,136(sp)
    1838:	e122                	sd	s0,128(sp)
    183a:	fca6                	sd	s1,120(sp)
    183c:	f8ca                	sd	s2,112(sp)
    183e:	f4ce                	sd	s3,104(sp)
    1840:	f0d2                	sd	s4,96(sp)
    1842:	ecd6                	sd	s5,88(sp)
    1844:	e8da                	sd	s6,80(sp)
    1846:	e4de                	sd	s7,72(sp)
    1848:	e0e2                	sd	s8,64(sp)
    184a:	fc66                	sd	s9,56(sp)
    184c:	0900                	addi	s0,sp,144
    184e:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1850:	4901                	li	s2,0
    1852:	4991                	li	s3,4
    pid = fork();
    1854:	51e030ef          	jal	4d72 <fork>
    1858:	84aa                	mv	s1,a0
    if(pid < 0){
    185a:	02054d63          	bltz	a0,1894 <createdelete+0x60>
    if(pid == 0){
    185e:	c529                	beqz	a0,18a8 <createdelete+0x74>
  for(pi = 0; pi < NCHILD; pi++){
    1860:	2905                	addiw	s2,s2,1
    1862:	ff3919e3          	bne	s2,s3,1854 <createdelete+0x20>
    1866:	4491                	li	s1,4
    wait(&xstatus);
    1868:	f7c40513          	addi	a0,s0,-132
    186c:	516030ef          	jal	4d82 <wait>
    if(xstatus != 0)
    1870:	f7c42903          	lw	s2,-132(s0)
    1874:	0a091e63          	bnez	s2,1930 <createdelete+0xfc>
  for(pi = 0; pi < NCHILD; pi++){
    1878:	34fd                	addiw	s1,s1,-1
    187a:	f4fd                	bnez	s1,1868 <createdelete+0x34>
  name[0] = name[1] = name[2] = 0;
    187c:	f8040123          	sb	zero,-126(s0)
    1880:	03000993          	li	s3,48
    1884:	5a7d                	li	s4,-1
    1886:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    188a:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    188c:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    188e:	07400a93          	li	s5,116
    1892:	aa39                	j	19b0 <createdelete+0x17c>
      printf("%s: fork failed\n", s);
    1894:	85e6                	mv	a1,s9
    1896:	00004517          	auipc	a0,0x4
    189a:	39250513          	addi	a0,a0,914 # 5c28 <malloc+0x9c2>
    189e:	115030ef          	jal	51b2 <printf>
      exit(1);
    18a2:	4505                	li	a0,1
    18a4:	4d6030ef          	jal	4d7a <exit>
      name[0] = 'p' + pi;
    18a8:	0709091b          	addiw	s2,s2,112
    18ac:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    18b0:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    18b4:	4951                	li	s2,20
    18b6:	a831                	j	18d2 <createdelete+0x9e>
          printf("%s: create failed\n", s);
    18b8:	85e6                	mv	a1,s9
    18ba:	00004517          	auipc	a0,0x4
    18be:	40650513          	addi	a0,a0,1030 # 5cc0 <malloc+0xa5a>
    18c2:	0f1030ef          	jal	51b2 <printf>
          exit(1);
    18c6:	4505                	li	a0,1
    18c8:	4b2030ef          	jal	4d7a <exit>
      for(i = 0; i < N; i++){
    18cc:	2485                	addiw	s1,s1,1
    18ce:	05248e63          	beq	s1,s2,192a <createdelete+0xf6>
        name[1] = '0' + i;
    18d2:	0304879b          	addiw	a5,s1,48
    18d6:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    18da:	20200593          	li	a1,514
    18de:	f8040513          	addi	a0,s0,-128
    18e2:	4d8030ef          	jal	4dba <open>
        if(fd < 0){
    18e6:	fc0549e3          	bltz	a0,18b8 <createdelete+0x84>
        close(fd);
    18ea:	4b8030ef          	jal	4da2 <close>
        if(i > 0 && (i % 2 ) == 0){
    18ee:	10905063          	blez	s1,19ee <createdelete+0x1ba>
    18f2:	0014f793          	andi	a5,s1,1
    18f6:	fbf9                	bnez	a5,18cc <createdelete+0x98>
          name[1] = '0' + (i / 2);
    18f8:	01f4d79b          	srliw	a5,s1,0x1f
    18fc:	9fa5                	addw	a5,a5,s1
    18fe:	4017d79b          	sraiw	a5,a5,0x1
    1902:	0307879b          	addiw	a5,a5,48
    1906:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    190a:	f8040513          	addi	a0,s0,-128
    190e:	4bc030ef          	jal	4dca <unlink>
    1912:	fa055de3          	bgez	a0,18cc <createdelete+0x98>
            printf("%s: unlink failed\n", s);
    1916:	85e6                	mv	a1,s9
    1918:	00004517          	auipc	a0,0x4
    191c:	50050513          	addi	a0,a0,1280 # 5e18 <malloc+0xbb2>
    1920:	093030ef          	jal	51b2 <printf>
            exit(1);
    1924:	4505                	li	a0,1
    1926:	454030ef          	jal	4d7a <exit>
      exit(0);
    192a:	4501                	li	a0,0
    192c:	44e030ef          	jal	4d7a <exit>
      exit(1);
    1930:	4505                	li	a0,1
    1932:	448030ef          	jal	4d7a <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1936:	f8040613          	addi	a2,s0,-128
    193a:	85e6                	mv	a1,s9
    193c:	00004517          	auipc	a0,0x4
    1940:	4f450513          	addi	a0,a0,1268 # 5e30 <malloc+0xbca>
    1944:	06f030ef          	jal	51b2 <printf>
        exit(1);
    1948:	4505                	li	a0,1
    194a:	430030ef          	jal	4d7a <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    194e:	034bfb63          	bgeu	s7,s4,1984 <createdelete+0x150>
      if(fd >= 0)
    1952:	02055663          	bgez	a0,197e <createdelete+0x14a>
    for(pi = 0; pi < NCHILD; pi++){
    1956:	2485                	addiw	s1,s1,1
    1958:	0ff4f493          	zext.b	s1,s1
    195c:	05548263          	beq	s1,s5,19a0 <createdelete+0x16c>
      name[0] = 'p' + pi;
    1960:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1964:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1968:	4581                	li	a1,0
    196a:	f8040513          	addi	a0,s0,-128
    196e:	44c030ef          	jal	4dba <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1972:	00090463          	beqz	s2,197a <createdelete+0x146>
    1976:	fd2b5ce3          	bge	s6,s2,194e <createdelete+0x11a>
    197a:	fa054ee3          	bltz	a0,1936 <createdelete+0x102>
        close(fd);
    197e:	424030ef          	jal	4da2 <close>
    1982:	bfd1                	j	1956 <createdelete+0x122>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1984:	fc0549e3          	bltz	a0,1956 <createdelete+0x122>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1988:	f8040613          	addi	a2,s0,-128
    198c:	85e6                	mv	a1,s9
    198e:	00004517          	auipc	a0,0x4
    1992:	4ca50513          	addi	a0,a0,1226 # 5e58 <malloc+0xbf2>
    1996:	01d030ef          	jal	51b2 <printf>
        exit(1);
    199a:	4505                	li	a0,1
    199c:	3de030ef          	jal	4d7a <exit>
  for(i = 0; i < N; i++){
    19a0:	2905                	addiw	s2,s2,1
    19a2:	2a05                	addiw	s4,s4,1
    19a4:	2985                	addiw	s3,s3,1
    19a6:	0ff9f993          	zext.b	s3,s3
    19aa:	47d1                	li	a5,20
    19ac:	02f90863          	beq	s2,a5,19dc <createdelete+0x1a8>
    for(pi = 0; pi < NCHILD; pi++){
    19b0:	84e2                	mv	s1,s8
    19b2:	b77d                	j	1960 <createdelete+0x12c>
  for(i = 0; i < N; i++){
    19b4:	2905                	addiw	s2,s2,1
    19b6:	0ff97913          	zext.b	s2,s2
    19ba:	03490c63          	beq	s2,s4,19f2 <createdelete+0x1be>
  name[0] = name[1] = name[2] = 0;
    19be:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    19c0:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    19c4:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    19c8:	f8040513          	addi	a0,s0,-128
    19cc:	3fe030ef          	jal	4dca <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    19d0:	2485                	addiw	s1,s1,1
    19d2:	0ff4f493          	zext.b	s1,s1
    19d6:	ff3495e3          	bne	s1,s3,19c0 <createdelete+0x18c>
    19da:	bfe9                	j	19b4 <createdelete+0x180>
    19dc:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    19e0:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    19e4:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    19e8:	04400a13          	li	s4,68
    19ec:	bfc9                	j	19be <createdelete+0x18a>
      for(i = 0; i < N; i++){
    19ee:	2485                	addiw	s1,s1,1
    19f0:	b5cd                	j	18d2 <createdelete+0x9e>
}
    19f2:	60aa                	ld	ra,136(sp)
    19f4:	640a                	ld	s0,128(sp)
    19f6:	74e6                	ld	s1,120(sp)
    19f8:	7946                	ld	s2,112(sp)
    19fa:	79a6                	ld	s3,104(sp)
    19fc:	7a06                	ld	s4,96(sp)
    19fe:	6ae6                	ld	s5,88(sp)
    1a00:	6b46                	ld	s6,80(sp)
    1a02:	6ba6                	ld	s7,72(sp)
    1a04:	6c06                	ld	s8,64(sp)
    1a06:	7ce2                	ld	s9,56(sp)
    1a08:	6149                	addi	sp,sp,144
    1a0a:	8082                	ret

0000000000001a0c <linkunlink>:
{
    1a0c:	711d                	addi	sp,sp,-96
    1a0e:	ec86                	sd	ra,88(sp)
    1a10:	e8a2                	sd	s0,80(sp)
    1a12:	e4a6                	sd	s1,72(sp)
    1a14:	e0ca                	sd	s2,64(sp)
    1a16:	fc4e                	sd	s3,56(sp)
    1a18:	f852                	sd	s4,48(sp)
    1a1a:	f456                	sd	s5,40(sp)
    1a1c:	f05a                	sd	s6,32(sp)
    1a1e:	ec5e                	sd	s7,24(sp)
    1a20:	e862                	sd	s8,16(sp)
    1a22:	e466                	sd	s9,8(sp)
    1a24:	1080                	addi	s0,sp,96
    1a26:	84aa                	mv	s1,a0
  unlink("x");
    1a28:	00004517          	auipc	a0,0x4
    1a2c:	9e050513          	addi	a0,a0,-1568 # 5408 <malloc+0x1a2>
    1a30:	39a030ef          	jal	4dca <unlink>
  pid = fork();
    1a34:	33e030ef          	jal	4d72 <fork>
  if(pid < 0){
    1a38:	02054b63          	bltz	a0,1a6e <linkunlink+0x62>
    1a3c:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1a3e:	06100913          	li	s2,97
    1a42:	c111                	beqz	a0,1a46 <linkunlink+0x3a>
    1a44:	4905                	li	s2,1
    1a46:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1a4a:	41c65a37          	lui	s4,0x41c65
    1a4e:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c561b5>
    1a52:	698d                	lui	s3,0x3
    1a54:	0399899b          	addiw	s3,s3,57 # 3039 <subdir+0x471>
    if((x % 3) == 0){
    1a58:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    1a5a:	4b85                	li	s7,1
      unlink("x");
    1a5c:	00004b17          	auipc	s6,0x4
    1a60:	9acb0b13          	addi	s6,s6,-1620 # 5408 <malloc+0x1a2>
      link("cat", "x");
    1a64:	00004c17          	auipc	s8,0x4
    1a68:	41cc0c13          	addi	s8,s8,1052 # 5e80 <malloc+0xc1a>
    1a6c:	a025                	j	1a94 <linkunlink+0x88>
    printf("%s: fork failed\n", s);
    1a6e:	85a6                	mv	a1,s1
    1a70:	00004517          	auipc	a0,0x4
    1a74:	1b850513          	addi	a0,a0,440 # 5c28 <malloc+0x9c2>
    1a78:	73a030ef          	jal	51b2 <printf>
    exit(1);
    1a7c:	4505                	li	a0,1
    1a7e:	2fc030ef          	jal	4d7a <exit>
      close(open("x", O_RDWR | O_CREATE));
    1a82:	20200593          	li	a1,514
    1a86:	855a                	mv	a0,s6
    1a88:	332030ef          	jal	4dba <open>
    1a8c:	316030ef          	jal	4da2 <close>
  for(i = 0; i < 100; i++){
    1a90:	34fd                	addiw	s1,s1,-1
    1a92:	c495                	beqz	s1,1abe <linkunlink+0xb2>
    x = x * 1103515245 + 12345;
    1a94:	034907bb          	mulw	a5,s2,s4
    1a98:	013787bb          	addw	a5,a5,s3
    1a9c:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    1aa0:	0357f7bb          	remuw	a5,a5,s5
    1aa4:	2781                	sext.w	a5,a5
    1aa6:	dff1                	beqz	a5,1a82 <linkunlink+0x76>
    } else if((x % 3) == 1){
    1aa8:	01778663          	beq	a5,s7,1ab4 <linkunlink+0xa8>
      unlink("x");
    1aac:	855a                	mv	a0,s6
    1aae:	31c030ef          	jal	4dca <unlink>
    1ab2:	bff9                	j	1a90 <linkunlink+0x84>
      link("cat", "x");
    1ab4:	85da                	mv	a1,s6
    1ab6:	8562                	mv	a0,s8
    1ab8:	322030ef          	jal	4dda <link>
    1abc:	bfd1                	j	1a90 <linkunlink+0x84>
  if(pid)
    1abe:	020c8263          	beqz	s9,1ae2 <linkunlink+0xd6>
    wait(0);
    1ac2:	4501                	li	a0,0
    1ac4:	2be030ef          	jal	4d82 <wait>
}
    1ac8:	60e6                	ld	ra,88(sp)
    1aca:	6446                	ld	s0,80(sp)
    1acc:	64a6                	ld	s1,72(sp)
    1ace:	6906                	ld	s2,64(sp)
    1ad0:	79e2                	ld	s3,56(sp)
    1ad2:	7a42                	ld	s4,48(sp)
    1ad4:	7aa2                	ld	s5,40(sp)
    1ad6:	7b02                	ld	s6,32(sp)
    1ad8:	6be2                	ld	s7,24(sp)
    1ada:	6c42                	ld	s8,16(sp)
    1adc:	6ca2                	ld	s9,8(sp)
    1ade:	6125                	addi	sp,sp,96
    1ae0:	8082                	ret
    exit(0);
    1ae2:	4501                	li	a0,0
    1ae4:	296030ef          	jal	4d7a <exit>

0000000000001ae8 <forktest>:
{
    1ae8:	7179                	addi	sp,sp,-48
    1aea:	f406                	sd	ra,40(sp)
    1aec:	f022                	sd	s0,32(sp)
    1aee:	ec26                	sd	s1,24(sp)
    1af0:	e84a                	sd	s2,16(sp)
    1af2:	e44e                	sd	s3,8(sp)
    1af4:	1800                	addi	s0,sp,48
    1af6:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1af8:	4481                	li	s1,0
    1afa:	3e800913          	li	s2,1000
    pid = fork();
    1afe:	274030ef          	jal	4d72 <fork>
    if(pid < 0)
    1b02:	06054063          	bltz	a0,1b62 <forktest+0x7a>
    if(pid == 0)
    1b06:	cd11                	beqz	a0,1b22 <forktest+0x3a>
  for(n=0; n<N; n++){
    1b08:	2485                	addiw	s1,s1,1
    1b0a:	ff249ae3          	bne	s1,s2,1afe <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1b0e:	85ce                	mv	a1,s3
    1b10:	00004517          	auipc	a0,0x4
    1b14:	3c050513          	addi	a0,a0,960 # 5ed0 <malloc+0xc6a>
    1b18:	69a030ef          	jal	51b2 <printf>
    exit(1);
    1b1c:	4505                	li	a0,1
    1b1e:	25c030ef          	jal	4d7a <exit>
      exit(0);
    1b22:	258030ef          	jal	4d7a <exit>
    printf("%s: no fork at all!\n", s);
    1b26:	85ce                	mv	a1,s3
    1b28:	00004517          	auipc	a0,0x4
    1b2c:	36050513          	addi	a0,a0,864 # 5e88 <malloc+0xc22>
    1b30:	682030ef          	jal	51b2 <printf>
    exit(1);
    1b34:	4505                	li	a0,1
    1b36:	244030ef          	jal	4d7a <exit>
      printf("%s: wait stopped early\n", s);
    1b3a:	85ce                	mv	a1,s3
    1b3c:	00004517          	auipc	a0,0x4
    1b40:	36450513          	addi	a0,a0,868 # 5ea0 <malloc+0xc3a>
    1b44:	66e030ef          	jal	51b2 <printf>
      exit(1);
    1b48:	4505                	li	a0,1
    1b4a:	230030ef          	jal	4d7a <exit>
    printf("%s: wait got too many\n", s);
    1b4e:	85ce                	mv	a1,s3
    1b50:	00004517          	auipc	a0,0x4
    1b54:	36850513          	addi	a0,a0,872 # 5eb8 <malloc+0xc52>
    1b58:	65a030ef          	jal	51b2 <printf>
    exit(1);
    1b5c:	4505                	li	a0,1
    1b5e:	21c030ef          	jal	4d7a <exit>
  if (n == 0) {
    1b62:	d0f1                	beqz	s1,1b26 <forktest+0x3e>
  for(; n > 0; n--){
    1b64:	00905963          	blez	s1,1b76 <forktest+0x8e>
    if(wait(0) < 0){
    1b68:	4501                	li	a0,0
    1b6a:	218030ef          	jal	4d82 <wait>
    1b6e:	fc0546e3          	bltz	a0,1b3a <forktest+0x52>
  for(; n > 0; n--){
    1b72:	34fd                	addiw	s1,s1,-1
    1b74:	f8f5                	bnez	s1,1b68 <forktest+0x80>
  if(wait(0) != -1){
    1b76:	4501                	li	a0,0
    1b78:	20a030ef          	jal	4d82 <wait>
    1b7c:	57fd                	li	a5,-1
    1b7e:	fcf518e3          	bne	a0,a5,1b4e <forktest+0x66>
}
    1b82:	70a2                	ld	ra,40(sp)
    1b84:	7402                	ld	s0,32(sp)
    1b86:	64e2                	ld	s1,24(sp)
    1b88:	6942                	ld	s2,16(sp)
    1b8a:	69a2                	ld	s3,8(sp)
    1b8c:	6145                	addi	sp,sp,48
    1b8e:	8082                	ret

0000000000001b90 <kernmem>:
{
    1b90:	715d                	addi	sp,sp,-80
    1b92:	e486                	sd	ra,72(sp)
    1b94:	e0a2                	sd	s0,64(sp)
    1b96:	fc26                	sd	s1,56(sp)
    1b98:	f84a                	sd	s2,48(sp)
    1b9a:	f44e                	sd	s3,40(sp)
    1b9c:	f052                	sd	s4,32(sp)
    1b9e:	ec56                	sd	s5,24(sp)
    1ba0:	0880                	addi	s0,sp,80
    1ba2:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ba4:	4485                	li	s1,1
    1ba6:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1ba8:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1baa:	69b1                	lui	s3,0xc
    1bac:	35098993          	addi	s3,s3,848 # c350 <buf+0x698>
    1bb0:	1003d937          	lui	s2,0x1003d
    1bb4:	090e                	slli	s2,s2,0x3
    1bb6:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002e7c8>
    pid = fork();
    1bba:	1b8030ef          	jal	4d72 <fork>
    if(pid < 0){
    1bbe:	02054763          	bltz	a0,1bec <kernmem+0x5c>
    if(pid == 0){
    1bc2:	cd1d                	beqz	a0,1c00 <kernmem+0x70>
    wait(&xstatus);
    1bc4:	fbc40513          	addi	a0,s0,-68
    1bc8:	1ba030ef          	jal	4d82 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1bcc:	fbc42783          	lw	a5,-68(s0)
    1bd0:	05479563          	bne	a5,s4,1c1a <kernmem+0x8a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1bd4:	94ce                	add	s1,s1,s3
    1bd6:	ff2492e3          	bne	s1,s2,1bba <kernmem+0x2a>
}
    1bda:	60a6                	ld	ra,72(sp)
    1bdc:	6406                	ld	s0,64(sp)
    1bde:	74e2                	ld	s1,56(sp)
    1be0:	7942                	ld	s2,48(sp)
    1be2:	79a2                	ld	s3,40(sp)
    1be4:	7a02                	ld	s4,32(sp)
    1be6:	6ae2                	ld	s5,24(sp)
    1be8:	6161                	addi	sp,sp,80
    1bea:	8082                	ret
      printf("%s: fork failed\n", s);
    1bec:	85d6                	mv	a1,s5
    1bee:	00004517          	auipc	a0,0x4
    1bf2:	03a50513          	addi	a0,a0,58 # 5c28 <malloc+0x9c2>
    1bf6:	5bc030ef          	jal	51b2 <printf>
      exit(1);
    1bfa:	4505                	li	a0,1
    1bfc:	17e030ef          	jal	4d7a <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1c00:	0004c683          	lbu	a3,0(s1)
    1c04:	8626                	mv	a2,s1
    1c06:	85d6                	mv	a1,s5
    1c08:	00004517          	auipc	a0,0x4
    1c0c:	2f050513          	addi	a0,a0,752 # 5ef8 <malloc+0xc92>
    1c10:	5a2030ef          	jal	51b2 <printf>
      exit(1);
    1c14:	4505                	li	a0,1
    1c16:	164030ef          	jal	4d7a <exit>
      exit(1);
    1c1a:	4505                	li	a0,1
    1c1c:	15e030ef          	jal	4d7a <exit>

0000000000001c20 <MAXVAplus>:
{
    1c20:	7179                	addi	sp,sp,-48
    1c22:	f406                	sd	ra,40(sp)
    1c24:	f022                	sd	s0,32(sp)
    1c26:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    1c28:	4785                	li	a5,1
    1c2a:	179a                	slli	a5,a5,0x26
    1c2c:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    1c30:	fd843783          	ld	a5,-40(s0)
    1c34:	cf85                	beqz	a5,1c6c <MAXVAplus+0x4c>
    1c36:	ec26                	sd	s1,24(sp)
    1c38:	e84a                	sd	s2,16(sp)
    1c3a:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    1c3c:	54fd                	li	s1,-1
    pid = fork();
    1c3e:	134030ef          	jal	4d72 <fork>
    if(pid < 0){
    1c42:	02054963          	bltz	a0,1c74 <MAXVAplus+0x54>
    if(pid == 0){
    1c46:	c129                	beqz	a0,1c88 <MAXVAplus+0x68>
    wait(&xstatus);
    1c48:	fd440513          	addi	a0,s0,-44
    1c4c:	136030ef          	jal	4d82 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c50:	fd442783          	lw	a5,-44(s0)
    1c54:	04979c63          	bne	a5,s1,1cac <MAXVAplus+0x8c>
  for( ; a != 0; a <<= 1){
    1c58:	fd843783          	ld	a5,-40(s0)
    1c5c:	0786                	slli	a5,a5,0x1
    1c5e:	fcf43c23          	sd	a5,-40(s0)
    1c62:	fd843783          	ld	a5,-40(s0)
    1c66:	ffe1                	bnez	a5,1c3e <MAXVAplus+0x1e>
    1c68:	64e2                	ld	s1,24(sp)
    1c6a:	6942                	ld	s2,16(sp)
}
    1c6c:	70a2                	ld	ra,40(sp)
    1c6e:	7402                	ld	s0,32(sp)
    1c70:	6145                	addi	sp,sp,48
    1c72:	8082                	ret
      printf("%s: fork failed\n", s);
    1c74:	85ca                	mv	a1,s2
    1c76:	00004517          	auipc	a0,0x4
    1c7a:	fb250513          	addi	a0,a0,-78 # 5c28 <malloc+0x9c2>
    1c7e:	534030ef          	jal	51b2 <printf>
      exit(1);
    1c82:	4505                	li	a0,1
    1c84:	0f6030ef          	jal	4d7a <exit>
      *(char*)a = 99;
    1c88:	fd843783          	ld	a5,-40(s0)
    1c8c:	06300713          	li	a4,99
    1c90:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1c94:	fd843603          	ld	a2,-40(s0)
    1c98:	85ca                	mv	a1,s2
    1c9a:	00004517          	auipc	a0,0x4
    1c9e:	27e50513          	addi	a0,a0,638 # 5f18 <malloc+0xcb2>
    1ca2:	510030ef          	jal	51b2 <printf>
      exit(1);
    1ca6:	4505                	li	a0,1
    1ca8:	0d2030ef          	jal	4d7a <exit>
      exit(1);
    1cac:	4505                	li	a0,1
    1cae:	0cc030ef          	jal	4d7a <exit>

0000000000001cb2 <stacktest>:
{
    1cb2:	7179                	addi	sp,sp,-48
    1cb4:	f406                	sd	ra,40(sp)
    1cb6:	f022                	sd	s0,32(sp)
    1cb8:	ec26                	sd	s1,24(sp)
    1cba:	1800                	addi	s0,sp,48
    1cbc:	84aa                	mv	s1,a0
  pid = fork();
    1cbe:	0b4030ef          	jal	4d72 <fork>
  if(pid == 0) {
    1cc2:	cd11                	beqz	a0,1cde <stacktest+0x2c>
  } else if(pid < 0){
    1cc4:	02054c63          	bltz	a0,1cfc <stacktest+0x4a>
  wait(&xstatus);
    1cc8:	fdc40513          	addi	a0,s0,-36
    1ccc:	0b6030ef          	jal	4d82 <wait>
  if(xstatus == -1)  // kernel killed child?
    1cd0:	fdc42503          	lw	a0,-36(s0)
    1cd4:	57fd                	li	a5,-1
    1cd6:	02f50d63          	beq	a0,a5,1d10 <stacktest+0x5e>
    exit(xstatus);
    1cda:	0a0030ef          	jal	4d7a <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1cde:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1ce0:	77fd                	lui	a5,0xfffff
    1ce2:	97ba                	add	a5,a5,a4
    1ce4:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xffffffffffff0348>
    1ce8:	85a6                	mv	a1,s1
    1cea:	00004517          	auipc	a0,0x4
    1cee:	24650513          	addi	a0,a0,582 # 5f30 <malloc+0xcca>
    1cf2:	4c0030ef          	jal	51b2 <printf>
    exit(1);
    1cf6:	4505                	li	a0,1
    1cf8:	082030ef          	jal	4d7a <exit>
    printf("%s: fork failed\n", s);
    1cfc:	85a6                	mv	a1,s1
    1cfe:	00004517          	auipc	a0,0x4
    1d02:	f2a50513          	addi	a0,a0,-214 # 5c28 <malloc+0x9c2>
    1d06:	4ac030ef          	jal	51b2 <printf>
    exit(1);
    1d0a:	4505                	li	a0,1
    1d0c:	06e030ef          	jal	4d7a <exit>
    exit(0);
    1d10:	4501                	li	a0,0
    1d12:	068030ef          	jal	4d7a <exit>

0000000000001d16 <nowrite>:
{
    1d16:	7159                	addi	sp,sp,-112
    1d18:	f486                	sd	ra,104(sp)
    1d1a:	f0a2                	sd	s0,96(sp)
    1d1c:	eca6                	sd	s1,88(sp)
    1d1e:	e8ca                	sd	s2,80(sp)
    1d20:	e4ce                	sd	s3,72(sp)
    1d22:	1880                	addi	s0,sp,112
    1d24:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1d26:	00006797          	auipc	a5,0x6
    1d2a:	bba78793          	addi	a5,a5,-1094 # 78e0 <malloc+0x267a>
    1d2e:	7788                	ld	a0,40(a5)
    1d30:	7b8c                	ld	a1,48(a5)
    1d32:	7f90                	ld	a2,56(a5)
    1d34:	63b4                	ld	a3,64(a5)
    1d36:	67b8                	ld	a4,72(a5)
    1d38:	6bbc                	ld	a5,80(a5)
    1d3a:	f8a43c23          	sd	a0,-104(s0)
    1d3e:	fab43023          	sd	a1,-96(s0)
    1d42:	fac43423          	sd	a2,-88(s0)
    1d46:	fad43823          	sd	a3,-80(s0)
    1d4a:	fae43c23          	sd	a4,-72(s0)
    1d4e:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d52:	4481                	li	s1,0
    1d54:	4919                	li	s2,6
    pid = fork();
    1d56:	01c030ef          	jal	4d72 <fork>
    if(pid == 0) {
    1d5a:	c105                	beqz	a0,1d7a <nowrite+0x64>
    } else if(pid < 0){
    1d5c:	04054263          	bltz	a0,1da0 <nowrite+0x8a>
    wait(&xstatus);
    1d60:	fcc40513          	addi	a0,s0,-52
    1d64:	01e030ef          	jal	4d82 <wait>
    if(xstatus == 0){
    1d68:	fcc42783          	lw	a5,-52(s0)
    1d6c:	c7a1                	beqz	a5,1db4 <nowrite+0x9e>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d6e:	2485                	addiw	s1,s1,1
    1d70:	ff2493e3          	bne	s1,s2,1d56 <nowrite+0x40>
  exit(0);
    1d74:	4501                	li	a0,0
    1d76:	004030ef          	jal	4d7a <exit>
      volatile int *addr = (int *) addrs[ai];
    1d7a:	048e                	slli	s1,s1,0x3
    1d7c:	fd048793          	addi	a5,s1,-48
    1d80:	008784b3          	add	s1,a5,s0
    1d84:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1d88:	47a9                	li	a5,10
    1d8a:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1d8c:	85ce                	mv	a1,s3
    1d8e:	00004517          	auipc	a0,0x4
    1d92:	1ca50513          	addi	a0,a0,458 # 5f58 <malloc+0xcf2>
    1d96:	41c030ef          	jal	51b2 <printf>
      exit(0);
    1d9a:	4501                	li	a0,0
    1d9c:	7df020ef          	jal	4d7a <exit>
      printf("%s: fork failed\n", s);
    1da0:	85ce                	mv	a1,s3
    1da2:	00004517          	auipc	a0,0x4
    1da6:	e8650513          	addi	a0,a0,-378 # 5c28 <malloc+0x9c2>
    1daa:	408030ef          	jal	51b2 <printf>
      exit(1);
    1dae:	4505                	li	a0,1
    1db0:	7cb020ef          	jal	4d7a <exit>
      exit(1);
    1db4:	4505                	li	a0,1
    1db6:	7c5020ef          	jal	4d7a <exit>

0000000000001dba <manywrites>:
{
    1dba:	711d                	addi	sp,sp,-96
    1dbc:	ec86                	sd	ra,88(sp)
    1dbe:	e8a2                	sd	s0,80(sp)
    1dc0:	e4a6                	sd	s1,72(sp)
    1dc2:	e0ca                	sd	s2,64(sp)
    1dc4:	fc4e                	sd	s3,56(sp)
    1dc6:	f456                	sd	s5,40(sp)
    1dc8:	1080                	addi	s0,sp,96
    1dca:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1dcc:	4981                	li	s3,0
    1dce:	4911                	li	s2,4
    int pid = fork();
    1dd0:	7a3020ef          	jal	4d72 <fork>
    1dd4:	84aa                	mv	s1,a0
    if(pid < 0){
    1dd6:	02054963          	bltz	a0,1e08 <manywrites+0x4e>
    if(pid == 0){
    1dda:	c139                	beqz	a0,1e20 <manywrites+0x66>
  for(int ci = 0; ci < nchildren; ci++){
    1ddc:	2985                	addiw	s3,s3,1
    1dde:	ff2999e3          	bne	s3,s2,1dd0 <manywrites+0x16>
    1de2:	f852                	sd	s4,48(sp)
    1de4:	f05a                	sd	s6,32(sp)
    1de6:	ec5e                	sd	s7,24(sp)
    1de8:	4491                	li	s1,4
    int st = 0;
    1dea:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1dee:	fa840513          	addi	a0,s0,-88
    1df2:	791020ef          	jal	4d82 <wait>
    if(st != 0)
    1df6:	fa842503          	lw	a0,-88(s0)
    1dfa:	0c051863          	bnez	a0,1eca <manywrites+0x110>
  for(int ci = 0; ci < nchildren; ci++){
    1dfe:	34fd                	addiw	s1,s1,-1
    1e00:	f4ed                	bnez	s1,1dea <manywrites+0x30>
  exit(0);
    1e02:	4501                	li	a0,0
    1e04:	777020ef          	jal	4d7a <exit>
    1e08:	f852                	sd	s4,48(sp)
    1e0a:	f05a                	sd	s6,32(sp)
    1e0c:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    1e0e:	00005517          	auipc	a0,0x5
    1e12:	3c250513          	addi	a0,a0,962 # 71d0 <malloc+0x1f6a>
    1e16:	39c030ef          	jal	51b2 <printf>
      exit(1);
    1e1a:	4505                	li	a0,1
    1e1c:	75f020ef          	jal	4d7a <exit>
    1e20:	f852                	sd	s4,48(sp)
    1e22:	f05a                	sd	s6,32(sp)
    1e24:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    1e26:	06200793          	li	a5,98
    1e2a:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1e2e:	0619879b          	addiw	a5,s3,97
    1e32:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1e36:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1e3a:	fa840513          	addi	a0,s0,-88
    1e3e:	78d020ef          	jal	4dca <unlink>
    1e42:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1e44:	0000ab17          	auipc	s6,0xa
    1e48:	e74b0b13          	addi	s6,s6,-396 # bcb8 <buf>
        for(int i = 0; i < ci+1; i++){
    1e4c:	8a26                	mv	s4,s1
    1e4e:	0209c863          	bltz	s3,1e7e <manywrites+0xc4>
          int fd = open(name, O_CREATE | O_RDWR);
    1e52:	20200593          	li	a1,514
    1e56:	fa840513          	addi	a0,s0,-88
    1e5a:	761020ef          	jal	4dba <open>
    1e5e:	892a                	mv	s2,a0
          if(fd < 0){
    1e60:	02054d63          	bltz	a0,1e9a <manywrites+0xe0>
          int cc = write(fd, buf, sz);
    1e64:	660d                	lui	a2,0x3
    1e66:	85da                	mv	a1,s6
    1e68:	733020ef          	jal	4d9a <write>
          if(cc != sz){
    1e6c:	678d                	lui	a5,0x3
    1e6e:	04f51263          	bne	a0,a5,1eb2 <manywrites+0xf8>
          close(fd);
    1e72:	854a                	mv	a0,s2
    1e74:	72f020ef          	jal	4da2 <close>
        for(int i = 0; i < ci+1; i++){
    1e78:	2a05                	addiw	s4,s4,1
    1e7a:	fd49dce3          	bge	s3,s4,1e52 <manywrites+0x98>
        unlink(name);
    1e7e:	fa840513          	addi	a0,s0,-88
    1e82:	749020ef          	jal	4dca <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1e86:	3bfd                	addiw	s7,s7,-1
    1e88:	fc0b92e3          	bnez	s7,1e4c <manywrites+0x92>
      unlink(name);
    1e8c:	fa840513          	addi	a0,s0,-88
    1e90:	73b020ef          	jal	4dca <unlink>
      exit(0);
    1e94:	4501                	li	a0,0
    1e96:	6e5020ef          	jal	4d7a <exit>
            printf("%s: cannot create %s\n", s, name);
    1e9a:	fa840613          	addi	a2,s0,-88
    1e9e:	85d6                	mv	a1,s5
    1ea0:	00004517          	auipc	a0,0x4
    1ea4:	0d850513          	addi	a0,a0,216 # 5f78 <malloc+0xd12>
    1ea8:	30a030ef          	jal	51b2 <printf>
            exit(1);
    1eac:	4505                	li	a0,1
    1eae:	6cd020ef          	jal	4d7a <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1eb2:	86aa                	mv	a3,a0
    1eb4:	660d                	lui	a2,0x3
    1eb6:	85d6                	mv	a1,s5
    1eb8:	00003517          	auipc	a0,0x3
    1ebc:	5b050513          	addi	a0,a0,1456 # 5468 <malloc+0x202>
    1ec0:	2f2030ef          	jal	51b2 <printf>
            exit(1);
    1ec4:	4505                	li	a0,1
    1ec6:	6b5020ef          	jal	4d7a <exit>
      exit(st);
    1eca:	6b1020ef          	jal	4d7a <exit>

0000000000001ece <copyinstr3>:
{
    1ece:	7179                	addi	sp,sp,-48
    1ed0:	f406                	sd	ra,40(sp)
    1ed2:	f022                	sd	s0,32(sp)
    1ed4:	ec26                	sd	s1,24(sp)
    1ed6:	1800                	addi	s0,sp,48
  sbrk(8192);
    1ed8:	6509                	lui	a0,0x2
    1eda:	66d020ef          	jal	4d46 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1ede:	4501                	li	a0,0
    1ee0:	667020ef          	jal	4d46 <sbrk>
  if((top % PGSIZE) != 0){
    1ee4:	03451793          	slli	a5,a0,0x34
    1ee8:	e7bd                	bnez	a5,1f56 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1eea:	4501                	li	a0,0
    1eec:	65b020ef          	jal	4d46 <sbrk>
  if(top % PGSIZE){
    1ef0:	03451793          	slli	a5,a0,0x34
    1ef4:	ebad                	bnez	a5,1f66 <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ef6:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0x2d>
  *b = 'x';
    1efa:	07800793          	li	a5,120
    1efe:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1f02:	8526                	mv	a0,s1
    1f04:	6c7020ef          	jal	4dca <unlink>
  if(ret != -1){
    1f08:	57fd                	li	a5,-1
    1f0a:	06f51763          	bne	a0,a5,1f78 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1f0e:	20100593          	li	a1,513
    1f12:	8526                	mv	a0,s1
    1f14:	6a7020ef          	jal	4dba <open>
  if(fd != -1){
    1f18:	57fd                	li	a5,-1
    1f1a:	06f51a63          	bne	a0,a5,1f8e <copyinstr3+0xc0>
  ret = link(b, b);
    1f1e:	85a6                	mv	a1,s1
    1f20:	8526                	mv	a0,s1
    1f22:	6b9020ef          	jal	4dda <link>
  if(ret != -1){
    1f26:	57fd                	li	a5,-1
    1f28:	06f51e63          	bne	a0,a5,1fa4 <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    1f2c:	00005797          	auipc	a5,0x5
    1f30:	d4c78793          	addi	a5,a5,-692 # 6c78 <malloc+0x1a12>
    1f34:	fcf43823          	sd	a5,-48(s0)
    1f38:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1f3c:	fd040593          	addi	a1,s0,-48
    1f40:	8526                	mv	a0,s1
    1f42:	671020ef          	jal	4db2 <exec>
  if(ret != -1){
    1f46:	57fd                	li	a5,-1
    1f48:	06f51a63          	bne	a0,a5,1fbc <copyinstr3+0xee>
}
    1f4c:	70a2                	ld	ra,40(sp)
    1f4e:	7402                	ld	s0,32(sp)
    1f50:	64e2                	ld	s1,24(sp)
    1f52:	6145                	addi	sp,sp,48
    1f54:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1f56:	0347d513          	srli	a0,a5,0x34
    1f5a:	6785                	lui	a5,0x1
    1f5c:	40a7853b          	subw	a0,a5,a0
    1f60:	5e7020ef          	jal	4d46 <sbrk>
    1f64:	b759                	j	1eea <copyinstr3+0x1c>
    printf("oops\n");
    1f66:	00004517          	auipc	a0,0x4
    1f6a:	02a50513          	addi	a0,a0,42 # 5f90 <malloc+0xd2a>
    1f6e:	244030ef          	jal	51b2 <printf>
    exit(1);
    1f72:	4505                	li	a0,1
    1f74:	607020ef          	jal	4d7a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f78:	862a                	mv	a2,a0
    1f7a:	85a6                	mv	a1,s1
    1f7c:	00004517          	auipc	a0,0x4
    1f80:	bcc50513          	addi	a0,a0,-1076 # 5b48 <malloc+0x8e2>
    1f84:	22e030ef          	jal	51b2 <printf>
    exit(1);
    1f88:	4505                	li	a0,1
    1f8a:	5f1020ef          	jal	4d7a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f8e:	862a                	mv	a2,a0
    1f90:	85a6                	mv	a1,s1
    1f92:	00004517          	auipc	a0,0x4
    1f96:	bd650513          	addi	a0,a0,-1066 # 5b68 <malloc+0x902>
    1f9a:	218030ef          	jal	51b2 <printf>
    exit(1);
    1f9e:	4505                	li	a0,1
    1fa0:	5db020ef          	jal	4d7a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1fa4:	86aa                	mv	a3,a0
    1fa6:	8626                	mv	a2,s1
    1fa8:	85a6                	mv	a1,s1
    1faa:	00004517          	auipc	a0,0x4
    1fae:	bde50513          	addi	a0,a0,-1058 # 5b88 <malloc+0x922>
    1fb2:	200030ef          	jal	51b2 <printf>
    exit(1);
    1fb6:	4505                	li	a0,1
    1fb8:	5c3020ef          	jal	4d7a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1fbc:	567d                	li	a2,-1
    1fbe:	85a6                	mv	a1,s1
    1fc0:	00004517          	auipc	a0,0x4
    1fc4:	bf050513          	addi	a0,a0,-1040 # 5bb0 <malloc+0x94a>
    1fc8:	1ea030ef          	jal	51b2 <printf>
    exit(1);
    1fcc:	4505                	li	a0,1
    1fce:	5ad020ef          	jal	4d7a <exit>

0000000000001fd2 <rwsbrk>:
{
    1fd2:	1101                	addi	sp,sp,-32
    1fd4:	ec06                	sd	ra,24(sp)
    1fd6:	e822                	sd	s0,16(sp)
    1fd8:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1fda:	6509                	lui	a0,0x2
    1fdc:	56b020ef          	jal	4d46 <sbrk>
  if(a == (uint64) SBRK_ERROR) {
    1fe0:	57fd                	li	a5,-1
    1fe2:	04f50a63          	beq	a0,a5,2036 <rwsbrk+0x64>
    1fe6:	e426                	sd	s1,8(sp)
    1fe8:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1fea:	7579                	lui	a0,0xffffe
    1fec:	55b020ef          	jal	4d46 <sbrk>
    1ff0:	57fd                	li	a5,-1
    1ff2:	04f50d63          	beq	a0,a5,204c <rwsbrk+0x7a>
    1ff6:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1ff8:	20100593          	li	a1,513
    1ffc:	00004517          	auipc	a0,0x4
    2000:	fd450513          	addi	a0,a0,-44 # 5fd0 <malloc+0xd6a>
    2004:	5b7020ef          	jal	4dba <open>
    2008:	892a                	mv	s2,a0
  if(fd < 0){
    200a:	04054b63          	bltz	a0,2060 <rwsbrk+0x8e>
  n = write(fd, (void*)(a+PGSIZE), 1024);
    200e:	6785                	lui	a5,0x1
    2010:	94be                	add	s1,s1,a5
    2012:	40000613          	li	a2,1024
    2016:	85a6                	mv	a1,s1
    2018:	583020ef          	jal	4d9a <write>
    201c:	862a                	mv	a2,a0
  if(n >= 0){
    201e:	04054a63          	bltz	a0,2072 <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+PGSIZE, n);
    2022:	85a6                	mv	a1,s1
    2024:	00004517          	auipc	a0,0x4
    2028:	fcc50513          	addi	a0,a0,-52 # 5ff0 <malloc+0xd8a>
    202c:	186030ef          	jal	51b2 <printf>
    exit(1);
    2030:	4505                	li	a0,1
    2032:	549020ef          	jal	4d7a <exit>
    2036:	e426                	sd	s1,8(sp)
    2038:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    203a:	00004517          	auipc	a0,0x4
    203e:	f5e50513          	addi	a0,a0,-162 # 5f98 <malloc+0xd32>
    2042:	170030ef          	jal	51b2 <printf>
    exit(1);
    2046:	4505                	li	a0,1
    2048:	533020ef          	jal	4d7a <exit>
    204c:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    204e:	00004517          	auipc	a0,0x4
    2052:	f6250513          	addi	a0,a0,-158 # 5fb0 <malloc+0xd4a>
    2056:	15c030ef          	jal	51b2 <printf>
    exit(1);
    205a:	4505                	li	a0,1
    205c:	51f020ef          	jal	4d7a <exit>
    printf("open(rwsbrk) failed\n");
    2060:	00004517          	auipc	a0,0x4
    2064:	f7850513          	addi	a0,a0,-136 # 5fd8 <malloc+0xd72>
    2068:	14a030ef          	jal	51b2 <printf>
    exit(1);
    206c:	4505                	li	a0,1
    206e:	50d020ef          	jal	4d7a <exit>
  close(fd);
    2072:	854a                	mv	a0,s2
    2074:	52f020ef          	jal	4da2 <close>
  unlink("rwsbrk");
    2078:	00004517          	auipc	a0,0x4
    207c:	f5850513          	addi	a0,a0,-168 # 5fd0 <malloc+0xd6a>
    2080:	54b020ef          	jal	4dca <unlink>
  fd = open("README", O_RDONLY);
    2084:	4581                	li	a1,0
    2086:	00003517          	auipc	a0,0x3
    208a:	4ea50513          	addi	a0,a0,1258 # 5570 <malloc+0x30a>
    208e:	52d020ef          	jal	4dba <open>
    2092:	892a                	mv	s2,a0
  if(fd < 0){
    2094:	02054363          	bltz	a0,20ba <rwsbrk+0xe8>
  n = read(fd, (void*)(a+PGSIZE), 10);
    2098:	4629                	li	a2,10
    209a:	85a6                	mv	a1,s1
    209c:	4f7020ef          	jal	4d92 <read>
    20a0:	862a                	mv	a2,a0
  if(n >= 0){
    20a2:	02054563          	bltz	a0,20cc <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+PGSIZE, n);
    20a6:	85a6                	mv	a1,s1
    20a8:	00004517          	auipc	a0,0x4
    20ac:	f7850513          	addi	a0,a0,-136 # 6020 <malloc+0xdba>
    20b0:	102030ef          	jal	51b2 <printf>
    exit(1);
    20b4:	4505                	li	a0,1
    20b6:	4c5020ef          	jal	4d7a <exit>
    printf("open(README) failed\n");
    20ba:	00003517          	auipc	a0,0x3
    20be:	4be50513          	addi	a0,a0,1214 # 5578 <malloc+0x312>
    20c2:	0f0030ef          	jal	51b2 <printf>
    exit(1);
    20c6:	4505                	li	a0,1
    20c8:	4b3020ef          	jal	4d7a <exit>
  close(fd);
    20cc:	854a                	mv	a0,s2
    20ce:	4d5020ef          	jal	4da2 <close>
  exit(0);
    20d2:	4501                	li	a0,0
    20d4:	4a7020ef          	jal	4d7a <exit>

00000000000020d8 <sbrkbasic>:
{
    20d8:	7139                	addi	sp,sp,-64
    20da:	fc06                	sd	ra,56(sp)
    20dc:	f822                	sd	s0,48(sp)
    20de:	ec4e                	sd	s3,24(sp)
    20e0:	0080                	addi	s0,sp,64
    20e2:	89aa                	mv	s3,a0
  pid = fork();
    20e4:	48f020ef          	jal	4d72 <fork>
  if(pid < 0){
    20e8:	02054b63          	bltz	a0,211e <sbrkbasic+0x46>
  if(pid == 0){
    20ec:	e939                	bnez	a0,2142 <sbrkbasic+0x6a>
    a = sbrk(TOOMUCH);
    20ee:	40000537          	lui	a0,0x40000
    20f2:	455020ef          	jal	4d46 <sbrk>
    if(a == (char*)SBRK_ERROR){
    20f6:	57fd                	li	a5,-1
    20f8:	02f50f63          	beq	a0,a5,2136 <sbrkbasic+0x5e>
    20fc:	f426                	sd	s1,40(sp)
    20fe:	f04a                	sd	s2,32(sp)
    2100:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    2102:	400007b7          	lui	a5,0x40000
    2106:	97aa                	add	a5,a5,a0
      *b = 99;
    2108:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    210c:	6705                	lui	a4,0x1
      *b = 99;
    210e:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1348>
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    2112:	953a                	add	a0,a0,a4
    2114:	fef51de3          	bne	a0,a5,210e <sbrkbasic+0x36>
    exit(1);
    2118:	4505                	li	a0,1
    211a:	461020ef          	jal	4d7a <exit>
    211e:	f426                	sd	s1,40(sp)
    2120:	f04a                	sd	s2,32(sp)
    2122:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    2124:	00004517          	auipc	a0,0x4
    2128:	f2450513          	addi	a0,a0,-220 # 6048 <malloc+0xde2>
    212c:	086030ef          	jal	51b2 <printf>
    exit(1);
    2130:	4505                	li	a0,1
    2132:	449020ef          	jal	4d7a <exit>
    2136:	f426                	sd	s1,40(sp)
    2138:	f04a                	sd	s2,32(sp)
    213a:	e852                	sd	s4,16(sp)
      exit(0);
    213c:	4501                	li	a0,0
    213e:	43d020ef          	jal	4d7a <exit>
  wait(&xstatus);
    2142:	fcc40513          	addi	a0,s0,-52
    2146:	43d020ef          	jal	4d82 <wait>
  if(xstatus == 1){
    214a:	fcc42703          	lw	a4,-52(s0)
    214e:	4785                	li	a5,1
    2150:	00f70e63          	beq	a4,a5,216c <sbrkbasic+0x94>
    2154:	f426                	sd	s1,40(sp)
    2156:	f04a                	sd	s2,32(sp)
    2158:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    215a:	4501                	li	a0,0
    215c:	3eb020ef          	jal	4d46 <sbrk>
    2160:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2162:	4901                	li	s2,0
    2164:	6a05                	lui	s4,0x1
    2166:	388a0a13          	addi	s4,s4,904 # 1388 <exectest+0x46>
    216a:	a839                	j	2188 <sbrkbasic+0xb0>
    216c:	f426                	sd	s1,40(sp)
    216e:	f04a                	sd	s2,32(sp)
    2170:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    2172:	85ce                	mv	a1,s3
    2174:	00004517          	auipc	a0,0x4
    2178:	ef450513          	addi	a0,a0,-268 # 6068 <malloc+0xe02>
    217c:	036030ef          	jal	51b2 <printf>
    exit(1);
    2180:	4505                	li	a0,1
    2182:	3f9020ef          	jal	4d7a <exit>
    2186:	84be                	mv	s1,a5
    b = sbrk(1);
    2188:	4505                	li	a0,1
    218a:	3bd020ef          	jal	4d46 <sbrk>
    if(b != a){
    218e:	04951263          	bne	a0,s1,21d2 <sbrkbasic+0xfa>
    *b = 1;
    2192:	4785                	li	a5,1
    2194:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2198:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    219c:	2905                	addiw	s2,s2,1
    219e:	ff4914e3          	bne	s2,s4,2186 <sbrkbasic+0xae>
  pid = fork();
    21a2:	3d1020ef          	jal	4d72 <fork>
    21a6:	892a                	mv	s2,a0
  if(pid < 0){
    21a8:	04054263          	bltz	a0,21ec <sbrkbasic+0x114>
  c = sbrk(1);
    21ac:	4505                	li	a0,1
    21ae:	399020ef          	jal	4d46 <sbrk>
  c = sbrk(1);
    21b2:	4505                	li	a0,1
    21b4:	393020ef          	jal	4d46 <sbrk>
  if(c != a + 1){
    21b8:	0489                	addi	s1,s1,2
    21ba:	04a48363          	beq	s1,a0,2200 <sbrkbasic+0x128>
    printf("%s: sbrk test failed post-fork\n", s);
    21be:	85ce                	mv	a1,s3
    21c0:	00004517          	auipc	a0,0x4
    21c4:	f0850513          	addi	a0,a0,-248 # 60c8 <malloc+0xe62>
    21c8:	7eb020ef          	jal	51b2 <printf>
    exit(1);
    21cc:	4505                	li	a0,1
    21ce:	3ad020ef          	jal	4d7a <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    21d2:	872a                	mv	a4,a0
    21d4:	86a6                	mv	a3,s1
    21d6:	864a                	mv	a2,s2
    21d8:	85ce                	mv	a1,s3
    21da:	00004517          	auipc	a0,0x4
    21de:	eae50513          	addi	a0,a0,-338 # 6088 <malloc+0xe22>
    21e2:	7d1020ef          	jal	51b2 <printf>
      exit(1);
    21e6:	4505                	li	a0,1
    21e8:	393020ef          	jal	4d7a <exit>
    printf("%s: sbrk test fork failed\n", s);
    21ec:	85ce                	mv	a1,s3
    21ee:	00004517          	auipc	a0,0x4
    21f2:	eba50513          	addi	a0,a0,-326 # 60a8 <malloc+0xe42>
    21f6:	7bd020ef          	jal	51b2 <printf>
    exit(1);
    21fa:	4505                	li	a0,1
    21fc:	37f020ef          	jal	4d7a <exit>
  if(pid == 0)
    2200:	00091563          	bnez	s2,220a <sbrkbasic+0x132>
    exit(0);
    2204:	4501                	li	a0,0
    2206:	375020ef          	jal	4d7a <exit>
  wait(&xstatus);
    220a:	fcc40513          	addi	a0,s0,-52
    220e:	375020ef          	jal	4d82 <wait>
  exit(xstatus);
    2212:	fcc42503          	lw	a0,-52(s0)
    2216:	365020ef          	jal	4d7a <exit>

000000000000221a <sbrkmuch>:
{
    221a:	7179                	addi	sp,sp,-48
    221c:	f406                	sd	ra,40(sp)
    221e:	f022                	sd	s0,32(sp)
    2220:	ec26                	sd	s1,24(sp)
    2222:	e84a                	sd	s2,16(sp)
    2224:	e44e                	sd	s3,8(sp)
    2226:	e052                	sd	s4,0(sp)
    2228:	1800                	addi	s0,sp,48
    222a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    222c:	4501                	li	a0,0
    222e:	319020ef          	jal	4d46 <sbrk>
    2232:	892a                	mv	s2,a0
  a = sbrk(0);
    2234:	4501                	li	a0,0
    2236:	311020ef          	jal	4d46 <sbrk>
    223a:	84aa                	mv	s1,a0
  p = sbrk(amt);
    223c:	06400537          	lui	a0,0x6400
    2240:	9d05                	subw	a0,a0,s1
    2242:	305020ef          	jal	4d46 <sbrk>
  if (p != a) {
    2246:	08a49763          	bne	s1,a0,22d4 <sbrkmuch+0xba>
  *lastaddr = 99;
    224a:	064007b7          	lui	a5,0x6400
    224e:	06300713          	li	a4,99
    2252:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1347>
  a = sbrk(0);
    2256:	4501                	li	a0,0
    2258:	2ef020ef          	jal	4d46 <sbrk>
    225c:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    225e:	757d                	lui	a0,0xfffff
    2260:	2e7020ef          	jal	4d46 <sbrk>
  if(c == (char*)SBRK_ERROR){
    2264:	57fd                	li	a5,-1
    2266:	08f50163          	beq	a0,a5,22e8 <sbrkmuch+0xce>
  c = sbrk(0);
    226a:	4501                	li	a0,0
    226c:	2db020ef          	jal	4d46 <sbrk>
  if(c != a - PGSIZE){
    2270:	77fd                	lui	a5,0xfffff
    2272:	97a6                	add	a5,a5,s1
    2274:	08f51463          	bne	a0,a5,22fc <sbrkmuch+0xe2>
  a = sbrk(0);
    2278:	4501                	li	a0,0
    227a:	2cd020ef          	jal	4d46 <sbrk>
    227e:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2280:	6505                	lui	a0,0x1
    2282:	2c5020ef          	jal	4d46 <sbrk>
    2286:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2288:	08a49663          	bne	s1,a0,2314 <sbrkmuch+0xfa>
    228c:	4501                	li	a0,0
    228e:	2b9020ef          	jal	4d46 <sbrk>
    2292:	6785                	lui	a5,0x1
    2294:	97a6                	add	a5,a5,s1
    2296:	06f51f63          	bne	a0,a5,2314 <sbrkmuch+0xfa>
  if(*lastaddr == 99){
    229a:	064007b7          	lui	a5,0x6400
    229e:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1347>
    22a2:	06300793          	li	a5,99
    22a6:	08f70363          	beq	a4,a5,232c <sbrkmuch+0x112>
  a = sbrk(0);
    22aa:	4501                	li	a0,0
    22ac:	29b020ef          	jal	4d46 <sbrk>
    22b0:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    22b2:	4501                	li	a0,0
    22b4:	293020ef          	jal	4d46 <sbrk>
    22b8:	40a9053b          	subw	a0,s2,a0
    22bc:	28b020ef          	jal	4d46 <sbrk>
  if(c != a){
    22c0:	08a49063          	bne	s1,a0,2340 <sbrkmuch+0x126>
}
    22c4:	70a2                	ld	ra,40(sp)
    22c6:	7402                	ld	s0,32(sp)
    22c8:	64e2                	ld	s1,24(sp)
    22ca:	6942                	ld	s2,16(sp)
    22cc:	69a2                	ld	s3,8(sp)
    22ce:	6a02                	ld	s4,0(sp)
    22d0:	6145                	addi	sp,sp,48
    22d2:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    22d4:	85ce                	mv	a1,s3
    22d6:	00004517          	auipc	a0,0x4
    22da:	e1250513          	addi	a0,a0,-494 # 60e8 <malloc+0xe82>
    22de:	6d5020ef          	jal	51b2 <printf>
    exit(1);
    22e2:	4505                	li	a0,1
    22e4:	297020ef          	jal	4d7a <exit>
    printf("%s: sbrk could not deallocate\n", s);
    22e8:	85ce                	mv	a1,s3
    22ea:	00004517          	auipc	a0,0x4
    22ee:	e4650513          	addi	a0,a0,-442 # 6130 <malloc+0xeca>
    22f2:	6c1020ef          	jal	51b2 <printf>
    exit(1);
    22f6:	4505                	li	a0,1
    22f8:	283020ef          	jal	4d7a <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    22fc:	86aa                	mv	a3,a0
    22fe:	8626                	mv	a2,s1
    2300:	85ce                	mv	a1,s3
    2302:	00004517          	auipc	a0,0x4
    2306:	e4e50513          	addi	a0,a0,-434 # 6150 <malloc+0xeea>
    230a:	6a9020ef          	jal	51b2 <printf>
    exit(1);
    230e:	4505                	li	a0,1
    2310:	26b020ef          	jal	4d7a <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    2314:	86d2                	mv	a3,s4
    2316:	8626                	mv	a2,s1
    2318:	85ce                	mv	a1,s3
    231a:	00004517          	auipc	a0,0x4
    231e:	e7650513          	addi	a0,a0,-394 # 6190 <malloc+0xf2a>
    2322:	691020ef          	jal	51b2 <printf>
    exit(1);
    2326:	4505                	li	a0,1
    2328:	253020ef          	jal	4d7a <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    232c:	85ce                	mv	a1,s3
    232e:	00004517          	auipc	a0,0x4
    2332:	e9250513          	addi	a0,a0,-366 # 61c0 <malloc+0xf5a>
    2336:	67d020ef          	jal	51b2 <printf>
    exit(1);
    233a:	4505                	li	a0,1
    233c:	23f020ef          	jal	4d7a <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2340:	86aa                	mv	a3,a0
    2342:	8626                	mv	a2,s1
    2344:	85ce                	mv	a1,s3
    2346:	00004517          	auipc	a0,0x4
    234a:	eb250513          	addi	a0,a0,-334 # 61f8 <malloc+0xf92>
    234e:	665020ef          	jal	51b2 <printf>
    exit(1);
    2352:	4505                	li	a0,1
    2354:	227020ef          	jal	4d7a <exit>

0000000000002358 <sbrkarg>:
{
    2358:	7179                	addi	sp,sp,-48
    235a:	f406                	sd	ra,40(sp)
    235c:	f022                	sd	s0,32(sp)
    235e:	ec26                	sd	s1,24(sp)
    2360:	e84a                	sd	s2,16(sp)
    2362:	e44e                	sd	s3,8(sp)
    2364:	1800                	addi	s0,sp,48
    2366:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2368:	6505                	lui	a0,0x1
    236a:	1dd020ef          	jal	4d46 <sbrk>
    236e:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2370:	20100593          	li	a1,513
    2374:	00004517          	auipc	a0,0x4
    2378:	eac50513          	addi	a0,a0,-340 # 6220 <malloc+0xfba>
    237c:	23f020ef          	jal	4dba <open>
    2380:	84aa                	mv	s1,a0
  unlink("sbrk");
    2382:	00004517          	auipc	a0,0x4
    2386:	e9e50513          	addi	a0,a0,-354 # 6220 <malloc+0xfba>
    238a:	241020ef          	jal	4dca <unlink>
  if(fd < 0)  {
    238e:	0204c963          	bltz	s1,23c0 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2392:	6605                	lui	a2,0x1
    2394:	85ca                	mv	a1,s2
    2396:	8526                	mv	a0,s1
    2398:	203020ef          	jal	4d9a <write>
    239c:	02054c63          	bltz	a0,23d4 <sbrkarg+0x7c>
  close(fd);
    23a0:	8526                	mv	a0,s1
    23a2:	201020ef          	jal	4da2 <close>
  a = sbrk(PGSIZE);
    23a6:	6505                	lui	a0,0x1
    23a8:	19f020ef          	jal	4d46 <sbrk>
  if(pipe((int *) a) != 0){
    23ac:	1df020ef          	jal	4d8a <pipe>
    23b0:	ed05                	bnez	a0,23e8 <sbrkarg+0x90>
}
    23b2:	70a2                	ld	ra,40(sp)
    23b4:	7402                	ld	s0,32(sp)
    23b6:	64e2                	ld	s1,24(sp)
    23b8:	6942                	ld	s2,16(sp)
    23ba:	69a2                	ld	s3,8(sp)
    23bc:	6145                	addi	sp,sp,48
    23be:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    23c0:	85ce                	mv	a1,s3
    23c2:	00004517          	auipc	a0,0x4
    23c6:	e6650513          	addi	a0,a0,-410 # 6228 <malloc+0xfc2>
    23ca:	5e9020ef          	jal	51b2 <printf>
    exit(1);
    23ce:	4505                	li	a0,1
    23d0:	1ab020ef          	jal	4d7a <exit>
    printf("%s: write sbrk failed\n", s);
    23d4:	85ce                	mv	a1,s3
    23d6:	00004517          	auipc	a0,0x4
    23da:	e6a50513          	addi	a0,a0,-406 # 6240 <malloc+0xfda>
    23de:	5d5020ef          	jal	51b2 <printf>
    exit(1);
    23e2:	4505                	li	a0,1
    23e4:	197020ef          	jal	4d7a <exit>
    printf("%s: pipe() failed\n", s);
    23e8:	85ce                	mv	a1,s3
    23ea:	00004517          	auipc	a0,0x4
    23ee:	94650513          	addi	a0,a0,-1722 # 5d30 <malloc+0xaca>
    23f2:	5c1020ef          	jal	51b2 <printf>
    exit(1);
    23f6:	4505                	li	a0,1
    23f8:	183020ef          	jal	4d7a <exit>

00000000000023fc <argptest>:
{
    23fc:	1101                	addi	sp,sp,-32
    23fe:	ec06                	sd	ra,24(sp)
    2400:	e822                	sd	s0,16(sp)
    2402:	e426                	sd	s1,8(sp)
    2404:	e04a                	sd	s2,0(sp)
    2406:	1000                	addi	s0,sp,32
    2408:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    240a:	4581                	li	a1,0
    240c:	00004517          	auipc	a0,0x4
    2410:	e4c50513          	addi	a0,a0,-436 # 6258 <malloc+0xff2>
    2414:	1a7020ef          	jal	4dba <open>
  if (fd < 0) {
    2418:	02054563          	bltz	a0,2442 <argptest+0x46>
    241c:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    241e:	4501                	li	a0,0
    2420:	127020ef          	jal	4d46 <sbrk>
    2424:	567d                	li	a2,-1
    2426:	fff50593          	addi	a1,a0,-1
    242a:	8526                	mv	a0,s1
    242c:	167020ef          	jal	4d92 <read>
  close(fd);
    2430:	8526                	mv	a0,s1
    2432:	171020ef          	jal	4da2 <close>
}
    2436:	60e2                	ld	ra,24(sp)
    2438:	6442                	ld	s0,16(sp)
    243a:	64a2                	ld	s1,8(sp)
    243c:	6902                	ld	s2,0(sp)
    243e:	6105                	addi	sp,sp,32
    2440:	8082                	ret
    printf("%s: open failed\n", s);
    2442:	85ca                	mv	a1,s2
    2444:	00003517          	auipc	a0,0x3
    2448:	7fc50513          	addi	a0,a0,2044 # 5c40 <malloc+0x9da>
    244c:	567020ef          	jal	51b2 <printf>
    exit(1);
    2450:	4505                	li	a0,1
    2452:	129020ef          	jal	4d7a <exit>

0000000000002456 <sbrkbugs>:
{
    2456:	1141                	addi	sp,sp,-16
    2458:	e406                	sd	ra,8(sp)
    245a:	e022                	sd	s0,0(sp)
    245c:	0800                	addi	s0,sp,16
  int pid = fork();
    245e:	115020ef          	jal	4d72 <fork>
  if(pid < 0){
    2462:	00054c63          	bltz	a0,247a <sbrkbugs+0x24>
  if(pid == 0){
    2466:	e11d                	bnez	a0,248c <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    2468:	0df020ef          	jal	4d46 <sbrk>
    sbrk(-sz);
    246c:	40a0053b          	negw	a0,a0
    2470:	0d7020ef          	jal	4d46 <sbrk>
    exit(0);
    2474:	4501                	li	a0,0
    2476:	105020ef          	jal	4d7a <exit>
    printf("fork failed\n");
    247a:	00005517          	auipc	a0,0x5
    247e:	d5650513          	addi	a0,a0,-682 # 71d0 <malloc+0x1f6a>
    2482:	531020ef          	jal	51b2 <printf>
    exit(1);
    2486:	4505                	li	a0,1
    2488:	0f3020ef          	jal	4d7a <exit>
  wait(0);
    248c:	4501                	li	a0,0
    248e:	0f5020ef          	jal	4d82 <wait>
  pid = fork();
    2492:	0e1020ef          	jal	4d72 <fork>
  if(pid < 0){
    2496:	00054f63          	bltz	a0,24b4 <sbrkbugs+0x5e>
  if(pid == 0){
    249a:	e515                	bnez	a0,24c6 <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    249c:	0ab020ef          	jal	4d46 <sbrk>
    sbrk(-(sz - 3500));
    24a0:	6785                	lui	a5,0x1
    24a2:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x134>
    24a6:	40a7853b          	subw	a0,a5,a0
    24aa:	09d020ef          	jal	4d46 <sbrk>
    exit(0);
    24ae:	4501                	li	a0,0
    24b0:	0cb020ef          	jal	4d7a <exit>
    printf("fork failed\n");
    24b4:	00005517          	auipc	a0,0x5
    24b8:	d1c50513          	addi	a0,a0,-740 # 71d0 <malloc+0x1f6a>
    24bc:	4f7020ef          	jal	51b2 <printf>
    exit(1);
    24c0:	4505                	li	a0,1
    24c2:	0b9020ef          	jal	4d7a <exit>
  wait(0);
    24c6:	4501                	li	a0,0
    24c8:	0bb020ef          	jal	4d82 <wait>
  pid = fork();
    24cc:	0a7020ef          	jal	4d72 <fork>
  if(pid < 0){
    24d0:	02054263          	bltz	a0,24f4 <sbrkbugs+0x9e>
  if(pid == 0){
    24d4:	e90d                	bnez	a0,2506 <sbrkbugs+0xb0>
    sbrk((10*PGSIZE + 2048) - (uint64)sbrk(0));
    24d6:	071020ef          	jal	4d46 <sbrk>
    24da:	67ad                	lui	a5,0xb
    24dc:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x1258>
    24e0:	40a7853b          	subw	a0,a5,a0
    24e4:	063020ef          	jal	4d46 <sbrk>
    sbrk(-10);
    24e8:	5559                	li	a0,-10
    24ea:	05d020ef          	jal	4d46 <sbrk>
    exit(0);
    24ee:	4501                	li	a0,0
    24f0:	08b020ef          	jal	4d7a <exit>
    printf("fork failed\n");
    24f4:	00005517          	auipc	a0,0x5
    24f8:	cdc50513          	addi	a0,a0,-804 # 71d0 <malloc+0x1f6a>
    24fc:	4b7020ef          	jal	51b2 <printf>
    exit(1);
    2500:	4505                	li	a0,1
    2502:	079020ef          	jal	4d7a <exit>
  wait(0);
    2506:	4501                	li	a0,0
    2508:	07b020ef          	jal	4d82 <wait>
  exit(0);
    250c:	4501                	li	a0,0
    250e:	06d020ef          	jal	4d7a <exit>

0000000000002512 <sbrklast>:
{
    2512:	7179                	addi	sp,sp,-48
    2514:	f406                	sd	ra,40(sp)
    2516:	f022                	sd	s0,32(sp)
    2518:	ec26                	sd	s1,24(sp)
    251a:	e84a                	sd	s2,16(sp)
    251c:	e44e                	sd	s3,8(sp)
    251e:	e052                	sd	s4,0(sp)
    2520:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2522:	4501                	li	a0,0
    2524:	023020ef          	jal	4d46 <sbrk>
  if((top % PGSIZE) != 0)
    2528:	03451793          	slli	a5,a0,0x34
    252c:	ebad                	bnez	a5,259e <sbrklast+0x8c>
  sbrk(PGSIZE);
    252e:	6505                	lui	a0,0x1
    2530:	017020ef          	jal	4d46 <sbrk>
  sbrk(10);
    2534:	4529                	li	a0,10
    2536:	011020ef          	jal	4d46 <sbrk>
  sbrk(-20);
    253a:	5531                	li	a0,-20
    253c:	00b020ef          	jal	4d46 <sbrk>
  top = (uint64) sbrk(0);
    2540:	4501                	li	a0,0
    2542:	005020ef          	jal	4d46 <sbrk>
    2546:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2548:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x11e>
  p[0] = 'x';
    254c:	07800a13          	li	s4,120
    2550:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2554:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2558:	20200593          	li	a1,514
    255c:	854a                	mv	a0,s2
    255e:	05d020ef          	jal	4dba <open>
    2562:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2564:	4605                	li	a2,1
    2566:	85ca                	mv	a1,s2
    2568:	033020ef          	jal	4d9a <write>
  close(fd);
    256c:	854e                	mv	a0,s3
    256e:	035020ef          	jal	4da2 <close>
  fd = open(p, O_RDWR);
    2572:	4589                	li	a1,2
    2574:	854a                	mv	a0,s2
    2576:	045020ef          	jal	4dba <open>
  p[0] = '\0';
    257a:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    257e:	4605                	li	a2,1
    2580:	85ca                	mv	a1,s2
    2582:	011020ef          	jal	4d92 <read>
  if(p[0] != 'x')
    2586:	fc04c783          	lbu	a5,-64(s1)
    258a:	03479263          	bne	a5,s4,25ae <sbrklast+0x9c>
}
    258e:	70a2                	ld	ra,40(sp)
    2590:	7402                	ld	s0,32(sp)
    2592:	64e2                	ld	s1,24(sp)
    2594:	6942                	ld	s2,16(sp)
    2596:	69a2                	ld	s3,8(sp)
    2598:	6a02                	ld	s4,0(sp)
    259a:	6145                	addi	sp,sp,48
    259c:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    259e:	0347d513          	srli	a0,a5,0x34
    25a2:	6785                	lui	a5,0x1
    25a4:	40a7853b          	subw	a0,a5,a0
    25a8:	79e020ef          	jal	4d46 <sbrk>
    25ac:	b749                	j	252e <sbrklast+0x1c>
    exit(1);
    25ae:	4505                	li	a0,1
    25b0:	7ca020ef          	jal	4d7a <exit>

00000000000025b4 <sbrk8000>:
{
    25b4:	1141                	addi	sp,sp,-16
    25b6:	e406                	sd	ra,8(sp)
    25b8:	e022                	sd	s0,0(sp)
    25ba:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    25bc:	80000537          	lui	a0,0x80000
    25c0:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff134c>
    25c2:	784020ef          	jal	4d46 <sbrk>
  volatile char *top = sbrk(0);
    25c6:	4501                	li	a0,0
    25c8:	77e020ef          	jal	4d46 <sbrk>
  *(top-1) = *(top-1) + 1;
    25cc:	fff54783          	lbu	a5,-1(a0)
    25d0:	2785                	addiw	a5,a5,1 # 1001 <pgbug+0x29>
    25d2:	0ff7f793          	zext.b	a5,a5
    25d6:	fef50fa3          	sb	a5,-1(a0)
}
    25da:	60a2                	ld	ra,8(sp)
    25dc:	6402                	ld	s0,0(sp)
    25de:	0141                	addi	sp,sp,16
    25e0:	8082                	ret

00000000000025e2 <execout>:
{
    25e2:	715d                	addi	sp,sp,-80
    25e4:	e486                	sd	ra,72(sp)
    25e6:	e0a2                	sd	s0,64(sp)
    25e8:	fc26                	sd	s1,56(sp)
    25ea:	f84a                	sd	s2,48(sp)
    25ec:	f44e                	sd	s3,40(sp)
    25ee:	f052                	sd	s4,32(sp)
    25f0:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    25f2:	4901                	li	s2,0
    25f4:	49bd                	li	s3,15
    int pid = fork();
    25f6:	77c020ef          	jal	4d72 <fork>
    25fa:	84aa                	mv	s1,a0
    if(pid < 0){
    25fc:	00054c63          	bltz	a0,2614 <execout+0x32>
    } else if(pid == 0){
    2600:	c11d                	beqz	a0,2626 <execout+0x44>
      wait((int*)0);
    2602:	4501                	li	a0,0
    2604:	77e020ef          	jal	4d82 <wait>
  for(int avail = 0; avail < 15; avail++){
    2608:	2905                	addiw	s2,s2,1
    260a:	ff3916e3          	bne	s2,s3,25f6 <execout+0x14>
  exit(0);
    260e:	4501                	li	a0,0
    2610:	76a020ef          	jal	4d7a <exit>
      printf("fork failed\n");
    2614:	00005517          	auipc	a0,0x5
    2618:	bbc50513          	addi	a0,a0,-1092 # 71d0 <malloc+0x1f6a>
    261c:	397020ef          	jal	51b2 <printf>
      exit(1);
    2620:	4505                	li	a0,1
    2622:	758020ef          	jal	4d7a <exit>
        if(a == SBRK_ERROR)
    2626:	59fd                	li	s3,-1
        *(a + PGSIZE - 1) = 1;
    2628:	4a05                	li	s4,1
        char *a = sbrk(PGSIZE);
    262a:	6505                	lui	a0,0x1
    262c:	71a020ef          	jal	4d46 <sbrk>
        if(a == SBRK_ERROR)
    2630:	01350763          	beq	a0,s3,263e <execout+0x5c>
        *(a + PGSIZE - 1) = 1;
    2634:	6785                	lui	a5,0x1
    2636:	953e                	add	a0,a0,a5
    2638:	ff450fa3          	sb	s4,-1(a0) # fff <pgbug+0x27>
      while(1){
    263c:	b7fd                	j	262a <execout+0x48>
      for(int i = 0; i < avail; i++)
    263e:	01205863          	blez	s2,264e <execout+0x6c>
        sbrk(-PGSIZE);
    2642:	757d                	lui	a0,0xfffff
    2644:	702020ef          	jal	4d46 <sbrk>
      for(int i = 0; i < avail; i++)
    2648:	2485                	addiw	s1,s1,1
    264a:	ff249ce3          	bne	s1,s2,2642 <execout+0x60>
      close(1);
    264e:	4505                	li	a0,1
    2650:	752020ef          	jal	4da2 <close>
      char *args[] = { "echo", "x", 0 };
    2654:	00003517          	auipc	a0,0x3
    2658:	d4450513          	addi	a0,a0,-700 # 5398 <malloc+0x132>
    265c:	faa43c23          	sd	a0,-72(s0)
    2660:	00003797          	auipc	a5,0x3
    2664:	da878793          	addi	a5,a5,-600 # 5408 <malloc+0x1a2>
    2668:	fcf43023          	sd	a5,-64(s0)
    266c:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2670:	fb840593          	addi	a1,s0,-72
    2674:	73e020ef          	jal	4db2 <exec>
      exit(0);
    2678:	4501                	li	a0,0
    267a:	700020ef          	jal	4d7a <exit>

000000000000267e <fourteen>:
{
    267e:	1101                	addi	sp,sp,-32
    2680:	ec06                	sd	ra,24(sp)
    2682:	e822                	sd	s0,16(sp)
    2684:	e426                	sd	s1,8(sp)
    2686:	1000                	addi	s0,sp,32
    2688:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    268a:	00004517          	auipc	a0,0x4
    268e:	da650513          	addi	a0,a0,-602 # 6430 <malloc+0x11ca>
    2692:	750020ef          	jal	4de2 <mkdir>
    2696:	e555                	bnez	a0,2742 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    2698:	00004517          	auipc	a0,0x4
    269c:	bf050513          	addi	a0,a0,-1040 # 6288 <malloc+0x1022>
    26a0:	742020ef          	jal	4de2 <mkdir>
    26a4:	e94d                	bnez	a0,2756 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    26a6:	20000593          	li	a1,512
    26aa:	00004517          	auipc	a0,0x4
    26ae:	c3650513          	addi	a0,a0,-970 # 62e0 <malloc+0x107a>
    26b2:	708020ef          	jal	4dba <open>
  if(fd < 0){
    26b6:	0a054a63          	bltz	a0,276a <fourteen+0xec>
  close(fd);
    26ba:	6e8020ef          	jal	4da2 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    26be:	4581                	li	a1,0
    26c0:	00004517          	auipc	a0,0x4
    26c4:	c9850513          	addi	a0,a0,-872 # 6358 <malloc+0x10f2>
    26c8:	6f2020ef          	jal	4dba <open>
  if(fd < 0){
    26cc:	0a054963          	bltz	a0,277e <fourteen+0x100>
  close(fd);
    26d0:	6d2020ef          	jal	4da2 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    26d4:	00004517          	auipc	a0,0x4
    26d8:	cf450513          	addi	a0,a0,-780 # 63c8 <malloc+0x1162>
    26dc:	706020ef          	jal	4de2 <mkdir>
    26e0:	c94d                	beqz	a0,2792 <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    26e2:	00004517          	auipc	a0,0x4
    26e6:	d3e50513          	addi	a0,a0,-706 # 6420 <malloc+0x11ba>
    26ea:	6f8020ef          	jal	4de2 <mkdir>
    26ee:	cd45                	beqz	a0,27a6 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    26f0:	00004517          	auipc	a0,0x4
    26f4:	d3050513          	addi	a0,a0,-720 # 6420 <malloc+0x11ba>
    26f8:	6d2020ef          	jal	4dca <unlink>
  unlink("12345678901234/12345678901234");
    26fc:	00004517          	auipc	a0,0x4
    2700:	ccc50513          	addi	a0,a0,-820 # 63c8 <malloc+0x1162>
    2704:	6c6020ef          	jal	4dca <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2708:	00004517          	auipc	a0,0x4
    270c:	c5050513          	addi	a0,a0,-944 # 6358 <malloc+0x10f2>
    2710:	6ba020ef          	jal	4dca <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2714:	00004517          	auipc	a0,0x4
    2718:	bcc50513          	addi	a0,a0,-1076 # 62e0 <malloc+0x107a>
    271c:	6ae020ef          	jal	4dca <unlink>
  unlink("12345678901234/123456789012345");
    2720:	00004517          	auipc	a0,0x4
    2724:	b6850513          	addi	a0,a0,-1176 # 6288 <malloc+0x1022>
    2728:	6a2020ef          	jal	4dca <unlink>
  unlink("12345678901234");
    272c:	00004517          	auipc	a0,0x4
    2730:	d0450513          	addi	a0,a0,-764 # 6430 <malloc+0x11ca>
    2734:	696020ef          	jal	4dca <unlink>
}
    2738:	60e2                	ld	ra,24(sp)
    273a:	6442                	ld	s0,16(sp)
    273c:	64a2                	ld	s1,8(sp)
    273e:	6105                	addi	sp,sp,32
    2740:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2742:	85a6                	mv	a1,s1
    2744:	00004517          	auipc	a0,0x4
    2748:	b1c50513          	addi	a0,a0,-1252 # 6260 <malloc+0xffa>
    274c:	267020ef          	jal	51b2 <printf>
    exit(1);
    2750:	4505                	li	a0,1
    2752:	628020ef          	jal	4d7a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2756:	85a6                	mv	a1,s1
    2758:	00004517          	auipc	a0,0x4
    275c:	b5050513          	addi	a0,a0,-1200 # 62a8 <malloc+0x1042>
    2760:	253020ef          	jal	51b2 <printf>
    exit(1);
    2764:	4505                	li	a0,1
    2766:	614020ef          	jal	4d7a <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    276a:	85a6                	mv	a1,s1
    276c:	00004517          	auipc	a0,0x4
    2770:	ba450513          	addi	a0,a0,-1116 # 6310 <malloc+0x10aa>
    2774:	23f020ef          	jal	51b2 <printf>
    exit(1);
    2778:	4505                	li	a0,1
    277a:	600020ef          	jal	4d7a <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    277e:	85a6                	mv	a1,s1
    2780:	00004517          	auipc	a0,0x4
    2784:	c0850513          	addi	a0,a0,-1016 # 6388 <malloc+0x1122>
    2788:	22b020ef          	jal	51b2 <printf>
    exit(1);
    278c:	4505                	li	a0,1
    278e:	5ec020ef          	jal	4d7a <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2792:	85a6                	mv	a1,s1
    2794:	00004517          	auipc	a0,0x4
    2798:	c5450513          	addi	a0,a0,-940 # 63e8 <malloc+0x1182>
    279c:	217020ef          	jal	51b2 <printf>
    exit(1);
    27a0:	4505                	li	a0,1
    27a2:	5d8020ef          	jal	4d7a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    27a6:	85a6                	mv	a1,s1
    27a8:	00004517          	auipc	a0,0x4
    27ac:	c9850513          	addi	a0,a0,-872 # 6440 <malloc+0x11da>
    27b0:	203020ef          	jal	51b2 <printf>
    exit(1);
    27b4:	4505                	li	a0,1
    27b6:	5c4020ef          	jal	4d7a <exit>

00000000000027ba <diskfull>:
{
    27ba:	b8010113          	addi	sp,sp,-1152
    27be:	46113c23          	sd	ra,1144(sp)
    27c2:	46813823          	sd	s0,1136(sp)
    27c6:	46913423          	sd	s1,1128(sp)
    27ca:	47213023          	sd	s2,1120(sp)
    27ce:	45313c23          	sd	s3,1112(sp)
    27d2:	45413823          	sd	s4,1104(sp)
    27d6:	45513423          	sd	s5,1096(sp)
    27da:	45613023          	sd	s6,1088(sp)
    27de:	43713c23          	sd	s7,1080(sp)
    27e2:	43813823          	sd	s8,1072(sp)
    27e6:	43913423          	sd	s9,1064(sp)
    27ea:	48010413          	addi	s0,sp,1152
    27ee:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    27f0:	00004517          	auipc	a0,0x4
    27f4:	c8850513          	addi	a0,a0,-888 # 6478 <malloc+0x1212>
    27f8:	5d2020ef          	jal	4dca <unlink>
    27fc:	03000993          	li	s3,48
    name[0] = 'b';
    2800:	06200b93          	li	s7,98
    name[1] = 'i';
    2804:	06900b13          	li	s6,105
    name[2] = 'g';
    2808:	06700a93          	li	s5,103
    280c:	6a41                	lui	s4,0x10
    280e:	10ba0a13          	addi	s4,s4,267 # 1010b <base+0x1453>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2812:	07f00c13          	li	s8,127
    2816:	aab9                	j	2974 <diskfull+0x1ba>
      printf("%s: could not create file %s\n", s, name);
    2818:	b8040613          	addi	a2,s0,-1152
    281c:	85e6                	mv	a1,s9
    281e:	00004517          	auipc	a0,0x4
    2822:	c6a50513          	addi	a0,a0,-918 # 6488 <malloc+0x1222>
    2826:	18d020ef          	jal	51b2 <printf>
      break;
    282a:	a039                	j	2838 <diskfull+0x7e>
        close(fd);
    282c:	854a                	mv	a0,s2
    282e:	574020ef          	jal	4da2 <close>
    close(fd);
    2832:	854a                	mv	a0,s2
    2834:	56e020ef          	jal	4da2 <close>
  for(int i = 0; i < nzz; i++){
    2838:	4481                	li	s1,0
    name[0] = 'z';
    283a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    283e:	08000993          	li	s3,128
    name[0] = 'z';
    2842:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    2846:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    284a:	41f4d71b          	sraiw	a4,s1,0x1f
    284e:	01b7571b          	srliw	a4,a4,0x1b
    2852:	009707bb          	addw	a5,a4,s1
    2856:	4057d69b          	sraiw	a3,a5,0x5
    285a:	0306869b          	addiw	a3,a3,48
    285e:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    2862:	8bfd                	andi	a5,a5,31
    2864:	9f99                	subw	a5,a5,a4
    2866:	0307879b          	addiw	a5,a5,48
    286a:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    286e:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2872:	ba040513          	addi	a0,s0,-1120
    2876:	554020ef          	jal	4dca <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    287a:	60200593          	li	a1,1538
    287e:	ba040513          	addi	a0,s0,-1120
    2882:	538020ef          	jal	4dba <open>
    if(fd < 0)
    2886:	00054763          	bltz	a0,2894 <diskfull+0xda>
    close(fd);
    288a:	518020ef          	jal	4da2 <close>
  for(int i = 0; i < nzz; i++){
    288e:	2485                	addiw	s1,s1,1
    2890:	fb3499e3          	bne	s1,s3,2842 <diskfull+0x88>
  if(mkdir("diskfulldir") == 0)
    2894:	00004517          	auipc	a0,0x4
    2898:	be450513          	addi	a0,a0,-1052 # 6478 <malloc+0x1212>
    289c:	546020ef          	jal	4de2 <mkdir>
    28a0:	12050063          	beqz	a0,29c0 <diskfull+0x206>
  unlink("diskfulldir");
    28a4:	00004517          	auipc	a0,0x4
    28a8:	bd450513          	addi	a0,a0,-1068 # 6478 <malloc+0x1212>
    28ac:	51e020ef          	jal	4dca <unlink>
  for(int i = 0; i < nzz; i++){
    28b0:	4481                	li	s1,0
    name[0] = 'z';
    28b2:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    28b6:	08000993          	li	s3,128
    name[0] = 'z';
    28ba:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    28be:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    28c2:	41f4d71b          	sraiw	a4,s1,0x1f
    28c6:	01b7571b          	srliw	a4,a4,0x1b
    28ca:	009707bb          	addw	a5,a4,s1
    28ce:	4057d69b          	sraiw	a3,a5,0x5
    28d2:	0306869b          	addiw	a3,a3,48
    28d6:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    28da:	8bfd                	andi	a5,a5,31
    28dc:	9f99                	subw	a5,a5,a4
    28de:	0307879b          	addiw	a5,a5,48
    28e2:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    28e6:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28ea:	ba040513          	addi	a0,s0,-1120
    28ee:	4dc020ef          	jal	4dca <unlink>
  for(int i = 0; i < nzz; i++){
    28f2:	2485                	addiw	s1,s1,1
    28f4:	fd3493e3          	bne	s1,s3,28ba <diskfull+0x100>
    28f8:	03000493          	li	s1,48
    name[0] = 'b';
    28fc:	06200a93          	li	s5,98
    name[1] = 'i';
    2900:	06900a13          	li	s4,105
    name[2] = 'g';
    2904:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    2908:	07f00913          	li	s2,127
    name[0] = 'b';
    290c:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    2910:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    2914:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    2918:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    291c:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2920:	ba040513          	addi	a0,s0,-1120
    2924:	4a6020ef          	jal	4dca <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    2928:	2485                	addiw	s1,s1,1
    292a:	0ff4f493          	zext.b	s1,s1
    292e:	fd249fe3          	bne	s1,s2,290c <diskfull+0x152>
}
    2932:	47813083          	ld	ra,1144(sp)
    2936:	47013403          	ld	s0,1136(sp)
    293a:	46813483          	ld	s1,1128(sp)
    293e:	46013903          	ld	s2,1120(sp)
    2942:	45813983          	ld	s3,1112(sp)
    2946:	45013a03          	ld	s4,1104(sp)
    294a:	44813a83          	ld	s5,1096(sp)
    294e:	44013b03          	ld	s6,1088(sp)
    2952:	43813b83          	ld	s7,1080(sp)
    2956:	43013c03          	ld	s8,1072(sp)
    295a:	42813c83          	ld	s9,1064(sp)
    295e:	48010113          	addi	sp,sp,1152
    2962:	8082                	ret
    close(fd);
    2964:	854a                	mv	a0,s2
    2966:	43c020ef          	jal	4da2 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    296a:	2985                	addiw	s3,s3,1
    296c:	0ff9f993          	zext.b	s3,s3
    2970:	ed8984e3          	beq	s3,s8,2838 <diskfull+0x7e>
    name[0] = 'b';
    2974:	b9740023          	sb	s7,-1152(s0)
    name[1] = 'i';
    2978:	b96400a3          	sb	s6,-1151(s0)
    name[2] = 'g';
    297c:	b9540123          	sb	s5,-1150(s0)
    name[3] = '0' + fi;
    2980:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    2984:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    2988:	b8040513          	addi	a0,s0,-1152
    298c:	43e020ef          	jal	4dca <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2990:	60200593          	li	a1,1538
    2994:	b8040513          	addi	a0,s0,-1152
    2998:	422020ef          	jal	4dba <open>
    299c:	892a                	mv	s2,a0
    if(fd < 0){
    299e:	e6054de3          	bltz	a0,2818 <diskfull+0x5e>
    29a2:	84d2                	mv	s1,s4
      if(write(fd, buf, BSIZE) != BSIZE){
    29a4:	40000613          	li	a2,1024
    29a8:	ba040593          	addi	a1,s0,-1120
    29ac:	854a                	mv	a0,s2
    29ae:	3ec020ef          	jal	4d9a <write>
    29b2:	40000793          	li	a5,1024
    29b6:	e6f51be3          	bne	a0,a5,282c <diskfull+0x72>
    for(int i = 0; i < MAXFILE; i++){
    29ba:	34fd                	addiw	s1,s1,-1
    29bc:	f4e5                	bnez	s1,29a4 <diskfull+0x1ea>
    29be:	b75d                	j	2964 <diskfull+0x1aa>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    29c0:	85e6                	mv	a1,s9
    29c2:	00004517          	auipc	a0,0x4
    29c6:	ae650513          	addi	a0,a0,-1306 # 64a8 <malloc+0x1242>
    29ca:	7e8020ef          	jal	51b2 <printf>
    29ce:	bdd9                	j	28a4 <diskfull+0xea>

00000000000029d0 <iputtest>:
{
    29d0:	1101                	addi	sp,sp,-32
    29d2:	ec06                	sd	ra,24(sp)
    29d4:	e822                	sd	s0,16(sp)
    29d6:	e426                	sd	s1,8(sp)
    29d8:	1000                	addi	s0,sp,32
    29da:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    29dc:	00004517          	auipc	a0,0x4
    29e0:	afc50513          	addi	a0,a0,-1284 # 64d8 <malloc+0x1272>
    29e4:	3fe020ef          	jal	4de2 <mkdir>
    29e8:	02054f63          	bltz	a0,2a26 <iputtest+0x56>
  if(chdir("iputdir") < 0){
    29ec:	00004517          	auipc	a0,0x4
    29f0:	aec50513          	addi	a0,a0,-1300 # 64d8 <malloc+0x1272>
    29f4:	3f6020ef          	jal	4dea <chdir>
    29f8:	04054163          	bltz	a0,2a3a <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    29fc:	00004517          	auipc	a0,0x4
    2a00:	b1c50513          	addi	a0,a0,-1252 # 6518 <malloc+0x12b2>
    2a04:	3c6020ef          	jal	4dca <unlink>
    2a08:	04054363          	bltz	a0,2a4e <iputtest+0x7e>
  if(chdir("/") < 0){
    2a0c:	00004517          	auipc	a0,0x4
    2a10:	b3c50513          	addi	a0,a0,-1220 # 6548 <malloc+0x12e2>
    2a14:	3d6020ef          	jal	4dea <chdir>
    2a18:	04054563          	bltz	a0,2a62 <iputtest+0x92>
}
    2a1c:	60e2                	ld	ra,24(sp)
    2a1e:	6442                	ld	s0,16(sp)
    2a20:	64a2                	ld	s1,8(sp)
    2a22:	6105                	addi	sp,sp,32
    2a24:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2a26:	85a6                	mv	a1,s1
    2a28:	00004517          	auipc	a0,0x4
    2a2c:	ab850513          	addi	a0,a0,-1352 # 64e0 <malloc+0x127a>
    2a30:	782020ef          	jal	51b2 <printf>
    exit(1);
    2a34:	4505                	li	a0,1
    2a36:	344020ef          	jal	4d7a <exit>
    printf("%s: chdir iputdir failed\n", s);
    2a3a:	85a6                	mv	a1,s1
    2a3c:	00004517          	auipc	a0,0x4
    2a40:	abc50513          	addi	a0,a0,-1348 # 64f8 <malloc+0x1292>
    2a44:	76e020ef          	jal	51b2 <printf>
    exit(1);
    2a48:	4505                	li	a0,1
    2a4a:	330020ef          	jal	4d7a <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a4e:	85a6                	mv	a1,s1
    2a50:	00004517          	auipc	a0,0x4
    2a54:	ad850513          	addi	a0,a0,-1320 # 6528 <malloc+0x12c2>
    2a58:	75a020ef          	jal	51b2 <printf>
    exit(1);
    2a5c:	4505                	li	a0,1
    2a5e:	31c020ef          	jal	4d7a <exit>
    printf("%s: chdir / failed\n", s);
    2a62:	85a6                	mv	a1,s1
    2a64:	00004517          	auipc	a0,0x4
    2a68:	aec50513          	addi	a0,a0,-1300 # 6550 <malloc+0x12ea>
    2a6c:	746020ef          	jal	51b2 <printf>
    exit(1);
    2a70:	4505                	li	a0,1
    2a72:	308020ef          	jal	4d7a <exit>

0000000000002a76 <exitiputtest>:
{
    2a76:	7179                	addi	sp,sp,-48
    2a78:	f406                	sd	ra,40(sp)
    2a7a:	f022                	sd	s0,32(sp)
    2a7c:	ec26                	sd	s1,24(sp)
    2a7e:	1800                	addi	s0,sp,48
    2a80:	84aa                	mv	s1,a0
  pid = fork();
    2a82:	2f0020ef          	jal	4d72 <fork>
  if(pid < 0){
    2a86:	02054e63          	bltz	a0,2ac2 <exitiputtest+0x4c>
  if(pid == 0){
    2a8a:	e541                	bnez	a0,2b12 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2a8c:	00004517          	auipc	a0,0x4
    2a90:	a4c50513          	addi	a0,a0,-1460 # 64d8 <malloc+0x1272>
    2a94:	34e020ef          	jal	4de2 <mkdir>
    2a98:	02054f63          	bltz	a0,2ad6 <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2a9c:	00004517          	auipc	a0,0x4
    2aa0:	a3c50513          	addi	a0,a0,-1476 # 64d8 <malloc+0x1272>
    2aa4:	346020ef          	jal	4dea <chdir>
    2aa8:	04054163          	bltz	a0,2aea <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2aac:	00004517          	auipc	a0,0x4
    2ab0:	a6c50513          	addi	a0,a0,-1428 # 6518 <malloc+0x12b2>
    2ab4:	316020ef          	jal	4dca <unlink>
    2ab8:	04054363          	bltz	a0,2afe <exitiputtest+0x88>
    exit(0);
    2abc:	4501                	li	a0,0
    2abe:	2bc020ef          	jal	4d7a <exit>
    printf("%s: fork failed\n", s);
    2ac2:	85a6                	mv	a1,s1
    2ac4:	00003517          	auipc	a0,0x3
    2ac8:	16450513          	addi	a0,a0,356 # 5c28 <malloc+0x9c2>
    2acc:	6e6020ef          	jal	51b2 <printf>
    exit(1);
    2ad0:	4505                	li	a0,1
    2ad2:	2a8020ef          	jal	4d7a <exit>
      printf("%s: mkdir failed\n", s);
    2ad6:	85a6                	mv	a1,s1
    2ad8:	00004517          	auipc	a0,0x4
    2adc:	a0850513          	addi	a0,a0,-1528 # 64e0 <malloc+0x127a>
    2ae0:	6d2020ef          	jal	51b2 <printf>
      exit(1);
    2ae4:	4505                	li	a0,1
    2ae6:	294020ef          	jal	4d7a <exit>
      printf("%s: child chdir failed\n", s);
    2aea:	85a6                	mv	a1,s1
    2aec:	00004517          	auipc	a0,0x4
    2af0:	a7c50513          	addi	a0,a0,-1412 # 6568 <malloc+0x1302>
    2af4:	6be020ef          	jal	51b2 <printf>
      exit(1);
    2af8:	4505                	li	a0,1
    2afa:	280020ef          	jal	4d7a <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2afe:	85a6                	mv	a1,s1
    2b00:	00004517          	auipc	a0,0x4
    2b04:	a2850513          	addi	a0,a0,-1496 # 6528 <malloc+0x12c2>
    2b08:	6aa020ef          	jal	51b2 <printf>
      exit(1);
    2b0c:	4505                	li	a0,1
    2b0e:	26c020ef          	jal	4d7a <exit>
  wait(&xstatus);
    2b12:	fdc40513          	addi	a0,s0,-36
    2b16:	26c020ef          	jal	4d82 <wait>
  exit(xstatus);
    2b1a:	fdc42503          	lw	a0,-36(s0)
    2b1e:	25c020ef          	jal	4d7a <exit>

0000000000002b22 <dirtest>:
{
    2b22:	1101                	addi	sp,sp,-32
    2b24:	ec06                	sd	ra,24(sp)
    2b26:	e822                	sd	s0,16(sp)
    2b28:	e426                	sd	s1,8(sp)
    2b2a:	1000                	addi	s0,sp,32
    2b2c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2b2e:	00004517          	auipc	a0,0x4
    2b32:	a5250513          	addi	a0,a0,-1454 # 6580 <malloc+0x131a>
    2b36:	2ac020ef          	jal	4de2 <mkdir>
    2b3a:	02054f63          	bltz	a0,2b78 <dirtest+0x56>
  if(chdir("dir0") < 0){
    2b3e:	00004517          	auipc	a0,0x4
    2b42:	a4250513          	addi	a0,a0,-1470 # 6580 <malloc+0x131a>
    2b46:	2a4020ef          	jal	4dea <chdir>
    2b4a:	04054163          	bltz	a0,2b8c <dirtest+0x6a>
  if(chdir("..") < 0){
    2b4e:	00004517          	auipc	a0,0x4
    2b52:	a5250513          	addi	a0,a0,-1454 # 65a0 <malloc+0x133a>
    2b56:	294020ef          	jal	4dea <chdir>
    2b5a:	04054363          	bltz	a0,2ba0 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2b5e:	00004517          	auipc	a0,0x4
    2b62:	a2250513          	addi	a0,a0,-1502 # 6580 <malloc+0x131a>
    2b66:	264020ef          	jal	4dca <unlink>
    2b6a:	04054563          	bltz	a0,2bb4 <dirtest+0x92>
}
    2b6e:	60e2                	ld	ra,24(sp)
    2b70:	6442                	ld	s0,16(sp)
    2b72:	64a2                	ld	s1,8(sp)
    2b74:	6105                	addi	sp,sp,32
    2b76:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b78:	85a6                	mv	a1,s1
    2b7a:	00004517          	auipc	a0,0x4
    2b7e:	96650513          	addi	a0,a0,-1690 # 64e0 <malloc+0x127a>
    2b82:	630020ef          	jal	51b2 <printf>
    exit(1);
    2b86:	4505                	li	a0,1
    2b88:	1f2020ef          	jal	4d7a <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b8c:	85a6                	mv	a1,s1
    2b8e:	00004517          	auipc	a0,0x4
    2b92:	9fa50513          	addi	a0,a0,-1542 # 6588 <malloc+0x1322>
    2b96:	61c020ef          	jal	51b2 <printf>
    exit(1);
    2b9a:	4505                	li	a0,1
    2b9c:	1de020ef          	jal	4d7a <exit>
    printf("%s: chdir .. failed\n", s);
    2ba0:	85a6                	mv	a1,s1
    2ba2:	00004517          	auipc	a0,0x4
    2ba6:	a0650513          	addi	a0,a0,-1530 # 65a8 <malloc+0x1342>
    2baa:	608020ef          	jal	51b2 <printf>
    exit(1);
    2bae:	4505                	li	a0,1
    2bb0:	1ca020ef          	jal	4d7a <exit>
    printf("%s: unlink dir0 failed\n", s);
    2bb4:	85a6                	mv	a1,s1
    2bb6:	00004517          	auipc	a0,0x4
    2bba:	a0a50513          	addi	a0,a0,-1526 # 65c0 <malloc+0x135a>
    2bbe:	5f4020ef          	jal	51b2 <printf>
    exit(1);
    2bc2:	4505                	li	a0,1
    2bc4:	1b6020ef          	jal	4d7a <exit>

0000000000002bc8 <subdir>:
{
    2bc8:	1101                	addi	sp,sp,-32
    2bca:	ec06                	sd	ra,24(sp)
    2bcc:	e822                	sd	s0,16(sp)
    2bce:	e426                	sd	s1,8(sp)
    2bd0:	e04a                	sd	s2,0(sp)
    2bd2:	1000                	addi	s0,sp,32
    2bd4:	892a                	mv	s2,a0
  unlink("ff");
    2bd6:	00004517          	auipc	a0,0x4
    2bda:	b3250513          	addi	a0,a0,-1230 # 6708 <malloc+0x14a2>
    2bde:	1ec020ef          	jal	4dca <unlink>
  if(mkdir("dd") != 0){
    2be2:	00004517          	auipc	a0,0x4
    2be6:	9f650513          	addi	a0,a0,-1546 # 65d8 <malloc+0x1372>
    2bea:	1f8020ef          	jal	4de2 <mkdir>
    2bee:	2e051263          	bnez	a0,2ed2 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2bf2:	20200593          	li	a1,514
    2bf6:	00004517          	auipc	a0,0x4
    2bfa:	a0250513          	addi	a0,a0,-1534 # 65f8 <malloc+0x1392>
    2bfe:	1bc020ef          	jal	4dba <open>
    2c02:	84aa                	mv	s1,a0
  if(fd < 0){
    2c04:	2e054163          	bltz	a0,2ee6 <subdir+0x31e>
  write(fd, "ff", 2);
    2c08:	4609                	li	a2,2
    2c0a:	00004597          	auipc	a1,0x4
    2c0e:	afe58593          	addi	a1,a1,-1282 # 6708 <malloc+0x14a2>
    2c12:	188020ef          	jal	4d9a <write>
  close(fd);
    2c16:	8526                	mv	a0,s1
    2c18:	18a020ef          	jal	4da2 <close>
  if(unlink("dd") >= 0){
    2c1c:	00004517          	auipc	a0,0x4
    2c20:	9bc50513          	addi	a0,a0,-1604 # 65d8 <malloc+0x1372>
    2c24:	1a6020ef          	jal	4dca <unlink>
    2c28:	2c055963          	bgez	a0,2efa <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2c2c:	00004517          	auipc	a0,0x4
    2c30:	a2450513          	addi	a0,a0,-1500 # 6650 <malloc+0x13ea>
    2c34:	1ae020ef          	jal	4de2 <mkdir>
    2c38:	2c051b63          	bnez	a0,2f0e <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2c3c:	20200593          	li	a1,514
    2c40:	00004517          	auipc	a0,0x4
    2c44:	a3850513          	addi	a0,a0,-1480 # 6678 <malloc+0x1412>
    2c48:	172020ef          	jal	4dba <open>
    2c4c:	84aa                	mv	s1,a0
  if(fd < 0){
    2c4e:	2c054a63          	bltz	a0,2f22 <subdir+0x35a>
  write(fd, "FF", 2);
    2c52:	4609                	li	a2,2
    2c54:	00004597          	auipc	a1,0x4
    2c58:	a5458593          	addi	a1,a1,-1452 # 66a8 <malloc+0x1442>
    2c5c:	13e020ef          	jal	4d9a <write>
  close(fd);
    2c60:	8526                	mv	a0,s1
    2c62:	140020ef          	jal	4da2 <close>
  fd = open("dd/dd/../ff", 0);
    2c66:	4581                	li	a1,0
    2c68:	00004517          	auipc	a0,0x4
    2c6c:	a4850513          	addi	a0,a0,-1464 # 66b0 <malloc+0x144a>
    2c70:	14a020ef          	jal	4dba <open>
    2c74:	84aa                	mv	s1,a0
  if(fd < 0){
    2c76:	2c054063          	bltz	a0,2f36 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c7a:	660d                	lui	a2,0x3
    2c7c:	00009597          	auipc	a1,0x9
    2c80:	03c58593          	addi	a1,a1,60 # bcb8 <buf>
    2c84:	10e020ef          	jal	4d92 <read>
  if(cc != 2 || buf[0] != 'f'){
    2c88:	4789                	li	a5,2
    2c8a:	2cf51063          	bne	a0,a5,2f4a <subdir+0x382>
    2c8e:	00009717          	auipc	a4,0x9
    2c92:	02a74703          	lbu	a4,42(a4) # bcb8 <buf>
    2c96:	06600793          	li	a5,102
    2c9a:	2af71863          	bne	a4,a5,2f4a <subdir+0x382>
  close(fd);
    2c9e:	8526                	mv	a0,s1
    2ca0:	102020ef          	jal	4da2 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2ca4:	00004597          	auipc	a1,0x4
    2ca8:	a5c58593          	addi	a1,a1,-1444 # 6700 <malloc+0x149a>
    2cac:	00004517          	auipc	a0,0x4
    2cb0:	9cc50513          	addi	a0,a0,-1588 # 6678 <malloc+0x1412>
    2cb4:	126020ef          	jal	4dda <link>
    2cb8:	2a051363          	bnez	a0,2f5e <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2cbc:	00004517          	auipc	a0,0x4
    2cc0:	9bc50513          	addi	a0,a0,-1604 # 6678 <malloc+0x1412>
    2cc4:	106020ef          	jal	4dca <unlink>
    2cc8:	2a051563          	bnez	a0,2f72 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2ccc:	4581                	li	a1,0
    2cce:	00004517          	auipc	a0,0x4
    2cd2:	9aa50513          	addi	a0,a0,-1622 # 6678 <malloc+0x1412>
    2cd6:	0e4020ef          	jal	4dba <open>
    2cda:	2a055663          	bgez	a0,2f86 <subdir+0x3be>
  if(chdir("dd") != 0){
    2cde:	00004517          	auipc	a0,0x4
    2ce2:	8fa50513          	addi	a0,a0,-1798 # 65d8 <malloc+0x1372>
    2ce6:	104020ef          	jal	4dea <chdir>
    2cea:	2a051863          	bnez	a0,2f9a <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2cee:	00004517          	auipc	a0,0x4
    2cf2:	aaa50513          	addi	a0,a0,-1366 # 6798 <malloc+0x1532>
    2cf6:	0f4020ef          	jal	4dea <chdir>
    2cfa:	2a051a63          	bnez	a0,2fae <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2cfe:	00004517          	auipc	a0,0x4
    2d02:	aca50513          	addi	a0,a0,-1334 # 67c8 <malloc+0x1562>
    2d06:	0e4020ef          	jal	4dea <chdir>
    2d0a:	2a051c63          	bnez	a0,2fc2 <subdir+0x3fa>
  if(chdir("./..") != 0){
    2d0e:	00004517          	auipc	a0,0x4
    2d12:	af250513          	addi	a0,a0,-1294 # 6800 <malloc+0x159a>
    2d16:	0d4020ef          	jal	4dea <chdir>
    2d1a:	2a051e63          	bnez	a0,2fd6 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2d1e:	4581                	li	a1,0
    2d20:	00004517          	auipc	a0,0x4
    2d24:	9e050513          	addi	a0,a0,-1568 # 6700 <malloc+0x149a>
    2d28:	092020ef          	jal	4dba <open>
    2d2c:	84aa                	mv	s1,a0
  if(fd < 0){
    2d2e:	2a054e63          	bltz	a0,2fea <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2d32:	660d                	lui	a2,0x3
    2d34:	00009597          	auipc	a1,0x9
    2d38:	f8458593          	addi	a1,a1,-124 # bcb8 <buf>
    2d3c:	056020ef          	jal	4d92 <read>
    2d40:	4789                	li	a5,2
    2d42:	2af51e63          	bne	a0,a5,2ffe <subdir+0x436>
  close(fd);
    2d46:	8526                	mv	a0,s1
    2d48:	05a020ef          	jal	4da2 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d4c:	4581                	li	a1,0
    2d4e:	00004517          	auipc	a0,0x4
    2d52:	92a50513          	addi	a0,a0,-1750 # 6678 <malloc+0x1412>
    2d56:	064020ef          	jal	4dba <open>
    2d5a:	2a055c63          	bgez	a0,3012 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2d5e:	20200593          	li	a1,514
    2d62:	00004517          	auipc	a0,0x4
    2d66:	b2e50513          	addi	a0,a0,-1234 # 6890 <malloc+0x162a>
    2d6a:	050020ef          	jal	4dba <open>
    2d6e:	2a055c63          	bgez	a0,3026 <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2d72:	20200593          	li	a1,514
    2d76:	00004517          	auipc	a0,0x4
    2d7a:	b4a50513          	addi	a0,a0,-1206 # 68c0 <malloc+0x165a>
    2d7e:	03c020ef          	jal	4dba <open>
    2d82:	2a055c63          	bgez	a0,303a <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2d86:	20000593          	li	a1,512
    2d8a:	00004517          	auipc	a0,0x4
    2d8e:	84e50513          	addi	a0,a0,-1970 # 65d8 <malloc+0x1372>
    2d92:	028020ef          	jal	4dba <open>
    2d96:	2a055c63          	bgez	a0,304e <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2d9a:	4589                	li	a1,2
    2d9c:	00004517          	auipc	a0,0x4
    2da0:	83c50513          	addi	a0,a0,-1988 # 65d8 <malloc+0x1372>
    2da4:	016020ef          	jal	4dba <open>
    2da8:	2a055d63          	bgez	a0,3062 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2dac:	4585                	li	a1,1
    2dae:	00004517          	auipc	a0,0x4
    2db2:	82a50513          	addi	a0,a0,-2006 # 65d8 <malloc+0x1372>
    2db6:	004020ef          	jal	4dba <open>
    2dba:	2a055e63          	bgez	a0,3076 <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2dbe:	00004597          	auipc	a1,0x4
    2dc2:	b9258593          	addi	a1,a1,-1134 # 6950 <malloc+0x16ea>
    2dc6:	00004517          	auipc	a0,0x4
    2dca:	aca50513          	addi	a0,a0,-1334 # 6890 <malloc+0x162a>
    2dce:	00c020ef          	jal	4dda <link>
    2dd2:	2a050c63          	beqz	a0,308a <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2dd6:	00004597          	auipc	a1,0x4
    2dda:	b7a58593          	addi	a1,a1,-1158 # 6950 <malloc+0x16ea>
    2dde:	00004517          	auipc	a0,0x4
    2de2:	ae250513          	addi	a0,a0,-1310 # 68c0 <malloc+0x165a>
    2de6:	7f5010ef          	jal	4dda <link>
    2dea:	2a050a63          	beqz	a0,309e <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2dee:	00004597          	auipc	a1,0x4
    2df2:	91258593          	addi	a1,a1,-1774 # 6700 <malloc+0x149a>
    2df6:	00004517          	auipc	a0,0x4
    2dfa:	80250513          	addi	a0,a0,-2046 # 65f8 <malloc+0x1392>
    2dfe:	7dd010ef          	jal	4dda <link>
    2e02:	2a050863          	beqz	a0,30b2 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2e06:	00004517          	auipc	a0,0x4
    2e0a:	a8a50513          	addi	a0,a0,-1398 # 6890 <malloc+0x162a>
    2e0e:	7d5010ef          	jal	4de2 <mkdir>
    2e12:	2a050a63          	beqz	a0,30c6 <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2e16:	00004517          	auipc	a0,0x4
    2e1a:	aaa50513          	addi	a0,a0,-1366 # 68c0 <malloc+0x165a>
    2e1e:	7c5010ef          	jal	4de2 <mkdir>
    2e22:	2a050c63          	beqz	a0,30da <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2e26:	00004517          	auipc	a0,0x4
    2e2a:	8da50513          	addi	a0,a0,-1830 # 6700 <malloc+0x149a>
    2e2e:	7b5010ef          	jal	4de2 <mkdir>
    2e32:	2a050e63          	beqz	a0,30ee <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2e36:	00004517          	auipc	a0,0x4
    2e3a:	a8a50513          	addi	a0,a0,-1398 # 68c0 <malloc+0x165a>
    2e3e:	78d010ef          	jal	4dca <unlink>
    2e42:	2c050063          	beqz	a0,3102 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2e46:	00004517          	auipc	a0,0x4
    2e4a:	a4a50513          	addi	a0,a0,-1462 # 6890 <malloc+0x162a>
    2e4e:	77d010ef          	jal	4dca <unlink>
    2e52:	2c050263          	beqz	a0,3116 <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2e56:	00003517          	auipc	a0,0x3
    2e5a:	7a250513          	addi	a0,a0,1954 # 65f8 <malloc+0x1392>
    2e5e:	78d010ef          	jal	4dea <chdir>
    2e62:	2c050463          	beqz	a0,312a <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2e66:	00004517          	auipc	a0,0x4
    2e6a:	c3a50513          	addi	a0,a0,-966 # 6aa0 <malloc+0x183a>
    2e6e:	77d010ef          	jal	4dea <chdir>
    2e72:	2c050663          	beqz	a0,313e <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2e76:	00004517          	auipc	a0,0x4
    2e7a:	88a50513          	addi	a0,a0,-1910 # 6700 <malloc+0x149a>
    2e7e:	74d010ef          	jal	4dca <unlink>
    2e82:	2c051863          	bnez	a0,3152 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2e86:	00003517          	auipc	a0,0x3
    2e8a:	77250513          	addi	a0,a0,1906 # 65f8 <malloc+0x1392>
    2e8e:	73d010ef          	jal	4dca <unlink>
    2e92:	2c051a63          	bnez	a0,3166 <subdir+0x59e>
  if(unlink("dd") == 0){
    2e96:	00003517          	auipc	a0,0x3
    2e9a:	74250513          	addi	a0,a0,1858 # 65d8 <malloc+0x1372>
    2e9e:	72d010ef          	jal	4dca <unlink>
    2ea2:	2c050c63          	beqz	a0,317a <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2ea6:	00004517          	auipc	a0,0x4
    2eaa:	c6a50513          	addi	a0,a0,-918 # 6b10 <malloc+0x18aa>
    2eae:	71d010ef          	jal	4dca <unlink>
    2eb2:	2c054e63          	bltz	a0,318e <subdir+0x5c6>
  if(unlink("dd") < 0){
    2eb6:	00003517          	auipc	a0,0x3
    2eba:	72250513          	addi	a0,a0,1826 # 65d8 <malloc+0x1372>
    2ebe:	70d010ef          	jal	4dca <unlink>
    2ec2:	2e054063          	bltz	a0,31a2 <subdir+0x5da>
}
    2ec6:	60e2                	ld	ra,24(sp)
    2ec8:	6442                	ld	s0,16(sp)
    2eca:	64a2                	ld	s1,8(sp)
    2ecc:	6902                	ld	s2,0(sp)
    2ece:	6105                	addi	sp,sp,32
    2ed0:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2ed2:	85ca                	mv	a1,s2
    2ed4:	00003517          	auipc	a0,0x3
    2ed8:	70c50513          	addi	a0,a0,1804 # 65e0 <malloc+0x137a>
    2edc:	2d6020ef          	jal	51b2 <printf>
    exit(1);
    2ee0:	4505                	li	a0,1
    2ee2:	699010ef          	jal	4d7a <exit>
    printf("%s: create dd/ff failed\n", s);
    2ee6:	85ca                	mv	a1,s2
    2ee8:	00003517          	auipc	a0,0x3
    2eec:	71850513          	addi	a0,a0,1816 # 6600 <malloc+0x139a>
    2ef0:	2c2020ef          	jal	51b2 <printf>
    exit(1);
    2ef4:	4505                	li	a0,1
    2ef6:	685010ef          	jal	4d7a <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2efa:	85ca                	mv	a1,s2
    2efc:	00003517          	auipc	a0,0x3
    2f00:	72450513          	addi	a0,a0,1828 # 6620 <malloc+0x13ba>
    2f04:	2ae020ef          	jal	51b2 <printf>
    exit(1);
    2f08:	4505                	li	a0,1
    2f0a:	671010ef          	jal	4d7a <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2f0e:	85ca                	mv	a1,s2
    2f10:	00003517          	auipc	a0,0x3
    2f14:	74850513          	addi	a0,a0,1864 # 6658 <malloc+0x13f2>
    2f18:	29a020ef          	jal	51b2 <printf>
    exit(1);
    2f1c:	4505                	li	a0,1
    2f1e:	65d010ef          	jal	4d7a <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2f22:	85ca                	mv	a1,s2
    2f24:	00003517          	auipc	a0,0x3
    2f28:	76450513          	addi	a0,a0,1892 # 6688 <malloc+0x1422>
    2f2c:	286020ef          	jal	51b2 <printf>
    exit(1);
    2f30:	4505                	li	a0,1
    2f32:	649010ef          	jal	4d7a <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2f36:	85ca                	mv	a1,s2
    2f38:	00003517          	auipc	a0,0x3
    2f3c:	78850513          	addi	a0,a0,1928 # 66c0 <malloc+0x145a>
    2f40:	272020ef          	jal	51b2 <printf>
    exit(1);
    2f44:	4505                	li	a0,1
    2f46:	635010ef          	jal	4d7a <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f4a:	85ca                	mv	a1,s2
    2f4c:	00003517          	auipc	a0,0x3
    2f50:	79450513          	addi	a0,a0,1940 # 66e0 <malloc+0x147a>
    2f54:	25e020ef          	jal	51b2 <printf>
    exit(1);
    2f58:	4505                	li	a0,1
    2f5a:	621010ef          	jal	4d7a <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f5e:	85ca                	mv	a1,s2
    2f60:	00003517          	auipc	a0,0x3
    2f64:	7b050513          	addi	a0,a0,1968 # 6710 <malloc+0x14aa>
    2f68:	24a020ef          	jal	51b2 <printf>
    exit(1);
    2f6c:	4505                	li	a0,1
    2f6e:	60d010ef          	jal	4d7a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f72:	85ca                	mv	a1,s2
    2f74:	00003517          	auipc	a0,0x3
    2f78:	7c450513          	addi	a0,a0,1988 # 6738 <malloc+0x14d2>
    2f7c:	236020ef          	jal	51b2 <printf>
    exit(1);
    2f80:	4505                	li	a0,1
    2f82:	5f9010ef          	jal	4d7a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f86:	85ca                	mv	a1,s2
    2f88:	00003517          	auipc	a0,0x3
    2f8c:	7d050513          	addi	a0,a0,2000 # 6758 <malloc+0x14f2>
    2f90:	222020ef          	jal	51b2 <printf>
    exit(1);
    2f94:	4505                	li	a0,1
    2f96:	5e5010ef          	jal	4d7a <exit>
    printf("%s: chdir dd failed\n", s);
    2f9a:	85ca                	mv	a1,s2
    2f9c:	00003517          	auipc	a0,0x3
    2fa0:	7e450513          	addi	a0,a0,2020 # 6780 <malloc+0x151a>
    2fa4:	20e020ef          	jal	51b2 <printf>
    exit(1);
    2fa8:	4505                	li	a0,1
    2faa:	5d1010ef          	jal	4d7a <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2fae:	85ca                	mv	a1,s2
    2fb0:	00003517          	auipc	a0,0x3
    2fb4:	7f850513          	addi	a0,a0,2040 # 67a8 <malloc+0x1542>
    2fb8:	1fa020ef          	jal	51b2 <printf>
    exit(1);
    2fbc:	4505                	li	a0,1
    2fbe:	5bd010ef          	jal	4d7a <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2fc2:	85ca                	mv	a1,s2
    2fc4:	00004517          	auipc	a0,0x4
    2fc8:	81450513          	addi	a0,a0,-2028 # 67d8 <malloc+0x1572>
    2fcc:	1e6020ef          	jal	51b2 <printf>
    exit(1);
    2fd0:	4505                	li	a0,1
    2fd2:	5a9010ef          	jal	4d7a <exit>
    printf("%s: chdir ./.. failed\n", s);
    2fd6:	85ca                	mv	a1,s2
    2fd8:	00004517          	auipc	a0,0x4
    2fdc:	83050513          	addi	a0,a0,-2000 # 6808 <malloc+0x15a2>
    2fe0:	1d2020ef          	jal	51b2 <printf>
    exit(1);
    2fe4:	4505                	li	a0,1
    2fe6:	595010ef          	jal	4d7a <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2fea:	85ca                	mv	a1,s2
    2fec:	00004517          	auipc	a0,0x4
    2ff0:	83450513          	addi	a0,a0,-1996 # 6820 <malloc+0x15ba>
    2ff4:	1be020ef          	jal	51b2 <printf>
    exit(1);
    2ff8:	4505                	li	a0,1
    2ffa:	581010ef          	jal	4d7a <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2ffe:	85ca                	mv	a1,s2
    3000:	00004517          	auipc	a0,0x4
    3004:	84050513          	addi	a0,a0,-1984 # 6840 <malloc+0x15da>
    3008:	1aa020ef          	jal	51b2 <printf>
    exit(1);
    300c:	4505                	li	a0,1
    300e:	56d010ef          	jal	4d7a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3012:	85ca                	mv	a1,s2
    3014:	00004517          	auipc	a0,0x4
    3018:	84c50513          	addi	a0,a0,-1972 # 6860 <malloc+0x15fa>
    301c:	196020ef          	jal	51b2 <printf>
    exit(1);
    3020:	4505                	li	a0,1
    3022:	559010ef          	jal	4d7a <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3026:	85ca                	mv	a1,s2
    3028:	00004517          	auipc	a0,0x4
    302c:	87850513          	addi	a0,a0,-1928 # 68a0 <malloc+0x163a>
    3030:	182020ef          	jal	51b2 <printf>
    exit(1);
    3034:	4505                	li	a0,1
    3036:	545010ef          	jal	4d7a <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    303a:	85ca                	mv	a1,s2
    303c:	00004517          	auipc	a0,0x4
    3040:	89450513          	addi	a0,a0,-1900 # 68d0 <malloc+0x166a>
    3044:	16e020ef          	jal	51b2 <printf>
    exit(1);
    3048:	4505                	li	a0,1
    304a:	531010ef          	jal	4d7a <exit>
    printf("%s: create dd succeeded!\n", s);
    304e:	85ca                	mv	a1,s2
    3050:	00004517          	auipc	a0,0x4
    3054:	8a050513          	addi	a0,a0,-1888 # 68f0 <malloc+0x168a>
    3058:	15a020ef          	jal	51b2 <printf>
    exit(1);
    305c:	4505                	li	a0,1
    305e:	51d010ef          	jal	4d7a <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3062:	85ca                	mv	a1,s2
    3064:	00004517          	auipc	a0,0x4
    3068:	8ac50513          	addi	a0,a0,-1876 # 6910 <malloc+0x16aa>
    306c:	146020ef          	jal	51b2 <printf>
    exit(1);
    3070:	4505                	li	a0,1
    3072:	509010ef          	jal	4d7a <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3076:	85ca                	mv	a1,s2
    3078:	00004517          	auipc	a0,0x4
    307c:	8b850513          	addi	a0,a0,-1864 # 6930 <malloc+0x16ca>
    3080:	132020ef          	jal	51b2 <printf>
    exit(1);
    3084:	4505                	li	a0,1
    3086:	4f5010ef          	jal	4d7a <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    308a:	85ca                	mv	a1,s2
    308c:	00004517          	auipc	a0,0x4
    3090:	8d450513          	addi	a0,a0,-1836 # 6960 <malloc+0x16fa>
    3094:	11e020ef          	jal	51b2 <printf>
    exit(1);
    3098:	4505                	li	a0,1
    309a:	4e1010ef          	jal	4d7a <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    309e:	85ca                	mv	a1,s2
    30a0:	00004517          	auipc	a0,0x4
    30a4:	8e850513          	addi	a0,a0,-1816 # 6988 <malloc+0x1722>
    30a8:	10a020ef          	jal	51b2 <printf>
    exit(1);
    30ac:	4505                	li	a0,1
    30ae:	4cd010ef          	jal	4d7a <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    30b2:	85ca                	mv	a1,s2
    30b4:	00004517          	auipc	a0,0x4
    30b8:	8fc50513          	addi	a0,a0,-1796 # 69b0 <malloc+0x174a>
    30bc:	0f6020ef          	jal	51b2 <printf>
    exit(1);
    30c0:	4505                	li	a0,1
    30c2:	4b9010ef          	jal	4d7a <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    30c6:	85ca                	mv	a1,s2
    30c8:	00004517          	auipc	a0,0x4
    30cc:	91050513          	addi	a0,a0,-1776 # 69d8 <malloc+0x1772>
    30d0:	0e2020ef          	jal	51b2 <printf>
    exit(1);
    30d4:	4505                	li	a0,1
    30d6:	4a5010ef          	jal	4d7a <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    30da:	85ca                	mv	a1,s2
    30dc:	00004517          	auipc	a0,0x4
    30e0:	91c50513          	addi	a0,a0,-1764 # 69f8 <malloc+0x1792>
    30e4:	0ce020ef          	jal	51b2 <printf>
    exit(1);
    30e8:	4505                	li	a0,1
    30ea:	491010ef          	jal	4d7a <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30ee:	85ca                	mv	a1,s2
    30f0:	00004517          	auipc	a0,0x4
    30f4:	92850513          	addi	a0,a0,-1752 # 6a18 <malloc+0x17b2>
    30f8:	0ba020ef          	jal	51b2 <printf>
    exit(1);
    30fc:	4505                	li	a0,1
    30fe:	47d010ef          	jal	4d7a <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3102:	85ca                	mv	a1,s2
    3104:	00004517          	auipc	a0,0x4
    3108:	93c50513          	addi	a0,a0,-1732 # 6a40 <malloc+0x17da>
    310c:	0a6020ef          	jal	51b2 <printf>
    exit(1);
    3110:	4505                	li	a0,1
    3112:	469010ef          	jal	4d7a <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3116:	85ca                	mv	a1,s2
    3118:	00004517          	auipc	a0,0x4
    311c:	94850513          	addi	a0,a0,-1720 # 6a60 <malloc+0x17fa>
    3120:	092020ef          	jal	51b2 <printf>
    exit(1);
    3124:	4505                	li	a0,1
    3126:	455010ef          	jal	4d7a <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    312a:	85ca                	mv	a1,s2
    312c:	00004517          	auipc	a0,0x4
    3130:	95450513          	addi	a0,a0,-1708 # 6a80 <malloc+0x181a>
    3134:	07e020ef          	jal	51b2 <printf>
    exit(1);
    3138:	4505                	li	a0,1
    313a:	441010ef          	jal	4d7a <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    313e:	85ca                	mv	a1,s2
    3140:	00004517          	auipc	a0,0x4
    3144:	96850513          	addi	a0,a0,-1688 # 6aa8 <malloc+0x1842>
    3148:	06a020ef          	jal	51b2 <printf>
    exit(1);
    314c:	4505                	li	a0,1
    314e:	42d010ef          	jal	4d7a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3152:	85ca                	mv	a1,s2
    3154:	00003517          	auipc	a0,0x3
    3158:	5e450513          	addi	a0,a0,1508 # 6738 <malloc+0x14d2>
    315c:	056020ef          	jal	51b2 <printf>
    exit(1);
    3160:	4505                	li	a0,1
    3162:	419010ef          	jal	4d7a <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3166:	85ca                	mv	a1,s2
    3168:	00004517          	auipc	a0,0x4
    316c:	96050513          	addi	a0,a0,-1696 # 6ac8 <malloc+0x1862>
    3170:	042020ef          	jal	51b2 <printf>
    exit(1);
    3174:	4505                	li	a0,1
    3176:	405010ef          	jal	4d7a <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    317a:	85ca                	mv	a1,s2
    317c:	00004517          	auipc	a0,0x4
    3180:	96c50513          	addi	a0,a0,-1684 # 6ae8 <malloc+0x1882>
    3184:	02e020ef          	jal	51b2 <printf>
    exit(1);
    3188:	4505                	li	a0,1
    318a:	3f1010ef          	jal	4d7a <exit>
    printf("%s: unlink dd/dd failed\n", s);
    318e:	85ca                	mv	a1,s2
    3190:	00004517          	auipc	a0,0x4
    3194:	98850513          	addi	a0,a0,-1656 # 6b18 <malloc+0x18b2>
    3198:	01a020ef          	jal	51b2 <printf>
    exit(1);
    319c:	4505                	li	a0,1
    319e:	3dd010ef          	jal	4d7a <exit>
    printf("%s: unlink dd failed\n", s);
    31a2:	85ca                	mv	a1,s2
    31a4:	00004517          	auipc	a0,0x4
    31a8:	99450513          	addi	a0,a0,-1644 # 6b38 <malloc+0x18d2>
    31ac:	006020ef          	jal	51b2 <printf>
    exit(1);
    31b0:	4505                	li	a0,1
    31b2:	3c9010ef          	jal	4d7a <exit>

00000000000031b6 <rmdot>:
{
    31b6:	1101                	addi	sp,sp,-32
    31b8:	ec06                	sd	ra,24(sp)
    31ba:	e822                	sd	s0,16(sp)
    31bc:	e426                	sd	s1,8(sp)
    31be:	1000                	addi	s0,sp,32
    31c0:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    31c2:	00004517          	auipc	a0,0x4
    31c6:	98e50513          	addi	a0,a0,-1650 # 6b50 <malloc+0x18ea>
    31ca:	419010ef          	jal	4de2 <mkdir>
    31ce:	e53d                	bnez	a0,323c <rmdot+0x86>
  if(chdir("dots") != 0){
    31d0:	00004517          	auipc	a0,0x4
    31d4:	98050513          	addi	a0,a0,-1664 # 6b50 <malloc+0x18ea>
    31d8:	413010ef          	jal	4dea <chdir>
    31dc:	e935                	bnez	a0,3250 <rmdot+0x9a>
  if(unlink(".") == 0){
    31de:	00003517          	auipc	a0,0x3
    31e2:	8a250513          	addi	a0,a0,-1886 # 5a80 <malloc+0x81a>
    31e6:	3e5010ef          	jal	4dca <unlink>
    31ea:	cd2d                	beqz	a0,3264 <rmdot+0xae>
  if(unlink("..") == 0){
    31ec:	00003517          	auipc	a0,0x3
    31f0:	3b450513          	addi	a0,a0,948 # 65a0 <malloc+0x133a>
    31f4:	3d7010ef          	jal	4dca <unlink>
    31f8:	c141                	beqz	a0,3278 <rmdot+0xc2>
  if(chdir("/") != 0){
    31fa:	00003517          	auipc	a0,0x3
    31fe:	34e50513          	addi	a0,a0,846 # 6548 <malloc+0x12e2>
    3202:	3e9010ef          	jal	4dea <chdir>
    3206:	e159                	bnez	a0,328c <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    3208:	00004517          	auipc	a0,0x4
    320c:	9b050513          	addi	a0,a0,-1616 # 6bb8 <malloc+0x1952>
    3210:	3bb010ef          	jal	4dca <unlink>
    3214:	c551                	beqz	a0,32a0 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    3216:	00004517          	auipc	a0,0x4
    321a:	9ca50513          	addi	a0,a0,-1590 # 6be0 <malloc+0x197a>
    321e:	3ad010ef          	jal	4dca <unlink>
    3222:	c949                	beqz	a0,32b4 <rmdot+0xfe>
  if(unlink("dots") != 0){
    3224:	00004517          	auipc	a0,0x4
    3228:	92c50513          	addi	a0,a0,-1748 # 6b50 <malloc+0x18ea>
    322c:	39f010ef          	jal	4dca <unlink>
    3230:	ed41                	bnez	a0,32c8 <rmdot+0x112>
}
    3232:	60e2                	ld	ra,24(sp)
    3234:	6442                	ld	s0,16(sp)
    3236:	64a2                	ld	s1,8(sp)
    3238:	6105                	addi	sp,sp,32
    323a:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    323c:	85a6                	mv	a1,s1
    323e:	00004517          	auipc	a0,0x4
    3242:	91a50513          	addi	a0,a0,-1766 # 6b58 <malloc+0x18f2>
    3246:	76d010ef          	jal	51b2 <printf>
    exit(1);
    324a:	4505                	li	a0,1
    324c:	32f010ef          	jal	4d7a <exit>
    printf("%s: chdir dots failed\n", s);
    3250:	85a6                	mv	a1,s1
    3252:	00004517          	auipc	a0,0x4
    3256:	91e50513          	addi	a0,a0,-1762 # 6b70 <malloc+0x190a>
    325a:	759010ef          	jal	51b2 <printf>
    exit(1);
    325e:	4505                	li	a0,1
    3260:	31b010ef          	jal	4d7a <exit>
    printf("%s: rm . worked!\n", s);
    3264:	85a6                	mv	a1,s1
    3266:	00004517          	auipc	a0,0x4
    326a:	92250513          	addi	a0,a0,-1758 # 6b88 <malloc+0x1922>
    326e:	745010ef          	jal	51b2 <printf>
    exit(1);
    3272:	4505                	li	a0,1
    3274:	307010ef          	jal	4d7a <exit>
    printf("%s: rm .. worked!\n", s);
    3278:	85a6                	mv	a1,s1
    327a:	00004517          	auipc	a0,0x4
    327e:	92650513          	addi	a0,a0,-1754 # 6ba0 <malloc+0x193a>
    3282:	731010ef          	jal	51b2 <printf>
    exit(1);
    3286:	4505                	li	a0,1
    3288:	2f3010ef          	jal	4d7a <exit>
    printf("%s: chdir / failed\n", s);
    328c:	85a6                	mv	a1,s1
    328e:	00003517          	auipc	a0,0x3
    3292:	2c250513          	addi	a0,a0,706 # 6550 <malloc+0x12ea>
    3296:	71d010ef          	jal	51b2 <printf>
    exit(1);
    329a:	4505                	li	a0,1
    329c:	2df010ef          	jal	4d7a <exit>
    printf("%s: unlink dots/. worked!\n", s);
    32a0:	85a6                	mv	a1,s1
    32a2:	00004517          	auipc	a0,0x4
    32a6:	91e50513          	addi	a0,a0,-1762 # 6bc0 <malloc+0x195a>
    32aa:	709010ef          	jal	51b2 <printf>
    exit(1);
    32ae:	4505                	li	a0,1
    32b0:	2cb010ef          	jal	4d7a <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    32b4:	85a6                	mv	a1,s1
    32b6:	00004517          	auipc	a0,0x4
    32ba:	93250513          	addi	a0,a0,-1742 # 6be8 <malloc+0x1982>
    32be:	6f5010ef          	jal	51b2 <printf>
    exit(1);
    32c2:	4505                	li	a0,1
    32c4:	2b7010ef          	jal	4d7a <exit>
    printf("%s: unlink dots failed!\n", s);
    32c8:	85a6                	mv	a1,s1
    32ca:	00004517          	auipc	a0,0x4
    32ce:	93e50513          	addi	a0,a0,-1730 # 6c08 <malloc+0x19a2>
    32d2:	6e1010ef          	jal	51b2 <printf>
    exit(1);
    32d6:	4505                	li	a0,1
    32d8:	2a3010ef          	jal	4d7a <exit>

00000000000032dc <dirfile>:
{
    32dc:	1101                	addi	sp,sp,-32
    32de:	ec06                	sd	ra,24(sp)
    32e0:	e822                	sd	s0,16(sp)
    32e2:	e426                	sd	s1,8(sp)
    32e4:	e04a                	sd	s2,0(sp)
    32e6:	1000                	addi	s0,sp,32
    32e8:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32ea:	20000593          	li	a1,512
    32ee:	00004517          	auipc	a0,0x4
    32f2:	93a50513          	addi	a0,a0,-1734 # 6c28 <malloc+0x19c2>
    32f6:	2c5010ef          	jal	4dba <open>
  if(fd < 0){
    32fa:	0c054563          	bltz	a0,33c4 <dirfile+0xe8>
  close(fd);
    32fe:	2a5010ef          	jal	4da2 <close>
  if(chdir("dirfile") == 0){
    3302:	00004517          	auipc	a0,0x4
    3306:	92650513          	addi	a0,a0,-1754 # 6c28 <malloc+0x19c2>
    330a:	2e1010ef          	jal	4dea <chdir>
    330e:	c569                	beqz	a0,33d8 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    3310:	4581                	li	a1,0
    3312:	00004517          	auipc	a0,0x4
    3316:	95e50513          	addi	a0,a0,-1698 # 6c70 <malloc+0x1a0a>
    331a:	2a1010ef          	jal	4dba <open>
  if(fd >= 0){
    331e:	0c055763          	bgez	a0,33ec <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    3322:	20000593          	li	a1,512
    3326:	00004517          	auipc	a0,0x4
    332a:	94a50513          	addi	a0,a0,-1718 # 6c70 <malloc+0x1a0a>
    332e:	28d010ef          	jal	4dba <open>
  if(fd >= 0){
    3332:	0c055763          	bgez	a0,3400 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    3336:	00004517          	auipc	a0,0x4
    333a:	93a50513          	addi	a0,a0,-1734 # 6c70 <malloc+0x1a0a>
    333e:	2a5010ef          	jal	4de2 <mkdir>
    3342:	0c050963          	beqz	a0,3414 <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    3346:	00004517          	auipc	a0,0x4
    334a:	92a50513          	addi	a0,a0,-1750 # 6c70 <malloc+0x1a0a>
    334e:	27d010ef          	jal	4dca <unlink>
    3352:	0c050b63          	beqz	a0,3428 <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    3356:	00004597          	auipc	a1,0x4
    335a:	91a58593          	addi	a1,a1,-1766 # 6c70 <malloc+0x1a0a>
    335e:	00002517          	auipc	a0,0x2
    3362:	21250513          	addi	a0,a0,530 # 5570 <malloc+0x30a>
    3366:	275010ef          	jal	4dda <link>
    336a:	0c050963          	beqz	a0,343c <dirfile+0x160>
  if(unlink("dirfile") != 0){
    336e:	00004517          	auipc	a0,0x4
    3372:	8ba50513          	addi	a0,a0,-1862 # 6c28 <malloc+0x19c2>
    3376:	255010ef          	jal	4dca <unlink>
    337a:	0c051b63          	bnez	a0,3450 <dirfile+0x174>
  fd = open(".", O_RDWR);
    337e:	4589                	li	a1,2
    3380:	00002517          	auipc	a0,0x2
    3384:	70050513          	addi	a0,a0,1792 # 5a80 <malloc+0x81a>
    3388:	233010ef          	jal	4dba <open>
  if(fd >= 0){
    338c:	0c055c63          	bgez	a0,3464 <dirfile+0x188>
  fd = open(".", 0);
    3390:	4581                	li	a1,0
    3392:	00002517          	auipc	a0,0x2
    3396:	6ee50513          	addi	a0,a0,1774 # 5a80 <malloc+0x81a>
    339a:	221010ef          	jal	4dba <open>
    339e:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    33a0:	4605                	li	a2,1
    33a2:	00002597          	auipc	a1,0x2
    33a6:	06658593          	addi	a1,a1,102 # 5408 <malloc+0x1a2>
    33aa:	1f1010ef          	jal	4d9a <write>
    33ae:	0ca04563          	bgtz	a0,3478 <dirfile+0x19c>
  close(fd);
    33b2:	8526                	mv	a0,s1
    33b4:	1ef010ef          	jal	4da2 <close>
}
    33b8:	60e2                	ld	ra,24(sp)
    33ba:	6442                	ld	s0,16(sp)
    33bc:	64a2                	ld	s1,8(sp)
    33be:	6902                	ld	s2,0(sp)
    33c0:	6105                	addi	sp,sp,32
    33c2:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    33c4:	85ca                	mv	a1,s2
    33c6:	00004517          	auipc	a0,0x4
    33ca:	86a50513          	addi	a0,a0,-1942 # 6c30 <malloc+0x19ca>
    33ce:	5e5010ef          	jal	51b2 <printf>
    exit(1);
    33d2:	4505                	li	a0,1
    33d4:	1a7010ef          	jal	4d7a <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    33d8:	85ca                	mv	a1,s2
    33da:	00004517          	auipc	a0,0x4
    33de:	87650513          	addi	a0,a0,-1930 # 6c50 <malloc+0x19ea>
    33e2:	5d1010ef          	jal	51b2 <printf>
    exit(1);
    33e6:	4505                	li	a0,1
    33e8:	193010ef          	jal	4d7a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33ec:	85ca                	mv	a1,s2
    33ee:	00004517          	auipc	a0,0x4
    33f2:	89250513          	addi	a0,a0,-1902 # 6c80 <malloc+0x1a1a>
    33f6:	5bd010ef          	jal	51b2 <printf>
    exit(1);
    33fa:	4505                	li	a0,1
    33fc:	17f010ef          	jal	4d7a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3400:	85ca                	mv	a1,s2
    3402:	00004517          	auipc	a0,0x4
    3406:	87e50513          	addi	a0,a0,-1922 # 6c80 <malloc+0x1a1a>
    340a:	5a9010ef          	jal	51b2 <printf>
    exit(1);
    340e:	4505                	li	a0,1
    3410:	16b010ef          	jal	4d7a <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3414:	85ca                	mv	a1,s2
    3416:	00004517          	auipc	a0,0x4
    341a:	89250513          	addi	a0,a0,-1902 # 6ca8 <malloc+0x1a42>
    341e:	595010ef          	jal	51b2 <printf>
    exit(1);
    3422:	4505                	li	a0,1
    3424:	157010ef          	jal	4d7a <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3428:	85ca                	mv	a1,s2
    342a:	00004517          	auipc	a0,0x4
    342e:	8a650513          	addi	a0,a0,-1882 # 6cd0 <malloc+0x1a6a>
    3432:	581010ef          	jal	51b2 <printf>
    exit(1);
    3436:	4505                	li	a0,1
    3438:	143010ef          	jal	4d7a <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    343c:	85ca                	mv	a1,s2
    343e:	00004517          	auipc	a0,0x4
    3442:	8ba50513          	addi	a0,a0,-1862 # 6cf8 <malloc+0x1a92>
    3446:	56d010ef          	jal	51b2 <printf>
    exit(1);
    344a:	4505                	li	a0,1
    344c:	12f010ef          	jal	4d7a <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3450:	85ca                	mv	a1,s2
    3452:	00004517          	auipc	a0,0x4
    3456:	8ce50513          	addi	a0,a0,-1842 # 6d20 <malloc+0x1aba>
    345a:	559010ef          	jal	51b2 <printf>
    exit(1);
    345e:	4505                	li	a0,1
    3460:	11b010ef          	jal	4d7a <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3464:	85ca                	mv	a1,s2
    3466:	00004517          	auipc	a0,0x4
    346a:	8da50513          	addi	a0,a0,-1830 # 6d40 <malloc+0x1ada>
    346e:	545010ef          	jal	51b2 <printf>
    exit(1);
    3472:	4505                	li	a0,1
    3474:	107010ef          	jal	4d7a <exit>
    printf("%s: write . succeeded!\n", s);
    3478:	85ca                	mv	a1,s2
    347a:	00004517          	auipc	a0,0x4
    347e:	8ee50513          	addi	a0,a0,-1810 # 6d68 <malloc+0x1b02>
    3482:	531010ef          	jal	51b2 <printf>
    exit(1);
    3486:	4505                	li	a0,1
    3488:	0f3010ef          	jal	4d7a <exit>

000000000000348c <iref>:
{
    348c:	7139                	addi	sp,sp,-64
    348e:	fc06                	sd	ra,56(sp)
    3490:	f822                	sd	s0,48(sp)
    3492:	f426                	sd	s1,40(sp)
    3494:	f04a                	sd	s2,32(sp)
    3496:	ec4e                	sd	s3,24(sp)
    3498:	e852                	sd	s4,16(sp)
    349a:	e456                	sd	s5,8(sp)
    349c:	e05a                	sd	s6,0(sp)
    349e:	0080                	addi	s0,sp,64
    34a0:	8b2a                	mv	s6,a0
    34a2:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    34a6:	00004a17          	auipc	s4,0x4
    34aa:	8daa0a13          	addi	s4,s4,-1830 # 6d80 <malloc+0x1b1a>
    mkdir("");
    34ae:	00003497          	auipc	s1,0x3
    34b2:	3da48493          	addi	s1,s1,986 # 6888 <malloc+0x1622>
    link("README", "");
    34b6:	00002a97          	auipc	s5,0x2
    34ba:	0baa8a93          	addi	s5,s5,186 # 5570 <malloc+0x30a>
    fd = open("xx", O_CREATE);
    34be:	00003997          	auipc	s3,0x3
    34c2:	7ba98993          	addi	s3,s3,1978 # 6c78 <malloc+0x1a12>
    34c6:	a835                	j	3502 <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    34c8:	85da                	mv	a1,s6
    34ca:	00004517          	auipc	a0,0x4
    34ce:	8be50513          	addi	a0,a0,-1858 # 6d88 <malloc+0x1b22>
    34d2:	4e1010ef          	jal	51b2 <printf>
      exit(1);
    34d6:	4505                	li	a0,1
    34d8:	0a3010ef          	jal	4d7a <exit>
      printf("%s: chdir irefd failed\n", s);
    34dc:	85da                	mv	a1,s6
    34de:	00004517          	auipc	a0,0x4
    34e2:	8c250513          	addi	a0,a0,-1854 # 6da0 <malloc+0x1b3a>
    34e6:	4cd010ef          	jal	51b2 <printf>
      exit(1);
    34ea:	4505                	li	a0,1
    34ec:	08f010ef          	jal	4d7a <exit>
      close(fd);
    34f0:	0b3010ef          	jal	4da2 <close>
    34f4:	a82d                	j	352e <iref+0xa2>
    unlink("xx");
    34f6:	854e                	mv	a0,s3
    34f8:	0d3010ef          	jal	4dca <unlink>
  for(i = 0; i < NINODE + 1; i++){
    34fc:	397d                	addiw	s2,s2,-1
    34fe:	04090263          	beqz	s2,3542 <iref+0xb6>
    if(mkdir("irefd") != 0){
    3502:	8552                	mv	a0,s4
    3504:	0df010ef          	jal	4de2 <mkdir>
    3508:	f161                	bnez	a0,34c8 <iref+0x3c>
    if(chdir("irefd") != 0){
    350a:	8552                	mv	a0,s4
    350c:	0df010ef          	jal	4dea <chdir>
    3510:	f571                	bnez	a0,34dc <iref+0x50>
    mkdir("");
    3512:	8526                	mv	a0,s1
    3514:	0cf010ef          	jal	4de2 <mkdir>
    link("README", "");
    3518:	85a6                	mv	a1,s1
    351a:	8556                	mv	a0,s5
    351c:	0bf010ef          	jal	4dda <link>
    fd = open("", O_CREATE);
    3520:	20000593          	li	a1,512
    3524:	8526                	mv	a0,s1
    3526:	095010ef          	jal	4dba <open>
    if(fd >= 0)
    352a:	fc0553e3          	bgez	a0,34f0 <iref+0x64>
    fd = open("xx", O_CREATE);
    352e:	20000593          	li	a1,512
    3532:	854e                	mv	a0,s3
    3534:	087010ef          	jal	4dba <open>
    if(fd >= 0)
    3538:	fa054fe3          	bltz	a0,34f6 <iref+0x6a>
      close(fd);
    353c:	067010ef          	jal	4da2 <close>
    3540:	bf5d                	j	34f6 <iref+0x6a>
    3542:	03300493          	li	s1,51
    chdir("..");
    3546:	00003997          	auipc	s3,0x3
    354a:	05a98993          	addi	s3,s3,90 # 65a0 <malloc+0x133a>
    unlink("irefd");
    354e:	00004917          	auipc	s2,0x4
    3552:	83290913          	addi	s2,s2,-1998 # 6d80 <malloc+0x1b1a>
    chdir("..");
    3556:	854e                	mv	a0,s3
    3558:	093010ef          	jal	4dea <chdir>
    unlink("irefd");
    355c:	854a                	mv	a0,s2
    355e:	06d010ef          	jal	4dca <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3562:	34fd                	addiw	s1,s1,-1
    3564:	f8ed                	bnez	s1,3556 <iref+0xca>
  chdir("/");
    3566:	00003517          	auipc	a0,0x3
    356a:	fe250513          	addi	a0,a0,-30 # 6548 <malloc+0x12e2>
    356e:	07d010ef          	jal	4dea <chdir>
}
    3572:	70e2                	ld	ra,56(sp)
    3574:	7442                	ld	s0,48(sp)
    3576:	74a2                	ld	s1,40(sp)
    3578:	7902                	ld	s2,32(sp)
    357a:	69e2                	ld	s3,24(sp)
    357c:	6a42                	ld	s4,16(sp)
    357e:	6aa2                	ld	s5,8(sp)
    3580:	6b02                	ld	s6,0(sp)
    3582:	6121                	addi	sp,sp,64
    3584:	8082                	ret

0000000000003586 <openiputtest>:
{
    3586:	7179                	addi	sp,sp,-48
    3588:	f406                	sd	ra,40(sp)
    358a:	f022                	sd	s0,32(sp)
    358c:	ec26                	sd	s1,24(sp)
    358e:	1800                	addi	s0,sp,48
    3590:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3592:	00004517          	auipc	a0,0x4
    3596:	82650513          	addi	a0,a0,-2010 # 6db8 <malloc+0x1b52>
    359a:	049010ef          	jal	4de2 <mkdir>
    359e:	02054a63          	bltz	a0,35d2 <openiputtest+0x4c>
  pid = fork();
    35a2:	7d0010ef          	jal	4d72 <fork>
  if(pid < 0){
    35a6:	04054063          	bltz	a0,35e6 <openiputtest+0x60>
  if(pid == 0){
    35aa:	e939                	bnez	a0,3600 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    35ac:	4589                	li	a1,2
    35ae:	00004517          	auipc	a0,0x4
    35b2:	80a50513          	addi	a0,a0,-2038 # 6db8 <malloc+0x1b52>
    35b6:	005010ef          	jal	4dba <open>
    if(fd >= 0){
    35ba:	04054063          	bltz	a0,35fa <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    35be:	85a6                	mv	a1,s1
    35c0:	00004517          	auipc	a0,0x4
    35c4:	81850513          	addi	a0,a0,-2024 # 6dd8 <malloc+0x1b72>
    35c8:	3eb010ef          	jal	51b2 <printf>
      exit(1);
    35cc:	4505                	li	a0,1
    35ce:	7ac010ef          	jal	4d7a <exit>
    printf("%s: mkdir oidir failed\n", s);
    35d2:	85a6                	mv	a1,s1
    35d4:	00003517          	auipc	a0,0x3
    35d8:	7ec50513          	addi	a0,a0,2028 # 6dc0 <malloc+0x1b5a>
    35dc:	3d7010ef          	jal	51b2 <printf>
    exit(1);
    35e0:	4505                	li	a0,1
    35e2:	798010ef          	jal	4d7a <exit>
    printf("%s: fork failed\n", s);
    35e6:	85a6                	mv	a1,s1
    35e8:	00002517          	auipc	a0,0x2
    35ec:	64050513          	addi	a0,a0,1600 # 5c28 <malloc+0x9c2>
    35f0:	3c3010ef          	jal	51b2 <printf>
    exit(1);
    35f4:	4505                	li	a0,1
    35f6:	784010ef          	jal	4d7a <exit>
    exit(0);
    35fa:	4501                	li	a0,0
    35fc:	77e010ef          	jal	4d7a <exit>
  pause(1);
    3600:	4505                	li	a0,1
    3602:	009010ef          	jal	4e0a <pause>
  if(unlink("oidir") != 0){
    3606:	00003517          	auipc	a0,0x3
    360a:	7b250513          	addi	a0,a0,1970 # 6db8 <malloc+0x1b52>
    360e:	7bc010ef          	jal	4dca <unlink>
    3612:	c919                	beqz	a0,3628 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    3614:	85a6                	mv	a1,s1
    3616:	00003517          	auipc	a0,0x3
    361a:	80250513          	addi	a0,a0,-2046 # 5e18 <malloc+0xbb2>
    361e:	395010ef          	jal	51b2 <printf>
    exit(1);
    3622:	4505                	li	a0,1
    3624:	756010ef          	jal	4d7a <exit>
  wait(&xstatus);
    3628:	fdc40513          	addi	a0,s0,-36
    362c:	756010ef          	jal	4d82 <wait>
  exit(xstatus);
    3630:	fdc42503          	lw	a0,-36(s0)
    3634:	746010ef          	jal	4d7a <exit>

0000000000003638 <forkforkfork>:
{
    3638:	1101                	addi	sp,sp,-32
    363a:	ec06                	sd	ra,24(sp)
    363c:	e822                	sd	s0,16(sp)
    363e:	e426                	sd	s1,8(sp)
    3640:	1000                	addi	s0,sp,32
    3642:	84aa                	mv	s1,a0
  unlink("stopforking");
    3644:	00003517          	auipc	a0,0x3
    3648:	7bc50513          	addi	a0,a0,1980 # 6e00 <malloc+0x1b9a>
    364c:	77e010ef          	jal	4dca <unlink>
  int pid = fork();
    3650:	722010ef          	jal	4d72 <fork>
  if(pid < 0){
    3654:	02054b63          	bltz	a0,368a <forkforkfork+0x52>
  if(pid == 0){
    3658:	c139                	beqz	a0,369e <forkforkfork+0x66>
  pause(20); // two seconds
    365a:	4551                	li	a0,20
    365c:	7ae010ef          	jal	4e0a <pause>
  close(open("stopforking", O_CREATE|O_RDWR));
    3660:	20200593          	li	a1,514
    3664:	00003517          	auipc	a0,0x3
    3668:	79c50513          	addi	a0,a0,1948 # 6e00 <malloc+0x1b9a>
    366c:	74e010ef          	jal	4dba <open>
    3670:	732010ef          	jal	4da2 <close>
  wait(0);
    3674:	4501                	li	a0,0
    3676:	70c010ef          	jal	4d82 <wait>
  pause(10); // one second
    367a:	4529                	li	a0,10
    367c:	78e010ef          	jal	4e0a <pause>
}
    3680:	60e2                	ld	ra,24(sp)
    3682:	6442                	ld	s0,16(sp)
    3684:	64a2                	ld	s1,8(sp)
    3686:	6105                	addi	sp,sp,32
    3688:	8082                	ret
    printf("%s: fork failed", s);
    368a:	85a6                	mv	a1,s1
    368c:	00002517          	auipc	a0,0x2
    3690:	75c50513          	addi	a0,a0,1884 # 5de8 <malloc+0xb82>
    3694:	31f010ef          	jal	51b2 <printf>
    exit(1);
    3698:	4505                	li	a0,1
    369a:	6e0010ef          	jal	4d7a <exit>
      int fd = open("stopforking", 0);
    369e:	00003497          	auipc	s1,0x3
    36a2:	76248493          	addi	s1,s1,1890 # 6e00 <malloc+0x1b9a>
    36a6:	4581                	li	a1,0
    36a8:	8526                	mv	a0,s1
    36aa:	710010ef          	jal	4dba <open>
      if(fd >= 0){
    36ae:	02055163          	bgez	a0,36d0 <forkforkfork+0x98>
      if(fork() < 0){
    36b2:	6c0010ef          	jal	4d72 <fork>
    36b6:	fe0558e3          	bgez	a0,36a6 <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    36ba:	20200593          	li	a1,514
    36be:	00003517          	auipc	a0,0x3
    36c2:	74250513          	addi	a0,a0,1858 # 6e00 <malloc+0x1b9a>
    36c6:	6f4010ef          	jal	4dba <open>
    36ca:	6d8010ef          	jal	4da2 <close>
    36ce:	bfe1                	j	36a6 <forkforkfork+0x6e>
        exit(0);
    36d0:	4501                	li	a0,0
    36d2:	6a8010ef          	jal	4d7a <exit>

00000000000036d6 <killstatus>:
{
    36d6:	7139                	addi	sp,sp,-64
    36d8:	fc06                	sd	ra,56(sp)
    36da:	f822                	sd	s0,48(sp)
    36dc:	f426                	sd	s1,40(sp)
    36de:	f04a                	sd	s2,32(sp)
    36e0:	ec4e                	sd	s3,24(sp)
    36e2:	e852                	sd	s4,16(sp)
    36e4:	0080                	addi	s0,sp,64
    36e6:	8a2a                	mv	s4,a0
    36e8:	06400913          	li	s2,100
    if(xst != -1) {
    36ec:	59fd                	li	s3,-1
    int pid1 = fork();
    36ee:	684010ef          	jal	4d72 <fork>
    36f2:	84aa                	mv	s1,a0
    if(pid1 < 0){
    36f4:	02054763          	bltz	a0,3722 <killstatus+0x4c>
    if(pid1 == 0){
    36f8:	cd1d                	beqz	a0,3736 <killstatus+0x60>
    pause(1);
    36fa:	4505                	li	a0,1
    36fc:	70e010ef          	jal	4e0a <pause>
    kill(pid1);
    3700:	8526                	mv	a0,s1
    3702:	6a8010ef          	jal	4daa <kill>
    wait(&xst);
    3706:	fcc40513          	addi	a0,s0,-52
    370a:	678010ef          	jal	4d82 <wait>
    if(xst != -1) {
    370e:	fcc42783          	lw	a5,-52(s0)
    3712:	03379563          	bne	a5,s3,373c <killstatus+0x66>
  for(int i = 0; i < 100; i++){
    3716:	397d                	addiw	s2,s2,-1
    3718:	fc091be3          	bnez	s2,36ee <killstatus+0x18>
  exit(0);
    371c:	4501                	li	a0,0
    371e:	65c010ef          	jal	4d7a <exit>
      printf("%s: fork failed\n", s);
    3722:	85d2                	mv	a1,s4
    3724:	00002517          	auipc	a0,0x2
    3728:	50450513          	addi	a0,a0,1284 # 5c28 <malloc+0x9c2>
    372c:	287010ef          	jal	51b2 <printf>
      exit(1);
    3730:	4505                	li	a0,1
    3732:	648010ef          	jal	4d7a <exit>
        getpid();
    3736:	6c4010ef          	jal	4dfa <getpid>
      while(1) {
    373a:	bff5                	j	3736 <killstatus+0x60>
       printf("%s: status should be -1\n", s);
    373c:	85d2                	mv	a1,s4
    373e:	00003517          	auipc	a0,0x3
    3742:	6d250513          	addi	a0,a0,1746 # 6e10 <malloc+0x1baa>
    3746:	26d010ef          	jal	51b2 <printf>
       exit(1);
    374a:	4505                	li	a0,1
    374c:	62e010ef          	jal	4d7a <exit>

0000000000003750 <preempt>:
{
    3750:	7139                	addi	sp,sp,-64
    3752:	fc06                	sd	ra,56(sp)
    3754:	f822                	sd	s0,48(sp)
    3756:	f426                	sd	s1,40(sp)
    3758:	f04a                	sd	s2,32(sp)
    375a:	ec4e                	sd	s3,24(sp)
    375c:	e852                	sd	s4,16(sp)
    375e:	0080                	addi	s0,sp,64
    3760:	892a                	mv	s2,a0
  pid1 = fork();
    3762:	610010ef          	jal	4d72 <fork>
  if(pid1 < 0) {
    3766:	00054563          	bltz	a0,3770 <preempt+0x20>
    376a:	84aa                	mv	s1,a0
  if(pid1 == 0)
    376c:	ed01                	bnez	a0,3784 <preempt+0x34>
    for(;;)
    376e:	a001                	j	376e <preempt+0x1e>
    printf("%s: fork failed", s);
    3770:	85ca                	mv	a1,s2
    3772:	00002517          	auipc	a0,0x2
    3776:	67650513          	addi	a0,a0,1654 # 5de8 <malloc+0xb82>
    377a:	239010ef          	jal	51b2 <printf>
    exit(1);
    377e:	4505                	li	a0,1
    3780:	5fa010ef          	jal	4d7a <exit>
  pid2 = fork();
    3784:	5ee010ef          	jal	4d72 <fork>
    3788:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    378a:	00054463          	bltz	a0,3792 <preempt+0x42>
  if(pid2 == 0)
    378e:	ed01                	bnez	a0,37a6 <preempt+0x56>
    for(;;)
    3790:	a001                	j	3790 <preempt+0x40>
    printf("%s: fork failed\n", s);
    3792:	85ca                	mv	a1,s2
    3794:	00002517          	auipc	a0,0x2
    3798:	49450513          	addi	a0,a0,1172 # 5c28 <malloc+0x9c2>
    379c:	217010ef          	jal	51b2 <printf>
    exit(1);
    37a0:	4505                	li	a0,1
    37a2:	5d8010ef          	jal	4d7a <exit>
  pipe(pfds);
    37a6:	fc840513          	addi	a0,s0,-56
    37aa:	5e0010ef          	jal	4d8a <pipe>
  pid3 = fork();
    37ae:	5c4010ef          	jal	4d72 <fork>
    37b2:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    37b4:	02054863          	bltz	a0,37e4 <preempt+0x94>
  if(pid3 == 0){
    37b8:	e921                	bnez	a0,3808 <preempt+0xb8>
    close(pfds[0]);
    37ba:	fc842503          	lw	a0,-56(s0)
    37be:	5e4010ef          	jal	4da2 <close>
    if(write(pfds[1], "x", 1) != 1)
    37c2:	4605                	li	a2,1
    37c4:	00002597          	auipc	a1,0x2
    37c8:	c4458593          	addi	a1,a1,-956 # 5408 <malloc+0x1a2>
    37cc:	fcc42503          	lw	a0,-52(s0)
    37d0:	5ca010ef          	jal	4d9a <write>
    37d4:	4785                	li	a5,1
    37d6:	02f51163          	bne	a0,a5,37f8 <preempt+0xa8>
    close(pfds[1]);
    37da:	fcc42503          	lw	a0,-52(s0)
    37de:	5c4010ef          	jal	4da2 <close>
    for(;;)
    37e2:	a001                	j	37e2 <preempt+0x92>
     printf("%s: fork failed\n", s);
    37e4:	85ca                	mv	a1,s2
    37e6:	00002517          	auipc	a0,0x2
    37ea:	44250513          	addi	a0,a0,1090 # 5c28 <malloc+0x9c2>
    37ee:	1c5010ef          	jal	51b2 <printf>
     exit(1);
    37f2:	4505                	li	a0,1
    37f4:	586010ef          	jal	4d7a <exit>
      printf("%s: preempt write error", s);
    37f8:	85ca                	mv	a1,s2
    37fa:	00003517          	auipc	a0,0x3
    37fe:	63650513          	addi	a0,a0,1590 # 6e30 <malloc+0x1bca>
    3802:	1b1010ef          	jal	51b2 <printf>
    3806:	bfd1                	j	37da <preempt+0x8a>
  close(pfds[1]);
    3808:	fcc42503          	lw	a0,-52(s0)
    380c:	596010ef          	jal	4da2 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3810:	660d                	lui	a2,0x3
    3812:	00008597          	auipc	a1,0x8
    3816:	4a658593          	addi	a1,a1,1190 # bcb8 <buf>
    381a:	fc842503          	lw	a0,-56(s0)
    381e:	574010ef          	jal	4d92 <read>
    3822:	4785                	li	a5,1
    3824:	02f50163          	beq	a0,a5,3846 <preempt+0xf6>
    printf("%s: preempt read error", s);
    3828:	85ca                	mv	a1,s2
    382a:	00003517          	auipc	a0,0x3
    382e:	61e50513          	addi	a0,a0,1566 # 6e48 <malloc+0x1be2>
    3832:	181010ef          	jal	51b2 <printf>
}
    3836:	70e2                	ld	ra,56(sp)
    3838:	7442                	ld	s0,48(sp)
    383a:	74a2                	ld	s1,40(sp)
    383c:	7902                	ld	s2,32(sp)
    383e:	69e2                	ld	s3,24(sp)
    3840:	6a42                	ld	s4,16(sp)
    3842:	6121                	addi	sp,sp,64
    3844:	8082                	ret
  close(pfds[0]);
    3846:	fc842503          	lw	a0,-56(s0)
    384a:	558010ef          	jal	4da2 <close>
  printf("kill... ");
    384e:	00003517          	auipc	a0,0x3
    3852:	61250513          	addi	a0,a0,1554 # 6e60 <malloc+0x1bfa>
    3856:	15d010ef          	jal	51b2 <printf>
  kill(pid1);
    385a:	8526                	mv	a0,s1
    385c:	54e010ef          	jal	4daa <kill>
  kill(pid2);
    3860:	854e                	mv	a0,s3
    3862:	548010ef          	jal	4daa <kill>
  kill(pid3);
    3866:	8552                	mv	a0,s4
    3868:	542010ef          	jal	4daa <kill>
  printf("wait... ");
    386c:	00003517          	auipc	a0,0x3
    3870:	60450513          	addi	a0,a0,1540 # 6e70 <malloc+0x1c0a>
    3874:	13f010ef          	jal	51b2 <printf>
  wait(0);
    3878:	4501                	li	a0,0
    387a:	508010ef          	jal	4d82 <wait>
  wait(0);
    387e:	4501                	li	a0,0
    3880:	502010ef          	jal	4d82 <wait>
  wait(0);
    3884:	4501                	li	a0,0
    3886:	4fc010ef          	jal	4d82 <wait>
    388a:	b775                	j	3836 <preempt+0xe6>

000000000000388c <reparent>:
{
    388c:	7179                	addi	sp,sp,-48
    388e:	f406                	sd	ra,40(sp)
    3890:	f022                	sd	s0,32(sp)
    3892:	ec26                	sd	s1,24(sp)
    3894:	e84a                	sd	s2,16(sp)
    3896:	e44e                	sd	s3,8(sp)
    3898:	e052                	sd	s4,0(sp)
    389a:	1800                	addi	s0,sp,48
    389c:	89aa                	mv	s3,a0
  int master_pid = getpid();
    389e:	55c010ef          	jal	4dfa <getpid>
    38a2:	8a2a                	mv	s4,a0
    38a4:	0c800913          	li	s2,200
    int pid = fork();
    38a8:	4ca010ef          	jal	4d72 <fork>
    38ac:	84aa                	mv	s1,a0
    if(pid < 0){
    38ae:	00054e63          	bltz	a0,38ca <reparent+0x3e>
    if(pid){
    38b2:	c121                	beqz	a0,38f2 <reparent+0x66>
      if(wait(0) != pid){
    38b4:	4501                	li	a0,0
    38b6:	4cc010ef          	jal	4d82 <wait>
    38ba:	02951263          	bne	a0,s1,38de <reparent+0x52>
  for(int i = 0; i < 200; i++){
    38be:	397d                	addiw	s2,s2,-1
    38c0:	fe0914e3          	bnez	s2,38a8 <reparent+0x1c>
  exit(0);
    38c4:	4501                	li	a0,0
    38c6:	4b4010ef          	jal	4d7a <exit>
      printf("%s: fork failed\n", s);
    38ca:	85ce                	mv	a1,s3
    38cc:	00002517          	auipc	a0,0x2
    38d0:	35c50513          	addi	a0,a0,860 # 5c28 <malloc+0x9c2>
    38d4:	0df010ef          	jal	51b2 <printf>
      exit(1);
    38d8:	4505                	li	a0,1
    38da:	4a0010ef          	jal	4d7a <exit>
        printf("%s: wait wrong pid\n", s);
    38de:	85ce                	mv	a1,s3
    38e0:	00002517          	auipc	a0,0x2
    38e4:	4d050513          	addi	a0,a0,1232 # 5db0 <malloc+0xb4a>
    38e8:	0cb010ef          	jal	51b2 <printf>
        exit(1);
    38ec:	4505                	li	a0,1
    38ee:	48c010ef          	jal	4d7a <exit>
      int pid2 = fork();
    38f2:	480010ef          	jal	4d72 <fork>
      if(pid2 < 0){
    38f6:	00054563          	bltz	a0,3900 <reparent+0x74>
      exit(0);
    38fa:	4501                	li	a0,0
    38fc:	47e010ef          	jal	4d7a <exit>
        kill(master_pid);
    3900:	8552                	mv	a0,s4
    3902:	4a8010ef          	jal	4daa <kill>
        exit(1);
    3906:	4505                	li	a0,1
    3908:	472010ef          	jal	4d7a <exit>

000000000000390c <sbrkfail>:
{
    390c:	7175                	addi	sp,sp,-144
    390e:	e506                	sd	ra,136(sp)
    3910:	e122                	sd	s0,128(sp)
    3912:	fca6                	sd	s1,120(sp)
    3914:	f8ca                	sd	s2,112(sp)
    3916:	f4ce                	sd	s3,104(sp)
    3918:	f0d2                	sd	s4,96(sp)
    391a:	ecd6                	sd	s5,88(sp)
    391c:	e8da                	sd	s6,80(sp)
    391e:	e4de                	sd	s7,72(sp)
    3920:	0900                	addi	s0,sp,144
    3922:	8b2a                	mv	s6,a0
  if(pipe(fds) != 0){
    3924:	fa040513          	addi	a0,s0,-96
    3928:	462010ef          	jal	4d8a <pipe>
    392c:	e919                	bnez	a0,3942 <sbrkfail+0x36>
    392e:	8aaa                	mv	s5,a0
    3930:	f7040493          	addi	s1,s0,-144
    3934:	f9840993          	addi	s3,s0,-104
    3938:	8926                	mv	s2,s1
    if(pids[i] != -1) {
    393a:	5a7d                	li	s4,-1
      if(scratch == '0')
    393c:	03000b93          	li	s7,48
    3940:	a08d                	j	39a2 <sbrkfail+0x96>
    printf("%s: pipe() failed\n", s);
    3942:	85da                	mv	a1,s6
    3944:	00002517          	auipc	a0,0x2
    3948:	3ec50513          	addi	a0,a0,1004 # 5d30 <malloc+0xaca>
    394c:	067010ef          	jal	51b2 <printf>
    exit(1);
    3950:	4505                	li	a0,1
    3952:	428010ef          	jal	4d7a <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) ==  (char*)SBRK_ERROR)
    3956:	3f0010ef          	jal	4d46 <sbrk>
    395a:	064007b7          	lui	a5,0x6400
    395e:	40a7853b          	subw	a0,a5,a0
    3962:	3e4010ef          	jal	4d46 <sbrk>
    3966:	57fd                	li	a5,-1
    3968:	02f50063          	beq	a0,a5,3988 <sbrkfail+0x7c>
        write(fds[1], "1", 1);
    396c:	4605                	li	a2,1
    396e:	00004597          	auipc	a1,0x4
    3972:	c8a58593          	addi	a1,a1,-886 # 75f8 <malloc+0x2392>
    3976:	fa442503          	lw	a0,-92(s0)
    397a:	420010ef          	jal	4d9a <write>
      for(;;) pause(1000);
    397e:	3e800513          	li	a0,1000
    3982:	488010ef          	jal	4e0a <pause>
    3986:	bfe5                	j	397e <sbrkfail+0x72>
        write(fds[1], "0", 1);
    3988:	4605                	li	a2,1
    398a:	00003597          	auipc	a1,0x3
    398e:	4f658593          	addi	a1,a1,1270 # 6e80 <malloc+0x1c1a>
    3992:	fa442503          	lw	a0,-92(s0)
    3996:	404010ef          	jal	4d9a <write>
    399a:	b7d5                	j	397e <sbrkfail+0x72>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    399c:	0911                	addi	s2,s2,4
    399e:	03390663          	beq	s2,s3,39ca <sbrkfail+0xbe>
    if((pids[i] = fork()) == 0){
    39a2:	3d0010ef          	jal	4d72 <fork>
    39a6:	00a92023          	sw	a0,0(s2)
    39aa:	d555                	beqz	a0,3956 <sbrkfail+0x4a>
    if(pids[i] != -1) {
    39ac:	ff4508e3          	beq	a0,s4,399c <sbrkfail+0x90>
      read(fds[0], &scratch, 1);
    39b0:	4605                	li	a2,1
    39b2:	f9f40593          	addi	a1,s0,-97
    39b6:	fa042503          	lw	a0,-96(s0)
    39ba:	3d8010ef          	jal	4d92 <read>
      if(scratch == '0')
    39be:	f9f44783          	lbu	a5,-97(s0)
    39c2:	fd779de3          	bne	a5,s7,399c <sbrkfail+0x90>
        failed = 1;
    39c6:	4a85                	li	s5,1
    39c8:	bfd1                	j	399c <sbrkfail+0x90>
  if(!failed) {
    39ca:	000a8863          	beqz	s5,39da <sbrkfail+0xce>
  c = sbrk(PGSIZE);
    39ce:	6505                	lui	a0,0x1
    39d0:	376010ef          	jal	4d46 <sbrk>
    39d4:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    39d6:	597d                	li	s2,-1
    39d8:	a821                	j	39f0 <sbrkfail+0xe4>
    printf("%s: no allocation failed; allocate more?\n", s);
    39da:	85da                	mv	a1,s6
    39dc:	00003517          	auipc	a0,0x3
    39e0:	4ac50513          	addi	a0,a0,1196 # 6e88 <malloc+0x1c22>
    39e4:	7ce010ef          	jal	51b2 <printf>
    39e8:	b7dd                	j	39ce <sbrkfail+0xc2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    39ea:	0491                	addi	s1,s1,4
    39ec:	01348b63          	beq	s1,s3,3a02 <sbrkfail+0xf6>
    if(pids[i] == -1)
    39f0:	4088                	lw	a0,0(s1)
    39f2:	ff250ce3          	beq	a0,s2,39ea <sbrkfail+0xde>
    kill(pids[i]);
    39f6:	3b4010ef          	jal	4daa <kill>
    wait(0);
    39fa:	4501                	li	a0,0
    39fc:	386010ef          	jal	4d82 <wait>
    3a00:	b7ed                	j	39ea <sbrkfail+0xde>
  if(c == (char*)SBRK_ERROR){
    3a02:	57fd                	li	a5,-1
    3a04:	02fa0a63          	beq	s4,a5,3a38 <sbrkfail+0x12c>
  pid = fork();
    3a08:	36a010ef          	jal	4d72 <fork>
  if(pid < 0){
    3a0c:	04054063          	bltz	a0,3a4c <sbrkfail+0x140>
  if(pid == 0){
    3a10:	e939                	bnez	a0,3a66 <sbrkfail+0x15a>
    a = sbrk(10*BIG);
    3a12:	3e800537          	lui	a0,0x3e800
    3a16:	330010ef          	jal	4d46 <sbrk>
    if(a == (char*)SBRK_ERROR){
    3a1a:	57fd                	li	a5,-1
    3a1c:	04f50263          	beq	a0,a5,3a60 <sbrkfail+0x154>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10*BIG);
    3a20:	3e800637          	lui	a2,0x3e800
    3a24:	85da                	mv	a1,s6
    3a26:	00003517          	auipc	a0,0x3
    3a2a:	4b250513          	addi	a0,a0,1202 # 6ed8 <malloc+0x1c72>
    3a2e:	784010ef          	jal	51b2 <printf>
    exit(1);
    3a32:	4505                	li	a0,1
    3a34:	346010ef          	jal	4d7a <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3a38:	85da                	mv	a1,s6
    3a3a:	00003517          	auipc	a0,0x3
    3a3e:	47e50513          	addi	a0,a0,1150 # 6eb8 <malloc+0x1c52>
    3a42:	770010ef          	jal	51b2 <printf>
    exit(1);
    3a46:	4505                	li	a0,1
    3a48:	332010ef          	jal	4d7a <exit>
    printf("%s: fork failed\n", s);
    3a4c:	85da                	mv	a1,s6
    3a4e:	00002517          	auipc	a0,0x2
    3a52:	1da50513          	addi	a0,a0,474 # 5c28 <malloc+0x9c2>
    3a56:	75c010ef          	jal	51b2 <printf>
    exit(1);
    3a5a:	4505                	li	a0,1
    3a5c:	31e010ef          	jal	4d7a <exit>
      exit(0);
    3a60:	4501                	li	a0,0
    3a62:	318010ef          	jal	4d7a <exit>
  wait(&xstatus);
    3a66:	fac40513          	addi	a0,s0,-84
    3a6a:	318010ef          	jal	4d82 <wait>
  if(xstatus != 0)
    3a6e:	fac42783          	lw	a5,-84(s0)
    3a72:	ef81                	bnez	a5,3a8a <sbrkfail+0x17e>
}
    3a74:	60aa                	ld	ra,136(sp)
    3a76:	640a                	ld	s0,128(sp)
    3a78:	74e6                	ld	s1,120(sp)
    3a7a:	7946                	ld	s2,112(sp)
    3a7c:	79a6                	ld	s3,104(sp)
    3a7e:	7a06                	ld	s4,96(sp)
    3a80:	6ae6                	ld	s5,88(sp)
    3a82:	6b46                	ld	s6,80(sp)
    3a84:	6ba6                	ld	s7,72(sp)
    3a86:	6149                	addi	sp,sp,144
    3a88:	8082                	ret
    exit(1);
    3a8a:	4505                	li	a0,1
    3a8c:	2ee010ef          	jal	4d7a <exit>

0000000000003a90 <mem>:
{
    3a90:	7139                	addi	sp,sp,-64
    3a92:	fc06                	sd	ra,56(sp)
    3a94:	f822                	sd	s0,48(sp)
    3a96:	f426                	sd	s1,40(sp)
    3a98:	f04a                	sd	s2,32(sp)
    3a9a:	ec4e                	sd	s3,24(sp)
    3a9c:	0080                	addi	s0,sp,64
    3a9e:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3aa0:	2d2010ef          	jal	4d72 <fork>
    m1 = 0;
    3aa4:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3aa6:	6909                	lui	s2,0x2
    3aa8:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0x93>
  if((pid = fork()) == 0){
    3aac:	cd11                	beqz	a0,3ac8 <mem+0x38>
    wait(&xstatus);
    3aae:	fcc40513          	addi	a0,s0,-52
    3ab2:	2d0010ef          	jal	4d82 <wait>
    if(xstatus == -1){
    3ab6:	fcc42503          	lw	a0,-52(s0)
    3aba:	57fd                	li	a5,-1
    3abc:	04f50363          	beq	a0,a5,3b02 <mem+0x72>
    exit(xstatus);
    3ac0:	2ba010ef          	jal	4d7a <exit>
      *(char**)m2 = m1;
    3ac4:	e104                	sd	s1,0(a0)
      m1 = m2;
    3ac6:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3ac8:	854a                	mv	a0,s2
    3aca:	79c010ef          	jal	5266 <malloc>
    3ace:	f97d                	bnez	a0,3ac4 <mem+0x34>
    while(m1){
    3ad0:	c491                	beqz	s1,3adc <mem+0x4c>
      m2 = *(char**)m1;
    3ad2:	8526                	mv	a0,s1
    3ad4:	6084                	ld	s1,0(s1)
      free(m1);
    3ad6:	70e010ef          	jal	51e4 <free>
    while(m1){
    3ada:	fce5                	bnez	s1,3ad2 <mem+0x42>
    m1 = malloc(1024*20);
    3adc:	6515                	lui	a0,0x5
    3ade:	788010ef          	jal	5266 <malloc>
    if(m1 == 0){
    3ae2:	c511                	beqz	a0,3aee <mem+0x5e>
    free(m1);
    3ae4:	700010ef          	jal	51e4 <free>
    exit(0);
    3ae8:	4501                	li	a0,0
    3aea:	290010ef          	jal	4d7a <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3aee:	85ce                	mv	a1,s3
    3af0:	00003517          	auipc	a0,0x3
    3af4:	41850513          	addi	a0,a0,1048 # 6f08 <malloc+0x1ca2>
    3af8:	6ba010ef          	jal	51b2 <printf>
      exit(1);
    3afc:	4505                	li	a0,1
    3afe:	27c010ef          	jal	4d7a <exit>
      exit(0);
    3b02:	4501                	li	a0,0
    3b04:	276010ef          	jal	4d7a <exit>

0000000000003b08 <sharedfd>:
{
    3b08:	7159                	addi	sp,sp,-112
    3b0a:	f486                	sd	ra,104(sp)
    3b0c:	f0a2                	sd	s0,96(sp)
    3b0e:	e0d2                	sd	s4,64(sp)
    3b10:	1880                	addi	s0,sp,112
    3b12:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3b14:	00003517          	auipc	a0,0x3
    3b18:	41450513          	addi	a0,a0,1044 # 6f28 <malloc+0x1cc2>
    3b1c:	2ae010ef          	jal	4dca <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3b20:	20200593          	li	a1,514
    3b24:	00003517          	auipc	a0,0x3
    3b28:	40450513          	addi	a0,a0,1028 # 6f28 <malloc+0x1cc2>
    3b2c:	28e010ef          	jal	4dba <open>
  if(fd < 0){
    3b30:	04054863          	bltz	a0,3b80 <sharedfd+0x78>
    3b34:	eca6                	sd	s1,88(sp)
    3b36:	e8ca                	sd	s2,80(sp)
    3b38:	e4ce                	sd	s3,72(sp)
    3b3a:	fc56                	sd	s5,56(sp)
    3b3c:	f85a                	sd	s6,48(sp)
    3b3e:	f45e                	sd	s7,40(sp)
    3b40:	892a                	mv	s2,a0
  pid = fork();
    3b42:	230010ef          	jal	4d72 <fork>
    3b46:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3b48:	07000593          	li	a1,112
    3b4c:	e119                	bnez	a0,3b52 <sharedfd+0x4a>
    3b4e:	06300593          	li	a1,99
    3b52:	4629                	li	a2,10
    3b54:	fa040513          	addi	a0,s0,-96
    3b58:	010010ef          	jal	4b68 <memset>
    3b5c:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3b60:	4629                	li	a2,10
    3b62:	fa040593          	addi	a1,s0,-96
    3b66:	854a                	mv	a0,s2
    3b68:	232010ef          	jal	4d9a <write>
    3b6c:	47a9                	li	a5,10
    3b6e:	02f51963          	bne	a0,a5,3ba0 <sharedfd+0x98>
  for(i = 0; i < N; i++){
    3b72:	34fd                	addiw	s1,s1,-1
    3b74:	f4f5                	bnez	s1,3b60 <sharedfd+0x58>
  if(pid == 0) {
    3b76:	02099f63          	bnez	s3,3bb4 <sharedfd+0xac>
    exit(0);
    3b7a:	4501                	li	a0,0
    3b7c:	1fe010ef          	jal	4d7a <exit>
    3b80:	eca6                	sd	s1,88(sp)
    3b82:	e8ca                	sd	s2,80(sp)
    3b84:	e4ce                	sd	s3,72(sp)
    3b86:	fc56                	sd	s5,56(sp)
    3b88:	f85a                	sd	s6,48(sp)
    3b8a:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3b8c:	85d2                	mv	a1,s4
    3b8e:	00003517          	auipc	a0,0x3
    3b92:	3aa50513          	addi	a0,a0,938 # 6f38 <malloc+0x1cd2>
    3b96:	61c010ef          	jal	51b2 <printf>
    exit(1);
    3b9a:	4505                	li	a0,1
    3b9c:	1de010ef          	jal	4d7a <exit>
      printf("%s: write sharedfd failed\n", s);
    3ba0:	85d2                	mv	a1,s4
    3ba2:	00003517          	auipc	a0,0x3
    3ba6:	3be50513          	addi	a0,a0,958 # 6f60 <malloc+0x1cfa>
    3baa:	608010ef          	jal	51b2 <printf>
      exit(1);
    3bae:	4505                	li	a0,1
    3bb0:	1ca010ef          	jal	4d7a <exit>
    wait(&xstatus);
    3bb4:	f9c40513          	addi	a0,s0,-100
    3bb8:	1ca010ef          	jal	4d82 <wait>
    if(xstatus != 0)
    3bbc:	f9c42983          	lw	s3,-100(s0)
    3bc0:	00098563          	beqz	s3,3bca <sharedfd+0xc2>
      exit(xstatus);
    3bc4:	854e                	mv	a0,s3
    3bc6:	1b4010ef          	jal	4d7a <exit>
  close(fd);
    3bca:	854a                	mv	a0,s2
    3bcc:	1d6010ef          	jal	4da2 <close>
  fd = open("sharedfd", 0);
    3bd0:	4581                	li	a1,0
    3bd2:	00003517          	auipc	a0,0x3
    3bd6:	35650513          	addi	a0,a0,854 # 6f28 <malloc+0x1cc2>
    3bda:	1e0010ef          	jal	4dba <open>
    3bde:	8baa                	mv	s7,a0
  nc = np = 0;
    3be0:	8ace                	mv	s5,s3
  if(fd < 0){
    3be2:	02054363          	bltz	a0,3c08 <sharedfd+0x100>
    3be6:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3bea:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3bee:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3bf2:	4629                	li	a2,10
    3bf4:	fa040593          	addi	a1,s0,-96
    3bf8:	855e                	mv	a0,s7
    3bfa:	198010ef          	jal	4d92 <read>
    3bfe:	02a05b63          	blez	a0,3c34 <sharedfd+0x12c>
    3c02:	fa040793          	addi	a5,s0,-96
    3c06:	a839                	j	3c24 <sharedfd+0x11c>
    printf("%s: cannot open sharedfd for reading\n", s);
    3c08:	85d2                	mv	a1,s4
    3c0a:	00003517          	auipc	a0,0x3
    3c0e:	37650513          	addi	a0,a0,886 # 6f80 <malloc+0x1d1a>
    3c12:	5a0010ef          	jal	51b2 <printf>
    exit(1);
    3c16:	4505                	li	a0,1
    3c18:	162010ef          	jal	4d7a <exit>
        nc++;
    3c1c:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3c1e:	0785                	addi	a5,a5,1 # 6400001 <base+0x63f1349>
    3c20:	fd2789e3          	beq	a5,s2,3bf2 <sharedfd+0xea>
      if(buf[i] == 'c')
    3c24:	0007c703          	lbu	a4,0(a5)
    3c28:	fe970ae3          	beq	a4,s1,3c1c <sharedfd+0x114>
      if(buf[i] == 'p')
    3c2c:	ff6719e3          	bne	a4,s6,3c1e <sharedfd+0x116>
        np++;
    3c30:	2a85                	addiw	s5,s5,1
    3c32:	b7f5                	j	3c1e <sharedfd+0x116>
  close(fd);
    3c34:	855e                	mv	a0,s7
    3c36:	16c010ef          	jal	4da2 <close>
  unlink("sharedfd");
    3c3a:	00003517          	auipc	a0,0x3
    3c3e:	2ee50513          	addi	a0,a0,750 # 6f28 <malloc+0x1cc2>
    3c42:	188010ef          	jal	4dca <unlink>
  if(nc == N*SZ && np == N*SZ){
    3c46:	6789                	lui	a5,0x2
    3c48:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x92>
    3c4c:	00f99763          	bne	s3,a5,3c5a <sharedfd+0x152>
    3c50:	6789                	lui	a5,0x2
    3c52:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x92>
    3c56:	00fa8c63          	beq	s5,a5,3c6e <sharedfd+0x166>
    printf("%s: nc/np test fails\n", s);
    3c5a:	85d2                	mv	a1,s4
    3c5c:	00003517          	auipc	a0,0x3
    3c60:	34c50513          	addi	a0,a0,844 # 6fa8 <malloc+0x1d42>
    3c64:	54e010ef          	jal	51b2 <printf>
    exit(1);
    3c68:	4505                	li	a0,1
    3c6a:	110010ef          	jal	4d7a <exit>
    exit(0);
    3c6e:	4501                	li	a0,0
    3c70:	10a010ef          	jal	4d7a <exit>

0000000000003c74 <fourfiles>:
{
    3c74:	7135                	addi	sp,sp,-160
    3c76:	ed06                	sd	ra,152(sp)
    3c78:	e922                	sd	s0,144(sp)
    3c7a:	e526                	sd	s1,136(sp)
    3c7c:	e14a                	sd	s2,128(sp)
    3c7e:	fcce                	sd	s3,120(sp)
    3c80:	f8d2                	sd	s4,112(sp)
    3c82:	f4d6                	sd	s5,104(sp)
    3c84:	f0da                	sd	s6,96(sp)
    3c86:	ecde                	sd	s7,88(sp)
    3c88:	e8e2                	sd	s8,80(sp)
    3c8a:	e4e6                	sd	s9,72(sp)
    3c8c:	e0ea                	sd	s10,64(sp)
    3c8e:	fc6e                	sd	s11,56(sp)
    3c90:	1100                	addi	s0,sp,160
    3c92:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c94:	00003797          	auipc	a5,0x3
    3c98:	32c78793          	addi	a5,a5,812 # 6fc0 <malloc+0x1d5a>
    3c9c:	f6f43823          	sd	a5,-144(s0)
    3ca0:	00003797          	auipc	a5,0x3
    3ca4:	32878793          	addi	a5,a5,808 # 6fc8 <malloc+0x1d62>
    3ca8:	f6f43c23          	sd	a5,-136(s0)
    3cac:	00003797          	auipc	a5,0x3
    3cb0:	32478793          	addi	a5,a5,804 # 6fd0 <malloc+0x1d6a>
    3cb4:	f8f43023          	sd	a5,-128(s0)
    3cb8:	00003797          	auipc	a5,0x3
    3cbc:	32078793          	addi	a5,a5,800 # 6fd8 <malloc+0x1d72>
    3cc0:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3cc4:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3cc8:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3cca:	4481                	li	s1,0
    3ccc:	4a11                	li	s4,4
    fname = names[pi];
    3cce:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3cd2:	854e                	mv	a0,s3
    3cd4:	0f6010ef          	jal	4dca <unlink>
    pid = fork();
    3cd8:	09a010ef          	jal	4d72 <fork>
    if(pid < 0){
    3cdc:	02054e63          	bltz	a0,3d18 <fourfiles+0xa4>
    if(pid == 0){
    3ce0:	c531                	beqz	a0,3d2c <fourfiles+0xb8>
  for(pi = 0; pi < NCHILD; pi++){
    3ce2:	2485                	addiw	s1,s1,1
    3ce4:	0921                	addi	s2,s2,8
    3ce6:	ff4494e3          	bne	s1,s4,3cce <fourfiles+0x5a>
    3cea:	4491                	li	s1,4
    wait(&xstatus);
    3cec:	f6c40513          	addi	a0,s0,-148
    3cf0:	092010ef          	jal	4d82 <wait>
    if(xstatus != 0)
    3cf4:	f6c42a83          	lw	s5,-148(s0)
    3cf8:	0a0a9463          	bnez	s5,3da0 <fourfiles+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    3cfc:	34fd                	addiw	s1,s1,-1
    3cfe:	f4fd                	bnez	s1,3cec <fourfiles+0x78>
    3d00:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3d04:	00008a17          	auipc	s4,0x8
    3d08:	fb4a0a13          	addi	s4,s4,-76 # bcb8 <buf>
    if(total != N*SZ){
    3d0c:	6d05                	lui	s10,0x1
    3d0e:	770d0d13          	addi	s10,s10,1904 # 1770 <forkfork+0x1a>
  for(i = 0; i < NCHILD; i++){
    3d12:	03400d93          	li	s11,52
    3d16:	a0ed                	j	3e00 <fourfiles+0x18c>
      printf("%s: fork failed\n", s);
    3d18:	85e6                	mv	a1,s9
    3d1a:	00002517          	auipc	a0,0x2
    3d1e:	f0e50513          	addi	a0,a0,-242 # 5c28 <malloc+0x9c2>
    3d22:	490010ef          	jal	51b2 <printf>
      exit(1);
    3d26:	4505                	li	a0,1
    3d28:	052010ef          	jal	4d7a <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3d2c:	20200593          	li	a1,514
    3d30:	854e                	mv	a0,s3
    3d32:	088010ef          	jal	4dba <open>
    3d36:	892a                	mv	s2,a0
      if(fd < 0){
    3d38:	04054163          	bltz	a0,3d7a <fourfiles+0x106>
      memset(buf, '0'+pi, SZ);
    3d3c:	1f400613          	li	a2,500
    3d40:	0304859b          	addiw	a1,s1,48
    3d44:	00008517          	auipc	a0,0x8
    3d48:	f7450513          	addi	a0,a0,-140 # bcb8 <buf>
    3d4c:	61d000ef          	jal	4b68 <memset>
    3d50:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3d52:	00008997          	auipc	s3,0x8
    3d56:	f6698993          	addi	s3,s3,-154 # bcb8 <buf>
    3d5a:	1f400613          	li	a2,500
    3d5e:	85ce                	mv	a1,s3
    3d60:	854a                	mv	a0,s2
    3d62:	038010ef          	jal	4d9a <write>
    3d66:	85aa                	mv	a1,a0
    3d68:	1f400793          	li	a5,500
    3d6c:	02f51163          	bne	a0,a5,3d8e <fourfiles+0x11a>
      for(i = 0; i < N; i++){
    3d70:	34fd                	addiw	s1,s1,-1
    3d72:	f4e5                	bnez	s1,3d5a <fourfiles+0xe6>
      exit(0);
    3d74:	4501                	li	a0,0
    3d76:	004010ef          	jal	4d7a <exit>
        printf("%s: create failed\n", s);
    3d7a:	85e6                	mv	a1,s9
    3d7c:	00002517          	auipc	a0,0x2
    3d80:	f4450513          	addi	a0,a0,-188 # 5cc0 <malloc+0xa5a>
    3d84:	42e010ef          	jal	51b2 <printf>
        exit(1);
    3d88:	4505                	li	a0,1
    3d8a:	7f1000ef          	jal	4d7a <exit>
          printf("write failed %d\n", n);
    3d8e:	00003517          	auipc	a0,0x3
    3d92:	25250513          	addi	a0,a0,594 # 6fe0 <malloc+0x1d7a>
    3d96:	41c010ef          	jal	51b2 <printf>
          exit(1);
    3d9a:	4505                	li	a0,1
    3d9c:	7df000ef          	jal	4d7a <exit>
      exit(xstatus);
    3da0:	8556                	mv	a0,s5
    3da2:	7d9000ef          	jal	4d7a <exit>
          printf("%s: wrong char\n", s);
    3da6:	85e6                	mv	a1,s9
    3da8:	00003517          	auipc	a0,0x3
    3dac:	25050513          	addi	a0,a0,592 # 6ff8 <malloc+0x1d92>
    3db0:	402010ef          	jal	51b2 <printf>
          exit(1);
    3db4:	4505                	li	a0,1
    3db6:	7c5000ef          	jal	4d7a <exit>
      total += n;
    3dba:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3dbe:	660d                	lui	a2,0x3
    3dc0:	85d2                	mv	a1,s4
    3dc2:	854e                	mv	a0,s3
    3dc4:	7cf000ef          	jal	4d92 <read>
    3dc8:	02a05063          	blez	a0,3de8 <fourfiles+0x174>
    3dcc:	00008797          	auipc	a5,0x8
    3dd0:	eec78793          	addi	a5,a5,-276 # bcb8 <buf>
    3dd4:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3dd8:	0007c703          	lbu	a4,0(a5)
    3ddc:	fc9715e3          	bne	a4,s1,3da6 <fourfiles+0x132>
      for(j = 0; j < n; j++){
    3de0:	0785                	addi	a5,a5,1
    3de2:	fed79be3          	bne	a5,a3,3dd8 <fourfiles+0x164>
    3de6:	bfd1                	j	3dba <fourfiles+0x146>
    close(fd);
    3de8:	854e                	mv	a0,s3
    3dea:	7b9000ef          	jal	4da2 <close>
    if(total != N*SZ){
    3dee:	03a91463          	bne	s2,s10,3e16 <fourfiles+0x1a2>
    unlink(fname);
    3df2:	8562                	mv	a0,s8
    3df4:	7d7000ef          	jal	4dca <unlink>
  for(i = 0; i < NCHILD; i++){
    3df8:	0ba1                	addi	s7,s7,8
    3dfa:	2b05                	addiw	s6,s6,1
    3dfc:	03bb0763          	beq	s6,s11,3e2a <fourfiles+0x1b6>
    fname = names[i];
    3e00:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3e04:	4581                	li	a1,0
    3e06:	8562                	mv	a0,s8
    3e08:	7b3000ef          	jal	4dba <open>
    3e0c:	89aa                	mv	s3,a0
    total = 0;
    3e0e:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    3e10:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3e14:	b76d                	j	3dbe <fourfiles+0x14a>
      printf("wrong length %d\n", total);
    3e16:	85ca                	mv	a1,s2
    3e18:	00003517          	auipc	a0,0x3
    3e1c:	1f050513          	addi	a0,a0,496 # 7008 <malloc+0x1da2>
    3e20:	392010ef          	jal	51b2 <printf>
      exit(1);
    3e24:	4505                	li	a0,1
    3e26:	755000ef          	jal	4d7a <exit>
}
    3e2a:	60ea                	ld	ra,152(sp)
    3e2c:	644a                	ld	s0,144(sp)
    3e2e:	64aa                	ld	s1,136(sp)
    3e30:	690a                	ld	s2,128(sp)
    3e32:	79e6                	ld	s3,120(sp)
    3e34:	7a46                	ld	s4,112(sp)
    3e36:	7aa6                	ld	s5,104(sp)
    3e38:	7b06                	ld	s6,96(sp)
    3e3a:	6be6                	ld	s7,88(sp)
    3e3c:	6c46                	ld	s8,80(sp)
    3e3e:	6ca6                	ld	s9,72(sp)
    3e40:	6d06                	ld	s10,64(sp)
    3e42:	7de2                	ld	s11,56(sp)
    3e44:	610d                	addi	sp,sp,160
    3e46:	8082                	ret

0000000000003e48 <concreate>:
{
    3e48:	7135                	addi	sp,sp,-160
    3e4a:	ed06                	sd	ra,152(sp)
    3e4c:	e922                	sd	s0,144(sp)
    3e4e:	e526                	sd	s1,136(sp)
    3e50:	e14a                	sd	s2,128(sp)
    3e52:	fcce                	sd	s3,120(sp)
    3e54:	f8d2                	sd	s4,112(sp)
    3e56:	f4d6                	sd	s5,104(sp)
    3e58:	f0da                	sd	s6,96(sp)
    3e5a:	ecde                	sd	s7,88(sp)
    3e5c:	1100                	addi	s0,sp,160
    3e5e:	89aa                	mv	s3,a0
  file[0] = 'C';
    3e60:	04300793          	li	a5,67
    3e64:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3e68:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    3e6c:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    3e6e:	4b0d                	li	s6,3
    3e70:	4a85                	li	s5,1
      link("C0", file);
    3e72:	00003b97          	auipc	s7,0x3
    3e76:	1aeb8b93          	addi	s7,s7,430 # 7020 <malloc+0x1dba>
  for(i = 0; i < N; i++){
    3e7a:	02800a13          	li	s4,40
    3e7e:	a41d                	j	40a4 <concreate+0x25c>
      link("C0", file);
    3e80:	fa840593          	addi	a1,s0,-88
    3e84:	855e                	mv	a0,s7
    3e86:	755000ef          	jal	4dda <link>
    if(pid == 0) {
    3e8a:	a411                	j	408e <concreate+0x246>
    } else if(pid == 0 && (i % 5) == 1){
    3e8c:	4795                	li	a5,5
    3e8e:	02f9693b          	remw	s2,s2,a5
    3e92:	4785                	li	a5,1
    3e94:	02f90563          	beq	s2,a5,3ebe <concreate+0x76>
      fd = open(file, O_CREATE | O_RDWR);
    3e98:	20200593          	li	a1,514
    3e9c:	fa840513          	addi	a0,s0,-88
    3ea0:	71b000ef          	jal	4dba <open>
      if(fd < 0){
    3ea4:	1e055063          	bgez	a0,4084 <concreate+0x23c>
        printf("concreate create %s failed\n", file);
    3ea8:	fa840593          	addi	a1,s0,-88
    3eac:	00003517          	auipc	a0,0x3
    3eb0:	17c50513          	addi	a0,a0,380 # 7028 <malloc+0x1dc2>
    3eb4:	2fe010ef          	jal	51b2 <printf>
        exit(1);
    3eb8:	4505                	li	a0,1
    3eba:	6c1000ef          	jal	4d7a <exit>
      link("C0", file);
    3ebe:	fa840593          	addi	a1,s0,-88
    3ec2:	00003517          	auipc	a0,0x3
    3ec6:	15e50513          	addi	a0,a0,350 # 7020 <malloc+0x1dba>
    3eca:	711000ef          	jal	4dda <link>
      exit(0);
    3ece:	4501                	li	a0,0
    3ed0:	6ab000ef          	jal	4d7a <exit>
        exit(1);
    3ed4:	4505                	li	a0,1
    3ed6:	6a5000ef          	jal	4d7a <exit>
  memset(fa, 0, sizeof(fa));
    3eda:	02800613          	li	a2,40
    3ede:	4581                	li	a1,0
    3ee0:	f8040513          	addi	a0,s0,-128
    3ee4:	485000ef          	jal	4b68 <memset>
  fd = open(".", 0);
    3ee8:	4581                	li	a1,0
    3eea:	00002517          	auipc	a0,0x2
    3eee:	b9650513          	addi	a0,a0,-1130 # 5a80 <malloc+0x81a>
    3ef2:	6c9000ef          	jal	4dba <open>
    3ef6:	892a                	mv	s2,a0
  n = 0;
    3ef8:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3efa:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    3efe:	02700b13          	li	s6,39
      fa[i] = 1;
    3f02:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    3f04:	4641                	li	a2,16
    3f06:	f7040593          	addi	a1,s0,-144
    3f0a:	854a                	mv	a0,s2
    3f0c:	687000ef          	jal	4d92 <read>
    3f10:	06a05a63          	blez	a0,3f84 <concreate+0x13c>
    if(de.inum == 0)
    3f14:	f7045783          	lhu	a5,-144(s0)
    3f18:	d7f5                	beqz	a5,3f04 <concreate+0xbc>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3f1a:	f7244783          	lbu	a5,-142(s0)
    3f1e:	ff4793e3          	bne	a5,s4,3f04 <concreate+0xbc>
    3f22:	f7444783          	lbu	a5,-140(s0)
    3f26:	fff9                	bnez	a5,3f04 <concreate+0xbc>
      i = de.name[1] - '0';
    3f28:	f7344783          	lbu	a5,-141(s0)
    3f2c:	fd07879b          	addiw	a5,a5,-48
    3f30:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    3f34:	02eb6063          	bltu	s6,a4,3f54 <concreate+0x10c>
      if(fa[i]){
    3f38:	fb070793          	addi	a5,a4,-80
    3f3c:	97a2                	add	a5,a5,s0
    3f3e:	fd07c783          	lbu	a5,-48(a5)
    3f42:	e78d                	bnez	a5,3f6c <concreate+0x124>
      fa[i] = 1;
    3f44:	fb070793          	addi	a5,a4,-80
    3f48:	00878733          	add	a4,a5,s0
    3f4c:	fd770823          	sb	s7,-48(a4)
      n++;
    3f50:	2a85                	addiw	s5,s5,1
    3f52:	bf4d                	j	3f04 <concreate+0xbc>
        printf("%s: concreate weird file %s\n", s, de.name);
    3f54:	f7240613          	addi	a2,s0,-142
    3f58:	85ce                	mv	a1,s3
    3f5a:	00003517          	auipc	a0,0x3
    3f5e:	0ee50513          	addi	a0,a0,238 # 7048 <malloc+0x1de2>
    3f62:	250010ef          	jal	51b2 <printf>
        exit(1);
    3f66:	4505                	li	a0,1
    3f68:	613000ef          	jal	4d7a <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3f6c:	f7240613          	addi	a2,s0,-142
    3f70:	85ce                	mv	a1,s3
    3f72:	00003517          	auipc	a0,0x3
    3f76:	0f650513          	addi	a0,a0,246 # 7068 <malloc+0x1e02>
    3f7a:	238010ef          	jal	51b2 <printf>
        exit(1);
    3f7e:	4505                	li	a0,1
    3f80:	5fb000ef          	jal	4d7a <exit>
  close(fd);
    3f84:	854a                	mv	a0,s2
    3f86:	61d000ef          	jal	4da2 <close>
  if(n != N){
    3f8a:	02800793          	li	a5,40
    3f8e:	00fa9763          	bne	s5,a5,3f9c <concreate+0x154>
    if(((i % 3) == 0 && pid == 0) ||
    3f92:	4a8d                	li	s5,3
    3f94:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    3f96:	02800a13          	li	s4,40
    3f9a:	a079                	j	4028 <concreate+0x1e0>
    printf("%s: concreate not enough files in directory listing\n", s);
    3f9c:	85ce                	mv	a1,s3
    3f9e:	00003517          	auipc	a0,0x3
    3fa2:	0f250513          	addi	a0,a0,242 # 7090 <malloc+0x1e2a>
    3fa6:	20c010ef          	jal	51b2 <printf>
    exit(1);
    3faa:	4505                	li	a0,1
    3fac:	5cf000ef          	jal	4d7a <exit>
      printf("%s: fork failed\n", s);
    3fb0:	85ce                	mv	a1,s3
    3fb2:	00002517          	auipc	a0,0x2
    3fb6:	c7650513          	addi	a0,a0,-906 # 5c28 <malloc+0x9c2>
    3fba:	1f8010ef          	jal	51b2 <printf>
      exit(1);
    3fbe:	4505                	li	a0,1
    3fc0:	5bb000ef          	jal	4d7a <exit>
      close(open(file, 0));
    3fc4:	4581                	li	a1,0
    3fc6:	fa840513          	addi	a0,s0,-88
    3fca:	5f1000ef          	jal	4dba <open>
    3fce:	5d5000ef          	jal	4da2 <close>
      close(open(file, 0));
    3fd2:	4581                	li	a1,0
    3fd4:	fa840513          	addi	a0,s0,-88
    3fd8:	5e3000ef          	jal	4dba <open>
    3fdc:	5c7000ef          	jal	4da2 <close>
      close(open(file, 0));
    3fe0:	4581                	li	a1,0
    3fe2:	fa840513          	addi	a0,s0,-88
    3fe6:	5d5000ef          	jal	4dba <open>
    3fea:	5b9000ef          	jal	4da2 <close>
      close(open(file, 0));
    3fee:	4581                	li	a1,0
    3ff0:	fa840513          	addi	a0,s0,-88
    3ff4:	5c7000ef          	jal	4dba <open>
    3ff8:	5ab000ef          	jal	4da2 <close>
      close(open(file, 0));
    3ffc:	4581                	li	a1,0
    3ffe:	fa840513          	addi	a0,s0,-88
    4002:	5b9000ef          	jal	4dba <open>
    4006:	59d000ef          	jal	4da2 <close>
      close(open(file, 0));
    400a:	4581                	li	a1,0
    400c:	fa840513          	addi	a0,s0,-88
    4010:	5ab000ef          	jal	4dba <open>
    4014:	58f000ef          	jal	4da2 <close>
    if(pid == 0)
    4018:	06090363          	beqz	s2,407e <concreate+0x236>
      wait(0);
    401c:	4501                	li	a0,0
    401e:	565000ef          	jal	4d82 <wait>
  for(i = 0; i < N; i++){
    4022:	2485                	addiw	s1,s1,1
    4024:	0b448963          	beq	s1,s4,40d6 <concreate+0x28e>
    file[1] = '0' + i;
    4028:	0304879b          	addiw	a5,s1,48
    402c:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4030:	543000ef          	jal	4d72 <fork>
    4034:	892a                	mv	s2,a0
    if(pid < 0){
    4036:	f6054de3          	bltz	a0,3fb0 <concreate+0x168>
    if(((i % 3) == 0 && pid == 0) ||
    403a:	0354e73b          	remw	a4,s1,s5
    403e:	00a767b3          	or	a5,a4,a0
    4042:	2781                	sext.w	a5,a5
    4044:	d3c1                	beqz	a5,3fc4 <concreate+0x17c>
    4046:	01671363          	bne	a4,s6,404c <concreate+0x204>
       ((i % 3) == 1 && pid != 0)){
    404a:	fd2d                	bnez	a0,3fc4 <concreate+0x17c>
      unlink(file);
    404c:	fa840513          	addi	a0,s0,-88
    4050:	57b000ef          	jal	4dca <unlink>
      unlink(file);
    4054:	fa840513          	addi	a0,s0,-88
    4058:	573000ef          	jal	4dca <unlink>
      unlink(file);
    405c:	fa840513          	addi	a0,s0,-88
    4060:	56b000ef          	jal	4dca <unlink>
      unlink(file);
    4064:	fa840513          	addi	a0,s0,-88
    4068:	563000ef          	jal	4dca <unlink>
      unlink(file);
    406c:	fa840513          	addi	a0,s0,-88
    4070:	55b000ef          	jal	4dca <unlink>
      unlink(file);
    4074:	fa840513          	addi	a0,s0,-88
    4078:	553000ef          	jal	4dca <unlink>
    407c:	bf71                	j	4018 <concreate+0x1d0>
      exit(0);
    407e:	4501                	li	a0,0
    4080:	4fb000ef          	jal	4d7a <exit>
      close(fd);
    4084:	51f000ef          	jal	4da2 <close>
    if(pid == 0) {
    4088:	b599                	j	3ece <concreate+0x86>
      close(fd);
    408a:	519000ef          	jal	4da2 <close>
      wait(&xstatus);
    408e:	f6c40513          	addi	a0,s0,-148
    4092:	4f1000ef          	jal	4d82 <wait>
      if(xstatus != 0)
    4096:	f6c42483          	lw	s1,-148(s0)
    409a:	e2049de3          	bnez	s1,3ed4 <concreate+0x8c>
  for(i = 0; i < N; i++){
    409e:	2905                	addiw	s2,s2,1
    40a0:	e3490de3          	beq	s2,s4,3eda <concreate+0x92>
    file[1] = '0' + i;
    40a4:	0309079b          	addiw	a5,s2,48
    40a8:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    40ac:	fa840513          	addi	a0,s0,-88
    40b0:	51b000ef          	jal	4dca <unlink>
    pid = fork();
    40b4:	4bf000ef          	jal	4d72 <fork>
    if(pid && (i % 3) == 1){
    40b8:	dc050ae3          	beqz	a0,3e8c <concreate+0x44>
    40bc:	036967bb          	remw	a5,s2,s6
    40c0:	dd5780e3          	beq	a5,s5,3e80 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    40c4:	20200593          	li	a1,514
    40c8:	fa840513          	addi	a0,s0,-88
    40cc:	4ef000ef          	jal	4dba <open>
      if(fd < 0){
    40d0:	fa055de3          	bgez	a0,408a <concreate+0x242>
    40d4:	bbd1                	j	3ea8 <concreate+0x60>
}
    40d6:	60ea                	ld	ra,152(sp)
    40d8:	644a                	ld	s0,144(sp)
    40da:	64aa                	ld	s1,136(sp)
    40dc:	690a                	ld	s2,128(sp)
    40de:	79e6                	ld	s3,120(sp)
    40e0:	7a46                	ld	s4,112(sp)
    40e2:	7aa6                	ld	s5,104(sp)
    40e4:	7b06                	ld	s6,96(sp)
    40e6:	6be6                	ld	s7,88(sp)
    40e8:	610d                	addi	sp,sp,160
    40ea:	8082                	ret

00000000000040ec <bigfile>:
{
    40ec:	7139                	addi	sp,sp,-64
    40ee:	fc06                	sd	ra,56(sp)
    40f0:	f822                	sd	s0,48(sp)
    40f2:	f426                	sd	s1,40(sp)
    40f4:	f04a                	sd	s2,32(sp)
    40f6:	ec4e                	sd	s3,24(sp)
    40f8:	e852                	sd	s4,16(sp)
    40fa:	e456                	sd	s5,8(sp)
    40fc:	0080                	addi	s0,sp,64
    40fe:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4100:	00003517          	auipc	a0,0x3
    4104:	fc850513          	addi	a0,a0,-56 # 70c8 <malloc+0x1e62>
    4108:	4c3000ef          	jal	4dca <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    410c:	20200593          	li	a1,514
    4110:	00003517          	auipc	a0,0x3
    4114:	fb850513          	addi	a0,a0,-72 # 70c8 <malloc+0x1e62>
    4118:	4a3000ef          	jal	4dba <open>
    411c:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    411e:	4481                	li	s1,0
    memset(buf, i, SZ);
    4120:	00008917          	auipc	s2,0x8
    4124:	b9890913          	addi	s2,s2,-1128 # bcb8 <buf>
  for(i = 0; i < N; i++){
    4128:	4a51                	li	s4,20
  if(fd < 0){
    412a:	08054663          	bltz	a0,41b6 <bigfile+0xca>
    memset(buf, i, SZ);
    412e:	25800613          	li	a2,600
    4132:	85a6                	mv	a1,s1
    4134:	854a                	mv	a0,s2
    4136:	233000ef          	jal	4b68 <memset>
    if(write(fd, buf, SZ) != SZ){
    413a:	25800613          	li	a2,600
    413e:	85ca                	mv	a1,s2
    4140:	854e                	mv	a0,s3
    4142:	459000ef          	jal	4d9a <write>
    4146:	25800793          	li	a5,600
    414a:	08f51063          	bne	a0,a5,41ca <bigfile+0xde>
  for(i = 0; i < N; i++){
    414e:	2485                	addiw	s1,s1,1
    4150:	fd449fe3          	bne	s1,s4,412e <bigfile+0x42>
  close(fd);
    4154:	854e                	mv	a0,s3
    4156:	44d000ef          	jal	4da2 <close>
  fd = open("bigfile.dat", 0);
    415a:	4581                	li	a1,0
    415c:	00003517          	auipc	a0,0x3
    4160:	f6c50513          	addi	a0,a0,-148 # 70c8 <malloc+0x1e62>
    4164:	457000ef          	jal	4dba <open>
    4168:	8a2a                	mv	s4,a0
  total = 0;
    416a:	4981                	li	s3,0
  for(i = 0; ; i++){
    416c:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    416e:	00008917          	auipc	s2,0x8
    4172:	b4a90913          	addi	s2,s2,-1206 # bcb8 <buf>
  if(fd < 0){
    4176:	06054463          	bltz	a0,41de <bigfile+0xf2>
    cc = read(fd, buf, SZ/2);
    417a:	12c00613          	li	a2,300
    417e:	85ca                	mv	a1,s2
    4180:	8552                	mv	a0,s4
    4182:	411000ef          	jal	4d92 <read>
    if(cc < 0){
    4186:	06054663          	bltz	a0,41f2 <bigfile+0x106>
    if(cc == 0)
    418a:	c155                	beqz	a0,422e <bigfile+0x142>
    if(cc != SZ/2){
    418c:	12c00793          	li	a5,300
    4190:	06f51b63          	bne	a0,a5,4206 <bigfile+0x11a>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4194:	01f4d79b          	srliw	a5,s1,0x1f
    4198:	9fa5                	addw	a5,a5,s1
    419a:	4017d79b          	sraiw	a5,a5,0x1
    419e:	00094703          	lbu	a4,0(s2)
    41a2:	06f71c63          	bne	a4,a5,421a <bigfile+0x12e>
    41a6:	12b94703          	lbu	a4,299(s2)
    41aa:	06f71863          	bne	a4,a5,421a <bigfile+0x12e>
    total += cc;
    41ae:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    41b2:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    41b4:	b7d9                	j	417a <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    41b6:	85d6                	mv	a1,s5
    41b8:	00003517          	auipc	a0,0x3
    41bc:	f2050513          	addi	a0,a0,-224 # 70d8 <malloc+0x1e72>
    41c0:	7f3000ef          	jal	51b2 <printf>
    exit(1);
    41c4:	4505                	li	a0,1
    41c6:	3b5000ef          	jal	4d7a <exit>
      printf("%s: write bigfile failed\n", s);
    41ca:	85d6                	mv	a1,s5
    41cc:	00003517          	auipc	a0,0x3
    41d0:	f2c50513          	addi	a0,a0,-212 # 70f8 <malloc+0x1e92>
    41d4:	7df000ef          	jal	51b2 <printf>
      exit(1);
    41d8:	4505                	li	a0,1
    41da:	3a1000ef          	jal	4d7a <exit>
    printf("%s: cannot open bigfile\n", s);
    41de:	85d6                	mv	a1,s5
    41e0:	00003517          	auipc	a0,0x3
    41e4:	f3850513          	addi	a0,a0,-200 # 7118 <malloc+0x1eb2>
    41e8:	7cb000ef          	jal	51b2 <printf>
    exit(1);
    41ec:	4505                	li	a0,1
    41ee:	38d000ef          	jal	4d7a <exit>
      printf("%s: read bigfile failed\n", s);
    41f2:	85d6                	mv	a1,s5
    41f4:	00003517          	auipc	a0,0x3
    41f8:	f4450513          	addi	a0,a0,-188 # 7138 <malloc+0x1ed2>
    41fc:	7b7000ef          	jal	51b2 <printf>
      exit(1);
    4200:	4505                	li	a0,1
    4202:	379000ef          	jal	4d7a <exit>
      printf("%s: short read bigfile\n", s);
    4206:	85d6                	mv	a1,s5
    4208:	00003517          	auipc	a0,0x3
    420c:	f5050513          	addi	a0,a0,-176 # 7158 <malloc+0x1ef2>
    4210:	7a3000ef          	jal	51b2 <printf>
      exit(1);
    4214:	4505                	li	a0,1
    4216:	365000ef          	jal	4d7a <exit>
      printf("%s: read bigfile wrong data\n", s);
    421a:	85d6                	mv	a1,s5
    421c:	00003517          	auipc	a0,0x3
    4220:	f5450513          	addi	a0,a0,-172 # 7170 <malloc+0x1f0a>
    4224:	78f000ef          	jal	51b2 <printf>
      exit(1);
    4228:	4505                	li	a0,1
    422a:	351000ef          	jal	4d7a <exit>
  close(fd);
    422e:	8552                	mv	a0,s4
    4230:	373000ef          	jal	4da2 <close>
  if(total != N*SZ){
    4234:	678d                	lui	a5,0x3
    4236:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x318>
    423a:	02f99163          	bne	s3,a5,425c <bigfile+0x170>
  unlink("bigfile.dat");
    423e:	00003517          	auipc	a0,0x3
    4242:	e8a50513          	addi	a0,a0,-374 # 70c8 <malloc+0x1e62>
    4246:	385000ef          	jal	4dca <unlink>
}
    424a:	70e2                	ld	ra,56(sp)
    424c:	7442                	ld	s0,48(sp)
    424e:	74a2                	ld	s1,40(sp)
    4250:	7902                	ld	s2,32(sp)
    4252:	69e2                	ld	s3,24(sp)
    4254:	6a42                	ld	s4,16(sp)
    4256:	6aa2                	ld	s5,8(sp)
    4258:	6121                	addi	sp,sp,64
    425a:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    425c:	85d6                	mv	a1,s5
    425e:	00003517          	auipc	a0,0x3
    4262:	f3250513          	addi	a0,a0,-206 # 7190 <malloc+0x1f2a>
    4266:	74d000ef          	jal	51b2 <printf>
    exit(1);
    426a:	4505                	li	a0,1
    426c:	30f000ef          	jal	4d7a <exit>

0000000000004270 <bigargtest>:
{
    4270:	7121                	addi	sp,sp,-448
    4272:	ff06                	sd	ra,440(sp)
    4274:	fb22                	sd	s0,432(sp)
    4276:	f726                	sd	s1,424(sp)
    4278:	0380                	addi	s0,sp,448
    427a:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    427c:	00003517          	auipc	a0,0x3
    4280:	f3450513          	addi	a0,a0,-204 # 71b0 <malloc+0x1f4a>
    4284:	347000ef          	jal	4dca <unlink>
  pid = fork();
    4288:	2eb000ef          	jal	4d72 <fork>
  if(pid == 0){
    428c:	c915                	beqz	a0,42c0 <bigargtest+0x50>
  } else if(pid < 0){
    428e:	08054a63          	bltz	a0,4322 <bigargtest+0xb2>
  wait(&xstatus);
    4292:	fdc40513          	addi	a0,s0,-36
    4296:	2ed000ef          	jal	4d82 <wait>
  if(xstatus != 0)
    429a:	fdc42503          	lw	a0,-36(s0)
    429e:	ed41                	bnez	a0,4336 <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    42a0:	4581                	li	a1,0
    42a2:	00003517          	auipc	a0,0x3
    42a6:	f0e50513          	addi	a0,a0,-242 # 71b0 <malloc+0x1f4a>
    42aa:	311000ef          	jal	4dba <open>
  if(fd < 0){
    42ae:	08054663          	bltz	a0,433a <bigargtest+0xca>
  close(fd);
    42b2:	2f1000ef          	jal	4da2 <close>
}
    42b6:	70fa                	ld	ra,440(sp)
    42b8:	745a                	ld	s0,432(sp)
    42ba:	74ba                	ld	s1,424(sp)
    42bc:	6139                	addi	sp,sp,448
    42be:	8082                	ret
    memset(big, ' ', sizeof(big));
    42c0:	19000613          	li	a2,400
    42c4:	02000593          	li	a1,32
    42c8:	e4840513          	addi	a0,s0,-440
    42cc:	09d000ef          	jal	4b68 <memset>
    big[sizeof(big)-1] = '\0';
    42d0:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    42d4:	00004797          	auipc	a5,0x4
    42d8:	1cc78793          	addi	a5,a5,460 # 84a0 <args.1>
    42dc:	00004697          	auipc	a3,0x4
    42e0:	2bc68693          	addi	a3,a3,700 # 8598 <args.1+0xf8>
      args[i] = big;
    42e4:	e4840713          	addi	a4,s0,-440
    42e8:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    42ea:	07a1                	addi	a5,a5,8
    42ec:	fed79ee3          	bne	a5,a3,42e8 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    42f0:	00004597          	auipc	a1,0x4
    42f4:	1b058593          	addi	a1,a1,432 # 84a0 <args.1>
    42f8:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    42fc:	00001517          	auipc	a0,0x1
    4300:	09c50513          	addi	a0,a0,156 # 5398 <malloc+0x132>
    4304:	2af000ef          	jal	4db2 <exec>
    fd = open("bigarg-ok", O_CREATE);
    4308:	20000593          	li	a1,512
    430c:	00003517          	auipc	a0,0x3
    4310:	ea450513          	addi	a0,a0,-348 # 71b0 <malloc+0x1f4a>
    4314:	2a7000ef          	jal	4dba <open>
    close(fd);
    4318:	28b000ef          	jal	4da2 <close>
    exit(0);
    431c:	4501                	li	a0,0
    431e:	25d000ef          	jal	4d7a <exit>
    printf("%s: bigargtest: fork failed\n", s);
    4322:	85a6                	mv	a1,s1
    4324:	00003517          	auipc	a0,0x3
    4328:	e9c50513          	addi	a0,a0,-356 # 71c0 <malloc+0x1f5a>
    432c:	687000ef          	jal	51b2 <printf>
    exit(1);
    4330:	4505                	li	a0,1
    4332:	249000ef          	jal	4d7a <exit>
    exit(xstatus);
    4336:	245000ef          	jal	4d7a <exit>
    printf("%s: bigarg test failed!\n", s);
    433a:	85a6                	mv	a1,s1
    433c:	00003517          	auipc	a0,0x3
    4340:	ea450513          	addi	a0,a0,-348 # 71e0 <malloc+0x1f7a>
    4344:	66f000ef          	jal	51b2 <printf>
    exit(1);
    4348:	4505                	li	a0,1
    434a:	231000ef          	jal	4d7a <exit>

000000000000434e <lazy_alloc>:
{
    434e:	1141                	addi	sp,sp,-16
    4350:	e406                	sd	ra,8(sp)
    4352:	e022                	sd	s0,0(sp)
    4354:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    4356:	40000537          	lui	a0,0x40000
    435a:	203000ef          	jal	4d5c <sbrklazy>
  if (prev_end == (char *) SBRK_ERROR) {
    435e:	57fd                	li	a5,-1
    4360:	02f50a63          	beq	a0,a5,4394 <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4364:	6605                	lui	a2,0x1
    4366:	962a                	add	a2,a2,a0
    4368:	400017b7          	lui	a5,0x40001
    436c:	00f50733          	add	a4,a0,a5
    4370:	87b2                	mv	a5,a2
    4372:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    4376:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4378:	97b6                	add	a5,a5,a3
    437a:	fee79ee3          	bne	a5,a4,4376 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    437e:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    4382:	621c                	ld	a5,0(a2)
    4384:	02c79163          	bne	a5,a2,43a6 <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4388:	9636                	add	a2,a2,a3
    438a:	fee61ce3          	bne	a2,a4,4382 <lazy_alloc+0x34>
  exit(0);
    438e:	4501                	li	a0,0
    4390:	1eb000ef          	jal	4d7a <exit>
    printf("sbrklazy() failed\n");
    4394:	00003517          	auipc	a0,0x3
    4398:	e6c50513          	addi	a0,a0,-404 # 7200 <malloc+0x1f9a>
    439c:	617000ef          	jal	51b2 <printf>
    exit(1);
    43a0:	4505                	li	a0,1
    43a2:	1d9000ef          	jal	4d7a <exit>
      printf("failed to read value from memory\n");
    43a6:	00003517          	auipc	a0,0x3
    43aa:	e7250513          	addi	a0,a0,-398 # 7218 <malloc+0x1fb2>
    43ae:	605000ef          	jal	51b2 <printf>
      exit(1);
    43b2:	4505                	li	a0,1
    43b4:	1c7000ef          	jal	4d7a <exit>

00000000000043b8 <lazy_unmap>:
{
    43b8:	7139                	addi	sp,sp,-64
    43ba:	fc06                	sd	ra,56(sp)
    43bc:	f822                	sd	s0,48(sp)
    43be:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    43c0:	40000537          	lui	a0,0x40000
    43c4:	199000ef          	jal	4d5c <sbrklazy>
  if (prev_end == (char*)SBRK_ERROR) {
    43c8:	57fd                	li	a5,-1
    43ca:	04f50663          	beq	a0,a5,4416 <lazy_unmap+0x5e>
    43ce:	f426                	sd	s1,40(sp)
    43d0:	f04a                	sd	s2,32(sp)
    43d2:	ec4e                	sd	s3,24(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    43d4:	6905                	lui	s2,0x1
    43d6:	992a                	add	s2,s2,a0
    43d8:	400017b7          	lui	a5,0x40001
    43dc:	00f504b3          	add	s1,a0,a5
    43e0:	87ca                	mv	a5,s2
    43e2:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    43e6:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    43e8:	97ba                	add	a5,a5,a4
    43ea:	fe979ee3          	bne	a5,s1,43e6 <lazy_unmap+0x2e>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    43ee:	010009b7          	lui	s3,0x1000
    pid = fork();
    43f2:	181000ef          	jal	4d72 <fork>
    if (pid < 0) {
    43f6:	02054c63          	bltz	a0,442e <lazy_unmap+0x76>
    } else if (pid == 0) {
    43fa:	c139                	beqz	a0,4440 <lazy_unmap+0x88>
      wait(&status);
    43fc:	fcc40513          	addi	a0,s0,-52
    4400:	183000ef          	jal	4d82 <wait>
      if (status == 0) {
    4404:	fcc42783          	lw	a5,-52(s0)
    4408:	c7a9                	beqz	a5,4452 <lazy_unmap+0x9a>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    440a:	994e                	add	s2,s2,s3
    440c:	fe9913e3          	bne	s2,s1,43f2 <lazy_unmap+0x3a>
  exit(0);
    4410:	4501                	li	a0,0
    4412:	169000ef          	jal	4d7a <exit>
    4416:	f426                	sd	s1,40(sp)
    4418:	f04a                	sd	s2,32(sp)
    441a:	ec4e                	sd	s3,24(sp)
    printf("sbrklazy() failed\n");
    441c:	00003517          	auipc	a0,0x3
    4420:	de450513          	addi	a0,a0,-540 # 7200 <malloc+0x1f9a>
    4424:	58f000ef          	jal	51b2 <printf>
    exit(1);
    4428:	4505                	li	a0,1
    442a:	151000ef          	jal	4d7a <exit>
      printf("error forking\n");
    442e:	00003517          	auipc	a0,0x3
    4432:	e1250513          	addi	a0,a0,-494 # 7240 <malloc+0x1fda>
    4436:	57d000ef          	jal	51b2 <printf>
      exit(1);
    443a:	4505                	li	a0,1
    443c:	13f000ef          	jal	4d7a <exit>
      sbrklazy(-1L * REGION_SZ);
    4440:	c0000537          	lui	a0,0xc0000
    4444:	119000ef          	jal	4d5c <sbrklazy>
      *(char **)i = i;
    4448:	01293023          	sd	s2,0(s2) # 1000 <pgbug+0x28>
      exit(0);
    444c:	4501                	li	a0,0
    444e:	12d000ef          	jal	4d7a <exit>
        printf("memory not unmapped\n");
    4452:	00003517          	auipc	a0,0x3
    4456:	dfe50513          	addi	a0,a0,-514 # 7250 <malloc+0x1fea>
    445a:	559000ef          	jal	51b2 <printf>
        exit(1);
    445e:	4505                	li	a0,1
    4460:	11b000ef          	jal	4d7a <exit>

0000000000004464 <lazy_copy>:
{
    4464:	7159                	addi	sp,sp,-112
    4466:	f486                	sd	ra,104(sp)
    4468:	f0a2                	sd	s0,96(sp)
    446a:	eca6                	sd	s1,88(sp)
    446c:	e8ca                	sd	s2,80(sp)
    446e:	e4ce                	sd	s3,72(sp)
    4470:	e0d2                	sd	s4,64(sp)
    4472:	fc56                	sd	s5,56(sp)
    4474:	f85a                	sd	s6,48(sp)
    4476:	1880                	addi	s0,sp,112
    char *p = sbrk(0);
    4478:	4501                	li	a0,0
    447a:	0cd000ef          	jal	4d46 <sbrk>
    447e:	84aa                	mv	s1,a0
    sbrklazy(4*PGSIZE);
    4480:	6511                	lui	a0,0x4
    4482:	0db000ef          	jal	4d5c <sbrklazy>
    open(p + 8192, 0);
    4486:	4581                	li	a1,0
    4488:	6509                	lui	a0,0x2
    448a:	9526                	add	a0,a0,s1
    448c:	12f000ef          	jal	4dba <open>
    void *xx = sbrk(0);
    4490:	4501                	li	a0,0
    4492:	0b5000ef          	jal	4d46 <sbrk>
    4496:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64) xx)+1));
    4498:	fff54513          	not	a0,a0
    449c:	2501                	sext.w	a0,a0
    449e:	0a9000ef          	jal	4d46 <sbrk>
    if(ret != xx){
    44a2:	00a48c63          	beq	s1,a0,44ba <lazy_copy+0x56>
    44a6:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    44a8:	00003517          	auipc	a0,0x3
    44ac:	dc050513          	addi	a0,a0,-576 # 7268 <malloc+0x2002>
    44b0:	503000ef          	jal	51b2 <printf>
      exit(1);
    44b4:	4505                	li	a0,1
    44b6:	0c5000ef          	jal	4d7a <exit>
  unsigned long bad[] = {
    44ba:	00003797          	auipc	a5,0x3
    44be:	42678793          	addi	a5,a5,1062 # 78e0 <malloc+0x267a>
    44c2:	7fa8                	ld	a0,120(a5)
    44c4:	63cc                	ld	a1,128(a5)
    44c6:	67d0                	ld	a2,136(a5)
    44c8:	6bd4                	ld	a3,144(a5)
    44ca:	6fd8                	ld	a4,152(a5)
    44cc:	73dc                	ld	a5,160(a5)
    44ce:	f8a43823          	sd	a0,-112(s0)
    44d2:	f8b43c23          	sd	a1,-104(s0)
    44d6:	fac43023          	sd	a2,-96(s0)
    44da:	fad43423          	sd	a3,-88(s0)
    44de:	fae43823          	sd	a4,-80(s0)
    44e2:	faf43c23          	sd	a5,-72(s0)
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    44e6:	f9040913          	addi	s2,s0,-112
    44ea:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
    44ee:	00001a17          	auipc	s4,0x1
    44f2:	082a0a13          	addi	s4,s4,130 # 5570 <malloc+0x30a>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    44f6:	00001a97          	auipc	s5,0x1
    44fa:	f8aa8a93          	addi	s5,s5,-118 # 5480 <malloc+0x21a>
    int fd = open("README", 0);
    44fe:	4581                	li	a1,0
    4500:	8552                	mv	a0,s4
    4502:	0b9000ef          	jal	4dba <open>
    4506:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    4508:	04054663          	bltz	a0,4554 <lazy_copy+0xf0>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    450c:	00093983          	ld	s3,0(s2)
    4510:	20000613          	li	a2,512
    4514:	85ce                	mv	a1,s3
    4516:	07d000ef          	jal	4d92 <read>
    451a:	04055663          	bgez	a0,4566 <lazy_copy+0x102>
    close(fd);
    451e:	8526                	mv	a0,s1
    4520:	083000ef          	jal	4da2 <close>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    4524:	60200593          	li	a1,1538
    4528:	8556                	mv	a0,s5
    452a:	091000ef          	jal	4dba <open>
    452e:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    4530:	04054463          	bltz	a0,4578 <lazy_copy+0x114>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    4534:	20000613          	li	a2,512
    4538:	85ce                	mv	a1,s3
    453a:	061000ef          	jal	4d9a <write>
    453e:	04055663          	bgez	a0,458a <lazy_copy+0x126>
    close(fd);
    4542:	8526                	mv	a0,s1
    4544:	05f000ef          	jal	4da2 <close>
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    4548:	0921                	addi	s2,s2,8
    454a:	fb691ae3          	bne	s2,s6,44fe <lazy_copy+0x9a>
  exit(0);
    454e:	4501                	li	a0,0
    4550:	02b000ef          	jal	4d7a <exit>
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    4554:	00003517          	auipc	a0,0x3
    4558:	d4450513          	addi	a0,a0,-700 # 7298 <malloc+0x2032>
    455c:	457000ef          	jal	51b2 <printf>
    4560:	4505                	li	a0,1
    4562:	019000ef          	jal	4d7a <exit>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4566:	00003517          	auipc	a0,0x3
    456a:	d4a50513          	addi	a0,a0,-694 # 72b0 <malloc+0x204a>
    456e:	445000ef          	jal	51b2 <printf>
    4572:	4505                	li	a0,1
    4574:	007000ef          	jal	4d7a <exit>
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    4578:	00003517          	auipc	a0,0x3
    457c:	d4850513          	addi	a0,a0,-696 # 72c0 <malloc+0x205a>
    4580:	433000ef          	jal	51b2 <printf>
    4584:	4505                	li	a0,1
    4586:	7f4000ef          	jal	4d7a <exit>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    458a:	00003517          	auipc	a0,0x3
    458e:	d4e50513          	addi	a0,a0,-690 # 72d8 <malloc+0x2072>
    4592:	421000ef          	jal	51b2 <printf>
    4596:	4505                	li	a0,1
    4598:	7e2000ef          	jal	4d7a <exit>

000000000000459c <lazy_sbrk>:
{
    459c:	1101                	addi	sp,sp,-32
    459e:	ec06                	sd	ra,24(sp)
    45a0:	e822                	sd	s0,16(sp)
    45a2:	e426                	sd	s1,8(sp)
    45a4:	e04a                	sd	s2,0(sp)
    45a6:	1000                	addi	s0,sp,32
  char *p = sbrk(0);
    45a8:	4501                	li	a0,0
    45aa:	79c000ef          	jal	4d46 <sbrk>
    45ae:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    45b0:	0ff00793          	li	a5,255
    45b4:	07fa                	slli	a5,a5,0x1e
    45b6:	00f57d63          	bgeu	a0,a5,45d0 <lazy_sbrk+0x34>
    45ba:	893e                	mv	s2,a5
    p = sbrklazy(1<<30);
    45bc:	40000537          	lui	a0,0x40000
    45c0:	79c000ef          	jal	4d5c <sbrklazy>
    p = sbrklazy(0);
    45c4:	4501                	li	a0,0
    45c6:	796000ef          	jal	4d5c <sbrklazy>
    45ca:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    45cc:	ff2568e3          	bltu	a0,s2,45bc <lazy_sbrk+0x20>
  int n = TRAPFRAME-PGSIZE-(uint64)p;
    45d0:	7975                	lui	s2,0xffffd
    45d2:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    45d6:	854a                	mv	a0,s2
    45d8:	784000ef          	jal	4d5c <sbrklazy>
    45dc:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    45de:	00950d63          	beq	a0,s1,45f8 <lazy_sbrk+0x5c>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    45e2:	86a6                	mv	a3,s1
    45e4:	85ca                	mv	a1,s2
    45e6:	00003517          	auipc	a0,0x3
    45ea:	d0a50513          	addi	a0,a0,-758 # 72f0 <malloc+0x208a>
    45ee:	3c5000ef          	jal	51b2 <printf>
    exit(1);
    45f2:	4505                	li	a0,1
    45f4:	786000ef          	jal	4d7a <exit>
  p = sbrk(PGSIZE);
    45f8:	6505                	lui	a0,0x1
    45fa:	74c000ef          	jal	4d46 <sbrk>
    45fe:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME-PGSIZE) {
    4600:	040007b7          	lui	a5,0x4000
    4604:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff1345>
    4606:	07b2                	slli	a5,a5,0xc
    4608:	00f50c63          	beq	a0,a5,4620 <lazy_sbrk+0x84>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    460c:	6585                	lui	a1,0x1
    460e:	00003517          	auipc	a0,0x3
    4612:	d1250513          	addi	a0,a0,-750 # 7320 <malloc+0x20ba>
    4616:	39d000ef          	jal	51b2 <printf>
    exit(1);
    461a:	4505                	li	a0,1
    461c:	75e000ef          	jal	4d7a <exit>
  p[0] = 1;
    4620:	040007b7          	lui	a5,0x4000
    4624:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff1345>
    4626:	07b2                	slli	a5,a5,0xc
    4628:	4705                	li	a4,1
    462a:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    462e:	0017c783          	lbu	a5,1(a5)
    4632:	cb91                	beqz	a5,4646 <lazy_sbrk+0xaa>
    printf("sbrk() returned non-zero-filled memory\n");
    4634:	00003517          	auipc	a0,0x3
    4638:	d2450513          	addi	a0,a0,-732 # 7358 <malloc+0x20f2>
    463c:	377000ef          	jal	51b2 <printf>
    exit(1);
    4640:	4505                	li	a0,1
    4642:	738000ef          	jal	4d7a <exit>
  p = sbrk(1);
    4646:	4505                	li	a0,1
    4648:	6fe000ef          	jal	4d46 <sbrk>
    464c:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    464e:	57fd                	li	a5,-1
    4650:	00f50b63          	beq	a0,a5,4666 <lazy_sbrk+0xca>
    printf("sbrk(1) returned %p, expected error\n", p);
    4654:	00003517          	auipc	a0,0x3
    4658:	d2c50513          	addi	a0,a0,-724 # 7380 <malloc+0x211a>
    465c:	357000ef          	jal	51b2 <printf>
    exit(1);
    4660:	4505                	li	a0,1
    4662:	718000ef          	jal	4d7a <exit>
  p = sbrklazy(1);
    4666:	4505                	li	a0,1
    4668:	6f4000ef          	jal	4d5c <sbrklazy>
    466c:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    466e:	57fd                	li	a5,-1
    4670:	00f50b63          	beq	a0,a5,4686 <lazy_sbrk+0xea>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    4674:	00003517          	auipc	a0,0x3
    4678:	d3450513          	addi	a0,a0,-716 # 73a8 <malloc+0x2142>
    467c:	337000ef          	jal	51b2 <printf>
    exit(1);
    4680:	4505                	li	a0,1
    4682:	6f8000ef          	jal	4d7a <exit>
  exit(0);
    4686:	4501                	li	a0,0
    4688:	6f2000ef          	jal	4d7a <exit>

000000000000468c <fsfull>:
{
    468c:	7135                	addi	sp,sp,-160
    468e:	ed06                	sd	ra,152(sp)
    4690:	e922                	sd	s0,144(sp)
    4692:	e526                	sd	s1,136(sp)
    4694:	e14a                	sd	s2,128(sp)
    4696:	fcce                	sd	s3,120(sp)
    4698:	f8d2                	sd	s4,112(sp)
    469a:	f4d6                	sd	s5,104(sp)
    469c:	f0da                	sd	s6,96(sp)
    469e:	ecde                	sd	s7,88(sp)
    46a0:	e8e2                	sd	s8,80(sp)
    46a2:	e4e6                	sd	s9,72(sp)
    46a4:	e0ea                	sd	s10,64(sp)
    46a6:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    46a8:	00003517          	auipc	a0,0x3
    46ac:	d3050513          	addi	a0,a0,-720 # 73d8 <malloc+0x2172>
    46b0:	303000ef          	jal	51b2 <printf>
  for(nfiles = 0; ; nfiles++){
    46b4:	4481                	li	s1,0
    name[0] = 'f';
    46b6:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    46ba:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    46be:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    46c2:	4b29                	li	s6,10
    printf("writing %s\n", name);
    46c4:	00003c97          	auipc	s9,0x3
    46c8:	d24c8c93          	addi	s9,s9,-732 # 73e8 <malloc+0x2182>
    name[0] = 'f';
    46cc:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    46d0:	0384c7bb          	divw	a5,s1,s8
    46d4:	0307879b          	addiw	a5,a5,48
    46d8:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    46dc:	0384e7bb          	remw	a5,s1,s8
    46e0:	0377c7bb          	divw	a5,a5,s7
    46e4:	0307879b          	addiw	a5,a5,48
    46e8:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    46ec:	0374e7bb          	remw	a5,s1,s7
    46f0:	0367c7bb          	divw	a5,a5,s6
    46f4:	0307879b          	addiw	a5,a5,48
    46f8:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    46fc:	0364e7bb          	remw	a5,s1,s6
    4700:	0307879b          	addiw	a5,a5,48
    4704:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4708:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    470c:	f6040593          	addi	a1,s0,-160
    4710:	8566                	mv	a0,s9
    4712:	2a1000ef          	jal	51b2 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4716:	20200593          	li	a1,514
    471a:	f6040513          	addi	a0,s0,-160
    471e:	69c000ef          	jal	4dba <open>
    4722:	892a                	mv	s2,a0
    if(fd < 0){
    4724:	08055f63          	bgez	a0,47c2 <fsfull+0x136>
      printf("open %s failed\n", name);
    4728:	f6040593          	addi	a1,s0,-160
    472c:	00003517          	auipc	a0,0x3
    4730:	ccc50513          	addi	a0,a0,-820 # 73f8 <malloc+0x2192>
    4734:	27f000ef          	jal	51b2 <printf>
  while(nfiles >= 0){
    4738:	0604c163          	bltz	s1,479a <fsfull+0x10e>
    name[0] = 'f';
    473c:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4740:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4744:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4748:	4929                	li	s2,10
  while(nfiles >= 0){
    474a:	5afd                	li	s5,-1
    name[0] = 'f';
    474c:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4750:	0344c7bb          	divw	a5,s1,s4
    4754:	0307879b          	addiw	a5,a5,48
    4758:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    475c:	0344e7bb          	remw	a5,s1,s4
    4760:	0337c7bb          	divw	a5,a5,s3
    4764:	0307879b          	addiw	a5,a5,48
    4768:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    476c:	0334e7bb          	remw	a5,s1,s3
    4770:	0327c7bb          	divw	a5,a5,s2
    4774:	0307879b          	addiw	a5,a5,48
    4778:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    477c:	0324e7bb          	remw	a5,s1,s2
    4780:	0307879b          	addiw	a5,a5,48
    4784:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4788:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    478c:	f6040513          	addi	a0,s0,-160
    4790:	63a000ef          	jal	4dca <unlink>
    nfiles--;
    4794:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4796:	fb549be3          	bne	s1,s5,474c <fsfull+0xc0>
  printf("fsfull test finished\n");
    479a:	00003517          	auipc	a0,0x3
    479e:	c7e50513          	addi	a0,a0,-898 # 7418 <malloc+0x21b2>
    47a2:	211000ef          	jal	51b2 <printf>
}
    47a6:	60ea                	ld	ra,152(sp)
    47a8:	644a                	ld	s0,144(sp)
    47aa:	64aa                	ld	s1,136(sp)
    47ac:	690a                	ld	s2,128(sp)
    47ae:	79e6                	ld	s3,120(sp)
    47b0:	7a46                	ld	s4,112(sp)
    47b2:	7aa6                	ld	s5,104(sp)
    47b4:	7b06                	ld	s6,96(sp)
    47b6:	6be6                	ld	s7,88(sp)
    47b8:	6c46                	ld	s8,80(sp)
    47ba:	6ca6                	ld	s9,72(sp)
    47bc:	6d06                	ld	s10,64(sp)
    47be:	610d                	addi	sp,sp,160
    47c0:	8082                	ret
    int total = 0;
    47c2:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    47c4:	00007a97          	auipc	s5,0x7
    47c8:	4f4a8a93          	addi	s5,s5,1268 # bcb8 <buf>
      if(cc < BSIZE)
    47cc:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    47d0:	40000613          	li	a2,1024
    47d4:	85d6                	mv	a1,s5
    47d6:	854a                	mv	a0,s2
    47d8:	5c2000ef          	jal	4d9a <write>
      if(cc < BSIZE)
    47dc:	00aa5563          	bge	s4,a0,47e6 <fsfull+0x15a>
      total += cc;
    47e0:	00a989bb          	addw	s3,s3,a0
    while(1){
    47e4:	b7f5                	j	47d0 <fsfull+0x144>
    printf("wrote %d bytes\n", total);
    47e6:	85ce                	mv	a1,s3
    47e8:	00003517          	auipc	a0,0x3
    47ec:	c2050513          	addi	a0,a0,-992 # 7408 <malloc+0x21a2>
    47f0:	1c3000ef          	jal	51b2 <printf>
    close(fd);
    47f4:	854a                	mv	a0,s2
    47f6:	5ac000ef          	jal	4da2 <close>
    if(total == 0)
    47fa:	f2098fe3          	beqz	s3,4738 <fsfull+0xac>
  for(nfiles = 0; ; nfiles++){
    47fe:	2485                	addiw	s1,s1,1
    4800:	b5f1                	j	46cc <fsfull+0x40>

0000000000004802 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4802:	7179                	addi	sp,sp,-48
    4804:	f406                	sd	ra,40(sp)
    4806:	f022                	sd	s0,32(sp)
    4808:	ec26                	sd	s1,24(sp)
    480a:	e84a                	sd	s2,16(sp)
    480c:	1800                	addi	s0,sp,48
    480e:	84aa                	mv	s1,a0
    4810:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4812:	00003517          	auipc	a0,0x3
    4816:	c1e50513          	addi	a0,a0,-994 # 7430 <malloc+0x21ca>
    481a:	199000ef          	jal	51b2 <printf>
  if((pid = fork()) < 0) {
    481e:	554000ef          	jal	4d72 <fork>
    4822:	02054a63          	bltz	a0,4856 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4826:	c129                	beqz	a0,4868 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4828:	fdc40513          	addi	a0,s0,-36
    482c:	556000ef          	jal	4d82 <wait>
    if(xstatus != 0) 
    4830:	fdc42783          	lw	a5,-36(s0)
    4834:	cf9d                	beqz	a5,4872 <run+0x70>
      printf("FAILED\n");
    4836:	00003517          	auipc	a0,0x3
    483a:	c2250513          	addi	a0,a0,-990 # 7458 <malloc+0x21f2>
    483e:	175000ef          	jal	51b2 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4842:	fdc42503          	lw	a0,-36(s0)
  }
}
    4846:	00153513          	seqz	a0,a0
    484a:	70a2                	ld	ra,40(sp)
    484c:	7402                	ld	s0,32(sp)
    484e:	64e2                	ld	s1,24(sp)
    4850:	6942                	ld	s2,16(sp)
    4852:	6145                	addi	sp,sp,48
    4854:	8082                	ret
    printf("runtest: fork error\n");
    4856:	00003517          	auipc	a0,0x3
    485a:	bea50513          	addi	a0,a0,-1046 # 7440 <malloc+0x21da>
    485e:	155000ef          	jal	51b2 <printf>
    exit(1);
    4862:	4505                	li	a0,1
    4864:	516000ef          	jal	4d7a <exit>
    f(s);
    4868:	854a                	mv	a0,s2
    486a:	9482                	jalr	s1
    exit(0);
    486c:	4501                	li	a0,0
    486e:	50c000ef          	jal	4d7a <exit>
      printf("OK\n");
    4872:	00003517          	auipc	a0,0x3
    4876:	bee50513          	addi	a0,a0,-1042 # 7460 <malloc+0x21fa>
    487a:	139000ef          	jal	51b2 <printf>
    487e:	b7d1                	j	4842 <run+0x40>

0000000000004880 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    4880:	7139                	addi	sp,sp,-64
    4882:	fc06                	sd	ra,56(sp)
    4884:	f822                	sd	s0,48(sp)
    4886:	f426                	sd	s1,40(sp)
    4888:	ec4e                	sd	s3,24(sp)
    488a:	0080                	addi	s0,sp,64
    488c:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    488e:	6508                	ld	a0,8(a0)
    4890:	cd39                	beqz	a0,48ee <runtests+0x6e>
    4892:	f04a                	sd	s2,32(sp)
    4894:	e852                	sd	s4,16(sp)
    4896:	e456                	sd	s5,8(sp)
    4898:	892e                	mv	s2,a1
    489a:	8a32                	mv	s4,a2
  int ntests = 0;
    489c:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if(!run(t->f, t->s)){
        if(continuous != 2){
    489e:	4a89                	li	s5,2
    48a0:	a021                	j	48a8 <runtests+0x28>
  for (struct test *t = tests; t->s != 0; t++) {
    48a2:	04c1                	addi	s1,s1,16
    48a4:	6488                	ld	a0,8(s1)
    48a6:	c915                	beqz	a0,48da <runtests+0x5a>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    48a8:	00090663          	beqz	s2,48b4 <runtests+0x34>
    48ac:	85ca                	mv	a1,s2
    48ae:	264000ef          	jal	4b12 <strcmp>
    48b2:	f965                	bnez	a0,48a2 <runtests+0x22>
      ntests++;
    48b4:	2985                	addiw	s3,s3,1 # 1000001 <base+0xff1349>
      if(!run(t->f, t->s)){
    48b6:	648c                	ld	a1,8(s1)
    48b8:	6088                	ld	a0,0(s1)
    48ba:	f49ff0ef          	jal	4802 <run>
    48be:	f175                	bnez	a0,48a2 <runtests+0x22>
        if(continuous != 2){
    48c0:	ff5a01e3          	beq	s4,s5,48a2 <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    48c4:	00003517          	auipc	a0,0x3
    48c8:	ba450513          	addi	a0,a0,-1116 # 7468 <malloc+0x2202>
    48cc:	0e7000ef          	jal	51b2 <printf>
          return -1;
    48d0:	59fd                	li	s3,-1
    48d2:	7902                	ld	s2,32(sp)
    48d4:	6a42                	ld	s4,16(sp)
    48d6:	6aa2                	ld	s5,8(sp)
    48d8:	a021                	j	48e0 <runtests+0x60>
    48da:	7902                	ld	s2,32(sp)
    48dc:	6a42                	ld	s4,16(sp)
    48de:	6aa2                	ld	s5,8(sp)
        }
      }
    }
  }
  return ntests;
}
    48e0:	854e                	mv	a0,s3
    48e2:	70e2                	ld	ra,56(sp)
    48e4:	7442                	ld	s0,48(sp)
    48e6:	74a2                	ld	s1,40(sp)
    48e8:	69e2                	ld	s3,24(sp)
    48ea:	6121                	addi	sp,sp,64
    48ec:	8082                	ret
  return ntests;
    48ee:	4981                	li	s3,0
    48f0:	bfc5                	j	48e0 <runtests+0x60>

00000000000048f2 <countfree>:


// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    48f2:	7179                	addi	sp,sp,-48
    48f4:	f406                	sd	ra,40(sp)
    48f6:	f022                	sd	s0,32(sp)
    48f8:	ec26                	sd	s1,24(sp)
    48fa:	e84a                	sd	s2,16(sp)
    48fc:	e44e                	sd	s3,8(sp)
    48fe:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    4900:	4501                	li	a0,0
    4902:	444000ef          	jal	4d46 <sbrk>
    4906:	89aa                	mv	s3,a0
  int n = 0;
    4908:	4481                	li	s1,0
  while(1){
    char *a = sbrk(PGSIZE);
    if(a == SBRK_ERROR){
    490a:	597d                	li	s2,-1
    490c:	a011                	j	4910 <countfree+0x1e>
      break;
    }
    n += 1;
    490e:	2485                	addiw	s1,s1,1
    char *a = sbrk(PGSIZE);
    4910:	6505                	lui	a0,0x1
    4912:	434000ef          	jal	4d46 <sbrk>
    if(a == SBRK_ERROR){
    4916:	ff251ce3          	bne	a0,s2,490e <countfree+0x1c>
  }
  sbrk(-((uint64)sbrk(0) - sz0));  
    491a:	4501                	li	a0,0
    491c:	42a000ef          	jal	4d46 <sbrk>
    4920:	40a9853b          	subw	a0,s3,a0
    4924:	422000ef          	jal	4d46 <sbrk>
  return n;
}
    4928:	8526                	mv	a0,s1
    492a:	70a2                	ld	ra,40(sp)
    492c:	7402                	ld	s0,32(sp)
    492e:	64e2                	ld	s1,24(sp)
    4930:	6942                	ld	s2,16(sp)
    4932:	69a2                	ld	s3,8(sp)
    4934:	6145                	addi	sp,sp,48
    4936:	8082                	ret

0000000000004938 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    4938:	7159                	addi	sp,sp,-112
    493a:	f486                	sd	ra,104(sp)
    493c:	f0a2                	sd	s0,96(sp)
    493e:	eca6                	sd	s1,88(sp)
    4940:	e8ca                	sd	s2,80(sp)
    4942:	e4ce                	sd	s3,72(sp)
    4944:	e0d2                	sd	s4,64(sp)
    4946:	fc56                	sd	s5,56(sp)
    4948:	f85a                	sd	s6,48(sp)
    494a:	f45e                	sd	s7,40(sp)
    494c:	f062                	sd	s8,32(sp)
    494e:	ec66                	sd	s9,24(sp)
    4950:	e86a                	sd	s10,16(sp)
    4952:	e46e                	sd	s11,8(sp)
    4954:	1880                	addi	s0,sp,112
    4956:	8aaa                	mv	s5,a0
    4958:	89ae                	mv	s3,a1
    495a:	8a32                	mv	s4,a2
  do {
    printf("usertests starting\n");
    495c:	00003c17          	auipc	s8,0x3
    4960:	b24c0c13          	addi	s8,s8,-1244 # 7480 <malloc+0x221a>
    int free0 = countfree();
    int free1 = 0;
    int ntests = 0;
    int n;
    n = runtests(quicktests, justone, continuous);
    4964:	00003b97          	auipc	s7,0x3
    4968:	6acb8b93          	addi	s7,s7,1708 # 8010 <quicktests>
    if (n < 0) {
      if(continuous != 2) {
    496c:	4b09                	li	s6,2
      ntests += n;
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      n = runtests(slowtests, justone, continuous);
    496e:	00004c97          	auipc	s9,0x4
    4972:	ab2c8c93          	addi	s9,s9,-1358 # 8420 <slowtests>
        printf("usertests slow tests starting\n");
    4976:	00003d97          	auipc	s11,0x3
    497a:	b22d8d93          	addi	s11,s11,-1246 # 7498 <malloc+0x2232>
      } else {
        ntests += n;
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    497e:	00003d17          	auipc	s10,0x3
    4982:	b3ad0d13          	addi	s10,s10,-1222 # 74b8 <malloc+0x2252>
    4986:	a025                	j	49ae <drivetests+0x76>
      if(continuous != 2) {
    4988:	09699063          	bne	s3,s6,4a08 <drivetests+0xd0>
    int ntests = 0;
    498c:	4481                	li	s1,0
    498e:	a835                	j	49ca <drivetests+0x92>
        printf("usertests slow tests starting\n");
    4990:	856e                	mv	a0,s11
    4992:	021000ef          	jal	51b2 <printf>
    4996:	a835                	j	49d2 <drivetests+0x9a>
        if(continuous != 2) {
    4998:	07699a63          	bne	s3,s6,4a0c <drivetests+0xd4>
    if((free1 = countfree()) < free0) {
    499c:	f57ff0ef          	jal	48f2 <countfree>
    49a0:	05254263          	blt	a0,s2,49e4 <drivetests+0xac>
      if(continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    49a4:	000a0363          	beqz	s4,49aa <drivetests+0x72>
    49a8:	c8a1                	beqz	s1,49f8 <drivetests+0xc0>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while(continuous);
    49aa:	06098563          	beqz	s3,4a14 <drivetests+0xdc>
    printf("usertests starting\n");
    49ae:	8562                	mv	a0,s8
    49b0:	003000ef          	jal	51b2 <printf>
    int free0 = countfree();
    49b4:	f3fff0ef          	jal	48f2 <countfree>
    49b8:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    49ba:	864e                	mv	a2,s3
    49bc:	85d2                	mv	a1,s4
    49be:	855e                	mv	a0,s7
    49c0:	ec1ff0ef          	jal	4880 <runtests>
    49c4:	84aa                	mv	s1,a0
    if (n < 0) {
    49c6:	fc0541e3          	bltz	a0,4988 <drivetests+0x50>
    if(!quick) {
    49ca:	fc0a99e3          	bnez	s5,499c <drivetests+0x64>
      if (justone == 0)
    49ce:	fc0a01e3          	beqz	s4,4990 <drivetests+0x58>
      n = runtests(slowtests, justone, continuous);
    49d2:	864e                	mv	a2,s3
    49d4:	85d2                	mv	a1,s4
    49d6:	8566                	mv	a0,s9
    49d8:	ea9ff0ef          	jal	4880 <runtests>
      if (n < 0) {
    49dc:	fa054ee3          	bltz	a0,4998 <drivetests+0x60>
        ntests += n;
    49e0:	9ca9                	addw	s1,s1,a0
    49e2:	bf6d                	j	499c <drivetests+0x64>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    49e4:	864a                	mv	a2,s2
    49e6:	85aa                	mv	a1,a0
    49e8:	856a                	mv	a0,s10
    49ea:	7c8000ef          	jal	51b2 <printf>
      if(continuous != 2) {
    49ee:	03699163          	bne	s3,s6,4a10 <drivetests+0xd8>
    if (justone != 0 && ntests == 0) {
    49f2:	fa0a1be3          	bnez	s4,49a8 <drivetests+0x70>
    49f6:	bf65                	j	49ae <drivetests+0x76>
      printf("NO TESTS EXECUTED\n");
    49f8:	00003517          	auipc	a0,0x3
    49fc:	af050513          	addi	a0,a0,-1296 # 74e8 <malloc+0x2282>
    4a00:	7b2000ef          	jal	51b2 <printf>
      return 1;
    4a04:	4505                	li	a0,1
    4a06:	a801                	j	4a16 <drivetests+0xde>
        return 1;
    4a08:	4505                	li	a0,1
    4a0a:	a031                	j	4a16 <drivetests+0xde>
          return 1;
    4a0c:	4505                	li	a0,1
    4a0e:	a021                	j	4a16 <drivetests+0xde>
        return 1;
    4a10:	4505                	li	a0,1
    4a12:	a011                	j	4a16 <drivetests+0xde>
  return 0;
    4a14:	854e                	mv	a0,s3
}
    4a16:	70a6                	ld	ra,104(sp)
    4a18:	7406                	ld	s0,96(sp)
    4a1a:	64e6                	ld	s1,88(sp)
    4a1c:	6946                	ld	s2,80(sp)
    4a1e:	69a6                	ld	s3,72(sp)
    4a20:	6a06                	ld	s4,64(sp)
    4a22:	7ae2                	ld	s5,56(sp)
    4a24:	7b42                	ld	s6,48(sp)
    4a26:	7ba2                	ld	s7,40(sp)
    4a28:	7c02                	ld	s8,32(sp)
    4a2a:	6ce2                	ld	s9,24(sp)
    4a2c:	6d42                	ld	s10,16(sp)
    4a2e:	6da2                	ld	s11,8(sp)
    4a30:	6165                	addi	sp,sp,112
    4a32:	8082                	ret

0000000000004a34 <main>:

int
main(int argc, char *argv[])
{
    4a34:	1101                	addi	sp,sp,-32
    4a36:	ec06                	sd	ra,24(sp)
    4a38:	e822                	sd	s0,16(sp)
    4a3a:	e426                	sd	s1,8(sp)
    4a3c:	e04a                	sd	s2,0(sp)
    4a3e:	1000                	addi	s0,sp,32
    4a40:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4a42:	4789                	li	a5,2
    4a44:	00f50e63          	beq	a0,a5,4a60 <main+0x2c>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4a48:	4785                	li	a5,1
    4a4a:	06a7c663          	blt	a5,a0,4ab6 <main+0x82>
  char *justone = 0;
    4a4e:	4601                	li	a2,0
  int quick = 0;
    4a50:	4501                	li	a0,0
  int continuous = 0;
    4a52:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    4a54:	ee5ff0ef          	jal	4938 <drivetests>
    4a58:	cd35                	beqz	a0,4ad4 <main+0xa0>
    exit(1);
    4a5a:	4505                	li	a0,1
    4a5c:	31e000ef          	jal	4d7a <exit>
    4a60:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4a62:	00003597          	auipc	a1,0x3
    4a66:	a9e58593          	addi	a1,a1,-1378 # 7500 <malloc+0x229a>
    4a6a:	00893503          	ld	a0,8(s2) # ffffffffffffd008 <base+0xfffffffffffee350>
    4a6e:	0a4000ef          	jal	4b12 <strcmp>
    4a72:	85aa                	mv	a1,a0
    4a74:	e501                	bnez	a0,4a7c <main+0x48>
  char *justone = 0;
    4a76:	4601                	li	a2,0
    quick = 1;
    4a78:	4505                	li	a0,1
    4a7a:	bfe9                	j	4a54 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4a7c:	00003597          	auipc	a1,0x3
    4a80:	a8c58593          	addi	a1,a1,-1396 # 7508 <malloc+0x22a2>
    4a84:	00893503          	ld	a0,8(s2)
    4a88:	08a000ef          	jal	4b12 <strcmp>
    4a8c:	cd15                	beqz	a0,4ac8 <main+0x94>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4a8e:	00003597          	auipc	a1,0x3
    4a92:	aca58593          	addi	a1,a1,-1334 # 7558 <malloc+0x22f2>
    4a96:	00893503          	ld	a0,8(s2)
    4a9a:	078000ef          	jal	4b12 <strcmp>
    4a9e:	c905                	beqz	a0,4ace <main+0x9a>
  } else if(argc == 2 && argv[1][0] != '-'){
    4aa0:	00893603          	ld	a2,8(s2)
    4aa4:	00064703          	lbu	a4,0(a2) # 1000 <pgbug+0x28>
    4aa8:	02d00793          	li	a5,45
    4aac:	00f70563          	beq	a4,a5,4ab6 <main+0x82>
  int quick = 0;
    4ab0:	4501                	li	a0,0
  int continuous = 0;
    4ab2:	4581                	li	a1,0
    4ab4:	b745                	j	4a54 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4ab6:	00003517          	auipc	a0,0x3
    4aba:	a5a50513          	addi	a0,a0,-1446 # 7510 <malloc+0x22aa>
    4abe:	6f4000ef          	jal	51b2 <printf>
    exit(1);
    4ac2:	4505                	li	a0,1
    4ac4:	2b6000ef          	jal	4d7a <exit>
  char *justone = 0;
    4ac8:	4601                	li	a2,0
    continuous = 1;
    4aca:	4585                	li	a1,1
    4acc:	b761                	j	4a54 <main+0x20>
    continuous = 2;
    4ace:	85a6                	mv	a1,s1
  char *justone = 0;
    4ad0:	4601                	li	a2,0
    4ad2:	b749                	j	4a54 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4ad4:	00003517          	auipc	a0,0x3
    4ad8:	a6c50513          	addi	a0,a0,-1428 # 7540 <malloc+0x22da>
    4adc:	6d6000ef          	jal	51b2 <printf>
  exit(0);
    4ae0:	4501                	li	a0,0
    4ae2:	298000ef          	jal	4d7a <exit>

0000000000004ae6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    4ae6:	1141                	addi	sp,sp,-16
    4ae8:	e406                	sd	ra,8(sp)
    4aea:	e022                	sd	s0,0(sp)
    4aec:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    4aee:	f47ff0ef          	jal	4a34 <main>
  exit(r);
    4af2:	288000ef          	jal	4d7a <exit>

0000000000004af6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4af6:	1141                	addi	sp,sp,-16
    4af8:	e422                	sd	s0,8(sp)
    4afa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4afc:	87aa                	mv	a5,a0
    4afe:	0585                	addi	a1,a1,1
    4b00:	0785                	addi	a5,a5,1
    4b02:	fff5c703          	lbu	a4,-1(a1)
    4b06:	fee78fa3          	sb	a4,-1(a5)
    4b0a:	fb75                	bnez	a4,4afe <strcpy+0x8>
    ;
  return os;
}
    4b0c:	6422                	ld	s0,8(sp)
    4b0e:	0141                	addi	sp,sp,16
    4b10:	8082                	ret

0000000000004b12 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4b12:	1141                	addi	sp,sp,-16
    4b14:	e422                	sd	s0,8(sp)
    4b16:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4b18:	00054783          	lbu	a5,0(a0)
    4b1c:	cb91                	beqz	a5,4b30 <strcmp+0x1e>
    4b1e:	0005c703          	lbu	a4,0(a1)
    4b22:	00f71763          	bne	a4,a5,4b30 <strcmp+0x1e>
    p++, q++;
    4b26:	0505                	addi	a0,a0,1
    4b28:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4b2a:	00054783          	lbu	a5,0(a0)
    4b2e:	fbe5                	bnez	a5,4b1e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    4b30:	0005c503          	lbu	a0,0(a1)
}
    4b34:	40a7853b          	subw	a0,a5,a0
    4b38:	6422                	ld	s0,8(sp)
    4b3a:	0141                	addi	sp,sp,16
    4b3c:	8082                	ret

0000000000004b3e <strlen>:

uint
strlen(const char *s)
{
    4b3e:	1141                	addi	sp,sp,-16
    4b40:	e422                	sd	s0,8(sp)
    4b42:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4b44:	00054783          	lbu	a5,0(a0)
    4b48:	cf91                	beqz	a5,4b64 <strlen+0x26>
    4b4a:	0505                	addi	a0,a0,1
    4b4c:	87aa                	mv	a5,a0
    4b4e:	86be                	mv	a3,a5
    4b50:	0785                	addi	a5,a5,1
    4b52:	fff7c703          	lbu	a4,-1(a5)
    4b56:	ff65                	bnez	a4,4b4e <strlen+0x10>
    4b58:	40a6853b          	subw	a0,a3,a0
    4b5c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    4b5e:	6422                	ld	s0,8(sp)
    4b60:	0141                	addi	sp,sp,16
    4b62:	8082                	ret
  for(n = 0; s[n]; n++)
    4b64:	4501                	li	a0,0
    4b66:	bfe5                	j	4b5e <strlen+0x20>

0000000000004b68 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4b68:	1141                	addi	sp,sp,-16
    4b6a:	e422                	sd	s0,8(sp)
    4b6c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4b6e:	ca19                	beqz	a2,4b84 <memset+0x1c>
    4b70:	87aa                	mv	a5,a0
    4b72:	1602                	slli	a2,a2,0x20
    4b74:	9201                	srli	a2,a2,0x20
    4b76:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4b7a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4b7e:	0785                	addi	a5,a5,1
    4b80:	fee79de3          	bne	a5,a4,4b7a <memset+0x12>
  }
  return dst;
}
    4b84:	6422                	ld	s0,8(sp)
    4b86:	0141                	addi	sp,sp,16
    4b88:	8082                	ret

0000000000004b8a <strchr>:

char*
strchr(const char *s, char c)
{
    4b8a:	1141                	addi	sp,sp,-16
    4b8c:	e422                	sd	s0,8(sp)
    4b8e:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4b90:	00054783          	lbu	a5,0(a0)
    4b94:	cb99                	beqz	a5,4baa <strchr+0x20>
    if(*s == c)
    4b96:	00f58763          	beq	a1,a5,4ba4 <strchr+0x1a>
  for(; *s; s++)
    4b9a:	0505                	addi	a0,a0,1
    4b9c:	00054783          	lbu	a5,0(a0)
    4ba0:	fbfd                	bnez	a5,4b96 <strchr+0xc>
      return (char*)s;
  return 0;
    4ba2:	4501                	li	a0,0
}
    4ba4:	6422                	ld	s0,8(sp)
    4ba6:	0141                	addi	sp,sp,16
    4ba8:	8082                	ret
  return 0;
    4baa:	4501                	li	a0,0
    4bac:	bfe5                	j	4ba4 <strchr+0x1a>

0000000000004bae <gets>:

char*
gets(char *buf, int max)
{
    4bae:	711d                	addi	sp,sp,-96
    4bb0:	ec86                	sd	ra,88(sp)
    4bb2:	e8a2                	sd	s0,80(sp)
    4bb4:	e4a6                	sd	s1,72(sp)
    4bb6:	e0ca                	sd	s2,64(sp)
    4bb8:	fc4e                	sd	s3,56(sp)
    4bba:	f852                	sd	s4,48(sp)
    4bbc:	f456                	sd	s5,40(sp)
    4bbe:	f05a                	sd	s6,32(sp)
    4bc0:	ec5e                	sd	s7,24(sp)
    4bc2:	1080                	addi	s0,sp,96
    4bc4:	8baa                	mv	s7,a0
    4bc6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4bc8:	892a                	mv	s2,a0
    4bca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    4bcc:	4aa9                	li	s5,10
    4bce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    4bd0:	89a6                	mv	s3,s1
    4bd2:	2485                	addiw	s1,s1,1
    4bd4:	0344d663          	bge	s1,s4,4c00 <gets+0x52>
    cc = read(0, &c, 1);
    4bd8:	4605                	li	a2,1
    4bda:	faf40593          	addi	a1,s0,-81
    4bde:	4501                	li	a0,0
    4be0:	1b2000ef          	jal	4d92 <read>
    if(cc < 1)
    4be4:	00a05e63          	blez	a0,4c00 <gets+0x52>
    buf[i++] = c;
    4be8:	faf44783          	lbu	a5,-81(s0)
    4bec:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4bf0:	01578763          	beq	a5,s5,4bfe <gets+0x50>
    4bf4:	0905                	addi	s2,s2,1
    4bf6:	fd679de3          	bne	a5,s6,4bd0 <gets+0x22>
    buf[i++] = c;
    4bfa:	89a6                	mv	s3,s1
    4bfc:	a011                	j	4c00 <gets+0x52>
    4bfe:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    4c00:	99de                	add	s3,s3,s7
    4c02:	00098023          	sb	zero,0(s3)
  return buf;
}
    4c06:	855e                	mv	a0,s7
    4c08:	60e6                	ld	ra,88(sp)
    4c0a:	6446                	ld	s0,80(sp)
    4c0c:	64a6                	ld	s1,72(sp)
    4c0e:	6906                	ld	s2,64(sp)
    4c10:	79e2                	ld	s3,56(sp)
    4c12:	7a42                	ld	s4,48(sp)
    4c14:	7aa2                	ld	s5,40(sp)
    4c16:	7b02                	ld	s6,32(sp)
    4c18:	6be2                	ld	s7,24(sp)
    4c1a:	6125                	addi	sp,sp,96
    4c1c:	8082                	ret

0000000000004c1e <stat>:

int
stat(const char *n, struct stat *st)
{
    4c1e:	1101                	addi	sp,sp,-32
    4c20:	ec06                	sd	ra,24(sp)
    4c22:	e822                	sd	s0,16(sp)
    4c24:	e04a                	sd	s2,0(sp)
    4c26:	1000                	addi	s0,sp,32
    4c28:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4c2a:	4581                	li	a1,0
    4c2c:	18e000ef          	jal	4dba <open>
  if(fd < 0)
    4c30:	02054263          	bltz	a0,4c54 <stat+0x36>
    4c34:	e426                	sd	s1,8(sp)
    4c36:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4c38:	85ca                	mv	a1,s2
    4c3a:	198000ef          	jal	4dd2 <fstat>
    4c3e:	892a                	mv	s2,a0
  close(fd);
    4c40:	8526                	mv	a0,s1
    4c42:	160000ef          	jal	4da2 <close>
  return r;
    4c46:	64a2                	ld	s1,8(sp)
}
    4c48:	854a                	mv	a0,s2
    4c4a:	60e2                	ld	ra,24(sp)
    4c4c:	6442                	ld	s0,16(sp)
    4c4e:	6902                	ld	s2,0(sp)
    4c50:	6105                	addi	sp,sp,32
    4c52:	8082                	ret
    return -1;
    4c54:	597d                	li	s2,-1
    4c56:	bfcd                	j	4c48 <stat+0x2a>

0000000000004c58 <atoi>:

int
atoi(const char *s)
{
    4c58:	1141                	addi	sp,sp,-16
    4c5a:	e422                	sd	s0,8(sp)
    4c5c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4c5e:	00054683          	lbu	a3,0(a0)
    4c62:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x31318>
    4c66:	0ff7f793          	zext.b	a5,a5
    4c6a:	4625                	li	a2,9
    4c6c:	02f66863          	bltu	a2,a5,4c9c <atoi+0x44>
    4c70:	872a                	mv	a4,a0
  n = 0;
    4c72:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4c74:	0705                	addi	a4,a4,1 # 1000001 <base+0xff1349>
    4c76:	0025179b          	slliw	a5,a0,0x2
    4c7a:	9fa9                	addw	a5,a5,a0
    4c7c:	0017979b          	slliw	a5,a5,0x1
    4c80:	9fb5                	addw	a5,a5,a3
    4c82:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4c86:	00074683          	lbu	a3,0(a4)
    4c8a:	fd06879b          	addiw	a5,a3,-48
    4c8e:	0ff7f793          	zext.b	a5,a5
    4c92:	fef671e3          	bgeu	a2,a5,4c74 <atoi+0x1c>
  return n;
}
    4c96:	6422                	ld	s0,8(sp)
    4c98:	0141                	addi	sp,sp,16
    4c9a:	8082                	ret
  n = 0;
    4c9c:	4501                	li	a0,0
    4c9e:	bfe5                	j	4c96 <atoi+0x3e>

0000000000004ca0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4ca0:	1141                	addi	sp,sp,-16
    4ca2:	e422                	sd	s0,8(sp)
    4ca4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4ca6:	02b57463          	bgeu	a0,a1,4cce <memmove+0x2e>
    while(n-- > 0)
    4caa:	00c05f63          	blez	a2,4cc8 <memmove+0x28>
    4cae:	1602                	slli	a2,a2,0x20
    4cb0:	9201                	srli	a2,a2,0x20
    4cb2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4cb6:	872a                	mv	a4,a0
      *dst++ = *src++;
    4cb8:	0585                	addi	a1,a1,1
    4cba:	0705                	addi	a4,a4,1
    4cbc:	fff5c683          	lbu	a3,-1(a1)
    4cc0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4cc4:	fef71ae3          	bne	a4,a5,4cb8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4cc8:	6422                	ld	s0,8(sp)
    4cca:	0141                	addi	sp,sp,16
    4ccc:	8082                	ret
    dst += n;
    4cce:	00c50733          	add	a4,a0,a2
    src += n;
    4cd2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    4cd4:	fec05ae3          	blez	a2,4cc8 <memmove+0x28>
    4cd8:	fff6079b          	addiw	a5,a2,-1
    4cdc:	1782                	slli	a5,a5,0x20
    4cde:	9381                	srli	a5,a5,0x20
    4ce0:	fff7c793          	not	a5,a5
    4ce4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4ce6:	15fd                	addi	a1,a1,-1
    4ce8:	177d                	addi	a4,a4,-1
    4cea:	0005c683          	lbu	a3,0(a1)
    4cee:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4cf2:	fee79ae3          	bne	a5,a4,4ce6 <memmove+0x46>
    4cf6:	bfc9                	j	4cc8 <memmove+0x28>

0000000000004cf8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4cf8:	1141                	addi	sp,sp,-16
    4cfa:	e422                	sd	s0,8(sp)
    4cfc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4cfe:	ca05                	beqz	a2,4d2e <memcmp+0x36>
    4d00:	fff6069b          	addiw	a3,a2,-1
    4d04:	1682                	slli	a3,a3,0x20
    4d06:	9281                	srli	a3,a3,0x20
    4d08:	0685                	addi	a3,a3,1
    4d0a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    4d0c:	00054783          	lbu	a5,0(a0)
    4d10:	0005c703          	lbu	a4,0(a1)
    4d14:	00e79863          	bne	a5,a4,4d24 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    4d18:	0505                	addi	a0,a0,1
    p2++;
    4d1a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4d1c:	fed518e3          	bne	a0,a3,4d0c <memcmp+0x14>
  }
  return 0;
    4d20:	4501                	li	a0,0
    4d22:	a019                	j	4d28 <memcmp+0x30>
      return *p1 - *p2;
    4d24:	40e7853b          	subw	a0,a5,a4
}
    4d28:	6422                	ld	s0,8(sp)
    4d2a:	0141                	addi	sp,sp,16
    4d2c:	8082                	ret
  return 0;
    4d2e:	4501                	li	a0,0
    4d30:	bfe5                	j	4d28 <memcmp+0x30>

0000000000004d32 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4d32:	1141                	addi	sp,sp,-16
    4d34:	e406                	sd	ra,8(sp)
    4d36:	e022                	sd	s0,0(sp)
    4d38:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4d3a:	f67ff0ef          	jal	4ca0 <memmove>
}
    4d3e:	60a2                	ld	ra,8(sp)
    4d40:	6402                	ld	s0,0(sp)
    4d42:	0141                	addi	sp,sp,16
    4d44:	8082                	ret

0000000000004d46 <sbrk>:

char *
sbrk(int n) {
    4d46:	1141                	addi	sp,sp,-16
    4d48:	e406                	sd	ra,8(sp)
    4d4a:	e022                	sd	s0,0(sp)
    4d4c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    4d4e:	4585                	li	a1,1
    4d50:	0b2000ef          	jal	4e02 <sys_sbrk>
}
    4d54:	60a2                	ld	ra,8(sp)
    4d56:	6402                	ld	s0,0(sp)
    4d58:	0141                	addi	sp,sp,16
    4d5a:	8082                	ret

0000000000004d5c <sbrklazy>:

char *
sbrklazy(int n) {
    4d5c:	1141                	addi	sp,sp,-16
    4d5e:	e406                	sd	ra,8(sp)
    4d60:	e022                	sd	s0,0(sp)
    4d62:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    4d64:	4589                	li	a1,2
    4d66:	09c000ef          	jal	4e02 <sys_sbrk>
}
    4d6a:	60a2                	ld	ra,8(sp)
    4d6c:	6402                	ld	s0,0(sp)
    4d6e:	0141                	addi	sp,sp,16
    4d70:	8082                	ret

0000000000004d72 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4d72:	4885                	li	a7,1
 ecall
    4d74:	00000073          	ecall
 ret
    4d78:	8082                	ret

0000000000004d7a <exit>:
.global exit
exit:
 li a7, SYS_exit
    4d7a:	4889                	li	a7,2
 ecall
    4d7c:	00000073          	ecall
 ret
    4d80:	8082                	ret

0000000000004d82 <wait>:
.global wait
wait:
 li a7, SYS_wait
    4d82:	488d                	li	a7,3
 ecall
    4d84:	00000073          	ecall
 ret
    4d88:	8082                	ret

0000000000004d8a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4d8a:	4891                	li	a7,4
 ecall
    4d8c:	00000073          	ecall
 ret
    4d90:	8082                	ret

0000000000004d92 <read>:
.global read
read:
 li a7, SYS_read
    4d92:	4895                	li	a7,5
 ecall
    4d94:	00000073          	ecall
 ret
    4d98:	8082                	ret

0000000000004d9a <write>:
.global write
write:
 li a7, SYS_write
    4d9a:	48c1                	li	a7,16
 ecall
    4d9c:	00000073          	ecall
 ret
    4da0:	8082                	ret

0000000000004da2 <close>:
.global close
close:
 li a7, SYS_close
    4da2:	48d5                	li	a7,21
 ecall
    4da4:	00000073          	ecall
 ret
    4da8:	8082                	ret

0000000000004daa <kill>:
.global kill
kill:
 li a7, SYS_kill
    4daa:	4899                	li	a7,6
 ecall
    4dac:	00000073          	ecall
 ret
    4db0:	8082                	ret

0000000000004db2 <exec>:
.global exec
exec:
 li a7, SYS_exec
    4db2:	489d                	li	a7,7
 ecall
    4db4:	00000073          	ecall
 ret
    4db8:	8082                	ret

0000000000004dba <open>:
.global open
open:
 li a7, SYS_open
    4dba:	48bd                	li	a7,15
 ecall
    4dbc:	00000073          	ecall
 ret
    4dc0:	8082                	ret

0000000000004dc2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4dc2:	48c5                	li	a7,17
 ecall
    4dc4:	00000073          	ecall
 ret
    4dc8:	8082                	ret

0000000000004dca <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4dca:	48c9                	li	a7,18
 ecall
    4dcc:	00000073          	ecall
 ret
    4dd0:	8082                	ret

0000000000004dd2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4dd2:	48a1                	li	a7,8
 ecall
    4dd4:	00000073          	ecall
 ret
    4dd8:	8082                	ret

0000000000004dda <link>:
.global link
link:
 li a7, SYS_link
    4dda:	48cd                	li	a7,19
 ecall
    4ddc:	00000073          	ecall
 ret
    4de0:	8082                	ret

0000000000004de2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4de2:	48d1                	li	a7,20
 ecall
    4de4:	00000073          	ecall
 ret
    4de8:	8082                	ret

0000000000004dea <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4dea:	48a5                	li	a7,9
 ecall
    4dec:	00000073          	ecall
 ret
    4df0:	8082                	ret

0000000000004df2 <dup>:
.global dup
dup:
 li a7, SYS_dup
    4df2:	48a9                	li	a7,10
 ecall
    4df4:	00000073          	ecall
 ret
    4df8:	8082                	ret

0000000000004dfa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4dfa:	48ad                	li	a7,11
 ecall
    4dfc:	00000073          	ecall
 ret
    4e00:	8082                	ret

0000000000004e02 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    4e02:	48b1                	li	a7,12
 ecall
    4e04:	00000073          	ecall
 ret
    4e08:	8082                	ret

0000000000004e0a <pause>:
.global pause
pause:
 li a7, SYS_pause
    4e0a:	48b5                	li	a7,13
 ecall
    4e0c:	00000073          	ecall
 ret
    4e10:	8082                	ret

0000000000004e12 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4e12:	48b9                	li	a7,14
 ecall
    4e14:	00000073          	ecall
 ret
    4e18:	8082                	ret

0000000000004e1a <kmemfree>:
.global kmemfree
kmemfree:
 li a7, SYS_kmemfree
    4e1a:	48d9                	li	a7,22
 ecall
    4e1c:	00000073          	ecall
 ret
    4e20:	8082                	ret

0000000000004e22 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
    4e22:	48dd                	li	a7,23
 ecall
    4e24:	00000073          	ecall
 ret
    4e28:	8082                	ret

0000000000004e2a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4e2a:	1101                	addi	sp,sp,-32
    4e2c:	ec06                	sd	ra,24(sp)
    4e2e:	e822                	sd	s0,16(sp)
    4e30:	1000                	addi	s0,sp,32
    4e32:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4e36:	4605                	li	a2,1
    4e38:	fef40593          	addi	a1,s0,-17
    4e3c:	f5fff0ef          	jal	4d9a <write>
}
    4e40:	60e2                	ld	ra,24(sp)
    4e42:	6442                	ld	s0,16(sp)
    4e44:	6105                	addi	sp,sp,32
    4e46:	8082                	ret

0000000000004e48 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    4e48:	715d                	addi	sp,sp,-80
    4e4a:	e486                	sd	ra,72(sp)
    4e4c:	e0a2                	sd	s0,64(sp)
    4e4e:	f84a                	sd	s2,48(sp)
    4e50:	0880                	addi	s0,sp,80
    4e52:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
    4e54:	c299                	beqz	a3,4e5a <printint+0x12>
    4e56:	0805c363          	bltz	a1,4edc <printint+0x94>
  neg = 0;
    4e5a:	4881                	li	a7,0
    4e5c:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    4e60:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
    4e62:	00003517          	auipc	a0,0x3
    4e66:	b2650513          	addi	a0,a0,-1242 # 7988 <digits>
    4e6a:	883e                	mv	a6,a5
    4e6c:	2785                	addiw	a5,a5,1
    4e6e:	02c5f733          	remu	a4,a1,a2
    4e72:	972a                	add	a4,a4,a0
    4e74:	00074703          	lbu	a4,0(a4)
    4e78:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
    4e7c:	872e                	mv	a4,a1
    4e7e:	02c5d5b3          	divu	a1,a1,a2
    4e82:	0685                	addi	a3,a3,1
    4e84:	fec773e3          	bgeu	a4,a2,4e6a <printint+0x22>
  if(neg)
    4e88:	00088b63          	beqz	a7,4e9e <printint+0x56>
    buf[i++] = '-';
    4e8c:	fd078793          	addi	a5,a5,-48
    4e90:	97a2                	add	a5,a5,s0
    4e92:	02d00713          	li	a4,45
    4e96:	fee78423          	sb	a4,-24(a5)
    4e9a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    4e9e:	02f05a63          	blez	a5,4ed2 <printint+0x8a>
    4ea2:	fc26                	sd	s1,56(sp)
    4ea4:	f44e                	sd	s3,40(sp)
    4ea6:	fb840713          	addi	a4,s0,-72
    4eaa:	00f704b3          	add	s1,a4,a5
    4eae:	fff70993          	addi	s3,a4,-1
    4eb2:	99be                	add	s3,s3,a5
    4eb4:	37fd                	addiw	a5,a5,-1
    4eb6:	1782                	slli	a5,a5,0x20
    4eb8:	9381                	srli	a5,a5,0x20
    4eba:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
    4ebe:	fff4c583          	lbu	a1,-1(s1)
    4ec2:	854a                	mv	a0,s2
    4ec4:	f67ff0ef          	jal	4e2a <putc>
  while(--i >= 0)
    4ec8:	14fd                	addi	s1,s1,-1
    4eca:	ff349ae3          	bne	s1,s3,4ebe <printint+0x76>
    4ece:	74e2                	ld	s1,56(sp)
    4ed0:	79a2                	ld	s3,40(sp)
}
    4ed2:	60a6                	ld	ra,72(sp)
    4ed4:	6406                	ld	s0,64(sp)
    4ed6:	7942                	ld	s2,48(sp)
    4ed8:	6161                	addi	sp,sp,80
    4eda:	8082                	ret
    x = -xx;
    4edc:	40b005b3          	neg	a1,a1
    neg = 1;
    4ee0:	4885                	li	a7,1
    x = -xx;
    4ee2:	bfad                	j	4e5c <printint+0x14>

0000000000004ee4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4ee4:	711d                	addi	sp,sp,-96
    4ee6:	ec86                	sd	ra,88(sp)
    4ee8:	e8a2                	sd	s0,80(sp)
    4eea:	e0ca                	sd	s2,64(sp)
    4eec:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4eee:	0005c903          	lbu	s2,0(a1)
    4ef2:	28090663          	beqz	s2,517e <vprintf+0x29a>
    4ef6:	e4a6                	sd	s1,72(sp)
    4ef8:	fc4e                	sd	s3,56(sp)
    4efa:	f852                	sd	s4,48(sp)
    4efc:	f456                	sd	s5,40(sp)
    4efe:	f05a                	sd	s6,32(sp)
    4f00:	ec5e                	sd	s7,24(sp)
    4f02:	e862                	sd	s8,16(sp)
    4f04:	e466                	sd	s9,8(sp)
    4f06:	8b2a                	mv	s6,a0
    4f08:	8a2e                	mv	s4,a1
    4f0a:	8bb2                	mv	s7,a2
  state = 0;
    4f0c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4f0e:	4481                	li	s1,0
    4f10:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4f12:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4f16:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4f1a:	06c00c93          	li	s9,108
    4f1e:	a005                	j	4f3e <vprintf+0x5a>
        putc(fd, c0);
    4f20:	85ca                	mv	a1,s2
    4f22:	855a                	mv	a0,s6
    4f24:	f07ff0ef          	jal	4e2a <putc>
    4f28:	a019                	j	4f2e <vprintf+0x4a>
    } else if(state == '%'){
    4f2a:	03598263          	beq	s3,s5,4f4e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    4f2e:	2485                	addiw	s1,s1,1
    4f30:	8726                	mv	a4,s1
    4f32:	009a07b3          	add	a5,s4,s1
    4f36:	0007c903          	lbu	s2,0(a5)
    4f3a:	22090a63          	beqz	s2,516e <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
    4f3e:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4f42:	fe0994e3          	bnez	s3,4f2a <vprintf+0x46>
      if(c0 == '%'){
    4f46:	fd579de3          	bne	a5,s5,4f20 <vprintf+0x3c>
        state = '%';
    4f4a:	89be                	mv	s3,a5
    4f4c:	b7cd                	j	4f2e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    4f4e:	00ea06b3          	add	a3,s4,a4
    4f52:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4f56:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4f58:	c681                	beqz	a3,4f60 <vprintf+0x7c>
    4f5a:	9752                	add	a4,a4,s4
    4f5c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4f60:	05878363          	beq	a5,s8,4fa6 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
    4f64:	05978d63          	beq	a5,s9,4fbe <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4f68:	07500713          	li	a4,117
    4f6c:	0ee78763          	beq	a5,a4,505a <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4f70:	07800713          	li	a4,120
    4f74:	12e78963          	beq	a5,a4,50a6 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4f78:	07000713          	li	a4,112
    4f7c:	14e78e63          	beq	a5,a4,50d8 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
    4f80:	06300713          	li	a4,99
    4f84:	18e78e63          	beq	a5,a4,5120 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
    4f88:	07300713          	li	a4,115
    4f8c:	1ae78463          	beq	a5,a4,5134 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4f90:	02500713          	li	a4,37
    4f94:	04e79563          	bne	a5,a4,4fde <vprintf+0xfa>
        putc(fd, '%');
    4f98:	02500593          	li	a1,37
    4f9c:	855a                	mv	a0,s6
    4f9e:	e8dff0ef          	jal	4e2a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    4fa2:	4981                	li	s3,0
    4fa4:	b769                	j	4f2e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    4fa6:	008b8913          	addi	s2,s7,8
    4faa:	4685                	li	a3,1
    4fac:	4629                	li	a2,10
    4fae:	000ba583          	lw	a1,0(s7)
    4fb2:	855a                	mv	a0,s6
    4fb4:	e95ff0ef          	jal	4e48 <printint>
    4fb8:	8bca                	mv	s7,s2
      state = 0;
    4fba:	4981                	li	s3,0
    4fbc:	bf8d                	j	4f2e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    4fbe:	06400793          	li	a5,100
    4fc2:	02f68963          	beq	a3,a5,4ff4 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4fc6:	06c00793          	li	a5,108
    4fca:	04f68263          	beq	a3,a5,500e <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
    4fce:	07500793          	li	a5,117
    4fd2:	0af68063          	beq	a3,a5,5072 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
    4fd6:	07800793          	li	a5,120
    4fda:	0ef68263          	beq	a3,a5,50be <vprintf+0x1da>
        putc(fd, '%');
    4fde:	02500593          	li	a1,37
    4fe2:	855a                	mv	a0,s6
    4fe4:	e47ff0ef          	jal	4e2a <putc>
        putc(fd, c0);
    4fe8:	85ca                	mv	a1,s2
    4fea:	855a                	mv	a0,s6
    4fec:	e3fff0ef          	jal	4e2a <putc>
      state = 0;
    4ff0:	4981                	li	s3,0
    4ff2:	bf35                	j	4f2e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4ff4:	008b8913          	addi	s2,s7,8
    4ff8:	4685                	li	a3,1
    4ffa:	4629                	li	a2,10
    4ffc:	000bb583          	ld	a1,0(s7)
    5000:	855a                	mv	a0,s6
    5002:	e47ff0ef          	jal	4e48 <printint>
        i += 1;
    5006:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    5008:	8bca                	mv	s7,s2
      state = 0;
    500a:	4981                	li	s3,0
        i += 1;
    500c:	b70d                	j	4f2e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    500e:	06400793          	li	a5,100
    5012:	02f60763          	beq	a2,a5,5040 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    5016:	07500793          	li	a5,117
    501a:	06f60963          	beq	a2,a5,508c <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    501e:	07800793          	li	a5,120
    5022:	faf61ee3          	bne	a2,a5,4fde <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5026:	008b8913          	addi	s2,s7,8
    502a:	4681                	li	a3,0
    502c:	4641                	li	a2,16
    502e:	000bb583          	ld	a1,0(s7)
    5032:	855a                	mv	a0,s6
    5034:	e15ff0ef          	jal	4e48 <printint>
        i += 2;
    5038:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    503a:	8bca                	mv	s7,s2
      state = 0;
    503c:	4981                	li	s3,0
        i += 2;
    503e:	bdc5                	j	4f2e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5040:	008b8913          	addi	s2,s7,8
    5044:	4685                	li	a3,1
    5046:	4629                	li	a2,10
    5048:	000bb583          	ld	a1,0(s7)
    504c:	855a                	mv	a0,s6
    504e:	dfbff0ef          	jal	4e48 <printint>
        i += 2;
    5052:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    5054:	8bca                	mv	s7,s2
      state = 0;
    5056:	4981                	li	s3,0
        i += 2;
    5058:	bdd9                	j	4f2e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
    505a:	008b8913          	addi	s2,s7,8
    505e:	4681                	li	a3,0
    5060:	4629                	li	a2,10
    5062:	000be583          	lwu	a1,0(s7)
    5066:	855a                	mv	a0,s6
    5068:	de1ff0ef          	jal	4e48 <printint>
    506c:	8bca                	mv	s7,s2
      state = 0;
    506e:	4981                	li	s3,0
    5070:	bd7d                	j	4f2e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5072:	008b8913          	addi	s2,s7,8
    5076:	4681                	li	a3,0
    5078:	4629                	li	a2,10
    507a:	000bb583          	ld	a1,0(s7)
    507e:	855a                	mv	a0,s6
    5080:	dc9ff0ef          	jal	4e48 <printint>
        i += 1;
    5084:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    5086:	8bca                	mv	s7,s2
      state = 0;
    5088:	4981                	li	s3,0
        i += 1;
    508a:	b555                	j	4f2e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    508c:	008b8913          	addi	s2,s7,8
    5090:	4681                	li	a3,0
    5092:	4629                	li	a2,10
    5094:	000bb583          	ld	a1,0(s7)
    5098:	855a                	mv	a0,s6
    509a:	dafff0ef          	jal	4e48 <printint>
        i += 2;
    509e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    50a0:	8bca                	mv	s7,s2
      state = 0;
    50a2:	4981                	li	s3,0
        i += 2;
    50a4:	b569                	j	4f2e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
    50a6:	008b8913          	addi	s2,s7,8
    50aa:	4681                	li	a3,0
    50ac:	4641                	li	a2,16
    50ae:	000be583          	lwu	a1,0(s7)
    50b2:	855a                	mv	a0,s6
    50b4:	d95ff0ef          	jal	4e48 <printint>
    50b8:	8bca                	mv	s7,s2
      state = 0;
    50ba:	4981                	li	s3,0
    50bc:	bd8d                	j	4f2e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    50be:	008b8913          	addi	s2,s7,8
    50c2:	4681                	li	a3,0
    50c4:	4641                	li	a2,16
    50c6:	000bb583          	ld	a1,0(s7)
    50ca:	855a                	mv	a0,s6
    50cc:	d7dff0ef          	jal	4e48 <printint>
        i += 1;
    50d0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    50d2:	8bca                	mv	s7,s2
      state = 0;
    50d4:	4981                	li	s3,0
        i += 1;
    50d6:	bda1                	j	4f2e <vprintf+0x4a>
    50d8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    50da:	008b8d13          	addi	s10,s7,8
    50de:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    50e2:	03000593          	li	a1,48
    50e6:	855a                	mv	a0,s6
    50e8:	d43ff0ef          	jal	4e2a <putc>
  putc(fd, 'x');
    50ec:	07800593          	li	a1,120
    50f0:	855a                	mv	a0,s6
    50f2:	d39ff0ef          	jal	4e2a <putc>
    50f6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    50f8:	00003b97          	auipc	s7,0x3
    50fc:	890b8b93          	addi	s7,s7,-1904 # 7988 <digits>
    5100:	03c9d793          	srli	a5,s3,0x3c
    5104:	97de                	add	a5,a5,s7
    5106:	0007c583          	lbu	a1,0(a5)
    510a:	855a                	mv	a0,s6
    510c:	d1fff0ef          	jal	4e2a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5110:	0992                	slli	s3,s3,0x4
    5112:	397d                	addiw	s2,s2,-1
    5114:	fe0916e3          	bnez	s2,5100 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
    5118:	8bea                	mv	s7,s10
      state = 0;
    511a:	4981                	li	s3,0
    511c:	6d02                	ld	s10,0(sp)
    511e:	bd01                	j	4f2e <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    5120:	008b8913          	addi	s2,s7,8
    5124:	000bc583          	lbu	a1,0(s7)
    5128:	855a                	mv	a0,s6
    512a:	d01ff0ef          	jal	4e2a <putc>
    512e:	8bca                	mv	s7,s2
      state = 0;
    5130:	4981                	li	s3,0
    5132:	bbf5                	j	4f2e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    5134:	008b8993          	addi	s3,s7,8
    5138:	000bb903          	ld	s2,0(s7)
    513c:	00090f63          	beqz	s2,515a <vprintf+0x276>
        for(; *s; s++)
    5140:	00094583          	lbu	a1,0(s2)
    5144:	c195                	beqz	a1,5168 <vprintf+0x284>
          putc(fd, *s);
    5146:	855a                	mv	a0,s6
    5148:	ce3ff0ef          	jal	4e2a <putc>
        for(; *s; s++)
    514c:	0905                	addi	s2,s2,1
    514e:	00094583          	lbu	a1,0(s2)
    5152:	f9f5                	bnez	a1,5146 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    5154:	8bce                	mv	s7,s3
      state = 0;
    5156:	4981                	li	s3,0
    5158:	bbd9                	j	4f2e <vprintf+0x4a>
          s = "(null)";
    515a:	00002917          	auipc	s2,0x2
    515e:	77e90913          	addi	s2,s2,1918 # 78d8 <malloc+0x2672>
        for(; *s; s++)
    5162:	02800593          	li	a1,40
    5166:	b7c5                	j	5146 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    5168:	8bce                	mv	s7,s3
      state = 0;
    516a:	4981                	li	s3,0
    516c:	b3c9                	j	4f2e <vprintf+0x4a>
    516e:	64a6                	ld	s1,72(sp)
    5170:	79e2                	ld	s3,56(sp)
    5172:	7a42                	ld	s4,48(sp)
    5174:	7aa2                	ld	s5,40(sp)
    5176:	7b02                	ld	s6,32(sp)
    5178:	6be2                	ld	s7,24(sp)
    517a:	6c42                	ld	s8,16(sp)
    517c:	6ca2                	ld	s9,8(sp)
    }
  }
}
    517e:	60e6                	ld	ra,88(sp)
    5180:	6446                	ld	s0,80(sp)
    5182:	6906                	ld	s2,64(sp)
    5184:	6125                	addi	sp,sp,96
    5186:	8082                	ret

0000000000005188 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5188:	715d                	addi	sp,sp,-80
    518a:	ec06                	sd	ra,24(sp)
    518c:	e822                	sd	s0,16(sp)
    518e:	1000                	addi	s0,sp,32
    5190:	e010                	sd	a2,0(s0)
    5192:	e414                	sd	a3,8(s0)
    5194:	e818                	sd	a4,16(s0)
    5196:	ec1c                	sd	a5,24(s0)
    5198:	03043023          	sd	a6,32(s0)
    519c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    51a0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    51a4:	8622                	mv	a2,s0
    51a6:	d3fff0ef          	jal	4ee4 <vprintf>
}
    51aa:	60e2                	ld	ra,24(sp)
    51ac:	6442                	ld	s0,16(sp)
    51ae:	6161                	addi	sp,sp,80
    51b0:	8082                	ret

00000000000051b2 <printf>:

void
printf(const char *fmt, ...)
{
    51b2:	711d                	addi	sp,sp,-96
    51b4:	ec06                	sd	ra,24(sp)
    51b6:	e822                	sd	s0,16(sp)
    51b8:	1000                	addi	s0,sp,32
    51ba:	e40c                	sd	a1,8(s0)
    51bc:	e810                	sd	a2,16(s0)
    51be:	ec14                	sd	a3,24(s0)
    51c0:	f018                	sd	a4,32(s0)
    51c2:	f41c                	sd	a5,40(s0)
    51c4:	03043823          	sd	a6,48(s0)
    51c8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    51cc:	00840613          	addi	a2,s0,8
    51d0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    51d4:	85aa                	mv	a1,a0
    51d6:	4505                	li	a0,1
    51d8:	d0dff0ef          	jal	4ee4 <vprintf>
}
    51dc:	60e2                	ld	ra,24(sp)
    51de:	6442                	ld	s0,16(sp)
    51e0:	6125                	addi	sp,sp,96
    51e2:	8082                	ret

00000000000051e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    51e4:	1141                	addi	sp,sp,-16
    51e6:	e422                	sd	s0,8(sp)
    51e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    51ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    51ee:	00003797          	auipc	a5,0x3
    51f2:	2a27b783          	ld	a5,674(a5) # 8490 <freep>
    51f6:	a02d                	j	5220 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    51f8:	4618                	lw	a4,8(a2)
    51fa:	9f2d                	addw	a4,a4,a1
    51fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5200:	6398                	ld	a4,0(a5)
    5202:	6310                	ld	a2,0(a4)
    5204:	a83d                	j	5242 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5206:	ff852703          	lw	a4,-8(a0)
    520a:	9f31                	addw	a4,a4,a2
    520c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    520e:	ff053683          	ld	a3,-16(a0)
    5212:	a091                	j	5256 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5214:	6398                	ld	a4,0(a5)
    5216:	00e7e463          	bltu	a5,a4,521e <free+0x3a>
    521a:	00e6ea63          	bltu	a3,a4,522e <free+0x4a>
{
    521e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5220:	fed7fae3          	bgeu	a5,a3,5214 <free+0x30>
    5224:	6398                	ld	a4,0(a5)
    5226:	00e6e463          	bltu	a3,a4,522e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    522a:	fee7eae3          	bltu	a5,a4,521e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    522e:	ff852583          	lw	a1,-8(a0)
    5232:	6390                	ld	a2,0(a5)
    5234:	02059813          	slli	a6,a1,0x20
    5238:	01c85713          	srli	a4,a6,0x1c
    523c:	9736                	add	a4,a4,a3
    523e:	fae60de3          	beq	a2,a4,51f8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5242:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5246:	4790                	lw	a2,8(a5)
    5248:	02061593          	slli	a1,a2,0x20
    524c:	01c5d713          	srli	a4,a1,0x1c
    5250:	973e                	add	a4,a4,a5
    5252:	fae68ae3          	beq	a3,a4,5206 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5256:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5258:	00003717          	auipc	a4,0x3
    525c:	22f73c23          	sd	a5,568(a4) # 8490 <freep>
}
    5260:	6422                	ld	s0,8(sp)
    5262:	0141                	addi	sp,sp,16
    5264:	8082                	ret

0000000000005266 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5266:	7139                	addi	sp,sp,-64
    5268:	fc06                	sd	ra,56(sp)
    526a:	f822                	sd	s0,48(sp)
    526c:	f426                	sd	s1,40(sp)
    526e:	ec4e                	sd	s3,24(sp)
    5270:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5272:	02051493          	slli	s1,a0,0x20
    5276:	9081                	srli	s1,s1,0x20
    5278:	04bd                	addi	s1,s1,15
    527a:	8091                	srli	s1,s1,0x4
    527c:	0014899b          	addiw	s3,s1,1
    5280:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5282:	00003517          	auipc	a0,0x3
    5286:	20e53503          	ld	a0,526(a0) # 8490 <freep>
    528a:	c915                	beqz	a0,52be <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    528c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    528e:	4798                	lw	a4,8(a5)
    5290:	08977a63          	bgeu	a4,s1,5324 <malloc+0xbe>
    5294:	f04a                	sd	s2,32(sp)
    5296:	e852                	sd	s4,16(sp)
    5298:	e456                	sd	s5,8(sp)
    529a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    529c:	8a4e                	mv	s4,s3
    529e:	0009871b          	sext.w	a4,s3
    52a2:	6685                	lui	a3,0x1
    52a4:	00d77363          	bgeu	a4,a3,52aa <malloc+0x44>
    52a8:	6a05                	lui	s4,0x1
    52aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    52ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    52b2:	00003917          	auipc	s2,0x3
    52b6:	1de90913          	addi	s2,s2,478 # 8490 <freep>
  if(p == SBRK_ERROR)
    52ba:	5afd                	li	s5,-1
    52bc:	a081                	j	52fc <malloc+0x96>
    52be:	f04a                	sd	s2,32(sp)
    52c0:	e852                	sd	s4,16(sp)
    52c2:	e456                	sd	s5,8(sp)
    52c4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    52c6:	0000a797          	auipc	a5,0xa
    52ca:	9f278793          	addi	a5,a5,-1550 # ecb8 <base>
    52ce:	00003717          	auipc	a4,0x3
    52d2:	1cf73123          	sd	a5,450(a4) # 8490 <freep>
    52d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    52d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    52dc:	b7c1                	j	529c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    52de:	6398                	ld	a4,0(a5)
    52e0:	e118                	sd	a4,0(a0)
    52e2:	a8a9                	j	533c <malloc+0xd6>
  hp->s.size = nu;
    52e4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    52e8:	0541                	addi	a0,a0,16
    52ea:	efbff0ef          	jal	51e4 <free>
  return freep;
    52ee:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    52f2:	c12d                	beqz	a0,5354 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    52f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    52f6:	4798                	lw	a4,8(a5)
    52f8:	02977263          	bgeu	a4,s1,531c <malloc+0xb6>
    if(p == freep)
    52fc:	00093703          	ld	a4,0(s2)
    5300:	853e                	mv	a0,a5
    5302:	fef719e3          	bne	a4,a5,52f4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    5306:	8552                	mv	a0,s4
    5308:	a3fff0ef          	jal	4d46 <sbrk>
  if(p == SBRK_ERROR)
    530c:	fd551ce3          	bne	a0,s5,52e4 <malloc+0x7e>
        return 0;
    5310:	4501                	li	a0,0
    5312:	7902                	ld	s2,32(sp)
    5314:	6a42                	ld	s4,16(sp)
    5316:	6aa2                	ld	s5,8(sp)
    5318:	6b02                	ld	s6,0(sp)
    531a:	a03d                	j	5348 <malloc+0xe2>
    531c:	7902                	ld	s2,32(sp)
    531e:	6a42                	ld	s4,16(sp)
    5320:	6aa2                	ld	s5,8(sp)
    5322:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    5324:	fae48de3          	beq	s1,a4,52de <malloc+0x78>
        p->s.size -= nunits;
    5328:	4137073b          	subw	a4,a4,s3
    532c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    532e:	02071693          	slli	a3,a4,0x20
    5332:	01c6d713          	srli	a4,a3,0x1c
    5336:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5338:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    533c:	00003717          	auipc	a4,0x3
    5340:	14a73a23          	sd	a0,340(a4) # 8490 <freep>
      return (void*)(p + 1);
    5344:	01078513          	addi	a0,a5,16
  }
}
    5348:	70e2                	ld	ra,56(sp)
    534a:	7442                	ld	s0,48(sp)
    534c:	74a2                	ld	s1,40(sp)
    534e:	69e2                	ld	s3,24(sp)
    5350:	6121                	addi	sp,sp,64
    5352:	8082                	ret
    5354:	7902                	ld	s2,32(sp)
    5356:	6a42                	ld	s4,16(sp)
    5358:	6aa2                	ld	s5,8(sp)
    535a:	6b02                	ld	s6,0(sp)
    535c:	b7f5                	j	5348 <malloc+0xe2>
