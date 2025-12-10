
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00008117          	auipc	sp,0x8
    80000004:	87010113          	addi	sp,sp,-1936 # 80007870 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddc87>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	de078793          	addi	a5,a5,-544 # 80000e60 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800000a2:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	7119                	addi	sp,sp,-128
    800000d2:	fc86                	sd	ra,120(sp)
    800000d4:	f8a2                	sd	s0,112(sp)
    800000d6:	f4a6                	sd	s1,104(sp)
    800000d8:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while(i < n){
    800000da:	06c05a63          	blez	a2,8000014e <consolewrite+0x7e>
    800000de:	f0ca                	sd	s2,96(sp)
    800000e0:	ecce                	sd	s3,88(sp)
    800000e2:	e8d2                	sd	s4,80(sp)
    800000e4:	e4d6                	sd	s5,72(sp)
    800000e6:	e0da                	sd	s6,64(sp)
    800000e8:	fc5e                	sd	s7,56(sp)
    800000ea:	f862                	sd	s8,48(sp)
    800000ec:	f466                	sd	s9,40(sp)
    800000ee:	8aaa                	mv	s5,a0
    800000f0:	8b2e                	mv	s6,a1
    800000f2:	8a32                	mv	s4,a2
  int i = 0;
    800000f4:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800000f6:	02000c13          	li	s8,32
    800000fa:	02000c93          	li	s9,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    800000fe:	5bfd                	li	s7,-1
    80000100:	a035                	j	8000012c <consolewrite+0x5c>
    if(nn > n - i)
    80000102:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000106:	86ce                	mv	a3,s3
    80000108:	01648633          	add	a2,s1,s6
    8000010c:	85d6                	mv	a1,s5
    8000010e:	f8040513          	addi	a0,s0,-128
    80000112:	190020ef          	jal	800022a2 <either_copyin>
    80000116:	03750e63          	beq	a0,s7,80000152 <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    8000011a:	85ce                	mv	a1,s3
    8000011c:	f8040513          	addi	a0,s0,-128
    80000120:	778000ef          	jal	80000898 <uartwrite>
    i += nn;
    80000124:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80000128:	0144da63          	bge	s1,s4,8000013c <consolewrite+0x6c>
    if(nn > n - i)
    8000012c:	409a093b          	subw	s2,s4,s1
    80000130:	0009079b          	sext.w	a5,s2
    80000134:	fcfc57e3          	bge	s8,a5,80000102 <consolewrite+0x32>
    80000138:	8966                	mv	s2,s9
    8000013a:	b7e1                	j	80000102 <consolewrite+0x32>
    8000013c:	7906                	ld	s2,96(sp)
    8000013e:	69e6                	ld	s3,88(sp)
    80000140:	6a46                	ld	s4,80(sp)
    80000142:	6aa6                	ld	s5,72(sp)
    80000144:	6b06                	ld	s6,64(sp)
    80000146:	7be2                	ld	s7,56(sp)
    80000148:	7c42                	ld	s8,48(sp)
    8000014a:	7ca2                	ld	s9,40(sp)
    8000014c:	a819                	j	80000162 <consolewrite+0x92>
  int i = 0;
    8000014e:	4481                	li	s1,0
    80000150:	a809                	j	80000162 <consolewrite+0x92>
    80000152:	7906                	ld	s2,96(sp)
    80000154:	69e6                	ld	s3,88(sp)
    80000156:	6a46                	ld	s4,80(sp)
    80000158:	6aa6                	ld	s5,72(sp)
    8000015a:	6b06                	ld	s6,64(sp)
    8000015c:	7be2                	ld	s7,56(sp)
    8000015e:	7c42                	ld	s8,48(sp)
    80000160:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    80000162:	8526                	mv	a0,s1
    80000164:	70e6                	ld	ra,120(sp)
    80000166:	7446                	ld	s0,112(sp)
    80000168:	74a6                	ld	s1,104(sp)
    8000016a:	6109                	addi	sp,sp,128
    8000016c:	8082                	ret

000000008000016e <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	711d                	addi	sp,sp,-96
    80000170:	ec86                	sd	ra,88(sp)
    80000172:	e8a2                	sd	s0,80(sp)
    80000174:	e4a6                	sd	s1,72(sp)
    80000176:	e0ca                	sd	s2,64(sp)
    80000178:	fc4e                	sd	s3,56(sp)
    8000017a:	f852                	sd	s4,48(sp)
    8000017c:	f456                	sd	s5,40(sp)
    8000017e:	f05a                	sd	s6,32(sp)
    80000180:	1080                	addi	s0,sp,96
    80000182:	8aaa                	mv	s5,a0
    80000184:	8a2e                	mv	s4,a1
    80000186:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000188:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018c:	0000f517          	auipc	a0,0xf
    80000190:	6e450513          	addi	a0,a0,1764 # 8000f870 <cons>
    80000194:	25f000ef          	jal	80000bf2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000198:	0000f497          	auipc	s1,0xf
    8000019c:	6d848493          	addi	s1,s1,1752 # 8000f870 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a0:	0000f917          	auipc	s2,0xf
    800001a4:	76890913          	addi	s2,s2,1896 # 8000f908 <cons+0x98>
  while(n > 0){
    800001a8:	0b305d63          	blez	s3,80000262 <consoleread+0xf4>
    while(cons.r == cons.w){
    800001ac:	0984a783          	lw	a5,152(s1)
    800001b0:	09c4a703          	lw	a4,156(s1)
    800001b4:	0af71263          	bne	a4,a5,80000258 <consoleread+0xea>
      if(killed(myproc())){
    800001b8:	73a010ef          	jal	800018f2 <myproc>
    800001bc:	779010ef          	jal	80002134 <killed>
    800001c0:	e12d                	bnez	a0,80000222 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    800001c2:	85a6                	mv	a1,s1
    800001c4:	854a                	mv	a0,s2
    800001c6:	537010ef          	jal	80001efc <sleep>
    while(cons.r == cons.w){
    800001ca:	0984a783          	lw	a5,152(s1)
    800001ce:	09c4a703          	lw	a4,156(s1)
    800001d2:	fef703e3          	beq	a4,a5,800001b8 <consoleread+0x4a>
    800001d6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001d8:	0000f717          	auipc	a4,0xf
    800001dc:	69870713          	addi	a4,a4,1688 # 8000f870 <cons>
    800001e0:	0017869b          	addiw	a3,a5,1
    800001e4:	08d72c23          	sw	a3,152(a4)
    800001e8:	07f7f693          	andi	a3,a5,127
    800001ec:	9736                	add	a4,a4,a3
    800001ee:	01874703          	lbu	a4,24(a4)
    800001f2:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001f6:	4691                	li	a3,4
    800001f8:	04db8663          	beq	s7,a3,80000244 <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001fc:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000200:	4685                	li	a3,1
    80000202:	faf40613          	addi	a2,s0,-81
    80000206:	85d2                	mv	a1,s4
    80000208:	8556                	mv	a0,s5
    8000020a:	04e020ef          	jal	80002258 <either_copyout>
    8000020e:	57fd                	li	a5,-1
    80000210:	04f50863          	beq	a0,a5,80000260 <consoleread+0xf2>
      break;

    dst++;
    80000214:	0a05                	addi	s4,s4,1
    --n;
    80000216:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80000218:	47a9                	li	a5,10
    8000021a:	04fb8d63          	beq	s7,a5,80000274 <consoleread+0x106>
    8000021e:	6be2                	ld	s7,24(sp)
    80000220:	b761                	j	800001a8 <consoleread+0x3a>
        release(&cons.lock);
    80000222:	0000f517          	auipc	a0,0xf
    80000226:	64e50513          	addi	a0,a0,1614 # 8000f870 <cons>
    8000022a:	261000ef          	jal	80000c8a <release>
        return -1;
    8000022e:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000230:	60e6                	ld	ra,88(sp)
    80000232:	6446                	ld	s0,80(sp)
    80000234:	64a6                	ld	s1,72(sp)
    80000236:	6906                	ld	s2,64(sp)
    80000238:	79e2                	ld	s3,56(sp)
    8000023a:	7a42                	ld	s4,48(sp)
    8000023c:	7aa2                	ld	s5,40(sp)
    8000023e:	7b02                	ld	s6,32(sp)
    80000240:	6125                	addi	sp,sp,96
    80000242:	8082                	ret
      if(n < target){
    80000244:	0009871b          	sext.w	a4,s3
    80000248:	01677a63          	bgeu	a4,s6,8000025c <consoleread+0xee>
        cons.r--;
    8000024c:	0000f717          	auipc	a4,0xf
    80000250:	6af72e23          	sw	a5,1724(a4) # 8000f908 <cons+0x98>
    80000254:	6be2                	ld	s7,24(sp)
    80000256:	a031                	j	80000262 <consoleread+0xf4>
    80000258:	ec5e                	sd	s7,24(sp)
    8000025a:	bfbd                	j	800001d8 <consoleread+0x6a>
    8000025c:	6be2                	ld	s7,24(sp)
    8000025e:	a011                	j	80000262 <consoleread+0xf4>
    80000260:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000262:	0000f517          	auipc	a0,0xf
    80000266:	60e50513          	addi	a0,a0,1550 # 8000f870 <cons>
    8000026a:	221000ef          	jal	80000c8a <release>
  return target - n;
    8000026e:	413b053b          	subw	a0,s6,s3
    80000272:	bf7d                	j	80000230 <consoleread+0xc2>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	b7f5                	j	80000262 <consoleread+0xf4>

0000000080000278 <consputc>:
{
    80000278:	1141                	addi	sp,sp,-16
    8000027a:	e406                	sd	ra,8(sp)
    8000027c:	e022                	sd	s0,0(sp)
    8000027e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000280:	10000793          	li	a5,256
    80000284:	00f50863          	beq	a0,a5,80000294 <consputc+0x1c>
    uartputc_sync(c);
    80000288:	6a4000ef          	jal	8000092c <uartputc_sync>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	addi	sp,sp,16
    80000292:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000294:	4521                	li	a0,8
    80000296:	696000ef          	jal	8000092c <uartputc_sync>
    8000029a:	02000513          	li	a0,32
    8000029e:	68e000ef          	jal	8000092c <uartputc_sync>
    800002a2:	4521                	li	a0,8
    800002a4:	688000ef          	jal	8000092c <uartputc_sync>
    800002a8:	b7d5                	j	8000028c <consputc+0x14>

00000000800002aa <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002aa:	1101                	addi	sp,sp,-32
    800002ac:	ec06                	sd	ra,24(sp)
    800002ae:	e822                	sd	s0,16(sp)
    800002b0:	e426                	sd	s1,8(sp)
    800002b2:	1000                	addi	s0,sp,32
    800002b4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b6:	0000f517          	auipc	a0,0xf
    800002ba:	5ba50513          	addi	a0,a0,1466 # 8000f870 <cons>
    800002be:	135000ef          	jal	80000bf2 <acquire>

  switch(c){
    800002c2:	47d5                	li	a5,21
    800002c4:	08f48f63          	beq	s1,a5,80000362 <consoleintr+0xb8>
    800002c8:	0297c563          	blt	a5,s1,800002f2 <consoleintr+0x48>
    800002cc:	47a1                	li	a5,8
    800002ce:	0ef48463          	beq	s1,a5,800003b6 <consoleintr+0x10c>
    800002d2:	47c1                	li	a5,16
    800002d4:	10f49563          	bne	s1,a5,800003de <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800002d8:	014020ef          	jal	800022ec <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002dc:	0000f517          	auipc	a0,0xf
    800002e0:	59450513          	addi	a0,a0,1428 # 8000f870 <cons>
    800002e4:	1a7000ef          	jal	80000c8a <release>
}
    800002e8:	60e2                	ld	ra,24(sp)
    800002ea:	6442                	ld	s0,16(sp)
    800002ec:	64a2                	ld	s1,8(sp)
    800002ee:	6105                	addi	sp,sp,32
    800002f0:	8082                	ret
  switch(c){
    800002f2:	07f00793          	li	a5,127
    800002f6:	0cf48063          	beq	s1,a5,800003b6 <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002fa:	0000f717          	auipc	a4,0xf
    800002fe:	57670713          	addi	a4,a4,1398 # 8000f870 <cons>
    80000302:	0a072783          	lw	a5,160(a4)
    80000306:	09872703          	lw	a4,152(a4)
    8000030a:	9f99                	subw	a5,a5,a4
    8000030c:	07f00713          	li	a4,127
    80000310:	fcf766e3          	bltu	a4,a5,800002dc <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000314:	47b5                	li	a5,13
    80000316:	0cf48763          	beq	s1,a5,800003e4 <consoleintr+0x13a>
      consputc(c);
    8000031a:	8526                	mv	a0,s1
    8000031c:	f5dff0ef          	jal	80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000320:	0000f797          	auipc	a5,0xf
    80000324:	55078793          	addi	a5,a5,1360 # 8000f870 <cons>
    80000328:	0a07a683          	lw	a3,160(a5)
    8000032c:	0016871b          	addiw	a4,a3,1
    80000330:	0007061b          	sext.w	a2,a4
    80000334:	0ae7a023          	sw	a4,160(a5)
    80000338:	07f6f693          	andi	a3,a3,127
    8000033c:	97b6                	add	a5,a5,a3
    8000033e:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000342:	47a9                	li	a5,10
    80000344:	0cf48563          	beq	s1,a5,8000040e <consoleintr+0x164>
    80000348:	4791                	li	a5,4
    8000034a:	0cf48263          	beq	s1,a5,8000040e <consoleintr+0x164>
    8000034e:	0000f797          	auipc	a5,0xf
    80000352:	5ba7a783          	lw	a5,1466(a5) # 8000f908 <cons+0x98>
    80000356:	9f1d                	subw	a4,a4,a5
    80000358:	08000793          	li	a5,128
    8000035c:	f8f710e3          	bne	a4,a5,800002dc <consoleintr+0x32>
    80000360:	a07d                	j	8000040e <consoleintr+0x164>
    80000362:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000364:	0000f717          	auipc	a4,0xf
    80000368:	50c70713          	addi	a4,a4,1292 # 8000f870 <cons>
    8000036c:	0a072783          	lw	a5,160(a4)
    80000370:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000374:	0000f497          	auipc	s1,0xf
    80000378:	4fc48493          	addi	s1,s1,1276 # 8000f870 <cons>
    while(cons.e != cons.w &&
    8000037c:	4929                	li	s2,10
    8000037e:	02f70863          	beq	a4,a5,800003ae <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000382:	37fd                	addiw	a5,a5,-1
    80000384:	07f7f713          	andi	a4,a5,127
    80000388:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000038a:	01874703          	lbu	a4,24(a4)
    8000038e:	03270263          	beq	a4,s2,800003b2 <consoleintr+0x108>
      cons.e--;
    80000392:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000396:	10000513          	li	a0,256
    8000039a:	edfff0ef          	jal	80000278 <consputc>
    while(cons.e != cons.w &&
    8000039e:	0a04a783          	lw	a5,160(s1)
    800003a2:	09c4a703          	lw	a4,156(s1)
    800003a6:	fcf71ee3          	bne	a4,a5,80000382 <consoleintr+0xd8>
    800003aa:	6902                	ld	s2,0(sp)
    800003ac:	bf05                	j	800002dc <consoleintr+0x32>
    800003ae:	6902                	ld	s2,0(sp)
    800003b0:	b735                	j	800002dc <consoleintr+0x32>
    800003b2:	6902                	ld	s2,0(sp)
    800003b4:	b725                	j	800002dc <consoleintr+0x32>
    if(cons.e != cons.w){
    800003b6:	0000f717          	auipc	a4,0xf
    800003ba:	4ba70713          	addi	a4,a4,1210 # 8000f870 <cons>
    800003be:	0a072783          	lw	a5,160(a4)
    800003c2:	09c72703          	lw	a4,156(a4)
    800003c6:	f0f70be3          	beq	a4,a5,800002dc <consoleintr+0x32>
      cons.e--;
    800003ca:	37fd                	addiw	a5,a5,-1
    800003cc:	0000f717          	auipc	a4,0xf
    800003d0:	54f72223          	sw	a5,1348(a4) # 8000f910 <cons+0xa0>
      consputc(BACKSPACE);
    800003d4:	10000513          	li	a0,256
    800003d8:	ea1ff0ef          	jal	80000278 <consputc>
    800003dc:	b701                	j	800002dc <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003de:	ee048fe3          	beqz	s1,800002dc <consoleintr+0x32>
    800003e2:	bf21                	j	800002fa <consoleintr+0x50>
      consputc(c);
    800003e4:	4529                	li	a0,10
    800003e6:	e93ff0ef          	jal	80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003ea:	0000f797          	auipc	a5,0xf
    800003ee:	48678793          	addi	a5,a5,1158 # 8000f870 <cons>
    800003f2:	0a07a703          	lw	a4,160(a5)
    800003f6:	0017069b          	addiw	a3,a4,1
    800003fa:	0006861b          	sext.w	a2,a3
    800003fe:	0ad7a023          	sw	a3,160(a5)
    80000402:	07f77713          	andi	a4,a4,127
    80000406:	97ba                	add	a5,a5,a4
    80000408:	4729                	li	a4,10
    8000040a:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000040e:	0000f797          	auipc	a5,0xf
    80000412:	4ec7af23          	sw	a2,1278(a5) # 8000f90c <cons+0x9c>
        wakeup(&cons.r);
    80000416:	0000f517          	auipc	a0,0xf
    8000041a:	4f250513          	addi	a0,a0,1266 # 8000f908 <cons+0x98>
    8000041e:	32b010ef          	jal	80001f48 <wakeup>
    80000422:	bd6d                	j	800002dc <consoleintr+0x32>

0000000080000424 <consoleinit>:

void
consoleinit(void)
{
    80000424:	1141                	addi	sp,sp,-16
    80000426:	e406                	sd	ra,8(sp)
    80000428:	e022                	sd	s0,0(sp)
    8000042a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000042c:	00007597          	auipc	a1,0x7
    80000430:	bd458593          	addi	a1,a1,-1068 # 80007000 <etext>
    80000434:	0000f517          	auipc	a0,0xf
    80000438:	43c50513          	addi	a0,a0,1084 # 8000f870 <cons>
    8000043c:	736000ef          	jal	80000b72 <initlock>

  uartinit();
    80000440:	400000ef          	jal	80000840 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000444:	0001f797          	auipc	a5,0x1f
    80000448:	59c78793          	addi	a5,a5,1436 # 8001f9e0 <devsw>
    8000044c:	00000717          	auipc	a4,0x0
    80000450:	d2270713          	addi	a4,a4,-734 # 8000016e <consoleread>
    80000454:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000456:	00000717          	auipc	a4,0x0
    8000045a:	c7a70713          	addi	a4,a4,-902 # 800000d0 <consolewrite>
    8000045e:	ef98                	sd	a4,24(a5)
}
    80000460:	60a2                	ld	ra,8(sp)
    80000462:	6402                	ld	s0,0(sp)
    80000464:	0141                	addi	sp,sp,16
    80000466:	8082                	ret

0000000080000468 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000468:	7139                	addi	sp,sp,-64
    8000046a:	fc06                	sd	ra,56(sp)
    8000046c:	f822                	sd	s0,48(sp)
    8000046e:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000470:	c219                	beqz	a2,80000476 <printint+0xe>
    80000472:	08054063          	bltz	a0,800004f2 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80000476:	4881                	li	a7,0
    80000478:	fc840693          	addi	a3,s0,-56

  i = 0;
    8000047c:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    8000047e:	00007617          	auipc	a2,0x7
    80000482:	29260613          	addi	a2,a2,658 # 80007710 <digits>
    80000486:	883e                	mv	a6,a5
    80000488:	2785                	addiw	a5,a5,1
    8000048a:	02b57733          	remu	a4,a0,a1
    8000048e:	9732                	add	a4,a4,a2
    80000490:	00074703          	lbu	a4,0(a4)
    80000494:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000498:	872a                	mv	a4,a0
    8000049a:	02b55533          	divu	a0,a0,a1
    8000049e:	0685                	addi	a3,a3,1
    800004a0:	feb773e3          	bgeu	a4,a1,80000486 <printint+0x1e>

  if(sign)
    800004a4:	00088a63          	beqz	a7,800004b8 <printint+0x50>
    buf[i++] = '-';
    800004a8:	1781                	addi	a5,a5,-32
    800004aa:	97a2                	add	a5,a5,s0
    800004ac:	02d00713          	li	a4,45
    800004b0:	fee78423          	sb	a4,-24(a5)
    800004b4:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800004b8:	02f05963          	blez	a5,800004ea <printint+0x82>
    800004bc:	f426                	sd	s1,40(sp)
    800004be:	f04a                	sd	s2,32(sp)
    800004c0:	fc840713          	addi	a4,s0,-56
    800004c4:	00f704b3          	add	s1,a4,a5
    800004c8:	fff70913          	addi	s2,a4,-1
    800004cc:	993e                	add	s2,s2,a5
    800004ce:	37fd                	addiw	a5,a5,-1
    800004d0:	1782                	slli	a5,a5,0x20
    800004d2:	9381                	srli	a5,a5,0x20
    800004d4:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004d8:	fff4c503          	lbu	a0,-1(s1)
    800004dc:	d9dff0ef          	jal	80000278 <consputc>
  while(--i >= 0)
    800004e0:	14fd                	addi	s1,s1,-1
    800004e2:	ff249be3          	bne	s1,s2,800004d8 <printint+0x70>
    800004e6:	74a2                	ld	s1,40(sp)
    800004e8:	7902                	ld	s2,32(sp)
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	6121                	addi	sp,sp,64
    800004f0:	8082                	ret
    x = -xx;
    800004f2:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004f6:	4885                	li	a7,1
    x = -xx;
    800004f8:	b741                	j	80000478 <printint+0x10>

00000000800004fa <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004fa:	7131                	addi	sp,sp,-192
    800004fc:	fc86                	sd	ra,120(sp)
    800004fe:	f8a2                	sd	s0,112(sp)
    80000500:	e8d2                	sd	s4,80(sp)
    80000502:	0100                	addi	s0,sp,128
    80000504:	8a2a                	mv	s4,a0
    80000506:	e40c                	sd	a1,8(s0)
    80000508:	e810                	sd	a2,16(s0)
    8000050a:	ec14                	sd	a3,24(s0)
    8000050c:	f018                	sd	a4,32(s0)
    8000050e:	f41c                	sd	a5,40(s0)
    80000510:	03043823          	sd	a6,48(s0)
    80000514:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80000518:	00007797          	auipc	a5,0x7
    8000051c:	32c7a783          	lw	a5,812(a5) # 80007844 <panicking>
    80000520:	c3a1                	beqz	a5,80000560 <printf+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	000a4503          	lbu	a0,0(s4)
    8000052e:	28050763          	beqz	a0,800007bc <printf+0x2c2>
    80000532:	f4a6                	sd	s1,104(sp)
    80000534:	f0ca                	sd	s2,96(sp)
    80000536:	ecce                	sd	s3,88(sp)
    80000538:	e4d6                	sd	s5,72(sp)
    8000053a:	e0da                	sd	s6,64(sp)
    8000053c:	f862                	sd	s8,48(sp)
    8000053e:	f466                	sd	s9,40(sp)
    80000540:	f06a                	sd	s10,32(sp)
    80000542:	ec6e                	sd	s11,24(sp)
    80000544:	4981                	li	s3,0
    if(cx != '%'){
    80000546:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000054a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000054e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000552:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000556:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000055a:	07000d93          	li	s11,112
    8000055e:	a01d                	j	80000584 <printf+0x8a>
    acquire(&pr.lock);
    80000560:	0000f517          	auipc	a0,0xf
    80000564:	3b850513          	addi	a0,a0,952 # 8000f918 <pr>
    80000568:	68a000ef          	jal	80000bf2 <acquire>
    8000056c:	bf5d                	j	80000522 <printf+0x28>
      consputc(cx);
    8000056e:	d0bff0ef          	jal	80000278 <consputc>
      continue;
    80000572:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000574:	0014899b          	addiw	s3,s1,1
    80000578:	013a07b3          	add	a5,s4,s3
    8000057c:	0007c503          	lbu	a0,0(a5)
    80000580:	20050b63          	beqz	a0,80000796 <printf+0x29c>
    if(cx != '%'){
    80000584:	ff5515e3          	bne	a0,s5,8000056e <printf+0x74>
    i++;
    80000588:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    8000058c:	009a07b3          	add	a5,s4,s1
    80000590:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000594:	20090b63          	beqz	s2,800007aa <printf+0x2b0>
    80000598:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    8000059c:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    8000059e:	c789                	beqz	a5,800005a8 <printf+0xae>
    800005a0:	009a0733          	add	a4,s4,s1
    800005a4:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800005a8:	03690963          	beq	s2,s6,800005da <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    800005ac:	05890363          	beq	s2,s8,800005f2 <printf+0xf8>
    } else if(c0 == 'u'){
    800005b0:	0d990663          	beq	s2,s9,8000067c <printf+0x182>
    } else if(c0 == 'x'){
    800005b4:	11a90d63          	beq	s2,s10,800006ce <printf+0x1d4>
    } else if(c0 == 'p'){
    800005b8:	15b90663          	beq	s2,s11,80000704 <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    800005bc:	06300793          	li	a5,99
    800005c0:	18f90563          	beq	s2,a5,8000074a <printf+0x250>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    800005c4:	07300793          	li	a5,115
    800005c8:	18f90b63          	beq	s2,a5,8000075e <printf+0x264>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005cc:	03591b63          	bne	s2,s5,80000602 <printf+0x108>
      consputc('%');
    800005d0:	02500513          	li	a0,37
    800005d4:	ca5ff0ef          	jal	80000278 <consputc>
    800005d8:	bf71                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, int), 10, 1);
    800005da:	f8843783          	ld	a5,-120(s0)
    800005de:	00878713          	addi	a4,a5,8
    800005e2:	f8e43423          	sd	a4,-120(s0)
    800005e6:	4605                	li	a2,1
    800005e8:	45a9                	li	a1,10
    800005ea:	4388                	lw	a0,0(a5)
    800005ec:	e7dff0ef          	jal	80000468 <printint>
    800005f0:	b751                	j	80000574 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'd'){
    800005f2:	01678f63          	beq	a5,s6,80000610 <printf+0x116>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005f6:	03878b63          	beq	a5,s8,8000062c <printf+0x132>
    } else if(c0 == 'l' && c1 == 'u'){
    800005fa:	09978e63          	beq	a5,s9,80000696 <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'x'){
    800005fe:	0fa78563          	beq	a5,s10,800006e8 <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80000602:	8556                	mv	a0,s5
    80000604:	c75ff0ef          	jal	80000278 <consputc>
      consputc(c0);
    80000608:	854a                	mv	a0,s2
    8000060a:	c6fff0ef          	jal	80000278 <consputc>
    8000060e:	b79d                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80000610:	f8843783          	ld	a5,-120(s0)
    80000614:	00878713          	addi	a4,a5,8
    80000618:	f8e43423          	sd	a4,-120(s0)
    8000061c:	4605                	li	a2,1
    8000061e:	45a9                	li	a1,10
    80000620:	6388                	ld	a0,0(a5)
    80000622:	e47ff0ef          	jal	80000468 <printint>
      i += 1;
    80000626:	0029849b          	addiw	s1,s3,2
    8000062a:	b7a9                	j	80000574 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000062c:	06400793          	li	a5,100
    80000630:	02f68863          	beq	a3,a5,80000660 <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000634:	07500793          	li	a5,117
    80000638:	06f68d63          	beq	a3,a5,800006b2 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000063c:	07800793          	li	a5,120
    80000640:	fcf691e3          	bne	a3,a5,80000602 <printf+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4601                	li	a2,0
    80000652:	45c1                	li	a1,16
    80000654:	6388                	ld	a0,0(a5)
    80000656:	e13ff0ef          	jal	80000468 <printint>
      i += 2;
    8000065a:	0039849b          	addiw	s1,s3,3
    8000065e:	bf19                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80000660:	f8843783          	ld	a5,-120(s0)
    80000664:	00878713          	addi	a4,a5,8
    80000668:	f8e43423          	sd	a4,-120(s0)
    8000066c:	4605                	li	a2,1
    8000066e:	45a9                	li	a1,10
    80000670:	6388                	ld	a0,0(a5)
    80000672:	df7ff0ef          	jal	80000468 <printint>
      i += 2;
    80000676:	0039849b          	addiw	s1,s3,3
    8000067a:	bded                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    8000067c:	f8843783          	ld	a5,-120(s0)
    80000680:	00878713          	addi	a4,a5,8
    80000684:	f8e43423          	sd	a4,-120(s0)
    80000688:	4601                	li	a2,0
    8000068a:	45a9                	li	a1,10
    8000068c:	0007e503          	lwu	a0,0(a5)
    80000690:	dd9ff0ef          	jal	80000468 <printint>
    80000694:	b5c5                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80000696:	f8843783          	ld	a5,-120(s0)
    8000069a:	00878713          	addi	a4,a5,8
    8000069e:	f8e43423          	sd	a4,-120(s0)
    800006a2:	4601                	li	a2,0
    800006a4:	45a9                	li	a1,10
    800006a6:	6388                	ld	a0,0(a5)
    800006a8:	dc1ff0ef          	jal	80000468 <printint>
      i += 1;
    800006ac:	0029849b          	addiw	s1,s3,2
    800006b0:	b5d1                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	4601                	li	a2,0
    800006c0:	45a9                	li	a1,10
    800006c2:	6388                	ld	a0,0(a5)
    800006c4:	da5ff0ef          	jal	80000468 <printint>
      i += 2;
    800006c8:	0039849b          	addiw	s1,s3,3
    800006cc:	b565                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    800006ce:	f8843783          	ld	a5,-120(s0)
    800006d2:	00878713          	addi	a4,a5,8
    800006d6:	f8e43423          	sd	a4,-120(s0)
    800006da:	4601                	li	a2,0
    800006dc:	45c1                	li	a1,16
    800006de:	0007e503          	lwu	a0,0(a5)
    800006e2:	d87ff0ef          	jal	80000468 <printint>
    800006e6:	b579                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    800006e8:	f8843783          	ld	a5,-120(s0)
    800006ec:	00878713          	addi	a4,a5,8
    800006f0:	f8e43423          	sd	a4,-120(s0)
    800006f4:	4601                	li	a2,0
    800006f6:	45c1                	li	a1,16
    800006f8:	6388                	ld	a0,0(a5)
    800006fa:	d6fff0ef          	jal	80000468 <printint>
      i += 1;
    800006fe:	0029849b          	addiw	s1,s3,2
    80000702:	bd8d                	j	80000574 <printf+0x7a>
    80000704:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80000706:	f8843783          	ld	a5,-120(s0)
    8000070a:	00878713          	addi	a4,a5,8
    8000070e:	f8e43423          	sd	a4,-120(s0)
    80000712:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80000716:	03000513          	li	a0,48
    8000071a:	b5fff0ef          	jal	80000278 <consputc>
  consputc('x');
    8000071e:	07800513          	li	a0,120
    80000722:	b57ff0ef          	jal	80000278 <consputc>
    80000726:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000728:	00007b97          	auipc	s7,0x7
    8000072c:	fe8b8b93          	addi	s7,s7,-24 # 80007710 <digits>
    80000730:	03c9d793          	srli	a5,s3,0x3c
    80000734:	97de                	add	a5,a5,s7
    80000736:	0007c503          	lbu	a0,0(a5)
    8000073a:	b3fff0ef          	jal	80000278 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000073e:	0992                	slli	s3,s3,0x4
    80000740:	397d                	addiw	s2,s2,-1
    80000742:	fe0917e3          	bnez	s2,80000730 <printf+0x236>
    80000746:	7be2                	ld	s7,56(sp)
    80000748:	b535                	j	80000574 <printf+0x7a>
      consputc(va_arg(ap, uint));
    8000074a:	f8843783          	ld	a5,-120(s0)
    8000074e:	00878713          	addi	a4,a5,8
    80000752:	f8e43423          	sd	a4,-120(s0)
    80000756:	4388                	lw	a0,0(a5)
    80000758:	b21ff0ef          	jal	80000278 <consputc>
    8000075c:	bd21                	j	80000574 <printf+0x7a>
      if((s = va_arg(ap, char*)) == 0)
    8000075e:	f8843783          	ld	a5,-120(s0)
    80000762:	00878713          	addi	a4,a5,8
    80000766:	f8e43423          	sd	a4,-120(s0)
    8000076a:	0007b903          	ld	s2,0(a5)
    8000076e:	00090d63          	beqz	s2,80000788 <printf+0x28e>
      for(; *s; s++)
    80000772:	00094503          	lbu	a0,0(s2)
    80000776:	de050fe3          	beqz	a0,80000574 <printf+0x7a>
        consputc(*s);
    8000077a:	affff0ef          	jal	80000278 <consputc>
      for(; *s; s++)
    8000077e:	0905                	addi	s2,s2,1
    80000780:	00094503          	lbu	a0,0(s2)
    80000784:	f97d                	bnez	a0,8000077a <printf+0x280>
    80000786:	b3fd                	j	80000574 <printf+0x7a>
        s = "(null)";
    80000788:	00007917          	auipc	s2,0x7
    8000078c:	88090913          	addi	s2,s2,-1920 # 80007008 <etext+0x8>
      for(; *s; s++)
    80000790:	02800513          	li	a0,40
    80000794:	b7dd                	j	8000077a <printf+0x280>
    80000796:	74a6                	ld	s1,104(sp)
    80000798:	7906                	ld	s2,96(sp)
    8000079a:	69e6                	ld	s3,88(sp)
    8000079c:	6aa6                	ld	s5,72(sp)
    8000079e:	6b06                	ld	s6,64(sp)
    800007a0:	7c42                	ld	s8,48(sp)
    800007a2:	7ca2                	ld	s9,40(sp)
    800007a4:	7d02                	ld	s10,32(sp)
    800007a6:	6de2                	ld	s11,24(sp)
    800007a8:	a811                	j	800007bc <printf+0x2c2>
    800007aa:	74a6                	ld	s1,104(sp)
    800007ac:	7906                	ld	s2,96(sp)
    800007ae:	69e6                	ld	s3,88(sp)
    800007b0:	6aa6                	ld	s5,72(sp)
    800007b2:	6b06                	ld	s6,64(sp)
    800007b4:	7c42                	ld	s8,48(sp)
    800007b6:	7ca2                	ld	s9,40(sp)
    800007b8:	7d02                	ld	s10,32(sp)
    800007ba:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    800007bc:	00007797          	auipc	a5,0x7
    800007c0:	0887a783          	lw	a5,136(a5) # 80007844 <panicking>
    800007c4:	c799                	beqz	a5,800007d2 <printf+0x2d8>
    release(&pr.lock);

  return 0;
}
    800007c6:	4501                	li	a0,0
    800007c8:	70e6                	ld	ra,120(sp)
    800007ca:	7446                	ld	s0,112(sp)
    800007cc:	6a46                	ld	s4,80(sp)
    800007ce:	6129                	addi	sp,sp,192
    800007d0:	8082                	ret
    release(&pr.lock);
    800007d2:	0000f517          	auipc	a0,0xf
    800007d6:	14650513          	addi	a0,a0,326 # 8000f918 <pr>
    800007da:	4b0000ef          	jal	80000c8a <release>
  return 0;
    800007de:	b7e5                	j	800007c6 <printf+0x2cc>

00000000800007e0 <panic>:

void
panic(char *s)
{
    800007e0:	1101                	addi	sp,sp,-32
    800007e2:	ec06                	sd	ra,24(sp)
    800007e4:	e822                	sd	s0,16(sp)
    800007e6:	e426                	sd	s1,8(sp)
    800007e8:	e04a                	sd	s2,0(sp)
    800007ea:	1000                	addi	s0,sp,32
    800007ec:	84aa                	mv	s1,a0
  panicking = 1;
    800007ee:	4905                	li	s2,1
    800007f0:	00007797          	auipc	a5,0x7
    800007f4:	0527aa23          	sw	s2,84(a5) # 80007844 <panicking>
  printf("panic: ");
    800007f8:	00007517          	auipc	a0,0x7
    800007fc:	82050513          	addi	a0,a0,-2016 # 80007018 <etext+0x18>
    80000800:	cfbff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000804:	85a6                	mv	a1,s1
    80000806:	00007517          	auipc	a0,0x7
    8000080a:	81a50513          	addi	a0,a0,-2022 # 80007020 <etext+0x20>
    8000080e:	cedff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000812:	00007797          	auipc	a5,0x7
    80000816:	0327a723          	sw	s2,46(a5) # 80007840 <panicked>
  for(;;)
    8000081a:	a001                	j	8000081a <panic+0x3a>

000000008000081c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000081c:	1141                	addi	sp,sp,-16
    8000081e:	e406                	sd	ra,8(sp)
    80000820:	e022                	sd	s0,0(sp)
    80000822:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000824:	00007597          	auipc	a1,0x7
    80000828:	80458593          	addi	a1,a1,-2044 # 80007028 <etext+0x28>
    8000082c:	0000f517          	auipc	a0,0xf
    80000830:	0ec50513          	addi	a0,a0,236 # 8000f918 <pr>
    80000834:	33e000ef          	jal	80000b72 <initlock>
}
    80000838:	60a2                	ld	ra,8(sp)
    8000083a:	6402                	ld	s0,0(sp)
    8000083c:	0141                	addi	sp,sp,16
    8000083e:	8082                	ret

0000000080000840 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80000840:	1141                	addi	sp,sp,-16
    80000842:	e406                	sd	ra,8(sp)
    80000844:	e022                	sd	s0,0(sp)
    80000846:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000848:	100007b7          	lui	a5,0x10000
    8000084c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000850:	10000737          	lui	a4,0x10000
    80000854:	f8000693          	li	a3,-128
    80000858:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000085c:	468d                	li	a3,3
    8000085e:	10000637          	lui	a2,0x10000
    80000862:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000866:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000086a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000086e:	10000737          	lui	a4,0x10000
    80000872:	461d                	li	a2,7
    80000874:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000878:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    8000087c:	00006597          	auipc	a1,0x6
    80000880:	7b458593          	addi	a1,a1,1972 # 80007030 <etext+0x30>
    80000884:	0000f517          	auipc	a0,0xf
    80000888:	0ac50513          	addi	a0,a0,172 # 8000f930 <tx_lock>
    8000088c:	2e6000ef          	jal	80000b72 <initlock>
}
    80000890:	60a2                	ld	ra,8(sp)
    80000892:	6402                	ld	s0,0(sp)
    80000894:	0141                	addi	sp,sp,16
    80000896:	8082                	ret

0000000080000898 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80000898:	715d                	addi	sp,sp,-80
    8000089a:	e486                	sd	ra,72(sp)
    8000089c:	e0a2                	sd	s0,64(sp)
    8000089e:	fc26                	sd	s1,56(sp)
    800008a0:	ec56                	sd	s5,24(sp)
    800008a2:	0880                	addi	s0,sp,80
    800008a4:	8aaa                	mv	s5,a0
    800008a6:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800008a8:	0000f517          	auipc	a0,0xf
    800008ac:	08850513          	addi	a0,a0,136 # 8000f930 <tx_lock>
    800008b0:	342000ef          	jal	80000bf2 <acquire>

  int i = 0;
  while(i < n){ 
    800008b4:	06905063          	blez	s1,80000914 <uartwrite+0x7c>
    800008b8:	f84a                	sd	s2,48(sp)
    800008ba:	f44e                	sd	s3,40(sp)
    800008bc:	f052                	sd	s4,32(sp)
    800008be:	e85a                	sd	s6,16(sp)
    800008c0:	e45e                	sd	s7,8(sp)
    800008c2:	8a56                	mv	s4,s5
    800008c4:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    800008c6:	00007497          	auipc	s1,0x7
    800008ca:	f8648493          	addi	s1,s1,-122 # 8000784c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    800008ce:	0000f997          	auipc	s3,0xf
    800008d2:	06298993          	addi	s3,s3,98 # 8000f930 <tx_lock>
    800008d6:	00007917          	auipc	s2,0x7
    800008da:	f7290913          	addi	s2,s2,-142 # 80007848 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    800008de:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    800008e2:	4b05                	li	s6,1
    800008e4:	a005                	j	80000904 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    800008e6:	85ce                	mv	a1,s3
    800008e8:	854a                	mv	a0,s2
    800008ea:	612010ef          	jal	80001efc <sleep>
    while(tx_busy != 0){
    800008ee:	409c                	lw	a5,0(s1)
    800008f0:	fbfd                	bnez	a5,800008e6 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    800008f2:	000a4783          	lbu	a5,0(s4)
    800008f6:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    800008fa:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    800008fe:	0a05                	addi	s4,s4,1
    80000900:	015a0563          	beq	s4,s5,8000090a <uartwrite+0x72>
    while(tx_busy != 0){
    80000904:	409c                	lw	a5,0(s1)
    80000906:	f3e5                	bnez	a5,800008e6 <uartwrite+0x4e>
    80000908:	b7ed                	j	800008f2 <uartwrite+0x5a>
    8000090a:	7942                	ld	s2,48(sp)
    8000090c:	79a2                	ld	s3,40(sp)
    8000090e:	7a02                	ld	s4,32(sp)
    80000910:	6b42                	ld	s6,16(sp)
    80000912:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80000914:	0000f517          	auipc	a0,0xf
    80000918:	01c50513          	addi	a0,a0,28 # 8000f930 <tx_lock>
    8000091c:	36e000ef          	jal	80000c8a <release>
}
    80000920:	60a6                	ld	ra,72(sp)
    80000922:	6406                	ld	s0,64(sp)
    80000924:	74e2                	ld	s1,56(sp)
    80000926:	6ae2                	ld	s5,24(sp)
    80000928:	6161                	addi	sp,sp,80
    8000092a:	8082                	ret

000000008000092c <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000092c:	1101                	addi	sp,sp,-32
    8000092e:	ec06                	sd	ra,24(sp)
    80000930:	e822                	sd	s0,16(sp)
    80000932:	e426                	sd	s1,8(sp)
    80000934:	1000                	addi	s0,sp,32
    80000936:	84aa                	mv	s1,a0
  if(panicking == 0)
    80000938:	00007797          	auipc	a5,0x7
    8000093c:	f0c7a783          	lw	a5,-244(a5) # 80007844 <panicking>
    80000940:	cf95                	beqz	a5,8000097c <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000942:	00007797          	auipc	a5,0x7
    80000946:	efe7a783          	lw	a5,-258(a5) # 80007840 <panicked>
    8000094a:	ef85                	bnez	a5,80000982 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000094c:	10000737          	lui	a4,0x10000
    80000950:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000952:	00074783          	lbu	a5,0(a4)
    80000956:	0207f793          	andi	a5,a5,32
    8000095a:	dfe5                	beqz	a5,80000952 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000095c:	0ff4f513          	zext.b	a0,s1
    80000960:	100007b7          	lui	a5,0x10000
    80000964:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80000968:	00007797          	auipc	a5,0x7
    8000096c:	edc7a783          	lw	a5,-292(a5) # 80007844 <panicking>
    80000970:	cb91                	beqz	a5,80000984 <uartputc_sync+0x58>
    pop_off();
}
    80000972:	60e2                	ld	ra,24(sp)
    80000974:	6442                	ld	s0,16(sp)
    80000976:	64a2                	ld	s1,8(sp)
    80000978:	6105                	addi	sp,sp,32
    8000097a:	8082                	ret
    push_off();
    8000097c:	236000ef          	jal	80000bb2 <push_off>
    80000980:	b7c9                	j	80000942 <uartputc_sync+0x16>
    for(;;)
    80000982:	a001                	j	80000982 <uartputc_sync+0x56>
    pop_off();
    80000984:	2b2000ef          	jal	80000c36 <pop_off>
}
    80000988:	b7ed                	j	80000972 <uartputc_sync+0x46>

000000008000098a <uartgetc>:

// try to read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000098a:	1141                	addi	sp,sp,-16
    8000098c:	e422                	sd	s0,8(sp)
    8000098e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80000990:	100007b7          	lui	a5,0x10000
    80000994:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000996:	0007c783          	lbu	a5,0(a5)
    8000099a:	8b85                	andi	a5,a5,1
    8000099c:	cb81                	beqz	a5,800009ac <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000099e:	100007b7          	lui	a5,0x10000
    800009a2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009a6:	6422                	ld	s0,8(sp)
    800009a8:	0141                	addi	sp,sp,16
    800009aa:	8082                	ret
    return -1;
    800009ac:	557d                	li	a0,-1
    800009ae:	bfe5                	j	800009a6 <uartgetc+0x1c>

00000000800009b0 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009b0:	1101                	addi	sp,sp,-32
    800009b2:	ec06                	sd	ra,24(sp)
    800009b4:	e822                	sd	s0,16(sp)
    800009b6:	e426                	sd	s1,8(sp)
    800009b8:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009ba:	100007b7          	lui	a5,0x10000
    800009be:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800009c0:	0007c783          	lbu	a5,0(a5)

  acquire(&tx_lock);
    800009c4:	0000f517          	auipc	a0,0xf
    800009c8:	f6c50513          	addi	a0,a0,-148 # 8000f930 <tx_lock>
    800009cc:	226000ef          	jal	80000bf2 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    800009d0:	100007b7          	lui	a5,0x10000
    800009d4:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009d6:	0007c783          	lbu	a5,0(a5)
    800009da:	0207f793          	andi	a5,a5,32
    800009de:	eb89                	bnez	a5,800009f0 <uartintr+0x40>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    800009e0:	0000f517          	auipc	a0,0xf
    800009e4:	f5050513          	addi	a0,a0,-176 # 8000f930 <tx_lock>
    800009e8:	2a2000ef          	jal	80000c8a <release>

  // read and process incoming characters, if any.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009ec:	54fd                	li	s1,-1
    800009ee:	a831                	j	80000a0a <uartintr+0x5a>
    tx_busy = 0;
    800009f0:	00007797          	auipc	a5,0x7
    800009f4:	e407ae23          	sw	zero,-420(a5) # 8000784c <tx_busy>
    wakeup(&tx_chan);
    800009f8:	00007517          	auipc	a0,0x7
    800009fc:	e5050513          	addi	a0,a0,-432 # 80007848 <tx_chan>
    80000a00:	548010ef          	jal	80001f48 <wakeup>
    80000a04:	bff1                	j	800009e0 <uartintr+0x30>
      break;
    consoleintr(c);
    80000a06:	8a5ff0ef          	jal	800002aa <consoleintr>
    int c = uartgetc();
    80000a0a:	f81ff0ef          	jal	8000098a <uartgetc>
    if(c == -1)
    80000a0e:	fe951ce3          	bne	a0,s1,80000a06 <uartintr+0x56>
  }
}
    80000a12:	60e2                	ld	ra,24(sp)
    80000a14:	6442                	ld	s0,16(sp)
    80000a16:	64a2                	ld	s1,8(sp)
    80000a18:	6105                	addi	sp,sp,32
    80000a1a:	8082                	ret

0000000080000a1c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a1c:	1101                	addi	sp,sp,-32
    80000a1e:	ec06                	sd	ra,24(sp)
    80000a20:	e822                	sd	s0,16(sp)
    80000a22:	e426                	sd	s1,8(sp)
    80000a24:	e04a                	sd	s2,0(sp)
    80000a26:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a28:	03451793          	slli	a5,a0,0x34
    80000a2c:	e7a9                	bnez	a5,80000a76 <kfree+0x5a>
    80000a2e:	84aa                	mv	s1,a0
    80000a30:	00020797          	auipc	a5,0x20
    80000a34:	14878793          	addi	a5,a5,328 # 80020b78 <end>
    80000a38:	02f56f63          	bltu	a0,a5,80000a76 <kfree+0x5a>
    80000a3c:	47c5                	li	a5,17
    80000a3e:	07ee                	slli	a5,a5,0x1b
    80000a40:	02f57b63          	bgeu	a0,a5,80000a76 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a44:	6605                	lui	a2,0x1
    80000a46:	4585                	li	a1,1
    80000a48:	27e000ef          	jal	80000cc6 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a4c:	0000f917          	auipc	s2,0xf
    80000a50:	efc90913          	addi	s2,s2,-260 # 8000f948 <kmem>
    80000a54:	854a                	mv	a0,s2
    80000a56:	19c000ef          	jal	80000bf2 <acquire>
  r->next = kmem.freelist;
    80000a5a:	01893783          	ld	a5,24(s2)
    80000a5e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a60:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a64:	854a                	mv	a0,s2
    80000a66:	224000ef          	jal	80000c8a <release>
}
    80000a6a:	60e2                	ld	ra,24(sp)
    80000a6c:	6442                	ld	s0,16(sp)
    80000a6e:	64a2                	ld	s1,8(sp)
    80000a70:	6902                	ld	s2,0(sp)
    80000a72:	6105                	addi	sp,sp,32
    80000a74:	8082                	ret
    panic("kfree");
    80000a76:	00006517          	auipc	a0,0x6
    80000a7a:	5c250513          	addi	a0,a0,1474 # 80007038 <etext+0x38>
    80000a7e:	d63ff0ef          	jal	800007e0 <panic>

0000000080000a82 <freerange>:
{
    80000a82:	7179                	addi	sp,sp,-48
    80000a84:	f406                	sd	ra,40(sp)
    80000a86:	f022                	sd	s0,32(sp)
    80000a88:	ec26                	sd	s1,24(sp)
    80000a8a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a8c:	6785                	lui	a5,0x1
    80000a8e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a92:	00e504b3          	add	s1,a0,a4
    80000a96:	777d                	lui	a4,0xfffff
    80000a98:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a9a:	94be                	add	s1,s1,a5
    80000a9c:	0295e263          	bltu	a1,s1,80000ac0 <freerange+0x3e>
    80000aa0:	e84a                	sd	s2,16(sp)
    80000aa2:	e44e                	sd	s3,8(sp)
    80000aa4:	e052                	sd	s4,0(sp)
    80000aa6:	892e                	mv	s2,a1
    kfree(p);
    80000aa8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aaa:	6985                	lui	s3,0x1
    kfree(p);
    80000aac:	01448533          	add	a0,s1,s4
    80000ab0:	f6dff0ef          	jal	80000a1c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ab4:	94ce                	add	s1,s1,s3
    80000ab6:	fe997be3          	bgeu	s2,s1,80000aac <freerange+0x2a>
    80000aba:	6942                	ld	s2,16(sp)
    80000abc:	69a2                	ld	s3,8(sp)
    80000abe:	6a02                	ld	s4,0(sp)
}
    80000ac0:	70a2                	ld	ra,40(sp)
    80000ac2:	7402                	ld	s0,32(sp)
    80000ac4:	64e2                	ld	s1,24(sp)
    80000ac6:	6145                	addi	sp,sp,48
    80000ac8:	8082                	ret

0000000080000aca <kinit>:
{
    80000aca:	1141                	addi	sp,sp,-16
    80000acc:	e406                	sd	ra,8(sp)
    80000ace:	e022                	sd	s0,0(sp)
    80000ad0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ad2:	00006597          	auipc	a1,0x6
    80000ad6:	56e58593          	addi	a1,a1,1390 # 80007040 <etext+0x40>
    80000ada:	0000f517          	auipc	a0,0xf
    80000ade:	e6e50513          	addi	a0,a0,-402 # 8000f948 <kmem>
    80000ae2:	090000ef          	jal	80000b72 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ae6:	45c5                	li	a1,17
    80000ae8:	05ee                	slli	a1,a1,0x1b
    80000aea:	00020517          	auipc	a0,0x20
    80000aee:	08e50513          	addi	a0,a0,142 # 80020b78 <end>
    80000af2:	f91ff0ef          	jal	80000a82 <freerange>
}
    80000af6:	60a2                	ld	ra,8(sp)
    80000af8:	6402                	ld	s0,0(sp)
    80000afa:	0141                	addi	sp,sp,16
    80000afc:	8082                	ret

0000000080000afe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000afe:	1101                	addi	sp,sp,-32
    80000b00:	ec06                	sd	ra,24(sp)
    80000b02:	e822                	sd	s0,16(sp)
    80000b04:	e426                	sd	s1,8(sp)
    80000b06:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b08:	0000f497          	auipc	s1,0xf
    80000b0c:	e4048493          	addi	s1,s1,-448 # 8000f948 <kmem>
    80000b10:	8526                	mv	a0,s1
    80000b12:	0e0000ef          	jal	80000bf2 <acquire>
  r = kmem.freelist;
    80000b16:	6c84                	ld	s1,24(s1)
  if(r)
    80000b18:	c485                	beqz	s1,80000b40 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b1a:	609c                	ld	a5,0(s1)
    80000b1c:	0000f517          	auipc	a0,0xf
    80000b20:	e2c50513          	addi	a0,a0,-468 # 8000f948 <kmem>
    80000b24:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b26:	164000ef          	jal	80000c8a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b2a:	6605                	lui	a2,0x1
    80000b2c:	4595                	li	a1,5
    80000b2e:	8526                	mv	a0,s1
    80000b30:	196000ef          	jal	80000cc6 <memset>
  return (void*)r;
}
    80000b34:	8526                	mv	a0,s1
    80000b36:	60e2                	ld	ra,24(sp)
    80000b38:	6442                	ld	s0,16(sp)
    80000b3a:	64a2                	ld	s1,8(sp)
    80000b3c:	6105                	addi	sp,sp,32
    80000b3e:	8082                	ret
  release(&kmem.lock);
    80000b40:	0000f517          	auipc	a0,0xf
    80000b44:	e0850513          	addi	a0,a0,-504 # 8000f948 <kmem>
    80000b48:	142000ef          	jal	80000c8a <release>
  if(r)
    80000b4c:	b7e5                	j	80000b34 <kalloc+0x36>

0000000080000b4e <kmemfree>:

uint64
kmemfree(void)
{
    80000b4e:	1141                	addi	sp,sp,-16
    80000b50:	e422                	sd	s0,8(sp)
    80000b52:	0800                	addi	s0,sp,16
  struct run *r;
  uint64 free = 0;
  for(r = kmem.freelist; r; r=r->next){
    80000b54:	0000f797          	auipc	a5,0xf
    80000b58:	e0c7b783          	ld	a5,-500(a5) # 8000f960 <kmem+0x18>
    80000b5c:	cb89                	beqz	a5,80000b6e <kmemfree+0x20>
  uint64 free = 0;
    80000b5e:	4501                	li	a0,0
    free += PGSIZE;
    80000b60:	6705                	lui	a4,0x1
    80000b62:	953a                	add	a0,a0,a4
  for(r = kmem.freelist; r; r=r->next){
    80000b64:	639c                	ld	a5,0(a5)
    80000b66:	fff5                	bnez	a5,80000b62 <kmemfree+0x14>
  }
  return free;
}
    80000b68:	6422                	ld	s0,8(sp)
    80000b6a:	0141                	addi	sp,sp,16
    80000b6c:	8082                	ret
  uint64 free = 0;
    80000b6e:	4501                	li	a0,0
  return free;
    80000b70:	bfe5                	j	80000b68 <kmemfree+0x1a>

0000000080000b72 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b72:	1141                	addi	sp,sp,-16
    80000b74:	e422                	sd	s0,8(sp)
    80000b76:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b78:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b7e:	00053823          	sd	zero,16(a0)
}
    80000b82:	6422                	ld	s0,8(sp)
    80000b84:	0141                	addi	sp,sp,16
    80000b86:	8082                	ret

0000000080000b88 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b88:	411c                	lw	a5,0(a0)
    80000b8a:	e399                	bnez	a5,80000b90 <holding+0x8>
    80000b8c:	4501                	li	a0,0
  return r;
}
    80000b8e:	8082                	ret
{
    80000b90:	1101                	addi	sp,sp,-32
    80000b92:	ec06                	sd	ra,24(sp)
    80000b94:	e822                	sd	s0,16(sp)
    80000b96:	e426                	sd	s1,8(sp)
    80000b98:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9a:	6904                	ld	s1,16(a0)
    80000b9c:	53b000ef          	jal	800018d6 <mycpu>
    80000ba0:	40a48533          	sub	a0,s1,a0
    80000ba4:	00153513          	seqz	a0,a0
}
    80000ba8:	60e2                	ld	ra,24(sp)
    80000baa:	6442                	ld	s0,16(sp)
    80000bac:	64a2                	ld	s1,8(sp)
    80000bae:	6105                	addi	sp,sp,32
    80000bb0:	8082                	ret

0000000080000bb2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb2:	1101                	addi	sp,sp,-32
    80000bb4:	ec06                	sd	ra,24(sp)
    80000bb6:	e822                	sd	s0,16(sp)
    80000bb8:	e426                	sd	s1,8(sp)
    80000bba:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bbc:	100024f3          	csrr	s1,sstatus
    80000bc0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc6:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000bca:	50d000ef          	jal	800018d6 <mycpu>
    80000bce:	5d3c                	lw	a5,120(a0)
    80000bd0:	cb99                	beqz	a5,80000be6 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd2:	505000ef          	jal	800018d6 <mycpu>
    80000bd6:	5d3c                	lw	a5,120(a0)
    80000bd8:	2785                	addiw	a5,a5,1
    80000bda:	dd3c                	sw	a5,120(a0)
}
    80000bdc:	60e2                	ld	ra,24(sp)
    80000bde:	6442                	ld	s0,16(sp)
    80000be0:	64a2                	ld	s1,8(sp)
    80000be2:	6105                	addi	sp,sp,32
    80000be4:	8082                	ret
    mycpu()->intena = old;
    80000be6:	4f1000ef          	jal	800018d6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bea:	8085                	srli	s1,s1,0x1
    80000bec:	8885                	andi	s1,s1,1
    80000bee:	dd64                	sw	s1,124(a0)
    80000bf0:	b7cd                	j	80000bd2 <push_off+0x20>

0000000080000bf2 <acquire>:
{
    80000bf2:	1101                	addi	sp,sp,-32
    80000bf4:	ec06                	sd	ra,24(sp)
    80000bf6:	e822                	sd	s0,16(sp)
    80000bf8:	e426                	sd	s1,8(sp)
    80000bfa:	1000                	addi	s0,sp,32
    80000bfc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bfe:	fb5ff0ef          	jal	80000bb2 <push_off>
  if(holding(lk))
    80000c02:	8526                	mv	a0,s1
    80000c04:	f85ff0ef          	jal	80000b88 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c08:	4705                	li	a4,1
  if(holding(lk))
    80000c0a:	e105                	bnez	a0,80000c2a <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0c:	87ba                	mv	a5,a4
    80000c0e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c12:	2781                	sext.w	a5,a5
    80000c14:	ffe5                	bnez	a5,80000c0c <acquire+0x1a>
  __sync_synchronize();
    80000c16:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c1a:	4bd000ef          	jal	800018d6 <mycpu>
    80000c1e:	e888                	sd	a0,16(s1)
}
    80000c20:	60e2                	ld	ra,24(sp)
    80000c22:	6442                	ld	s0,16(sp)
    80000c24:	64a2                	ld	s1,8(sp)
    80000c26:	6105                	addi	sp,sp,32
    80000c28:	8082                	ret
    panic("acquire");
    80000c2a:	00006517          	auipc	a0,0x6
    80000c2e:	41e50513          	addi	a0,a0,1054 # 80007048 <etext+0x48>
    80000c32:	bafff0ef          	jal	800007e0 <panic>

0000000080000c36 <pop_off>:

void
pop_off(void)
{
    80000c36:	1141                	addi	sp,sp,-16
    80000c38:	e406                	sd	ra,8(sp)
    80000c3a:	e022                	sd	s0,0(sp)
    80000c3c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c3e:	499000ef          	jal	800018d6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c42:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c46:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c48:	e78d                	bnez	a5,80000c72 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4a:	5d3c                	lw	a5,120(a0)
    80000c4c:	02f05963          	blez	a5,80000c7e <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c50:	37fd                	addiw	a5,a5,-1
    80000c52:	0007871b          	sext.w	a4,a5
    80000c56:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c58:	eb09                	bnez	a4,80000c6a <pop_off+0x34>
    80000c5a:	5d7c                	lw	a5,124(a0)
    80000c5c:	c799                	beqz	a5,80000c6a <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c5e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c62:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c66:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6a:	60a2                	ld	ra,8(sp)
    80000c6c:	6402                	ld	s0,0(sp)
    80000c6e:	0141                	addi	sp,sp,16
    80000c70:	8082                	ret
    panic("pop_off - interruptible");
    80000c72:	00006517          	auipc	a0,0x6
    80000c76:	3de50513          	addi	a0,a0,990 # 80007050 <etext+0x50>
    80000c7a:	b67ff0ef          	jal	800007e0 <panic>
    panic("pop_off");
    80000c7e:	00006517          	auipc	a0,0x6
    80000c82:	3ea50513          	addi	a0,a0,1002 # 80007068 <etext+0x68>
    80000c86:	b5bff0ef          	jal	800007e0 <panic>

0000000080000c8a <release>:
{
    80000c8a:	1101                	addi	sp,sp,-32
    80000c8c:	ec06                	sd	ra,24(sp)
    80000c8e:	e822                	sd	s0,16(sp)
    80000c90:	e426                	sd	s1,8(sp)
    80000c92:	1000                	addi	s0,sp,32
    80000c94:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c96:	ef3ff0ef          	jal	80000b88 <holding>
    80000c9a:	c105                	beqz	a0,80000cba <release+0x30>
  lk->cpu = 0;
    80000c9c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca4:	0f50000f          	fence	iorw,ow
    80000ca8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cac:	f8bff0ef          	jal	80000c36 <pop_off>
}
    80000cb0:	60e2                	ld	ra,24(sp)
    80000cb2:	6442                	ld	s0,16(sp)
    80000cb4:	64a2                	ld	s1,8(sp)
    80000cb6:	6105                	addi	sp,sp,32
    80000cb8:	8082                	ret
    panic("release");
    80000cba:	00006517          	auipc	a0,0x6
    80000cbe:	3b650513          	addi	a0,a0,950 # 80007070 <etext+0x70>
    80000cc2:	b1fff0ef          	jal	800007e0 <panic>

0000000080000cc6 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cc6:	1141                	addi	sp,sp,-16
    80000cc8:	e422                	sd	s0,8(sp)
    80000cca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000ccc:	ca19                	beqz	a2,80000ce2 <memset+0x1c>
    80000cce:	87aa                	mv	a5,a0
    80000cd0:	1602                	slli	a2,a2,0x20
    80000cd2:	9201                	srli	a2,a2,0x20
    80000cd4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cd8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cdc:	0785                	addi	a5,a5,1
    80000cde:	fee79de3          	bne	a5,a4,80000cd8 <memset+0x12>
  }
  return dst;
}
    80000ce2:	6422                	ld	s0,8(sp)
    80000ce4:	0141                	addi	sp,sp,16
    80000ce6:	8082                	ret

0000000080000ce8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000ce8:	1141                	addi	sp,sp,-16
    80000cea:	e422                	sd	s0,8(sp)
    80000cec:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cee:	ca05                	beqz	a2,80000d1e <memcmp+0x36>
    80000cf0:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cf4:	1682                	slli	a3,a3,0x20
    80000cf6:	9281                	srli	a3,a3,0x20
    80000cf8:	0685                	addi	a3,a3,1
    80000cfa:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cfc:	00054783          	lbu	a5,0(a0)
    80000d00:	0005c703          	lbu	a4,0(a1)
    80000d04:	00e79863          	bne	a5,a4,80000d14 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d08:	0505                	addi	a0,a0,1
    80000d0a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d0c:	fed518e3          	bne	a0,a3,80000cfc <memcmp+0x14>
  }

  return 0;
    80000d10:	4501                	li	a0,0
    80000d12:	a019                	j	80000d18 <memcmp+0x30>
      return *s1 - *s2;
    80000d14:	40e7853b          	subw	a0,a5,a4
}
    80000d18:	6422                	ld	s0,8(sp)
    80000d1a:	0141                	addi	sp,sp,16
    80000d1c:	8082                	ret
  return 0;
    80000d1e:	4501                	li	a0,0
    80000d20:	bfe5                	j	80000d18 <memcmp+0x30>

0000000080000d22 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d22:	1141                	addi	sp,sp,-16
    80000d24:	e422                	sd	s0,8(sp)
    80000d26:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d28:	c205                	beqz	a2,80000d48 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2a:	02a5e263          	bltu	a1,a0,80000d4e <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d2e:	1602                	slli	a2,a2,0x20
    80000d30:	9201                	srli	a2,a2,0x20
    80000d32:	00c587b3          	add	a5,a1,a2
{
    80000d36:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d38:	0585                	addi	a1,a1,1
    80000d3a:	0705                	addi	a4,a4,1 # 1001 <_entry-0x7fffefff>
    80000d3c:	fff5c683          	lbu	a3,-1(a1)
    80000d40:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d44:	feb79ae3          	bne	a5,a1,80000d38 <memmove+0x16>

  return dst;
}
    80000d48:	6422                	ld	s0,8(sp)
    80000d4a:	0141                	addi	sp,sp,16
    80000d4c:	8082                	ret
  if(s < d && s + n > d){
    80000d4e:	02061693          	slli	a3,a2,0x20
    80000d52:	9281                	srli	a3,a3,0x20
    80000d54:	00d58733          	add	a4,a1,a3
    80000d58:	fce57be3          	bgeu	a0,a4,80000d2e <memmove+0xc>
    d += n;
    80000d5c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d5e:	fff6079b          	addiw	a5,a2,-1
    80000d62:	1782                	slli	a5,a5,0x20
    80000d64:	9381                	srli	a5,a5,0x20
    80000d66:	fff7c793          	not	a5,a5
    80000d6a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d6c:	177d                	addi	a4,a4,-1
    80000d6e:	16fd                	addi	a3,a3,-1
    80000d70:	00074603          	lbu	a2,0(a4)
    80000d74:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d78:	fef71ae3          	bne	a4,a5,80000d6c <memmove+0x4a>
    80000d7c:	b7f1                	j	80000d48 <memmove+0x26>

0000000080000d7e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d7e:	1141                	addi	sp,sp,-16
    80000d80:	e406                	sd	ra,8(sp)
    80000d82:	e022                	sd	s0,0(sp)
    80000d84:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d86:	f9dff0ef          	jal	80000d22 <memmove>
}
    80000d8a:	60a2                	ld	ra,8(sp)
    80000d8c:	6402                	ld	s0,0(sp)
    80000d8e:	0141                	addi	sp,sp,16
    80000d90:	8082                	ret

0000000080000d92 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d92:	1141                	addi	sp,sp,-16
    80000d94:	e422                	sd	s0,8(sp)
    80000d96:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d98:	ce11                	beqz	a2,80000db4 <strncmp+0x22>
    80000d9a:	00054783          	lbu	a5,0(a0)
    80000d9e:	cf89                	beqz	a5,80000db8 <strncmp+0x26>
    80000da0:	0005c703          	lbu	a4,0(a1)
    80000da4:	00f71a63          	bne	a4,a5,80000db8 <strncmp+0x26>
    n--, p++, q++;
    80000da8:	367d                	addiw	a2,a2,-1
    80000daa:	0505                	addi	a0,a0,1
    80000dac:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dae:	f675                	bnez	a2,80000d9a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db0:	4501                	li	a0,0
    80000db2:	a801                	j	80000dc2 <strncmp+0x30>
    80000db4:	4501                	li	a0,0
    80000db6:	a031                	j	80000dc2 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000db8:	00054503          	lbu	a0,0(a0)
    80000dbc:	0005c783          	lbu	a5,0(a1)
    80000dc0:	9d1d                	subw	a0,a0,a5
}
    80000dc2:	6422                	ld	s0,8(sp)
    80000dc4:	0141                	addi	sp,sp,16
    80000dc6:	8082                	ret

0000000080000dc8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dc8:	1141                	addi	sp,sp,-16
    80000dca:	e422                	sd	s0,8(sp)
    80000dcc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dce:	87aa                	mv	a5,a0
    80000dd0:	86b2                	mv	a3,a2
    80000dd2:	367d                	addiw	a2,a2,-1
    80000dd4:	02d05563          	blez	a3,80000dfe <strncpy+0x36>
    80000dd8:	0785                	addi	a5,a5,1
    80000dda:	0005c703          	lbu	a4,0(a1)
    80000dde:	fee78fa3          	sb	a4,-1(a5)
    80000de2:	0585                	addi	a1,a1,1
    80000de4:	f775                	bnez	a4,80000dd0 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000de6:	873e                	mv	a4,a5
    80000de8:	9fb5                	addw	a5,a5,a3
    80000dea:	37fd                	addiw	a5,a5,-1
    80000dec:	00c05963          	blez	a2,80000dfe <strncpy+0x36>
    *s++ = 0;
    80000df0:	0705                	addi	a4,a4,1
    80000df2:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000df6:	40e786bb          	subw	a3,a5,a4
    80000dfa:	fed04be3          	bgtz	a3,80000df0 <strncpy+0x28>
  return os;
}
    80000dfe:	6422                	ld	s0,8(sp)
    80000e00:	0141                	addi	sp,sp,16
    80000e02:	8082                	ret

0000000080000e04 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e04:	1141                	addi	sp,sp,-16
    80000e06:	e422                	sd	s0,8(sp)
    80000e08:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e0a:	02c05363          	blez	a2,80000e30 <safestrcpy+0x2c>
    80000e0e:	fff6069b          	addiw	a3,a2,-1
    80000e12:	1682                	slli	a3,a3,0x20
    80000e14:	9281                	srli	a3,a3,0x20
    80000e16:	96ae                	add	a3,a3,a1
    80000e18:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e1a:	00d58963          	beq	a1,a3,80000e2c <safestrcpy+0x28>
    80000e1e:	0585                	addi	a1,a1,1
    80000e20:	0785                	addi	a5,a5,1
    80000e22:	fff5c703          	lbu	a4,-1(a1)
    80000e26:	fee78fa3          	sb	a4,-1(a5)
    80000e2a:	fb65                	bnez	a4,80000e1a <safestrcpy+0x16>
    ;
  *s = 0;
    80000e2c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e30:	6422                	ld	s0,8(sp)
    80000e32:	0141                	addi	sp,sp,16
    80000e34:	8082                	ret

0000000080000e36 <strlen>:

int
strlen(const char *s)
{
    80000e36:	1141                	addi	sp,sp,-16
    80000e38:	e422                	sd	s0,8(sp)
    80000e3a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e3c:	00054783          	lbu	a5,0(a0)
    80000e40:	cf91                	beqz	a5,80000e5c <strlen+0x26>
    80000e42:	0505                	addi	a0,a0,1
    80000e44:	87aa                	mv	a5,a0
    80000e46:	86be                	mv	a3,a5
    80000e48:	0785                	addi	a5,a5,1
    80000e4a:	fff7c703          	lbu	a4,-1(a5)
    80000e4e:	ff65                	bnez	a4,80000e46 <strlen+0x10>
    80000e50:	40a6853b          	subw	a0,a3,a0
    80000e54:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e56:	6422                	ld	s0,8(sp)
    80000e58:	0141                	addi	sp,sp,16
    80000e5a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e5c:	4501                	li	a0,0
    80000e5e:	bfe5                	j	80000e56 <strlen+0x20>

0000000080000e60 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e406                	sd	ra,8(sp)
    80000e64:	e022                	sd	s0,0(sp)
    80000e66:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e68:	25f000ef          	jal	800018c6 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e6c:	00007717          	auipc	a4,0x7
    80000e70:	9e470713          	addi	a4,a4,-1564 # 80007850 <started>
  if(cpuid() == 0){
    80000e74:	c51d                	beqz	a0,80000ea2 <main+0x42>
    while(started == 0)
    80000e76:	431c                	lw	a5,0(a4)
    80000e78:	2781                	sext.w	a5,a5
    80000e7a:	dff5                	beqz	a5,80000e76 <main+0x16>
      ;
    __sync_synchronize();
    80000e7c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e80:	247000ef          	jal	800018c6 <cpuid>
    80000e84:	85aa                	mv	a1,a0
    80000e86:	00006517          	auipc	a0,0x6
    80000e8a:	21250513          	addi	a0,a0,530 # 80007098 <etext+0x98>
    80000e8e:	e6cff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000e92:	080000ef          	jal	80000f12 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e96:	588010ef          	jal	8000241e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9a:	56e040ef          	jal	80005408 <plicinithart>
  }

  scheduler();        
    80000e9e:	6c7000ef          	jal	80001d64 <scheduler>
    consoleinit();
    80000ea2:	d82ff0ef          	jal	80000424 <consoleinit>
    printfinit();
    80000ea6:	977ff0ef          	jal	8000081c <printfinit>
    printf("\n");
    80000eaa:	00006517          	auipc	a0,0x6
    80000eae:	1ce50513          	addi	a0,a0,462 # 80007078 <etext+0x78>
    80000eb2:	e48ff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000eb6:	00006517          	auipc	a0,0x6
    80000eba:	1ca50513          	addi	a0,a0,458 # 80007080 <etext+0x80>
    80000ebe:	e3cff0ef          	jal	800004fa <printf>
    printf("\n");
    80000ec2:	00006517          	auipc	a0,0x6
    80000ec6:	1b650513          	addi	a0,a0,438 # 80007078 <etext+0x78>
    80000eca:	e30ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000ece:	bfdff0ef          	jal	80000aca <kinit>
    kvminit();       // create kernel page table
    80000ed2:	2ca000ef          	jal	8000119c <kvminit>
    kvminithart();   // turn on paging
    80000ed6:	03c000ef          	jal	80000f12 <kvminithart>
    procinit();      // process table
    80000eda:	137000ef          	jal	80001810 <procinit>
    trapinit();      // trap vectors
    80000ede:	51c010ef          	jal	800023fa <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee2:	53c010ef          	jal	8000241e <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee6:	508040ef          	jal	800053ee <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eea:	51e040ef          	jal	80005408 <plicinithart>
    binit();         // buffer cache
    80000eee:	3db010ef          	jal	80002ac8 <binit>
    iinit();         // inode table
    80000ef2:	160020ef          	jal	80003052 <iinit>
    fileinit();      // file table
    80000ef6:	052030ef          	jal	80003f48 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efa:	5fe040ef          	jal	800054f8 <virtio_disk_init>
    userinit();      // first user process
    80000efe:	4bb000ef          	jal	80001bb8 <userinit>
    __sync_synchronize();
    80000f02:	0ff0000f          	fence
    started = 1;
    80000f06:	4785                	li	a5,1
    80000f08:	00007717          	auipc	a4,0x7
    80000f0c:	94f72423          	sw	a5,-1720(a4) # 80007850 <started>
    80000f10:	b779                	j	80000e9e <main+0x3e>

0000000080000f12 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f12:	1141                	addi	sp,sp,-16
    80000f14:	e422                	sd	s0,8(sp)
    80000f16:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f18:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f1c:	00007797          	auipc	a5,0x7
    80000f20:	93c7b783          	ld	a5,-1732(a5) # 80007858 <kernel_pagetable>
    80000f24:	83b1                	srli	a5,a5,0xc
    80000f26:	577d                	li	a4,-1
    80000f28:	177e                	slli	a4,a4,0x3f
    80000f2a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f2c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f30:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f34:	6422                	ld	s0,8(sp)
    80000f36:	0141                	addi	sp,sp,16
    80000f38:	8082                	ret

0000000080000f3a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f3a:	7139                	addi	sp,sp,-64
    80000f3c:	fc06                	sd	ra,56(sp)
    80000f3e:	f822                	sd	s0,48(sp)
    80000f40:	f426                	sd	s1,40(sp)
    80000f42:	f04a                	sd	s2,32(sp)
    80000f44:	ec4e                	sd	s3,24(sp)
    80000f46:	e852                	sd	s4,16(sp)
    80000f48:	e456                	sd	s5,8(sp)
    80000f4a:	e05a                	sd	s6,0(sp)
    80000f4c:	0080                	addi	s0,sp,64
    80000f4e:	84aa                	mv	s1,a0
    80000f50:	89ae                	mv	s3,a1
    80000f52:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f54:	57fd                	li	a5,-1
    80000f56:	83e9                	srli	a5,a5,0x1a
    80000f58:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f5a:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f5c:	02b7fc63          	bgeu	a5,a1,80000f94 <walk+0x5a>
    panic("walk");
    80000f60:	00006517          	auipc	a0,0x6
    80000f64:	15050513          	addi	a0,a0,336 # 800070b0 <etext+0xb0>
    80000f68:	879ff0ef          	jal	800007e0 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f6c:	060a8263          	beqz	s5,80000fd0 <walk+0x96>
    80000f70:	b8fff0ef          	jal	80000afe <kalloc>
    80000f74:	84aa                	mv	s1,a0
    80000f76:	c139                	beqz	a0,80000fbc <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f78:	6605                	lui	a2,0x1
    80000f7a:	4581                	li	a1,0
    80000f7c:	d4bff0ef          	jal	80000cc6 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f80:	00c4d793          	srli	a5,s1,0xc
    80000f84:	07aa                	slli	a5,a5,0xa
    80000f86:	0017e793          	ori	a5,a5,1
    80000f8a:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f8e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffde47f>
    80000f90:	036a0063          	beq	s4,s6,80000fb0 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f94:	0149d933          	srl	s2,s3,s4
    80000f98:	1ff97913          	andi	s2,s2,511
    80000f9c:	090e                	slli	s2,s2,0x3
    80000f9e:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fa0:	00093483          	ld	s1,0(s2)
    80000fa4:	0014f793          	andi	a5,s1,1
    80000fa8:	d3f1                	beqz	a5,80000f6c <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000faa:	80a9                	srli	s1,s1,0xa
    80000fac:	04b2                	slli	s1,s1,0xc
    80000fae:	b7c5                	j	80000f8e <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fb0:	00c9d513          	srli	a0,s3,0xc
    80000fb4:	1ff57513          	andi	a0,a0,511
    80000fb8:	050e                	slli	a0,a0,0x3
    80000fba:	9526                	add	a0,a0,s1
}
    80000fbc:	70e2                	ld	ra,56(sp)
    80000fbe:	7442                	ld	s0,48(sp)
    80000fc0:	74a2                	ld	s1,40(sp)
    80000fc2:	7902                	ld	s2,32(sp)
    80000fc4:	69e2                	ld	s3,24(sp)
    80000fc6:	6a42                	ld	s4,16(sp)
    80000fc8:	6aa2                	ld	s5,8(sp)
    80000fca:	6b02                	ld	s6,0(sp)
    80000fcc:	6121                	addi	sp,sp,64
    80000fce:	8082                	ret
        return 0;
    80000fd0:	4501                	li	a0,0
    80000fd2:	b7ed                	j	80000fbc <walk+0x82>

0000000080000fd4 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fd4:	57fd                	li	a5,-1
    80000fd6:	83e9                	srli	a5,a5,0x1a
    80000fd8:	00b7f463          	bgeu	a5,a1,80000fe0 <walkaddr+0xc>
    return 0;
    80000fdc:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fde:	8082                	ret
{
    80000fe0:	1141                	addi	sp,sp,-16
    80000fe2:	e406                	sd	ra,8(sp)
    80000fe4:	e022                	sd	s0,0(sp)
    80000fe6:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fe8:	4601                	li	a2,0
    80000fea:	f51ff0ef          	jal	80000f3a <walk>
  if(pte == 0)
    80000fee:	c105                	beqz	a0,8000100e <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000ff0:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000ff2:	0117f693          	andi	a3,a5,17
    80000ff6:	4745                	li	a4,17
    return 0;
    80000ff8:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000ffa:	00e68663          	beq	a3,a4,80001006 <walkaddr+0x32>
}
    80000ffe:	60a2                	ld	ra,8(sp)
    80001000:	6402                	ld	s0,0(sp)
    80001002:	0141                	addi	sp,sp,16
    80001004:	8082                	ret
  pa = PTE2PA(*pte);
    80001006:	83a9                	srli	a5,a5,0xa
    80001008:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000100c:	bfcd                	j	80000ffe <walkaddr+0x2a>
    return 0;
    8000100e:	4501                	li	a0,0
    80001010:	b7fd                	j	80000ffe <walkaddr+0x2a>

0000000080001012 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001012:	715d                	addi	sp,sp,-80
    80001014:	e486                	sd	ra,72(sp)
    80001016:	e0a2                	sd	s0,64(sp)
    80001018:	fc26                	sd	s1,56(sp)
    8000101a:	f84a                	sd	s2,48(sp)
    8000101c:	f44e                	sd	s3,40(sp)
    8000101e:	f052                	sd	s4,32(sp)
    80001020:	ec56                	sd	s5,24(sp)
    80001022:	e85a                	sd	s6,16(sp)
    80001024:	e45e                	sd	s7,8(sp)
    80001026:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001028:	03459793          	slli	a5,a1,0x34
    8000102c:	e7a9                	bnez	a5,80001076 <mappages+0x64>
    8000102e:	8aaa                	mv	s5,a0
    80001030:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001032:	03461793          	slli	a5,a2,0x34
    80001036:	e7b1                	bnez	a5,80001082 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80001038:	ca39                	beqz	a2,8000108e <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000103a:	77fd                	lui	a5,0xfffff
    8000103c:	963e                	add	a2,a2,a5
    8000103e:	00b609b3          	add	s3,a2,a1
  a = va;
    80001042:	892e                	mv	s2,a1
    80001044:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001048:	6b85                	lui	s7,0x1
    8000104a:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000104e:	4605                	li	a2,1
    80001050:	85ca                	mv	a1,s2
    80001052:	8556                	mv	a0,s5
    80001054:	ee7ff0ef          	jal	80000f3a <walk>
    80001058:	c539                	beqz	a0,800010a6 <mappages+0x94>
    if(*pte & PTE_V)
    8000105a:	611c                	ld	a5,0(a0)
    8000105c:	8b85                	andi	a5,a5,1
    8000105e:	ef95                	bnez	a5,8000109a <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001060:	80b1                	srli	s1,s1,0xc
    80001062:	04aa                	slli	s1,s1,0xa
    80001064:	0164e4b3          	or	s1,s1,s6
    80001068:	0014e493          	ori	s1,s1,1
    8000106c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000106e:	05390863          	beq	s2,s3,800010be <mappages+0xac>
    a += PGSIZE;
    80001072:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001074:	bfd9                	j	8000104a <mappages+0x38>
    panic("mappages: va not aligned");
    80001076:	00006517          	auipc	a0,0x6
    8000107a:	04250513          	addi	a0,a0,66 # 800070b8 <etext+0xb8>
    8000107e:	f62ff0ef          	jal	800007e0 <panic>
    panic("mappages: size not aligned");
    80001082:	00006517          	auipc	a0,0x6
    80001086:	05650513          	addi	a0,a0,86 # 800070d8 <etext+0xd8>
    8000108a:	f56ff0ef          	jal	800007e0 <panic>
    panic("mappages: size");
    8000108e:	00006517          	auipc	a0,0x6
    80001092:	06a50513          	addi	a0,a0,106 # 800070f8 <etext+0xf8>
    80001096:	f4aff0ef          	jal	800007e0 <panic>
      panic("mappages: remap");
    8000109a:	00006517          	auipc	a0,0x6
    8000109e:	06e50513          	addi	a0,a0,110 # 80007108 <etext+0x108>
    800010a2:	f3eff0ef          	jal	800007e0 <panic>
      return -1;
    800010a6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010a8:	60a6                	ld	ra,72(sp)
    800010aa:	6406                	ld	s0,64(sp)
    800010ac:	74e2                	ld	s1,56(sp)
    800010ae:	7942                	ld	s2,48(sp)
    800010b0:	79a2                	ld	s3,40(sp)
    800010b2:	7a02                	ld	s4,32(sp)
    800010b4:	6ae2                	ld	s5,24(sp)
    800010b6:	6b42                	ld	s6,16(sp)
    800010b8:	6ba2                	ld	s7,8(sp)
    800010ba:	6161                	addi	sp,sp,80
    800010bc:	8082                	ret
  return 0;
    800010be:	4501                	li	a0,0
    800010c0:	b7e5                	j	800010a8 <mappages+0x96>

00000000800010c2 <kvmmap>:
{
    800010c2:	1141                	addi	sp,sp,-16
    800010c4:	e406                	sd	ra,8(sp)
    800010c6:	e022                	sd	s0,0(sp)
    800010c8:	0800                	addi	s0,sp,16
    800010ca:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010cc:	86b2                	mv	a3,a2
    800010ce:	863e                	mv	a2,a5
    800010d0:	f43ff0ef          	jal	80001012 <mappages>
    800010d4:	e509                	bnez	a0,800010de <kvmmap+0x1c>
}
    800010d6:	60a2                	ld	ra,8(sp)
    800010d8:	6402                	ld	s0,0(sp)
    800010da:	0141                	addi	sp,sp,16
    800010dc:	8082                	ret
    panic("kvmmap");
    800010de:	00006517          	auipc	a0,0x6
    800010e2:	03a50513          	addi	a0,a0,58 # 80007118 <etext+0x118>
    800010e6:	efaff0ef          	jal	800007e0 <panic>

00000000800010ea <kvmmake>:
{
    800010ea:	1101                	addi	sp,sp,-32
    800010ec:	ec06                	sd	ra,24(sp)
    800010ee:	e822                	sd	s0,16(sp)
    800010f0:	e426                	sd	s1,8(sp)
    800010f2:	e04a                	sd	s2,0(sp)
    800010f4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010f6:	a09ff0ef          	jal	80000afe <kalloc>
    800010fa:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010fc:	6605                	lui	a2,0x1
    800010fe:	4581                	li	a1,0
    80001100:	bc7ff0ef          	jal	80000cc6 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001104:	4719                	li	a4,6
    80001106:	6685                	lui	a3,0x1
    80001108:	10000637          	lui	a2,0x10000
    8000110c:	100005b7          	lui	a1,0x10000
    80001110:	8526                	mv	a0,s1
    80001112:	fb1ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001116:	4719                	li	a4,6
    80001118:	6685                	lui	a3,0x1
    8000111a:	10001637          	lui	a2,0x10001
    8000111e:	100015b7          	lui	a1,0x10001
    80001122:	8526                	mv	a0,s1
    80001124:	f9fff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001128:	4719                	li	a4,6
    8000112a:	040006b7          	lui	a3,0x4000
    8000112e:	0c000637          	lui	a2,0xc000
    80001132:	0c0005b7          	lui	a1,0xc000
    80001136:	8526                	mv	a0,s1
    80001138:	f8bff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000113c:	00006917          	auipc	s2,0x6
    80001140:	ec490913          	addi	s2,s2,-316 # 80007000 <etext>
    80001144:	4729                	li	a4,10
    80001146:	80006697          	auipc	a3,0x80006
    8000114a:	eba68693          	addi	a3,a3,-326 # 7000 <_entry-0x7fff9000>
    8000114e:	4605                	li	a2,1
    80001150:	067e                	slli	a2,a2,0x1f
    80001152:	85b2                	mv	a1,a2
    80001154:	8526                	mv	a0,s1
    80001156:	f6dff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000115a:	46c5                	li	a3,17
    8000115c:	06ee                	slli	a3,a3,0x1b
    8000115e:	4719                	li	a4,6
    80001160:	412686b3          	sub	a3,a3,s2
    80001164:	864a                	mv	a2,s2
    80001166:	85ca                	mv	a1,s2
    80001168:	8526                	mv	a0,s1
    8000116a:	f59ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000116e:	4729                	li	a4,10
    80001170:	6685                	lui	a3,0x1
    80001172:	00005617          	auipc	a2,0x5
    80001176:	e8e60613          	addi	a2,a2,-370 # 80006000 <_trampoline>
    8000117a:	040005b7          	lui	a1,0x4000
    8000117e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001180:	05b2                	slli	a1,a1,0xc
    80001182:	8526                	mv	a0,s1
    80001184:	f3fff0ef          	jal	800010c2 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001188:	8526                	mv	a0,s1
    8000118a:	5ee000ef          	jal	80001778 <proc_mapstacks>
}
    8000118e:	8526                	mv	a0,s1
    80001190:	60e2                	ld	ra,24(sp)
    80001192:	6442                	ld	s0,16(sp)
    80001194:	64a2                	ld	s1,8(sp)
    80001196:	6902                	ld	s2,0(sp)
    80001198:	6105                	addi	sp,sp,32
    8000119a:	8082                	ret

000000008000119c <kvminit>:
{
    8000119c:	1141                	addi	sp,sp,-16
    8000119e:	e406                	sd	ra,8(sp)
    800011a0:	e022                	sd	s0,0(sp)
    800011a2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011a4:	f47ff0ef          	jal	800010ea <kvmmake>
    800011a8:	00006797          	auipc	a5,0x6
    800011ac:	6aa7b823          	sd	a0,1712(a5) # 80007858 <kernel_pagetable>
}
    800011b0:	60a2                	ld	ra,8(sp)
    800011b2:	6402                	ld	s0,0(sp)
    800011b4:	0141                	addi	sp,sp,16
    800011b6:	8082                	ret

00000000800011b8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011b8:	1101                	addi	sp,sp,-32
    800011ba:	ec06                	sd	ra,24(sp)
    800011bc:	e822                	sd	s0,16(sp)
    800011be:	e426                	sd	s1,8(sp)
    800011c0:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800011c2:	93dff0ef          	jal	80000afe <kalloc>
    800011c6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800011c8:	c509                	beqz	a0,800011d2 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011ca:	6605                	lui	a2,0x1
    800011cc:	4581                	li	a1,0
    800011ce:	af9ff0ef          	jal	80000cc6 <memset>
  return pagetable;
}
    800011d2:	8526                	mv	a0,s1
    800011d4:	60e2                	ld	ra,24(sp)
    800011d6:	6442                	ld	s0,16(sp)
    800011d8:	64a2                	ld	s1,8(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret

00000000800011de <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011de:	7139                	addi	sp,sp,-64
    800011e0:	fc06                	sd	ra,56(sp)
    800011e2:	f822                	sd	s0,48(sp)
    800011e4:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011e6:	03459793          	slli	a5,a1,0x34
    800011ea:	e38d                	bnez	a5,8000120c <uvmunmap+0x2e>
    800011ec:	f04a                	sd	s2,32(sp)
    800011ee:	ec4e                	sd	s3,24(sp)
    800011f0:	e852                	sd	s4,16(sp)
    800011f2:	e456                	sd	s5,8(sp)
    800011f4:	e05a                	sd	s6,0(sp)
    800011f6:	8a2a                	mv	s4,a0
    800011f8:	892e                	mv	s2,a1
    800011fa:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011fc:	0632                	slli	a2,a2,0xc
    800011fe:	00b609b3          	add	s3,a2,a1
    80001202:	6b05                	lui	s6,0x1
    80001204:	0535f963          	bgeu	a1,s3,80001256 <uvmunmap+0x78>
    80001208:	f426                	sd	s1,40(sp)
    8000120a:	a015                	j	8000122e <uvmunmap+0x50>
    8000120c:	f426                	sd	s1,40(sp)
    8000120e:	f04a                	sd	s2,32(sp)
    80001210:	ec4e                	sd	s3,24(sp)
    80001212:	e852                	sd	s4,16(sp)
    80001214:	e456                	sd	s5,8(sp)
    80001216:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80001218:	00006517          	auipc	a0,0x6
    8000121c:	f0850513          	addi	a0,a0,-248 # 80007120 <etext+0x120>
    80001220:	dc0ff0ef          	jal	800007e0 <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001224:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001228:	995a                	add	s2,s2,s6
    8000122a:	03397563          	bgeu	s2,s3,80001254 <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    8000122e:	4601                	li	a2,0
    80001230:	85ca                	mv	a1,s2
    80001232:	8552                	mv	a0,s4
    80001234:	d07ff0ef          	jal	80000f3a <walk>
    80001238:	84aa                	mv	s1,a0
    8000123a:	d57d                	beqz	a0,80001228 <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    8000123c:	611c                	ld	a5,0(a0)
    8000123e:	0017f713          	andi	a4,a5,1
    80001242:	d37d                	beqz	a4,80001228 <uvmunmap+0x4a>
    if(do_free){
    80001244:	fe0a80e3          	beqz	s5,80001224 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001248:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    8000124a:	00c79513          	slli	a0,a5,0xc
    8000124e:	fceff0ef          	jal	80000a1c <kfree>
    80001252:	bfc9                	j	80001224 <uvmunmap+0x46>
    80001254:	74a2                	ld	s1,40(sp)
    80001256:	7902                	ld	s2,32(sp)
    80001258:	69e2                	ld	s3,24(sp)
    8000125a:	6a42                	ld	s4,16(sp)
    8000125c:	6aa2                	ld	s5,8(sp)
    8000125e:	6b02                	ld	s6,0(sp)
  }
}
    80001260:	70e2                	ld	ra,56(sp)
    80001262:	7442                	ld	s0,48(sp)
    80001264:	6121                	addi	sp,sp,64
    80001266:	8082                	ret

0000000080001268 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001268:	1101                	addi	sp,sp,-32
    8000126a:	ec06                	sd	ra,24(sp)
    8000126c:	e822                	sd	s0,16(sp)
    8000126e:	e426                	sd	s1,8(sp)
    80001270:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001272:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001274:	00b67d63          	bgeu	a2,a1,8000128e <uvmdealloc+0x26>
    80001278:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000127a:	6785                	lui	a5,0x1
    8000127c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000127e:	00f60733          	add	a4,a2,a5
    80001282:	76fd                	lui	a3,0xfffff
    80001284:	8f75                	and	a4,a4,a3
    80001286:	97ae                	add	a5,a5,a1
    80001288:	8ff5                	and	a5,a5,a3
    8000128a:	00f76863          	bltu	a4,a5,8000129a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000128e:	8526                	mv	a0,s1
    80001290:	60e2                	ld	ra,24(sp)
    80001292:	6442                	ld	s0,16(sp)
    80001294:	64a2                	ld	s1,8(sp)
    80001296:	6105                	addi	sp,sp,32
    80001298:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000129a:	8f99                	sub	a5,a5,a4
    8000129c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000129e:	4685                	li	a3,1
    800012a0:	0007861b          	sext.w	a2,a5
    800012a4:	85ba                	mv	a1,a4
    800012a6:	f39ff0ef          	jal	800011de <uvmunmap>
    800012aa:	b7d5                	j	8000128e <uvmdealloc+0x26>

00000000800012ac <uvmalloc>:
  if(newsz < oldsz)
    800012ac:	08b66f63          	bltu	a2,a1,8000134a <uvmalloc+0x9e>
{
    800012b0:	7139                	addi	sp,sp,-64
    800012b2:	fc06                	sd	ra,56(sp)
    800012b4:	f822                	sd	s0,48(sp)
    800012b6:	ec4e                	sd	s3,24(sp)
    800012b8:	e852                	sd	s4,16(sp)
    800012ba:	e456                	sd	s5,8(sp)
    800012bc:	0080                	addi	s0,sp,64
    800012be:	8aaa                	mv	s5,a0
    800012c0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012c2:	6785                	lui	a5,0x1
    800012c4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012c6:	95be                	add	a1,a1,a5
    800012c8:	77fd                	lui	a5,0xfffff
    800012ca:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800012ce:	08c9f063          	bgeu	s3,a2,8000134e <uvmalloc+0xa2>
    800012d2:	f426                	sd	s1,40(sp)
    800012d4:	f04a                	sd	s2,32(sp)
    800012d6:	e05a                	sd	s6,0(sp)
    800012d8:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800012da:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800012de:	821ff0ef          	jal	80000afe <kalloc>
    800012e2:	84aa                	mv	s1,a0
    if(mem == 0){
    800012e4:	c515                	beqz	a0,80001310 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800012e6:	6605                	lui	a2,0x1
    800012e8:	4581                	li	a1,0
    800012ea:	9ddff0ef          	jal	80000cc6 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800012ee:	875a                	mv	a4,s6
    800012f0:	86a6                	mv	a3,s1
    800012f2:	6605                	lui	a2,0x1
    800012f4:	85ca                	mv	a1,s2
    800012f6:	8556                	mv	a0,s5
    800012f8:	d1bff0ef          	jal	80001012 <mappages>
    800012fc:	e915                	bnez	a0,80001330 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800012fe:	6785                	lui	a5,0x1
    80001300:	993e                	add	s2,s2,a5
    80001302:	fd496ee3          	bltu	s2,s4,800012de <uvmalloc+0x32>
  return newsz;
    80001306:	8552                	mv	a0,s4
    80001308:	74a2                	ld	s1,40(sp)
    8000130a:	7902                	ld	s2,32(sp)
    8000130c:	6b02                	ld	s6,0(sp)
    8000130e:	a811                	j	80001322 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80001310:	864e                	mv	a2,s3
    80001312:	85ca                	mv	a1,s2
    80001314:	8556                	mv	a0,s5
    80001316:	f53ff0ef          	jal	80001268 <uvmdealloc>
      return 0;
    8000131a:	4501                	li	a0,0
    8000131c:	74a2                	ld	s1,40(sp)
    8000131e:	7902                	ld	s2,32(sp)
    80001320:	6b02                	ld	s6,0(sp)
}
    80001322:	70e2                	ld	ra,56(sp)
    80001324:	7442                	ld	s0,48(sp)
    80001326:	69e2                	ld	s3,24(sp)
    80001328:	6a42                	ld	s4,16(sp)
    8000132a:	6aa2                	ld	s5,8(sp)
    8000132c:	6121                	addi	sp,sp,64
    8000132e:	8082                	ret
      kfree(mem);
    80001330:	8526                	mv	a0,s1
    80001332:	eeaff0ef          	jal	80000a1c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001336:	864e                	mv	a2,s3
    80001338:	85ca                	mv	a1,s2
    8000133a:	8556                	mv	a0,s5
    8000133c:	f2dff0ef          	jal	80001268 <uvmdealloc>
      return 0;
    80001340:	4501                	li	a0,0
    80001342:	74a2                	ld	s1,40(sp)
    80001344:	7902                	ld	s2,32(sp)
    80001346:	6b02                	ld	s6,0(sp)
    80001348:	bfe9                	j	80001322 <uvmalloc+0x76>
    return oldsz;
    8000134a:	852e                	mv	a0,a1
}
    8000134c:	8082                	ret
  return newsz;
    8000134e:	8532                	mv	a0,a2
    80001350:	bfc9                	j	80001322 <uvmalloc+0x76>

0000000080001352 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001352:	7179                	addi	sp,sp,-48
    80001354:	f406                	sd	ra,40(sp)
    80001356:	f022                	sd	s0,32(sp)
    80001358:	ec26                	sd	s1,24(sp)
    8000135a:	e84a                	sd	s2,16(sp)
    8000135c:	e44e                	sd	s3,8(sp)
    8000135e:	e052                	sd	s4,0(sp)
    80001360:	1800                	addi	s0,sp,48
    80001362:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001364:	84aa                	mv	s1,a0
    80001366:	6905                	lui	s2,0x1
    80001368:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000136a:	4985                	li	s3,1
    8000136c:	a819                	j	80001382 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000136e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001370:	00c79513          	slli	a0,a5,0xc
    80001374:	fdfff0ef          	jal	80001352 <freewalk>
      pagetable[i] = 0;
    80001378:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000137c:	04a1                	addi	s1,s1,8
    8000137e:	01248f63          	beq	s1,s2,8000139c <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001382:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001384:	00f7f713          	andi	a4,a5,15
    80001388:	ff3703e3          	beq	a4,s3,8000136e <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000138c:	8b85                	andi	a5,a5,1
    8000138e:	d7fd                	beqz	a5,8000137c <freewalk+0x2a>
      panic("freewalk: leaf");
    80001390:	00006517          	auipc	a0,0x6
    80001394:	da850513          	addi	a0,a0,-600 # 80007138 <etext+0x138>
    80001398:	c48ff0ef          	jal	800007e0 <panic>
    }
  }
  kfree((void*)pagetable);
    8000139c:	8552                	mv	a0,s4
    8000139e:	e7eff0ef          	jal	80000a1c <kfree>
}
    800013a2:	70a2                	ld	ra,40(sp)
    800013a4:	7402                	ld	s0,32(sp)
    800013a6:	64e2                	ld	s1,24(sp)
    800013a8:	6942                	ld	s2,16(sp)
    800013aa:	69a2                	ld	s3,8(sp)
    800013ac:	6a02                	ld	s4,0(sp)
    800013ae:	6145                	addi	sp,sp,48
    800013b0:	8082                	ret

00000000800013b2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013b2:	1101                	addi	sp,sp,-32
    800013b4:	ec06                	sd	ra,24(sp)
    800013b6:	e822                	sd	s0,16(sp)
    800013b8:	e426                	sd	s1,8(sp)
    800013ba:	1000                	addi	s0,sp,32
    800013bc:	84aa                	mv	s1,a0
  if(sz > 0)
    800013be:	e989                	bnez	a1,800013d0 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800013c0:	8526                	mv	a0,s1
    800013c2:	f91ff0ef          	jal	80001352 <freewalk>
}
    800013c6:	60e2                	ld	ra,24(sp)
    800013c8:	6442                	ld	s0,16(sp)
    800013ca:	64a2                	ld	s1,8(sp)
    800013cc:	6105                	addi	sp,sp,32
    800013ce:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800013d0:	6785                	lui	a5,0x1
    800013d2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013d4:	95be                	add	a1,a1,a5
    800013d6:	4685                	li	a3,1
    800013d8:	00c5d613          	srli	a2,a1,0xc
    800013dc:	4581                	li	a1,0
    800013de:	e01ff0ef          	jal	800011de <uvmunmap>
    800013e2:	bff9                	j	800013c0 <uvmfree+0xe>

00000000800013e4 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800013e4:	ce49                	beqz	a2,8000147e <uvmcopy+0x9a>
{
    800013e6:	715d                	addi	sp,sp,-80
    800013e8:	e486                	sd	ra,72(sp)
    800013ea:	e0a2                	sd	s0,64(sp)
    800013ec:	fc26                	sd	s1,56(sp)
    800013ee:	f84a                	sd	s2,48(sp)
    800013f0:	f44e                	sd	s3,40(sp)
    800013f2:	f052                	sd	s4,32(sp)
    800013f4:	ec56                	sd	s5,24(sp)
    800013f6:	e85a                	sd	s6,16(sp)
    800013f8:	e45e                	sd	s7,8(sp)
    800013fa:	0880                	addi	s0,sp,80
    800013fc:	8aaa                	mv	s5,a0
    800013fe:	8b2e                	mv	s6,a1
    80001400:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001402:	4481                	li	s1,0
    80001404:	a029                	j	8000140e <uvmcopy+0x2a>
    80001406:	6785                	lui	a5,0x1
    80001408:	94be                	add	s1,s1,a5
    8000140a:	0544fe63          	bgeu	s1,s4,80001466 <uvmcopy+0x82>
    if((pte = walk(old, i, 0)) == 0)
    8000140e:	4601                	li	a2,0
    80001410:	85a6                	mv	a1,s1
    80001412:	8556                	mv	a0,s5
    80001414:	b27ff0ef          	jal	80000f3a <walk>
    80001418:	d57d                	beqz	a0,80001406 <uvmcopy+0x22>
      continue;   // page table entry hasn't been allocated
    if((*pte & PTE_V) == 0)
    8000141a:	6118                	ld	a4,0(a0)
    8000141c:	00177793          	andi	a5,a4,1
    80001420:	d3fd                	beqz	a5,80001406 <uvmcopy+0x22>
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    80001422:	00a75593          	srli	a1,a4,0xa
    80001426:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000142a:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    8000142e:	ed0ff0ef          	jal	80000afe <kalloc>
    80001432:	89aa                	mv	s3,a0
    80001434:	c105                	beqz	a0,80001454 <uvmcopy+0x70>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001436:	6605                	lui	a2,0x1
    80001438:	85de                	mv	a1,s7
    8000143a:	8e9ff0ef          	jal	80000d22 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000143e:	874a                	mv	a4,s2
    80001440:	86ce                	mv	a3,s3
    80001442:	6605                	lui	a2,0x1
    80001444:	85a6                	mv	a1,s1
    80001446:	855a                	mv	a0,s6
    80001448:	bcbff0ef          	jal	80001012 <mappages>
    8000144c:	dd4d                	beqz	a0,80001406 <uvmcopy+0x22>
      kfree(mem);
    8000144e:	854e                	mv	a0,s3
    80001450:	dccff0ef          	jal	80000a1c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001454:	4685                	li	a3,1
    80001456:	00c4d613          	srli	a2,s1,0xc
    8000145a:	4581                	li	a1,0
    8000145c:	855a                	mv	a0,s6
    8000145e:	d81ff0ef          	jal	800011de <uvmunmap>
  return -1;
    80001462:	557d                	li	a0,-1
    80001464:	a011                	j	80001468 <uvmcopy+0x84>
  return 0;
    80001466:	4501                	li	a0,0
}
    80001468:	60a6                	ld	ra,72(sp)
    8000146a:	6406                	ld	s0,64(sp)
    8000146c:	74e2                	ld	s1,56(sp)
    8000146e:	7942                	ld	s2,48(sp)
    80001470:	79a2                	ld	s3,40(sp)
    80001472:	7a02                	ld	s4,32(sp)
    80001474:	6ae2                	ld	s5,24(sp)
    80001476:	6b42                	ld	s6,16(sp)
    80001478:	6ba2                	ld	s7,8(sp)
    8000147a:	6161                	addi	sp,sp,80
    8000147c:	8082                	ret
  return 0;
    8000147e:	4501                	li	a0,0
}
    80001480:	8082                	ret

0000000080001482 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001482:	1141                	addi	sp,sp,-16
    80001484:	e406                	sd	ra,8(sp)
    80001486:	e022                	sd	s0,0(sp)
    80001488:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000148a:	4601                	li	a2,0
    8000148c:	aafff0ef          	jal	80000f3a <walk>
  if(pte == 0)
    80001490:	c901                	beqz	a0,800014a0 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001492:	611c                	ld	a5,0(a0)
    80001494:	9bbd                	andi	a5,a5,-17
    80001496:	e11c                	sd	a5,0(a0)
}
    80001498:	60a2                	ld	ra,8(sp)
    8000149a:	6402                	ld	s0,0(sp)
    8000149c:	0141                	addi	sp,sp,16
    8000149e:	8082                	ret
    panic("uvmclear");
    800014a0:	00006517          	auipc	a0,0x6
    800014a4:	ca850513          	addi	a0,a0,-856 # 80007148 <etext+0x148>
    800014a8:	b38ff0ef          	jal	800007e0 <panic>

00000000800014ac <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800014ac:	c6dd                	beqz	a3,8000155a <copyinstr+0xae>
{
    800014ae:	715d                	addi	sp,sp,-80
    800014b0:	e486                	sd	ra,72(sp)
    800014b2:	e0a2                	sd	s0,64(sp)
    800014b4:	fc26                	sd	s1,56(sp)
    800014b6:	f84a                	sd	s2,48(sp)
    800014b8:	f44e                	sd	s3,40(sp)
    800014ba:	f052                	sd	s4,32(sp)
    800014bc:	ec56                	sd	s5,24(sp)
    800014be:	e85a                	sd	s6,16(sp)
    800014c0:	e45e                	sd	s7,8(sp)
    800014c2:	0880                	addi	s0,sp,80
    800014c4:	8a2a                	mv	s4,a0
    800014c6:	8b2e                	mv	s6,a1
    800014c8:	8bb2                	mv	s7,a2
    800014ca:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800014cc:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800014ce:	6985                	lui	s3,0x1
    800014d0:	a825                	j	80001508 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800014d2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800014d6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800014d8:	37fd                	addiw	a5,a5,-1
    800014da:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800014de:	60a6                	ld	ra,72(sp)
    800014e0:	6406                	ld	s0,64(sp)
    800014e2:	74e2                	ld	s1,56(sp)
    800014e4:	7942                	ld	s2,48(sp)
    800014e6:	79a2                	ld	s3,40(sp)
    800014e8:	7a02                	ld	s4,32(sp)
    800014ea:	6ae2                	ld	s5,24(sp)
    800014ec:	6b42                	ld	s6,16(sp)
    800014ee:	6ba2                	ld	s7,8(sp)
    800014f0:	6161                	addi	sp,sp,80
    800014f2:	8082                	ret
    800014f4:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800014f8:	9742                	add	a4,a4,a6
      --max;
    800014fa:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    800014fe:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001502:	04e58463          	beq	a1,a4,8000154a <copyinstr+0x9e>
{
    80001506:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001508:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000150c:	85a6                	mv	a1,s1
    8000150e:	8552                	mv	a0,s4
    80001510:	ac5ff0ef          	jal	80000fd4 <walkaddr>
    if(pa0 == 0)
    80001514:	cd0d                	beqz	a0,8000154e <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001516:	417486b3          	sub	a3,s1,s7
    8000151a:	96ce                	add	a3,a3,s3
    if(n > max)
    8000151c:	00d97363          	bgeu	s2,a3,80001522 <copyinstr+0x76>
    80001520:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001522:	955e                	add	a0,a0,s7
    80001524:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001526:	c695                	beqz	a3,80001552 <copyinstr+0xa6>
    80001528:	87da                	mv	a5,s6
    8000152a:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000152c:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001530:	96da                	add	a3,a3,s6
    80001532:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001534:	00f60733          	add	a4,a2,a5
    80001538:	00074703          	lbu	a4,0(a4)
    8000153c:	db59                	beqz	a4,800014d2 <copyinstr+0x26>
        *dst = *p;
    8000153e:	00e78023          	sb	a4,0(a5)
      dst++;
    80001542:	0785                	addi	a5,a5,1
    while(n > 0){
    80001544:	fed797e3          	bne	a5,a3,80001532 <copyinstr+0x86>
    80001548:	b775                	j	800014f4 <copyinstr+0x48>
    8000154a:	4781                	li	a5,0
    8000154c:	b771                	j	800014d8 <copyinstr+0x2c>
      return -1;
    8000154e:	557d                	li	a0,-1
    80001550:	b779                	j	800014de <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001552:	6b85                	lui	s7,0x1
    80001554:	9ba6                	add	s7,s7,s1
    80001556:	87da                	mv	a5,s6
    80001558:	b77d                	j	80001506 <copyinstr+0x5a>
  int got_null = 0;
    8000155a:	4781                	li	a5,0
  if(got_null){
    8000155c:	37fd                	addiw	a5,a5,-1
    8000155e:	0007851b          	sext.w	a0,a5
}
    80001562:	8082                	ret

0000000080001564 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001564:	1141                	addi	sp,sp,-16
    80001566:	e406                	sd	ra,8(sp)
    80001568:	e022                	sd	s0,0(sp)
    8000156a:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    8000156c:	4601                	li	a2,0
    8000156e:	9cdff0ef          	jal	80000f3a <walk>
  if (pte == 0) {
    80001572:	c519                	beqz	a0,80001580 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    80001574:	6108                	ld	a0,0(a0)
    80001576:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80001578:	60a2                	ld	ra,8(sp)
    8000157a:	6402                	ld	s0,0(sp)
    8000157c:	0141                	addi	sp,sp,16
    8000157e:	8082                	ret
    return 0;
    80001580:	4501                	li	a0,0
    80001582:	bfdd                	j	80001578 <ismapped+0x14>

0000000080001584 <vmfault>:
{
    80001584:	7179                	addi	sp,sp,-48
    80001586:	f406                	sd	ra,40(sp)
    80001588:	f022                	sd	s0,32(sp)
    8000158a:	ec26                	sd	s1,24(sp)
    8000158c:	e44e                	sd	s3,8(sp)
    8000158e:	1800                	addi	s0,sp,48
    80001590:	89aa                	mv	s3,a0
    80001592:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80001594:	35e000ef          	jal	800018f2 <myproc>
  if (va >= p->sz)
    80001598:	653c                	ld	a5,72(a0)
    8000159a:	00f4ea63          	bltu	s1,a5,800015ae <vmfault+0x2a>
    return 0;
    8000159e:	4981                	li	s3,0
}
    800015a0:	854e                	mv	a0,s3
    800015a2:	70a2                	ld	ra,40(sp)
    800015a4:	7402                	ld	s0,32(sp)
    800015a6:	64e2                	ld	s1,24(sp)
    800015a8:	69a2                	ld	s3,8(sp)
    800015aa:	6145                	addi	sp,sp,48
    800015ac:	8082                	ret
    800015ae:	e84a                	sd	s2,16(sp)
    800015b0:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    800015b2:	77fd                	lui	a5,0xfffff
    800015b4:	8cfd                	and	s1,s1,a5
  if(ismapped(pagetable, va)) {
    800015b6:	85a6                	mv	a1,s1
    800015b8:	854e                	mv	a0,s3
    800015ba:	fabff0ef          	jal	80001564 <ismapped>
    return 0;
    800015be:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    800015c0:	c119                	beqz	a0,800015c6 <vmfault+0x42>
    800015c2:	6942                	ld	s2,16(sp)
    800015c4:	bff1                	j	800015a0 <vmfault+0x1c>
    800015c6:	e052                	sd	s4,0(sp)
  mem = (uint64) kalloc();
    800015c8:	d36ff0ef          	jal	80000afe <kalloc>
    800015cc:	8a2a                	mv	s4,a0
  if(mem == 0)
    800015ce:	c90d                	beqz	a0,80001600 <vmfault+0x7c>
  mem = (uint64) kalloc();
    800015d0:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    800015d2:	6605                	lui	a2,0x1
    800015d4:	4581                	li	a1,0
    800015d6:	ef0ff0ef          	jal	80000cc6 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    800015da:	4759                	li	a4,22
    800015dc:	86d2                	mv	a3,s4
    800015de:	6605                	lui	a2,0x1
    800015e0:	85a6                	mv	a1,s1
    800015e2:	05093503          	ld	a0,80(s2)
    800015e6:	a2dff0ef          	jal	80001012 <mappages>
    800015ea:	e501                	bnez	a0,800015f2 <vmfault+0x6e>
    800015ec:	6942                	ld	s2,16(sp)
    800015ee:	6a02                	ld	s4,0(sp)
    800015f0:	bf45                	j	800015a0 <vmfault+0x1c>
    kfree((void *)mem);
    800015f2:	8552                	mv	a0,s4
    800015f4:	c28ff0ef          	jal	80000a1c <kfree>
    return 0;
    800015f8:	4981                	li	s3,0
    800015fa:	6942                	ld	s2,16(sp)
    800015fc:	6a02                	ld	s4,0(sp)
    800015fe:	b74d                	j	800015a0 <vmfault+0x1c>
    80001600:	6942                	ld	s2,16(sp)
    80001602:	6a02                	ld	s4,0(sp)
    80001604:	bf71                	j	800015a0 <vmfault+0x1c>

0000000080001606 <copyout>:
  while(len > 0){
    80001606:	c2cd                	beqz	a3,800016a8 <copyout+0xa2>
{
    80001608:	711d                	addi	sp,sp,-96
    8000160a:	ec86                	sd	ra,88(sp)
    8000160c:	e8a2                	sd	s0,80(sp)
    8000160e:	e4a6                	sd	s1,72(sp)
    80001610:	f852                	sd	s4,48(sp)
    80001612:	f05a                	sd	s6,32(sp)
    80001614:	ec5e                	sd	s7,24(sp)
    80001616:	e862                	sd	s8,16(sp)
    80001618:	1080                	addi	s0,sp,96
    8000161a:	8c2a                	mv	s8,a0
    8000161c:	8b2e                	mv	s6,a1
    8000161e:	8bb2                	mv	s7,a2
    80001620:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80001622:	74fd                	lui	s1,0xfffff
    80001624:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001626:	57fd                	li	a5,-1
    80001628:	83e9                	srli	a5,a5,0x1a
    8000162a:	0897e163          	bltu	a5,s1,800016ac <copyout+0xa6>
    8000162e:	e0ca                	sd	s2,64(sp)
    80001630:	fc4e                	sd	s3,56(sp)
    80001632:	f456                	sd	s5,40(sp)
    80001634:	e466                	sd	s9,8(sp)
    80001636:	e06a                	sd	s10,0(sp)
    80001638:	6d05                	lui	s10,0x1
    8000163a:	8cbe                	mv	s9,a5
    8000163c:	a015                	j	80001660 <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000163e:	409b0533          	sub	a0,s6,s1
    80001642:	0009861b          	sext.w	a2,s3
    80001646:	85de                	mv	a1,s7
    80001648:	954a                	add	a0,a0,s2
    8000164a:	ed8ff0ef          	jal	80000d22 <memmove>
    len -= n;
    8000164e:	413a0a33          	sub	s4,s4,s3
    src += n;
    80001652:	9bce                	add	s7,s7,s3
  while(len > 0){
    80001654:	040a0363          	beqz	s4,8000169a <copyout+0x94>
    if(va0 >= MAXVA)
    80001658:	055cec63          	bltu	s9,s5,800016b0 <copyout+0xaa>
    8000165c:	84d6                	mv	s1,s5
    8000165e:	8b56                	mv	s6,s5
    pa0 = walkaddr(pagetable, va0);
    80001660:	85a6                	mv	a1,s1
    80001662:	8562                	mv	a0,s8
    80001664:	971ff0ef          	jal	80000fd4 <walkaddr>
    80001668:	892a                	mv	s2,a0
    if(pa0 == 0) {
    8000166a:	e901                	bnez	a0,8000167a <copyout+0x74>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    8000166c:	4601                	li	a2,0
    8000166e:	85a6                	mv	a1,s1
    80001670:	8562                	mv	a0,s8
    80001672:	f13ff0ef          	jal	80001584 <vmfault>
    80001676:	892a                	mv	s2,a0
    80001678:	c139                	beqz	a0,800016be <copyout+0xb8>
    pte = walk(pagetable, va0, 0);
    8000167a:	4601                	li	a2,0
    8000167c:	85a6                	mv	a1,s1
    8000167e:	8562                	mv	a0,s8
    80001680:	8bbff0ef          	jal	80000f3a <walk>
    if((*pte & PTE_W) == 0)
    80001684:	611c                	ld	a5,0(a0)
    80001686:	8b91                	andi	a5,a5,4
    80001688:	c3b1                	beqz	a5,800016cc <copyout+0xc6>
    n = PGSIZE - (dstva - va0);
    8000168a:	01a48ab3          	add	s5,s1,s10
    8000168e:	416a89b3          	sub	s3,s5,s6
    if(n > len)
    80001692:	fb3a76e3          	bgeu	s4,s3,8000163e <copyout+0x38>
    80001696:	89d2                	mv	s3,s4
    80001698:	b75d                	j	8000163e <copyout+0x38>
  return 0;
    8000169a:	4501                	li	a0,0
    8000169c:	6906                	ld	s2,64(sp)
    8000169e:	79e2                	ld	s3,56(sp)
    800016a0:	7aa2                	ld	s5,40(sp)
    800016a2:	6ca2                	ld	s9,8(sp)
    800016a4:	6d02                	ld	s10,0(sp)
    800016a6:	a80d                	j	800016d8 <copyout+0xd2>
    800016a8:	4501                	li	a0,0
}
    800016aa:	8082                	ret
      return -1;
    800016ac:	557d                	li	a0,-1
    800016ae:	a02d                	j	800016d8 <copyout+0xd2>
    800016b0:	557d                	li	a0,-1
    800016b2:	6906                	ld	s2,64(sp)
    800016b4:	79e2                	ld	s3,56(sp)
    800016b6:	7aa2                	ld	s5,40(sp)
    800016b8:	6ca2                	ld	s9,8(sp)
    800016ba:	6d02                	ld	s10,0(sp)
    800016bc:	a831                	j	800016d8 <copyout+0xd2>
        return -1;
    800016be:	557d                	li	a0,-1
    800016c0:	6906                	ld	s2,64(sp)
    800016c2:	79e2                	ld	s3,56(sp)
    800016c4:	7aa2                	ld	s5,40(sp)
    800016c6:	6ca2                	ld	s9,8(sp)
    800016c8:	6d02                	ld	s10,0(sp)
    800016ca:	a039                	j	800016d8 <copyout+0xd2>
      return -1;
    800016cc:	557d                	li	a0,-1
    800016ce:	6906                	ld	s2,64(sp)
    800016d0:	79e2                	ld	s3,56(sp)
    800016d2:	7aa2                	ld	s5,40(sp)
    800016d4:	6ca2                	ld	s9,8(sp)
    800016d6:	6d02                	ld	s10,0(sp)
}
    800016d8:	60e6                	ld	ra,88(sp)
    800016da:	6446                	ld	s0,80(sp)
    800016dc:	64a6                	ld	s1,72(sp)
    800016de:	7a42                	ld	s4,48(sp)
    800016e0:	7b02                	ld	s6,32(sp)
    800016e2:	6be2                	ld	s7,24(sp)
    800016e4:	6c42                	ld	s8,16(sp)
    800016e6:	6125                	addi	sp,sp,96
    800016e8:	8082                	ret

00000000800016ea <copyin>:
  while(len > 0){
    800016ea:	c6c9                	beqz	a3,80001774 <copyin+0x8a>
{
    800016ec:	715d                	addi	sp,sp,-80
    800016ee:	e486                	sd	ra,72(sp)
    800016f0:	e0a2                	sd	s0,64(sp)
    800016f2:	fc26                	sd	s1,56(sp)
    800016f4:	f84a                	sd	s2,48(sp)
    800016f6:	f44e                	sd	s3,40(sp)
    800016f8:	f052                	sd	s4,32(sp)
    800016fa:	ec56                	sd	s5,24(sp)
    800016fc:	e85a                	sd	s6,16(sp)
    800016fe:	e45e                	sd	s7,8(sp)
    80001700:	e062                	sd	s8,0(sp)
    80001702:	0880                	addi	s0,sp,80
    80001704:	8baa                	mv	s7,a0
    80001706:	8aae                	mv	s5,a1
    80001708:	8932                	mv	s2,a2
    8000170a:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    8000170c:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    8000170e:	6b05                	lui	s6,0x1
    80001710:	a035                	j	8000173c <copyin+0x52>
    80001712:	412984b3          	sub	s1,s3,s2
    80001716:	94da                	add	s1,s1,s6
    if(n > len)
    80001718:	009a7363          	bgeu	s4,s1,8000171e <copyin+0x34>
    8000171c:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000171e:	413905b3          	sub	a1,s2,s3
    80001722:	0004861b          	sext.w	a2,s1
    80001726:	95aa                	add	a1,a1,a0
    80001728:	8556                	mv	a0,s5
    8000172a:	df8ff0ef          	jal	80000d22 <memmove>
    len -= n;
    8000172e:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80001732:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80001734:	01698933          	add	s2,s3,s6
  while(len > 0){
    80001738:	020a0163          	beqz	s4,8000175a <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    8000173c:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80001740:	85ce                	mv	a1,s3
    80001742:	855e                	mv	a0,s7
    80001744:	891ff0ef          	jal	80000fd4 <walkaddr>
    if(pa0 == 0) {
    80001748:	f569                	bnez	a0,80001712 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    8000174a:	4601                	li	a2,0
    8000174c:	85ce                	mv	a1,s3
    8000174e:	855e                	mv	a0,s7
    80001750:	e35ff0ef          	jal	80001584 <vmfault>
    80001754:	fd5d                	bnez	a0,80001712 <copyin+0x28>
        return -1;
    80001756:	557d                	li	a0,-1
    80001758:	a011                	j	8000175c <copyin+0x72>
  return 0;
    8000175a:	4501                	li	a0,0
}
    8000175c:	60a6                	ld	ra,72(sp)
    8000175e:	6406                	ld	s0,64(sp)
    80001760:	74e2                	ld	s1,56(sp)
    80001762:	7942                	ld	s2,48(sp)
    80001764:	79a2                	ld	s3,40(sp)
    80001766:	7a02                	ld	s4,32(sp)
    80001768:	6ae2                	ld	s5,24(sp)
    8000176a:	6b42                	ld	s6,16(sp)
    8000176c:	6ba2                	ld	s7,8(sp)
    8000176e:	6c02                	ld	s8,0(sp)
    80001770:	6161                	addi	sp,sp,80
    80001772:	8082                	ret
  return 0;
    80001774:	4501                	li	a0,0
}
    80001776:	8082                	ret

0000000080001778 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001778:	7139                	addi	sp,sp,-64
    8000177a:	fc06                	sd	ra,56(sp)
    8000177c:	f822                	sd	s0,48(sp)
    8000177e:	f426                	sd	s1,40(sp)
    80001780:	f04a                	sd	s2,32(sp)
    80001782:	ec4e                	sd	s3,24(sp)
    80001784:	e852                	sd	s4,16(sp)
    80001786:	e456                	sd	s5,8(sp)
    80001788:	e05a                	sd	s6,0(sp)
    8000178a:	0080                	addi	s0,sp,64
    8000178c:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000178e:	0000e497          	auipc	s1,0xe
    80001792:	60a48493          	addi	s1,s1,1546 # 8000fd98 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001796:	8b26                	mv	s6,s1
    80001798:	04fa5937          	lui	s2,0x4fa5
    8000179c:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    800017a0:	0932                	slli	s2,s2,0xc
    800017a2:	fa590913          	addi	s2,s2,-91
    800017a6:	0932                	slli	s2,s2,0xc
    800017a8:	fa590913          	addi	s2,s2,-91
    800017ac:	0932                	slli	s2,s2,0xc
    800017ae:	fa590913          	addi	s2,s2,-91
    800017b2:	040009b7          	lui	s3,0x4000
    800017b6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017b8:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ba:	00014a97          	auipc	s5,0x14
    800017be:	fdea8a93          	addi	s5,s5,-34 # 80015798 <tickslock>
    char *pa = kalloc();
    800017c2:	b3cff0ef          	jal	80000afe <kalloc>
    800017c6:	862a                	mv	a2,a0
    if(pa == 0)
    800017c8:	cd15                	beqz	a0,80001804 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017ca:	416485b3          	sub	a1,s1,s6
    800017ce:	858d                	srai	a1,a1,0x3
    800017d0:	032585b3          	mul	a1,a1,s2
    800017d4:	2585                	addiw	a1,a1,1
    800017d6:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017da:	4719                	li	a4,6
    800017dc:	6685                	lui	a3,0x1
    800017de:	40b985b3          	sub	a1,s3,a1
    800017e2:	8552                	mv	a0,s4
    800017e4:	8dfff0ef          	jal	800010c2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e8:	16848493          	addi	s1,s1,360
    800017ec:	fd549be3          	bne	s1,s5,800017c2 <proc_mapstacks+0x4a>
  }
}
    800017f0:	70e2                	ld	ra,56(sp)
    800017f2:	7442                	ld	s0,48(sp)
    800017f4:	74a2                	ld	s1,40(sp)
    800017f6:	7902                	ld	s2,32(sp)
    800017f8:	69e2                	ld	s3,24(sp)
    800017fa:	6a42                	ld	s4,16(sp)
    800017fc:	6aa2                	ld	s5,8(sp)
    800017fe:	6b02                	ld	s6,0(sp)
    80001800:	6121                	addi	sp,sp,64
    80001802:	8082                	ret
      panic("kalloc");
    80001804:	00006517          	auipc	a0,0x6
    80001808:	95450513          	addi	a0,a0,-1708 # 80007158 <etext+0x158>
    8000180c:	fd5fe0ef          	jal	800007e0 <panic>

0000000080001810 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001810:	7139                	addi	sp,sp,-64
    80001812:	fc06                	sd	ra,56(sp)
    80001814:	f822                	sd	s0,48(sp)
    80001816:	f426                	sd	s1,40(sp)
    80001818:	f04a                	sd	s2,32(sp)
    8000181a:	ec4e                	sd	s3,24(sp)
    8000181c:	e852                	sd	s4,16(sp)
    8000181e:	e456                	sd	s5,8(sp)
    80001820:	e05a                	sd	s6,0(sp)
    80001822:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001824:	00006597          	auipc	a1,0x6
    80001828:	93c58593          	addi	a1,a1,-1732 # 80007160 <etext+0x160>
    8000182c:	0000e517          	auipc	a0,0xe
    80001830:	13c50513          	addi	a0,a0,316 # 8000f968 <pid_lock>
    80001834:	b3eff0ef          	jal	80000b72 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001838:	00006597          	auipc	a1,0x6
    8000183c:	93058593          	addi	a1,a1,-1744 # 80007168 <etext+0x168>
    80001840:	0000e517          	auipc	a0,0xe
    80001844:	14050513          	addi	a0,a0,320 # 8000f980 <wait_lock>
    80001848:	b2aff0ef          	jal	80000b72 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000184c:	0000e497          	auipc	s1,0xe
    80001850:	54c48493          	addi	s1,s1,1356 # 8000fd98 <proc>
      initlock(&p->lock, "proc");
    80001854:	00006b17          	auipc	s6,0x6
    80001858:	924b0b13          	addi	s6,s6,-1756 # 80007178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000185c:	8aa6                	mv	s5,s1
    8000185e:	04fa5937          	lui	s2,0x4fa5
    80001862:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001866:	0932                	slli	s2,s2,0xc
    80001868:	fa590913          	addi	s2,s2,-91
    8000186c:	0932                	slli	s2,s2,0xc
    8000186e:	fa590913          	addi	s2,s2,-91
    80001872:	0932                	slli	s2,s2,0xc
    80001874:	fa590913          	addi	s2,s2,-91
    80001878:	040009b7          	lui	s3,0x4000
    8000187c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000187e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001880:	00014a17          	auipc	s4,0x14
    80001884:	f18a0a13          	addi	s4,s4,-232 # 80015798 <tickslock>
      initlock(&p->lock, "proc");
    80001888:	85da                	mv	a1,s6
    8000188a:	8526                	mv	a0,s1
    8000188c:	ae6ff0ef          	jal	80000b72 <initlock>
      p->state = UNUSED;
    80001890:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001894:	415487b3          	sub	a5,s1,s5
    80001898:	878d                	srai	a5,a5,0x3
    8000189a:	032787b3          	mul	a5,a5,s2
    8000189e:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffde489>
    800018a0:	00d7979b          	slliw	a5,a5,0xd
    800018a4:	40f987b3          	sub	a5,s3,a5
    800018a8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018aa:	16848493          	addi	s1,s1,360
    800018ae:	fd449de3          	bne	s1,s4,80001888 <procinit+0x78>
  }
}
    800018b2:	70e2                	ld	ra,56(sp)
    800018b4:	7442                	ld	s0,48(sp)
    800018b6:	74a2                	ld	s1,40(sp)
    800018b8:	7902                	ld	s2,32(sp)
    800018ba:	69e2                	ld	s3,24(sp)
    800018bc:	6a42                	ld	s4,16(sp)
    800018be:	6aa2                	ld	s5,8(sp)
    800018c0:	6b02                	ld	s6,0(sp)
    800018c2:	6121                	addi	sp,sp,64
    800018c4:	8082                	ret

00000000800018c6 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018c6:	1141                	addi	sp,sp,-16
    800018c8:	e422                	sd	s0,8(sp)
    800018ca:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018cc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018ce:	2501                	sext.w	a0,a0
    800018d0:	6422                	ld	s0,8(sp)
    800018d2:	0141                	addi	sp,sp,16
    800018d4:	8082                	ret

00000000800018d6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018d6:	1141                	addi	sp,sp,-16
    800018d8:	e422                	sd	s0,8(sp)
    800018da:	0800                	addi	s0,sp,16
    800018dc:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018de:	2781                	sext.w	a5,a5
    800018e0:	079e                	slli	a5,a5,0x7
  return c;
}
    800018e2:	0000e517          	auipc	a0,0xe
    800018e6:	0b650513          	addi	a0,a0,182 # 8000f998 <cpus>
    800018ea:	953e                	add	a0,a0,a5
    800018ec:	6422                	ld	s0,8(sp)
    800018ee:	0141                	addi	sp,sp,16
    800018f0:	8082                	ret

00000000800018f2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800018f2:	1101                	addi	sp,sp,-32
    800018f4:	ec06                	sd	ra,24(sp)
    800018f6:	e822                	sd	s0,16(sp)
    800018f8:	e426                	sd	s1,8(sp)
    800018fa:	1000                	addi	s0,sp,32
  push_off();
    800018fc:	ab6ff0ef          	jal	80000bb2 <push_off>
    80001900:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001902:	2781                	sext.w	a5,a5
    80001904:	079e                	slli	a5,a5,0x7
    80001906:	0000e717          	auipc	a4,0xe
    8000190a:	06270713          	addi	a4,a4,98 # 8000f968 <pid_lock>
    8000190e:	97ba                	add	a5,a5,a4
    80001910:	7b84                	ld	s1,48(a5)
  pop_off();
    80001912:	b24ff0ef          	jal	80000c36 <pop_off>
  return p;
}
    80001916:	8526                	mv	a0,s1
    80001918:	60e2                	ld	ra,24(sp)
    8000191a:	6442                	ld	s0,16(sp)
    8000191c:	64a2                	ld	s1,8(sp)
    8000191e:	6105                	addi	sp,sp,32
    80001920:	8082                	ret

0000000080001922 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001922:	7179                	addi	sp,sp,-48
    80001924:	f406                	sd	ra,40(sp)
    80001926:	f022                	sd	s0,32(sp)
    80001928:	ec26                	sd	s1,24(sp)
    8000192a:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000192c:	fc7ff0ef          	jal	800018f2 <myproc>
    80001930:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001932:	b58ff0ef          	jal	80000c8a <release>

  if (first) {
    80001936:	00006797          	auipc	a5,0x6
    8000193a:	efa7a783          	lw	a5,-262(a5) # 80007830 <first.1>
    8000193e:	cf8d                	beqz	a5,80001978 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001940:	4505                	li	a0,1
    80001942:	3cd010ef          	jal	8000350e <fsinit>

    first = 0;
    80001946:	00006797          	auipc	a5,0x6
    8000194a:	ee07a523          	sw	zero,-278(a5) # 80007830 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    8000194e:	0ff0000f          	fence

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80001952:	00006517          	auipc	a0,0x6
    80001956:	82e50513          	addi	a0,a0,-2002 # 80007180 <etext+0x180>
    8000195a:	fca43823          	sd	a0,-48(s0)
    8000195e:	fc043c23          	sd	zero,-40(s0)
    80001962:	fd040593          	addi	a1,s0,-48
    80001966:	4b3020ef          	jal	80004618 <kexec>
    8000196a:	6cbc                	ld	a5,88(s1)
    8000196c:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    8000196e:	6cbc                	ld	a5,88(s1)
    80001970:	7bb8                	ld	a4,112(a5)
    80001972:	57fd                	li	a5,-1
    80001974:	02f70d63          	beq	a4,a5,800019ae <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001978:	2bf000ef          	jal	80002436 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000197c:	68a8                	ld	a0,80(s1)
    8000197e:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001980:	04000737          	lui	a4,0x4000
    80001984:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001986:	0732                	slli	a4,a4,0xc
    80001988:	00004797          	auipc	a5,0x4
    8000198c:	71478793          	addi	a5,a5,1812 # 8000609c <userret>
    80001990:	00004697          	auipc	a3,0x4
    80001994:	67068693          	addi	a3,a3,1648 # 80006000 <_trampoline>
    80001998:	8f95                	sub	a5,a5,a3
    8000199a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000199c:	577d                	li	a4,-1
    8000199e:	177e                	slli	a4,a4,0x3f
    800019a0:	8d59                	or	a0,a0,a4
    800019a2:	9782                	jalr	a5
}
    800019a4:	70a2                	ld	ra,40(sp)
    800019a6:	7402                	ld	s0,32(sp)
    800019a8:	64e2                	ld	s1,24(sp)
    800019aa:	6145                	addi	sp,sp,48
    800019ac:	8082                	ret
      panic("exec");
    800019ae:	00005517          	auipc	a0,0x5
    800019b2:	7da50513          	addi	a0,a0,2010 # 80007188 <etext+0x188>
    800019b6:	e2bfe0ef          	jal	800007e0 <panic>

00000000800019ba <allocpid>:
{
    800019ba:	1101                	addi	sp,sp,-32
    800019bc:	ec06                	sd	ra,24(sp)
    800019be:	e822                	sd	s0,16(sp)
    800019c0:	e426                	sd	s1,8(sp)
    800019c2:	e04a                	sd	s2,0(sp)
    800019c4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019c6:	0000e917          	auipc	s2,0xe
    800019ca:	fa290913          	addi	s2,s2,-94 # 8000f968 <pid_lock>
    800019ce:	854a                	mv	a0,s2
    800019d0:	a22ff0ef          	jal	80000bf2 <acquire>
  pid = nextpid;
    800019d4:	00006797          	auipc	a5,0x6
    800019d8:	e6078793          	addi	a5,a5,-416 # 80007834 <nextpid>
    800019dc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019de:	0014871b          	addiw	a4,s1,1
    800019e2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019e4:	854a                	mv	a0,s2
    800019e6:	aa4ff0ef          	jal	80000c8a <release>
}
    800019ea:	8526                	mv	a0,s1
    800019ec:	60e2                	ld	ra,24(sp)
    800019ee:	6442                	ld	s0,16(sp)
    800019f0:	64a2                	ld	s1,8(sp)
    800019f2:	6902                	ld	s2,0(sp)
    800019f4:	6105                	addi	sp,sp,32
    800019f6:	8082                	ret

00000000800019f8 <proc_pagetable>:
{
    800019f8:	1101                	addi	sp,sp,-32
    800019fa:	ec06                	sd	ra,24(sp)
    800019fc:	e822                	sd	s0,16(sp)
    800019fe:	e426                	sd	s1,8(sp)
    80001a00:	e04a                	sd	s2,0(sp)
    80001a02:	1000                	addi	s0,sp,32
    80001a04:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a06:	fb2ff0ef          	jal	800011b8 <uvmcreate>
    80001a0a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a0c:	cd05                	beqz	a0,80001a44 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a0e:	4729                	li	a4,10
    80001a10:	00004697          	auipc	a3,0x4
    80001a14:	5f068693          	addi	a3,a3,1520 # 80006000 <_trampoline>
    80001a18:	6605                	lui	a2,0x1
    80001a1a:	040005b7          	lui	a1,0x4000
    80001a1e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a20:	05b2                	slli	a1,a1,0xc
    80001a22:	df0ff0ef          	jal	80001012 <mappages>
    80001a26:	02054663          	bltz	a0,80001a52 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a2a:	4719                	li	a4,6
    80001a2c:	05893683          	ld	a3,88(s2)
    80001a30:	6605                	lui	a2,0x1
    80001a32:	020005b7          	lui	a1,0x2000
    80001a36:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a38:	05b6                	slli	a1,a1,0xd
    80001a3a:	8526                	mv	a0,s1
    80001a3c:	dd6ff0ef          	jal	80001012 <mappages>
    80001a40:	00054f63          	bltz	a0,80001a5e <proc_pagetable+0x66>
}
    80001a44:	8526                	mv	a0,s1
    80001a46:	60e2                	ld	ra,24(sp)
    80001a48:	6442                	ld	s0,16(sp)
    80001a4a:	64a2                	ld	s1,8(sp)
    80001a4c:	6902                	ld	s2,0(sp)
    80001a4e:	6105                	addi	sp,sp,32
    80001a50:	8082                	ret
    uvmfree(pagetable, 0);
    80001a52:	4581                	li	a1,0
    80001a54:	8526                	mv	a0,s1
    80001a56:	95dff0ef          	jal	800013b2 <uvmfree>
    return 0;
    80001a5a:	4481                	li	s1,0
    80001a5c:	b7e5                	j	80001a44 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a5e:	4681                	li	a3,0
    80001a60:	4605                	li	a2,1
    80001a62:	040005b7          	lui	a1,0x4000
    80001a66:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a68:	05b2                	slli	a1,a1,0xc
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	f72ff0ef          	jal	800011de <uvmunmap>
    uvmfree(pagetable, 0);
    80001a70:	4581                	li	a1,0
    80001a72:	8526                	mv	a0,s1
    80001a74:	93fff0ef          	jal	800013b2 <uvmfree>
    return 0;
    80001a78:	4481                	li	s1,0
    80001a7a:	b7e9                	j	80001a44 <proc_pagetable+0x4c>

0000000080001a7c <proc_freepagetable>:
{
    80001a7c:	1101                	addi	sp,sp,-32
    80001a7e:	ec06                	sd	ra,24(sp)
    80001a80:	e822                	sd	s0,16(sp)
    80001a82:	e426                	sd	s1,8(sp)
    80001a84:	e04a                	sd	s2,0(sp)
    80001a86:	1000                	addi	s0,sp,32
    80001a88:	84aa                	mv	s1,a0
    80001a8a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a8c:	4681                	li	a3,0
    80001a8e:	4605                	li	a2,1
    80001a90:	040005b7          	lui	a1,0x4000
    80001a94:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a96:	05b2                	slli	a1,a1,0xc
    80001a98:	f46ff0ef          	jal	800011de <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a9c:	4681                	li	a3,0
    80001a9e:	4605                	li	a2,1
    80001aa0:	020005b7          	lui	a1,0x2000
    80001aa4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001aa6:	05b6                	slli	a1,a1,0xd
    80001aa8:	8526                	mv	a0,s1
    80001aaa:	f34ff0ef          	jal	800011de <uvmunmap>
  uvmfree(pagetable, sz);
    80001aae:	85ca                	mv	a1,s2
    80001ab0:	8526                	mv	a0,s1
    80001ab2:	901ff0ef          	jal	800013b2 <uvmfree>
}
    80001ab6:	60e2                	ld	ra,24(sp)
    80001ab8:	6442                	ld	s0,16(sp)
    80001aba:	64a2                	ld	s1,8(sp)
    80001abc:	6902                	ld	s2,0(sp)
    80001abe:	6105                	addi	sp,sp,32
    80001ac0:	8082                	ret

0000000080001ac2 <freeproc>:
{
    80001ac2:	1101                	addi	sp,sp,-32
    80001ac4:	ec06                	sd	ra,24(sp)
    80001ac6:	e822                	sd	s0,16(sp)
    80001ac8:	e426                	sd	s1,8(sp)
    80001aca:	1000                	addi	s0,sp,32
    80001acc:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001ace:	6d28                	ld	a0,88(a0)
    80001ad0:	c119                	beqz	a0,80001ad6 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001ad2:	f4bfe0ef          	jal	80000a1c <kfree>
  p->trapframe = 0;
    80001ad6:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001ada:	68a8                	ld	a0,80(s1)
    80001adc:	c501                	beqz	a0,80001ae4 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001ade:	64ac                	ld	a1,72(s1)
    80001ae0:	f9dff0ef          	jal	80001a7c <proc_freepagetable>
  p->pagetable = 0;
    80001ae4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001ae8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001aec:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001af0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001af4:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001af8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001afc:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b00:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b04:	0004ac23          	sw	zero,24(s1)
}
    80001b08:	60e2                	ld	ra,24(sp)
    80001b0a:	6442                	ld	s0,16(sp)
    80001b0c:	64a2                	ld	s1,8(sp)
    80001b0e:	6105                	addi	sp,sp,32
    80001b10:	8082                	ret

0000000080001b12 <allocproc>:
{
    80001b12:	1101                	addi	sp,sp,-32
    80001b14:	ec06                	sd	ra,24(sp)
    80001b16:	e822                	sd	s0,16(sp)
    80001b18:	e426                	sd	s1,8(sp)
    80001b1a:	e04a                	sd	s2,0(sp)
    80001b1c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b1e:	0000e497          	auipc	s1,0xe
    80001b22:	27a48493          	addi	s1,s1,634 # 8000fd98 <proc>
    80001b26:	00014917          	auipc	s2,0x14
    80001b2a:	c7290913          	addi	s2,s2,-910 # 80015798 <tickslock>
    acquire(&p->lock);
    80001b2e:	8526                	mv	a0,s1
    80001b30:	8c2ff0ef          	jal	80000bf2 <acquire>
    if(p->state == UNUSED) {
    80001b34:	4c9c                	lw	a5,24(s1)
    80001b36:	cb91                	beqz	a5,80001b4a <allocproc+0x38>
      release(&p->lock);
    80001b38:	8526                	mv	a0,s1
    80001b3a:	950ff0ef          	jal	80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b3e:	16848493          	addi	s1,s1,360
    80001b42:	ff2496e3          	bne	s1,s2,80001b2e <allocproc+0x1c>
  return 0;
    80001b46:	4481                	li	s1,0
    80001b48:	a089                	j	80001b8a <allocproc+0x78>
  p->pid = allocpid();
    80001b4a:	e71ff0ef          	jal	800019ba <allocpid>
    80001b4e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b50:	4785                	li	a5,1
    80001b52:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001b54:	fabfe0ef          	jal	80000afe <kalloc>
    80001b58:	892a                	mv	s2,a0
    80001b5a:	eca8                	sd	a0,88(s1)
    80001b5c:	cd15                	beqz	a0,80001b98 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b5e:	8526                	mv	a0,s1
    80001b60:	e99ff0ef          	jal	800019f8 <proc_pagetable>
    80001b64:	892a                	mv	s2,a0
    80001b66:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001b68:	c121                	beqz	a0,80001ba8 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b6a:	07000613          	li	a2,112
    80001b6e:	4581                	li	a1,0
    80001b70:	06048513          	addi	a0,s1,96
    80001b74:	952ff0ef          	jal	80000cc6 <memset>
  p->context.ra = (uint64)forkret;
    80001b78:	00000797          	auipc	a5,0x0
    80001b7c:	daa78793          	addi	a5,a5,-598 # 80001922 <forkret>
    80001b80:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b82:	60bc                	ld	a5,64(s1)
    80001b84:	6705                	lui	a4,0x1
    80001b86:	97ba                	add	a5,a5,a4
    80001b88:	f4bc                	sd	a5,104(s1)
}
    80001b8a:	8526                	mv	a0,s1
    80001b8c:	60e2                	ld	ra,24(sp)
    80001b8e:	6442                	ld	s0,16(sp)
    80001b90:	64a2                	ld	s1,8(sp)
    80001b92:	6902                	ld	s2,0(sp)
    80001b94:	6105                	addi	sp,sp,32
    80001b96:	8082                	ret
    freeproc(p);
    80001b98:	8526                	mv	a0,s1
    80001b9a:	f29ff0ef          	jal	80001ac2 <freeproc>
    release(&p->lock);
    80001b9e:	8526                	mv	a0,s1
    80001ba0:	8eaff0ef          	jal	80000c8a <release>
    return 0;
    80001ba4:	84ca                	mv	s1,s2
    80001ba6:	b7d5                	j	80001b8a <allocproc+0x78>
    freeproc(p);
    80001ba8:	8526                	mv	a0,s1
    80001baa:	f19ff0ef          	jal	80001ac2 <freeproc>
    release(&p->lock);
    80001bae:	8526                	mv	a0,s1
    80001bb0:	8daff0ef          	jal	80000c8a <release>
    return 0;
    80001bb4:	84ca                	mv	s1,s2
    80001bb6:	bfd1                	j	80001b8a <allocproc+0x78>

0000000080001bb8 <userinit>:
{
    80001bb8:	1101                	addi	sp,sp,-32
    80001bba:	ec06                	sd	ra,24(sp)
    80001bbc:	e822                	sd	s0,16(sp)
    80001bbe:	e426                	sd	s1,8(sp)
    80001bc0:	1000                	addi	s0,sp,32
  p = allocproc();
    80001bc2:	f51ff0ef          	jal	80001b12 <allocproc>
    80001bc6:	84aa                	mv	s1,a0
  initproc = p;
    80001bc8:	00006797          	auipc	a5,0x6
    80001bcc:	c8a7bc23          	sd	a0,-872(a5) # 80007860 <initproc>
  p->cwd = namei("/");
    80001bd0:	00005517          	auipc	a0,0x5
    80001bd4:	5c050513          	addi	a0,a0,1472 # 80007190 <etext+0x190>
    80001bd8:	659010ef          	jal	80003a30 <namei>
    80001bdc:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001be0:	478d                	li	a5,3
    80001be2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001be4:	8526                	mv	a0,s1
    80001be6:	8a4ff0ef          	jal	80000c8a <release>
}
    80001bea:	60e2                	ld	ra,24(sp)
    80001bec:	6442                	ld	s0,16(sp)
    80001bee:	64a2                	ld	s1,8(sp)
    80001bf0:	6105                	addi	sp,sp,32
    80001bf2:	8082                	ret

0000000080001bf4 <growproc>:
{
    80001bf4:	1101                	addi	sp,sp,-32
    80001bf6:	ec06                	sd	ra,24(sp)
    80001bf8:	e822                	sd	s0,16(sp)
    80001bfa:	e426                	sd	s1,8(sp)
    80001bfc:	e04a                	sd	s2,0(sp)
    80001bfe:	1000                	addi	s0,sp,32
    80001c00:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c02:	cf1ff0ef          	jal	800018f2 <myproc>
    80001c06:	892a                	mv	s2,a0
  sz = p->sz;
    80001c08:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001c0a:	02905963          	blez	s1,80001c3c <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80001c0e:	00b48633          	add	a2,s1,a1
    80001c12:	020007b7          	lui	a5,0x2000
    80001c16:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c18:	07b6                	slli	a5,a5,0xd
    80001c1a:	02c7ea63          	bltu	a5,a2,80001c4e <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c1e:	4691                	li	a3,4
    80001c20:	6928                	ld	a0,80(a0)
    80001c22:	e8aff0ef          	jal	800012ac <uvmalloc>
    80001c26:	85aa                	mv	a1,a0
    80001c28:	c50d                	beqz	a0,80001c52 <growproc+0x5e>
  p->sz = sz;
    80001c2a:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c2e:	4501                	li	a0,0
}
    80001c30:	60e2                	ld	ra,24(sp)
    80001c32:	6442                	ld	s0,16(sp)
    80001c34:	64a2                	ld	s1,8(sp)
    80001c36:	6902                	ld	s2,0(sp)
    80001c38:	6105                	addi	sp,sp,32
    80001c3a:	8082                	ret
  } else if(n < 0){
    80001c3c:	fe04d7e3          	bgez	s1,80001c2a <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c40:	00b48633          	add	a2,s1,a1
    80001c44:	6928                	ld	a0,80(a0)
    80001c46:	e22ff0ef          	jal	80001268 <uvmdealloc>
    80001c4a:	85aa                	mv	a1,a0
    80001c4c:	bff9                	j	80001c2a <growproc+0x36>
      return -1;
    80001c4e:	557d                	li	a0,-1
    80001c50:	b7c5                	j	80001c30 <growproc+0x3c>
      return -1;
    80001c52:	557d                	li	a0,-1
    80001c54:	bff1                	j	80001c30 <growproc+0x3c>

0000000080001c56 <kfork>:
{
    80001c56:	7139                	addi	sp,sp,-64
    80001c58:	fc06                	sd	ra,56(sp)
    80001c5a:	f822                	sd	s0,48(sp)
    80001c5c:	f04a                	sd	s2,32(sp)
    80001c5e:	e456                	sd	s5,8(sp)
    80001c60:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c62:	c91ff0ef          	jal	800018f2 <myproc>
    80001c66:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c68:	eabff0ef          	jal	80001b12 <allocproc>
    80001c6c:	0e050a63          	beqz	a0,80001d60 <kfork+0x10a>
    80001c70:	e852                	sd	s4,16(sp)
    80001c72:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c74:	048ab603          	ld	a2,72(s5)
    80001c78:	692c                	ld	a1,80(a0)
    80001c7a:	050ab503          	ld	a0,80(s5)
    80001c7e:	f66ff0ef          	jal	800013e4 <uvmcopy>
    80001c82:	04054a63          	bltz	a0,80001cd6 <kfork+0x80>
    80001c86:	f426                	sd	s1,40(sp)
    80001c88:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001c8a:	048ab783          	ld	a5,72(s5)
    80001c8e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001c92:	058ab683          	ld	a3,88(s5)
    80001c96:	87b6                	mv	a5,a3
    80001c98:	058a3703          	ld	a4,88(s4)
    80001c9c:	12068693          	addi	a3,a3,288
    80001ca0:	0007b803          	ld	a6,0(a5)
    80001ca4:	6788                	ld	a0,8(a5)
    80001ca6:	6b8c                	ld	a1,16(a5)
    80001ca8:	6f90                	ld	a2,24(a5)
    80001caa:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001cae:	e708                	sd	a0,8(a4)
    80001cb0:	eb0c                	sd	a1,16(a4)
    80001cb2:	ef10                	sd	a2,24(a4)
    80001cb4:	02078793          	addi	a5,a5,32
    80001cb8:	02070713          	addi	a4,a4,32
    80001cbc:	fed792e3          	bne	a5,a3,80001ca0 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001cc0:	058a3783          	ld	a5,88(s4)
    80001cc4:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001cc8:	0d0a8493          	addi	s1,s5,208
    80001ccc:	0d0a0913          	addi	s2,s4,208
    80001cd0:	150a8993          	addi	s3,s5,336
    80001cd4:	a831                	j	80001cf0 <kfork+0x9a>
    freeproc(np);
    80001cd6:	8552                	mv	a0,s4
    80001cd8:	debff0ef          	jal	80001ac2 <freeproc>
    release(&np->lock);
    80001cdc:	8552                	mv	a0,s4
    80001cde:	fadfe0ef          	jal	80000c8a <release>
    return -1;
    80001ce2:	597d                	li	s2,-1
    80001ce4:	6a42                	ld	s4,16(sp)
    80001ce6:	a0b5                	j	80001d52 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001ce8:	04a1                	addi	s1,s1,8
    80001cea:	0921                	addi	s2,s2,8
    80001cec:	01348963          	beq	s1,s3,80001cfe <kfork+0xa8>
    if(p->ofile[i])
    80001cf0:	6088                	ld	a0,0(s1)
    80001cf2:	d97d                	beqz	a0,80001ce8 <kfork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001cf4:	2d6020ef          	jal	80003fca <filedup>
    80001cf8:	00a93023          	sd	a0,0(s2)
    80001cfc:	b7f5                	j	80001ce8 <kfork+0x92>
  np->cwd = idup(p->cwd);
    80001cfe:	150ab503          	ld	a0,336(s5)
    80001d02:	4e2010ef          	jal	800031e4 <idup>
    80001d06:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d0a:	4641                	li	a2,16
    80001d0c:	158a8593          	addi	a1,s5,344
    80001d10:	158a0513          	addi	a0,s4,344
    80001d14:	8f0ff0ef          	jal	80000e04 <safestrcpy>
  pid = np->pid;
    80001d18:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001d1c:	8552                	mv	a0,s4
    80001d1e:	f6dfe0ef          	jal	80000c8a <release>
  acquire(&wait_lock);
    80001d22:	0000e497          	auipc	s1,0xe
    80001d26:	c5e48493          	addi	s1,s1,-930 # 8000f980 <wait_lock>
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	ec7fe0ef          	jal	80000bf2 <acquire>
  np->parent = p;
    80001d30:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001d34:	8526                	mv	a0,s1
    80001d36:	f55fe0ef          	jal	80000c8a <release>
  acquire(&np->lock);
    80001d3a:	8552                	mv	a0,s4
    80001d3c:	eb7fe0ef          	jal	80000bf2 <acquire>
  np->state = RUNNABLE;
    80001d40:	478d                	li	a5,3
    80001d42:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d46:	8552                	mv	a0,s4
    80001d48:	f43fe0ef          	jal	80000c8a <release>
  return pid;
    80001d4c:	74a2                	ld	s1,40(sp)
    80001d4e:	69e2                	ld	s3,24(sp)
    80001d50:	6a42                	ld	s4,16(sp)
}
    80001d52:	854a                	mv	a0,s2
    80001d54:	70e2                	ld	ra,56(sp)
    80001d56:	7442                	ld	s0,48(sp)
    80001d58:	7902                	ld	s2,32(sp)
    80001d5a:	6aa2                	ld	s5,8(sp)
    80001d5c:	6121                	addi	sp,sp,64
    80001d5e:	8082                	ret
    return -1;
    80001d60:	597d                	li	s2,-1
    80001d62:	bfc5                	j	80001d52 <kfork+0xfc>

0000000080001d64 <scheduler>:
{
    80001d64:	715d                	addi	sp,sp,-80
    80001d66:	e486                	sd	ra,72(sp)
    80001d68:	e0a2                	sd	s0,64(sp)
    80001d6a:	fc26                	sd	s1,56(sp)
    80001d6c:	f84a                	sd	s2,48(sp)
    80001d6e:	f44e                	sd	s3,40(sp)
    80001d70:	f052                	sd	s4,32(sp)
    80001d72:	ec56                	sd	s5,24(sp)
    80001d74:	e85a                	sd	s6,16(sp)
    80001d76:	e45e                	sd	s7,8(sp)
    80001d78:	e062                	sd	s8,0(sp)
    80001d7a:	0880                	addi	s0,sp,80
    80001d7c:	8792                	mv	a5,tp
  int id = r_tp();
    80001d7e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d80:	00779b13          	slli	s6,a5,0x7
    80001d84:	0000e717          	auipc	a4,0xe
    80001d88:	be470713          	addi	a4,a4,-1052 # 8000f968 <pid_lock>
    80001d8c:	975a                	add	a4,a4,s6
    80001d8e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001d92:	0000e717          	auipc	a4,0xe
    80001d96:	c0e70713          	addi	a4,a4,-1010 # 8000f9a0 <cpus+0x8>
    80001d9a:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001d9c:	4c11                	li	s8,4
        c->proc = p;
    80001d9e:	079e                	slli	a5,a5,0x7
    80001da0:	0000ea17          	auipc	s4,0xe
    80001da4:	bc8a0a13          	addi	s4,s4,-1080 # 8000f968 <pid_lock>
    80001da8:	9a3e                	add	s4,s4,a5
        found = 1;
    80001daa:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dac:	00014997          	auipc	s3,0x14
    80001db0:	9ec98993          	addi	s3,s3,-1556 # 80015798 <tickslock>
    80001db4:	a83d                	j	80001df2 <scheduler+0x8e>
      release(&p->lock);
    80001db6:	8526                	mv	a0,s1
    80001db8:	ed3fe0ef          	jal	80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dbc:	16848493          	addi	s1,s1,360
    80001dc0:	03348563          	beq	s1,s3,80001dea <scheduler+0x86>
      acquire(&p->lock);
    80001dc4:	8526                	mv	a0,s1
    80001dc6:	e2dfe0ef          	jal	80000bf2 <acquire>
      if(p->state == RUNNABLE) {
    80001dca:	4c9c                	lw	a5,24(s1)
    80001dcc:	ff2795e3          	bne	a5,s2,80001db6 <scheduler+0x52>
        p->state = RUNNING;
    80001dd0:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001dd4:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001dd8:	06048593          	addi	a1,s1,96
    80001ddc:	855a                	mv	a0,s6
    80001dde:	5b2000ef          	jal	80002390 <swtch>
        c->proc = 0;
    80001de2:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001de6:	8ade                	mv	s5,s7
    80001de8:	b7f9                	j	80001db6 <scheduler+0x52>
    if(found == 0) {
    80001dea:	000a9463          	bnez	s5,80001df2 <scheduler+0x8e>
      asm volatile("wfi");
    80001dee:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001df2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001df6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dfa:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dfe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001e02:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e04:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001e08:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e0a:	0000e497          	auipc	s1,0xe
    80001e0e:	f8e48493          	addi	s1,s1,-114 # 8000fd98 <proc>
      if(p->state == RUNNABLE) {
    80001e12:	490d                	li	s2,3
    80001e14:	bf45                	j	80001dc4 <scheduler+0x60>

0000000080001e16 <sched>:
{
    80001e16:	7179                	addi	sp,sp,-48
    80001e18:	f406                	sd	ra,40(sp)
    80001e1a:	f022                	sd	s0,32(sp)
    80001e1c:	ec26                	sd	s1,24(sp)
    80001e1e:	e84a                	sd	s2,16(sp)
    80001e20:	e44e                	sd	s3,8(sp)
    80001e22:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e24:	acfff0ef          	jal	800018f2 <myproc>
    80001e28:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e2a:	d5ffe0ef          	jal	80000b88 <holding>
    80001e2e:	c92d                	beqz	a0,80001ea0 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e30:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e32:	2781                	sext.w	a5,a5
    80001e34:	079e                	slli	a5,a5,0x7
    80001e36:	0000e717          	auipc	a4,0xe
    80001e3a:	b3270713          	addi	a4,a4,-1230 # 8000f968 <pid_lock>
    80001e3e:	97ba                	add	a5,a5,a4
    80001e40:	0a87a703          	lw	a4,168(a5)
    80001e44:	4785                	li	a5,1
    80001e46:	06f71363          	bne	a4,a5,80001eac <sched+0x96>
  if(p->state == RUNNING)
    80001e4a:	4c98                	lw	a4,24(s1)
    80001e4c:	4791                	li	a5,4
    80001e4e:	06f70563          	beq	a4,a5,80001eb8 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e52:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e56:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e58:	e7b5                	bnez	a5,80001ec4 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e5a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e5c:	0000e917          	auipc	s2,0xe
    80001e60:	b0c90913          	addi	s2,s2,-1268 # 8000f968 <pid_lock>
    80001e64:	2781                	sext.w	a5,a5
    80001e66:	079e                	slli	a5,a5,0x7
    80001e68:	97ca                	add	a5,a5,s2
    80001e6a:	0ac7a983          	lw	s3,172(a5)
    80001e6e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e70:	2781                	sext.w	a5,a5
    80001e72:	079e                	slli	a5,a5,0x7
    80001e74:	0000e597          	auipc	a1,0xe
    80001e78:	b2c58593          	addi	a1,a1,-1236 # 8000f9a0 <cpus+0x8>
    80001e7c:	95be                	add	a1,a1,a5
    80001e7e:	06048513          	addi	a0,s1,96
    80001e82:	50e000ef          	jal	80002390 <swtch>
    80001e86:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e88:	2781                	sext.w	a5,a5
    80001e8a:	079e                	slli	a5,a5,0x7
    80001e8c:	993e                	add	s2,s2,a5
    80001e8e:	0b392623          	sw	s3,172(s2)
}
    80001e92:	70a2                	ld	ra,40(sp)
    80001e94:	7402                	ld	s0,32(sp)
    80001e96:	64e2                	ld	s1,24(sp)
    80001e98:	6942                	ld	s2,16(sp)
    80001e9a:	69a2                	ld	s3,8(sp)
    80001e9c:	6145                	addi	sp,sp,48
    80001e9e:	8082                	ret
    panic("sched p->lock");
    80001ea0:	00005517          	auipc	a0,0x5
    80001ea4:	2f850513          	addi	a0,a0,760 # 80007198 <etext+0x198>
    80001ea8:	939fe0ef          	jal	800007e0 <panic>
    panic("sched locks");
    80001eac:	00005517          	auipc	a0,0x5
    80001eb0:	2fc50513          	addi	a0,a0,764 # 800071a8 <etext+0x1a8>
    80001eb4:	92dfe0ef          	jal	800007e0 <panic>
    panic("sched RUNNING");
    80001eb8:	00005517          	auipc	a0,0x5
    80001ebc:	30050513          	addi	a0,a0,768 # 800071b8 <etext+0x1b8>
    80001ec0:	921fe0ef          	jal	800007e0 <panic>
    panic("sched interruptible");
    80001ec4:	00005517          	auipc	a0,0x5
    80001ec8:	30450513          	addi	a0,a0,772 # 800071c8 <etext+0x1c8>
    80001ecc:	915fe0ef          	jal	800007e0 <panic>

0000000080001ed0 <yield>:
{
    80001ed0:	1101                	addi	sp,sp,-32
    80001ed2:	ec06                	sd	ra,24(sp)
    80001ed4:	e822                	sd	s0,16(sp)
    80001ed6:	e426                	sd	s1,8(sp)
    80001ed8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001eda:	a19ff0ef          	jal	800018f2 <myproc>
    80001ede:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001ee0:	d13fe0ef          	jal	80000bf2 <acquire>
  p->state = RUNNABLE;
    80001ee4:	478d                	li	a5,3
    80001ee6:	cc9c                	sw	a5,24(s1)
  sched();
    80001ee8:	f2fff0ef          	jal	80001e16 <sched>
  release(&p->lock);
    80001eec:	8526                	mv	a0,s1
    80001eee:	d9dfe0ef          	jal	80000c8a <release>
}
    80001ef2:	60e2                	ld	ra,24(sp)
    80001ef4:	6442                	ld	s0,16(sp)
    80001ef6:	64a2                	ld	s1,8(sp)
    80001ef8:	6105                	addi	sp,sp,32
    80001efa:	8082                	ret

0000000080001efc <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001efc:	7179                	addi	sp,sp,-48
    80001efe:	f406                	sd	ra,40(sp)
    80001f00:	f022                	sd	s0,32(sp)
    80001f02:	ec26                	sd	s1,24(sp)
    80001f04:	e84a                	sd	s2,16(sp)
    80001f06:	e44e                	sd	s3,8(sp)
    80001f08:	1800                	addi	s0,sp,48
    80001f0a:	89aa                	mv	s3,a0
    80001f0c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f0e:	9e5ff0ef          	jal	800018f2 <myproc>
    80001f12:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001f14:	cdffe0ef          	jal	80000bf2 <acquire>
  release(lk);
    80001f18:	854a                	mv	a0,s2
    80001f1a:	d71fe0ef          	jal	80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    80001f1e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001f22:	4789                	li	a5,2
    80001f24:	cc9c                	sw	a5,24(s1)

  sched();
    80001f26:	ef1ff0ef          	jal	80001e16 <sched>

  // Tidy up.
  p->chan = 0;
    80001f2a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f2e:	8526                	mv	a0,s1
    80001f30:	d5bfe0ef          	jal	80000c8a <release>
  acquire(lk);
    80001f34:	854a                	mv	a0,s2
    80001f36:	cbdfe0ef          	jal	80000bf2 <acquire>
}
    80001f3a:	70a2                	ld	ra,40(sp)
    80001f3c:	7402                	ld	s0,32(sp)
    80001f3e:	64e2                	ld	s1,24(sp)
    80001f40:	6942                	ld	s2,16(sp)
    80001f42:	69a2                	ld	s3,8(sp)
    80001f44:	6145                	addi	sp,sp,48
    80001f46:	8082                	ret

0000000080001f48 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001f48:	7139                	addi	sp,sp,-64
    80001f4a:	fc06                	sd	ra,56(sp)
    80001f4c:	f822                	sd	s0,48(sp)
    80001f4e:	f426                	sd	s1,40(sp)
    80001f50:	f04a                	sd	s2,32(sp)
    80001f52:	ec4e                	sd	s3,24(sp)
    80001f54:	e852                	sd	s4,16(sp)
    80001f56:	e456                	sd	s5,8(sp)
    80001f58:	0080                	addi	s0,sp,64
    80001f5a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f5c:	0000e497          	auipc	s1,0xe
    80001f60:	e3c48493          	addi	s1,s1,-452 # 8000fd98 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001f64:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f66:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f68:	00014917          	auipc	s2,0x14
    80001f6c:	83090913          	addi	s2,s2,-2000 # 80015798 <tickslock>
    80001f70:	a801                	j	80001f80 <wakeup+0x38>
      }
      release(&p->lock);
    80001f72:	8526                	mv	a0,s1
    80001f74:	d17fe0ef          	jal	80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f78:	16848493          	addi	s1,s1,360
    80001f7c:	03248263          	beq	s1,s2,80001fa0 <wakeup+0x58>
    if(p != myproc()){
    80001f80:	973ff0ef          	jal	800018f2 <myproc>
    80001f84:	fea48ae3          	beq	s1,a0,80001f78 <wakeup+0x30>
      acquire(&p->lock);
    80001f88:	8526                	mv	a0,s1
    80001f8a:	c69fe0ef          	jal	80000bf2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001f8e:	4c9c                	lw	a5,24(s1)
    80001f90:	ff3791e3          	bne	a5,s3,80001f72 <wakeup+0x2a>
    80001f94:	709c                	ld	a5,32(s1)
    80001f96:	fd479ee3          	bne	a5,s4,80001f72 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001f9a:	0154ac23          	sw	s5,24(s1)
    80001f9e:	bfd1                	j	80001f72 <wakeup+0x2a>
    }
  }
}
    80001fa0:	70e2                	ld	ra,56(sp)
    80001fa2:	7442                	ld	s0,48(sp)
    80001fa4:	74a2                	ld	s1,40(sp)
    80001fa6:	7902                	ld	s2,32(sp)
    80001fa8:	69e2                	ld	s3,24(sp)
    80001faa:	6a42                	ld	s4,16(sp)
    80001fac:	6aa2                	ld	s5,8(sp)
    80001fae:	6121                	addi	sp,sp,64
    80001fb0:	8082                	ret

0000000080001fb2 <reparent>:
{
    80001fb2:	7179                	addi	sp,sp,-48
    80001fb4:	f406                	sd	ra,40(sp)
    80001fb6:	f022                	sd	s0,32(sp)
    80001fb8:	ec26                	sd	s1,24(sp)
    80001fba:	e84a                	sd	s2,16(sp)
    80001fbc:	e44e                	sd	s3,8(sp)
    80001fbe:	e052                	sd	s4,0(sp)
    80001fc0:	1800                	addi	s0,sp,48
    80001fc2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fc4:	0000e497          	auipc	s1,0xe
    80001fc8:	dd448493          	addi	s1,s1,-556 # 8000fd98 <proc>
      pp->parent = initproc;
    80001fcc:	00006a17          	auipc	s4,0x6
    80001fd0:	894a0a13          	addi	s4,s4,-1900 # 80007860 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fd4:	00013997          	auipc	s3,0x13
    80001fd8:	7c498993          	addi	s3,s3,1988 # 80015798 <tickslock>
    80001fdc:	a029                	j	80001fe6 <reparent+0x34>
    80001fde:	16848493          	addi	s1,s1,360
    80001fe2:	01348b63          	beq	s1,s3,80001ff8 <reparent+0x46>
    if(pp->parent == p){
    80001fe6:	7c9c                	ld	a5,56(s1)
    80001fe8:	ff279be3          	bne	a5,s2,80001fde <reparent+0x2c>
      pp->parent = initproc;
    80001fec:	000a3503          	ld	a0,0(s4)
    80001ff0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001ff2:	f57ff0ef          	jal	80001f48 <wakeup>
    80001ff6:	b7e5                	j	80001fde <reparent+0x2c>
}
    80001ff8:	70a2                	ld	ra,40(sp)
    80001ffa:	7402                	ld	s0,32(sp)
    80001ffc:	64e2                	ld	s1,24(sp)
    80001ffe:	6942                	ld	s2,16(sp)
    80002000:	69a2                	ld	s3,8(sp)
    80002002:	6a02                	ld	s4,0(sp)
    80002004:	6145                	addi	sp,sp,48
    80002006:	8082                	ret

0000000080002008 <kexit>:
{
    80002008:	7179                	addi	sp,sp,-48
    8000200a:	f406                	sd	ra,40(sp)
    8000200c:	f022                	sd	s0,32(sp)
    8000200e:	ec26                	sd	s1,24(sp)
    80002010:	e84a                	sd	s2,16(sp)
    80002012:	e44e                	sd	s3,8(sp)
    80002014:	e052                	sd	s4,0(sp)
    80002016:	1800                	addi	s0,sp,48
    80002018:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000201a:	8d9ff0ef          	jal	800018f2 <myproc>
    8000201e:	89aa                	mv	s3,a0
  if(p == initproc)
    80002020:	00006797          	auipc	a5,0x6
    80002024:	8407b783          	ld	a5,-1984(a5) # 80007860 <initproc>
    80002028:	0d050493          	addi	s1,a0,208
    8000202c:	15050913          	addi	s2,a0,336
    80002030:	00a79f63          	bne	a5,a0,8000204e <kexit+0x46>
    panic("init exiting");
    80002034:	00005517          	auipc	a0,0x5
    80002038:	1ac50513          	addi	a0,a0,428 # 800071e0 <etext+0x1e0>
    8000203c:	fa4fe0ef          	jal	800007e0 <panic>
      fileclose(f);
    80002040:	7d1010ef          	jal	80004010 <fileclose>
      p->ofile[fd] = 0;
    80002044:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002048:	04a1                	addi	s1,s1,8
    8000204a:	01248563          	beq	s1,s2,80002054 <kexit+0x4c>
    if(p->ofile[fd]){
    8000204e:	6088                	ld	a0,0(s1)
    80002050:	f965                	bnez	a0,80002040 <kexit+0x38>
    80002052:	bfdd                	j	80002048 <kexit+0x40>
  begin_op();
    80002054:	3b1010ef          	jal	80003c04 <begin_op>
  iput(p->cwd);
    80002058:	1509b503          	ld	a0,336(s3)
    8000205c:	340010ef          	jal	8000339c <iput>
  end_op();
    80002060:	40f010ef          	jal	80003c6e <end_op>
  p->cwd = 0;
    80002064:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002068:	0000e497          	auipc	s1,0xe
    8000206c:	91848493          	addi	s1,s1,-1768 # 8000f980 <wait_lock>
    80002070:	8526                	mv	a0,s1
    80002072:	b81fe0ef          	jal	80000bf2 <acquire>
  reparent(p);
    80002076:	854e                	mv	a0,s3
    80002078:	f3bff0ef          	jal	80001fb2 <reparent>
  wakeup(p->parent);
    8000207c:	0389b503          	ld	a0,56(s3)
    80002080:	ec9ff0ef          	jal	80001f48 <wakeup>
  acquire(&p->lock);
    80002084:	854e                	mv	a0,s3
    80002086:	b6dfe0ef          	jal	80000bf2 <acquire>
  p->xstate = status;
    8000208a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000208e:	4795                	li	a5,5
    80002090:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002094:	8526                	mv	a0,s1
    80002096:	bf5fe0ef          	jal	80000c8a <release>
  sched();
    8000209a:	d7dff0ef          	jal	80001e16 <sched>
  panic("zombie exit");
    8000209e:	00005517          	auipc	a0,0x5
    800020a2:	15250513          	addi	a0,a0,338 # 800071f0 <etext+0x1f0>
    800020a6:	f3afe0ef          	jal	800007e0 <panic>

00000000800020aa <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800020aa:	7179                	addi	sp,sp,-48
    800020ac:	f406                	sd	ra,40(sp)
    800020ae:	f022                	sd	s0,32(sp)
    800020b0:	ec26                	sd	s1,24(sp)
    800020b2:	e84a                	sd	s2,16(sp)
    800020b4:	e44e                	sd	s3,8(sp)
    800020b6:	1800                	addi	s0,sp,48
    800020b8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800020ba:	0000e497          	auipc	s1,0xe
    800020be:	cde48493          	addi	s1,s1,-802 # 8000fd98 <proc>
    800020c2:	00013997          	auipc	s3,0x13
    800020c6:	6d698993          	addi	s3,s3,1750 # 80015798 <tickslock>
    acquire(&p->lock);
    800020ca:	8526                	mv	a0,s1
    800020cc:	b27fe0ef          	jal	80000bf2 <acquire>
    if(p->pid == pid){
    800020d0:	589c                	lw	a5,48(s1)
    800020d2:	01278b63          	beq	a5,s2,800020e8 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800020d6:	8526                	mv	a0,s1
    800020d8:	bb3fe0ef          	jal	80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800020dc:	16848493          	addi	s1,s1,360
    800020e0:	ff3495e3          	bne	s1,s3,800020ca <kkill+0x20>
  }
  return -1;
    800020e4:	557d                	li	a0,-1
    800020e6:	a819                	j	800020fc <kkill+0x52>
      p->killed = 1;
    800020e8:	4785                	li	a5,1
    800020ea:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800020ec:	4c98                	lw	a4,24(s1)
    800020ee:	4789                	li	a5,2
    800020f0:	00f70d63          	beq	a4,a5,8000210a <kkill+0x60>
      release(&p->lock);
    800020f4:	8526                	mv	a0,s1
    800020f6:	b95fe0ef          	jal	80000c8a <release>
      return 0;
    800020fa:	4501                	li	a0,0
}
    800020fc:	70a2                	ld	ra,40(sp)
    800020fe:	7402                	ld	s0,32(sp)
    80002100:	64e2                	ld	s1,24(sp)
    80002102:	6942                	ld	s2,16(sp)
    80002104:	69a2                	ld	s3,8(sp)
    80002106:	6145                	addi	sp,sp,48
    80002108:	8082                	ret
        p->state = RUNNABLE;
    8000210a:	478d                	li	a5,3
    8000210c:	cc9c                	sw	a5,24(s1)
    8000210e:	b7dd                	j	800020f4 <kkill+0x4a>

0000000080002110 <setkilled>:

void
setkilled(struct proc *p)
{
    80002110:	1101                	addi	sp,sp,-32
    80002112:	ec06                	sd	ra,24(sp)
    80002114:	e822                	sd	s0,16(sp)
    80002116:	e426                	sd	s1,8(sp)
    80002118:	1000                	addi	s0,sp,32
    8000211a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000211c:	ad7fe0ef          	jal	80000bf2 <acquire>
  p->killed = 1;
    80002120:	4785                	li	a5,1
    80002122:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002124:	8526                	mv	a0,s1
    80002126:	b65fe0ef          	jal	80000c8a <release>
}
    8000212a:	60e2                	ld	ra,24(sp)
    8000212c:	6442                	ld	s0,16(sp)
    8000212e:	64a2                	ld	s1,8(sp)
    80002130:	6105                	addi	sp,sp,32
    80002132:	8082                	ret

0000000080002134 <killed>:

int
killed(struct proc *p)
{
    80002134:	1101                	addi	sp,sp,-32
    80002136:	ec06                	sd	ra,24(sp)
    80002138:	e822                	sd	s0,16(sp)
    8000213a:	e426                	sd	s1,8(sp)
    8000213c:	e04a                	sd	s2,0(sp)
    8000213e:	1000                	addi	s0,sp,32
    80002140:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002142:	ab1fe0ef          	jal	80000bf2 <acquire>
  k = p->killed;
    80002146:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000214a:	8526                	mv	a0,s1
    8000214c:	b3ffe0ef          	jal	80000c8a <release>
  return k;
}
    80002150:	854a                	mv	a0,s2
    80002152:	60e2                	ld	ra,24(sp)
    80002154:	6442                	ld	s0,16(sp)
    80002156:	64a2                	ld	s1,8(sp)
    80002158:	6902                	ld	s2,0(sp)
    8000215a:	6105                	addi	sp,sp,32
    8000215c:	8082                	ret

000000008000215e <kwait>:
{
    8000215e:	715d                	addi	sp,sp,-80
    80002160:	e486                	sd	ra,72(sp)
    80002162:	e0a2                	sd	s0,64(sp)
    80002164:	fc26                	sd	s1,56(sp)
    80002166:	f84a                	sd	s2,48(sp)
    80002168:	f44e                	sd	s3,40(sp)
    8000216a:	f052                	sd	s4,32(sp)
    8000216c:	ec56                	sd	s5,24(sp)
    8000216e:	e85a                	sd	s6,16(sp)
    80002170:	e45e                	sd	s7,8(sp)
    80002172:	e062                	sd	s8,0(sp)
    80002174:	0880                	addi	s0,sp,80
    80002176:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002178:	f7aff0ef          	jal	800018f2 <myproc>
    8000217c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000217e:	0000e517          	auipc	a0,0xe
    80002182:	80250513          	addi	a0,a0,-2046 # 8000f980 <wait_lock>
    80002186:	a6dfe0ef          	jal	80000bf2 <acquire>
    havekids = 0;
    8000218a:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000218c:	4a15                	li	s4,5
        havekids = 1;
    8000218e:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002190:	00013997          	auipc	s3,0x13
    80002194:	60898993          	addi	s3,s3,1544 # 80015798 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002198:	0000dc17          	auipc	s8,0xd
    8000219c:	7e8c0c13          	addi	s8,s8,2024 # 8000f980 <wait_lock>
    800021a0:	a871                	j	8000223c <kwait+0xde>
          pid = pp->pid;
    800021a2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800021a6:	000b0c63          	beqz	s6,800021be <kwait+0x60>
    800021aa:	4691                	li	a3,4
    800021ac:	02c48613          	addi	a2,s1,44
    800021b0:	85da                	mv	a1,s6
    800021b2:	05093503          	ld	a0,80(s2)
    800021b6:	c50ff0ef          	jal	80001606 <copyout>
    800021ba:	02054b63          	bltz	a0,800021f0 <kwait+0x92>
          freeproc(pp);
    800021be:	8526                	mv	a0,s1
    800021c0:	903ff0ef          	jal	80001ac2 <freeproc>
          release(&pp->lock);
    800021c4:	8526                	mv	a0,s1
    800021c6:	ac5fe0ef          	jal	80000c8a <release>
          release(&wait_lock);
    800021ca:	0000d517          	auipc	a0,0xd
    800021ce:	7b650513          	addi	a0,a0,1974 # 8000f980 <wait_lock>
    800021d2:	ab9fe0ef          	jal	80000c8a <release>
}
    800021d6:	854e                	mv	a0,s3
    800021d8:	60a6                	ld	ra,72(sp)
    800021da:	6406                	ld	s0,64(sp)
    800021dc:	74e2                	ld	s1,56(sp)
    800021de:	7942                	ld	s2,48(sp)
    800021e0:	79a2                	ld	s3,40(sp)
    800021e2:	7a02                	ld	s4,32(sp)
    800021e4:	6ae2                	ld	s5,24(sp)
    800021e6:	6b42                	ld	s6,16(sp)
    800021e8:	6ba2                	ld	s7,8(sp)
    800021ea:	6c02                	ld	s8,0(sp)
    800021ec:	6161                	addi	sp,sp,80
    800021ee:	8082                	ret
            release(&pp->lock);
    800021f0:	8526                	mv	a0,s1
    800021f2:	a99fe0ef          	jal	80000c8a <release>
            release(&wait_lock);
    800021f6:	0000d517          	auipc	a0,0xd
    800021fa:	78a50513          	addi	a0,a0,1930 # 8000f980 <wait_lock>
    800021fe:	a8dfe0ef          	jal	80000c8a <release>
            return -1;
    80002202:	59fd                	li	s3,-1
    80002204:	bfc9                	j	800021d6 <kwait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002206:	16848493          	addi	s1,s1,360
    8000220a:	03348063          	beq	s1,s3,8000222a <kwait+0xcc>
      if(pp->parent == p){
    8000220e:	7c9c                	ld	a5,56(s1)
    80002210:	ff279be3          	bne	a5,s2,80002206 <kwait+0xa8>
        acquire(&pp->lock);
    80002214:	8526                	mv	a0,s1
    80002216:	9ddfe0ef          	jal	80000bf2 <acquire>
        if(pp->state == ZOMBIE){
    8000221a:	4c9c                	lw	a5,24(s1)
    8000221c:	f94783e3          	beq	a5,s4,800021a2 <kwait+0x44>
        release(&pp->lock);
    80002220:	8526                	mv	a0,s1
    80002222:	a69fe0ef          	jal	80000c8a <release>
        havekids = 1;
    80002226:	8756                	mv	a4,s5
    80002228:	bff9                	j	80002206 <kwait+0xa8>
    if(!havekids || killed(p)){
    8000222a:	cf19                	beqz	a4,80002248 <kwait+0xea>
    8000222c:	854a                	mv	a0,s2
    8000222e:	f07ff0ef          	jal	80002134 <killed>
    80002232:	e919                	bnez	a0,80002248 <kwait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002234:	85e2                	mv	a1,s8
    80002236:	854a                	mv	a0,s2
    80002238:	cc5ff0ef          	jal	80001efc <sleep>
    havekids = 0;
    8000223c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000223e:	0000e497          	auipc	s1,0xe
    80002242:	b5a48493          	addi	s1,s1,-1190 # 8000fd98 <proc>
    80002246:	b7e1                	j	8000220e <kwait+0xb0>
      release(&wait_lock);
    80002248:	0000d517          	auipc	a0,0xd
    8000224c:	73850513          	addi	a0,a0,1848 # 8000f980 <wait_lock>
    80002250:	a3bfe0ef          	jal	80000c8a <release>
      return -1;
    80002254:	59fd                	li	s3,-1
    80002256:	b741                	j	800021d6 <kwait+0x78>

0000000080002258 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002258:	7179                	addi	sp,sp,-48
    8000225a:	f406                	sd	ra,40(sp)
    8000225c:	f022                	sd	s0,32(sp)
    8000225e:	ec26                	sd	s1,24(sp)
    80002260:	e84a                	sd	s2,16(sp)
    80002262:	e44e                	sd	s3,8(sp)
    80002264:	e052                	sd	s4,0(sp)
    80002266:	1800                	addi	s0,sp,48
    80002268:	84aa                	mv	s1,a0
    8000226a:	892e                	mv	s2,a1
    8000226c:	89b2                	mv	s3,a2
    8000226e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002270:	e82ff0ef          	jal	800018f2 <myproc>
  if(user_dst){
    80002274:	cc99                	beqz	s1,80002292 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002276:	86d2                	mv	a3,s4
    80002278:	864e                	mv	a2,s3
    8000227a:	85ca                	mv	a1,s2
    8000227c:	6928                	ld	a0,80(a0)
    8000227e:	b88ff0ef          	jal	80001606 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002282:	70a2                	ld	ra,40(sp)
    80002284:	7402                	ld	s0,32(sp)
    80002286:	64e2                	ld	s1,24(sp)
    80002288:	6942                	ld	s2,16(sp)
    8000228a:	69a2                	ld	s3,8(sp)
    8000228c:	6a02                	ld	s4,0(sp)
    8000228e:	6145                	addi	sp,sp,48
    80002290:	8082                	ret
    memmove((char *)dst, src, len);
    80002292:	000a061b          	sext.w	a2,s4
    80002296:	85ce                	mv	a1,s3
    80002298:	854a                	mv	a0,s2
    8000229a:	a89fe0ef          	jal	80000d22 <memmove>
    return 0;
    8000229e:	8526                	mv	a0,s1
    800022a0:	b7cd                	j	80002282 <either_copyout+0x2a>

00000000800022a2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022a2:	7179                	addi	sp,sp,-48
    800022a4:	f406                	sd	ra,40(sp)
    800022a6:	f022                	sd	s0,32(sp)
    800022a8:	ec26                	sd	s1,24(sp)
    800022aa:	e84a                	sd	s2,16(sp)
    800022ac:	e44e                	sd	s3,8(sp)
    800022ae:	e052                	sd	s4,0(sp)
    800022b0:	1800                	addi	s0,sp,48
    800022b2:	892a                	mv	s2,a0
    800022b4:	84ae                	mv	s1,a1
    800022b6:	89b2                	mv	s3,a2
    800022b8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022ba:	e38ff0ef          	jal	800018f2 <myproc>
  if(user_src){
    800022be:	cc99                	beqz	s1,800022dc <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800022c0:	86d2                	mv	a3,s4
    800022c2:	864e                	mv	a2,s3
    800022c4:	85ca                	mv	a1,s2
    800022c6:	6928                	ld	a0,80(a0)
    800022c8:	c22ff0ef          	jal	800016ea <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800022cc:	70a2                	ld	ra,40(sp)
    800022ce:	7402                	ld	s0,32(sp)
    800022d0:	64e2                	ld	s1,24(sp)
    800022d2:	6942                	ld	s2,16(sp)
    800022d4:	69a2                	ld	s3,8(sp)
    800022d6:	6a02                	ld	s4,0(sp)
    800022d8:	6145                	addi	sp,sp,48
    800022da:	8082                	ret
    memmove(dst, (char*)src, len);
    800022dc:	000a061b          	sext.w	a2,s4
    800022e0:	85ce                	mv	a1,s3
    800022e2:	854a                	mv	a0,s2
    800022e4:	a3ffe0ef          	jal	80000d22 <memmove>
    return 0;
    800022e8:	8526                	mv	a0,s1
    800022ea:	b7cd                	j	800022cc <either_copyin+0x2a>

00000000800022ec <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800022ec:	715d                	addi	sp,sp,-80
    800022ee:	e486                	sd	ra,72(sp)
    800022f0:	e0a2                	sd	s0,64(sp)
    800022f2:	fc26                	sd	s1,56(sp)
    800022f4:	f84a                	sd	s2,48(sp)
    800022f6:	f44e                	sd	s3,40(sp)
    800022f8:	f052                	sd	s4,32(sp)
    800022fa:	ec56                	sd	s5,24(sp)
    800022fc:	e85a                	sd	s6,16(sp)
    800022fe:	e45e                	sd	s7,8(sp)
    80002300:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002302:	00005517          	auipc	a0,0x5
    80002306:	d7650513          	addi	a0,a0,-650 # 80007078 <etext+0x78>
    8000230a:	9f0fe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000230e:	0000e497          	auipc	s1,0xe
    80002312:	be248493          	addi	s1,s1,-1054 # 8000fef0 <proc+0x158>
    80002316:	00013917          	auipc	s2,0x13
    8000231a:	5da90913          	addi	s2,s2,1498 # 800158f0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000231e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002320:	00005997          	auipc	s3,0x5
    80002324:	ee098993          	addi	s3,s3,-288 # 80007200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80002328:	00005a97          	auipc	s5,0x5
    8000232c:	ee0a8a93          	addi	s5,s5,-288 # 80007208 <etext+0x208>
    printf("\n");
    80002330:	00005a17          	auipc	s4,0x5
    80002334:	d48a0a13          	addi	s4,s4,-696 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002338:	00005b97          	auipc	s7,0x5
    8000233c:	3f0b8b93          	addi	s7,s7,1008 # 80007728 <states.0>
    80002340:	a829                	j	8000235a <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002342:	ed86a583          	lw	a1,-296(a3)
    80002346:	8556                	mv	a0,s5
    80002348:	9b2fe0ef          	jal	800004fa <printf>
    printf("\n");
    8000234c:	8552                	mv	a0,s4
    8000234e:	9acfe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002352:	16848493          	addi	s1,s1,360
    80002356:	03248263          	beq	s1,s2,8000237a <procdump+0x8e>
    if(p->state == UNUSED)
    8000235a:	86a6                	mv	a3,s1
    8000235c:	ec04a783          	lw	a5,-320(s1)
    80002360:	dbed                	beqz	a5,80002352 <procdump+0x66>
      state = "???";
    80002362:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002364:	fcfb6fe3          	bltu	s6,a5,80002342 <procdump+0x56>
    80002368:	02079713          	slli	a4,a5,0x20
    8000236c:	01d75793          	srli	a5,a4,0x1d
    80002370:	97de                	add	a5,a5,s7
    80002372:	6390                	ld	a2,0(a5)
    80002374:	f679                	bnez	a2,80002342 <procdump+0x56>
      state = "???";
    80002376:	864e                	mv	a2,s3
    80002378:	b7e9                	j	80002342 <procdump+0x56>
  }
}
    8000237a:	60a6                	ld	ra,72(sp)
    8000237c:	6406                	ld	s0,64(sp)
    8000237e:	74e2                	ld	s1,56(sp)
    80002380:	7942                	ld	s2,48(sp)
    80002382:	79a2                	ld	s3,40(sp)
    80002384:	7a02                	ld	s4,32(sp)
    80002386:	6ae2                	ld	s5,24(sp)
    80002388:	6b42                	ld	s6,16(sp)
    8000238a:	6ba2                	ld	s7,8(sp)
    8000238c:	6161                	addi	sp,sp,80
    8000238e:	8082                	ret

0000000080002390 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80002390:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80002394:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80002398:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8000239a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8000239c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800023a0:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800023a4:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800023a8:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800023ac:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800023b0:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800023b4:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800023b8:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800023bc:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800023c0:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800023c4:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800023c8:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800023cc:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800023ce:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800023d0:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800023d4:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    800023d8:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    800023dc:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800023e0:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    800023e4:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    800023e8:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    800023ec:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800023f0:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800023f4:	0685bd83          	ld	s11,104(a1)
        
        ret
    800023f8:	8082                	ret

00000000800023fa <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800023fa:	1141                	addi	sp,sp,-16
    800023fc:	e406                	sd	ra,8(sp)
    800023fe:	e022                	sd	s0,0(sp)
    80002400:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002402:	00005597          	auipc	a1,0x5
    80002406:	e4658593          	addi	a1,a1,-442 # 80007248 <etext+0x248>
    8000240a:	00013517          	auipc	a0,0x13
    8000240e:	38e50513          	addi	a0,a0,910 # 80015798 <tickslock>
    80002412:	f60fe0ef          	jal	80000b72 <initlock>
}
    80002416:	60a2                	ld	ra,8(sp)
    80002418:	6402                	ld	s0,0(sp)
    8000241a:	0141                	addi	sp,sp,16
    8000241c:	8082                	ret

000000008000241e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000241e:	1141                	addi	sp,sp,-16
    80002420:	e422                	sd	s0,8(sp)
    80002422:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002424:	00003797          	auipc	a5,0x3
    80002428:	f6c78793          	addi	a5,a5,-148 # 80005390 <kernelvec>
    8000242c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002430:	6422                	ld	s0,8(sp)
    80002432:	0141                	addi	sp,sp,16
    80002434:	8082                	ret

0000000080002436 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002436:	1141                	addi	sp,sp,-16
    80002438:	e406                	sd	ra,8(sp)
    8000243a:	e022                	sd	s0,0(sp)
    8000243c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000243e:	cb4ff0ef          	jal	800018f2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002442:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002446:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002448:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000244c:	04000737          	lui	a4,0x4000
    80002450:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002452:	0732                	slli	a4,a4,0xc
    80002454:	00004797          	auipc	a5,0x4
    80002458:	bac78793          	addi	a5,a5,-1108 # 80006000 <_trampoline>
    8000245c:	00004697          	auipc	a3,0x4
    80002460:	ba468693          	addi	a3,a3,-1116 # 80006000 <_trampoline>
    80002464:	8f95                	sub	a5,a5,a3
    80002466:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002468:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000246c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000246e:	18002773          	csrr	a4,satp
    80002472:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002474:	6d38                	ld	a4,88(a0)
    80002476:	613c                	ld	a5,64(a0)
    80002478:	6685                	lui	a3,0x1
    8000247a:	97b6                	add	a5,a5,a3
    8000247c:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000247e:	6d3c                	ld	a5,88(a0)
    80002480:	00000717          	auipc	a4,0x0
    80002484:	0f870713          	addi	a4,a4,248 # 80002578 <usertrap>
    80002488:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000248a:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000248c:	8712                	mv	a4,tp
    8000248e:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002490:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002494:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002498:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000249c:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024a0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800024a2:	6f9c                	ld	a5,24(a5)
    800024a4:	14179073          	csrw	sepc,a5
}
    800024a8:	60a2                	ld	ra,8(sp)
    800024aa:	6402                	ld	s0,0(sp)
    800024ac:	0141                	addi	sp,sp,16
    800024ae:	8082                	ret

00000000800024b0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024b0:	1101                	addi	sp,sp,-32
    800024b2:	ec06                	sd	ra,24(sp)
    800024b4:	e822                	sd	s0,16(sp)
    800024b6:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800024b8:	c0eff0ef          	jal	800018c6 <cpuid>
    800024bc:	cd11                	beqz	a0,800024d8 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800024be:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800024c2:	000f4737          	lui	a4,0xf4
    800024c6:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024ca:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800024cc:	14d79073          	csrw	stimecmp,a5
}
    800024d0:	60e2                	ld	ra,24(sp)
    800024d2:	6442                	ld	s0,16(sp)
    800024d4:	6105                	addi	sp,sp,32
    800024d6:	8082                	ret
    800024d8:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800024da:	00013497          	auipc	s1,0x13
    800024de:	2be48493          	addi	s1,s1,702 # 80015798 <tickslock>
    800024e2:	8526                	mv	a0,s1
    800024e4:	f0efe0ef          	jal	80000bf2 <acquire>
    ticks++;
    800024e8:	00005517          	auipc	a0,0x5
    800024ec:	38050513          	addi	a0,a0,896 # 80007868 <ticks>
    800024f0:	411c                	lw	a5,0(a0)
    800024f2:	2785                	addiw	a5,a5,1
    800024f4:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800024f6:	a53ff0ef          	jal	80001f48 <wakeup>
    release(&tickslock);
    800024fa:	8526                	mv	a0,s1
    800024fc:	f8efe0ef          	jal	80000c8a <release>
    80002500:	64a2                	ld	s1,8(sp)
    80002502:	bf75                	j	800024be <clockintr+0xe>

0000000080002504 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002504:	1101                	addi	sp,sp,-32
    80002506:	ec06                	sd	ra,24(sp)
    80002508:	e822                	sd	s0,16(sp)
    8000250a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000250c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002510:	57fd                	li	a5,-1
    80002512:	17fe                	slli	a5,a5,0x3f
    80002514:	07a5                	addi	a5,a5,9
    80002516:	00f70c63          	beq	a4,a5,8000252e <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000251a:	57fd                	li	a5,-1
    8000251c:	17fe                	slli	a5,a5,0x3f
    8000251e:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002520:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002522:	04f70763          	beq	a4,a5,80002570 <devintr+0x6c>
  }
}
    80002526:	60e2                	ld	ra,24(sp)
    80002528:	6442                	ld	s0,16(sp)
    8000252a:	6105                	addi	sp,sp,32
    8000252c:	8082                	ret
    8000252e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002530:	70d020ef          	jal	8000543c <plic_claim>
    80002534:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002536:	47a9                	li	a5,10
    80002538:	00f50963          	beq	a0,a5,8000254a <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    8000253c:	4785                	li	a5,1
    8000253e:	00f50963          	beq	a0,a5,80002550 <devintr+0x4c>
    return 1;
    80002542:	4505                	li	a0,1
    } else if(irq){
    80002544:	e889                	bnez	s1,80002556 <devintr+0x52>
    80002546:	64a2                	ld	s1,8(sp)
    80002548:	bff9                	j	80002526 <devintr+0x22>
      uartintr();
    8000254a:	c66fe0ef          	jal	800009b0 <uartintr>
    if(irq)
    8000254e:	a819                	j	80002564 <devintr+0x60>
      virtio_disk_intr();
    80002550:	3b2030ef          	jal	80005902 <virtio_disk_intr>
    if(irq)
    80002554:	a801                	j	80002564 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002556:	85a6                	mv	a1,s1
    80002558:	00005517          	auipc	a0,0x5
    8000255c:	cf850513          	addi	a0,a0,-776 # 80007250 <etext+0x250>
    80002560:	f9bfd0ef          	jal	800004fa <printf>
      plic_complete(irq);
    80002564:	8526                	mv	a0,s1
    80002566:	6f7020ef          	jal	8000545c <plic_complete>
    return 1;
    8000256a:	4505                	li	a0,1
    8000256c:	64a2                	ld	s1,8(sp)
    8000256e:	bf65                	j	80002526 <devintr+0x22>
    clockintr();
    80002570:	f41ff0ef          	jal	800024b0 <clockintr>
    return 2;
    80002574:	4509                	li	a0,2
    80002576:	bf45                	j	80002526 <devintr+0x22>

0000000080002578 <usertrap>:
{
    80002578:	1101                	addi	sp,sp,-32
    8000257a:	ec06                	sd	ra,24(sp)
    8000257c:	e822                	sd	s0,16(sp)
    8000257e:	e426                	sd	s1,8(sp)
    80002580:	e04a                	sd	s2,0(sp)
    80002582:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002584:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002588:	1007f793          	andi	a5,a5,256
    8000258c:	eba5                	bnez	a5,800025fc <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000258e:	00003797          	auipc	a5,0x3
    80002592:	e0278793          	addi	a5,a5,-510 # 80005390 <kernelvec>
    80002596:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000259a:	b58ff0ef          	jal	800018f2 <myproc>
    8000259e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800025a0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025a2:	14102773          	csrr	a4,sepc
    800025a6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025a8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800025ac:	47a1                	li	a5,8
    800025ae:	04f70d63          	beq	a4,a5,80002608 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    800025b2:	f53ff0ef          	jal	80002504 <devintr>
    800025b6:	892a                	mv	s2,a0
    800025b8:	e945                	bnez	a0,80002668 <usertrap+0xf0>
    800025ba:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    800025be:	47bd                	li	a5,15
    800025c0:	08f70863          	beq	a4,a5,80002650 <usertrap+0xd8>
    800025c4:	14202773          	csrr	a4,scause
    800025c8:	47b5                	li	a5,13
    800025ca:	08f70363          	beq	a4,a5,80002650 <usertrap+0xd8>
    800025ce:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800025d2:	5890                	lw	a2,48(s1)
    800025d4:	00005517          	auipc	a0,0x5
    800025d8:	cbc50513          	addi	a0,a0,-836 # 80007290 <etext+0x290>
    800025dc:	f1ffd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025e0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800025e4:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800025e8:	00005517          	auipc	a0,0x5
    800025ec:	cd850513          	addi	a0,a0,-808 # 800072c0 <etext+0x2c0>
    800025f0:	f0bfd0ef          	jal	800004fa <printf>
    setkilled(p);
    800025f4:	8526                	mv	a0,s1
    800025f6:	b1bff0ef          	jal	80002110 <setkilled>
    800025fa:	a035                	j	80002626 <usertrap+0xae>
    panic("usertrap: not from user mode");
    800025fc:	00005517          	auipc	a0,0x5
    80002600:	c7450513          	addi	a0,a0,-908 # 80007270 <etext+0x270>
    80002604:	9dcfe0ef          	jal	800007e0 <panic>
    if(killed(p))
    80002608:	b2dff0ef          	jal	80002134 <killed>
    8000260c:	ed15                	bnez	a0,80002648 <usertrap+0xd0>
    p->trapframe->epc += 4;
    8000260e:	6cb8                	ld	a4,88(s1)
    80002610:	6f1c                	ld	a5,24(a4)
    80002612:	0791                	addi	a5,a5,4
    80002614:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002616:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000261a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000261e:	10079073          	csrw	sstatus,a5
    syscall();
    80002622:	246000ef          	jal	80002868 <syscall>
  if(killed(p))
    80002626:	8526                	mv	a0,s1
    80002628:	b0dff0ef          	jal	80002134 <killed>
    8000262c:	e139                	bnez	a0,80002672 <usertrap+0xfa>
  prepare_return();
    8000262e:	e09ff0ef          	jal	80002436 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002632:	68a8                	ld	a0,80(s1)
    80002634:	8131                	srli	a0,a0,0xc
    80002636:	57fd                	li	a5,-1
    80002638:	17fe                	slli	a5,a5,0x3f
    8000263a:	8d5d                	or	a0,a0,a5
}
    8000263c:	60e2                	ld	ra,24(sp)
    8000263e:	6442                	ld	s0,16(sp)
    80002640:	64a2                	ld	s1,8(sp)
    80002642:	6902                	ld	s2,0(sp)
    80002644:	6105                	addi	sp,sp,32
    80002646:	8082                	ret
      kexit(-1);
    80002648:	557d                	li	a0,-1
    8000264a:	9bfff0ef          	jal	80002008 <kexit>
    8000264e:	b7c1                	j	8000260e <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002650:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002654:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80002658:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    8000265a:	00163613          	seqz	a2,a2
    8000265e:	68a8                	ld	a0,80(s1)
    80002660:	f25fe0ef          	jal	80001584 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002664:	f169                	bnez	a0,80002626 <usertrap+0xae>
    80002666:	b7a5                	j	800025ce <usertrap+0x56>
  if(killed(p))
    80002668:	8526                	mv	a0,s1
    8000266a:	acbff0ef          	jal	80002134 <killed>
    8000266e:	c511                	beqz	a0,8000267a <usertrap+0x102>
    80002670:	a011                	j	80002674 <usertrap+0xfc>
    80002672:	4901                	li	s2,0
    kexit(-1);
    80002674:	557d                	li	a0,-1
    80002676:	993ff0ef          	jal	80002008 <kexit>
  if(which_dev == 2)
    8000267a:	4789                	li	a5,2
    8000267c:	faf919e3          	bne	s2,a5,8000262e <usertrap+0xb6>
    yield();
    80002680:	851ff0ef          	jal	80001ed0 <yield>
    80002684:	b76d                	j	8000262e <usertrap+0xb6>

0000000080002686 <kerneltrap>:
{
    80002686:	7179                	addi	sp,sp,-48
    80002688:	f406                	sd	ra,40(sp)
    8000268a:	f022                	sd	s0,32(sp)
    8000268c:	ec26                	sd	s1,24(sp)
    8000268e:	e84a                	sd	s2,16(sp)
    80002690:	e44e                	sd	s3,8(sp)
    80002692:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002694:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002698:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000269c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800026a0:	1004f793          	andi	a5,s1,256
    800026a4:	c795                	beqz	a5,800026d0 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026a6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026aa:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800026ac:	eb85                	bnez	a5,800026dc <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800026ae:	e57ff0ef          	jal	80002504 <devintr>
    800026b2:	c91d                	beqz	a0,800026e8 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    800026b4:	4789                	li	a5,2
    800026b6:	04f50a63          	beq	a0,a5,8000270a <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026ba:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026be:	10049073          	csrw	sstatus,s1
}
    800026c2:	70a2                	ld	ra,40(sp)
    800026c4:	7402                	ld	s0,32(sp)
    800026c6:	64e2                	ld	s1,24(sp)
    800026c8:	6942                	ld	s2,16(sp)
    800026ca:	69a2                	ld	s3,8(sp)
    800026cc:	6145                	addi	sp,sp,48
    800026ce:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800026d0:	00005517          	auipc	a0,0x5
    800026d4:	c1850513          	addi	a0,a0,-1000 # 800072e8 <etext+0x2e8>
    800026d8:	908fe0ef          	jal	800007e0 <panic>
    panic("kerneltrap: interrupts enabled");
    800026dc:	00005517          	auipc	a0,0x5
    800026e0:	c3450513          	addi	a0,a0,-972 # 80007310 <etext+0x310>
    800026e4:	8fcfe0ef          	jal	800007e0 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026e8:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800026ec:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800026f0:	85ce                	mv	a1,s3
    800026f2:	00005517          	auipc	a0,0x5
    800026f6:	c3e50513          	addi	a0,a0,-962 # 80007330 <etext+0x330>
    800026fa:	e01fd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    800026fe:	00005517          	auipc	a0,0x5
    80002702:	c5a50513          	addi	a0,a0,-934 # 80007358 <etext+0x358>
    80002706:	8dafe0ef          	jal	800007e0 <panic>
  if(which_dev == 2 && myproc() != 0)
    8000270a:	9e8ff0ef          	jal	800018f2 <myproc>
    8000270e:	d555                	beqz	a0,800026ba <kerneltrap+0x34>
    yield();
    80002710:	fc0ff0ef          	jal	80001ed0 <yield>
    80002714:	b75d                	j	800026ba <kerneltrap+0x34>

0000000080002716 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002716:	1101                	addi	sp,sp,-32
    80002718:	ec06                	sd	ra,24(sp)
    8000271a:	e822                	sd	s0,16(sp)
    8000271c:	e426                	sd	s1,8(sp)
    8000271e:	1000                	addi	s0,sp,32
    80002720:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002722:	9d0ff0ef          	jal	800018f2 <myproc>
  switch (n) {
    80002726:	4795                	li	a5,5
    80002728:	0497e163          	bltu	a5,s1,8000276a <argraw+0x54>
    8000272c:	048a                	slli	s1,s1,0x2
    8000272e:	00005717          	auipc	a4,0x5
    80002732:	02a70713          	addi	a4,a4,42 # 80007758 <states.0+0x30>
    80002736:	94ba                	add	s1,s1,a4
    80002738:	409c                	lw	a5,0(s1)
    8000273a:	97ba                	add	a5,a5,a4
    8000273c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000273e:	6d3c                	ld	a5,88(a0)
    80002740:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002742:	60e2                	ld	ra,24(sp)
    80002744:	6442                	ld	s0,16(sp)
    80002746:	64a2                	ld	s1,8(sp)
    80002748:	6105                	addi	sp,sp,32
    8000274a:	8082                	ret
    return p->trapframe->a1;
    8000274c:	6d3c                	ld	a5,88(a0)
    8000274e:	7fa8                	ld	a0,120(a5)
    80002750:	bfcd                	j	80002742 <argraw+0x2c>
    return p->trapframe->a2;
    80002752:	6d3c                	ld	a5,88(a0)
    80002754:	63c8                	ld	a0,128(a5)
    80002756:	b7f5                	j	80002742 <argraw+0x2c>
    return p->trapframe->a3;
    80002758:	6d3c                	ld	a5,88(a0)
    8000275a:	67c8                	ld	a0,136(a5)
    8000275c:	b7dd                	j	80002742 <argraw+0x2c>
    return p->trapframe->a4;
    8000275e:	6d3c                	ld	a5,88(a0)
    80002760:	6bc8                	ld	a0,144(a5)
    80002762:	b7c5                	j	80002742 <argraw+0x2c>
    return p->trapframe->a5;
    80002764:	6d3c                	ld	a5,88(a0)
    80002766:	6fc8                	ld	a0,152(a5)
    80002768:	bfe9                	j	80002742 <argraw+0x2c>
  panic("argraw");
    8000276a:	00005517          	auipc	a0,0x5
    8000276e:	bfe50513          	addi	a0,a0,-1026 # 80007368 <etext+0x368>
    80002772:	86efe0ef          	jal	800007e0 <panic>

0000000080002776 <fetchaddr>:
{
    80002776:	1101                	addi	sp,sp,-32
    80002778:	ec06                	sd	ra,24(sp)
    8000277a:	e822                	sd	s0,16(sp)
    8000277c:	e426                	sd	s1,8(sp)
    8000277e:	e04a                	sd	s2,0(sp)
    80002780:	1000                	addi	s0,sp,32
    80002782:	84aa                	mv	s1,a0
    80002784:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002786:	96cff0ef          	jal	800018f2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000278a:	653c                	ld	a5,72(a0)
    8000278c:	02f4f663          	bgeu	s1,a5,800027b8 <fetchaddr+0x42>
    80002790:	00848713          	addi	a4,s1,8
    80002794:	02e7e463          	bltu	a5,a4,800027bc <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002798:	46a1                	li	a3,8
    8000279a:	8626                	mv	a2,s1
    8000279c:	85ca                	mv	a1,s2
    8000279e:	6928                	ld	a0,80(a0)
    800027a0:	f4bfe0ef          	jal	800016ea <copyin>
    800027a4:	00a03533          	snez	a0,a0
    800027a8:	40a00533          	neg	a0,a0
}
    800027ac:	60e2                	ld	ra,24(sp)
    800027ae:	6442                	ld	s0,16(sp)
    800027b0:	64a2                	ld	s1,8(sp)
    800027b2:	6902                	ld	s2,0(sp)
    800027b4:	6105                	addi	sp,sp,32
    800027b6:	8082                	ret
    return -1;
    800027b8:	557d                	li	a0,-1
    800027ba:	bfcd                	j	800027ac <fetchaddr+0x36>
    800027bc:	557d                	li	a0,-1
    800027be:	b7fd                	j	800027ac <fetchaddr+0x36>

00000000800027c0 <fetchstr>:
{
    800027c0:	7179                	addi	sp,sp,-48
    800027c2:	f406                	sd	ra,40(sp)
    800027c4:	f022                	sd	s0,32(sp)
    800027c6:	ec26                	sd	s1,24(sp)
    800027c8:	e84a                	sd	s2,16(sp)
    800027ca:	e44e                	sd	s3,8(sp)
    800027cc:	1800                	addi	s0,sp,48
    800027ce:	892a                	mv	s2,a0
    800027d0:	84ae                	mv	s1,a1
    800027d2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800027d4:	91eff0ef          	jal	800018f2 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800027d8:	86ce                	mv	a3,s3
    800027da:	864a                	mv	a2,s2
    800027dc:	85a6                	mv	a1,s1
    800027de:	6928                	ld	a0,80(a0)
    800027e0:	ccdfe0ef          	jal	800014ac <copyinstr>
    800027e4:	00054c63          	bltz	a0,800027fc <fetchstr+0x3c>
  return strlen(buf);
    800027e8:	8526                	mv	a0,s1
    800027ea:	e4cfe0ef          	jal	80000e36 <strlen>
}
    800027ee:	70a2                	ld	ra,40(sp)
    800027f0:	7402                	ld	s0,32(sp)
    800027f2:	64e2                	ld	s1,24(sp)
    800027f4:	6942                	ld	s2,16(sp)
    800027f6:	69a2                	ld	s3,8(sp)
    800027f8:	6145                	addi	sp,sp,48
    800027fa:	8082                	ret
    return -1;
    800027fc:	557d                	li	a0,-1
    800027fe:	bfc5                	j	800027ee <fetchstr+0x2e>

0000000080002800 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002800:	1101                	addi	sp,sp,-32
    80002802:	ec06                	sd	ra,24(sp)
    80002804:	e822                	sd	s0,16(sp)
    80002806:	e426                	sd	s1,8(sp)
    80002808:	1000                	addi	s0,sp,32
    8000280a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000280c:	f0bff0ef          	jal	80002716 <argraw>
    80002810:	c088                	sw	a0,0(s1)
}
    80002812:	60e2                	ld	ra,24(sp)
    80002814:	6442                	ld	s0,16(sp)
    80002816:	64a2                	ld	s1,8(sp)
    80002818:	6105                	addi	sp,sp,32
    8000281a:	8082                	ret

000000008000281c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000281c:	1101                	addi	sp,sp,-32
    8000281e:	ec06                	sd	ra,24(sp)
    80002820:	e822                	sd	s0,16(sp)
    80002822:	e426                	sd	s1,8(sp)
    80002824:	1000                	addi	s0,sp,32
    80002826:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002828:	eefff0ef          	jal	80002716 <argraw>
    8000282c:	e088                	sd	a0,0(s1)
}
    8000282e:	60e2                	ld	ra,24(sp)
    80002830:	6442                	ld	s0,16(sp)
    80002832:	64a2                	ld	s1,8(sp)
    80002834:	6105                	addi	sp,sp,32
    80002836:	8082                	ret

0000000080002838 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002838:	7179                	addi	sp,sp,-48
    8000283a:	f406                	sd	ra,40(sp)
    8000283c:	f022                	sd	s0,32(sp)
    8000283e:	ec26                	sd	s1,24(sp)
    80002840:	e84a                	sd	s2,16(sp)
    80002842:	1800                	addi	s0,sp,48
    80002844:	84ae                	mv	s1,a1
    80002846:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002848:	fd840593          	addi	a1,s0,-40
    8000284c:	fd1ff0ef          	jal	8000281c <argaddr>
  return fetchstr(addr, buf, max);
    80002850:	864a                	mv	a2,s2
    80002852:	85a6                	mv	a1,s1
    80002854:	fd843503          	ld	a0,-40(s0)
    80002858:	f69ff0ef          	jal	800027c0 <fetchstr>
}
    8000285c:	70a2                	ld	ra,40(sp)
    8000285e:	7402                	ld	s0,32(sp)
    80002860:	64e2                	ld	s1,24(sp)
    80002862:	6942                	ld	s2,16(sp)
    80002864:	6145                	addi	sp,sp,48
    80002866:	8082                	ret

0000000080002868 <syscall>:
[SYS_kmemfree] sys_kmemfree,
};

void
syscall(void)
{
    80002868:	1101                	addi	sp,sp,-32
    8000286a:	ec06                	sd	ra,24(sp)
    8000286c:	e822                	sd	s0,16(sp)
    8000286e:	e426                	sd	s1,8(sp)
    80002870:	e04a                	sd	s2,0(sp)
    80002872:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002874:	87eff0ef          	jal	800018f2 <myproc>
    80002878:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000287a:	05853903          	ld	s2,88(a0)
    8000287e:	0a893783          	ld	a5,168(s2)
    80002882:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002886:	37fd                	addiw	a5,a5,-1
    80002888:	4755                	li	a4,21
    8000288a:	00f76f63          	bltu	a4,a5,800028a8 <syscall+0x40>
    8000288e:	00369713          	slli	a4,a3,0x3
    80002892:	00005797          	auipc	a5,0x5
    80002896:	ede78793          	addi	a5,a5,-290 # 80007770 <syscalls>
    8000289a:	97ba                	add	a5,a5,a4
    8000289c:	639c                	ld	a5,0(a5)
    8000289e:	c789                	beqz	a5,800028a8 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800028a0:	9782                	jalr	a5
    800028a2:	06a93823          	sd	a0,112(s2)
    800028a6:	a829                	j	800028c0 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800028a8:	15848613          	addi	a2,s1,344
    800028ac:	588c                	lw	a1,48(s1)
    800028ae:	00005517          	auipc	a0,0x5
    800028b2:	ac250513          	addi	a0,a0,-1342 # 80007370 <etext+0x370>
    800028b6:	c45fd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800028ba:	6cbc                	ld	a5,88(s1)
    800028bc:	577d                	li	a4,-1
    800028be:	fbb8                	sd	a4,112(a5)
  }
}
    800028c0:	60e2                	ld	ra,24(sp)
    800028c2:	6442                	ld	s0,16(sp)
    800028c4:	64a2                	ld	s1,8(sp)
    800028c6:	6902                	ld	s2,0(sp)
    800028c8:	6105                	addi	sp,sp,32
    800028ca:	8082                	ret

00000000800028cc <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    800028cc:	1101                	addi	sp,sp,-32
    800028ce:	ec06                	sd	ra,24(sp)
    800028d0:	e822                	sd	s0,16(sp)
    800028d2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800028d4:	fec40593          	addi	a1,s0,-20
    800028d8:	4501                	li	a0,0
    800028da:	f27ff0ef          	jal	80002800 <argint>
  kexit(n);
    800028de:	fec42503          	lw	a0,-20(s0)
    800028e2:	f26ff0ef          	jal	80002008 <kexit>
  return 0;  // not reached
}
    800028e6:	4501                	li	a0,0
    800028e8:	60e2                	ld	ra,24(sp)
    800028ea:	6442                	ld	s0,16(sp)
    800028ec:	6105                	addi	sp,sp,32
    800028ee:	8082                	ret

00000000800028f0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800028f0:	1141                	addi	sp,sp,-16
    800028f2:	e406                	sd	ra,8(sp)
    800028f4:	e022                	sd	s0,0(sp)
    800028f6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800028f8:	ffbfe0ef          	jal	800018f2 <myproc>
}
    800028fc:	5908                	lw	a0,48(a0)
    800028fe:	60a2                	ld	ra,8(sp)
    80002900:	6402                	ld	s0,0(sp)
    80002902:	0141                	addi	sp,sp,16
    80002904:	8082                	ret

0000000080002906 <sys_fork>:

uint64
sys_fork(void)
{
    80002906:	1141                	addi	sp,sp,-16
    80002908:	e406                	sd	ra,8(sp)
    8000290a:	e022                	sd	s0,0(sp)
    8000290c:	0800                	addi	s0,sp,16
  return kfork();
    8000290e:	b48ff0ef          	jal	80001c56 <kfork>
}
    80002912:	60a2                	ld	ra,8(sp)
    80002914:	6402                	ld	s0,0(sp)
    80002916:	0141                	addi	sp,sp,16
    80002918:	8082                	ret

000000008000291a <sys_wait>:

uint64
sys_wait(void)
{
    8000291a:	1101                	addi	sp,sp,-32
    8000291c:	ec06                	sd	ra,24(sp)
    8000291e:	e822                	sd	s0,16(sp)
    80002920:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002922:	fe840593          	addi	a1,s0,-24
    80002926:	4501                	li	a0,0
    80002928:	ef5ff0ef          	jal	8000281c <argaddr>
  return kwait(p);
    8000292c:	fe843503          	ld	a0,-24(s0)
    80002930:	82fff0ef          	jal	8000215e <kwait>
}
    80002934:	60e2                	ld	ra,24(sp)
    80002936:	6442                	ld	s0,16(sp)
    80002938:	6105                	addi	sp,sp,32
    8000293a:	8082                	ret

000000008000293c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000293c:	7179                	addi	sp,sp,-48
    8000293e:	f406                	sd	ra,40(sp)
    80002940:	f022                	sd	s0,32(sp)
    80002942:	ec26                	sd	s1,24(sp)
    80002944:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002946:	fd840593          	addi	a1,s0,-40
    8000294a:	4501                	li	a0,0
    8000294c:	eb5ff0ef          	jal	80002800 <argint>
  argint(1, &t);
    80002950:	fdc40593          	addi	a1,s0,-36
    80002954:	4505                	li	a0,1
    80002956:	eabff0ef          	jal	80002800 <argint>
  addr = myproc()->sz;
    8000295a:	f99fe0ef          	jal	800018f2 <myproc>
    8000295e:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80002960:	fdc42703          	lw	a4,-36(s0)
    80002964:	4785                	li	a5,1
    80002966:	02f70763          	beq	a4,a5,80002994 <sys_sbrk+0x58>
    8000296a:	fd842783          	lw	a5,-40(s0)
    8000296e:	0207c363          	bltz	a5,80002994 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80002972:	97a6                	add	a5,a5,s1
    80002974:	0297ee63          	bltu	a5,s1,800029b0 <sys_sbrk+0x74>
      return -1;
    if(addr + n > TRAPFRAME)
    80002978:	02000737          	lui	a4,0x2000
    8000297c:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    8000297e:	0736                	slli	a4,a4,0xd
    80002980:	02f76a63          	bltu	a4,a5,800029b4 <sys_sbrk+0x78>
      return -1;
    myproc()->sz += n;
    80002984:	f6ffe0ef          	jal	800018f2 <myproc>
    80002988:	fd842703          	lw	a4,-40(s0)
    8000298c:	653c                	ld	a5,72(a0)
    8000298e:	97ba                	add	a5,a5,a4
    80002990:	e53c                	sd	a5,72(a0)
    80002992:	a039                	j	800029a0 <sys_sbrk+0x64>
    if(growproc(n) < 0) {
    80002994:	fd842503          	lw	a0,-40(s0)
    80002998:	a5cff0ef          	jal	80001bf4 <growproc>
    8000299c:	00054863          	bltz	a0,800029ac <sys_sbrk+0x70>
  }
  return addr;
}
    800029a0:	8526                	mv	a0,s1
    800029a2:	70a2                	ld	ra,40(sp)
    800029a4:	7402                	ld	s0,32(sp)
    800029a6:	64e2                	ld	s1,24(sp)
    800029a8:	6145                	addi	sp,sp,48
    800029aa:	8082                	ret
      return -1;
    800029ac:	54fd                	li	s1,-1
    800029ae:	bfcd                	j	800029a0 <sys_sbrk+0x64>
      return -1;
    800029b0:	54fd                	li	s1,-1
    800029b2:	b7fd                	j	800029a0 <sys_sbrk+0x64>
      return -1;
    800029b4:	54fd                	li	s1,-1
    800029b6:	b7ed                	j	800029a0 <sys_sbrk+0x64>

00000000800029b8 <sys_pause>:

uint64
sys_pause(void)
{
    800029b8:	7139                	addi	sp,sp,-64
    800029ba:	fc06                	sd	ra,56(sp)
    800029bc:	f822                	sd	s0,48(sp)
    800029be:	f04a                	sd	s2,32(sp)
    800029c0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800029c2:	fcc40593          	addi	a1,s0,-52
    800029c6:	4501                	li	a0,0
    800029c8:	e39ff0ef          	jal	80002800 <argint>
  if(n < 0)
    800029cc:	fcc42783          	lw	a5,-52(s0)
    800029d0:	0607c763          	bltz	a5,80002a3e <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    800029d4:	00013517          	auipc	a0,0x13
    800029d8:	dc450513          	addi	a0,a0,-572 # 80015798 <tickslock>
    800029dc:	a16fe0ef          	jal	80000bf2 <acquire>
  ticks0 = ticks;
    800029e0:	00005917          	auipc	s2,0x5
    800029e4:	e8892903          	lw	s2,-376(s2) # 80007868 <ticks>
  while(ticks - ticks0 < n){
    800029e8:	fcc42783          	lw	a5,-52(s0)
    800029ec:	cf8d                	beqz	a5,80002a26 <sys_pause+0x6e>
    800029ee:	f426                	sd	s1,40(sp)
    800029f0:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800029f2:	00013997          	auipc	s3,0x13
    800029f6:	da698993          	addi	s3,s3,-602 # 80015798 <tickslock>
    800029fa:	00005497          	auipc	s1,0x5
    800029fe:	e6e48493          	addi	s1,s1,-402 # 80007868 <ticks>
    if(killed(myproc())){
    80002a02:	ef1fe0ef          	jal	800018f2 <myproc>
    80002a06:	f2eff0ef          	jal	80002134 <killed>
    80002a0a:	ed0d                	bnez	a0,80002a44 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002a0c:	85ce                	mv	a1,s3
    80002a0e:	8526                	mv	a0,s1
    80002a10:	cecff0ef          	jal	80001efc <sleep>
  while(ticks - ticks0 < n){
    80002a14:	409c                	lw	a5,0(s1)
    80002a16:	412787bb          	subw	a5,a5,s2
    80002a1a:	fcc42703          	lw	a4,-52(s0)
    80002a1e:	fee7e2e3          	bltu	a5,a4,80002a02 <sys_pause+0x4a>
    80002a22:	74a2                	ld	s1,40(sp)
    80002a24:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a26:	00013517          	auipc	a0,0x13
    80002a2a:	d7250513          	addi	a0,a0,-654 # 80015798 <tickslock>
    80002a2e:	a5cfe0ef          	jal	80000c8a <release>
  return 0;
    80002a32:	4501                	li	a0,0
}
    80002a34:	70e2                	ld	ra,56(sp)
    80002a36:	7442                	ld	s0,48(sp)
    80002a38:	7902                	ld	s2,32(sp)
    80002a3a:	6121                	addi	sp,sp,64
    80002a3c:	8082                	ret
    n = 0;
    80002a3e:	fc042623          	sw	zero,-52(s0)
    80002a42:	bf49                	j	800029d4 <sys_pause+0x1c>
      release(&tickslock);
    80002a44:	00013517          	auipc	a0,0x13
    80002a48:	d5450513          	addi	a0,a0,-684 # 80015798 <tickslock>
    80002a4c:	a3efe0ef          	jal	80000c8a <release>
      return -1;
    80002a50:	557d                	li	a0,-1
    80002a52:	74a2                	ld	s1,40(sp)
    80002a54:	69e2                	ld	s3,24(sp)
    80002a56:	bff9                	j	80002a34 <sys_pause+0x7c>

0000000080002a58 <sys_kill>:

uint64
sys_kill(void)
{
    80002a58:	1101                	addi	sp,sp,-32
    80002a5a:	ec06                	sd	ra,24(sp)
    80002a5c:	e822                	sd	s0,16(sp)
    80002a5e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002a60:	fec40593          	addi	a1,s0,-20
    80002a64:	4501                	li	a0,0
    80002a66:	d9bff0ef          	jal	80002800 <argint>
  return kkill(pid);
    80002a6a:	fec42503          	lw	a0,-20(s0)
    80002a6e:	e3cff0ef          	jal	800020aa <kkill>
}
    80002a72:	60e2                	ld	ra,24(sp)
    80002a74:	6442                	ld	s0,16(sp)
    80002a76:	6105                	addi	sp,sp,32
    80002a78:	8082                	ret

0000000080002a7a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002a7a:	1101                	addi	sp,sp,-32
    80002a7c:	ec06                	sd	ra,24(sp)
    80002a7e:	e822                	sd	s0,16(sp)
    80002a80:	e426                	sd	s1,8(sp)
    80002a82:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002a84:	00013517          	auipc	a0,0x13
    80002a88:	d1450513          	addi	a0,a0,-748 # 80015798 <tickslock>
    80002a8c:	966fe0ef          	jal	80000bf2 <acquire>
  xticks = ticks;
    80002a90:	00005497          	auipc	s1,0x5
    80002a94:	dd84a483          	lw	s1,-552(s1) # 80007868 <ticks>
  release(&tickslock);
    80002a98:	00013517          	auipc	a0,0x13
    80002a9c:	d0050513          	addi	a0,a0,-768 # 80015798 <tickslock>
    80002aa0:	9eafe0ef          	jal	80000c8a <release>
  return xticks;
}
    80002aa4:	02049513          	slli	a0,s1,0x20
    80002aa8:	9101                	srli	a0,a0,0x20
    80002aaa:	60e2                	ld	ra,24(sp)
    80002aac:	6442                	ld	s0,16(sp)
    80002aae:	64a2                	ld	s1,8(sp)
    80002ab0:	6105                	addi	sp,sp,32
    80002ab2:	8082                	ret

0000000080002ab4 <sys_kmemfree>:

uint64
sys_kmemfree(void)
{
    80002ab4:	1141                	addi	sp,sp,-16
    80002ab6:	e406                	sd	ra,8(sp)
    80002ab8:	e022                	sd	s0,0(sp)
    80002aba:	0800                	addi	s0,sp,16
  return (uint64) kmemfree();
    80002abc:	892fe0ef          	jal	80000b4e <kmemfree>
}
    80002ac0:	60a2                	ld	ra,8(sp)
    80002ac2:	6402                	ld	s0,0(sp)
    80002ac4:	0141                	addi	sp,sp,16
    80002ac6:	8082                	ret

0000000080002ac8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ac8:	7179                	addi	sp,sp,-48
    80002aca:	f406                	sd	ra,40(sp)
    80002acc:	f022                	sd	s0,32(sp)
    80002ace:	ec26                	sd	s1,24(sp)
    80002ad0:	e84a                	sd	s2,16(sp)
    80002ad2:	e44e                	sd	s3,8(sp)
    80002ad4:	e052                	sd	s4,0(sp)
    80002ad6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ad8:	00005597          	auipc	a1,0x5
    80002adc:	8b858593          	addi	a1,a1,-1864 # 80007390 <etext+0x390>
    80002ae0:	00013517          	auipc	a0,0x13
    80002ae4:	cd050513          	addi	a0,a0,-816 # 800157b0 <bcache>
    80002ae8:	88afe0ef          	jal	80000b72 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002aec:	0001b797          	auipc	a5,0x1b
    80002af0:	cc478793          	addi	a5,a5,-828 # 8001d7b0 <bcache+0x8000>
    80002af4:	0001b717          	auipc	a4,0x1b
    80002af8:	f2470713          	addi	a4,a4,-220 # 8001da18 <bcache+0x8268>
    80002afc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002b00:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b04:	00013497          	auipc	s1,0x13
    80002b08:	cc448493          	addi	s1,s1,-828 # 800157c8 <bcache+0x18>
    b->next = bcache.head.next;
    80002b0c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b0e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002b10:	00005a17          	auipc	s4,0x5
    80002b14:	888a0a13          	addi	s4,s4,-1912 # 80007398 <etext+0x398>
    b->next = bcache.head.next;
    80002b18:	2b893783          	ld	a5,696(s2)
    80002b1c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002b1e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002b22:	85d2                	mv	a1,s4
    80002b24:	01048513          	addi	a0,s1,16
    80002b28:	322010ef          	jal	80003e4a <initsleeplock>
    bcache.head.next->prev = b;
    80002b2c:	2b893783          	ld	a5,696(s2)
    80002b30:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002b32:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b36:	45848493          	addi	s1,s1,1112
    80002b3a:	fd349fe3          	bne	s1,s3,80002b18 <binit+0x50>
  }
}
    80002b3e:	70a2                	ld	ra,40(sp)
    80002b40:	7402                	ld	s0,32(sp)
    80002b42:	64e2                	ld	s1,24(sp)
    80002b44:	6942                	ld	s2,16(sp)
    80002b46:	69a2                	ld	s3,8(sp)
    80002b48:	6a02                	ld	s4,0(sp)
    80002b4a:	6145                	addi	sp,sp,48
    80002b4c:	8082                	ret

0000000080002b4e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002b4e:	7179                	addi	sp,sp,-48
    80002b50:	f406                	sd	ra,40(sp)
    80002b52:	f022                	sd	s0,32(sp)
    80002b54:	ec26                	sd	s1,24(sp)
    80002b56:	e84a                	sd	s2,16(sp)
    80002b58:	e44e                	sd	s3,8(sp)
    80002b5a:	1800                	addi	s0,sp,48
    80002b5c:	892a                	mv	s2,a0
    80002b5e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002b60:	00013517          	auipc	a0,0x13
    80002b64:	c5050513          	addi	a0,a0,-944 # 800157b0 <bcache>
    80002b68:	88afe0ef          	jal	80000bf2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002b6c:	0001b497          	auipc	s1,0x1b
    80002b70:	efc4b483          	ld	s1,-260(s1) # 8001da68 <bcache+0x82b8>
    80002b74:	0001b797          	auipc	a5,0x1b
    80002b78:	ea478793          	addi	a5,a5,-348 # 8001da18 <bcache+0x8268>
    80002b7c:	02f48b63          	beq	s1,a5,80002bb2 <bread+0x64>
    80002b80:	873e                	mv	a4,a5
    80002b82:	a021                	j	80002b8a <bread+0x3c>
    80002b84:	68a4                	ld	s1,80(s1)
    80002b86:	02e48663          	beq	s1,a4,80002bb2 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002b8a:	449c                	lw	a5,8(s1)
    80002b8c:	ff279ce3          	bne	a5,s2,80002b84 <bread+0x36>
    80002b90:	44dc                	lw	a5,12(s1)
    80002b92:	ff3799e3          	bne	a5,s3,80002b84 <bread+0x36>
      b->refcnt++;
    80002b96:	40bc                	lw	a5,64(s1)
    80002b98:	2785                	addiw	a5,a5,1
    80002b9a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002b9c:	00013517          	auipc	a0,0x13
    80002ba0:	c1450513          	addi	a0,a0,-1004 # 800157b0 <bcache>
    80002ba4:	8e6fe0ef          	jal	80000c8a <release>
      acquiresleep(&b->lock);
    80002ba8:	01048513          	addi	a0,s1,16
    80002bac:	2d4010ef          	jal	80003e80 <acquiresleep>
      return b;
    80002bb0:	a889                	j	80002c02 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002bb2:	0001b497          	auipc	s1,0x1b
    80002bb6:	eae4b483          	ld	s1,-338(s1) # 8001da60 <bcache+0x82b0>
    80002bba:	0001b797          	auipc	a5,0x1b
    80002bbe:	e5e78793          	addi	a5,a5,-418 # 8001da18 <bcache+0x8268>
    80002bc2:	00f48863          	beq	s1,a5,80002bd2 <bread+0x84>
    80002bc6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002bc8:	40bc                	lw	a5,64(s1)
    80002bca:	cb91                	beqz	a5,80002bde <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002bcc:	64a4                	ld	s1,72(s1)
    80002bce:	fee49de3          	bne	s1,a4,80002bc8 <bread+0x7a>
  panic("bget: no buffers");
    80002bd2:	00004517          	auipc	a0,0x4
    80002bd6:	7ce50513          	addi	a0,a0,1998 # 800073a0 <etext+0x3a0>
    80002bda:	c07fd0ef          	jal	800007e0 <panic>
      b->dev = dev;
    80002bde:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002be2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002be6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002bea:	4785                	li	a5,1
    80002bec:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002bee:	00013517          	auipc	a0,0x13
    80002bf2:	bc250513          	addi	a0,a0,-1086 # 800157b0 <bcache>
    80002bf6:	894fe0ef          	jal	80000c8a <release>
      acquiresleep(&b->lock);
    80002bfa:	01048513          	addi	a0,s1,16
    80002bfe:	282010ef          	jal	80003e80 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002c02:	409c                	lw	a5,0(s1)
    80002c04:	cb89                	beqz	a5,80002c16 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002c06:	8526                	mv	a0,s1
    80002c08:	70a2                	ld	ra,40(sp)
    80002c0a:	7402                	ld	s0,32(sp)
    80002c0c:	64e2                	ld	s1,24(sp)
    80002c0e:	6942                	ld	s2,16(sp)
    80002c10:	69a2                	ld	s3,8(sp)
    80002c12:	6145                	addi	sp,sp,48
    80002c14:	8082                	ret
    virtio_disk_rw(b, 0);
    80002c16:	4581                	li	a1,0
    80002c18:	8526                	mv	a0,s1
    80002c1a:	2d7020ef          	jal	800056f0 <virtio_disk_rw>
    b->valid = 1;
    80002c1e:	4785                	li	a5,1
    80002c20:	c09c                	sw	a5,0(s1)
  return b;
    80002c22:	b7d5                	j	80002c06 <bread+0xb8>

0000000080002c24 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002c24:	1101                	addi	sp,sp,-32
    80002c26:	ec06                	sd	ra,24(sp)
    80002c28:	e822                	sd	s0,16(sp)
    80002c2a:	e426                	sd	s1,8(sp)
    80002c2c:	1000                	addi	s0,sp,32
    80002c2e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c30:	0541                	addi	a0,a0,16
    80002c32:	2cc010ef          	jal	80003efe <holdingsleep>
    80002c36:	c911                	beqz	a0,80002c4a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002c38:	4585                	li	a1,1
    80002c3a:	8526                	mv	a0,s1
    80002c3c:	2b5020ef          	jal	800056f0 <virtio_disk_rw>
}
    80002c40:	60e2                	ld	ra,24(sp)
    80002c42:	6442                	ld	s0,16(sp)
    80002c44:	64a2                	ld	s1,8(sp)
    80002c46:	6105                	addi	sp,sp,32
    80002c48:	8082                	ret
    panic("bwrite");
    80002c4a:	00004517          	auipc	a0,0x4
    80002c4e:	76e50513          	addi	a0,a0,1902 # 800073b8 <etext+0x3b8>
    80002c52:	b8ffd0ef          	jal	800007e0 <panic>

0000000080002c56 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002c56:	1101                	addi	sp,sp,-32
    80002c58:	ec06                	sd	ra,24(sp)
    80002c5a:	e822                	sd	s0,16(sp)
    80002c5c:	e426                	sd	s1,8(sp)
    80002c5e:	e04a                	sd	s2,0(sp)
    80002c60:	1000                	addi	s0,sp,32
    80002c62:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c64:	01050913          	addi	s2,a0,16
    80002c68:	854a                	mv	a0,s2
    80002c6a:	294010ef          	jal	80003efe <holdingsleep>
    80002c6e:	c135                	beqz	a0,80002cd2 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002c70:	854a                	mv	a0,s2
    80002c72:	254010ef          	jal	80003ec6 <releasesleep>

  acquire(&bcache.lock);
    80002c76:	00013517          	auipc	a0,0x13
    80002c7a:	b3a50513          	addi	a0,a0,-1222 # 800157b0 <bcache>
    80002c7e:	f75fd0ef          	jal	80000bf2 <acquire>
  b->refcnt--;
    80002c82:	40bc                	lw	a5,64(s1)
    80002c84:	37fd                	addiw	a5,a5,-1
    80002c86:	0007871b          	sext.w	a4,a5
    80002c8a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002c8c:	e71d                	bnez	a4,80002cba <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002c8e:	68b8                	ld	a4,80(s1)
    80002c90:	64bc                	ld	a5,72(s1)
    80002c92:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002c94:	68b8                	ld	a4,80(s1)
    80002c96:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002c98:	0001b797          	auipc	a5,0x1b
    80002c9c:	b1878793          	addi	a5,a5,-1256 # 8001d7b0 <bcache+0x8000>
    80002ca0:	2b87b703          	ld	a4,696(a5)
    80002ca4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002ca6:	0001b717          	auipc	a4,0x1b
    80002caa:	d7270713          	addi	a4,a4,-654 # 8001da18 <bcache+0x8268>
    80002cae:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002cb0:	2b87b703          	ld	a4,696(a5)
    80002cb4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002cb6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002cba:	00013517          	auipc	a0,0x13
    80002cbe:	af650513          	addi	a0,a0,-1290 # 800157b0 <bcache>
    80002cc2:	fc9fd0ef          	jal	80000c8a <release>
}
    80002cc6:	60e2                	ld	ra,24(sp)
    80002cc8:	6442                	ld	s0,16(sp)
    80002cca:	64a2                	ld	s1,8(sp)
    80002ccc:	6902                	ld	s2,0(sp)
    80002cce:	6105                	addi	sp,sp,32
    80002cd0:	8082                	ret
    panic("brelse");
    80002cd2:	00004517          	auipc	a0,0x4
    80002cd6:	6ee50513          	addi	a0,a0,1774 # 800073c0 <etext+0x3c0>
    80002cda:	b07fd0ef          	jal	800007e0 <panic>

0000000080002cde <bpin>:

void
bpin(struct buf *b) {
    80002cde:	1101                	addi	sp,sp,-32
    80002ce0:	ec06                	sd	ra,24(sp)
    80002ce2:	e822                	sd	s0,16(sp)
    80002ce4:	e426                	sd	s1,8(sp)
    80002ce6:	1000                	addi	s0,sp,32
    80002ce8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002cea:	00013517          	auipc	a0,0x13
    80002cee:	ac650513          	addi	a0,a0,-1338 # 800157b0 <bcache>
    80002cf2:	f01fd0ef          	jal	80000bf2 <acquire>
  b->refcnt++;
    80002cf6:	40bc                	lw	a5,64(s1)
    80002cf8:	2785                	addiw	a5,a5,1
    80002cfa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002cfc:	00013517          	auipc	a0,0x13
    80002d00:	ab450513          	addi	a0,a0,-1356 # 800157b0 <bcache>
    80002d04:	f87fd0ef          	jal	80000c8a <release>
}
    80002d08:	60e2                	ld	ra,24(sp)
    80002d0a:	6442                	ld	s0,16(sp)
    80002d0c:	64a2                	ld	s1,8(sp)
    80002d0e:	6105                	addi	sp,sp,32
    80002d10:	8082                	ret

0000000080002d12 <bunpin>:

void
bunpin(struct buf *b) {
    80002d12:	1101                	addi	sp,sp,-32
    80002d14:	ec06                	sd	ra,24(sp)
    80002d16:	e822                	sd	s0,16(sp)
    80002d18:	e426                	sd	s1,8(sp)
    80002d1a:	1000                	addi	s0,sp,32
    80002d1c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d1e:	00013517          	auipc	a0,0x13
    80002d22:	a9250513          	addi	a0,a0,-1390 # 800157b0 <bcache>
    80002d26:	ecdfd0ef          	jal	80000bf2 <acquire>
  b->refcnt--;
    80002d2a:	40bc                	lw	a5,64(s1)
    80002d2c:	37fd                	addiw	a5,a5,-1
    80002d2e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d30:	00013517          	auipc	a0,0x13
    80002d34:	a8050513          	addi	a0,a0,-1408 # 800157b0 <bcache>
    80002d38:	f53fd0ef          	jal	80000c8a <release>
}
    80002d3c:	60e2                	ld	ra,24(sp)
    80002d3e:	6442                	ld	s0,16(sp)
    80002d40:	64a2                	ld	s1,8(sp)
    80002d42:	6105                	addi	sp,sp,32
    80002d44:	8082                	ret

0000000080002d46 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002d46:	1101                	addi	sp,sp,-32
    80002d48:	ec06                	sd	ra,24(sp)
    80002d4a:	e822                	sd	s0,16(sp)
    80002d4c:	e426                	sd	s1,8(sp)
    80002d4e:	e04a                	sd	s2,0(sp)
    80002d50:	1000                	addi	s0,sp,32
    80002d52:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002d54:	00d5d59b          	srliw	a1,a1,0xd
    80002d58:	0001b797          	auipc	a5,0x1b
    80002d5c:	1347a783          	lw	a5,308(a5) # 8001de8c <sb+0x1c>
    80002d60:	9dbd                	addw	a1,a1,a5
    80002d62:	dedff0ef          	jal	80002b4e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002d66:	0074f713          	andi	a4,s1,7
    80002d6a:	4785                	li	a5,1
    80002d6c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002d70:	14ce                	slli	s1,s1,0x33
    80002d72:	90d9                	srli	s1,s1,0x36
    80002d74:	00950733          	add	a4,a0,s1
    80002d78:	05874703          	lbu	a4,88(a4)
    80002d7c:	00e7f6b3          	and	a3,a5,a4
    80002d80:	c29d                	beqz	a3,80002da6 <bfree+0x60>
    80002d82:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002d84:	94aa                	add	s1,s1,a0
    80002d86:	fff7c793          	not	a5,a5
    80002d8a:	8f7d                	and	a4,a4,a5
    80002d8c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002d90:	7f9000ef          	jal	80003d88 <log_write>
  brelse(bp);
    80002d94:	854a                	mv	a0,s2
    80002d96:	ec1ff0ef          	jal	80002c56 <brelse>
}
    80002d9a:	60e2                	ld	ra,24(sp)
    80002d9c:	6442                	ld	s0,16(sp)
    80002d9e:	64a2                	ld	s1,8(sp)
    80002da0:	6902                	ld	s2,0(sp)
    80002da2:	6105                	addi	sp,sp,32
    80002da4:	8082                	ret
    panic("freeing free block");
    80002da6:	00004517          	auipc	a0,0x4
    80002daa:	62250513          	addi	a0,a0,1570 # 800073c8 <etext+0x3c8>
    80002dae:	a33fd0ef          	jal	800007e0 <panic>

0000000080002db2 <balloc>:
{
    80002db2:	711d                	addi	sp,sp,-96
    80002db4:	ec86                	sd	ra,88(sp)
    80002db6:	e8a2                	sd	s0,80(sp)
    80002db8:	e4a6                	sd	s1,72(sp)
    80002dba:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002dbc:	0001b797          	auipc	a5,0x1b
    80002dc0:	0b87a783          	lw	a5,184(a5) # 8001de74 <sb+0x4>
    80002dc4:	0e078f63          	beqz	a5,80002ec2 <balloc+0x110>
    80002dc8:	e0ca                	sd	s2,64(sp)
    80002dca:	fc4e                	sd	s3,56(sp)
    80002dcc:	f852                	sd	s4,48(sp)
    80002dce:	f456                	sd	s5,40(sp)
    80002dd0:	f05a                	sd	s6,32(sp)
    80002dd2:	ec5e                	sd	s7,24(sp)
    80002dd4:	e862                	sd	s8,16(sp)
    80002dd6:	e466                	sd	s9,8(sp)
    80002dd8:	8baa                	mv	s7,a0
    80002dda:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002ddc:	0001bb17          	auipc	s6,0x1b
    80002de0:	094b0b13          	addi	s6,s6,148 # 8001de70 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002de4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002de6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002de8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002dea:	6c89                	lui	s9,0x2
    80002dec:	a0b5                	j	80002e58 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002dee:	97ca                	add	a5,a5,s2
    80002df0:	8e55                	or	a2,a2,a3
    80002df2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002df6:	854a                	mv	a0,s2
    80002df8:	791000ef          	jal	80003d88 <log_write>
        brelse(bp);
    80002dfc:	854a                	mv	a0,s2
    80002dfe:	e59ff0ef          	jal	80002c56 <brelse>
  bp = bread(dev, bno);
    80002e02:	85a6                	mv	a1,s1
    80002e04:	855e                	mv	a0,s7
    80002e06:	d49ff0ef          	jal	80002b4e <bread>
    80002e0a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002e0c:	40000613          	li	a2,1024
    80002e10:	4581                	li	a1,0
    80002e12:	05850513          	addi	a0,a0,88
    80002e16:	eb1fd0ef          	jal	80000cc6 <memset>
  log_write(bp);
    80002e1a:	854a                	mv	a0,s2
    80002e1c:	76d000ef          	jal	80003d88 <log_write>
  brelse(bp);
    80002e20:	854a                	mv	a0,s2
    80002e22:	e35ff0ef          	jal	80002c56 <brelse>
}
    80002e26:	6906                	ld	s2,64(sp)
    80002e28:	79e2                	ld	s3,56(sp)
    80002e2a:	7a42                	ld	s4,48(sp)
    80002e2c:	7aa2                	ld	s5,40(sp)
    80002e2e:	7b02                	ld	s6,32(sp)
    80002e30:	6be2                	ld	s7,24(sp)
    80002e32:	6c42                	ld	s8,16(sp)
    80002e34:	6ca2                	ld	s9,8(sp)
}
    80002e36:	8526                	mv	a0,s1
    80002e38:	60e6                	ld	ra,88(sp)
    80002e3a:	6446                	ld	s0,80(sp)
    80002e3c:	64a6                	ld	s1,72(sp)
    80002e3e:	6125                	addi	sp,sp,96
    80002e40:	8082                	ret
    brelse(bp);
    80002e42:	854a                	mv	a0,s2
    80002e44:	e13ff0ef          	jal	80002c56 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002e48:	015c87bb          	addw	a5,s9,s5
    80002e4c:	00078a9b          	sext.w	s5,a5
    80002e50:	004b2703          	lw	a4,4(s6)
    80002e54:	04eaff63          	bgeu	s5,a4,80002eb2 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002e58:	41fad79b          	sraiw	a5,s5,0x1f
    80002e5c:	0137d79b          	srliw	a5,a5,0x13
    80002e60:	015787bb          	addw	a5,a5,s5
    80002e64:	40d7d79b          	sraiw	a5,a5,0xd
    80002e68:	01cb2583          	lw	a1,28(s6)
    80002e6c:	9dbd                	addw	a1,a1,a5
    80002e6e:	855e                	mv	a0,s7
    80002e70:	cdfff0ef          	jal	80002b4e <bread>
    80002e74:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e76:	004b2503          	lw	a0,4(s6)
    80002e7a:	000a849b          	sext.w	s1,s5
    80002e7e:	8762                	mv	a4,s8
    80002e80:	fca4f1e3          	bgeu	s1,a0,80002e42 <balloc+0x90>
      m = 1 << (bi % 8);
    80002e84:	00777693          	andi	a3,a4,7
    80002e88:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002e8c:	41f7579b          	sraiw	a5,a4,0x1f
    80002e90:	01d7d79b          	srliw	a5,a5,0x1d
    80002e94:	9fb9                	addw	a5,a5,a4
    80002e96:	4037d79b          	sraiw	a5,a5,0x3
    80002e9a:	00f90633          	add	a2,s2,a5
    80002e9e:	05864603          	lbu	a2,88(a2)
    80002ea2:	00c6f5b3          	and	a1,a3,a2
    80002ea6:	d5a1                	beqz	a1,80002dee <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002ea8:	2705                	addiw	a4,a4,1
    80002eaa:	2485                	addiw	s1,s1,1
    80002eac:	fd471ae3          	bne	a4,s4,80002e80 <balloc+0xce>
    80002eb0:	bf49                	j	80002e42 <balloc+0x90>
    80002eb2:	6906                	ld	s2,64(sp)
    80002eb4:	79e2                	ld	s3,56(sp)
    80002eb6:	7a42                	ld	s4,48(sp)
    80002eb8:	7aa2                	ld	s5,40(sp)
    80002eba:	7b02                	ld	s6,32(sp)
    80002ebc:	6be2                	ld	s7,24(sp)
    80002ebe:	6c42                	ld	s8,16(sp)
    80002ec0:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002ec2:	00004517          	auipc	a0,0x4
    80002ec6:	51e50513          	addi	a0,a0,1310 # 800073e0 <etext+0x3e0>
    80002eca:	e30fd0ef          	jal	800004fa <printf>
  return 0;
    80002ece:	4481                	li	s1,0
    80002ed0:	b79d                	j	80002e36 <balloc+0x84>

0000000080002ed2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002ed2:	7179                	addi	sp,sp,-48
    80002ed4:	f406                	sd	ra,40(sp)
    80002ed6:	f022                	sd	s0,32(sp)
    80002ed8:	ec26                	sd	s1,24(sp)
    80002eda:	e84a                	sd	s2,16(sp)
    80002edc:	e44e                	sd	s3,8(sp)
    80002ede:	1800                	addi	s0,sp,48
    80002ee0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002ee2:	47ad                	li	a5,11
    80002ee4:	02b7e663          	bltu	a5,a1,80002f10 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002ee8:	02059793          	slli	a5,a1,0x20
    80002eec:	01e7d593          	srli	a1,a5,0x1e
    80002ef0:	00b504b3          	add	s1,a0,a1
    80002ef4:	0504a903          	lw	s2,80(s1)
    80002ef8:	06091a63          	bnez	s2,80002f6c <bmap+0x9a>
      addr = balloc(ip->dev);
    80002efc:	4108                	lw	a0,0(a0)
    80002efe:	eb5ff0ef          	jal	80002db2 <balloc>
    80002f02:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002f06:	06090363          	beqz	s2,80002f6c <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002f0a:	0524a823          	sw	s2,80(s1)
    80002f0e:	a8b9                	j	80002f6c <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002f10:	ff45849b          	addiw	s1,a1,-12
    80002f14:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002f18:	0ff00793          	li	a5,255
    80002f1c:	06e7ee63          	bltu	a5,a4,80002f98 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002f20:	08052903          	lw	s2,128(a0)
    80002f24:	00091d63          	bnez	s2,80002f3e <bmap+0x6c>
      addr = balloc(ip->dev);
    80002f28:	4108                	lw	a0,0(a0)
    80002f2a:	e89ff0ef          	jal	80002db2 <balloc>
    80002f2e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002f32:	02090d63          	beqz	s2,80002f6c <bmap+0x9a>
    80002f36:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002f38:	0929a023          	sw	s2,128(s3)
    80002f3c:	a011                	j	80002f40 <bmap+0x6e>
    80002f3e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002f40:	85ca                	mv	a1,s2
    80002f42:	0009a503          	lw	a0,0(s3)
    80002f46:	c09ff0ef          	jal	80002b4e <bread>
    80002f4a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002f4c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002f50:	02049713          	slli	a4,s1,0x20
    80002f54:	01e75593          	srli	a1,a4,0x1e
    80002f58:	00b784b3          	add	s1,a5,a1
    80002f5c:	0004a903          	lw	s2,0(s1)
    80002f60:	00090e63          	beqz	s2,80002f7c <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002f64:	8552                	mv	a0,s4
    80002f66:	cf1ff0ef          	jal	80002c56 <brelse>
    return addr;
    80002f6a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002f6c:	854a                	mv	a0,s2
    80002f6e:	70a2                	ld	ra,40(sp)
    80002f70:	7402                	ld	s0,32(sp)
    80002f72:	64e2                	ld	s1,24(sp)
    80002f74:	6942                	ld	s2,16(sp)
    80002f76:	69a2                	ld	s3,8(sp)
    80002f78:	6145                	addi	sp,sp,48
    80002f7a:	8082                	ret
      addr = balloc(ip->dev);
    80002f7c:	0009a503          	lw	a0,0(s3)
    80002f80:	e33ff0ef          	jal	80002db2 <balloc>
    80002f84:	0005091b          	sext.w	s2,a0
      if(addr){
    80002f88:	fc090ee3          	beqz	s2,80002f64 <bmap+0x92>
        a[bn] = addr;
    80002f8c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002f90:	8552                	mv	a0,s4
    80002f92:	5f7000ef          	jal	80003d88 <log_write>
    80002f96:	b7f9                	j	80002f64 <bmap+0x92>
    80002f98:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002f9a:	00004517          	auipc	a0,0x4
    80002f9e:	45e50513          	addi	a0,a0,1118 # 800073f8 <etext+0x3f8>
    80002fa2:	83ffd0ef          	jal	800007e0 <panic>

0000000080002fa6 <iget>:
{
    80002fa6:	7179                	addi	sp,sp,-48
    80002fa8:	f406                	sd	ra,40(sp)
    80002faa:	f022                	sd	s0,32(sp)
    80002fac:	ec26                	sd	s1,24(sp)
    80002fae:	e84a                	sd	s2,16(sp)
    80002fb0:	e44e                	sd	s3,8(sp)
    80002fb2:	e052                	sd	s4,0(sp)
    80002fb4:	1800                	addi	s0,sp,48
    80002fb6:	89aa                	mv	s3,a0
    80002fb8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002fba:	0001b517          	auipc	a0,0x1b
    80002fbe:	ed650513          	addi	a0,a0,-298 # 8001de90 <itable>
    80002fc2:	c31fd0ef          	jal	80000bf2 <acquire>
  empty = 0;
    80002fc6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002fc8:	0001b497          	auipc	s1,0x1b
    80002fcc:	ee048493          	addi	s1,s1,-288 # 8001dea8 <itable+0x18>
    80002fd0:	0001d697          	auipc	a3,0x1d
    80002fd4:	96868693          	addi	a3,a3,-1688 # 8001f938 <log>
    80002fd8:	a039                	j	80002fe6 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002fda:	02090963          	beqz	s2,8000300c <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002fde:	08848493          	addi	s1,s1,136
    80002fe2:	02d48863          	beq	s1,a3,80003012 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002fe6:	449c                	lw	a5,8(s1)
    80002fe8:	fef059e3          	blez	a5,80002fda <iget+0x34>
    80002fec:	4098                	lw	a4,0(s1)
    80002fee:	ff3716e3          	bne	a4,s3,80002fda <iget+0x34>
    80002ff2:	40d8                	lw	a4,4(s1)
    80002ff4:	ff4713e3          	bne	a4,s4,80002fda <iget+0x34>
      ip->ref++;
    80002ff8:	2785                	addiw	a5,a5,1
    80002ffa:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002ffc:	0001b517          	auipc	a0,0x1b
    80003000:	e9450513          	addi	a0,a0,-364 # 8001de90 <itable>
    80003004:	c87fd0ef          	jal	80000c8a <release>
      return ip;
    80003008:	8926                	mv	s2,s1
    8000300a:	a02d                	j	80003034 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000300c:	fbe9                	bnez	a5,80002fde <iget+0x38>
      empty = ip;
    8000300e:	8926                	mv	s2,s1
    80003010:	b7f9                	j	80002fde <iget+0x38>
  if(empty == 0)
    80003012:	02090a63          	beqz	s2,80003046 <iget+0xa0>
  ip->dev = dev;
    80003016:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000301a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000301e:	4785                	li	a5,1
    80003020:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003024:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003028:	0001b517          	auipc	a0,0x1b
    8000302c:	e6850513          	addi	a0,a0,-408 # 8001de90 <itable>
    80003030:	c5bfd0ef          	jal	80000c8a <release>
}
    80003034:	854a                	mv	a0,s2
    80003036:	70a2                	ld	ra,40(sp)
    80003038:	7402                	ld	s0,32(sp)
    8000303a:	64e2                	ld	s1,24(sp)
    8000303c:	6942                	ld	s2,16(sp)
    8000303e:	69a2                	ld	s3,8(sp)
    80003040:	6a02                	ld	s4,0(sp)
    80003042:	6145                	addi	sp,sp,48
    80003044:	8082                	ret
    panic("iget: no inodes");
    80003046:	00004517          	auipc	a0,0x4
    8000304a:	3ca50513          	addi	a0,a0,970 # 80007410 <etext+0x410>
    8000304e:	f92fd0ef          	jal	800007e0 <panic>

0000000080003052 <iinit>:
{
    80003052:	7179                	addi	sp,sp,-48
    80003054:	f406                	sd	ra,40(sp)
    80003056:	f022                	sd	s0,32(sp)
    80003058:	ec26                	sd	s1,24(sp)
    8000305a:	e84a                	sd	s2,16(sp)
    8000305c:	e44e                	sd	s3,8(sp)
    8000305e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003060:	00004597          	auipc	a1,0x4
    80003064:	3c058593          	addi	a1,a1,960 # 80007420 <etext+0x420>
    80003068:	0001b517          	auipc	a0,0x1b
    8000306c:	e2850513          	addi	a0,a0,-472 # 8001de90 <itable>
    80003070:	b03fd0ef          	jal	80000b72 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003074:	0001b497          	auipc	s1,0x1b
    80003078:	e4448493          	addi	s1,s1,-444 # 8001deb8 <itable+0x28>
    8000307c:	0001d997          	auipc	s3,0x1d
    80003080:	8cc98993          	addi	s3,s3,-1844 # 8001f948 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003084:	00004917          	auipc	s2,0x4
    80003088:	3a490913          	addi	s2,s2,932 # 80007428 <etext+0x428>
    8000308c:	85ca                	mv	a1,s2
    8000308e:	8526                	mv	a0,s1
    80003090:	5bb000ef          	jal	80003e4a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003094:	08848493          	addi	s1,s1,136
    80003098:	ff349ae3          	bne	s1,s3,8000308c <iinit+0x3a>
}
    8000309c:	70a2                	ld	ra,40(sp)
    8000309e:	7402                	ld	s0,32(sp)
    800030a0:	64e2                	ld	s1,24(sp)
    800030a2:	6942                	ld	s2,16(sp)
    800030a4:	69a2                	ld	s3,8(sp)
    800030a6:	6145                	addi	sp,sp,48
    800030a8:	8082                	ret

00000000800030aa <ialloc>:
{
    800030aa:	7139                	addi	sp,sp,-64
    800030ac:	fc06                	sd	ra,56(sp)
    800030ae:	f822                	sd	s0,48(sp)
    800030b0:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800030b2:	0001b717          	auipc	a4,0x1b
    800030b6:	dca72703          	lw	a4,-566(a4) # 8001de7c <sb+0xc>
    800030ba:	4785                	li	a5,1
    800030bc:	06e7f063          	bgeu	a5,a4,8000311c <ialloc+0x72>
    800030c0:	f426                	sd	s1,40(sp)
    800030c2:	f04a                	sd	s2,32(sp)
    800030c4:	ec4e                	sd	s3,24(sp)
    800030c6:	e852                	sd	s4,16(sp)
    800030c8:	e456                	sd	s5,8(sp)
    800030ca:	e05a                	sd	s6,0(sp)
    800030cc:	8aaa                	mv	s5,a0
    800030ce:	8b2e                	mv	s6,a1
    800030d0:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800030d2:	0001ba17          	auipc	s4,0x1b
    800030d6:	d9ea0a13          	addi	s4,s4,-610 # 8001de70 <sb>
    800030da:	00495593          	srli	a1,s2,0x4
    800030de:	018a2783          	lw	a5,24(s4)
    800030e2:	9dbd                	addw	a1,a1,a5
    800030e4:	8556                	mv	a0,s5
    800030e6:	a69ff0ef          	jal	80002b4e <bread>
    800030ea:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800030ec:	05850993          	addi	s3,a0,88
    800030f0:	00f97793          	andi	a5,s2,15
    800030f4:	079a                	slli	a5,a5,0x6
    800030f6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800030f8:	00099783          	lh	a5,0(s3)
    800030fc:	cb9d                	beqz	a5,80003132 <ialloc+0x88>
    brelse(bp);
    800030fe:	b59ff0ef          	jal	80002c56 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003102:	0905                	addi	s2,s2,1
    80003104:	00ca2703          	lw	a4,12(s4)
    80003108:	0009079b          	sext.w	a5,s2
    8000310c:	fce7e7e3          	bltu	a5,a4,800030da <ialloc+0x30>
    80003110:	74a2                	ld	s1,40(sp)
    80003112:	7902                	ld	s2,32(sp)
    80003114:	69e2                	ld	s3,24(sp)
    80003116:	6a42                	ld	s4,16(sp)
    80003118:	6aa2                	ld	s5,8(sp)
    8000311a:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000311c:	00004517          	auipc	a0,0x4
    80003120:	31450513          	addi	a0,a0,788 # 80007430 <etext+0x430>
    80003124:	bd6fd0ef          	jal	800004fa <printf>
  return 0;
    80003128:	4501                	li	a0,0
}
    8000312a:	70e2                	ld	ra,56(sp)
    8000312c:	7442                	ld	s0,48(sp)
    8000312e:	6121                	addi	sp,sp,64
    80003130:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003132:	04000613          	li	a2,64
    80003136:	4581                	li	a1,0
    80003138:	854e                	mv	a0,s3
    8000313a:	b8dfd0ef          	jal	80000cc6 <memset>
      dip->type = type;
    8000313e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003142:	8526                	mv	a0,s1
    80003144:	445000ef          	jal	80003d88 <log_write>
      brelse(bp);
    80003148:	8526                	mv	a0,s1
    8000314a:	b0dff0ef          	jal	80002c56 <brelse>
      return iget(dev, inum);
    8000314e:	0009059b          	sext.w	a1,s2
    80003152:	8556                	mv	a0,s5
    80003154:	e53ff0ef          	jal	80002fa6 <iget>
    80003158:	74a2                	ld	s1,40(sp)
    8000315a:	7902                	ld	s2,32(sp)
    8000315c:	69e2                	ld	s3,24(sp)
    8000315e:	6a42                	ld	s4,16(sp)
    80003160:	6aa2                	ld	s5,8(sp)
    80003162:	6b02                	ld	s6,0(sp)
    80003164:	b7d9                	j	8000312a <ialloc+0x80>

0000000080003166 <iupdate>:
{
    80003166:	1101                	addi	sp,sp,-32
    80003168:	ec06                	sd	ra,24(sp)
    8000316a:	e822                	sd	s0,16(sp)
    8000316c:	e426                	sd	s1,8(sp)
    8000316e:	e04a                	sd	s2,0(sp)
    80003170:	1000                	addi	s0,sp,32
    80003172:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003174:	415c                	lw	a5,4(a0)
    80003176:	0047d79b          	srliw	a5,a5,0x4
    8000317a:	0001b597          	auipc	a1,0x1b
    8000317e:	d0e5a583          	lw	a1,-754(a1) # 8001de88 <sb+0x18>
    80003182:	9dbd                	addw	a1,a1,a5
    80003184:	4108                	lw	a0,0(a0)
    80003186:	9c9ff0ef          	jal	80002b4e <bread>
    8000318a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000318c:	05850793          	addi	a5,a0,88
    80003190:	40d8                	lw	a4,4(s1)
    80003192:	8b3d                	andi	a4,a4,15
    80003194:	071a                	slli	a4,a4,0x6
    80003196:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003198:	04449703          	lh	a4,68(s1)
    8000319c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800031a0:	04649703          	lh	a4,70(s1)
    800031a4:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800031a8:	04849703          	lh	a4,72(s1)
    800031ac:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800031b0:	04a49703          	lh	a4,74(s1)
    800031b4:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800031b8:	44f8                	lw	a4,76(s1)
    800031ba:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800031bc:	03400613          	li	a2,52
    800031c0:	05048593          	addi	a1,s1,80
    800031c4:	00c78513          	addi	a0,a5,12
    800031c8:	b5bfd0ef          	jal	80000d22 <memmove>
  log_write(bp);
    800031cc:	854a                	mv	a0,s2
    800031ce:	3bb000ef          	jal	80003d88 <log_write>
  brelse(bp);
    800031d2:	854a                	mv	a0,s2
    800031d4:	a83ff0ef          	jal	80002c56 <brelse>
}
    800031d8:	60e2                	ld	ra,24(sp)
    800031da:	6442                	ld	s0,16(sp)
    800031dc:	64a2                	ld	s1,8(sp)
    800031de:	6902                	ld	s2,0(sp)
    800031e0:	6105                	addi	sp,sp,32
    800031e2:	8082                	ret

00000000800031e4 <idup>:
{
    800031e4:	1101                	addi	sp,sp,-32
    800031e6:	ec06                	sd	ra,24(sp)
    800031e8:	e822                	sd	s0,16(sp)
    800031ea:	e426                	sd	s1,8(sp)
    800031ec:	1000                	addi	s0,sp,32
    800031ee:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800031f0:	0001b517          	auipc	a0,0x1b
    800031f4:	ca050513          	addi	a0,a0,-864 # 8001de90 <itable>
    800031f8:	9fbfd0ef          	jal	80000bf2 <acquire>
  ip->ref++;
    800031fc:	449c                	lw	a5,8(s1)
    800031fe:	2785                	addiw	a5,a5,1
    80003200:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003202:	0001b517          	auipc	a0,0x1b
    80003206:	c8e50513          	addi	a0,a0,-882 # 8001de90 <itable>
    8000320a:	a81fd0ef          	jal	80000c8a <release>
}
    8000320e:	8526                	mv	a0,s1
    80003210:	60e2                	ld	ra,24(sp)
    80003212:	6442                	ld	s0,16(sp)
    80003214:	64a2                	ld	s1,8(sp)
    80003216:	6105                	addi	sp,sp,32
    80003218:	8082                	ret

000000008000321a <ilock>:
{
    8000321a:	1101                	addi	sp,sp,-32
    8000321c:	ec06                	sd	ra,24(sp)
    8000321e:	e822                	sd	s0,16(sp)
    80003220:	e426                	sd	s1,8(sp)
    80003222:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003224:	cd19                	beqz	a0,80003242 <ilock+0x28>
    80003226:	84aa                	mv	s1,a0
    80003228:	451c                	lw	a5,8(a0)
    8000322a:	00f05c63          	blez	a5,80003242 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000322e:	0541                	addi	a0,a0,16
    80003230:	451000ef          	jal	80003e80 <acquiresleep>
  if(ip->valid == 0){
    80003234:	40bc                	lw	a5,64(s1)
    80003236:	cf89                	beqz	a5,80003250 <ilock+0x36>
}
    80003238:	60e2                	ld	ra,24(sp)
    8000323a:	6442                	ld	s0,16(sp)
    8000323c:	64a2                	ld	s1,8(sp)
    8000323e:	6105                	addi	sp,sp,32
    80003240:	8082                	ret
    80003242:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003244:	00004517          	auipc	a0,0x4
    80003248:	20450513          	addi	a0,a0,516 # 80007448 <etext+0x448>
    8000324c:	d94fd0ef          	jal	800007e0 <panic>
    80003250:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003252:	40dc                	lw	a5,4(s1)
    80003254:	0047d79b          	srliw	a5,a5,0x4
    80003258:	0001b597          	auipc	a1,0x1b
    8000325c:	c305a583          	lw	a1,-976(a1) # 8001de88 <sb+0x18>
    80003260:	9dbd                	addw	a1,a1,a5
    80003262:	4088                	lw	a0,0(s1)
    80003264:	8ebff0ef          	jal	80002b4e <bread>
    80003268:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000326a:	05850593          	addi	a1,a0,88
    8000326e:	40dc                	lw	a5,4(s1)
    80003270:	8bbd                	andi	a5,a5,15
    80003272:	079a                	slli	a5,a5,0x6
    80003274:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003276:	00059783          	lh	a5,0(a1)
    8000327a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000327e:	00259783          	lh	a5,2(a1)
    80003282:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003286:	00459783          	lh	a5,4(a1)
    8000328a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000328e:	00659783          	lh	a5,6(a1)
    80003292:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003296:	459c                	lw	a5,8(a1)
    80003298:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000329a:	03400613          	li	a2,52
    8000329e:	05b1                	addi	a1,a1,12
    800032a0:	05048513          	addi	a0,s1,80
    800032a4:	a7ffd0ef          	jal	80000d22 <memmove>
    brelse(bp);
    800032a8:	854a                	mv	a0,s2
    800032aa:	9adff0ef          	jal	80002c56 <brelse>
    ip->valid = 1;
    800032ae:	4785                	li	a5,1
    800032b0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800032b2:	04449783          	lh	a5,68(s1)
    800032b6:	c399                	beqz	a5,800032bc <ilock+0xa2>
    800032b8:	6902                	ld	s2,0(sp)
    800032ba:	bfbd                	j	80003238 <ilock+0x1e>
      panic("ilock: no type");
    800032bc:	00004517          	auipc	a0,0x4
    800032c0:	19450513          	addi	a0,a0,404 # 80007450 <etext+0x450>
    800032c4:	d1cfd0ef          	jal	800007e0 <panic>

00000000800032c8 <iunlock>:
{
    800032c8:	1101                	addi	sp,sp,-32
    800032ca:	ec06                	sd	ra,24(sp)
    800032cc:	e822                	sd	s0,16(sp)
    800032ce:	e426                	sd	s1,8(sp)
    800032d0:	e04a                	sd	s2,0(sp)
    800032d2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800032d4:	c505                	beqz	a0,800032fc <iunlock+0x34>
    800032d6:	84aa                	mv	s1,a0
    800032d8:	01050913          	addi	s2,a0,16
    800032dc:	854a                	mv	a0,s2
    800032de:	421000ef          	jal	80003efe <holdingsleep>
    800032e2:	cd09                	beqz	a0,800032fc <iunlock+0x34>
    800032e4:	449c                	lw	a5,8(s1)
    800032e6:	00f05b63          	blez	a5,800032fc <iunlock+0x34>
  releasesleep(&ip->lock);
    800032ea:	854a                	mv	a0,s2
    800032ec:	3db000ef          	jal	80003ec6 <releasesleep>
}
    800032f0:	60e2                	ld	ra,24(sp)
    800032f2:	6442                	ld	s0,16(sp)
    800032f4:	64a2                	ld	s1,8(sp)
    800032f6:	6902                	ld	s2,0(sp)
    800032f8:	6105                	addi	sp,sp,32
    800032fa:	8082                	ret
    panic("iunlock");
    800032fc:	00004517          	auipc	a0,0x4
    80003300:	16450513          	addi	a0,a0,356 # 80007460 <etext+0x460>
    80003304:	cdcfd0ef          	jal	800007e0 <panic>

0000000080003308 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003308:	7179                	addi	sp,sp,-48
    8000330a:	f406                	sd	ra,40(sp)
    8000330c:	f022                	sd	s0,32(sp)
    8000330e:	ec26                	sd	s1,24(sp)
    80003310:	e84a                	sd	s2,16(sp)
    80003312:	e44e                	sd	s3,8(sp)
    80003314:	1800                	addi	s0,sp,48
    80003316:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003318:	05050493          	addi	s1,a0,80
    8000331c:	08050913          	addi	s2,a0,128
    80003320:	a021                	j	80003328 <itrunc+0x20>
    80003322:	0491                	addi	s1,s1,4
    80003324:	01248b63          	beq	s1,s2,8000333a <itrunc+0x32>
    if(ip->addrs[i]){
    80003328:	408c                	lw	a1,0(s1)
    8000332a:	dde5                	beqz	a1,80003322 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000332c:	0009a503          	lw	a0,0(s3)
    80003330:	a17ff0ef          	jal	80002d46 <bfree>
      ip->addrs[i] = 0;
    80003334:	0004a023          	sw	zero,0(s1)
    80003338:	b7ed                	j	80003322 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000333a:	0809a583          	lw	a1,128(s3)
    8000333e:	ed89                	bnez	a1,80003358 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003340:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003344:	854e                	mv	a0,s3
    80003346:	e21ff0ef          	jal	80003166 <iupdate>
}
    8000334a:	70a2                	ld	ra,40(sp)
    8000334c:	7402                	ld	s0,32(sp)
    8000334e:	64e2                	ld	s1,24(sp)
    80003350:	6942                	ld	s2,16(sp)
    80003352:	69a2                	ld	s3,8(sp)
    80003354:	6145                	addi	sp,sp,48
    80003356:	8082                	ret
    80003358:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000335a:	0009a503          	lw	a0,0(s3)
    8000335e:	ff0ff0ef          	jal	80002b4e <bread>
    80003362:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003364:	05850493          	addi	s1,a0,88
    80003368:	45850913          	addi	s2,a0,1112
    8000336c:	a021                	j	80003374 <itrunc+0x6c>
    8000336e:	0491                	addi	s1,s1,4
    80003370:	01248963          	beq	s1,s2,80003382 <itrunc+0x7a>
      if(a[j])
    80003374:	408c                	lw	a1,0(s1)
    80003376:	dde5                	beqz	a1,8000336e <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003378:	0009a503          	lw	a0,0(s3)
    8000337c:	9cbff0ef          	jal	80002d46 <bfree>
    80003380:	b7fd                	j	8000336e <itrunc+0x66>
    brelse(bp);
    80003382:	8552                	mv	a0,s4
    80003384:	8d3ff0ef          	jal	80002c56 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003388:	0809a583          	lw	a1,128(s3)
    8000338c:	0009a503          	lw	a0,0(s3)
    80003390:	9b7ff0ef          	jal	80002d46 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003394:	0809a023          	sw	zero,128(s3)
    80003398:	6a02                	ld	s4,0(sp)
    8000339a:	b75d                	j	80003340 <itrunc+0x38>

000000008000339c <iput>:
{
    8000339c:	1101                	addi	sp,sp,-32
    8000339e:	ec06                	sd	ra,24(sp)
    800033a0:	e822                	sd	s0,16(sp)
    800033a2:	e426                	sd	s1,8(sp)
    800033a4:	1000                	addi	s0,sp,32
    800033a6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800033a8:	0001b517          	auipc	a0,0x1b
    800033ac:	ae850513          	addi	a0,a0,-1304 # 8001de90 <itable>
    800033b0:	843fd0ef          	jal	80000bf2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800033b4:	4498                	lw	a4,8(s1)
    800033b6:	4785                	li	a5,1
    800033b8:	02f70063          	beq	a4,a5,800033d8 <iput+0x3c>
  ip->ref--;
    800033bc:	449c                	lw	a5,8(s1)
    800033be:	37fd                	addiw	a5,a5,-1
    800033c0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800033c2:	0001b517          	auipc	a0,0x1b
    800033c6:	ace50513          	addi	a0,a0,-1330 # 8001de90 <itable>
    800033ca:	8c1fd0ef          	jal	80000c8a <release>
}
    800033ce:	60e2                	ld	ra,24(sp)
    800033d0:	6442                	ld	s0,16(sp)
    800033d2:	64a2                	ld	s1,8(sp)
    800033d4:	6105                	addi	sp,sp,32
    800033d6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800033d8:	40bc                	lw	a5,64(s1)
    800033da:	d3ed                	beqz	a5,800033bc <iput+0x20>
    800033dc:	04a49783          	lh	a5,74(s1)
    800033e0:	fff1                	bnez	a5,800033bc <iput+0x20>
    800033e2:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800033e4:	01048913          	addi	s2,s1,16
    800033e8:	854a                	mv	a0,s2
    800033ea:	297000ef          	jal	80003e80 <acquiresleep>
    release(&itable.lock);
    800033ee:	0001b517          	auipc	a0,0x1b
    800033f2:	aa250513          	addi	a0,a0,-1374 # 8001de90 <itable>
    800033f6:	895fd0ef          	jal	80000c8a <release>
    itrunc(ip);
    800033fa:	8526                	mv	a0,s1
    800033fc:	f0dff0ef          	jal	80003308 <itrunc>
    ip->type = 0;
    80003400:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003404:	8526                	mv	a0,s1
    80003406:	d61ff0ef          	jal	80003166 <iupdate>
    ip->valid = 0;
    8000340a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000340e:	854a                	mv	a0,s2
    80003410:	2b7000ef          	jal	80003ec6 <releasesleep>
    acquire(&itable.lock);
    80003414:	0001b517          	auipc	a0,0x1b
    80003418:	a7c50513          	addi	a0,a0,-1412 # 8001de90 <itable>
    8000341c:	fd6fd0ef          	jal	80000bf2 <acquire>
    80003420:	6902                	ld	s2,0(sp)
    80003422:	bf69                	j	800033bc <iput+0x20>

0000000080003424 <iunlockput>:
{
    80003424:	1101                	addi	sp,sp,-32
    80003426:	ec06                	sd	ra,24(sp)
    80003428:	e822                	sd	s0,16(sp)
    8000342a:	e426                	sd	s1,8(sp)
    8000342c:	1000                	addi	s0,sp,32
    8000342e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003430:	e99ff0ef          	jal	800032c8 <iunlock>
  iput(ip);
    80003434:	8526                	mv	a0,s1
    80003436:	f67ff0ef          	jal	8000339c <iput>
}
    8000343a:	60e2                	ld	ra,24(sp)
    8000343c:	6442                	ld	s0,16(sp)
    8000343e:	64a2                	ld	s1,8(sp)
    80003440:	6105                	addi	sp,sp,32
    80003442:	8082                	ret

0000000080003444 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003444:	0001b717          	auipc	a4,0x1b
    80003448:	a3872703          	lw	a4,-1480(a4) # 8001de7c <sb+0xc>
    8000344c:	4785                	li	a5,1
    8000344e:	0ae7ff63          	bgeu	a5,a4,8000350c <ireclaim+0xc8>
{
    80003452:	7139                	addi	sp,sp,-64
    80003454:	fc06                	sd	ra,56(sp)
    80003456:	f822                	sd	s0,48(sp)
    80003458:	f426                	sd	s1,40(sp)
    8000345a:	f04a                	sd	s2,32(sp)
    8000345c:	ec4e                	sd	s3,24(sp)
    8000345e:	e852                	sd	s4,16(sp)
    80003460:	e456                	sd	s5,8(sp)
    80003462:	e05a                	sd	s6,0(sp)
    80003464:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003466:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003468:	00050a1b          	sext.w	s4,a0
    8000346c:	0001ba97          	auipc	s5,0x1b
    80003470:	a04a8a93          	addi	s5,s5,-1532 # 8001de70 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003474:	00004b17          	auipc	s6,0x4
    80003478:	ff4b0b13          	addi	s6,s6,-12 # 80007468 <etext+0x468>
    8000347c:	a099                	j	800034c2 <ireclaim+0x7e>
    8000347e:	85ce                	mv	a1,s3
    80003480:	855a                	mv	a0,s6
    80003482:	878fd0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    80003486:	85ce                	mv	a1,s3
    80003488:	8552                	mv	a0,s4
    8000348a:	b1dff0ef          	jal	80002fa6 <iget>
    8000348e:	89aa                	mv	s3,a0
    brelse(bp);
    80003490:	854a                	mv	a0,s2
    80003492:	fc4ff0ef          	jal	80002c56 <brelse>
    if (ip) {
    80003496:	00098f63          	beqz	s3,800034b4 <ireclaim+0x70>
      begin_op();
    8000349a:	76a000ef          	jal	80003c04 <begin_op>
      ilock(ip);
    8000349e:	854e                	mv	a0,s3
    800034a0:	d7bff0ef          	jal	8000321a <ilock>
      iunlock(ip);
    800034a4:	854e                	mv	a0,s3
    800034a6:	e23ff0ef          	jal	800032c8 <iunlock>
      iput(ip);
    800034aa:	854e                	mv	a0,s3
    800034ac:	ef1ff0ef          	jal	8000339c <iput>
      end_op();
    800034b0:	7be000ef          	jal	80003c6e <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800034b4:	0485                	addi	s1,s1,1
    800034b6:	00caa703          	lw	a4,12(s5)
    800034ba:	0004879b          	sext.w	a5,s1
    800034be:	02e7fd63          	bgeu	a5,a4,800034f8 <ireclaim+0xb4>
    800034c2:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800034c6:	0044d593          	srli	a1,s1,0x4
    800034ca:	018aa783          	lw	a5,24(s5)
    800034ce:	9dbd                	addw	a1,a1,a5
    800034d0:	8552                	mv	a0,s4
    800034d2:	e7cff0ef          	jal	80002b4e <bread>
    800034d6:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800034d8:	05850793          	addi	a5,a0,88
    800034dc:	00f9f713          	andi	a4,s3,15
    800034e0:	071a                	slli	a4,a4,0x6
    800034e2:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800034e4:	00079703          	lh	a4,0(a5)
    800034e8:	c701                	beqz	a4,800034f0 <ireclaim+0xac>
    800034ea:	00679783          	lh	a5,6(a5)
    800034ee:	dbc1                	beqz	a5,8000347e <ireclaim+0x3a>
    brelse(bp);
    800034f0:	854a                	mv	a0,s2
    800034f2:	f64ff0ef          	jal	80002c56 <brelse>
    if (ip) {
    800034f6:	bf7d                	j	800034b4 <ireclaim+0x70>
}
    800034f8:	70e2                	ld	ra,56(sp)
    800034fa:	7442                	ld	s0,48(sp)
    800034fc:	74a2                	ld	s1,40(sp)
    800034fe:	7902                	ld	s2,32(sp)
    80003500:	69e2                	ld	s3,24(sp)
    80003502:	6a42                	ld	s4,16(sp)
    80003504:	6aa2                	ld	s5,8(sp)
    80003506:	6b02                	ld	s6,0(sp)
    80003508:	6121                	addi	sp,sp,64
    8000350a:	8082                	ret
    8000350c:	8082                	ret

000000008000350e <fsinit>:
fsinit(int dev) {
    8000350e:	7179                	addi	sp,sp,-48
    80003510:	f406                	sd	ra,40(sp)
    80003512:	f022                	sd	s0,32(sp)
    80003514:	ec26                	sd	s1,24(sp)
    80003516:	e84a                	sd	s2,16(sp)
    80003518:	e44e                	sd	s3,8(sp)
    8000351a:	1800                	addi	s0,sp,48
    8000351c:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    8000351e:	4585                	li	a1,1
    80003520:	e2eff0ef          	jal	80002b4e <bread>
    80003524:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003526:	0001b997          	auipc	s3,0x1b
    8000352a:	94a98993          	addi	s3,s3,-1718 # 8001de70 <sb>
    8000352e:	02000613          	li	a2,32
    80003532:	05850593          	addi	a1,a0,88
    80003536:	854e                	mv	a0,s3
    80003538:	feafd0ef          	jal	80000d22 <memmove>
  brelse(bp);
    8000353c:	854a                	mv	a0,s2
    8000353e:	f18ff0ef          	jal	80002c56 <brelse>
  if(sb.magic != FSMAGIC)
    80003542:	0009a703          	lw	a4,0(s3)
    80003546:	102037b7          	lui	a5,0x10203
    8000354a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000354e:	02f71363          	bne	a4,a5,80003574 <fsinit+0x66>
  initlog(dev, &sb);
    80003552:	0001b597          	auipc	a1,0x1b
    80003556:	91e58593          	addi	a1,a1,-1762 # 8001de70 <sb>
    8000355a:	8526                	mv	a0,s1
    8000355c:	62a000ef          	jal	80003b86 <initlog>
  ireclaim(dev);
    80003560:	8526                	mv	a0,s1
    80003562:	ee3ff0ef          	jal	80003444 <ireclaim>
}
    80003566:	70a2                	ld	ra,40(sp)
    80003568:	7402                	ld	s0,32(sp)
    8000356a:	64e2                	ld	s1,24(sp)
    8000356c:	6942                	ld	s2,16(sp)
    8000356e:	69a2                	ld	s3,8(sp)
    80003570:	6145                	addi	sp,sp,48
    80003572:	8082                	ret
    panic("invalid file system");
    80003574:	00004517          	auipc	a0,0x4
    80003578:	f1450513          	addi	a0,a0,-236 # 80007488 <etext+0x488>
    8000357c:	a64fd0ef          	jal	800007e0 <panic>

0000000080003580 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003580:	1141                	addi	sp,sp,-16
    80003582:	e422                	sd	s0,8(sp)
    80003584:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003586:	411c                	lw	a5,0(a0)
    80003588:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000358a:	415c                	lw	a5,4(a0)
    8000358c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000358e:	04451783          	lh	a5,68(a0)
    80003592:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003596:	04a51783          	lh	a5,74(a0)
    8000359a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000359e:	04c56783          	lwu	a5,76(a0)
    800035a2:	e99c                	sd	a5,16(a1)
}
    800035a4:	6422                	ld	s0,8(sp)
    800035a6:	0141                	addi	sp,sp,16
    800035a8:	8082                	ret

00000000800035aa <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800035aa:	457c                	lw	a5,76(a0)
    800035ac:	0ed7eb63          	bltu	a5,a3,800036a2 <readi+0xf8>
{
    800035b0:	7159                	addi	sp,sp,-112
    800035b2:	f486                	sd	ra,104(sp)
    800035b4:	f0a2                	sd	s0,96(sp)
    800035b6:	eca6                	sd	s1,88(sp)
    800035b8:	e0d2                	sd	s4,64(sp)
    800035ba:	fc56                	sd	s5,56(sp)
    800035bc:	f85a                	sd	s6,48(sp)
    800035be:	f45e                	sd	s7,40(sp)
    800035c0:	1880                	addi	s0,sp,112
    800035c2:	8b2a                	mv	s6,a0
    800035c4:	8bae                	mv	s7,a1
    800035c6:	8a32                	mv	s4,a2
    800035c8:	84b6                	mv	s1,a3
    800035ca:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800035cc:	9f35                	addw	a4,a4,a3
    return 0;
    800035ce:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800035d0:	0cd76063          	bltu	a4,a3,80003690 <readi+0xe6>
    800035d4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800035d6:	00e7f463          	bgeu	a5,a4,800035de <readi+0x34>
    n = ip->size - off;
    800035da:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800035de:	080a8f63          	beqz	s5,8000367c <readi+0xd2>
    800035e2:	e8ca                	sd	s2,80(sp)
    800035e4:	f062                	sd	s8,32(sp)
    800035e6:	ec66                	sd	s9,24(sp)
    800035e8:	e86a                	sd	s10,16(sp)
    800035ea:	e46e                	sd	s11,8(sp)
    800035ec:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800035ee:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800035f2:	5c7d                	li	s8,-1
    800035f4:	a80d                	j	80003626 <readi+0x7c>
    800035f6:	020d1d93          	slli	s11,s10,0x20
    800035fa:	020ddd93          	srli	s11,s11,0x20
    800035fe:	05890613          	addi	a2,s2,88
    80003602:	86ee                	mv	a3,s11
    80003604:	963a                	add	a2,a2,a4
    80003606:	85d2                	mv	a1,s4
    80003608:	855e                	mv	a0,s7
    8000360a:	c4ffe0ef          	jal	80002258 <either_copyout>
    8000360e:	05850763          	beq	a0,s8,8000365c <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003612:	854a                	mv	a0,s2
    80003614:	e42ff0ef          	jal	80002c56 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003618:	013d09bb          	addw	s3,s10,s3
    8000361c:	009d04bb          	addw	s1,s10,s1
    80003620:	9a6e                	add	s4,s4,s11
    80003622:	0559f763          	bgeu	s3,s5,80003670 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003626:	00a4d59b          	srliw	a1,s1,0xa
    8000362a:	855a                	mv	a0,s6
    8000362c:	8a7ff0ef          	jal	80002ed2 <bmap>
    80003630:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003634:	c5b1                	beqz	a1,80003680 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003636:	000b2503          	lw	a0,0(s6)
    8000363a:	d14ff0ef          	jal	80002b4e <bread>
    8000363e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003640:	3ff4f713          	andi	a4,s1,1023
    80003644:	40ec87bb          	subw	a5,s9,a4
    80003648:	413a86bb          	subw	a3,s5,s3
    8000364c:	8d3e                	mv	s10,a5
    8000364e:	2781                	sext.w	a5,a5
    80003650:	0006861b          	sext.w	a2,a3
    80003654:	faf671e3          	bgeu	a2,a5,800035f6 <readi+0x4c>
    80003658:	8d36                	mv	s10,a3
    8000365a:	bf71                	j	800035f6 <readi+0x4c>
      brelse(bp);
    8000365c:	854a                	mv	a0,s2
    8000365e:	df8ff0ef          	jal	80002c56 <brelse>
      tot = -1;
    80003662:	59fd                	li	s3,-1
      break;
    80003664:	6946                	ld	s2,80(sp)
    80003666:	7c02                	ld	s8,32(sp)
    80003668:	6ce2                	ld	s9,24(sp)
    8000366a:	6d42                	ld	s10,16(sp)
    8000366c:	6da2                	ld	s11,8(sp)
    8000366e:	a831                	j	8000368a <readi+0xe0>
    80003670:	6946                	ld	s2,80(sp)
    80003672:	7c02                	ld	s8,32(sp)
    80003674:	6ce2                	ld	s9,24(sp)
    80003676:	6d42                	ld	s10,16(sp)
    80003678:	6da2                	ld	s11,8(sp)
    8000367a:	a801                	j	8000368a <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000367c:	89d6                	mv	s3,s5
    8000367e:	a031                	j	8000368a <readi+0xe0>
    80003680:	6946                	ld	s2,80(sp)
    80003682:	7c02                	ld	s8,32(sp)
    80003684:	6ce2                	ld	s9,24(sp)
    80003686:	6d42                	ld	s10,16(sp)
    80003688:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000368a:	0009851b          	sext.w	a0,s3
    8000368e:	69a6                	ld	s3,72(sp)
}
    80003690:	70a6                	ld	ra,104(sp)
    80003692:	7406                	ld	s0,96(sp)
    80003694:	64e6                	ld	s1,88(sp)
    80003696:	6a06                	ld	s4,64(sp)
    80003698:	7ae2                	ld	s5,56(sp)
    8000369a:	7b42                	ld	s6,48(sp)
    8000369c:	7ba2                	ld	s7,40(sp)
    8000369e:	6165                	addi	sp,sp,112
    800036a0:	8082                	ret
    return 0;
    800036a2:	4501                	li	a0,0
}
    800036a4:	8082                	ret

00000000800036a6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800036a6:	457c                	lw	a5,76(a0)
    800036a8:	10d7e063          	bltu	a5,a3,800037a8 <writei+0x102>
{
    800036ac:	7159                	addi	sp,sp,-112
    800036ae:	f486                	sd	ra,104(sp)
    800036b0:	f0a2                	sd	s0,96(sp)
    800036b2:	e8ca                	sd	s2,80(sp)
    800036b4:	e0d2                	sd	s4,64(sp)
    800036b6:	fc56                	sd	s5,56(sp)
    800036b8:	f85a                	sd	s6,48(sp)
    800036ba:	f45e                	sd	s7,40(sp)
    800036bc:	1880                	addi	s0,sp,112
    800036be:	8aaa                	mv	s5,a0
    800036c0:	8bae                	mv	s7,a1
    800036c2:	8a32                	mv	s4,a2
    800036c4:	8936                	mv	s2,a3
    800036c6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800036c8:	00e687bb          	addw	a5,a3,a4
    800036cc:	0ed7e063          	bltu	a5,a3,800037ac <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800036d0:	00043737          	lui	a4,0x43
    800036d4:	0cf76e63          	bltu	a4,a5,800037b0 <writei+0x10a>
    800036d8:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800036da:	0a0b0f63          	beqz	s6,80003798 <writei+0xf2>
    800036de:	eca6                	sd	s1,88(sp)
    800036e0:	f062                	sd	s8,32(sp)
    800036e2:	ec66                	sd	s9,24(sp)
    800036e4:	e86a                	sd	s10,16(sp)
    800036e6:	e46e                	sd	s11,8(sp)
    800036e8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800036ea:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800036ee:	5c7d                	li	s8,-1
    800036f0:	a825                	j	80003728 <writei+0x82>
    800036f2:	020d1d93          	slli	s11,s10,0x20
    800036f6:	020ddd93          	srli	s11,s11,0x20
    800036fa:	05848513          	addi	a0,s1,88
    800036fe:	86ee                	mv	a3,s11
    80003700:	8652                	mv	a2,s4
    80003702:	85de                	mv	a1,s7
    80003704:	953a                	add	a0,a0,a4
    80003706:	b9dfe0ef          	jal	800022a2 <either_copyin>
    8000370a:	05850a63          	beq	a0,s8,8000375e <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000370e:	8526                	mv	a0,s1
    80003710:	678000ef          	jal	80003d88 <log_write>
    brelse(bp);
    80003714:	8526                	mv	a0,s1
    80003716:	d40ff0ef          	jal	80002c56 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000371a:	013d09bb          	addw	s3,s10,s3
    8000371e:	012d093b          	addw	s2,s10,s2
    80003722:	9a6e                	add	s4,s4,s11
    80003724:	0569f063          	bgeu	s3,s6,80003764 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003728:	00a9559b          	srliw	a1,s2,0xa
    8000372c:	8556                	mv	a0,s5
    8000372e:	fa4ff0ef          	jal	80002ed2 <bmap>
    80003732:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003736:	c59d                	beqz	a1,80003764 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003738:	000aa503          	lw	a0,0(s5)
    8000373c:	c12ff0ef          	jal	80002b4e <bread>
    80003740:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003742:	3ff97713          	andi	a4,s2,1023
    80003746:	40ec87bb          	subw	a5,s9,a4
    8000374a:	413b06bb          	subw	a3,s6,s3
    8000374e:	8d3e                	mv	s10,a5
    80003750:	2781                	sext.w	a5,a5
    80003752:	0006861b          	sext.w	a2,a3
    80003756:	f8f67ee3          	bgeu	a2,a5,800036f2 <writei+0x4c>
    8000375a:	8d36                	mv	s10,a3
    8000375c:	bf59                	j	800036f2 <writei+0x4c>
      brelse(bp);
    8000375e:	8526                	mv	a0,s1
    80003760:	cf6ff0ef          	jal	80002c56 <brelse>
  }

  if(off > ip->size)
    80003764:	04caa783          	lw	a5,76(s5)
    80003768:	0327fa63          	bgeu	a5,s2,8000379c <writei+0xf6>
    ip->size = off;
    8000376c:	052aa623          	sw	s2,76(s5)
    80003770:	64e6                	ld	s1,88(sp)
    80003772:	7c02                	ld	s8,32(sp)
    80003774:	6ce2                	ld	s9,24(sp)
    80003776:	6d42                	ld	s10,16(sp)
    80003778:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000377a:	8556                	mv	a0,s5
    8000377c:	9ebff0ef          	jal	80003166 <iupdate>

  return tot;
    80003780:	0009851b          	sext.w	a0,s3
    80003784:	69a6                	ld	s3,72(sp)
}
    80003786:	70a6                	ld	ra,104(sp)
    80003788:	7406                	ld	s0,96(sp)
    8000378a:	6946                	ld	s2,80(sp)
    8000378c:	6a06                	ld	s4,64(sp)
    8000378e:	7ae2                	ld	s5,56(sp)
    80003790:	7b42                	ld	s6,48(sp)
    80003792:	7ba2                	ld	s7,40(sp)
    80003794:	6165                	addi	sp,sp,112
    80003796:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003798:	89da                	mv	s3,s6
    8000379a:	b7c5                	j	8000377a <writei+0xd4>
    8000379c:	64e6                	ld	s1,88(sp)
    8000379e:	7c02                	ld	s8,32(sp)
    800037a0:	6ce2                	ld	s9,24(sp)
    800037a2:	6d42                	ld	s10,16(sp)
    800037a4:	6da2                	ld	s11,8(sp)
    800037a6:	bfd1                	j	8000377a <writei+0xd4>
    return -1;
    800037a8:	557d                	li	a0,-1
}
    800037aa:	8082                	ret
    return -1;
    800037ac:	557d                	li	a0,-1
    800037ae:	bfe1                	j	80003786 <writei+0xe0>
    return -1;
    800037b0:	557d                	li	a0,-1
    800037b2:	bfd1                	j	80003786 <writei+0xe0>

00000000800037b4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800037b4:	1141                	addi	sp,sp,-16
    800037b6:	e406                	sd	ra,8(sp)
    800037b8:	e022                	sd	s0,0(sp)
    800037ba:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800037bc:	4639                	li	a2,14
    800037be:	dd4fd0ef          	jal	80000d92 <strncmp>
}
    800037c2:	60a2                	ld	ra,8(sp)
    800037c4:	6402                	ld	s0,0(sp)
    800037c6:	0141                	addi	sp,sp,16
    800037c8:	8082                	ret

00000000800037ca <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800037ca:	7139                	addi	sp,sp,-64
    800037cc:	fc06                	sd	ra,56(sp)
    800037ce:	f822                	sd	s0,48(sp)
    800037d0:	f426                	sd	s1,40(sp)
    800037d2:	f04a                	sd	s2,32(sp)
    800037d4:	ec4e                	sd	s3,24(sp)
    800037d6:	e852                	sd	s4,16(sp)
    800037d8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800037da:	04451703          	lh	a4,68(a0)
    800037de:	4785                	li	a5,1
    800037e0:	00f71a63          	bne	a4,a5,800037f4 <dirlookup+0x2a>
    800037e4:	892a                	mv	s2,a0
    800037e6:	89ae                	mv	s3,a1
    800037e8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800037ea:	457c                	lw	a5,76(a0)
    800037ec:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800037ee:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037f0:	e39d                	bnez	a5,80003816 <dirlookup+0x4c>
    800037f2:	a095                	j	80003856 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800037f4:	00004517          	auipc	a0,0x4
    800037f8:	cac50513          	addi	a0,a0,-852 # 800074a0 <etext+0x4a0>
    800037fc:	fe5fc0ef          	jal	800007e0 <panic>
      panic("dirlookup read");
    80003800:	00004517          	auipc	a0,0x4
    80003804:	cb850513          	addi	a0,a0,-840 # 800074b8 <etext+0x4b8>
    80003808:	fd9fc0ef          	jal	800007e0 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000380c:	24c1                	addiw	s1,s1,16
    8000380e:	04c92783          	lw	a5,76(s2)
    80003812:	04f4f163          	bgeu	s1,a5,80003854 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003816:	4741                	li	a4,16
    80003818:	86a6                	mv	a3,s1
    8000381a:	fc040613          	addi	a2,s0,-64
    8000381e:	4581                	li	a1,0
    80003820:	854a                	mv	a0,s2
    80003822:	d89ff0ef          	jal	800035aa <readi>
    80003826:	47c1                	li	a5,16
    80003828:	fcf51ce3          	bne	a0,a5,80003800 <dirlookup+0x36>
    if(de.inum == 0)
    8000382c:	fc045783          	lhu	a5,-64(s0)
    80003830:	dff1                	beqz	a5,8000380c <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003832:	fc240593          	addi	a1,s0,-62
    80003836:	854e                	mv	a0,s3
    80003838:	f7dff0ef          	jal	800037b4 <namecmp>
    8000383c:	f961                	bnez	a0,8000380c <dirlookup+0x42>
      if(poff)
    8000383e:	000a0463          	beqz	s4,80003846 <dirlookup+0x7c>
        *poff = off;
    80003842:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003846:	fc045583          	lhu	a1,-64(s0)
    8000384a:	00092503          	lw	a0,0(s2)
    8000384e:	f58ff0ef          	jal	80002fa6 <iget>
    80003852:	a011                	j	80003856 <dirlookup+0x8c>
  return 0;
    80003854:	4501                	li	a0,0
}
    80003856:	70e2                	ld	ra,56(sp)
    80003858:	7442                	ld	s0,48(sp)
    8000385a:	74a2                	ld	s1,40(sp)
    8000385c:	7902                	ld	s2,32(sp)
    8000385e:	69e2                	ld	s3,24(sp)
    80003860:	6a42                	ld	s4,16(sp)
    80003862:	6121                	addi	sp,sp,64
    80003864:	8082                	ret

0000000080003866 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003866:	711d                	addi	sp,sp,-96
    80003868:	ec86                	sd	ra,88(sp)
    8000386a:	e8a2                	sd	s0,80(sp)
    8000386c:	e4a6                	sd	s1,72(sp)
    8000386e:	e0ca                	sd	s2,64(sp)
    80003870:	fc4e                	sd	s3,56(sp)
    80003872:	f852                	sd	s4,48(sp)
    80003874:	f456                	sd	s5,40(sp)
    80003876:	f05a                	sd	s6,32(sp)
    80003878:	ec5e                	sd	s7,24(sp)
    8000387a:	e862                	sd	s8,16(sp)
    8000387c:	e466                	sd	s9,8(sp)
    8000387e:	1080                	addi	s0,sp,96
    80003880:	84aa                	mv	s1,a0
    80003882:	8b2e                	mv	s6,a1
    80003884:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003886:	00054703          	lbu	a4,0(a0)
    8000388a:	02f00793          	li	a5,47
    8000388e:	00f70e63          	beq	a4,a5,800038aa <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003892:	860fe0ef          	jal	800018f2 <myproc>
    80003896:	15053503          	ld	a0,336(a0)
    8000389a:	94bff0ef          	jal	800031e4 <idup>
    8000389e:	8a2a                	mv	s4,a0
  while(*path == '/')
    800038a0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800038a4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800038a6:	4b85                	li	s7,1
    800038a8:	a871                	j	80003944 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    800038aa:	4585                	li	a1,1
    800038ac:	4505                	li	a0,1
    800038ae:	ef8ff0ef          	jal	80002fa6 <iget>
    800038b2:	8a2a                	mv	s4,a0
    800038b4:	b7f5                	j	800038a0 <namex+0x3a>
      iunlockput(ip);
    800038b6:	8552                	mv	a0,s4
    800038b8:	b6dff0ef          	jal	80003424 <iunlockput>
      return 0;
    800038bc:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800038be:	8552                	mv	a0,s4
    800038c0:	60e6                	ld	ra,88(sp)
    800038c2:	6446                	ld	s0,80(sp)
    800038c4:	64a6                	ld	s1,72(sp)
    800038c6:	6906                	ld	s2,64(sp)
    800038c8:	79e2                	ld	s3,56(sp)
    800038ca:	7a42                	ld	s4,48(sp)
    800038cc:	7aa2                	ld	s5,40(sp)
    800038ce:	7b02                	ld	s6,32(sp)
    800038d0:	6be2                	ld	s7,24(sp)
    800038d2:	6c42                	ld	s8,16(sp)
    800038d4:	6ca2                	ld	s9,8(sp)
    800038d6:	6125                	addi	sp,sp,96
    800038d8:	8082                	ret
      iunlock(ip);
    800038da:	8552                	mv	a0,s4
    800038dc:	9edff0ef          	jal	800032c8 <iunlock>
      return ip;
    800038e0:	bff9                	j	800038be <namex+0x58>
      iunlockput(ip);
    800038e2:	8552                	mv	a0,s4
    800038e4:	b41ff0ef          	jal	80003424 <iunlockput>
      return 0;
    800038e8:	8a4e                	mv	s4,s3
    800038ea:	bfd1                	j	800038be <namex+0x58>
  len = path - s;
    800038ec:	40998633          	sub	a2,s3,s1
    800038f0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800038f4:	099c5063          	bge	s8,s9,80003974 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    800038f8:	4639                	li	a2,14
    800038fa:	85a6                	mv	a1,s1
    800038fc:	8556                	mv	a0,s5
    800038fe:	c24fd0ef          	jal	80000d22 <memmove>
    80003902:	84ce                	mv	s1,s3
  while(*path == '/')
    80003904:	0004c783          	lbu	a5,0(s1)
    80003908:	01279763          	bne	a5,s2,80003916 <namex+0xb0>
    path++;
    8000390c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000390e:	0004c783          	lbu	a5,0(s1)
    80003912:	ff278de3          	beq	a5,s2,8000390c <namex+0xa6>
    ilock(ip);
    80003916:	8552                	mv	a0,s4
    80003918:	903ff0ef          	jal	8000321a <ilock>
    if(ip->type != T_DIR){
    8000391c:	044a1783          	lh	a5,68(s4)
    80003920:	f9779be3          	bne	a5,s7,800038b6 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003924:	000b0563          	beqz	s6,8000392e <namex+0xc8>
    80003928:	0004c783          	lbu	a5,0(s1)
    8000392c:	d7dd                	beqz	a5,800038da <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000392e:	4601                	li	a2,0
    80003930:	85d6                	mv	a1,s5
    80003932:	8552                	mv	a0,s4
    80003934:	e97ff0ef          	jal	800037ca <dirlookup>
    80003938:	89aa                	mv	s3,a0
    8000393a:	d545                	beqz	a0,800038e2 <namex+0x7c>
    iunlockput(ip);
    8000393c:	8552                	mv	a0,s4
    8000393e:	ae7ff0ef          	jal	80003424 <iunlockput>
    ip = next;
    80003942:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003944:	0004c783          	lbu	a5,0(s1)
    80003948:	01279763          	bne	a5,s2,80003956 <namex+0xf0>
    path++;
    8000394c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000394e:	0004c783          	lbu	a5,0(s1)
    80003952:	ff278de3          	beq	a5,s2,8000394c <namex+0xe6>
  if(*path == 0)
    80003956:	cb8d                	beqz	a5,80003988 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003958:	0004c783          	lbu	a5,0(s1)
    8000395c:	89a6                	mv	s3,s1
  len = path - s;
    8000395e:	4c81                	li	s9,0
    80003960:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003962:	01278963          	beq	a5,s2,80003974 <namex+0x10e>
    80003966:	d3d9                	beqz	a5,800038ec <namex+0x86>
    path++;
    80003968:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000396a:	0009c783          	lbu	a5,0(s3)
    8000396e:	ff279ce3          	bne	a5,s2,80003966 <namex+0x100>
    80003972:	bfad                	j	800038ec <namex+0x86>
    memmove(name, s, len);
    80003974:	2601                	sext.w	a2,a2
    80003976:	85a6                	mv	a1,s1
    80003978:	8556                	mv	a0,s5
    8000397a:	ba8fd0ef          	jal	80000d22 <memmove>
    name[len] = 0;
    8000397e:	9cd6                	add	s9,s9,s5
    80003980:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003984:	84ce                	mv	s1,s3
    80003986:	bfbd                	j	80003904 <namex+0x9e>
  if(nameiparent){
    80003988:	f20b0be3          	beqz	s6,800038be <namex+0x58>
    iput(ip);
    8000398c:	8552                	mv	a0,s4
    8000398e:	a0fff0ef          	jal	8000339c <iput>
    return 0;
    80003992:	4a01                	li	s4,0
    80003994:	b72d                	j	800038be <namex+0x58>

0000000080003996 <dirlink>:
{
    80003996:	7139                	addi	sp,sp,-64
    80003998:	fc06                	sd	ra,56(sp)
    8000399a:	f822                	sd	s0,48(sp)
    8000399c:	f04a                	sd	s2,32(sp)
    8000399e:	ec4e                	sd	s3,24(sp)
    800039a0:	e852                	sd	s4,16(sp)
    800039a2:	0080                	addi	s0,sp,64
    800039a4:	892a                	mv	s2,a0
    800039a6:	8a2e                	mv	s4,a1
    800039a8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800039aa:	4601                	li	a2,0
    800039ac:	e1fff0ef          	jal	800037ca <dirlookup>
    800039b0:	e535                	bnez	a0,80003a1c <dirlink+0x86>
    800039b2:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039b4:	04c92483          	lw	s1,76(s2)
    800039b8:	c48d                	beqz	s1,800039e2 <dirlink+0x4c>
    800039ba:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039bc:	4741                	li	a4,16
    800039be:	86a6                	mv	a3,s1
    800039c0:	fc040613          	addi	a2,s0,-64
    800039c4:	4581                	li	a1,0
    800039c6:	854a                	mv	a0,s2
    800039c8:	be3ff0ef          	jal	800035aa <readi>
    800039cc:	47c1                	li	a5,16
    800039ce:	04f51b63          	bne	a0,a5,80003a24 <dirlink+0x8e>
    if(de.inum == 0)
    800039d2:	fc045783          	lhu	a5,-64(s0)
    800039d6:	c791                	beqz	a5,800039e2 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039d8:	24c1                	addiw	s1,s1,16
    800039da:	04c92783          	lw	a5,76(s2)
    800039de:	fcf4efe3          	bltu	s1,a5,800039bc <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800039e2:	4639                	li	a2,14
    800039e4:	85d2                	mv	a1,s4
    800039e6:	fc240513          	addi	a0,s0,-62
    800039ea:	bdefd0ef          	jal	80000dc8 <strncpy>
  de.inum = inum;
    800039ee:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039f2:	4741                	li	a4,16
    800039f4:	86a6                	mv	a3,s1
    800039f6:	fc040613          	addi	a2,s0,-64
    800039fa:	4581                	li	a1,0
    800039fc:	854a                	mv	a0,s2
    800039fe:	ca9ff0ef          	jal	800036a6 <writei>
    80003a02:	1541                	addi	a0,a0,-16
    80003a04:	00a03533          	snez	a0,a0
    80003a08:	40a00533          	neg	a0,a0
    80003a0c:	74a2                	ld	s1,40(sp)
}
    80003a0e:	70e2                	ld	ra,56(sp)
    80003a10:	7442                	ld	s0,48(sp)
    80003a12:	7902                	ld	s2,32(sp)
    80003a14:	69e2                	ld	s3,24(sp)
    80003a16:	6a42                	ld	s4,16(sp)
    80003a18:	6121                	addi	sp,sp,64
    80003a1a:	8082                	ret
    iput(ip);
    80003a1c:	981ff0ef          	jal	8000339c <iput>
    return -1;
    80003a20:	557d                	li	a0,-1
    80003a22:	b7f5                	j	80003a0e <dirlink+0x78>
      panic("dirlink read");
    80003a24:	00004517          	auipc	a0,0x4
    80003a28:	aa450513          	addi	a0,a0,-1372 # 800074c8 <etext+0x4c8>
    80003a2c:	db5fc0ef          	jal	800007e0 <panic>

0000000080003a30 <namei>:

struct inode*
namei(char *path)
{
    80003a30:	1101                	addi	sp,sp,-32
    80003a32:	ec06                	sd	ra,24(sp)
    80003a34:	e822                	sd	s0,16(sp)
    80003a36:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003a38:	fe040613          	addi	a2,s0,-32
    80003a3c:	4581                	li	a1,0
    80003a3e:	e29ff0ef          	jal	80003866 <namex>
}
    80003a42:	60e2                	ld	ra,24(sp)
    80003a44:	6442                	ld	s0,16(sp)
    80003a46:	6105                	addi	sp,sp,32
    80003a48:	8082                	ret

0000000080003a4a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003a4a:	1141                	addi	sp,sp,-16
    80003a4c:	e406                	sd	ra,8(sp)
    80003a4e:	e022                	sd	s0,0(sp)
    80003a50:	0800                	addi	s0,sp,16
    80003a52:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003a54:	4585                	li	a1,1
    80003a56:	e11ff0ef          	jal	80003866 <namex>
}
    80003a5a:	60a2                	ld	ra,8(sp)
    80003a5c:	6402                	ld	s0,0(sp)
    80003a5e:	0141                	addi	sp,sp,16
    80003a60:	8082                	ret

0000000080003a62 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003a62:	1101                	addi	sp,sp,-32
    80003a64:	ec06                	sd	ra,24(sp)
    80003a66:	e822                	sd	s0,16(sp)
    80003a68:	e426                	sd	s1,8(sp)
    80003a6a:	e04a                	sd	s2,0(sp)
    80003a6c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003a6e:	0001c917          	auipc	s2,0x1c
    80003a72:	eca90913          	addi	s2,s2,-310 # 8001f938 <log>
    80003a76:	01892583          	lw	a1,24(s2)
    80003a7a:	02492503          	lw	a0,36(s2)
    80003a7e:	8d0ff0ef          	jal	80002b4e <bread>
    80003a82:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003a84:	02892603          	lw	a2,40(s2)
    80003a88:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003a8a:	00c05f63          	blez	a2,80003aa8 <write_head+0x46>
    80003a8e:	0001c717          	auipc	a4,0x1c
    80003a92:	ed670713          	addi	a4,a4,-298 # 8001f964 <log+0x2c>
    80003a96:	87aa                	mv	a5,a0
    80003a98:	060a                	slli	a2,a2,0x2
    80003a9a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003a9c:	4314                	lw	a3,0(a4)
    80003a9e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003aa0:	0711                	addi	a4,a4,4
    80003aa2:	0791                	addi	a5,a5,4
    80003aa4:	fec79ce3          	bne	a5,a2,80003a9c <write_head+0x3a>
  }
  bwrite(buf);
    80003aa8:	8526                	mv	a0,s1
    80003aaa:	97aff0ef          	jal	80002c24 <bwrite>
  brelse(buf);
    80003aae:	8526                	mv	a0,s1
    80003ab0:	9a6ff0ef          	jal	80002c56 <brelse>
}
    80003ab4:	60e2                	ld	ra,24(sp)
    80003ab6:	6442                	ld	s0,16(sp)
    80003ab8:	64a2                	ld	s1,8(sp)
    80003aba:	6902                	ld	s2,0(sp)
    80003abc:	6105                	addi	sp,sp,32
    80003abe:	8082                	ret

0000000080003ac0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ac0:	0001c797          	auipc	a5,0x1c
    80003ac4:	ea07a783          	lw	a5,-352(a5) # 8001f960 <log+0x28>
    80003ac8:	0af05e63          	blez	a5,80003b84 <install_trans+0xc4>
{
    80003acc:	715d                	addi	sp,sp,-80
    80003ace:	e486                	sd	ra,72(sp)
    80003ad0:	e0a2                	sd	s0,64(sp)
    80003ad2:	fc26                	sd	s1,56(sp)
    80003ad4:	f84a                	sd	s2,48(sp)
    80003ad6:	f44e                	sd	s3,40(sp)
    80003ad8:	f052                	sd	s4,32(sp)
    80003ada:	ec56                	sd	s5,24(sp)
    80003adc:	e85a                	sd	s6,16(sp)
    80003ade:	e45e                	sd	s7,8(sp)
    80003ae0:	0880                	addi	s0,sp,80
    80003ae2:	8b2a                	mv	s6,a0
    80003ae4:	0001ca97          	auipc	s5,0x1c
    80003ae8:	e80a8a93          	addi	s5,s5,-384 # 8001f964 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003aec:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003aee:	00004b97          	auipc	s7,0x4
    80003af2:	9eab8b93          	addi	s7,s7,-1558 # 800074d8 <etext+0x4d8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003af6:	0001ca17          	auipc	s4,0x1c
    80003afa:	e42a0a13          	addi	s4,s4,-446 # 8001f938 <log>
    80003afe:	a025                	j	80003b26 <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003b00:	000aa603          	lw	a2,0(s5)
    80003b04:	85ce                	mv	a1,s3
    80003b06:	855e                	mv	a0,s7
    80003b08:	9f3fc0ef          	jal	800004fa <printf>
    80003b0c:	a839                	j	80003b2a <install_trans+0x6a>
    brelse(lbuf);
    80003b0e:	854a                	mv	a0,s2
    80003b10:	946ff0ef          	jal	80002c56 <brelse>
    brelse(dbuf);
    80003b14:	8526                	mv	a0,s1
    80003b16:	940ff0ef          	jal	80002c56 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b1a:	2985                	addiw	s3,s3,1
    80003b1c:	0a91                	addi	s5,s5,4
    80003b1e:	028a2783          	lw	a5,40(s4)
    80003b22:	04f9d663          	bge	s3,a5,80003b6e <install_trans+0xae>
    if(recovering) {
    80003b26:	fc0b1de3          	bnez	s6,80003b00 <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b2a:	018a2583          	lw	a1,24(s4)
    80003b2e:	013585bb          	addw	a1,a1,s3
    80003b32:	2585                	addiw	a1,a1,1
    80003b34:	024a2503          	lw	a0,36(s4)
    80003b38:	816ff0ef          	jal	80002b4e <bread>
    80003b3c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003b3e:	000aa583          	lw	a1,0(s5)
    80003b42:	024a2503          	lw	a0,36(s4)
    80003b46:	808ff0ef          	jal	80002b4e <bread>
    80003b4a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003b4c:	40000613          	li	a2,1024
    80003b50:	05890593          	addi	a1,s2,88
    80003b54:	05850513          	addi	a0,a0,88
    80003b58:	9cafd0ef          	jal	80000d22 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003b5c:	8526                	mv	a0,s1
    80003b5e:	8c6ff0ef          	jal	80002c24 <bwrite>
    if(recovering == 0)
    80003b62:	fa0b16e3          	bnez	s6,80003b0e <install_trans+0x4e>
      bunpin(dbuf);
    80003b66:	8526                	mv	a0,s1
    80003b68:	9aaff0ef          	jal	80002d12 <bunpin>
    80003b6c:	b74d                	j	80003b0e <install_trans+0x4e>
}
    80003b6e:	60a6                	ld	ra,72(sp)
    80003b70:	6406                	ld	s0,64(sp)
    80003b72:	74e2                	ld	s1,56(sp)
    80003b74:	7942                	ld	s2,48(sp)
    80003b76:	79a2                	ld	s3,40(sp)
    80003b78:	7a02                	ld	s4,32(sp)
    80003b7a:	6ae2                	ld	s5,24(sp)
    80003b7c:	6b42                	ld	s6,16(sp)
    80003b7e:	6ba2                	ld	s7,8(sp)
    80003b80:	6161                	addi	sp,sp,80
    80003b82:	8082                	ret
    80003b84:	8082                	ret

0000000080003b86 <initlog>:
{
    80003b86:	7179                	addi	sp,sp,-48
    80003b88:	f406                	sd	ra,40(sp)
    80003b8a:	f022                	sd	s0,32(sp)
    80003b8c:	ec26                	sd	s1,24(sp)
    80003b8e:	e84a                	sd	s2,16(sp)
    80003b90:	e44e                	sd	s3,8(sp)
    80003b92:	1800                	addi	s0,sp,48
    80003b94:	892a                	mv	s2,a0
    80003b96:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003b98:	0001c497          	auipc	s1,0x1c
    80003b9c:	da048493          	addi	s1,s1,-608 # 8001f938 <log>
    80003ba0:	00004597          	auipc	a1,0x4
    80003ba4:	95858593          	addi	a1,a1,-1704 # 800074f8 <etext+0x4f8>
    80003ba8:	8526                	mv	a0,s1
    80003baa:	fc9fc0ef          	jal	80000b72 <initlock>
  log.start = sb->logstart;
    80003bae:	0149a583          	lw	a1,20(s3)
    80003bb2:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003bb4:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003bb8:	854a                	mv	a0,s2
    80003bba:	f95fe0ef          	jal	80002b4e <bread>
  log.lh.n = lh->n;
    80003bbe:	4d30                	lw	a2,88(a0)
    80003bc0:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003bc2:	00c05f63          	blez	a2,80003be0 <initlog+0x5a>
    80003bc6:	87aa                	mv	a5,a0
    80003bc8:	0001c717          	auipc	a4,0x1c
    80003bcc:	d9c70713          	addi	a4,a4,-612 # 8001f964 <log+0x2c>
    80003bd0:	060a                	slli	a2,a2,0x2
    80003bd2:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003bd4:	4ff4                	lw	a3,92(a5)
    80003bd6:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003bd8:	0791                	addi	a5,a5,4
    80003bda:	0711                	addi	a4,a4,4
    80003bdc:	fec79ce3          	bne	a5,a2,80003bd4 <initlog+0x4e>
  brelse(buf);
    80003be0:	876ff0ef          	jal	80002c56 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003be4:	4505                	li	a0,1
    80003be6:	edbff0ef          	jal	80003ac0 <install_trans>
  log.lh.n = 0;
    80003bea:	0001c797          	auipc	a5,0x1c
    80003bee:	d607ab23          	sw	zero,-650(a5) # 8001f960 <log+0x28>
  write_head(); // clear the log
    80003bf2:	e71ff0ef          	jal	80003a62 <write_head>
}
    80003bf6:	70a2                	ld	ra,40(sp)
    80003bf8:	7402                	ld	s0,32(sp)
    80003bfa:	64e2                	ld	s1,24(sp)
    80003bfc:	6942                	ld	s2,16(sp)
    80003bfe:	69a2                	ld	s3,8(sp)
    80003c00:	6145                	addi	sp,sp,48
    80003c02:	8082                	ret

0000000080003c04 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003c04:	1101                	addi	sp,sp,-32
    80003c06:	ec06                	sd	ra,24(sp)
    80003c08:	e822                	sd	s0,16(sp)
    80003c0a:	e426                	sd	s1,8(sp)
    80003c0c:	e04a                	sd	s2,0(sp)
    80003c0e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003c10:	0001c517          	auipc	a0,0x1c
    80003c14:	d2850513          	addi	a0,a0,-728 # 8001f938 <log>
    80003c18:	fdbfc0ef          	jal	80000bf2 <acquire>
  while(1){
    if(log.committing){
    80003c1c:	0001c497          	auipc	s1,0x1c
    80003c20:	d1c48493          	addi	s1,s1,-740 # 8001f938 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003c24:	4979                	li	s2,30
    80003c26:	a029                	j	80003c30 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003c28:	85a6                	mv	a1,s1
    80003c2a:	8526                	mv	a0,s1
    80003c2c:	ad0fe0ef          	jal	80001efc <sleep>
    if(log.committing){
    80003c30:	509c                	lw	a5,32(s1)
    80003c32:	fbfd                	bnez	a5,80003c28 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003c34:	4cd8                	lw	a4,28(s1)
    80003c36:	2705                	addiw	a4,a4,1
    80003c38:	0027179b          	slliw	a5,a4,0x2
    80003c3c:	9fb9                	addw	a5,a5,a4
    80003c3e:	0017979b          	slliw	a5,a5,0x1
    80003c42:	5494                	lw	a3,40(s1)
    80003c44:	9fb5                	addw	a5,a5,a3
    80003c46:	00f95763          	bge	s2,a5,80003c54 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003c4a:	85a6                	mv	a1,s1
    80003c4c:	8526                	mv	a0,s1
    80003c4e:	aaefe0ef          	jal	80001efc <sleep>
    80003c52:	bff9                	j	80003c30 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003c54:	0001c517          	auipc	a0,0x1c
    80003c58:	ce450513          	addi	a0,a0,-796 # 8001f938 <log>
    80003c5c:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    80003c5e:	82cfd0ef          	jal	80000c8a <release>
      break;
    }
  }
}
    80003c62:	60e2                	ld	ra,24(sp)
    80003c64:	6442                	ld	s0,16(sp)
    80003c66:	64a2                	ld	s1,8(sp)
    80003c68:	6902                	ld	s2,0(sp)
    80003c6a:	6105                	addi	sp,sp,32
    80003c6c:	8082                	ret

0000000080003c6e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003c6e:	7139                	addi	sp,sp,-64
    80003c70:	fc06                	sd	ra,56(sp)
    80003c72:	f822                	sd	s0,48(sp)
    80003c74:	f426                	sd	s1,40(sp)
    80003c76:	f04a                	sd	s2,32(sp)
    80003c78:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003c7a:	0001c497          	auipc	s1,0x1c
    80003c7e:	cbe48493          	addi	s1,s1,-834 # 8001f938 <log>
    80003c82:	8526                	mv	a0,s1
    80003c84:	f6ffc0ef          	jal	80000bf2 <acquire>
  log.outstanding -= 1;
    80003c88:	4cdc                	lw	a5,28(s1)
    80003c8a:	37fd                	addiw	a5,a5,-1
    80003c8c:	0007891b          	sext.w	s2,a5
    80003c90:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003c92:	509c                	lw	a5,32(s1)
    80003c94:	ef9d                	bnez	a5,80003cd2 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003c96:	04091763          	bnez	s2,80003ce4 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003c9a:	0001c497          	auipc	s1,0x1c
    80003c9e:	c9e48493          	addi	s1,s1,-866 # 8001f938 <log>
    80003ca2:	4785                	li	a5,1
    80003ca4:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003ca6:	8526                	mv	a0,s1
    80003ca8:	fe3fc0ef          	jal	80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003cac:	549c                	lw	a5,40(s1)
    80003cae:	04f04b63          	bgtz	a5,80003d04 <end_op+0x96>
    acquire(&log.lock);
    80003cb2:	0001c497          	auipc	s1,0x1c
    80003cb6:	c8648493          	addi	s1,s1,-890 # 8001f938 <log>
    80003cba:	8526                	mv	a0,s1
    80003cbc:	f37fc0ef          	jal	80000bf2 <acquire>
    log.committing = 0;
    80003cc0:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003cc4:	8526                	mv	a0,s1
    80003cc6:	a82fe0ef          	jal	80001f48 <wakeup>
    release(&log.lock);
    80003cca:	8526                	mv	a0,s1
    80003ccc:	fbffc0ef          	jal	80000c8a <release>
}
    80003cd0:	a025                	j	80003cf8 <end_op+0x8a>
    80003cd2:	ec4e                	sd	s3,24(sp)
    80003cd4:	e852                	sd	s4,16(sp)
    80003cd6:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003cd8:	00004517          	auipc	a0,0x4
    80003cdc:	82850513          	addi	a0,a0,-2008 # 80007500 <etext+0x500>
    80003ce0:	b01fc0ef          	jal	800007e0 <panic>
    wakeup(&log);
    80003ce4:	0001c497          	auipc	s1,0x1c
    80003ce8:	c5448493          	addi	s1,s1,-940 # 8001f938 <log>
    80003cec:	8526                	mv	a0,s1
    80003cee:	a5afe0ef          	jal	80001f48 <wakeup>
  release(&log.lock);
    80003cf2:	8526                	mv	a0,s1
    80003cf4:	f97fc0ef          	jal	80000c8a <release>
}
    80003cf8:	70e2                	ld	ra,56(sp)
    80003cfa:	7442                	ld	s0,48(sp)
    80003cfc:	74a2                	ld	s1,40(sp)
    80003cfe:	7902                	ld	s2,32(sp)
    80003d00:	6121                	addi	sp,sp,64
    80003d02:	8082                	ret
    80003d04:	ec4e                	sd	s3,24(sp)
    80003d06:	e852                	sd	s4,16(sp)
    80003d08:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d0a:	0001ca97          	auipc	s5,0x1c
    80003d0e:	c5aa8a93          	addi	s5,s5,-934 # 8001f964 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003d12:	0001ca17          	auipc	s4,0x1c
    80003d16:	c26a0a13          	addi	s4,s4,-986 # 8001f938 <log>
    80003d1a:	018a2583          	lw	a1,24(s4)
    80003d1e:	012585bb          	addw	a1,a1,s2
    80003d22:	2585                	addiw	a1,a1,1
    80003d24:	024a2503          	lw	a0,36(s4)
    80003d28:	e27fe0ef          	jal	80002b4e <bread>
    80003d2c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003d2e:	000aa583          	lw	a1,0(s5)
    80003d32:	024a2503          	lw	a0,36(s4)
    80003d36:	e19fe0ef          	jal	80002b4e <bread>
    80003d3a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003d3c:	40000613          	li	a2,1024
    80003d40:	05850593          	addi	a1,a0,88
    80003d44:	05848513          	addi	a0,s1,88
    80003d48:	fdbfc0ef          	jal	80000d22 <memmove>
    bwrite(to);  // write the log
    80003d4c:	8526                	mv	a0,s1
    80003d4e:	ed7fe0ef          	jal	80002c24 <bwrite>
    brelse(from);
    80003d52:	854e                	mv	a0,s3
    80003d54:	f03fe0ef          	jal	80002c56 <brelse>
    brelse(to);
    80003d58:	8526                	mv	a0,s1
    80003d5a:	efdfe0ef          	jal	80002c56 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d5e:	2905                	addiw	s2,s2,1
    80003d60:	0a91                	addi	s5,s5,4
    80003d62:	028a2783          	lw	a5,40(s4)
    80003d66:	faf94ae3          	blt	s2,a5,80003d1a <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003d6a:	cf9ff0ef          	jal	80003a62 <write_head>
    install_trans(0); // Now install writes to home locations
    80003d6e:	4501                	li	a0,0
    80003d70:	d51ff0ef          	jal	80003ac0 <install_trans>
    log.lh.n = 0;
    80003d74:	0001c797          	auipc	a5,0x1c
    80003d78:	be07a623          	sw	zero,-1044(a5) # 8001f960 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003d7c:	ce7ff0ef          	jal	80003a62 <write_head>
    80003d80:	69e2                	ld	s3,24(sp)
    80003d82:	6a42                	ld	s4,16(sp)
    80003d84:	6aa2                	ld	s5,8(sp)
    80003d86:	b735                	j	80003cb2 <end_op+0x44>

0000000080003d88 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003d88:	1101                	addi	sp,sp,-32
    80003d8a:	ec06                	sd	ra,24(sp)
    80003d8c:	e822                	sd	s0,16(sp)
    80003d8e:	e426                	sd	s1,8(sp)
    80003d90:	e04a                	sd	s2,0(sp)
    80003d92:	1000                	addi	s0,sp,32
    80003d94:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003d96:	0001c917          	auipc	s2,0x1c
    80003d9a:	ba290913          	addi	s2,s2,-1118 # 8001f938 <log>
    80003d9e:	854a                	mv	a0,s2
    80003da0:	e53fc0ef          	jal	80000bf2 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003da4:	02892603          	lw	a2,40(s2)
    80003da8:	47f5                	li	a5,29
    80003daa:	04c7cc63          	blt	a5,a2,80003e02 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003dae:	0001c797          	auipc	a5,0x1c
    80003db2:	ba67a783          	lw	a5,-1114(a5) # 8001f954 <log+0x1c>
    80003db6:	04f05c63          	blez	a5,80003e0e <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003dba:	4781                	li	a5,0
    80003dbc:	04c05f63          	blez	a2,80003e1a <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003dc0:	44cc                	lw	a1,12(s1)
    80003dc2:	0001c717          	auipc	a4,0x1c
    80003dc6:	ba270713          	addi	a4,a4,-1118 # 8001f964 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003dca:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003dcc:	4314                	lw	a3,0(a4)
    80003dce:	04b68663          	beq	a3,a1,80003e1a <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003dd2:	2785                	addiw	a5,a5,1
    80003dd4:	0711                	addi	a4,a4,4
    80003dd6:	fef61be3          	bne	a2,a5,80003dcc <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003dda:	0621                	addi	a2,a2,8
    80003ddc:	060a                	slli	a2,a2,0x2
    80003dde:	0001c797          	auipc	a5,0x1c
    80003de2:	b5a78793          	addi	a5,a5,-1190 # 8001f938 <log>
    80003de6:	97b2                	add	a5,a5,a2
    80003de8:	44d8                	lw	a4,12(s1)
    80003dea:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003dec:	8526                	mv	a0,s1
    80003dee:	ef1fe0ef          	jal	80002cde <bpin>
    log.lh.n++;
    80003df2:	0001c717          	auipc	a4,0x1c
    80003df6:	b4670713          	addi	a4,a4,-1210 # 8001f938 <log>
    80003dfa:	571c                	lw	a5,40(a4)
    80003dfc:	2785                	addiw	a5,a5,1
    80003dfe:	d71c                	sw	a5,40(a4)
    80003e00:	a80d                	j	80003e32 <log_write+0xaa>
    panic("too big a transaction");
    80003e02:	00003517          	auipc	a0,0x3
    80003e06:	70e50513          	addi	a0,a0,1806 # 80007510 <etext+0x510>
    80003e0a:	9d7fc0ef          	jal	800007e0 <panic>
    panic("log_write outside of trans");
    80003e0e:	00003517          	auipc	a0,0x3
    80003e12:	71a50513          	addi	a0,a0,1818 # 80007528 <etext+0x528>
    80003e16:	9cbfc0ef          	jal	800007e0 <panic>
  log.lh.block[i] = b->blockno;
    80003e1a:	00878693          	addi	a3,a5,8
    80003e1e:	068a                	slli	a3,a3,0x2
    80003e20:	0001c717          	auipc	a4,0x1c
    80003e24:	b1870713          	addi	a4,a4,-1256 # 8001f938 <log>
    80003e28:	9736                	add	a4,a4,a3
    80003e2a:	44d4                	lw	a3,12(s1)
    80003e2c:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003e2e:	faf60fe3          	beq	a2,a5,80003dec <log_write+0x64>
  }
  release(&log.lock);
    80003e32:	0001c517          	auipc	a0,0x1c
    80003e36:	b0650513          	addi	a0,a0,-1274 # 8001f938 <log>
    80003e3a:	e51fc0ef          	jal	80000c8a <release>
}
    80003e3e:	60e2                	ld	ra,24(sp)
    80003e40:	6442                	ld	s0,16(sp)
    80003e42:	64a2                	ld	s1,8(sp)
    80003e44:	6902                	ld	s2,0(sp)
    80003e46:	6105                	addi	sp,sp,32
    80003e48:	8082                	ret

0000000080003e4a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003e4a:	1101                	addi	sp,sp,-32
    80003e4c:	ec06                	sd	ra,24(sp)
    80003e4e:	e822                	sd	s0,16(sp)
    80003e50:	e426                	sd	s1,8(sp)
    80003e52:	e04a                	sd	s2,0(sp)
    80003e54:	1000                	addi	s0,sp,32
    80003e56:	84aa                	mv	s1,a0
    80003e58:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003e5a:	00003597          	auipc	a1,0x3
    80003e5e:	6ee58593          	addi	a1,a1,1774 # 80007548 <etext+0x548>
    80003e62:	0521                	addi	a0,a0,8
    80003e64:	d0ffc0ef          	jal	80000b72 <initlock>
  lk->name = name;
    80003e68:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003e6c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003e70:	0204a423          	sw	zero,40(s1)
}
    80003e74:	60e2                	ld	ra,24(sp)
    80003e76:	6442                	ld	s0,16(sp)
    80003e78:	64a2                	ld	s1,8(sp)
    80003e7a:	6902                	ld	s2,0(sp)
    80003e7c:	6105                	addi	sp,sp,32
    80003e7e:	8082                	ret

0000000080003e80 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003e80:	1101                	addi	sp,sp,-32
    80003e82:	ec06                	sd	ra,24(sp)
    80003e84:	e822                	sd	s0,16(sp)
    80003e86:	e426                	sd	s1,8(sp)
    80003e88:	e04a                	sd	s2,0(sp)
    80003e8a:	1000                	addi	s0,sp,32
    80003e8c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003e8e:	00850913          	addi	s2,a0,8
    80003e92:	854a                	mv	a0,s2
    80003e94:	d5ffc0ef          	jal	80000bf2 <acquire>
  while (lk->locked) {
    80003e98:	409c                	lw	a5,0(s1)
    80003e9a:	c799                	beqz	a5,80003ea8 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003e9c:	85ca                	mv	a1,s2
    80003e9e:	8526                	mv	a0,s1
    80003ea0:	85cfe0ef          	jal	80001efc <sleep>
  while (lk->locked) {
    80003ea4:	409c                	lw	a5,0(s1)
    80003ea6:	fbfd                	bnez	a5,80003e9c <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003ea8:	4785                	li	a5,1
    80003eaa:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003eac:	a47fd0ef          	jal	800018f2 <myproc>
    80003eb0:	591c                	lw	a5,48(a0)
    80003eb2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003eb4:	854a                	mv	a0,s2
    80003eb6:	dd5fc0ef          	jal	80000c8a <release>
}
    80003eba:	60e2                	ld	ra,24(sp)
    80003ebc:	6442                	ld	s0,16(sp)
    80003ebe:	64a2                	ld	s1,8(sp)
    80003ec0:	6902                	ld	s2,0(sp)
    80003ec2:	6105                	addi	sp,sp,32
    80003ec4:	8082                	ret

0000000080003ec6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003ec6:	1101                	addi	sp,sp,-32
    80003ec8:	ec06                	sd	ra,24(sp)
    80003eca:	e822                	sd	s0,16(sp)
    80003ecc:	e426                	sd	s1,8(sp)
    80003ece:	e04a                	sd	s2,0(sp)
    80003ed0:	1000                	addi	s0,sp,32
    80003ed2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ed4:	00850913          	addi	s2,a0,8
    80003ed8:	854a                	mv	a0,s2
    80003eda:	d19fc0ef          	jal	80000bf2 <acquire>
  lk->locked = 0;
    80003ede:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ee2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003ee6:	8526                	mv	a0,s1
    80003ee8:	860fe0ef          	jal	80001f48 <wakeup>
  release(&lk->lk);
    80003eec:	854a                	mv	a0,s2
    80003eee:	d9dfc0ef          	jal	80000c8a <release>
}
    80003ef2:	60e2                	ld	ra,24(sp)
    80003ef4:	6442                	ld	s0,16(sp)
    80003ef6:	64a2                	ld	s1,8(sp)
    80003ef8:	6902                	ld	s2,0(sp)
    80003efa:	6105                	addi	sp,sp,32
    80003efc:	8082                	ret

0000000080003efe <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003efe:	7179                	addi	sp,sp,-48
    80003f00:	f406                	sd	ra,40(sp)
    80003f02:	f022                	sd	s0,32(sp)
    80003f04:	ec26                	sd	s1,24(sp)
    80003f06:	e84a                	sd	s2,16(sp)
    80003f08:	1800                	addi	s0,sp,48
    80003f0a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003f0c:	00850913          	addi	s2,a0,8
    80003f10:	854a                	mv	a0,s2
    80003f12:	ce1fc0ef          	jal	80000bf2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f16:	409c                	lw	a5,0(s1)
    80003f18:	ef81                	bnez	a5,80003f30 <holdingsleep+0x32>
    80003f1a:	4481                	li	s1,0
  release(&lk->lk);
    80003f1c:	854a                	mv	a0,s2
    80003f1e:	d6dfc0ef          	jal	80000c8a <release>
  return r;
}
    80003f22:	8526                	mv	a0,s1
    80003f24:	70a2                	ld	ra,40(sp)
    80003f26:	7402                	ld	s0,32(sp)
    80003f28:	64e2                	ld	s1,24(sp)
    80003f2a:	6942                	ld	s2,16(sp)
    80003f2c:	6145                	addi	sp,sp,48
    80003f2e:	8082                	ret
    80003f30:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f32:	0284a983          	lw	s3,40(s1)
    80003f36:	9bdfd0ef          	jal	800018f2 <myproc>
    80003f3a:	5904                	lw	s1,48(a0)
    80003f3c:	413484b3          	sub	s1,s1,s3
    80003f40:	0014b493          	seqz	s1,s1
    80003f44:	69a2                	ld	s3,8(sp)
    80003f46:	bfd9                	j	80003f1c <holdingsleep+0x1e>

0000000080003f48 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003f48:	1141                	addi	sp,sp,-16
    80003f4a:	e406                	sd	ra,8(sp)
    80003f4c:	e022                	sd	s0,0(sp)
    80003f4e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003f50:	00003597          	auipc	a1,0x3
    80003f54:	60858593          	addi	a1,a1,1544 # 80007558 <etext+0x558>
    80003f58:	0001c517          	auipc	a0,0x1c
    80003f5c:	b2850513          	addi	a0,a0,-1240 # 8001fa80 <ftable>
    80003f60:	c13fc0ef          	jal	80000b72 <initlock>
}
    80003f64:	60a2                	ld	ra,8(sp)
    80003f66:	6402                	ld	s0,0(sp)
    80003f68:	0141                	addi	sp,sp,16
    80003f6a:	8082                	ret

0000000080003f6c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003f6c:	1101                	addi	sp,sp,-32
    80003f6e:	ec06                	sd	ra,24(sp)
    80003f70:	e822                	sd	s0,16(sp)
    80003f72:	e426                	sd	s1,8(sp)
    80003f74:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003f76:	0001c517          	auipc	a0,0x1c
    80003f7a:	b0a50513          	addi	a0,a0,-1270 # 8001fa80 <ftable>
    80003f7e:	c75fc0ef          	jal	80000bf2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f82:	0001c497          	auipc	s1,0x1c
    80003f86:	b1648493          	addi	s1,s1,-1258 # 8001fa98 <ftable+0x18>
    80003f8a:	0001d717          	auipc	a4,0x1d
    80003f8e:	aae70713          	addi	a4,a4,-1362 # 80020a38 <disk>
    if(f->ref == 0){
    80003f92:	40dc                	lw	a5,4(s1)
    80003f94:	cf89                	beqz	a5,80003fae <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f96:	02848493          	addi	s1,s1,40
    80003f9a:	fee49ce3          	bne	s1,a4,80003f92 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003f9e:	0001c517          	auipc	a0,0x1c
    80003fa2:	ae250513          	addi	a0,a0,-1310 # 8001fa80 <ftable>
    80003fa6:	ce5fc0ef          	jal	80000c8a <release>
  return 0;
    80003faa:	4481                	li	s1,0
    80003fac:	a809                	j	80003fbe <filealloc+0x52>
      f->ref = 1;
    80003fae:	4785                	li	a5,1
    80003fb0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003fb2:	0001c517          	auipc	a0,0x1c
    80003fb6:	ace50513          	addi	a0,a0,-1330 # 8001fa80 <ftable>
    80003fba:	cd1fc0ef          	jal	80000c8a <release>
}
    80003fbe:	8526                	mv	a0,s1
    80003fc0:	60e2                	ld	ra,24(sp)
    80003fc2:	6442                	ld	s0,16(sp)
    80003fc4:	64a2                	ld	s1,8(sp)
    80003fc6:	6105                	addi	sp,sp,32
    80003fc8:	8082                	ret

0000000080003fca <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003fca:	1101                	addi	sp,sp,-32
    80003fcc:	ec06                	sd	ra,24(sp)
    80003fce:	e822                	sd	s0,16(sp)
    80003fd0:	e426                	sd	s1,8(sp)
    80003fd2:	1000                	addi	s0,sp,32
    80003fd4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003fd6:	0001c517          	auipc	a0,0x1c
    80003fda:	aaa50513          	addi	a0,a0,-1366 # 8001fa80 <ftable>
    80003fde:	c15fc0ef          	jal	80000bf2 <acquire>
  if(f->ref < 1)
    80003fe2:	40dc                	lw	a5,4(s1)
    80003fe4:	02f05063          	blez	a5,80004004 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003fe8:	2785                	addiw	a5,a5,1
    80003fea:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003fec:	0001c517          	auipc	a0,0x1c
    80003ff0:	a9450513          	addi	a0,a0,-1388 # 8001fa80 <ftable>
    80003ff4:	c97fc0ef          	jal	80000c8a <release>
  return f;
}
    80003ff8:	8526                	mv	a0,s1
    80003ffa:	60e2                	ld	ra,24(sp)
    80003ffc:	6442                	ld	s0,16(sp)
    80003ffe:	64a2                	ld	s1,8(sp)
    80004000:	6105                	addi	sp,sp,32
    80004002:	8082                	ret
    panic("filedup");
    80004004:	00003517          	auipc	a0,0x3
    80004008:	55c50513          	addi	a0,a0,1372 # 80007560 <etext+0x560>
    8000400c:	fd4fc0ef          	jal	800007e0 <panic>

0000000080004010 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004010:	7139                	addi	sp,sp,-64
    80004012:	fc06                	sd	ra,56(sp)
    80004014:	f822                	sd	s0,48(sp)
    80004016:	f426                	sd	s1,40(sp)
    80004018:	0080                	addi	s0,sp,64
    8000401a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000401c:	0001c517          	auipc	a0,0x1c
    80004020:	a6450513          	addi	a0,a0,-1436 # 8001fa80 <ftable>
    80004024:	bcffc0ef          	jal	80000bf2 <acquire>
  if(f->ref < 1)
    80004028:	40dc                	lw	a5,4(s1)
    8000402a:	04f05a63          	blez	a5,8000407e <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    8000402e:	37fd                	addiw	a5,a5,-1
    80004030:	0007871b          	sext.w	a4,a5
    80004034:	c0dc                	sw	a5,4(s1)
    80004036:	04e04e63          	bgtz	a4,80004092 <fileclose+0x82>
    8000403a:	f04a                	sd	s2,32(sp)
    8000403c:	ec4e                	sd	s3,24(sp)
    8000403e:	e852                	sd	s4,16(sp)
    80004040:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004042:	0004a903          	lw	s2,0(s1)
    80004046:	0094ca83          	lbu	s5,9(s1)
    8000404a:	0104ba03          	ld	s4,16(s1)
    8000404e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004052:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004056:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000405a:	0001c517          	auipc	a0,0x1c
    8000405e:	a2650513          	addi	a0,a0,-1498 # 8001fa80 <ftable>
    80004062:	c29fc0ef          	jal	80000c8a <release>

  if(ff.type == FD_PIPE){
    80004066:	4785                	li	a5,1
    80004068:	04f90063          	beq	s2,a5,800040a8 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000406c:	3979                	addiw	s2,s2,-2
    8000406e:	4785                	li	a5,1
    80004070:	0527f563          	bgeu	a5,s2,800040ba <fileclose+0xaa>
    80004074:	7902                	ld	s2,32(sp)
    80004076:	69e2                	ld	s3,24(sp)
    80004078:	6a42                	ld	s4,16(sp)
    8000407a:	6aa2                	ld	s5,8(sp)
    8000407c:	a00d                	j	8000409e <fileclose+0x8e>
    8000407e:	f04a                	sd	s2,32(sp)
    80004080:	ec4e                	sd	s3,24(sp)
    80004082:	e852                	sd	s4,16(sp)
    80004084:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004086:	00003517          	auipc	a0,0x3
    8000408a:	4e250513          	addi	a0,a0,1250 # 80007568 <etext+0x568>
    8000408e:	f52fc0ef          	jal	800007e0 <panic>
    release(&ftable.lock);
    80004092:	0001c517          	auipc	a0,0x1c
    80004096:	9ee50513          	addi	a0,a0,-1554 # 8001fa80 <ftable>
    8000409a:	bf1fc0ef          	jal	80000c8a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000409e:	70e2                	ld	ra,56(sp)
    800040a0:	7442                	ld	s0,48(sp)
    800040a2:	74a2                	ld	s1,40(sp)
    800040a4:	6121                	addi	sp,sp,64
    800040a6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800040a8:	85d6                	mv	a1,s5
    800040aa:	8552                	mv	a0,s4
    800040ac:	336000ef          	jal	800043e2 <pipeclose>
    800040b0:	7902                	ld	s2,32(sp)
    800040b2:	69e2                	ld	s3,24(sp)
    800040b4:	6a42                	ld	s4,16(sp)
    800040b6:	6aa2                	ld	s5,8(sp)
    800040b8:	b7dd                	j	8000409e <fileclose+0x8e>
    begin_op();
    800040ba:	b4bff0ef          	jal	80003c04 <begin_op>
    iput(ff.ip);
    800040be:	854e                	mv	a0,s3
    800040c0:	adcff0ef          	jal	8000339c <iput>
    end_op();
    800040c4:	babff0ef          	jal	80003c6e <end_op>
    800040c8:	7902                	ld	s2,32(sp)
    800040ca:	69e2                	ld	s3,24(sp)
    800040cc:	6a42                	ld	s4,16(sp)
    800040ce:	6aa2                	ld	s5,8(sp)
    800040d0:	b7f9                	j	8000409e <fileclose+0x8e>

00000000800040d2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800040d2:	715d                	addi	sp,sp,-80
    800040d4:	e486                	sd	ra,72(sp)
    800040d6:	e0a2                	sd	s0,64(sp)
    800040d8:	fc26                	sd	s1,56(sp)
    800040da:	f44e                	sd	s3,40(sp)
    800040dc:	0880                	addi	s0,sp,80
    800040de:	84aa                	mv	s1,a0
    800040e0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800040e2:	811fd0ef          	jal	800018f2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800040e6:	409c                	lw	a5,0(s1)
    800040e8:	37f9                	addiw	a5,a5,-2
    800040ea:	4705                	li	a4,1
    800040ec:	04f76063          	bltu	a4,a5,8000412c <filestat+0x5a>
    800040f0:	f84a                	sd	s2,48(sp)
    800040f2:	892a                	mv	s2,a0
    ilock(f->ip);
    800040f4:	6c88                	ld	a0,24(s1)
    800040f6:	924ff0ef          	jal	8000321a <ilock>
    stati(f->ip, &st);
    800040fa:	fb840593          	addi	a1,s0,-72
    800040fe:	6c88                	ld	a0,24(s1)
    80004100:	c80ff0ef          	jal	80003580 <stati>
    iunlock(f->ip);
    80004104:	6c88                	ld	a0,24(s1)
    80004106:	9c2ff0ef          	jal	800032c8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000410a:	46e1                	li	a3,24
    8000410c:	fb840613          	addi	a2,s0,-72
    80004110:	85ce                	mv	a1,s3
    80004112:	05093503          	ld	a0,80(s2)
    80004116:	cf0fd0ef          	jal	80001606 <copyout>
    8000411a:	41f5551b          	sraiw	a0,a0,0x1f
    8000411e:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004120:	60a6                	ld	ra,72(sp)
    80004122:	6406                	ld	s0,64(sp)
    80004124:	74e2                	ld	s1,56(sp)
    80004126:	79a2                	ld	s3,40(sp)
    80004128:	6161                	addi	sp,sp,80
    8000412a:	8082                	ret
  return -1;
    8000412c:	557d                	li	a0,-1
    8000412e:	bfcd                	j	80004120 <filestat+0x4e>

0000000080004130 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004130:	7179                	addi	sp,sp,-48
    80004132:	f406                	sd	ra,40(sp)
    80004134:	f022                	sd	s0,32(sp)
    80004136:	e84a                	sd	s2,16(sp)
    80004138:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000413a:	00854783          	lbu	a5,8(a0)
    8000413e:	cfd1                	beqz	a5,800041da <fileread+0xaa>
    80004140:	ec26                	sd	s1,24(sp)
    80004142:	e44e                	sd	s3,8(sp)
    80004144:	84aa                	mv	s1,a0
    80004146:	89ae                	mv	s3,a1
    80004148:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000414a:	411c                	lw	a5,0(a0)
    8000414c:	4705                	li	a4,1
    8000414e:	04e78363          	beq	a5,a4,80004194 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004152:	470d                	li	a4,3
    80004154:	04e78763          	beq	a5,a4,800041a2 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004158:	4709                	li	a4,2
    8000415a:	06e79a63          	bne	a5,a4,800041ce <fileread+0x9e>
    ilock(f->ip);
    8000415e:	6d08                	ld	a0,24(a0)
    80004160:	8baff0ef          	jal	8000321a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004164:	874a                	mv	a4,s2
    80004166:	5094                	lw	a3,32(s1)
    80004168:	864e                	mv	a2,s3
    8000416a:	4585                	li	a1,1
    8000416c:	6c88                	ld	a0,24(s1)
    8000416e:	c3cff0ef          	jal	800035aa <readi>
    80004172:	892a                	mv	s2,a0
    80004174:	00a05563          	blez	a0,8000417e <fileread+0x4e>
      f->off += r;
    80004178:	509c                	lw	a5,32(s1)
    8000417a:	9fa9                	addw	a5,a5,a0
    8000417c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000417e:	6c88                	ld	a0,24(s1)
    80004180:	948ff0ef          	jal	800032c8 <iunlock>
    80004184:	64e2                	ld	s1,24(sp)
    80004186:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004188:	854a                	mv	a0,s2
    8000418a:	70a2                	ld	ra,40(sp)
    8000418c:	7402                	ld	s0,32(sp)
    8000418e:	6942                	ld	s2,16(sp)
    80004190:	6145                	addi	sp,sp,48
    80004192:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004194:	6908                	ld	a0,16(a0)
    80004196:	388000ef          	jal	8000451e <piperead>
    8000419a:	892a                	mv	s2,a0
    8000419c:	64e2                	ld	s1,24(sp)
    8000419e:	69a2                	ld	s3,8(sp)
    800041a0:	b7e5                	j	80004188 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800041a2:	02451783          	lh	a5,36(a0)
    800041a6:	03079693          	slli	a3,a5,0x30
    800041aa:	92c1                	srli	a3,a3,0x30
    800041ac:	4725                	li	a4,9
    800041ae:	02d76863          	bltu	a4,a3,800041de <fileread+0xae>
    800041b2:	0792                	slli	a5,a5,0x4
    800041b4:	0001c717          	auipc	a4,0x1c
    800041b8:	82c70713          	addi	a4,a4,-2004 # 8001f9e0 <devsw>
    800041bc:	97ba                	add	a5,a5,a4
    800041be:	639c                	ld	a5,0(a5)
    800041c0:	c39d                	beqz	a5,800041e6 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800041c2:	4505                	li	a0,1
    800041c4:	9782                	jalr	a5
    800041c6:	892a                	mv	s2,a0
    800041c8:	64e2                	ld	s1,24(sp)
    800041ca:	69a2                	ld	s3,8(sp)
    800041cc:	bf75                	j	80004188 <fileread+0x58>
    panic("fileread");
    800041ce:	00003517          	auipc	a0,0x3
    800041d2:	3aa50513          	addi	a0,a0,938 # 80007578 <etext+0x578>
    800041d6:	e0afc0ef          	jal	800007e0 <panic>
    return -1;
    800041da:	597d                	li	s2,-1
    800041dc:	b775                	j	80004188 <fileread+0x58>
      return -1;
    800041de:	597d                	li	s2,-1
    800041e0:	64e2                	ld	s1,24(sp)
    800041e2:	69a2                	ld	s3,8(sp)
    800041e4:	b755                	j	80004188 <fileread+0x58>
    800041e6:	597d                	li	s2,-1
    800041e8:	64e2                	ld	s1,24(sp)
    800041ea:	69a2                	ld	s3,8(sp)
    800041ec:	bf71                	j	80004188 <fileread+0x58>

00000000800041ee <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800041ee:	00954783          	lbu	a5,9(a0)
    800041f2:	10078b63          	beqz	a5,80004308 <filewrite+0x11a>
{
    800041f6:	715d                	addi	sp,sp,-80
    800041f8:	e486                	sd	ra,72(sp)
    800041fa:	e0a2                	sd	s0,64(sp)
    800041fc:	f84a                	sd	s2,48(sp)
    800041fe:	f052                	sd	s4,32(sp)
    80004200:	e85a                	sd	s6,16(sp)
    80004202:	0880                	addi	s0,sp,80
    80004204:	892a                	mv	s2,a0
    80004206:	8b2e                	mv	s6,a1
    80004208:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000420a:	411c                	lw	a5,0(a0)
    8000420c:	4705                	li	a4,1
    8000420e:	02e78763          	beq	a5,a4,8000423c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004212:	470d                	li	a4,3
    80004214:	02e78863          	beq	a5,a4,80004244 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004218:	4709                	li	a4,2
    8000421a:	0ce79c63          	bne	a5,a4,800042f2 <filewrite+0x104>
    8000421e:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004220:	0ac05863          	blez	a2,800042d0 <filewrite+0xe2>
    80004224:	fc26                	sd	s1,56(sp)
    80004226:	ec56                	sd	s5,24(sp)
    80004228:	e45e                	sd	s7,8(sp)
    8000422a:	e062                	sd	s8,0(sp)
    int i = 0;
    8000422c:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000422e:	6b85                	lui	s7,0x1
    80004230:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004234:	6c05                	lui	s8,0x1
    80004236:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000423a:	a8b5                	j	800042b6 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000423c:	6908                	ld	a0,16(a0)
    8000423e:	1fc000ef          	jal	8000443a <pipewrite>
    80004242:	a04d                	j	800042e4 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004244:	02451783          	lh	a5,36(a0)
    80004248:	03079693          	slli	a3,a5,0x30
    8000424c:	92c1                	srli	a3,a3,0x30
    8000424e:	4725                	li	a4,9
    80004250:	0ad76e63          	bltu	a4,a3,8000430c <filewrite+0x11e>
    80004254:	0792                	slli	a5,a5,0x4
    80004256:	0001b717          	auipc	a4,0x1b
    8000425a:	78a70713          	addi	a4,a4,1930 # 8001f9e0 <devsw>
    8000425e:	97ba                	add	a5,a5,a4
    80004260:	679c                	ld	a5,8(a5)
    80004262:	c7dd                	beqz	a5,80004310 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80004264:	4505                	li	a0,1
    80004266:	9782                	jalr	a5
    80004268:	a8b5                	j	800042e4 <filewrite+0xf6>
      if(n1 > max)
    8000426a:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000426e:	997ff0ef          	jal	80003c04 <begin_op>
      ilock(f->ip);
    80004272:	01893503          	ld	a0,24(s2)
    80004276:	fa5fe0ef          	jal	8000321a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000427a:	8756                	mv	a4,s5
    8000427c:	02092683          	lw	a3,32(s2)
    80004280:	01698633          	add	a2,s3,s6
    80004284:	4585                	li	a1,1
    80004286:	01893503          	ld	a0,24(s2)
    8000428a:	c1cff0ef          	jal	800036a6 <writei>
    8000428e:	84aa                	mv	s1,a0
    80004290:	00a05763          	blez	a0,8000429e <filewrite+0xb0>
        f->off += r;
    80004294:	02092783          	lw	a5,32(s2)
    80004298:	9fa9                	addw	a5,a5,a0
    8000429a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000429e:	01893503          	ld	a0,24(s2)
    800042a2:	826ff0ef          	jal	800032c8 <iunlock>
      end_op();
    800042a6:	9c9ff0ef          	jal	80003c6e <end_op>

      if(r != n1){
    800042aa:	029a9563          	bne	s5,s1,800042d4 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800042ae:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800042b2:	0149da63          	bge	s3,s4,800042c6 <filewrite+0xd8>
      int n1 = n - i;
    800042b6:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800042ba:	0004879b          	sext.w	a5,s1
    800042be:	fafbd6e3          	bge	s7,a5,8000426a <filewrite+0x7c>
    800042c2:	84e2                	mv	s1,s8
    800042c4:	b75d                	j	8000426a <filewrite+0x7c>
    800042c6:	74e2                	ld	s1,56(sp)
    800042c8:	6ae2                	ld	s5,24(sp)
    800042ca:	6ba2                	ld	s7,8(sp)
    800042cc:	6c02                	ld	s8,0(sp)
    800042ce:	a039                	j	800042dc <filewrite+0xee>
    int i = 0;
    800042d0:	4981                	li	s3,0
    800042d2:	a029                	j	800042dc <filewrite+0xee>
    800042d4:	74e2                	ld	s1,56(sp)
    800042d6:	6ae2                	ld	s5,24(sp)
    800042d8:	6ba2                	ld	s7,8(sp)
    800042da:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800042dc:	033a1c63          	bne	s4,s3,80004314 <filewrite+0x126>
    800042e0:	8552                	mv	a0,s4
    800042e2:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800042e4:	60a6                	ld	ra,72(sp)
    800042e6:	6406                	ld	s0,64(sp)
    800042e8:	7942                	ld	s2,48(sp)
    800042ea:	7a02                	ld	s4,32(sp)
    800042ec:	6b42                	ld	s6,16(sp)
    800042ee:	6161                	addi	sp,sp,80
    800042f0:	8082                	ret
    800042f2:	fc26                	sd	s1,56(sp)
    800042f4:	f44e                	sd	s3,40(sp)
    800042f6:	ec56                	sd	s5,24(sp)
    800042f8:	e45e                	sd	s7,8(sp)
    800042fa:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800042fc:	00003517          	auipc	a0,0x3
    80004300:	28c50513          	addi	a0,a0,652 # 80007588 <etext+0x588>
    80004304:	cdcfc0ef          	jal	800007e0 <panic>
    return -1;
    80004308:	557d                	li	a0,-1
}
    8000430a:	8082                	ret
      return -1;
    8000430c:	557d                	li	a0,-1
    8000430e:	bfd9                	j	800042e4 <filewrite+0xf6>
    80004310:	557d                	li	a0,-1
    80004312:	bfc9                	j	800042e4 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004314:	557d                	li	a0,-1
    80004316:	79a2                	ld	s3,40(sp)
    80004318:	b7f1                	j	800042e4 <filewrite+0xf6>

000000008000431a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000431a:	7179                	addi	sp,sp,-48
    8000431c:	f406                	sd	ra,40(sp)
    8000431e:	f022                	sd	s0,32(sp)
    80004320:	ec26                	sd	s1,24(sp)
    80004322:	e052                	sd	s4,0(sp)
    80004324:	1800                	addi	s0,sp,48
    80004326:	84aa                	mv	s1,a0
    80004328:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000432a:	0005b023          	sd	zero,0(a1)
    8000432e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004332:	c3bff0ef          	jal	80003f6c <filealloc>
    80004336:	e088                	sd	a0,0(s1)
    80004338:	c549                	beqz	a0,800043c2 <pipealloc+0xa8>
    8000433a:	c33ff0ef          	jal	80003f6c <filealloc>
    8000433e:	00aa3023          	sd	a0,0(s4)
    80004342:	cd25                	beqz	a0,800043ba <pipealloc+0xa0>
    80004344:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004346:	fb8fc0ef          	jal	80000afe <kalloc>
    8000434a:	892a                	mv	s2,a0
    8000434c:	c12d                	beqz	a0,800043ae <pipealloc+0x94>
    8000434e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004350:	4985                	li	s3,1
    80004352:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004356:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000435a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000435e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004362:	00003597          	auipc	a1,0x3
    80004366:	23658593          	addi	a1,a1,566 # 80007598 <etext+0x598>
    8000436a:	809fc0ef          	jal	80000b72 <initlock>
  (*f0)->type = FD_PIPE;
    8000436e:	609c                	ld	a5,0(s1)
    80004370:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004374:	609c                	ld	a5,0(s1)
    80004376:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000437a:	609c                	ld	a5,0(s1)
    8000437c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004380:	609c                	ld	a5,0(s1)
    80004382:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004386:	000a3783          	ld	a5,0(s4)
    8000438a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000438e:	000a3783          	ld	a5,0(s4)
    80004392:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004396:	000a3783          	ld	a5,0(s4)
    8000439a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000439e:	000a3783          	ld	a5,0(s4)
    800043a2:	0127b823          	sd	s2,16(a5)
  return 0;
    800043a6:	4501                	li	a0,0
    800043a8:	6942                	ld	s2,16(sp)
    800043aa:	69a2                	ld	s3,8(sp)
    800043ac:	a01d                	j	800043d2 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800043ae:	6088                	ld	a0,0(s1)
    800043b0:	c119                	beqz	a0,800043b6 <pipealloc+0x9c>
    800043b2:	6942                	ld	s2,16(sp)
    800043b4:	a029                	j	800043be <pipealloc+0xa4>
    800043b6:	6942                	ld	s2,16(sp)
    800043b8:	a029                	j	800043c2 <pipealloc+0xa8>
    800043ba:	6088                	ld	a0,0(s1)
    800043bc:	c10d                	beqz	a0,800043de <pipealloc+0xc4>
    fileclose(*f0);
    800043be:	c53ff0ef          	jal	80004010 <fileclose>
  if(*f1)
    800043c2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800043c6:	557d                	li	a0,-1
  if(*f1)
    800043c8:	c789                	beqz	a5,800043d2 <pipealloc+0xb8>
    fileclose(*f1);
    800043ca:	853e                	mv	a0,a5
    800043cc:	c45ff0ef          	jal	80004010 <fileclose>
  return -1;
    800043d0:	557d                	li	a0,-1
}
    800043d2:	70a2                	ld	ra,40(sp)
    800043d4:	7402                	ld	s0,32(sp)
    800043d6:	64e2                	ld	s1,24(sp)
    800043d8:	6a02                	ld	s4,0(sp)
    800043da:	6145                	addi	sp,sp,48
    800043dc:	8082                	ret
  return -1;
    800043de:	557d                	li	a0,-1
    800043e0:	bfcd                	j	800043d2 <pipealloc+0xb8>

00000000800043e2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800043e2:	1101                	addi	sp,sp,-32
    800043e4:	ec06                	sd	ra,24(sp)
    800043e6:	e822                	sd	s0,16(sp)
    800043e8:	e426                	sd	s1,8(sp)
    800043ea:	e04a                	sd	s2,0(sp)
    800043ec:	1000                	addi	s0,sp,32
    800043ee:	84aa                	mv	s1,a0
    800043f0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800043f2:	801fc0ef          	jal	80000bf2 <acquire>
  if(writable){
    800043f6:	02090763          	beqz	s2,80004424 <pipeclose+0x42>
    pi->writeopen = 0;
    800043fa:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800043fe:	21848513          	addi	a0,s1,536
    80004402:	b47fd0ef          	jal	80001f48 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004406:	2204b783          	ld	a5,544(s1)
    8000440a:	e785                	bnez	a5,80004432 <pipeclose+0x50>
    release(&pi->lock);
    8000440c:	8526                	mv	a0,s1
    8000440e:	87dfc0ef          	jal	80000c8a <release>
    kfree((char*)pi);
    80004412:	8526                	mv	a0,s1
    80004414:	e08fc0ef          	jal	80000a1c <kfree>
  } else
    release(&pi->lock);
}
    80004418:	60e2                	ld	ra,24(sp)
    8000441a:	6442                	ld	s0,16(sp)
    8000441c:	64a2                	ld	s1,8(sp)
    8000441e:	6902                	ld	s2,0(sp)
    80004420:	6105                	addi	sp,sp,32
    80004422:	8082                	ret
    pi->readopen = 0;
    80004424:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004428:	21c48513          	addi	a0,s1,540
    8000442c:	b1dfd0ef          	jal	80001f48 <wakeup>
    80004430:	bfd9                	j	80004406 <pipeclose+0x24>
    release(&pi->lock);
    80004432:	8526                	mv	a0,s1
    80004434:	857fc0ef          	jal	80000c8a <release>
}
    80004438:	b7c5                	j	80004418 <pipeclose+0x36>

000000008000443a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000443a:	711d                	addi	sp,sp,-96
    8000443c:	ec86                	sd	ra,88(sp)
    8000443e:	e8a2                	sd	s0,80(sp)
    80004440:	e4a6                	sd	s1,72(sp)
    80004442:	e0ca                	sd	s2,64(sp)
    80004444:	fc4e                	sd	s3,56(sp)
    80004446:	f852                	sd	s4,48(sp)
    80004448:	f456                	sd	s5,40(sp)
    8000444a:	1080                	addi	s0,sp,96
    8000444c:	84aa                	mv	s1,a0
    8000444e:	8aae                	mv	s5,a1
    80004450:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004452:	ca0fd0ef          	jal	800018f2 <myproc>
    80004456:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004458:	8526                	mv	a0,s1
    8000445a:	f98fc0ef          	jal	80000bf2 <acquire>
  while(i < n){
    8000445e:	0b405a63          	blez	s4,80004512 <pipewrite+0xd8>
    80004462:	f05a                	sd	s6,32(sp)
    80004464:	ec5e                	sd	s7,24(sp)
    80004466:	e862                	sd	s8,16(sp)
  int i = 0;
    80004468:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000446a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000446c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004470:	21c48b93          	addi	s7,s1,540
    80004474:	a81d                	j	800044aa <pipewrite+0x70>
      release(&pi->lock);
    80004476:	8526                	mv	a0,s1
    80004478:	813fc0ef          	jal	80000c8a <release>
      return -1;
    8000447c:	597d                	li	s2,-1
    8000447e:	7b02                	ld	s6,32(sp)
    80004480:	6be2                	ld	s7,24(sp)
    80004482:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004484:	854a                	mv	a0,s2
    80004486:	60e6                	ld	ra,88(sp)
    80004488:	6446                	ld	s0,80(sp)
    8000448a:	64a6                	ld	s1,72(sp)
    8000448c:	6906                	ld	s2,64(sp)
    8000448e:	79e2                	ld	s3,56(sp)
    80004490:	7a42                	ld	s4,48(sp)
    80004492:	7aa2                	ld	s5,40(sp)
    80004494:	6125                	addi	sp,sp,96
    80004496:	8082                	ret
      wakeup(&pi->nread);
    80004498:	8562                	mv	a0,s8
    8000449a:	aaffd0ef          	jal	80001f48 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000449e:	85a6                	mv	a1,s1
    800044a0:	855e                	mv	a0,s7
    800044a2:	a5bfd0ef          	jal	80001efc <sleep>
  while(i < n){
    800044a6:	05495b63          	bge	s2,s4,800044fc <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800044aa:	2204a783          	lw	a5,544(s1)
    800044ae:	d7e1                	beqz	a5,80004476 <pipewrite+0x3c>
    800044b0:	854e                	mv	a0,s3
    800044b2:	c83fd0ef          	jal	80002134 <killed>
    800044b6:	f161                	bnez	a0,80004476 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800044b8:	2184a783          	lw	a5,536(s1)
    800044bc:	21c4a703          	lw	a4,540(s1)
    800044c0:	2007879b          	addiw	a5,a5,512
    800044c4:	fcf70ae3          	beq	a4,a5,80004498 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800044c8:	4685                	li	a3,1
    800044ca:	01590633          	add	a2,s2,s5
    800044ce:	faf40593          	addi	a1,s0,-81
    800044d2:	0509b503          	ld	a0,80(s3)
    800044d6:	a14fd0ef          	jal	800016ea <copyin>
    800044da:	03650e63          	beq	a0,s6,80004516 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800044de:	21c4a783          	lw	a5,540(s1)
    800044e2:	0017871b          	addiw	a4,a5,1
    800044e6:	20e4ae23          	sw	a4,540(s1)
    800044ea:	1ff7f793          	andi	a5,a5,511
    800044ee:	97a6                	add	a5,a5,s1
    800044f0:	faf44703          	lbu	a4,-81(s0)
    800044f4:	00e78c23          	sb	a4,24(a5)
      i++;
    800044f8:	2905                	addiw	s2,s2,1
    800044fa:	b775                	j	800044a6 <pipewrite+0x6c>
    800044fc:	7b02                	ld	s6,32(sp)
    800044fe:	6be2                	ld	s7,24(sp)
    80004500:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004502:	21848513          	addi	a0,s1,536
    80004506:	a43fd0ef          	jal	80001f48 <wakeup>
  release(&pi->lock);
    8000450a:	8526                	mv	a0,s1
    8000450c:	f7efc0ef          	jal	80000c8a <release>
  return i;
    80004510:	bf95                	j	80004484 <pipewrite+0x4a>
  int i = 0;
    80004512:	4901                	li	s2,0
    80004514:	b7fd                	j	80004502 <pipewrite+0xc8>
    80004516:	7b02                	ld	s6,32(sp)
    80004518:	6be2                	ld	s7,24(sp)
    8000451a:	6c42                	ld	s8,16(sp)
    8000451c:	b7dd                	j	80004502 <pipewrite+0xc8>

000000008000451e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000451e:	715d                	addi	sp,sp,-80
    80004520:	e486                	sd	ra,72(sp)
    80004522:	e0a2                	sd	s0,64(sp)
    80004524:	fc26                	sd	s1,56(sp)
    80004526:	f84a                	sd	s2,48(sp)
    80004528:	f44e                	sd	s3,40(sp)
    8000452a:	f052                	sd	s4,32(sp)
    8000452c:	ec56                	sd	s5,24(sp)
    8000452e:	0880                	addi	s0,sp,80
    80004530:	84aa                	mv	s1,a0
    80004532:	892e                	mv	s2,a1
    80004534:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004536:	bbcfd0ef          	jal	800018f2 <myproc>
    8000453a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000453c:	8526                	mv	a0,s1
    8000453e:	eb4fc0ef          	jal	80000bf2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004542:	2184a703          	lw	a4,536(s1)
    80004546:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000454a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000454e:	02f71563          	bne	a4,a5,80004578 <piperead+0x5a>
    80004552:	2244a783          	lw	a5,548(s1)
    80004556:	cb85                	beqz	a5,80004586 <piperead+0x68>
    if(killed(pr)){
    80004558:	8552                	mv	a0,s4
    8000455a:	bdbfd0ef          	jal	80002134 <killed>
    8000455e:	ed19                	bnez	a0,8000457c <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004560:	85a6                	mv	a1,s1
    80004562:	854e                	mv	a0,s3
    80004564:	999fd0ef          	jal	80001efc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004568:	2184a703          	lw	a4,536(s1)
    8000456c:	21c4a783          	lw	a5,540(s1)
    80004570:	fef701e3          	beq	a4,a5,80004552 <piperead+0x34>
    80004574:	e85a                	sd	s6,16(sp)
    80004576:	a809                	j	80004588 <piperead+0x6a>
    80004578:	e85a                	sd	s6,16(sp)
    8000457a:	a039                	j	80004588 <piperead+0x6a>
      release(&pi->lock);
    8000457c:	8526                	mv	a0,s1
    8000457e:	f0cfc0ef          	jal	80000c8a <release>
      return -1;
    80004582:	59fd                	li	s3,-1
    80004584:	a8b9                	j	800045e2 <piperead+0xc4>
    80004586:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004588:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    8000458a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000458c:	05505363          	blez	s5,800045d2 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004590:	2184a783          	lw	a5,536(s1)
    80004594:	21c4a703          	lw	a4,540(s1)
    80004598:	02f70d63          	beq	a4,a5,800045d2 <piperead+0xb4>
    ch = pi->data[pi->nread % PIPESIZE];
    8000459c:	1ff7f793          	andi	a5,a5,511
    800045a0:	97a6                	add	a5,a5,s1
    800045a2:	0187c783          	lbu	a5,24(a5)
    800045a6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    800045aa:	4685                	li	a3,1
    800045ac:	fbf40613          	addi	a2,s0,-65
    800045b0:	85ca                	mv	a1,s2
    800045b2:	050a3503          	ld	a0,80(s4)
    800045b6:	850fd0ef          	jal	80001606 <copyout>
    800045ba:	03650e63          	beq	a0,s6,800045f6 <piperead+0xd8>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    800045be:	2184a783          	lw	a5,536(s1)
    800045c2:	2785                	addiw	a5,a5,1
    800045c4:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045c8:	2985                	addiw	s3,s3,1
    800045ca:	0905                	addi	s2,s2,1
    800045cc:	fd3a92e3          	bne	s5,s3,80004590 <piperead+0x72>
    800045d0:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800045d2:	21c48513          	addi	a0,s1,540
    800045d6:	973fd0ef          	jal	80001f48 <wakeup>
  release(&pi->lock);
    800045da:	8526                	mv	a0,s1
    800045dc:	eaefc0ef          	jal	80000c8a <release>
    800045e0:	6b42                	ld	s6,16(sp)
  return i;
}
    800045e2:	854e                	mv	a0,s3
    800045e4:	60a6                	ld	ra,72(sp)
    800045e6:	6406                	ld	s0,64(sp)
    800045e8:	74e2                	ld	s1,56(sp)
    800045ea:	7942                	ld	s2,48(sp)
    800045ec:	79a2                	ld	s3,40(sp)
    800045ee:	7a02                	ld	s4,32(sp)
    800045f0:	6ae2                	ld	s5,24(sp)
    800045f2:	6161                	addi	sp,sp,80
    800045f4:	8082                	ret
      if(i == 0)
    800045f6:	fc099ee3          	bnez	s3,800045d2 <piperead+0xb4>
        i = -1;
    800045fa:	89aa                	mv	s3,a0
    800045fc:	bfd9                	j	800045d2 <piperead+0xb4>

00000000800045fe <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    800045fe:	1141                	addi	sp,sp,-16
    80004600:	e422                	sd	s0,8(sp)
    80004602:	0800                	addi	s0,sp,16
    80004604:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004606:	8905                	andi	a0,a0,1
    80004608:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000460a:	8b89                	andi	a5,a5,2
    8000460c:	c399                	beqz	a5,80004612 <flags2perm+0x14>
      perm |= PTE_W;
    8000460e:	00456513          	ori	a0,a0,4
    return perm;
}
    80004612:	6422                	ld	s0,8(sp)
    80004614:	0141                	addi	sp,sp,16
    80004616:	8082                	ret

0000000080004618 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004618:	df010113          	addi	sp,sp,-528
    8000461c:	20113423          	sd	ra,520(sp)
    80004620:	20813023          	sd	s0,512(sp)
    80004624:	ffa6                	sd	s1,504(sp)
    80004626:	fbca                	sd	s2,496(sp)
    80004628:	0c00                	addi	s0,sp,528
    8000462a:	892a                	mv	s2,a0
    8000462c:	dea43c23          	sd	a0,-520(s0)
    80004630:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004634:	abefd0ef          	jal	800018f2 <myproc>
    80004638:	84aa                	mv	s1,a0

  begin_op();
    8000463a:	dcaff0ef          	jal	80003c04 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    8000463e:	854a                	mv	a0,s2
    80004640:	bf0ff0ef          	jal	80003a30 <namei>
    80004644:	c931                	beqz	a0,80004698 <kexec+0x80>
    80004646:	f3d2                	sd	s4,480(sp)
    80004648:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000464a:	bd1fe0ef          	jal	8000321a <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000464e:	04000713          	li	a4,64
    80004652:	4681                	li	a3,0
    80004654:	e5040613          	addi	a2,s0,-432
    80004658:	4581                	li	a1,0
    8000465a:	8552                	mv	a0,s4
    8000465c:	f4ffe0ef          	jal	800035aa <readi>
    80004660:	04000793          	li	a5,64
    80004664:	00f51a63          	bne	a0,a5,80004678 <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80004668:	e5042703          	lw	a4,-432(s0)
    8000466c:	464c47b7          	lui	a5,0x464c4
    80004670:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004674:	02f70663          	beq	a4,a5,800046a0 <kexec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004678:	8552                	mv	a0,s4
    8000467a:	dabfe0ef          	jal	80003424 <iunlockput>
    end_op();
    8000467e:	df0ff0ef          	jal	80003c6e <end_op>
  }
  return -1;
    80004682:	557d                	li	a0,-1
    80004684:	7a1e                	ld	s4,480(sp)
}
    80004686:	20813083          	ld	ra,520(sp)
    8000468a:	20013403          	ld	s0,512(sp)
    8000468e:	74fe                	ld	s1,504(sp)
    80004690:	795e                	ld	s2,496(sp)
    80004692:	21010113          	addi	sp,sp,528
    80004696:	8082                	ret
    end_op();
    80004698:	dd6ff0ef          	jal	80003c6e <end_op>
    return -1;
    8000469c:	557d                	li	a0,-1
    8000469e:	b7e5                	j	80004686 <kexec+0x6e>
    800046a0:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800046a2:	8526                	mv	a0,s1
    800046a4:	b54fd0ef          	jal	800019f8 <proc_pagetable>
    800046a8:	8b2a                	mv	s6,a0
    800046aa:	2c050b63          	beqz	a0,80004980 <kexec+0x368>
    800046ae:	f7ce                	sd	s3,488(sp)
    800046b0:	efd6                	sd	s5,472(sp)
    800046b2:	e7de                	sd	s7,456(sp)
    800046b4:	e3e2                	sd	s8,448(sp)
    800046b6:	ff66                	sd	s9,440(sp)
    800046b8:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800046ba:	e7042d03          	lw	s10,-400(s0)
    800046be:	e8845783          	lhu	a5,-376(s0)
    800046c2:	12078963          	beqz	a5,800047f4 <kexec+0x1dc>
    800046c6:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800046c8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800046ca:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800046cc:	6c85                	lui	s9,0x1
    800046ce:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800046d2:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800046d6:	6a85                	lui	s5,0x1
    800046d8:	a085                	j	80004738 <kexec+0x120>
      panic("loadseg: address should exist");
    800046da:	00003517          	auipc	a0,0x3
    800046de:	ec650513          	addi	a0,a0,-314 # 800075a0 <etext+0x5a0>
    800046e2:	8fefc0ef          	jal	800007e0 <panic>
    if(sz - i < PGSIZE)
    800046e6:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800046e8:	8726                	mv	a4,s1
    800046ea:	012c06bb          	addw	a3,s8,s2
    800046ee:	4581                	li	a1,0
    800046f0:	8552                	mv	a0,s4
    800046f2:	eb9fe0ef          	jal	800035aa <readi>
    800046f6:	2501                	sext.w	a0,a0
    800046f8:	24a49a63          	bne	s1,a0,8000494c <kexec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800046fc:	012a893b          	addw	s2,s5,s2
    80004700:	03397363          	bgeu	s2,s3,80004726 <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004704:	02091593          	slli	a1,s2,0x20
    80004708:	9181                	srli	a1,a1,0x20
    8000470a:	95de                	add	a1,a1,s7
    8000470c:	855a                	mv	a0,s6
    8000470e:	8c7fc0ef          	jal	80000fd4 <walkaddr>
    80004712:	862a                	mv	a2,a0
    if(pa == 0)
    80004714:	d179                	beqz	a0,800046da <kexec+0xc2>
    if(sz - i < PGSIZE)
    80004716:	412984bb          	subw	s1,s3,s2
    8000471a:	0004879b          	sext.w	a5,s1
    8000471e:	fcfcf4e3          	bgeu	s9,a5,800046e6 <kexec+0xce>
    80004722:	84d6                	mv	s1,s5
    80004724:	b7c9                	j	800046e6 <kexec+0xce>
    sz = sz1;
    80004726:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000472a:	2d85                	addiw	s11,s11,1
    8000472c:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004730:	e8845783          	lhu	a5,-376(s0)
    80004734:	08fdd063          	bge	s11,a5,800047b4 <kexec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004738:	2d01                	sext.w	s10,s10
    8000473a:	03800713          	li	a4,56
    8000473e:	86ea                	mv	a3,s10
    80004740:	e1840613          	addi	a2,s0,-488
    80004744:	4581                	li	a1,0
    80004746:	8552                	mv	a0,s4
    80004748:	e63fe0ef          	jal	800035aa <readi>
    8000474c:	03800793          	li	a5,56
    80004750:	1cf51663          	bne	a0,a5,8000491c <kexec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004754:	e1842783          	lw	a5,-488(s0)
    80004758:	4705                	li	a4,1
    8000475a:	fce798e3          	bne	a5,a4,8000472a <kexec+0x112>
    if(ph.memsz < ph.filesz)
    8000475e:	e4043483          	ld	s1,-448(s0)
    80004762:	e3843783          	ld	a5,-456(s0)
    80004766:	1af4ef63          	bltu	s1,a5,80004924 <kexec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000476a:	e2843783          	ld	a5,-472(s0)
    8000476e:	94be                	add	s1,s1,a5
    80004770:	1af4ee63          	bltu	s1,a5,8000492c <kexec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004774:	df043703          	ld	a4,-528(s0)
    80004778:	8ff9                	and	a5,a5,a4
    8000477a:	1a079d63          	bnez	a5,80004934 <kexec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000477e:	e1c42503          	lw	a0,-484(s0)
    80004782:	e7dff0ef          	jal	800045fe <flags2perm>
    80004786:	86aa                	mv	a3,a0
    80004788:	8626                	mv	a2,s1
    8000478a:	85ca                	mv	a1,s2
    8000478c:	855a                	mv	a0,s6
    8000478e:	b1ffc0ef          	jal	800012ac <uvmalloc>
    80004792:	e0a43423          	sd	a0,-504(s0)
    80004796:	1a050363          	beqz	a0,8000493c <kexec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000479a:	e2843b83          	ld	s7,-472(s0)
    8000479e:	e2042c03          	lw	s8,-480(s0)
    800047a2:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800047a6:	00098463          	beqz	s3,800047ae <kexec+0x196>
    800047aa:	4901                	li	s2,0
    800047ac:	bfa1                	j	80004704 <kexec+0xec>
    sz = sz1;
    800047ae:	e0843903          	ld	s2,-504(s0)
    800047b2:	bfa5                	j	8000472a <kexec+0x112>
    800047b4:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800047b6:	8552                	mv	a0,s4
    800047b8:	c6dfe0ef          	jal	80003424 <iunlockput>
  end_op();
    800047bc:	cb2ff0ef          	jal	80003c6e <end_op>
  p = myproc();
    800047c0:	932fd0ef          	jal	800018f2 <myproc>
    800047c4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800047c6:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800047ca:	6985                	lui	s3,0x1
    800047cc:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800047ce:	99ca                	add	s3,s3,s2
    800047d0:	77fd                	lui	a5,0xfffff
    800047d2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800047d6:	4691                	li	a3,4
    800047d8:	6609                	lui	a2,0x2
    800047da:	964e                	add	a2,a2,s3
    800047dc:	85ce                	mv	a1,s3
    800047de:	855a                	mv	a0,s6
    800047e0:	acdfc0ef          	jal	800012ac <uvmalloc>
    800047e4:	892a                	mv	s2,a0
    800047e6:	e0a43423          	sd	a0,-504(s0)
    800047ea:	e519                	bnez	a0,800047f8 <kexec+0x1e0>
  if(pagetable)
    800047ec:	e1343423          	sd	s3,-504(s0)
    800047f0:	4a01                	li	s4,0
    800047f2:	aab1                	j	8000494e <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800047f4:	4901                	li	s2,0
    800047f6:	b7c1                	j	800047b6 <kexec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800047f8:	75f9                	lui	a1,0xffffe
    800047fa:	95aa                	add	a1,a1,a0
    800047fc:	855a                	mv	a0,s6
    800047fe:	c85fc0ef          	jal	80001482 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004802:	7bfd                	lui	s7,0xfffff
    80004804:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004806:	e0043783          	ld	a5,-512(s0)
    8000480a:	6388                	ld	a0,0(a5)
    8000480c:	cd39                	beqz	a0,8000486a <kexec+0x252>
    8000480e:	e9040993          	addi	s3,s0,-368
    80004812:	f9040c13          	addi	s8,s0,-112
    80004816:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004818:	e1efc0ef          	jal	80000e36 <strlen>
    8000481c:	0015079b          	addiw	a5,a0,1
    80004820:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004824:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004828:	11796e63          	bltu	s2,s7,80004944 <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000482c:	e0043d03          	ld	s10,-512(s0)
    80004830:	000d3a03          	ld	s4,0(s10)
    80004834:	8552                	mv	a0,s4
    80004836:	e00fc0ef          	jal	80000e36 <strlen>
    8000483a:	0015069b          	addiw	a3,a0,1
    8000483e:	8652                	mv	a2,s4
    80004840:	85ca                	mv	a1,s2
    80004842:	855a                	mv	a0,s6
    80004844:	dc3fc0ef          	jal	80001606 <copyout>
    80004848:	10054063          	bltz	a0,80004948 <kexec+0x330>
    ustack[argc] = sp;
    8000484c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004850:	0485                	addi	s1,s1,1
    80004852:	008d0793          	addi	a5,s10,8
    80004856:	e0f43023          	sd	a5,-512(s0)
    8000485a:	008d3503          	ld	a0,8(s10)
    8000485e:	c909                	beqz	a0,80004870 <kexec+0x258>
    if(argc >= MAXARG)
    80004860:	09a1                	addi	s3,s3,8
    80004862:	fb899be3          	bne	s3,s8,80004818 <kexec+0x200>
  ip = 0;
    80004866:	4a01                	li	s4,0
    80004868:	a0dd                	j	8000494e <kexec+0x336>
  sp = sz;
    8000486a:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000486e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004870:	00349793          	slli	a5,s1,0x3
    80004874:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffde418>
    80004878:	97a2                	add	a5,a5,s0
    8000487a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000487e:	00148693          	addi	a3,s1,1
    80004882:	068e                	slli	a3,a3,0x3
    80004884:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004888:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000488c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004890:	f5796ee3          	bltu	s2,s7,800047ec <kexec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004894:	e9040613          	addi	a2,s0,-368
    80004898:	85ca                	mv	a1,s2
    8000489a:	855a                	mv	a0,s6
    8000489c:	d6bfc0ef          	jal	80001606 <copyout>
    800048a0:	0e054263          	bltz	a0,80004984 <kexec+0x36c>
  p->trapframe->a1 = sp;
    800048a4:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800048a8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800048ac:	df843783          	ld	a5,-520(s0)
    800048b0:	0007c703          	lbu	a4,0(a5)
    800048b4:	cf11                	beqz	a4,800048d0 <kexec+0x2b8>
    800048b6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800048b8:	02f00693          	li	a3,47
    800048bc:	a039                	j	800048ca <kexec+0x2b2>
      last = s+1;
    800048be:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800048c2:	0785                	addi	a5,a5,1
    800048c4:	fff7c703          	lbu	a4,-1(a5)
    800048c8:	c701                	beqz	a4,800048d0 <kexec+0x2b8>
    if(*s == '/')
    800048ca:	fed71ce3          	bne	a4,a3,800048c2 <kexec+0x2aa>
    800048ce:	bfc5                	j	800048be <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    800048d0:	4641                	li	a2,16
    800048d2:	df843583          	ld	a1,-520(s0)
    800048d6:	158a8513          	addi	a0,s5,344
    800048da:	d2afc0ef          	jal	80000e04 <safestrcpy>
  oldpagetable = p->pagetable;
    800048de:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800048e2:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800048e6:	e0843783          	ld	a5,-504(s0)
    800048ea:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    800048ee:	058ab783          	ld	a5,88(s5)
    800048f2:	e6843703          	ld	a4,-408(s0)
    800048f6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800048f8:	058ab783          	ld	a5,88(s5)
    800048fc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004900:	85e6                	mv	a1,s9
    80004902:	97afd0ef          	jal	80001a7c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004906:	0004851b          	sext.w	a0,s1
    8000490a:	79be                	ld	s3,488(sp)
    8000490c:	7a1e                	ld	s4,480(sp)
    8000490e:	6afe                	ld	s5,472(sp)
    80004910:	6b5e                	ld	s6,464(sp)
    80004912:	6bbe                	ld	s7,456(sp)
    80004914:	6c1e                	ld	s8,448(sp)
    80004916:	7cfa                	ld	s9,440(sp)
    80004918:	7d5a                	ld	s10,432(sp)
    8000491a:	b3b5                	j	80004686 <kexec+0x6e>
    8000491c:	e1243423          	sd	s2,-504(s0)
    80004920:	7dba                	ld	s11,424(sp)
    80004922:	a035                	j	8000494e <kexec+0x336>
    80004924:	e1243423          	sd	s2,-504(s0)
    80004928:	7dba                	ld	s11,424(sp)
    8000492a:	a015                	j	8000494e <kexec+0x336>
    8000492c:	e1243423          	sd	s2,-504(s0)
    80004930:	7dba                	ld	s11,424(sp)
    80004932:	a831                	j	8000494e <kexec+0x336>
    80004934:	e1243423          	sd	s2,-504(s0)
    80004938:	7dba                	ld	s11,424(sp)
    8000493a:	a811                	j	8000494e <kexec+0x336>
    8000493c:	e1243423          	sd	s2,-504(s0)
    80004940:	7dba                	ld	s11,424(sp)
    80004942:	a031                	j	8000494e <kexec+0x336>
  ip = 0;
    80004944:	4a01                	li	s4,0
    80004946:	a021                	j	8000494e <kexec+0x336>
    80004948:	4a01                	li	s4,0
  if(pagetable)
    8000494a:	a011                	j	8000494e <kexec+0x336>
    8000494c:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000494e:	e0843583          	ld	a1,-504(s0)
    80004952:	855a                	mv	a0,s6
    80004954:	928fd0ef          	jal	80001a7c <proc_freepagetable>
  return -1;
    80004958:	557d                	li	a0,-1
  if(ip){
    8000495a:	000a1b63          	bnez	s4,80004970 <kexec+0x358>
    8000495e:	79be                	ld	s3,488(sp)
    80004960:	7a1e                	ld	s4,480(sp)
    80004962:	6afe                	ld	s5,472(sp)
    80004964:	6b5e                	ld	s6,464(sp)
    80004966:	6bbe                	ld	s7,456(sp)
    80004968:	6c1e                	ld	s8,448(sp)
    8000496a:	7cfa                	ld	s9,440(sp)
    8000496c:	7d5a                	ld	s10,432(sp)
    8000496e:	bb21                	j	80004686 <kexec+0x6e>
    80004970:	79be                	ld	s3,488(sp)
    80004972:	6afe                	ld	s5,472(sp)
    80004974:	6b5e                	ld	s6,464(sp)
    80004976:	6bbe                	ld	s7,456(sp)
    80004978:	6c1e                	ld	s8,448(sp)
    8000497a:	7cfa                	ld	s9,440(sp)
    8000497c:	7d5a                	ld	s10,432(sp)
    8000497e:	b9ed                	j	80004678 <kexec+0x60>
    80004980:	6b5e                	ld	s6,464(sp)
    80004982:	b9dd                	j	80004678 <kexec+0x60>
  sz = sz1;
    80004984:	e0843983          	ld	s3,-504(s0)
    80004988:	b595                	j	800047ec <kexec+0x1d4>

000000008000498a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000498a:	7179                	addi	sp,sp,-48
    8000498c:	f406                	sd	ra,40(sp)
    8000498e:	f022                	sd	s0,32(sp)
    80004990:	ec26                	sd	s1,24(sp)
    80004992:	e84a                	sd	s2,16(sp)
    80004994:	1800                	addi	s0,sp,48
    80004996:	892e                	mv	s2,a1
    80004998:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000499a:	fdc40593          	addi	a1,s0,-36
    8000499e:	e63fd0ef          	jal	80002800 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800049a2:	fdc42703          	lw	a4,-36(s0)
    800049a6:	47bd                	li	a5,15
    800049a8:	02e7e963          	bltu	a5,a4,800049da <argfd+0x50>
    800049ac:	f47fc0ef          	jal	800018f2 <myproc>
    800049b0:	fdc42703          	lw	a4,-36(s0)
    800049b4:	01a70793          	addi	a5,a4,26
    800049b8:	078e                	slli	a5,a5,0x3
    800049ba:	953e                	add	a0,a0,a5
    800049bc:	611c                	ld	a5,0(a0)
    800049be:	c385                	beqz	a5,800049de <argfd+0x54>
    return -1;
  if(pfd)
    800049c0:	00090463          	beqz	s2,800049c8 <argfd+0x3e>
    *pfd = fd;
    800049c4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800049c8:	4501                	li	a0,0
  if(pf)
    800049ca:	c091                	beqz	s1,800049ce <argfd+0x44>
    *pf = f;
    800049cc:	e09c                	sd	a5,0(s1)
}
    800049ce:	70a2                	ld	ra,40(sp)
    800049d0:	7402                	ld	s0,32(sp)
    800049d2:	64e2                	ld	s1,24(sp)
    800049d4:	6942                	ld	s2,16(sp)
    800049d6:	6145                	addi	sp,sp,48
    800049d8:	8082                	ret
    return -1;
    800049da:	557d                	li	a0,-1
    800049dc:	bfcd                	j	800049ce <argfd+0x44>
    800049de:	557d                	li	a0,-1
    800049e0:	b7fd                	j	800049ce <argfd+0x44>

00000000800049e2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800049e2:	1101                	addi	sp,sp,-32
    800049e4:	ec06                	sd	ra,24(sp)
    800049e6:	e822                	sd	s0,16(sp)
    800049e8:	e426                	sd	s1,8(sp)
    800049ea:	1000                	addi	s0,sp,32
    800049ec:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800049ee:	f05fc0ef          	jal	800018f2 <myproc>
    800049f2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800049f4:	0d050793          	addi	a5,a0,208
    800049f8:	4501                	li	a0,0
    800049fa:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800049fc:	6398                	ld	a4,0(a5)
    800049fe:	cb19                	beqz	a4,80004a14 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004a00:	2505                	addiw	a0,a0,1
    80004a02:	07a1                	addi	a5,a5,8
    80004a04:	fed51ce3          	bne	a0,a3,800049fc <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004a08:	557d                	li	a0,-1
}
    80004a0a:	60e2                	ld	ra,24(sp)
    80004a0c:	6442                	ld	s0,16(sp)
    80004a0e:	64a2                	ld	s1,8(sp)
    80004a10:	6105                	addi	sp,sp,32
    80004a12:	8082                	ret
      p->ofile[fd] = f;
    80004a14:	01a50793          	addi	a5,a0,26
    80004a18:	078e                	slli	a5,a5,0x3
    80004a1a:	963e                	add	a2,a2,a5
    80004a1c:	e204                	sd	s1,0(a2)
      return fd;
    80004a1e:	b7f5                	j	80004a0a <fdalloc+0x28>

0000000080004a20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004a20:	715d                	addi	sp,sp,-80
    80004a22:	e486                	sd	ra,72(sp)
    80004a24:	e0a2                	sd	s0,64(sp)
    80004a26:	fc26                	sd	s1,56(sp)
    80004a28:	f84a                	sd	s2,48(sp)
    80004a2a:	f44e                	sd	s3,40(sp)
    80004a2c:	ec56                	sd	s5,24(sp)
    80004a2e:	e85a                	sd	s6,16(sp)
    80004a30:	0880                	addi	s0,sp,80
    80004a32:	8b2e                	mv	s6,a1
    80004a34:	89b2                	mv	s3,a2
    80004a36:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004a38:	fb040593          	addi	a1,s0,-80
    80004a3c:	80eff0ef          	jal	80003a4a <nameiparent>
    80004a40:	84aa                	mv	s1,a0
    80004a42:	10050a63          	beqz	a0,80004b56 <create+0x136>
    return 0;

  ilock(dp);
    80004a46:	fd4fe0ef          	jal	8000321a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004a4a:	4601                	li	a2,0
    80004a4c:	fb040593          	addi	a1,s0,-80
    80004a50:	8526                	mv	a0,s1
    80004a52:	d79fe0ef          	jal	800037ca <dirlookup>
    80004a56:	8aaa                	mv	s5,a0
    80004a58:	c129                	beqz	a0,80004a9a <create+0x7a>
    iunlockput(dp);
    80004a5a:	8526                	mv	a0,s1
    80004a5c:	9c9fe0ef          	jal	80003424 <iunlockput>
    ilock(ip);
    80004a60:	8556                	mv	a0,s5
    80004a62:	fb8fe0ef          	jal	8000321a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004a66:	4789                	li	a5,2
    80004a68:	02fb1463          	bne	s6,a5,80004a90 <create+0x70>
    80004a6c:	044ad783          	lhu	a5,68(s5)
    80004a70:	37f9                	addiw	a5,a5,-2
    80004a72:	17c2                	slli	a5,a5,0x30
    80004a74:	93c1                	srli	a5,a5,0x30
    80004a76:	4705                	li	a4,1
    80004a78:	00f76c63          	bltu	a4,a5,80004a90 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004a7c:	8556                	mv	a0,s5
    80004a7e:	60a6                	ld	ra,72(sp)
    80004a80:	6406                	ld	s0,64(sp)
    80004a82:	74e2                	ld	s1,56(sp)
    80004a84:	7942                	ld	s2,48(sp)
    80004a86:	79a2                	ld	s3,40(sp)
    80004a88:	6ae2                	ld	s5,24(sp)
    80004a8a:	6b42                	ld	s6,16(sp)
    80004a8c:	6161                	addi	sp,sp,80
    80004a8e:	8082                	ret
    iunlockput(ip);
    80004a90:	8556                	mv	a0,s5
    80004a92:	993fe0ef          	jal	80003424 <iunlockput>
    return 0;
    80004a96:	4a81                	li	s5,0
    80004a98:	b7d5                	j	80004a7c <create+0x5c>
    80004a9a:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004a9c:	85da                	mv	a1,s6
    80004a9e:	4088                	lw	a0,0(s1)
    80004aa0:	e0afe0ef          	jal	800030aa <ialloc>
    80004aa4:	8a2a                	mv	s4,a0
    80004aa6:	cd15                	beqz	a0,80004ae2 <create+0xc2>
  ilock(ip);
    80004aa8:	f72fe0ef          	jal	8000321a <ilock>
  ip->major = major;
    80004aac:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004ab0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004ab4:	4905                	li	s2,1
    80004ab6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004aba:	8552                	mv	a0,s4
    80004abc:	eaafe0ef          	jal	80003166 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004ac0:	032b0763          	beq	s6,s2,80004aee <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004ac4:	004a2603          	lw	a2,4(s4)
    80004ac8:	fb040593          	addi	a1,s0,-80
    80004acc:	8526                	mv	a0,s1
    80004ace:	ec9fe0ef          	jal	80003996 <dirlink>
    80004ad2:	06054563          	bltz	a0,80004b3c <create+0x11c>
  iunlockput(dp);
    80004ad6:	8526                	mv	a0,s1
    80004ad8:	94dfe0ef          	jal	80003424 <iunlockput>
  return ip;
    80004adc:	8ad2                	mv	s5,s4
    80004ade:	7a02                	ld	s4,32(sp)
    80004ae0:	bf71                	j	80004a7c <create+0x5c>
    iunlockput(dp);
    80004ae2:	8526                	mv	a0,s1
    80004ae4:	941fe0ef          	jal	80003424 <iunlockput>
    return 0;
    80004ae8:	8ad2                	mv	s5,s4
    80004aea:	7a02                	ld	s4,32(sp)
    80004aec:	bf41                	j	80004a7c <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004aee:	004a2603          	lw	a2,4(s4)
    80004af2:	00003597          	auipc	a1,0x3
    80004af6:	ace58593          	addi	a1,a1,-1330 # 800075c0 <etext+0x5c0>
    80004afa:	8552                	mv	a0,s4
    80004afc:	e9bfe0ef          	jal	80003996 <dirlink>
    80004b00:	02054e63          	bltz	a0,80004b3c <create+0x11c>
    80004b04:	40d0                	lw	a2,4(s1)
    80004b06:	00003597          	auipc	a1,0x3
    80004b0a:	ac258593          	addi	a1,a1,-1342 # 800075c8 <etext+0x5c8>
    80004b0e:	8552                	mv	a0,s4
    80004b10:	e87fe0ef          	jal	80003996 <dirlink>
    80004b14:	02054463          	bltz	a0,80004b3c <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004b18:	004a2603          	lw	a2,4(s4)
    80004b1c:	fb040593          	addi	a1,s0,-80
    80004b20:	8526                	mv	a0,s1
    80004b22:	e75fe0ef          	jal	80003996 <dirlink>
    80004b26:	00054b63          	bltz	a0,80004b3c <create+0x11c>
    dp->nlink++;  // for ".."
    80004b2a:	04a4d783          	lhu	a5,74(s1)
    80004b2e:	2785                	addiw	a5,a5,1
    80004b30:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b34:	8526                	mv	a0,s1
    80004b36:	e30fe0ef          	jal	80003166 <iupdate>
    80004b3a:	bf71                	j	80004ad6 <create+0xb6>
  ip->nlink = 0;
    80004b3c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004b40:	8552                	mv	a0,s4
    80004b42:	e24fe0ef          	jal	80003166 <iupdate>
  iunlockput(ip);
    80004b46:	8552                	mv	a0,s4
    80004b48:	8ddfe0ef          	jal	80003424 <iunlockput>
  iunlockput(dp);
    80004b4c:	8526                	mv	a0,s1
    80004b4e:	8d7fe0ef          	jal	80003424 <iunlockput>
  return 0;
    80004b52:	7a02                	ld	s4,32(sp)
    80004b54:	b725                	j	80004a7c <create+0x5c>
    return 0;
    80004b56:	8aaa                	mv	s5,a0
    80004b58:	b715                	j	80004a7c <create+0x5c>

0000000080004b5a <sys_dup>:
{
    80004b5a:	7179                	addi	sp,sp,-48
    80004b5c:	f406                	sd	ra,40(sp)
    80004b5e:	f022                	sd	s0,32(sp)
    80004b60:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004b62:	fd840613          	addi	a2,s0,-40
    80004b66:	4581                	li	a1,0
    80004b68:	4501                	li	a0,0
    80004b6a:	e21ff0ef          	jal	8000498a <argfd>
    return -1;
    80004b6e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004b70:	02054363          	bltz	a0,80004b96 <sys_dup+0x3c>
    80004b74:	ec26                	sd	s1,24(sp)
    80004b76:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004b78:	fd843903          	ld	s2,-40(s0)
    80004b7c:	854a                	mv	a0,s2
    80004b7e:	e65ff0ef          	jal	800049e2 <fdalloc>
    80004b82:	84aa                	mv	s1,a0
    return -1;
    80004b84:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004b86:	00054d63          	bltz	a0,80004ba0 <sys_dup+0x46>
  filedup(f);
    80004b8a:	854a                	mv	a0,s2
    80004b8c:	c3eff0ef          	jal	80003fca <filedup>
  return fd;
    80004b90:	87a6                	mv	a5,s1
    80004b92:	64e2                	ld	s1,24(sp)
    80004b94:	6942                	ld	s2,16(sp)
}
    80004b96:	853e                	mv	a0,a5
    80004b98:	70a2                	ld	ra,40(sp)
    80004b9a:	7402                	ld	s0,32(sp)
    80004b9c:	6145                	addi	sp,sp,48
    80004b9e:	8082                	ret
    80004ba0:	64e2                	ld	s1,24(sp)
    80004ba2:	6942                	ld	s2,16(sp)
    80004ba4:	bfcd                	j	80004b96 <sys_dup+0x3c>

0000000080004ba6 <sys_read>:
{
    80004ba6:	7179                	addi	sp,sp,-48
    80004ba8:	f406                	sd	ra,40(sp)
    80004baa:	f022                	sd	s0,32(sp)
    80004bac:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004bae:	fd840593          	addi	a1,s0,-40
    80004bb2:	4505                	li	a0,1
    80004bb4:	c69fd0ef          	jal	8000281c <argaddr>
  argint(2, &n);
    80004bb8:	fe440593          	addi	a1,s0,-28
    80004bbc:	4509                	li	a0,2
    80004bbe:	c43fd0ef          	jal	80002800 <argint>
  if(argfd(0, 0, &f) < 0)
    80004bc2:	fe840613          	addi	a2,s0,-24
    80004bc6:	4581                	li	a1,0
    80004bc8:	4501                	li	a0,0
    80004bca:	dc1ff0ef          	jal	8000498a <argfd>
    80004bce:	87aa                	mv	a5,a0
    return -1;
    80004bd0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004bd2:	0007ca63          	bltz	a5,80004be6 <sys_read+0x40>
  return fileread(f, p, n);
    80004bd6:	fe442603          	lw	a2,-28(s0)
    80004bda:	fd843583          	ld	a1,-40(s0)
    80004bde:	fe843503          	ld	a0,-24(s0)
    80004be2:	d4eff0ef          	jal	80004130 <fileread>
}
    80004be6:	70a2                	ld	ra,40(sp)
    80004be8:	7402                	ld	s0,32(sp)
    80004bea:	6145                	addi	sp,sp,48
    80004bec:	8082                	ret

0000000080004bee <sys_write>:
{
    80004bee:	7179                	addi	sp,sp,-48
    80004bf0:	f406                	sd	ra,40(sp)
    80004bf2:	f022                	sd	s0,32(sp)
    80004bf4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004bf6:	fd840593          	addi	a1,s0,-40
    80004bfa:	4505                	li	a0,1
    80004bfc:	c21fd0ef          	jal	8000281c <argaddr>
  argint(2, &n);
    80004c00:	fe440593          	addi	a1,s0,-28
    80004c04:	4509                	li	a0,2
    80004c06:	bfbfd0ef          	jal	80002800 <argint>
  if(argfd(0, 0, &f) < 0)
    80004c0a:	fe840613          	addi	a2,s0,-24
    80004c0e:	4581                	li	a1,0
    80004c10:	4501                	li	a0,0
    80004c12:	d79ff0ef          	jal	8000498a <argfd>
    80004c16:	87aa                	mv	a5,a0
    return -1;
    80004c18:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c1a:	0007ca63          	bltz	a5,80004c2e <sys_write+0x40>
  return filewrite(f, p, n);
    80004c1e:	fe442603          	lw	a2,-28(s0)
    80004c22:	fd843583          	ld	a1,-40(s0)
    80004c26:	fe843503          	ld	a0,-24(s0)
    80004c2a:	dc4ff0ef          	jal	800041ee <filewrite>
}
    80004c2e:	70a2                	ld	ra,40(sp)
    80004c30:	7402                	ld	s0,32(sp)
    80004c32:	6145                	addi	sp,sp,48
    80004c34:	8082                	ret

0000000080004c36 <sys_close>:
{
    80004c36:	1101                	addi	sp,sp,-32
    80004c38:	ec06                	sd	ra,24(sp)
    80004c3a:	e822                	sd	s0,16(sp)
    80004c3c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004c3e:	fe040613          	addi	a2,s0,-32
    80004c42:	fec40593          	addi	a1,s0,-20
    80004c46:	4501                	li	a0,0
    80004c48:	d43ff0ef          	jal	8000498a <argfd>
    return -1;
    80004c4c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004c4e:	02054063          	bltz	a0,80004c6e <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004c52:	ca1fc0ef          	jal	800018f2 <myproc>
    80004c56:	fec42783          	lw	a5,-20(s0)
    80004c5a:	07e9                	addi	a5,a5,26
    80004c5c:	078e                	slli	a5,a5,0x3
    80004c5e:	953e                	add	a0,a0,a5
    80004c60:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004c64:	fe043503          	ld	a0,-32(s0)
    80004c68:	ba8ff0ef          	jal	80004010 <fileclose>
  return 0;
    80004c6c:	4781                	li	a5,0
}
    80004c6e:	853e                	mv	a0,a5
    80004c70:	60e2                	ld	ra,24(sp)
    80004c72:	6442                	ld	s0,16(sp)
    80004c74:	6105                	addi	sp,sp,32
    80004c76:	8082                	ret

0000000080004c78 <sys_fstat>:
{
    80004c78:	1101                	addi	sp,sp,-32
    80004c7a:	ec06                	sd	ra,24(sp)
    80004c7c:	e822                	sd	s0,16(sp)
    80004c7e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004c80:	fe040593          	addi	a1,s0,-32
    80004c84:	4505                	li	a0,1
    80004c86:	b97fd0ef          	jal	8000281c <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004c8a:	fe840613          	addi	a2,s0,-24
    80004c8e:	4581                	li	a1,0
    80004c90:	4501                	li	a0,0
    80004c92:	cf9ff0ef          	jal	8000498a <argfd>
    80004c96:	87aa                	mv	a5,a0
    return -1;
    80004c98:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c9a:	0007c863          	bltz	a5,80004caa <sys_fstat+0x32>
  return filestat(f, st);
    80004c9e:	fe043583          	ld	a1,-32(s0)
    80004ca2:	fe843503          	ld	a0,-24(s0)
    80004ca6:	c2cff0ef          	jal	800040d2 <filestat>
}
    80004caa:	60e2                	ld	ra,24(sp)
    80004cac:	6442                	ld	s0,16(sp)
    80004cae:	6105                	addi	sp,sp,32
    80004cb0:	8082                	ret

0000000080004cb2 <sys_link>:
{
    80004cb2:	7169                	addi	sp,sp,-304
    80004cb4:	f606                	sd	ra,296(sp)
    80004cb6:	f222                	sd	s0,288(sp)
    80004cb8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cba:	08000613          	li	a2,128
    80004cbe:	ed040593          	addi	a1,s0,-304
    80004cc2:	4501                	li	a0,0
    80004cc4:	b75fd0ef          	jal	80002838 <argstr>
    return -1;
    80004cc8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cca:	0c054e63          	bltz	a0,80004da6 <sys_link+0xf4>
    80004cce:	08000613          	li	a2,128
    80004cd2:	f5040593          	addi	a1,s0,-176
    80004cd6:	4505                	li	a0,1
    80004cd8:	b61fd0ef          	jal	80002838 <argstr>
    return -1;
    80004cdc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cde:	0c054463          	bltz	a0,80004da6 <sys_link+0xf4>
    80004ce2:	ee26                	sd	s1,280(sp)
  begin_op();
    80004ce4:	f21fe0ef          	jal	80003c04 <begin_op>
  if((ip = namei(old)) == 0){
    80004ce8:	ed040513          	addi	a0,s0,-304
    80004cec:	d45fe0ef          	jal	80003a30 <namei>
    80004cf0:	84aa                	mv	s1,a0
    80004cf2:	c53d                	beqz	a0,80004d60 <sys_link+0xae>
  ilock(ip);
    80004cf4:	d26fe0ef          	jal	8000321a <ilock>
  if(ip->type == T_DIR){
    80004cf8:	04449703          	lh	a4,68(s1)
    80004cfc:	4785                	li	a5,1
    80004cfe:	06f70663          	beq	a4,a5,80004d6a <sys_link+0xb8>
    80004d02:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004d04:	04a4d783          	lhu	a5,74(s1)
    80004d08:	2785                	addiw	a5,a5,1
    80004d0a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d0e:	8526                	mv	a0,s1
    80004d10:	c56fe0ef          	jal	80003166 <iupdate>
  iunlock(ip);
    80004d14:	8526                	mv	a0,s1
    80004d16:	db2fe0ef          	jal	800032c8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004d1a:	fd040593          	addi	a1,s0,-48
    80004d1e:	f5040513          	addi	a0,s0,-176
    80004d22:	d29fe0ef          	jal	80003a4a <nameiparent>
    80004d26:	892a                	mv	s2,a0
    80004d28:	cd21                	beqz	a0,80004d80 <sys_link+0xce>
  ilock(dp);
    80004d2a:	cf0fe0ef          	jal	8000321a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004d2e:	00092703          	lw	a4,0(s2)
    80004d32:	409c                	lw	a5,0(s1)
    80004d34:	04f71363          	bne	a4,a5,80004d7a <sys_link+0xc8>
    80004d38:	40d0                	lw	a2,4(s1)
    80004d3a:	fd040593          	addi	a1,s0,-48
    80004d3e:	854a                	mv	a0,s2
    80004d40:	c57fe0ef          	jal	80003996 <dirlink>
    80004d44:	02054b63          	bltz	a0,80004d7a <sys_link+0xc8>
  iunlockput(dp);
    80004d48:	854a                	mv	a0,s2
    80004d4a:	edafe0ef          	jal	80003424 <iunlockput>
  iput(ip);
    80004d4e:	8526                	mv	a0,s1
    80004d50:	e4cfe0ef          	jal	8000339c <iput>
  end_op();
    80004d54:	f1bfe0ef          	jal	80003c6e <end_op>
  return 0;
    80004d58:	4781                	li	a5,0
    80004d5a:	64f2                	ld	s1,280(sp)
    80004d5c:	6952                	ld	s2,272(sp)
    80004d5e:	a0a1                	j	80004da6 <sys_link+0xf4>
    end_op();
    80004d60:	f0ffe0ef          	jal	80003c6e <end_op>
    return -1;
    80004d64:	57fd                	li	a5,-1
    80004d66:	64f2                	ld	s1,280(sp)
    80004d68:	a83d                	j	80004da6 <sys_link+0xf4>
    iunlockput(ip);
    80004d6a:	8526                	mv	a0,s1
    80004d6c:	eb8fe0ef          	jal	80003424 <iunlockput>
    end_op();
    80004d70:	efffe0ef          	jal	80003c6e <end_op>
    return -1;
    80004d74:	57fd                	li	a5,-1
    80004d76:	64f2                	ld	s1,280(sp)
    80004d78:	a03d                	j	80004da6 <sys_link+0xf4>
    iunlockput(dp);
    80004d7a:	854a                	mv	a0,s2
    80004d7c:	ea8fe0ef          	jal	80003424 <iunlockput>
  ilock(ip);
    80004d80:	8526                	mv	a0,s1
    80004d82:	c98fe0ef          	jal	8000321a <ilock>
  ip->nlink--;
    80004d86:	04a4d783          	lhu	a5,74(s1)
    80004d8a:	37fd                	addiw	a5,a5,-1
    80004d8c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d90:	8526                	mv	a0,s1
    80004d92:	bd4fe0ef          	jal	80003166 <iupdate>
  iunlockput(ip);
    80004d96:	8526                	mv	a0,s1
    80004d98:	e8cfe0ef          	jal	80003424 <iunlockput>
  end_op();
    80004d9c:	ed3fe0ef          	jal	80003c6e <end_op>
  return -1;
    80004da0:	57fd                	li	a5,-1
    80004da2:	64f2                	ld	s1,280(sp)
    80004da4:	6952                	ld	s2,272(sp)
}
    80004da6:	853e                	mv	a0,a5
    80004da8:	70b2                	ld	ra,296(sp)
    80004daa:	7412                	ld	s0,288(sp)
    80004dac:	6155                	addi	sp,sp,304
    80004dae:	8082                	ret

0000000080004db0 <sys_unlink>:
{
    80004db0:	7151                	addi	sp,sp,-240
    80004db2:	f586                	sd	ra,232(sp)
    80004db4:	f1a2                	sd	s0,224(sp)
    80004db6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004db8:	08000613          	li	a2,128
    80004dbc:	f3040593          	addi	a1,s0,-208
    80004dc0:	4501                	li	a0,0
    80004dc2:	a77fd0ef          	jal	80002838 <argstr>
    80004dc6:	16054063          	bltz	a0,80004f26 <sys_unlink+0x176>
    80004dca:	eda6                	sd	s1,216(sp)
  begin_op();
    80004dcc:	e39fe0ef          	jal	80003c04 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004dd0:	fb040593          	addi	a1,s0,-80
    80004dd4:	f3040513          	addi	a0,s0,-208
    80004dd8:	c73fe0ef          	jal	80003a4a <nameiparent>
    80004ddc:	84aa                	mv	s1,a0
    80004dde:	c945                	beqz	a0,80004e8e <sys_unlink+0xde>
  ilock(dp);
    80004de0:	c3afe0ef          	jal	8000321a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004de4:	00002597          	auipc	a1,0x2
    80004de8:	7dc58593          	addi	a1,a1,2012 # 800075c0 <etext+0x5c0>
    80004dec:	fb040513          	addi	a0,s0,-80
    80004df0:	9c5fe0ef          	jal	800037b4 <namecmp>
    80004df4:	10050e63          	beqz	a0,80004f10 <sys_unlink+0x160>
    80004df8:	00002597          	auipc	a1,0x2
    80004dfc:	7d058593          	addi	a1,a1,2000 # 800075c8 <etext+0x5c8>
    80004e00:	fb040513          	addi	a0,s0,-80
    80004e04:	9b1fe0ef          	jal	800037b4 <namecmp>
    80004e08:	10050463          	beqz	a0,80004f10 <sys_unlink+0x160>
    80004e0c:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004e0e:	f2c40613          	addi	a2,s0,-212
    80004e12:	fb040593          	addi	a1,s0,-80
    80004e16:	8526                	mv	a0,s1
    80004e18:	9b3fe0ef          	jal	800037ca <dirlookup>
    80004e1c:	892a                	mv	s2,a0
    80004e1e:	0e050863          	beqz	a0,80004f0e <sys_unlink+0x15e>
  ilock(ip);
    80004e22:	bf8fe0ef          	jal	8000321a <ilock>
  if(ip->nlink < 1)
    80004e26:	04a91783          	lh	a5,74(s2)
    80004e2a:	06f05763          	blez	a5,80004e98 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004e2e:	04491703          	lh	a4,68(s2)
    80004e32:	4785                	li	a5,1
    80004e34:	06f70963          	beq	a4,a5,80004ea6 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004e38:	4641                	li	a2,16
    80004e3a:	4581                	li	a1,0
    80004e3c:	fc040513          	addi	a0,s0,-64
    80004e40:	e87fb0ef          	jal	80000cc6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e44:	4741                	li	a4,16
    80004e46:	f2c42683          	lw	a3,-212(s0)
    80004e4a:	fc040613          	addi	a2,s0,-64
    80004e4e:	4581                	li	a1,0
    80004e50:	8526                	mv	a0,s1
    80004e52:	855fe0ef          	jal	800036a6 <writei>
    80004e56:	47c1                	li	a5,16
    80004e58:	08f51b63          	bne	a0,a5,80004eee <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004e5c:	04491703          	lh	a4,68(s2)
    80004e60:	4785                	li	a5,1
    80004e62:	08f70d63          	beq	a4,a5,80004efc <sys_unlink+0x14c>
  iunlockput(dp);
    80004e66:	8526                	mv	a0,s1
    80004e68:	dbcfe0ef          	jal	80003424 <iunlockput>
  ip->nlink--;
    80004e6c:	04a95783          	lhu	a5,74(s2)
    80004e70:	37fd                	addiw	a5,a5,-1
    80004e72:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004e76:	854a                	mv	a0,s2
    80004e78:	aeefe0ef          	jal	80003166 <iupdate>
  iunlockput(ip);
    80004e7c:	854a                	mv	a0,s2
    80004e7e:	da6fe0ef          	jal	80003424 <iunlockput>
  end_op();
    80004e82:	dedfe0ef          	jal	80003c6e <end_op>
  return 0;
    80004e86:	4501                	li	a0,0
    80004e88:	64ee                	ld	s1,216(sp)
    80004e8a:	694e                	ld	s2,208(sp)
    80004e8c:	a849                	j	80004f1e <sys_unlink+0x16e>
    end_op();
    80004e8e:	de1fe0ef          	jal	80003c6e <end_op>
    return -1;
    80004e92:	557d                	li	a0,-1
    80004e94:	64ee                	ld	s1,216(sp)
    80004e96:	a061                	j	80004f1e <sys_unlink+0x16e>
    80004e98:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004e9a:	00002517          	auipc	a0,0x2
    80004e9e:	73650513          	addi	a0,a0,1846 # 800075d0 <etext+0x5d0>
    80004ea2:	93ffb0ef          	jal	800007e0 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ea6:	04c92703          	lw	a4,76(s2)
    80004eaa:	02000793          	li	a5,32
    80004eae:	f8e7f5e3          	bgeu	a5,a4,80004e38 <sys_unlink+0x88>
    80004eb2:	e5ce                	sd	s3,200(sp)
    80004eb4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004eb8:	4741                	li	a4,16
    80004eba:	86ce                	mv	a3,s3
    80004ebc:	f1840613          	addi	a2,s0,-232
    80004ec0:	4581                	li	a1,0
    80004ec2:	854a                	mv	a0,s2
    80004ec4:	ee6fe0ef          	jal	800035aa <readi>
    80004ec8:	47c1                	li	a5,16
    80004eca:	00f51c63          	bne	a0,a5,80004ee2 <sys_unlink+0x132>
    if(de.inum != 0)
    80004ece:	f1845783          	lhu	a5,-232(s0)
    80004ed2:	efa1                	bnez	a5,80004f2a <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ed4:	29c1                	addiw	s3,s3,16
    80004ed6:	04c92783          	lw	a5,76(s2)
    80004eda:	fcf9efe3          	bltu	s3,a5,80004eb8 <sys_unlink+0x108>
    80004ede:	69ae                	ld	s3,200(sp)
    80004ee0:	bfa1                	j	80004e38 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004ee2:	00002517          	auipc	a0,0x2
    80004ee6:	70650513          	addi	a0,a0,1798 # 800075e8 <etext+0x5e8>
    80004eea:	8f7fb0ef          	jal	800007e0 <panic>
    80004eee:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004ef0:	00002517          	auipc	a0,0x2
    80004ef4:	71050513          	addi	a0,a0,1808 # 80007600 <etext+0x600>
    80004ef8:	8e9fb0ef          	jal	800007e0 <panic>
    dp->nlink--;
    80004efc:	04a4d783          	lhu	a5,74(s1)
    80004f00:	37fd                	addiw	a5,a5,-1
    80004f02:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004f06:	8526                	mv	a0,s1
    80004f08:	a5efe0ef          	jal	80003166 <iupdate>
    80004f0c:	bfa9                	j	80004e66 <sys_unlink+0xb6>
    80004f0e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004f10:	8526                	mv	a0,s1
    80004f12:	d12fe0ef          	jal	80003424 <iunlockput>
  end_op();
    80004f16:	d59fe0ef          	jal	80003c6e <end_op>
  return -1;
    80004f1a:	557d                	li	a0,-1
    80004f1c:	64ee                	ld	s1,216(sp)
}
    80004f1e:	70ae                	ld	ra,232(sp)
    80004f20:	740e                	ld	s0,224(sp)
    80004f22:	616d                	addi	sp,sp,240
    80004f24:	8082                	ret
    return -1;
    80004f26:	557d                	li	a0,-1
    80004f28:	bfdd                	j	80004f1e <sys_unlink+0x16e>
    iunlockput(ip);
    80004f2a:	854a                	mv	a0,s2
    80004f2c:	cf8fe0ef          	jal	80003424 <iunlockput>
    goto bad;
    80004f30:	694e                	ld	s2,208(sp)
    80004f32:	69ae                	ld	s3,200(sp)
    80004f34:	bff1                	j	80004f10 <sys_unlink+0x160>

0000000080004f36 <sys_open>:

uint64
sys_open(void)
{
    80004f36:	7131                	addi	sp,sp,-192
    80004f38:	fd06                	sd	ra,184(sp)
    80004f3a:	f922                	sd	s0,176(sp)
    80004f3c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004f3e:	f4c40593          	addi	a1,s0,-180
    80004f42:	4505                	li	a0,1
    80004f44:	8bdfd0ef          	jal	80002800 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004f48:	08000613          	li	a2,128
    80004f4c:	f5040593          	addi	a1,s0,-176
    80004f50:	4501                	li	a0,0
    80004f52:	8e7fd0ef          	jal	80002838 <argstr>
    80004f56:	87aa                	mv	a5,a0
    return -1;
    80004f58:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004f5a:	0a07c263          	bltz	a5,80004ffe <sys_open+0xc8>
    80004f5e:	f526                	sd	s1,168(sp)

  begin_op();
    80004f60:	ca5fe0ef          	jal	80003c04 <begin_op>

  if(omode & O_CREATE){
    80004f64:	f4c42783          	lw	a5,-180(s0)
    80004f68:	2007f793          	andi	a5,a5,512
    80004f6c:	c3d5                	beqz	a5,80005010 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004f6e:	4681                	li	a3,0
    80004f70:	4601                	li	a2,0
    80004f72:	4589                	li	a1,2
    80004f74:	f5040513          	addi	a0,s0,-176
    80004f78:	aa9ff0ef          	jal	80004a20 <create>
    80004f7c:	84aa                	mv	s1,a0
    if(ip == 0){
    80004f7e:	c541                	beqz	a0,80005006 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004f80:	04449703          	lh	a4,68(s1)
    80004f84:	478d                	li	a5,3
    80004f86:	00f71763          	bne	a4,a5,80004f94 <sys_open+0x5e>
    80004f8a:	0464d703          	lhu	a4,70(s1)
    80004f8e:	47a5                	li	a5,9
    80004f90:	0ae7ed63          	bltu	a5,a4,8000504a <sys_open+0x114>
    80004f94:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004f96:	fd7fe0ef          	jal	80003f6c <filealloc>
    80004f9a:	892a                	mv	s2,a0
    80004f9c:	c179                	beqz	a0,80005062 <sys_open+0x12c>
    80004f9e:	ed4e                	sd	s3,152(sp)
    80004fa0:	a43ff0ef          	jal	800049e2 <fdalloc>
    80004fa4:	89aa                	mv	s3,a0
    80004fa6:	0a054a63          	bltz	a0,8000505a <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004faa:	04449703          	lh	a4,68(s1)
    80004fae:	478d                	li	a5,3
    80004fb0:	0cf70263          	beq	a4,a5,80005074 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004fb4:	4789                	li	a5,2
    80004fb6:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004fba:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004fbe:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004fc2:	f4c42783          	lw	a5,-180(s0)
    80004fc6:	0017c713          	xori	a4,a5,1
    80004fca:	8b05                	andi	a4,a4,1
    80004fcc:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004fd0:	0037f713          	andi	a4,a5,3
    80004fd4:	00e03733          	snez	a4,a4
    80004fd8:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004fdc:	4007f793          	andi	a5,a5,1024
    80004fe0:	c791                	beqz	a5,80004fec <sys_open+0xb6>
    80004fe2:	04449703          	lh	a4,68(s1)
    80004fe6:	4789                	li	a5,2
    80004fe8:	08f70d63          	beq	a4,a5,80005082 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004fec:	8526                	mv	a0,s1
    80004fee:	adafe0ef          	jal	800032c8 <iunlock>
  end_op();
    80004ff2:	c7dfe0ef          	jal	80003c6e <end_op>

  return fd;
    80004ff6:	854e                	mv	a0,s3
    80004ff8:	74aa                	ld	s1,168(sp)
    80004ffa:	790a                	ld	s2,160(sp)
    80004ffc:	69ea                	ld	s3,152(sp)
}
    80004ffe:	70ea                	ld	ra,184(sp)
    80005000:	744a                	ld	s0,176(sp)
    80005002:	6129                	addi	sp,sp,192
    80005004:	8082                	ret
      end_op();
    80005006:	c69fe0ef          	jal	80003c6e <end_op>
      return -1;
    8000500a:	557d                	li	a0,-1
    8000500c:	74aa                	ld	s1,168(sp)
    8000500e:	bfc5                	j	80004ffe <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80005010:	f5040513          	addi	a0,s0,-176
    80005014:	a1dfe0ef          	jal	80003a30 <namei>
    80005018:	84aa                	mv	s1,a0
    8000501a:	c11d                	beqz	a0,80005040 <sys_open+0x10a>
    ilock(ip);
    8000501c:	9fefe0ef          	jal	8000321a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005020:	04449703          	lh	a4,68(s1)
    80005024:	4785                	li	a5,1
    80005026:	f4f71de3          	bne	a4,a5,80004f80 <sys_open+0x4a>
    8000502a:	f4c42783          	lw	a5,-180(s0)
    8000502e:	d3bd                	beqz	a5,80004f94 <sys_open+0x5e>
      iunlockput(ip);
    80005030:	8526                	mv	a0,s1
    80005032:	bf2fe0ef          	jal	80003424 <iunlockput>
      end_op();
    80005036:	c39fe0ef          	jal	80003c6e <end_op>
      return -1;
    8000503a:	557d                	li	a0,-1
    8000503c:	74aa                	ld	s1,168(sp)
    8000503e:	b7c1                	j	80004ffe <sys_open+0xc8>
      end_op();
    80005040:	c2ffe0ef          	jal	80003c6e <end_op>
      return -1;
    80005044:	557d                	li	a0,-1
    80005046:	74aa                	ld	s1,168(sp)
    80005048:	bf5d                	j	80004ffe <sys_open+0xc8>
    iunlockput(ip);
    8000504a:	8526                	mv	a0,s1
    8000504c:	bd8fe0ef          	jal	80003424 <iunlockput>
    end_op();
    80005050:	c1ffe0ef          	jal	80003c6e <end_op>
    return -1;
    80005054:	557d                	li	a0,-1
    80005056:	74aa                	ld	s1,168(sp)
    80005058:	b75d                	j	80004ffe <sys_open+0xc8>
      fileclose(f);
    8000505a:	854a                	mv	a0,s2
    8000505c:	fb5fe0ef          	jal	80004010 <fileclose>
    80005060:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005062:	8526                	mv	a0,s1
    80005064:	bc0fe0ef          	jal	80003424 <iunlockput>
    end_op();
    80005068:	c07fe0ef          	jal	80003c6e <end_op>
    return -1;
    8000506c:	557d                	li	a0,-1
    8000506e:	74aa                	ld	s1,168(sp)
    80005070:	790a                	ld	s2,160(sp)
    80005072:	b771                	j	80004ffe <sys_open+0xc8>
    f->type = FD_DEVICE;
    80005074:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005078:	04649783          	lh	a5,70(s1)
    8000507c:	02f91223          	sh	a5,36(s2)
    80005080:	bf3d                	j	80004fbe <sys_open+0x88>
    itrunc(ip);
    80005082:	8526                	mv	a0,s1
    80005084:	a84fe0ef          	jal	80003308 <itrunc>
    80005088:	b795                	j	80004fec <sys_open+0xb6>

000000008000508a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000508a:	7175                	addi	sp,sp,-144
    8000508c:	e506                	sd	ra,136(sp)
    8000508e:	e122                	sd	s0,128(sp)
    80005090:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005092:	b73fe0ef          	jal	80003c04 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005096:	08000613          	li	a2,128
    8000509a:	f7040593          	addi	a1,s0,-144
    8000509e:	4501                	li	a0,0
    800050a0:	f98fd0ef          	jal	80002838 <argstr>
    800050a4:	02054363          	bltz	a0,800050ca <sys_mkdir+0x40>
    800050a8:	4681                	li	a3,0
    800050aa:	4601                	li	a2,0
    800050ac:	4585                	li	a1,1
    800050ae:	f7040513          	addi	a0,s0,-144
    800050b2:	96fff0ef          	jal	80004a20 <create>
    800050b6:	c911                	beqz	a0,800050ca <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050b8:	b6cfe0ef          	jal	80003424 <iunlockput>
  end_op();
    800050bc:	bb3fe0ef          	jal	80003c6e <end_op>
  return 0;
    800050c0:	4501                	li	a0,0
}
    800050c2:	60aa                	ld	ra,136(sp)
    800050c4:	640a                	ld	s0,128(sp)
    800050c6:	6149                	addi	sp,sp,144
    800050c8:	8082                	ret
    end_op();
    800050ca:	ba5fe0ef          	jal	80003c6e <end_op>
    return -1;
    800050ce:	557d                	li	a0,-1
    800050d0:	bfcd                	j	800050c2 <sys_mkdir+0x38>

00000000800050d2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800050d2:	7135                	addi	sp,sp,-160
    800050d4:	ed06                	sd	ra,152(sp)
    800050d6:	e922                	sd	s0,144(sp)
    800050d8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800050da:	b2bfe0ef          	jal	80003c04 <begin_op>
  argint(1, &major);
    800050de:	f6c40593          	addi	a1,s0,-148
    800050e2:	4505                	li	a0,1
    800050e4:	f1cfd0ef          	jal	80002800 <argint>
  argint(2, &minor);
    800050e8:	f6840593          	addi	a1,s0,-152
    800050ec:	4509                	li	a0,2
    800050ee:	f12fd0ef          	jal	80002800 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050f2:	08000613          	li	a2,128
    800050f6:	f7040593          	addi	a1,s0,-144
    800050fa:	4501                	li	a0,0
    800050fc:	f3cfd0ef          	jal	80002838 <argstr>
    80005100:	02054563          	bltz	a0,8000512a <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005104:	f6841683          	lh	a3,-152(s0)
    80005108:	f6c41603          	lh	a2,-148(s0)
    8000510c:	458d                	li	a1,3
    8000510e:	f7040513          	addi	a0,s0,-144
    80005112:	90fff0ef          	jal	80004a20 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005116:	c911                	beqz	a0,8000512a <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005118:	b0cfe0ef          	jal	80003424 <iunlockput>
  end_op();
    8000511c:	b53fe0ef          	jal	80003c6e <end_op>
  return 0;
    80005120:	4501                	li	a0,0
}
    80005122:	60ea                	ld	ra,152(sp)
    80005124:	644a                	ld	s0,144(sp)
    80005126:	610d                	addi	sp,sp,160
    80005128:	8082                	ret
    end_op();
    8000512a:	b45fe0ef          	jal	80003c6e <end_op>
    return -1;
    8000512e:	557d                	li	a0,-1
    80005130:	bfcd                	j	80005122 <sys_mknod+0x50>

0000000080005132 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005132:	7135                	addi	sp,sp,-160
    80005134:	ed06                	sd	ra,152(sp)
    80005136:	e922                	sd	s0,144(sp)
    80005138:	e14a                	sd	s2,128(sp)
    8000513a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000513c:	fb6fc0ef          	jal	800018f2 <myproc>
    80005140:	892a                	mv	s2,a0
  
  begin_op();
    80005142:	ac3fe0ef          	jal	80003c04 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005146:	08000613          	li	a2,128
    8000514a:	f6040593          	addi	a1,s0,-160
    8000514e:	4501                	li	a0,0
    80005150:	ee8fd0ef          	jal	80002838 <argstr>
    80005154:	04054363          	bltz	a0,8000519a <sys_chdir+0x68>
    80005158:	e526                	sd	s1,136(sp)
    8000515a:	f6040513          	addi	a0,s0,-160
    8000515e:	8d3fe0ef          	jal	80003a30 <namei>
    80005162:	84aa                	mv	s1,a0
    80005164:	c915                	beqz	a0,80005198 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005166:	8b4fe0ef          	jal	8000321a <ilock>
  if(ip->type != T_DIR){
    8000516a:	04449703          	lh	a4,68(s1)
    8000516e:	4785                	li	a5,1
    80005170:	02f71963          	bne	a4,a5,800051a2 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005174:	8526                	mv	a0,s1
    80005176:	952fe0ef          	jal	800032c8 <iunlock>
  iput(p->cwd);
    8000517a:	15093503          	ld	a0,336(s2)
    8000517e:	a1efe0ef          	jal	8000339c <iput>
  end_op();
    80005182:	aedfe0ef          	jal	80003c6e <end_op>
  p->cwd = ip;
    80005186:	14993823          	sd	s1,336(s2)
  return 0;
    8000518a:	4501                	li	a0,0
    8000518c:	64aa                	ld	s1,136(sp)
}
    8000518e:	60ea                	ld	ra,152(sp)
    80005190:	644a                	ld	s0,144(sp)
    80005192:	690a                	ld	s2,128(sp)
    80005194:	610d                	addi	sp,sp,160
    80005196:	8082                	ret
    80005198:	64aa                	ld	s1,136(sp)
    end_op();
    8000519a:	ad5fe0ef          	jal	80003c6e <end_op>
    return -1;
    8000519e:	557d                	li	a0,-1
    800051a0:	b7fd                	j	8000518e <sys_chdir+0x5c>
    iunlockput(ip);
    800051a2:	8526                	mv	a0,s1
    800051a4:	a80fe0ef          	jal	80003424 <iunlockput>
    end_op();
    800051a8:	ac7fe0ef          	jal	80003c6e <end_op>
    return -1;
    800051ac:	557d                	li	a0,-1
    800051ae:	64aa                	ld	s1,136(sp)
    800051b0:	bff9                	j	8000518e <sys_chdir+0x5c>

00000000800051b2 <sys_exec>:

uint64
sys_exec(void)
{
    800051b2:	7121                	addi	sp,sp,-448
    800051b4:	ff06                	sd	ra,440(sp)
    800051b6:	fb22                	sd	s0,432(sp)
    800051b8:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800051ba:	e4840593          	addi	a1,s0,-440
    800051be:	4505                	li	a0,1
    800051c0:	e5cfd0ef          	jal	8000281c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800051c4:	08000613          	li	a2,128
    800051c8:	f5040593          	addi	a1,s0,-176
    800051cc:	4501                	li	a0,0
    800051ce:	e6afd0ef          	jal	80002838 <argstr>
    800051d2:	87aa                	mv	a5,a0
    return -1;
    800051d4:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800051d6:	0c07c463          	bltz	a5,8000529e <sys_exec+0xec>
    800051da:	f726                	sd	s1,424(sp)
    800051dc:	f34a                	sd	s2,416(sp)
    800051de:	ef4e                	sd	s3,408(sp)
    800051e0:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800051e2:	10000613          	li	a2,256
    800051e6:	4581                	li	a1,0
    800051e8:	e5040513          	addi	a0,s0,-432
    800051ec:	adbfb0ef          	jal	80000cc6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800051f0:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800051f4:	89a6                	mv	s3,s1
    800051f6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800051f8:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800051fc:	00391513          	slli	a0,s2,0x3
    80005200:	e4040593          	addi	a1,s0,-448
    80005204:	e4843783          	ld	a5,-440(s0)
    80005208:	953e                	add	a0,a0,a5
    8000520a:	d6cfd0ef          	jal	80002776 <fetchaddr>
    8000520e:	02054663          	bltz	a0,8000523a <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005212:	e4043783          	ld	a5,-448(s0)
    80005216:	c3a9                	beqz	a5,80005258 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005218:	8e7fb0ef          	jal	80000afe <kalloc>
    8000521c:	85aa                	mv	a1,a0
    8000521e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005222:	cd01                	beqz	a0,8000523a <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005224:	6605                	lui	a2,0x1
    80005226:	e4043503          	ld	a0,-448(s0)
    8000522a:	d96fd0ef          	jal	800027c0 <fetchstr>
    8000522e:	00054663          	bltz	a0,8000523a <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80005232:	0905                	addi	s2,s2,1
    80005234:	09a1                	addi	s3,s3,8
    80005236:	fd4913e3          	bne	s2,s4,800051fc <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000523a:	f5040913          	addi	s2,s0,-176
    8000523e:	6088                	ld	a0,0(s1)
    80005240:	c931                	beqz	a0,80005294 <sys_exec+0xe2>
    kfree(argv[i]);
    80005242:	fdafb0ef          	jal	80000a1c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005246:	04a1                	addi	s1,s1,8
    80005248:	ff249be3          	bne	s1,s2,8000523e <sys_exec+0x8c>
  return -1;
    8000524c:	557d                	li	a0,-1
    8000524e:	74ba                	ld	s1,424(sp)
    80005250:	791a                	ld	s2,416(sp)
    80005252:	69fa                	ld	s3,408(sp)
    80005254:	6a5a                	ld	s4,400(sp)
    80005256:	a0a1                	j	8000529e <sys_exec+0xec>
      argv[i] = 0;
    80005258:	0009079b          	sext.w	a5,s2
    8000525c:	078e                	slli	a5,a5,0x3
    8000525e:	fd078793          	addi	a5,a5,-48
    80005262:	97a2                	add	a5,a5,s0
    80005264:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    80005268:	e5040593          	addi	a1,s0,-432
    8000526c:	f5040513          	addi	a0,s0,-176
    80005270:	ba8ff0ef          	jal	80004618 <kexec>
    80005274:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005276:	f5040993          	addi	s3,s0,-176
    8000527a:	6088                	ld	a0,0(s1)
    8000527c:	c511                	beqz	a0,80005288 <sys_exec+0xd6>
    kfree(argv[i]);
    8000527e:	f9efb0ef          	jal	80000a1c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005282:	04a1                	addi	s1,s1,8
    80005284:	ff349be3          	bne	s1,s3,8000527a <sys_exec+0xc8>
  return ret;
    80005288:	854a                	mv	a0,s2
    8000528a:	74ba                	ld	s1,424(sp)
    8000528c:	791a                	ld	s2,416(sp)
    8000528e:	69fa                	ld	s3,408(sp)
    80005290:	6a5a                	ld	s4,400(sp)
    80005292:	a031                	j	8000529e <sys_exec+0xec>
  return -1;
    80005294:	557d                	li	a0,-1
    80005296:	74ba                	ld	s1,424(sp)
    80005298:	791a                	ld	s2,416(sp)
    8000529a:	69fa                	ld	s3,408(sp)
    8000529c:	6a5a                	ld	s4,400(sp)
}
    8000529e:	70fa                	ld	ra,440(sp)
    800052a0:	745a                	ld	s0,432(sp)
    800052a2:	6139                	addi	sp,sp,448
    800052a4:	8082                	ret

00000000800052a6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800052a6:	7139                	addi	sp,sp,-64
    800052a8:	fc06                	sd	ra,56(sp)
    800052aa:	f822                	sd	s0,48(sp)
    800052ac:	f426                	sd	s1,40(sp)
    800052ae:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800052b0:	e42fc0ef          	jal	800018f2 <myproc>
    800052b4:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800052b6:	fd840593          	addi	a1,s0,-40
    800052ba:	4501                	li	a0,0
    800052bc:	d60fd0ef          	jal	8000281c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800052c0:	fc840593          	addi	a1,s0,-56
    800052c4:	fd040513          	addi	a0,s0,-48
    800052c8:	852ff0ef          	jal	8000431a <pipealloc>
    return -1;
    800052cc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800052ce:	0a054463          	bltz	a0,80005376 <sys_pipe+0xd0>
  fd0 = -1;
    800052d2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800052d6:	fd043503          	ld	a0,-48(s0)
    800052da:	f08ff0ef          	jal	800049e2 <fdalloc>
    800052de:	fca42223          	sw	a0,-60(s0)
    800052e2:	08054163          	bltz	a0,80005364 <sys_pipe+0xbe>
    800052e6:	fc843503          	ld	a0,-56(s0)
    800052ea:	ef8ff0ef          	jal	800049e2 <fdalloc>
    800052ee:	fca42023          	sw	a0,-64(s0)
    800052f2:	06054063          	bltz	a0,80005352 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052f6:	4691                	li	a3,4
    800052f8:	fc440613          	addi	a2,s0,-60
    800052fc:	fd843583          	ld	a1,-40(s0)
    80005300:	68a8                	ld	a0,80(s1)
    80005302:	b04fc0ef          	jal	80001606 <copyout>
    80005306:	00054e63          	bltz	a0,80005322 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000530a:	4691                	li	a3,4
    8000530c:	fc040613          	addi	a2,s0,-64
    80005310:	fd843583          	ld	a1,-40(s0)
    80005314:	0591                	addi	a1,a1,4
    80005316:	68a8                	ld	a0,80(s1)
    80005318:	aeefc0ef          	jal	80001606 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000531c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000531e:	04055c63          	bgez	a0,80005376 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005322:	fc442783          	lw	a5,-60(s0)
    80005326:	07e9                	addi	a5,a5,26
    80005328:	078e                	slli	a5,a5,0x3
    8000532a:	97a6                	add	a5,a5,s1
    8000532c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005330:	fc042783          	lw	a5,-64(s0)
    80005334:	07e9                	addi	a5,a5,26
    80005336:	078e                	slli	a5,a5,0x3
    80005338:	94be                	add	s1,s1,a5
    8000533a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000533e:	fd043503          	ld	a0,-48(s0)
    80005342:	ccffe0ef          	jal	80004010 <fileclose>
    fileclose(wf);
    80005346:	fc843503          	ld	a0,-56(s0)
    8000534a:	cc7fe0ef          	jal	80004010 <fileclose>
    return -1;
    8000534e:	57fd                	li	a5,-1
    80005350:	a01d                	j	80005376 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005352:	fc442783          	lw	a5,-60(s0)
    80005356:	0007c763          	bltz	a5,80005364 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000535a:	07e9                	addi	a5,a5,26
    8000535c:	078e                	slli	a5,a5,0x3
    8000535e:	97a6                	add	a5,a5,s1
    80005360:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005364:	fd043503          	ld	a0,-48(s0)
    80005368:	ca9fe0ef          	jal	80004010 <fileclose>
    fileclose(wf);
    8000536c:	fc843503          	ld	a0,-56(s0)
    80005370:	ca1fe0ef          	jal	80004010 <fileclose>
    return -1;
    80005374:	57fd                	li	a5,-1
}
    80005376:	853e                	mv	a0,a5
    80005378:	70e2                	ld	ra,56(sp)
    8000537a:	7442                	ld	s0,48(sp)
    8000537c:	74a2                	ld	s1,40(sp)
    8000537e:	6121                	addi	sp,sp,64
    80005380:	8082                	ret
	...

0000000080005390 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005390:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005392:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005394:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005396:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005398:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000539a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000539c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000539e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    800053a0:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    800053a2:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    800053a4:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    800053a6:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    800053a8:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    800053aa:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    800053ac:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    800053ae:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    800053b0:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800053b2:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800053b4:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800053b6:	ad0fd0ef          	jal	80002686 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800053ba:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800053bc:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800053be:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    800053c0:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    800053c2:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    800053c4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    800053c6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    800053c8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    800053ca:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    800053cc:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    800053ce:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    800053d0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800053d2:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800053d4:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800053d6:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800053d8:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800053da:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800053dc:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800053de:	10200073          	sret
	...

00000000800053ee <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800053ee:	1141                	addi	sp,sp,-16
    800053f0:	e422                	sd	s0,8(sp)
    800053f2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800053f4:	0c0007b7          	lui	a5,0xc000
    800053f8:	4705                	li	a4,1
    800053fa:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800053fc:	0c0007b7          	lui	a5,0xc000
    80005400:	c3d8                	sw	a4,4(a5)
}
    80005402:	6422                	ld	s0,8(sp)
    80005404:	0141                	addi	sp,sp,16
    80005406:	8082                	ret

0000000080005408 <plicinithart>:

void
plicinithart(void)
{
    80005408:	1141                	addi	sp,sp,-16
    8000540a:	e406                	sd	ra,8(sp)
    8000540c:	e022                	sd	s0,0(sp)
    8000540e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005410:	cb6fc0ef          	jal	800018c6 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005414:	0085171b          	slliw	a4,a0,0x8
    80005418:	0c0027b7          	lui	a5,0xc002
    8000541c:	97ba                	add	a5,a5,a4
    8000541e:	40200713          	li	a4,1026
    80005422:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005426:	00d5151b          	slliw	a0,a0,0xd
    8000542a:	0c2017b7          	lui	a5,0xc201
    8000542e:	97aa                	add	a5,a5,a0
    80005430:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005434:	60a2                	ld	ra,8(sp)
    80005436:	6402                	ld	s0,0(sp)
    80005438:	0141                	addi	sp,sp,16
    8000543a:	8082                	ret

000000008000543c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000543c:	1141                	addi	sp,sp,-16
    8000543e:	e406                	sd	ra,8(sp)
    80005440:	e022                	sd	s0,0(sp)
    80005442:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005444:	c82fc0ef          	jal	800018c6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005448:	00d5151b          	slliw	a0,a0,0xd
    8000544c:	0c2017b7          	lui	a5,0xc201
    80005450:	97aa                	add	a5,a5,a0
  return irq;
}
    80005452:	43c8                	lw	a0,4(a5)
    80005454:	60a2                	ld	ra,8(sp)
    80005456:	6402                	ld	s0,0(sp)
    80005458:	0141                	addi	sp,sp,16
    8000545a:	8082                	ret

000000008000545c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000545c:	1101                	addi	sp,sp,-32
    8000545e:	ec06                	sd	ra,24(sp)
    80005460:	e822                	sd	s0,16(sp)
    80005462:	e426                	sd	s1,8(sp)
    80005464:	1000                	addi	s0,sp,32
    80005466:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005468:	c5efc0ef          	jal	800018c6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000546c:	00d5151b          	slliw	a0,a0,0xd
    80005470:	0c2017b7          	lui	a5,0xc201
    80005474:	97aa                	add	a5,a5,a0
    80005476:	c3c4                	sw	s1,4(a5)
}
    80005478:	60e2                	ld	ra,24(sp)
    8000547a:	6442                	ld	s0,16(sp)
    8000547c:	64a2                	ld	s1,8(sp)
    8000547e:	6105                	addi	sp,sp,32
    80005480:	8082                	ret

0000000080005482 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005482:	1141                	addi	sp,sp,-16
    80005484:	e406                	sd	ra,8(sp)
    80005486:	e022                	sd	s0,0(sp)
    80005488:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000548a:	479d                	li	a5,7
    8000548c:	04a7ca63          	blt	a5,a0,800054e0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005490:	0001b797          	auipc	a5,0x1b
    80005494:	5a878793          	addi	a5,a5,1448 # 80020a38 <disk>
    80005498:	97aa                	add	a5,a5,a0
    8000549a:	0187c783          	lbu	a5,24(a5)
    8000549e:	e7b9                	bnez	a5,800054ec <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800054a0:	00451693          	slli	a3,a0,0x4
    800054a4:	0001b797          	auipc	a5,0x1b
    800054a8:	59478793          	addi	a5,a5,1428 # 80020a38 <disk>
    800054ac:	6398                	ld	a4,0(a5)
    800054ae:	9736                	add	a4,a4,a3
    800054b0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800054b4:	6398                	ld	a4,0(a5)
    800054b6:	9736                	add	a4,a4,a3
    800054b8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800054bc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800054c0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800054c4:	97aa                	add	a5,a5,a0
    800054c6:	4705                	li	a4,1
    800054c8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800054cc:	0001b517          	auipc	a0,0x1b
    800054d0:	58450513          	addi	a0,a0,1412 # 80020a50 <disk+0x18>
    800054d4:	a75fc0ef          	jal	80001f48 <wakeup>
}
    800054d8:	60a2                	ld	ra,8(sp)
    800054da:	6402                	ld	s0,0(sp)
    800054dc:	0141                	addi	sp,sp,16
    800054de:	8082                	ret
    panic("free_desc 1");
    800054e0:	00002517          	auipc	a0,0x2
    800054e4:	13050513          	addi	a0,a0,304 # 80007610 <etext+0x610>
    800054e8:	af8fb0ef          	jal	800007e0 <panic>
    panic("free_desc 2");
    800054ec:	00002517          	auipc	a0,0x2
    800054f0:	13450513          	addi	a0,a0,308 # 80007620 <etext+0x620>
    800054f4:	aecfb0ef          	jal	800007e0 <panic>

00000000800054f8 <virtio_disk_init>:
{
    800054f8:	1101                	addi	sp,sp,-32
    800054fa:	ec06                	sd	ra,24(sp)
    800054fc:	e822                	sd	s0,16(sp)
    800054fe:	e426                	sd	s1,8(sp)
    80005500:	e04a                	sd	s2,0(sp)
    80005502:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005504:	00002597          	auipc	a1,0x2
    80005508:	12c58593          	addi	a1,a1,300 # 80007630 <etext+0x630>
    8000550c:	0001b517          	auipc	a0,0x1b
    80005510:	65450513          	addi	a0,a0,1620 # 80020b60 <disk+0x128>
    80005514:	e5efb0ef          	jal	80000b72 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005518:	100017b7          	lui	a5,0x10001
    8000551c:	4398                	lw	a4,0(a5)
    8000551e:	2701                	sext.w	a4,a4
    80005520:	747277b7          	lui	a5,0x74727
    80005524:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005528:	18f71063          	bne	a4,a5,800056a8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000552c:	100017b7          	lui	a5,0x10001
    80005530:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005532:	439c                	lw	a5,0(a5)
    80005534:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005536:	4709                	li	a4,2
    80005538:	16e79863          	bne	a5,a4,800056a8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000553c:	100017b7          	lui	a5,0x10001
    80005540:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005542:	439c                	lw	a5,0(a5)
    80005544:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005546:	16e79163          	bne	a5,a4,800056a8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000554a:	100017b7          	lui	a5,0x10001
    8000554e:	47d8                	lw	a4,12(a5)
    80005550:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005552:	554d47b7          	lui	a5,0x554d4
    80005556:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000555a:	14f71763          	bne	a4,a5,800056a8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000555e:	100017b7          	lui	a5,0x10001
    80005562:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005566:	4705                	li	a4,1
    80005568:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000556a:	470d                	li	a4,3
    8000556c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000556e:	10001737          	lui	a4,0x10001
    80005572:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005574:	c7ffe737          	lui	a4,0xc7ffe
    80005578:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fddbe7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000557c:	8ef9                	and	a3,a3,a4
    8000557e:	10001737          	lui	a4,0x10001
    80005582:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005584:	472d                	li	a4,11
    80005586:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005588:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000558c:	439c                	lw	a5,0(a5)
    8000558e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005592:	8ba1                	andi	a5,a5,8
    80005594:	12078063          	beqz	a5,800056b4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005598:	100017b7          	lui	a5,0x10001
    8000559c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800055a0:	100017b7          	lui	a5,0x10001
    800055a4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800055a8:	439c                	lw	a5,0(a5)
    800055aa:	2781                	sext.w	a5,a5
    800055ac:	10079a63          	bnez	a5,800056c0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055b0:	100017b7          	lui	a5,0x10001
    800055b4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800055b8:	439c                	lw	a5,0(a5)
    800055ba:	2781                	sext.w	a5,a5
  if(max == 0)
    800055bc:	10078863          	beqz	a5,800056cc <virtio_disk_init+0x1d4>
  if(max < NUM)
    800055c0:	471d                	li	a4,7
    800055c2:	10f77b63          	bgeu	a4,a5,800056d8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    800055c6:	d38fb0ef          	jal	80000afe <kalloc>
    800055ca:	0001b497          	auipc	s1,0x1b
    800055ce:	46e48493          	addi	s1,s1,1134 # 80020a38 <disk>
    800055d2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800055d4:	d2afb0ef          	jal	80000afe <kalloc>
    800055d8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800055da:	d24fb0ef          	jal	80000afe <kalloc>
    800055de:	87aa                	mv	a5,a0
    800055e0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800055e2:	6088                	ld	a0,0(s1)
    800055e4:	10050063          	beqz	a0,800056e4 <virtio_disk_init+0x1ec>
    800055e8:	0001b717          	auipc	a4,0x1b
    800055ec:	45873703          	ld	a4,1112(a4) # 80020a40 <disk+0x8>
    800055f0:	0e070a63          	beqz	a4,800056e4 <virtio_disk_init+0x1ec>
    800055f4:	0e078863          	beqz	a5,800056e4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800055f8:	6605                	lui	a2,0x1
    800055fa:	4581                	li	a1,0
    800055fc:	ecafb0ef          	jal	80000cc6 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005600:	0001b497          	auipc	s1,0x1b
    80005604:	43848493          	addi	s1,s1,1080 # 80020a38 <disk>
    80005608:	6605                	lui	a2,0x1
    8000560a:	4581                	li	a1,0
    8000560c:	6488                	ld	a0,8(s1)
    8000560e:	eb8fb0ef          	jal	80000cc6 <memset>
  memset(disk.used, 0, PGSIZE);
    80005612:	6605                	lui	a2,0x1
    80005614:	4581                	li	a1,0
    80005616:	6888                	ld	a0,16(s1)
    80005618:	eaefb0ef          	jal	80000cc6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000561c:	100017b7          	lui	a5,0x10001
    80005620:	4721                	li	a4,8
    80005622:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005624:	4098                	lw	a4,0(s1)
    80005626:	100017b7          	lui	a5,0x10001
    8000562a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000562e:	40d8                	lw	a4,4(s1)
    80005630:	100017b7          	lui	a5,0x10001
    80005634:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005638:	649c                	ld	a5,8(s1)
    8000563a:	0007869b          	sext.w	a3,a5
    8000563e:	10001737          	lui	a4,0x10001
    80005642:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005646:	9781                	srai	a5,a5,0x20
    80005648:	10001737          	lui	a4,0x10001
    8000564c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005650:	689c                	ld	a5,16(s1)
    80005652:	0007869b          	sext.w	a3,a5
    80005656:	10001737          	lui	a4,0x10001
    8000565a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000565e:	9781                	srai	a5,a5,0x20
    80005660:	10001737          	lui	a4,0x10001
    80005664:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005668:	10001737          	lui	a4,0x10001
    8000566c:	4785                	li	a5,1
    8000566e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005670:	00f48c23          	sb	a5,24(s1)
    80005674:	00f48ca3          	sb	a5,25(s1)
    80005678:	00f48d23          	sb	a5,26(s1)
    8000567c:	00f48da3          	sb	a5,27(s1)
    80005680:	00f48e23          	sb	a5,28(s1)
    80005684:	00f48ea3          	sb	a5,29(s1)
    80005688:	00f48f23          	sb	a5,30(s1)
    8000568c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005690:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005694:	100017b7          	lui	a5,0x10001
    80005698:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000569c:	60e2                	ld	ra,24(sp)
    8000569e:	6442                	ld	s0,16(sp)
    800056a0:	64a2                	ld	s1,8(sp)
    800056a2:	6902                	ld	s2,0(sp)
    800056a4:	6105                	addi	sp,sp,32
    800056a6:	8082                	ret
    panic("could not find virtio disk");
    800056a8:	00002517          	auipc	a0,0x2
    800056ac:	f9850513          	addi	a0,a0,-104 # 80007640 <etext+0x640>
    800056b0:	930fb0ef          	jal	800007e0 <panic>
    panic("virtio disk FEATURES_OK unset");
    800056b4:	00002517          	auipc	a0,0x2
    800056b8:	fac50513          	addi	a0,a0,-84 # 80007660 <etext+0x660>
    800056bc:	924fb0ef          	jal	800007e0 <panic>
    panic("virtio disk should not be ready");
    800056c0:	00002517          	auipc	a0,0x2
    800056c4:	fc050513          	addi	a0,a0,-64 # 80007680 <etext+0x680>
    800056c8:	918fb0ef          	jal	800007e0 <panic>
    panic("virtio disk has no queue 0");
    800056cc:	00002517          	auipc	a0,0x2
    800056d0:	fd450513          	addi	a0,a0,-44 # 800076a0 <etext+0x6a0>
    800056d4:	90cfb0ef          	jal	800007e0 <panic>
    panic("virtio disk max queue too short");
    800056d8:	00002517          	auipc	a0,0x2
    800056dc:	fe850513          	addi	a0,a0,-24 # 800076c0 <etext+0x6c0>
    800056e0:	900fb0ef          	jal	800007e0 <panic>
    panic("virtio disk kalloc");
    800056e4:	00002517          	auipc	a0,0x2
    800056e8:	ffc50513          	addi	a0,a0,-4 # 800076e0 <etext+0x6e0>
    800056ec:	8f4fb0ef          	jal	800007e0 <panic>

00000000800056f0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800056f0:	7159                	addi	sp,sp,-112
    800056f2:	f486                	sd	ra,104(sp)
    800056f4:	f0a2                	sd	s0,96(sp)
    800056f6:	eca6                	sd	s1,88(sp)
    800056f8:	e8ca                	sd	s2,80(sp)
    800056fa:	e4ce                	sd	s3,72(sp)
    800056fc:	e0d2                	sd	s4,64(sp)
    800056fe:	fc56                	sd	s5,56(sp)
    80005700:	f85a                	sd	s6,48(sp)
    80005702:	f45e                	sd	s7,40(sp)
    80005704:	f062                	sd	s8,32(sp)
    80005706:	ec66                	sd	s9,24(sp)
    80005708:	1880                	addi	s0,sp,112
    8000570a:	8a2a                	mv	s4,a0
    8000570c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000570e:	00c52c83          	lw	s9,12(a0)
    80005712:	001c9c9b          	slliw	s9,s9,0x1
    80005716:	1c82                	slli	s9,s9,0x20
    80005718:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000571c:	0001b517          	auipc	a0,0x1b
    80005720:	44450513          	addi	a0,a0,1092 # 80020b60 <disk+0x128>
    80005724:	ccefb0ef          	jal	80000bf2 <acquire>
  for(int i = 0; i < 3; i++){
    80005728:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000572a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000572c:	0001bb17          	auipc	s6,0x1b
    80005730:	30cb0b13          	addi	s6,s6,780 # 80020a38 <disk>
  for(int i = 0; i < 3; i++){
    80005734:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005736:	0001bc17          	auipc	s8,0x1b
    8000573a:	42ac0c13          	addi	s8,s8,1066 # 80020b60 <disk+0x128>
    8000573e:	a8b9                	j	8000579c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005740:	00fb0733          	add	a4,s6,a5
    80005744:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005748:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000574a:	0207c563          	bltz	a5,80005774 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000574e:	2905                	addiw	s2,s2,1
    80005750:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005752:	05590963          	beq	s2,s5,800057a4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005756:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005758:	0001b717          	auipc	a4,0x1b
    8000575c:	2e070713          	addi	a4,a4,736 # 80020a38 <disk>
    80005760:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005762:	01874683          	lbu	a3,24(a4)
    80005766:	fee9                	bnez	a3,80005740 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005768:	2785                	addiw	a5,a5,1
    8000576a:	0705                	addi	a4,a4,1
    8000576c:	fe979be3          	bne	a5,s1,80005762 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005770:	57fd                	li	a5,-1
    80005772:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005774:	01205d63          	blez	s2,8000578e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005778:	f9042503          	lw	a0,-112(s0)
    8000577c:	d07ff0ef          	jal	80005482 <free_desc>
      for(int j = 0; j < i; j++)
    80005780:	4785                	li	a5,1
    80005782:	0127d663          	bge	a5,s2,8000578e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005786:	f9442503          	lw	a0,-108(s0)
    8000578a:	cf9ff0ef          	jal	80005482 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000578e:	85e2                	mv	a1,s8
    80005790:	0001b517          	auipc	a0,0x1b
    80005794:	2c050513          	addi	a0,a0,704 # 80020a50 <disk+0x18>
    80005798:	f64fc0ef          	jal	80001efc <sleep>
  for(int i = 0; i < 3; i++){
    8000579c:	f9040613          	addi	a2,s0,-112
    800057a0:	894e                	mv	s2,s3
    800057a2:	bf55                	j	80005756 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057a4:	f9042503          	lw	a0,-112(s0)
    800057a8:	00451693          	slli	a3,a0,0x4

  if(write)
    800057ac:	0001b797          	auipc	a5,0x1b
    800057b0:	28c78793          	addi	a5,a5,652 # 80020a38 <disk>
    800057b4:	00a50713          	addi	a4,a0,10
    800057b8:	0712                	slli	a4,a4,0x4
    800057ba:	973e                	add	a4,a4,a5
    800057bc:	01703633          	snez	a2,s7
    800057c0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800057c2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800057c6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800057ca:	6398                	ld	a4,0(a5)
    800057cc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057ce:	0a868613          	addi	a2,a3,168
    800057d2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800057d4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800057d6:	6390                	ld	a2,0(a5)
    800057d8:	00d605b3          	add	a1,a2,a3
    800057dc:	4741                	li	a4,16
    800057de:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800057e0:	4805                	li	a6,1
    800057e2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800057e6:	f9442703          	lw	a4,-108(s0)
    800057ea:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800057ee:	0712                	slli	a4,a4,0x4
    800057f0:	963a                	add	a2,a2,a4
    800057f2:	058a0593          	addi	a1,s4,88
    800057f6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800057f8:	0007b883          	ld	a7,0(a5)
    800057fc:	9746                	add	a4,a4,a7
    800057fe:	40000613          	li	a2,1024
    80005802:	c710                	sw	a2,8(a4)
  if(write)
    80005804:	001bb613          	seqz	a2,s7
    80005808:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000580c:	00166613          	ori	a2,a2,1
    80005810:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005814:	f9842583          	lw	a1,-104(s0)
    80005818:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000581c:	00250613          	addi	a2,a0,2
    80005820:	0612                	slli	a2,a2,0x4
    80005822:	963e                	add	a2,a2,a5
    80005824:	577d                	li	a4,-1
    80005826:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000582a:	0592                	slli	a1,a1,0x4
    8000582c:	98ae                	add	a7,a7,a1
    8000582e:	03068713          	addi	a4,a3,48
    80005832:	973e                	add	a4,a4,a5
    80005834:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005838:	6398                	ld	a4,0(a5)
    8000583a:	972e                	add	a4,a4,a1
    8000583c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005840:	4689                	li	a3,2
    80005842:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005846:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000584a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000584e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005852:	6794                	ld	a3,8(a5)
    80005854:	0026d703          	lhu	a4,2(a3)
    80005858:	8b1d                	andi	a4,a4,7
    8000585a:	0706                	slli	a4,a4,0x1
    8000585c:	96ba                	add	a3,a3,a4
    8000585e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005862:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005866:	6798                	ld	a4,8(a5)
    80005868:	00275783          	lhu	a5,2(a4)
    8000586c:	2785                	addiw	a5,a5,1
    8000586e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005872:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005876:	100017b7          	lui	a5,0x10001
    8000587a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000587e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005882:	0001b917          	auipc	s2,0x1b
    80005886:	2de90913          	addi	s2,s2,734 # 80020b60 <disk+0x128>
  while(b->disk == 1) {
    8000588a:	4485                	li	s1,1
    8000588c:	01079a63          	bne	a5,a6,800058a0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005890:	85ca                	mv	a1,s2
    80005892:	8552                	mv	a0,s4
    80005894:	e68fc0ef          	jal	80001efc <sleep>
  while(b->disk == 1) {
    80005898:	004a2783          	lw	a5,4(s4)
    8000589c:	fe978ae3          	beq	a5,s1,80005890 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    800058a0:	f9042903          	lw	s2,-112(s0)
    800058a4:	00290713          	addi	a4,s2,2
    800058a8:	0712                	slli	a4,a4,0x4
    800058aa:	0001b797          	auipc	a5,0x1b
    800058ae:	18e78793          	addi	a5,a5,398 # 80020a38 <disk>
    800058b2:	97ba                	add	a5,a5,a4
    800058b4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800058b8:	0001b997          	auipc	s3,0x1b
    800058bc:	18098993          	addi	s3,s3,384 # 80020a38 <disk>
    800058c0:	00491713          	slli	a4,s2,0x4
    800058c4:	0009b783          	ld	a5,0(s3)
    800058c8:	97ba                	add	a5,a5,a4
    800058ca:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800058ce:	854a                	mv	a0,s2
    800058d0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800058d4:	bafff0ef          	jal	80005482 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800058d8:	8885                	andi	s1,s1,1
    800058da:	f0fd                	bnez	s1,800058c0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800058dc:	0001b517          	auipc	a0,0x1b
    800058e0:	28450513          	addi	a0,a0,644 # 80020b60 <disk+0x128>
    800058e4:	ba6fb0ef          	jal	80000c8a <release>
}
    800058e8:	70a6                	ld	ra,104(sp)
    800058ea:	7406                	ld	s0,96(sp)
    800058ec:	64e6                	ld	s1,88(sp)
    800058ee:	6946                	ld	s2,80(sp)
    800058f0:	69a6                	ld	s3,72(sp)
    800058f2:	6a06                	ld	s4,64(sp)
    800058f4:	7ae2                	ld	s5,56(sp)
    800058f6:	7b42                	ld	s6,48(sp)
    800058f8:	7ba2                	ld	s7,40(sp)
    800058fa:	7c02                	ld	s8,32(sp)
    800058fc:	6ce2                	ld	s9,24(sp)
    800058fe:	6165                	addi	sp,sp,112
    80005900:	8082                	ret

0000000080005902 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005902:	1101                	addi	sp,sp,-32
    80005904:	ec06                	sd	ra,24(sp)
    80005906:	e822                	sd	s0,16(sp)
    80005908:	e426                	sd	s1,8(sp)
    8000590a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000590c:	0001b497          	auipc	s1,0x1b
    80005910:	12c48493          	addi	s1,s1,300 # 80020a38 <disk>
    80005914:	0001b517          	auipc	a0,0x1b
    80005918:	24c50513          	addi	a0,a0,588 # 80020b60 <disk+0x128>
    8000591c:	ad6fb0ef          	jal	80000bf2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005920:	100017b7          	lui	a5,0x10001
    80005924:	53b8                	lw	a4,96(a5)
    80005926:	8b0d                	andi	a4,a4,3
    80005928:	100017b7          	lui	a5,0x10001
    8000592c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000592e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005932:	689c                	ld	a5,16(s1)
    80005934:	0204d703          	lhu	a4,32(s1)
    80005938:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000593c:	04f70663          	beq	a4,a5,80005988 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005940:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005944:	6898                	ld	a4,16(s1)
    80005946:	0204d783          	lhu	a5,32(s1)
    8000594a:	8b9d                	andi	a5,a5,7
    8000594c:	078e                	slli	a5,a5,0x3
    8000594e:	97ba                	add	a5,a5,a4
    80005950:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005952:	00278713          	addi	a4,a5,2
    80005956:	0712                	slli	a4,a4,0x4
    80005958:	9726                	add	a4,a4,s1
    8000595a:	01074703          	lbu	a4,16(a4)
    8000595e:	e321                	bnez	a4,8000599e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005960:	0789                	addi	a5,a5,2
    80005962:	0792                	slli	a5,a5,0x4
    80005964:	97a6                	add	a5,a5,s1
    80005966:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005968:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000596c:	ddcfc0ef          	jal	80001f48 <wakeup>

    disk.used_idx += 1;
    80005970:	0204d783          	lhu	a5,32(s1)
    80005974:	2785                	addiw	a5,a5,1
    80005976:	17c2                	slli	a5,a5,0x30
    80005978:	93c1                	srli	a5,a5,0x30
    8000597a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000597e:	6898                	ld	a4,16(s1)
    80005980:	00275703          	lhu	a4,2(a4)
    80005984:	faf71ee3          	bne	a4,a5,80005940 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005988:	0001b517          	auipc	a0,0x1b
    8000598c:	1d850513          	addi	a0,a0,472 # 80020b60 <disk+0x128>
    80005990:	afafb0ef          	jal	80000c8a <release>
}
    80005994:	60e2                	ld	ra,24(sp)
    80005996:	6442                	ld	s0,16(sp)
    80005998:	64a2                	ld	s1,8(sp)
    8000599a:	6105                	addi	sp,sp,32
    8000599c:	8082                	ret
      panic("virtio_disk_intr status");
    8000599e:	00002517          	auipc	a0,0x2
    800059a2:	d5a50513          	addi	a0,a0,-678 # 800076f8 <etext+0x6f8>
    800059a6:	e3bfa0ef          	jal	800007e0 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
