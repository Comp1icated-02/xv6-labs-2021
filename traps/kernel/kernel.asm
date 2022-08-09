
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	80013103          	ld	sp,-2048(sp) # 80008800 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	361050ef          	jal	ra,80005b76 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00028797          	auipc	a5,0x28
    80000034:	43078793          	addi	a5,a5,1072 # 80028460 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	516080e7          	jalr	1302(ra) # 80006570 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	5b6080e7          	jalr	1462(ra) # 80006624 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	f9c080e7          	jalr	-100(ra) # 80006026 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	3ec080e7          	jalr	1004(ra) # 800064e0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00028517          	auipc	a0,0x28
    80000104:	36050513          	addi	a0,a0,864 # 80028460 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	444080e7          	jalr	1092(ra) # 80006570 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	4e0080e7          	jalr	1248(ra) # 80006624 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	4b6080e7          	jalr	1206(ra) # 80006624 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	adc080e7          	jalr	-1316(ra) # 80000e0a <cpuid>
    userinit();      // first user process
    vma_init();     // added
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ac0080e7          	jalr	-1344(ra) # 80000e0a <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	d14080e7          	jalr	-748(ra) # 80006070 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0e0080e7          	jalr	224(ra) # 80000444 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	83e080e7          	jalr	-1986(ra) # 80001baa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	0ec080e7          	jalr	236(ra) # 80005460 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	058080e7          	jalr	88(ra) # 800013d4 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	bb4080e7          	jalr	-1100(ra) # 80005f38 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	eca080e7          	jalr	-310(ra) # 80006256 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	cd4080e7          	jalr	-812(ra) # 80006070 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	cc4080e7          	jalr	-828(ra) # 80006070 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	cb4080e7          	jalr	-844(ra) # 80006070 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	32a080e7          	jalr	810(ra) # 800006f6 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	070080e7          	jalr	112(ra) # 80000444 <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	97e080e7          	jalr	-1666(ra) # 80000d5a <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	79e080e7          	jalr	1950(ra) # 80001b82 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	7be080e7          	jalr	1982(ra) # 80001baa <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	056080e7          	jalr	86(ra) # 8000544a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	064080e7          	jalr	100(ra) # 80005460 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	fa2080e7          	jalr	-94(ra) # 800023a6 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	632080e7          	jalr	1586(ra) # 80002a3e <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	5dc080e7          	jalr	1500(ra) # 800039f0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	166080e7          	jalr	358(ra) # 80005582 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d10080e7          	jalr	-752(ra) # 80001134 <userinit>
    vma_init();     // added
    8000042c:	00005097          	auipc	ra,0x5
    80000430:	63a080e7          	jalr	1594(ra) # 80005a66 <vma_init>
    __sync_synchronize();
    80000434:	0ff0000f          	fence
    started = 1;
    80000438:	4785                	li	a5,1
    8000043a:	00009717          	auipc	a4,0x9
    8000043e:	bcf72323          	sw	a5,-1082(a4) # 80009000 <started>
    80000442:	bf2d                	j	8000037c <main+0x56>

0000000080000444 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000444:	1141                	addi	sp,sp,-16
    80000446:	e422                	sd	s0,8(sp)
    80000448:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000044a:	00009797          	auipc	a5,0x9
    8000044e:	bbe7b783          	ld	a5,-1090(a5) # 80009008 <kernel_pagetable>
    80000452:	83b1                	srli	a5,a5,0xc
    80000454:	577d                	li	a4,-1
    80000456:	177e                	slli	a4,a4,0x3f
    80000458:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000045a:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000045e:	12000073          	sfence.vma
  sfence_vma();
}
    80000462:	6422                	ld	s0,8(sp)
    80000464:	0141                	addi	sp,sp,16
    80000466:	8082                	ret

0000000080000468 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000468:	7139                	addi	sp,sp,-64
    8000046a:	fc06                	sd	ra,56(sp)
    8000046c:	f822                	sd	s0,48(sp)
    8000046e:	f426                	sd	s1,40(sp)
    80000470:	f04a                	sd	s2,32(sp)
    80000472:	ec4e                	sd	s3,24(sp)
    80000474:	e852                	sd	s4,16(sp)
    80000476:	e456                	sd	s5,8(sp)
    80000478:	e05a                	sd	s6,0(sp)
    8000047a:	0080                	addi	s0,sp,64
    8000047c:	84aa                	mv	s1,a0
    8000047e:	89ae                	mv	s3,a1
    80000480:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000482:	57fd                	li	a5,-1
    80000484:	83e9                	srli	a5,a5,0x1a
    80000486:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000488:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000048a:	04b7f263          	bgeu	a5,a1,800004ce <walk+0x66>
    panic("walk");
    8000048e:	00008517          	auipc	a0,0x8
    80000492:	bc250513          	addi	a0,a0,-1086 # 80008050 <etext+0x50>
    80000496:	00006097          	auipc	ra,0x6
    8000049a:	b90080e7          	jalr	-1136(ra) # 80006026 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000049e:	060a8663          	beqz	s5,8000050a <walk+0xa2>
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	c76080e7          	jalr	-906(ra) # 80000118 <kalloc>
    800004aa:	84aa                	mv	s1,a0
    800004ac:	c529                	beqz	a0,800004f6 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004ae:	6605                	lui	a2,0x1
    800004b0:	4581                	li	a1,0
    800004b2:	00000097          	auipc	ra,0x0
    800004b6:	cc6080e7          	jalr	-826(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ba:	00c4d793          	srli	a5,s1,0xc
    800004be:	07aa                	slli	a5,a5,0xa
    800004c0:	0017e793          	ori	a5,a5,1
    800004c4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c8:	3a5d                	addiw	s4,s4,-9
    800004ca:	036a0063          	beq	s4,s6,800004ea <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ce:	0149d933          	srl	s2,s3,s4
    800004d2:	1ff97913          	andi	s2,s2,511
    800004d6:	090e                	slli	s2,s2,0x3
    800004d8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004da:	00093483          	ld	s1,0(s2)
    800004de:	0014f793          	andi	a5,s1,1
    800004e2:	dfd5                	beqz	a5,8000049e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e4:	80a9                	srli	s1,s1,0xa
    800004e6:	04b2                	slli	s1,s1,0xc
    800004e8:	b7c5                	j	800004c8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004ea:	00c9d513          	srli	a0,s3,0xc
    800004ee:	1ff57513          	andi	a0,a0,511
    800004f2:	050e                	slli	a0,a0,0x3
    800004f4:	9526                	add	a0,a0,s1
}
    800004f6:	70e2                	ld	ra,56(sp)
    800004f8:	7442                	ld	s0,48(sp)
    800004fa:	74a2                	ld	s1,40(sp)
    800004fc:	7902                	ld	s2,32(sp)
    800004fe:	69e2                	ld	s3,24(sp)
    80000500:	6a42                	ld	s4,16(sp)
    80000502:	6aa2                	ld	s5,8(sp)
    80000504:	6b02                	ld	s6,0(sp)
    80000506:	6121                	addi	sp,sp,64
    80000508:	8082                	ret
        return 0;
    8000050a:	4501                	li	a0,0
    8000050c:	b7ed                	j	800004f6 <walk+0x8e>

000000008000050e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000050e:	57fd                	li	a5,-1
    80000510:	83e9                	srli	a5,a5,0x1a
    80000512:	00b7f463          	bgeu	a5,a1,8000051a <walkaddr+0xc>
    return 0;
    80000516:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000518:	8082                	ret
{
    8000051a:	1141                	addi	sp,sp,-16
    8000051c:	e406                	sd	ra,8(sp)
    8000051e:	e022                	sd	s0,0(sp)
    80000520:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000522:	4601                	li	a2,0
    80000524:	00000097          	auipc	ra,0x0
    80000528:	f44080e7          	jalr	-188(ra) # 80000468 <walk>
  if(pte == 0)
    8000052c:	c105                	beqz	a0,8000054c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000052e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000530:	0117f693          	andi	a3,a5,17
    80000534:	4745                	li	a4,17
    return 0;
    80000536:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000538:	00e68663          	beq	a3,a4,80000544 <walkaddr+0x36>
}
    8000053c:	60a2                	ld	ra,8(sp)
    8000053e:	6402                	ld	s0,0(sp)
    80000540:	0141                	addi	sp,sp,16
    80000542:	8082                	ret
  pa = PTE2PA(*pte);
    80000544:	00a7d513          	srli	a0,a5,0xa
    80000548:	0532                	slli	a0,a0,0xc
  return pa;
    8000054a:	bfcd                	j	8000053c <walkaddr+0x2e>
    return 0;
    8000054c:	4501                	li	a0,0
    8000054e:	b7fd                	j	8000053c <walkaddr+0x2e>

0000000080000550 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000550:	715d                	addi	sp,sp,-80
    80000552:	e486                	sd	ra,72(sp)
    80000554:	e0a2                	sd	s0,64(sp)
    80000556:	fc26                	sd	s1,56(sp)
    80000558:	f84a                	sd	s2,48(sp)
    8000055a:	f44e                	sd	s3,40(sp)
    8000055c:	f052                	sd	s4,32(sp)
    8000055e:	ec56                	sd	s5,24(sp)
    80000560:	e85a                	sd	s6,16(sp)
    80000562:	e45e                	sd	s7,8(sp)
    80000564:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000566:	c205                	beqz	a2,80000586 <mappages+0x36>
    80000568:	8aaa                	mv	s5,a0
    8000056a:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000056c:	77fd                	lui	a5,0xfffff
    8000056e:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000572:	15fd                	addi	a1,a1,-1
    80000574:	00c589b3          	add	s3,a1,a2
    80000578:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000057c:	8952                	mv	s2,s4
    8000057e:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000582:	6b85                	lui	s7,0x1
    80000584:	a015                	j	800005a8 <mappages+0x58>
    panic("mappages: size");
    80000586:	00008517          	auipc	a0,0x8
    8000058a:	ad250513          	addi	a0,a0,-1326 # 80008058 <etext+0x58>
    8000058e:	00006097          	auipc	ra,0x6
    80000592:	a98080e7          	jalr	-1384(ra) # 80006026 <panic>
      panic("mappages: remap");
    80000596:	00008517          	auipc	a0,0x8
    8000059a:	ad250513          	addi	a0,a0,-1326 # 80008068 <etext+0x68>
    8000059e:	00006097          	auipc	ra,0x6
    800005a2:	a88080e7          	jalr	-1400(ra) # 80006026 <panic>
    a += PGSIZE;
    800005a6:	995e                	add	s2,s2,s7
  for(;;){
    800005a8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ac:	4605                	li	a2,1
    800005ae:	85ca                	mv	a1,s2
    800005b0:	8556                	mv	a0,s5
    800005b2:	00000097          	auipc	ra,0x0
    800005b6:	eb6080e7          	jalr	-330(ra) # 80000468 <walk>
    800005ba:	cd19                	beqz	a0,800005d8 <mappages+0x88>
    if(*pte & PTE_V)
    800005bc:	611c                	ld	a5,0(a0)
    800005be:	8b85                	andi	a5,a5,1
    800005c0:	fbf9                	bnez	a5,80000596 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005c2:	80b1                	srli	s1,s1,0xc
    800005c4:	04aa                	slli	s1,s1,0xa
    800005c6:	0164e4b3          	or	s1,s1,s6
    800005ca:	0014e493          	ori	s1,s1,1
    800005ce:	e104                	sd	s1,0(a0)
    if(a == last)
    800005d0:	fd391be3          	bne	s2,s3,800005a6 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005d4:	4501                	li	a0,0
    800005d6:	a011                	j	800005da <mappages+0x8a>
      return -1;
    800005d8:	557d                	li	a0,-1
}
    800005da:	60a6                	ld	ra,72(sp)
    800005dc:	6406                	ld	s0,64(sp)
    800005de:	74e2                	ld	s1,56(sp)
    800005e0:	7942                	ld	s2,48(sp)
    800005e2:	79a2                	ld	s3,40(sp)
    800005e4:	7a02                	ld	s4,32(sp)
    800005e6:	6ae2                	ld	s5,24(sp)
    800005e8:	6b42                	ld	s6,16(sp)
    800005ea:	6ba2                	ld	s7,8(sp)
    800005ec:	6161                	addi	sp,sp,80
    800005ee:	8082                	ret

00000000800005f0 <kvmmap>:
{
    800005f0:	1141                	addi	sp,sp,-16
    800005f2:	e406                	sd	ra,8(sp)
    800005f4:	e022                	sd	s0,0(sp)
    800005f6:	0800                	addi	s0,sp,16
    800005f8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005fa:	86b2                	mv	a3,a2
    800005fc:	863e                	mv	a2,a5
    800005fe:	00000097          	auipc	ra,0x0
    80000602:	f52080e7          	jalr	-174(ra) # 80000550 <mappages>
    80000606:	e509                	bnez	a0,80000610 <kvmmap+0x20>
}
    80000608:	60a2                	ld	ra,8(sp)
    8000060a:	6402                	ld	s0,0(sp)
    8000060c:	0141                	addi	sp,sp,16
    8000060e:	8082                	ret
    panic("kvmmap");
    80000610:	00008517          	auipc	a0,0x8
    80000614:	a6850513          	addi	a0,a0,-1432 # 80008078 <etext+0x78>
    80000618:	00006097          	auipc	ra,0x6
    8000061c:	a0e080e7          	jalr	-1522(ra) # 80006026 <panic>

0000000080000620 <kvmmake>:
{
    80000620:	1101                	addi	sp,sp,-32
    80000622:	ec06                	sd	ra,24(sp)
    80000624:	e822                	sd	s0,16(sp)
    80000626:	e426                	sd	s1,8(sp)
    80000628:	e04a                	sd	s2,0(sp)
    8000062a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	aec080e7          	jalr	-1300(ra) # 80000118 <kalloc>
    80000634:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000636:	6605                	lui	a2,0x1
    80000638:	4581                	li	a1,0
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	b3e080e7          	jalr	-1218(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000642:	4719                	li	a4,6
    80000644:	6685                	lui	a3,0x1
    80000646:	10000637          	lui	a2,0x10000
    8000064a:	100005b7          	lui	a1,0x10000
    8000064e:	8526                	mv	a0,s1
    80000650:	00000097          	auipc	ra,0x0
    80000654:	fa0080e7          	jalr	-96(ra) # 800005f0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000658:	4719                	li	a4,6
    8000065a:	6685                	lui	a3,0x1
    8000065c:	10001637          	lui	a2,0x10001
    80000660:	100015b7          	lui	a1,0x10001
    80000664:	8526                	mv	a0,s1
    80000666:	00000097          	auipc	ra,0x0
    8000066a:	f8a080e7          	jalr	-118(ra) # 800005f0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000066e:	4719                	li	a4,6
    80000670:	004006b7          	lui	a3,0x400
    80000674:	0c000637          	lui	a2,0xc000
    80000678:	0c0005b7          	lui	a1,0xc000
    8000067c:	8526                	mv	a0,s1
    8000067e:	00000097          	auipc	ra,0x0
    80000682:	f72080e7          	jalr	-142(ra) # 800005f0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000686:	00008917          	auipc	s2,0x8
    8000068a:	97a90913          	addi	s2,s2,-1670 # 80008000 <etext>
    8000068e:	4729                	li	a4,10
    80000690:	80008697          	auipc	a3,0x80008
    80000694:	97068693          	addi	a3,a3,-1680 # 8000 <_entry-0x7fff8000>
    80000698:	4605                	li	a2,1
    8000069a:	067e                	slli	a2,a2,0x1f
    8000069c:	85b2                	mv	a1,a2
    8000069e:	8526                	mv	a0,s1
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	f50080e7          	jalr	-176(ra) # 800005f0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a8:	4719                	li	a4,6
    800006aa:	46c5                	li	a3,17
    800006ac:	06ee                	slli	a3,a3,0x1b
    800006ae:	412686b3          	sub	a3,a3,s2
    800006b2:	864a                	mv	a2,s2
    800006b4:	85ca                	mv	a1,s2
    800006b6:	8526                	mv	a0,s1
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	f38080e7          	jalr	-200(ra) # 800005f0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006c0:	4729                	li	a4,10
    800006c2:	6685                	lui	a3,0x1
    800006c4:	00007617          	auipc	a2,0x7
    800006c8:	93c60613          	addi	a2,a2,-1732 # 80007000 <_trampoline>
    800006cc:	040005b7          	lui	a1,0x4000
    800006d0:	15fd                	addi	a1,a1,-1
    800006d2:	05b2                	slli	a1,a1,0xc
    800006d4:	8526                	mv	a0,s1
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	f1a080e7          	jalr	-230(ra) # 800005f0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006de:	8526                	mv	a0,s1
    800006e0:	00000097          	auipc	ra,0x0
    800006e4:	5e4080e7          	jalr	1508(ra) # 80000cc4 <proc_mapstacks>
}
    800006e8:	8526                	mv	a0,s1
    800006ea:	60e2                	ld	ra,24(sp)
    800006ec:	6442                	ld	s0,16(sp)
    800006ee:	64a2                	ld	s1,8(sp)
    800006f0:	6902                	ld	s2,0(sp)
    800006f2:	6105                	addi	sp,sp,32
    800006f4:	8082                	ret

00000000800006f6 <kvminit>:
{
    800006f6:	1141                	addi	sp,sp,-16
    800006f8:	e406                	sd	ra,8(sp)
    800006fa:	e022                	sd	s0,0(sp)
    800006fc:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006fe:	00000097          	auipc	ra,0x0
    80000702:	f22080e7          	jalr	-222(ra) # 80000620 <kvmmake>
    80000706:	00009797          	auipc	a5,0x9
    8000070a:	90a7b123          	sd	a0,-1790(a5) # 80009008 <kernel_pagetable>
}
    8000070e:	60a2                	ld	ra,8(sp)
    80000710:	6402                	ld	s0,0(sp)
    80000712:	0141                	addi	sp,sp,16
    80000714:	8082                	ret

0000000080000716 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000716:	715d                	addi	sp,sp,-80
    80000718:	e486                	sd	ra,72(sp)
    8000071a:	e0a2                	sd	s0,64(sp)
    8000071c:	fc26                	sd	s1,56(sp)
    8000071e:	f84a                	sd	s2,48(sp)
    80000720:	f44e                	sd	s3,40(sp)
    80000722:	f052                	sd	s4,32(sp)
    80000724:	ec56                	sd	s5,24(sp)
    80000726:	e85a                	sd	s6,16(sp)
    80000728:	e45e                	sd	s7,8(sp)
    8000072a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000072c:	03459793          	slli	a5,a1,0x34
    80000730:	e795                	bnez	a5,8000075c <uvmunmap+0x46>
    80000732:	8a2a                	mv	s4,a0
    80000734:	892e                	mv	s2,a1
    80000736:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	0632                	slli	a2,a2,0xc
    8000073a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
	    continue;
	   // panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000073e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000740:	6a85                	lui	s5,0x1
    80000742:	0735e163          	bltu	a1,s3,800007a4 <uvmunmap+0x8e>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000746:	60a6                	ld	ra,72(sp)
    80000748:	6406                	ld	s0,64(sp)
    8000074a:	74e2                	ld	s1,56(sp)
    8000074c:	7942                	ld	s2,48(sp)
    8000074e:	79a2                	ld	s3,40(sp)
    80000750:	7a02                	ld	s4,32(sp)
    80000752:	6ae2                	ld	s5,24(sp)
    80000754:	6b42                	ld	s6,16(sp)
    80000756:	6ba2                	ld	s7,8(sp)
    80000758:	6161                	addi	sp,sp,80
    8000075a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000075c:	00008517          	auipc	a0,0x8
    80000760:	92450513          	addi	a0,a0,-1756 # 80008080 <etext+0x80>
    80000764:	00006097          	auipc	ra,0x6
    80000768:	8c2080e7          	jalr	-1854(ra) # 80006026 <panic>
      panic("uvmunmap: walk");
    8000076c:	00008517          	auipc	a0,0x8
    80000770:	92c50513          	addi	a0,a0,-1748 # 80008098 <etext+0x98>
    80000774:	00006097          	auipc	ra,0x6
    80000778:	8b2080e7          	jalr	-1870(ra) # 80006026 <panic>
      panic("uvmunmap: not a leaf");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	92c50513          	addi	a0,a0,-1748 # 800080a8 <etext+0xa8>
    80000784:	00006097          	auipc	ra,0x6
    80000788:	8a2080e7          	jalr	-1886(ra) # 80006026 <panic>
      uint64 pa = PTE2PA(*pte);
    8000078c:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    8000078e:	00c79513          	slli	a0,a5,0xc
    80000792:	00000097          	auipc	ra,0x0
    80000796:	88a080e7          	jalr	-1910(ra) # 8000001c <kfree>
    *pte = 0;
    8000079a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000079e:	9956                	add	s2,s2,s5
    800007a0:	fb3973e3          	bgeu	s2,s3,80000746 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007a4:	4601                	li	a2,0
    800007a6:	85ca                	mv	a1,s2
    800007a8:	8552                	mv	a0,s4
    800007aa:	00000097          	auipc	ra,0x0
    800007ae:	cbe080e7          	jalr	-834(ra) # 80000468 <walk>
    800007b2:	84aa                	mv	s1,a0
    800007b4:	dd45                	beqz	a0,8000076c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007b6:	611c                	ld	a5,0(a0)
    800007b8:	0017f713          	andi	a4,a5,1
    800007bc:	d36d                	beqz	a4,8000079e <uvmunmap+0x88>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007be:	3ff7f713          	andi	a4,a5,1023
    800007c2:	fb770de3          	beq	a4,s7,8000077c <uvmunmap+0x66>
    if(do_free){
    800007c6:	fc0b0ae3          	beqz	s6,8000079a <uvmunmap+0x84>
    800007ca:	b7c9                	j	8000078c <uvmunmap+0x76>

00000000800007cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007cc:	1101                	addi	sp,sp,-32
    800007ce:	ec06                	sd	ra,24(sp)
    800007d0:	e822                	sd	s0,16(sp)
    800007d2:	e426                	sd	s1,8(sp)
    800007d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	942080e7          	jalr	-1726(ra) # 80000118 <kalloc>
    800007de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e0:	c519                	beqz	a0,800007ee <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e2:	6605                	lui	a2,0x1
    800007e4:	4581                	li	a1,0
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	992080e7          	jalr	-1646(ra) # 80000178 <memset>
  return pagetable;
}
    800007ee:	8526                	mv	a0,s1
    800007f0:	60e2                	ld	ra,24(sp)
    800007f2:	6442                	ld	s0,16(sp)
    800007f4:	64a2                	ld	s1,8(sp)
    800007f6:	6105                	addi	sp,sp,32
    800007f8:	8082                	ret

00000000800007fa <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fa:	7179                	addi	sp,sp,-48
    800007fc:	f406                	sd	ra,40(sp)
    800007fe:	f022                	sd	s0,32(sp)
    80000800:	ec26                	sd	s1,24(sp)
    80000802:	e84a                	sd	s2,16(sp)
    80000804:	e44e                	sd	s3,8(sp)
    80000806:	e052                	sd	s4,0(sp)
    80000808:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080a:	6785                	lui	a5,0x1
    8000080c:	04f67863          	bgeu	a2,a5,8000085c <uvminit+0x62>
    80000810:	8a2a                	mv	s4,a0
    80000812:	89ae                	mv	s3,a1
    80000814:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	902080e7          	jalr	-1790(ra) # 80000118 <kalloc>
    8000081e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000820:	6605                	lui	a2,0x1
    80000822:	4581                	li	a1,0
    80000824:	00000097          	auipc	ra,0x0
    80000828:	954080e7          	jalr	-1708(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082c:	4779                	li	a4,30
    8000082e:	86ca                	mv	a3,s2
    80000830:	6605                	lui	a2,0x1
    80000832:	4581                	li	a1,0
    80000834:	8552                	mv	a0,s4
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	d1a080e7          	jalr	-742(ra) # 80000550 <mappages>
  memmove(mem, src, sz);
    8000083e:	8626                	mv	a2,s1
    80000840:	85ce                	mv	a1,s3
    80000842:	854a                	mv	a0,s2
    80000844:	00000097          	auipc	ra,0x0
    80000848:	994080e7          	jalr	-1644(ra) # 800001d8 <memmove>
}
    8000084c:	70a2                	ld	ra,40(sp)
    8000084e:	7402                	ld	s0,32(sp)
    80000850:	64e2                	ld	s1,24(sp)
    80000852:	6942                	ld	s2,16(sp)
    80000854:	69a2                	ld	s3,8(sp)
    80000856:	6a02                	ld	s4,0(sp)
    80000858:	6145                	addi	sp,sp,48
    8000085a:	8082                	ret
    panic("inituvm: more than a page");
    8000085c:	00008517          	auipc	a0,0x8
    80000860:	86450513          	addi	a0,a0,-1948 # 800080c0 <etext+0xc0>
    80000864:	00005097          	auipc	ra,0x5
    80000868:	7c2080e7          	jalr	1986(ra) # 80006026 <panic>

000000008000086c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086c:	1101                	addi	sp,sp,-32
    8000086e:	ec06                	sd	ra,24(sp)
    80000870:	e822                	sd	s0,16(sp)
    80000872:	e426                	sd	s1,8(sp)
    80000874:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000876:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000878:	00b67d63          	bgeu	a2,a1,80000892 <uvmdealloc+0x26>
    8000087c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087e:	6785                	lui	a5,0x1
    80000880:	17fd                	addi	a5,a5,-1
    80000882:	00f60733          	add	a4,a2,a5
    80000886:	767d                	lui	a2,0xfffff
    80000888:	8f71                	and	a4,a4,a2
    8000088a:	97ae                	add	a5,a5,a1
    8000088c:	8ff1                	and	a5,a5,a2
    8000088e:	00f76863          	bltu	a4,a5,8000089e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000892:	8526                	mv	a0,s1
    80000894:	60e2                	ld	ra,24(sp)
    80000896:	6442                	ld	s0,16(sp)
    80000898:	64a2                	ld	s1,8(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089e:	8f99                	sub	a5,a5,a4
    800008a0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a2:	4685                	li	a3,1
    800008a4:	0007861b          	sext.w	a2,a5
    800008a8:	85ba                	mv	a1,a4
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	e6c080e7          	jalr	-404(ra) # 80000716 <uvmunmap>
    800008b2:	b7c5                	j	80000892 <uvmdealloc+0x26>

00000000800008b4 <uvmalloc>:
  if(newsz < oldsz)
    800008b4:	0ab66163          	bltu	a2,a1,80000956 <uvmalloc+0xa2>
{
    800008b8:	7139                	addi	sp,sp,-64
    800008ba:	fc06                	sd	ra,56(sp)
    800008bc:	f822                	sd	s0,48(sp)
    800008be:	f426                	sd	s1,40(sp)
    800008c0:	f04a                	sd	s2,32(sp)
    800008c2:	ec4e                	sd	s3,24(sp)
    800008c4:	e852                	sd	s4,16(sp)
    800008c6:	e456                	sd	s5,8(sp)
    800008c8:	0080                	addi	s0,sp,64
    800008ca:	8aaa                	mv	s5,a0
    800008cc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008ce:	6985                	lui	s3,0x1
    800008d0:	19fd                	addi	s3,s3,-1
    800008d2:	95ce                	add	a1,a1,s3
    800008d4:	79fd                	lui	s3,0xfffff
    800008d6:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008da:	08c9f063          	bgeu	s3,a2,8000095a <uvmalloc+0xa6>
    800008de:	894e                	mv	s2,s3
    mem = kalloc();
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	838080e7          	jalr	-1992(ra) # 80000118 <kalloc>
    800008e8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008ea:	c51d                	beqz	a0,80000918 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ec:	6605                	lui	a2,0x1
    800008ee:	4581                	li	a1,0
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	888080e7          	jalr	-1912(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f8:	4779                	li	a4,30
    800008fa:	86a6                	mv	a3,s1
    800008fc:	6605                	lui	a2,0x1
    800008fe:	85ca                	mv	a1,s2
    80000900:	8556                	mv	a0,s5
    80000902:	00000097          	auipc	ra,0x0
    80000906:	c4e080e7          	jalr	-946(ra) # 80000550 <mappages>
    8000090a:	e905                	bnez	a0,8000093a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090c:	6785                	lui	a5,0x1
    8000090e:	993e                	add	s2,s2,a5
    80000910:	fd4968e3          	bltu	s2,s4,800008e0 <uvmalloc+0x2c>
  return newsz;
    80000914:	8552                	mv	a0,s4
    80000916:	a809                	j	80000928 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000918:	864e                	mv	a2,s3
    8000091a:	85ca                	mv	a1,s2
    8000091c:	8556                	mv	a0,s5
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	f4e080e7          	jalr	-178(ra) # 8000086c <uvmdealloc>
      return 0;
    80000926:	4501                	li	a0,0
}
    80000928:	70e2                	ld	ra,56(sp)
    8000092a:	7442                	ld	s0,48(sp)
    8000092c:	74a2                	ld	s1,40(sp)
    8000092e:	7902                	ld	s2,32(sp)
    80000930:	69e2                	ld	s3,24(sp)
    80000932:	6a42                	ld	s4,16(sp)
    80000934:	6aa2                	ld	s5,8(sp)
    80000936:	6121                	addi	sp,sp,64
    80000938:	8082                	ret
      kfree(mem);
    8000093a:	8526                	mv	a0,s1
    8000093c:	fffff097          	auipc	ra,0xfffff
    80000940:	6e0080e7          	jalr	1760(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f22080e7          	jalr	-222(ra) # 8000086c <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
    80000954:	bfd1                	j	80000928 <uvmalloc+0x74>
    return oldsz;
    80000956:	852e                	mv	a0,a1
}
    80000958:	8082                	ret
  return newsz;
    8000095a:	8532                	mv	a0,a2
    8000095c:	b7f1                	j	80000928 <uvmalloc+0x74>

000000008000095e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095e:	7179                	addi	sp,sp,-48
    80000960:	f406                	sd	ra,40(sp)
    80000962:	f022                	sd	s0,32(sp)
    80000964:	ec26                	sd	s1,24(sp)
    80000966:	e84a                	sd	s2,16(sp)
    80000968:	e44e                	sd	s3,8(sp)
    8000096a:	e052                	sd	s4,0(sp)
    8000096c:	1800                	addi	s0,sp,48
    8000096e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000970:	84aa                	mv	s1,a0
    80000972:	6905                	lui	s2,0x1
    80000974:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000976:	4985                	li	s3,1
    80000978:	a821                	j	80000990 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000097a:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000097c:	0532                	slli	a0,a0,0xc
    8000097e:	00000097          	auipc	ra,0x0
    80000982:	fe0080e7          	jalr	-32(ra) # 8000095e <freewalk>
      pagetable[i] = 0;
    80000986:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000098a:	04a1                	addi	s1,s1,8
    8000098c:	03248163          	beq	s1,s2,800009ae <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000990:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000992:	00f57793          	andi	a5,a0,15
    80000996:	ff3782e3          	beq	a5,s3,8000097a <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000099a:	8905                	andi	a0,a0,1
    8000099c:	d57d                	beqz	a0,8000098a <freewalk+0x2c>
      panic("freewalk: leaf");
    8000099e:	00007517          	auipc	a0,0x7
    800009a2:	74250513          	addi	a0,a0,1858 # 800080e0 <etext+0xe0>
    800009a6:	00005097          	auipc	ra,0x5
    800009aa:	680080e7          	jalr	1664(ra) # 80006026 <panic>
    }
  }
  kfree((void*)pagetable);
    800009ae:	8552                	mv	a0,s4
    800009b0:	fffff097          	auipc	ra,0xfffff
    800009b4:	66c080e7          	jalr	1644(ra) # 8000001c <kfree>
}
    800009b8:	70a2                	ld	ra,40(sp)
    800009ba:	7402                	ld	s0,32(sp)
    800009bc:	64e2                	ld	s1,24(sp)
    800009be:	6942                	ld	s2,16(sp)
    800009c0:	69a2                	ld	s3,8(sp)
    800009c2:	6a02                	ld	s4,0(sp)
    800009c4:	6145                	addi	sp,sp,48
    800009c6:	8082                	ret

00000000800009c8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009c8:	1101                	addi	sp,sp,-32
    800009ca:	ec06                	sd	ra,24(sp)
    800009cc:	e822                	sd	s0,16(sp)
    800009ce:	e426                	sd	s1,8(sp)
    800009d0:	1000                	addi	s0,sp,32
    800009d2:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d4:	e999                	bnez	a1,800009ea <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d6:	8526                	mv	a0,s1
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	f86080e7          	jalr	-122(ra) # 8000095e <freewalk>
}
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009ea:	6605                	lui	a2,0x1
    800009ec:	167d                	addi	a2,a2,-1
    800009ee:	962e                	add	a2,a2,a1
    800009f0:	4685                	li	a3,1
    800009f2:	8231                	srli	a2,a2,0xc
    800009f4:	4581                	li	a1,0
    800009f6:	00000097          	auipc	ra,0x0
    800009fa:	d20080e7          	jalr	-736(ra) # 80000716 <uvmunmap>
    800009fe:	bfe1                	j	800009d6 <uvmfree+0xe>

0000000080000a00 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a00:	c269                	beqz	a2,80000ac2 <uvmcopy+0xc2>
{
    80000a02:	715d                	addi	sp,sp,-80
    80000a04:	e486                	sd	ra,72(sp)
    80000a06:	e0a2                	sd	s0,64(sp)
    80000a08:	fc26                	sd	s1,56(sp)
    80000a0a:	f84a                	sd	s2,48(sp)
    80000a0c:	f44e                	sd	s3,40(sp)
    80000a0e:	f052                	sd	s4,32(sp)
    80000a10:	ec56                	sd	s5,24(sp)
    80000a12:	e85a                	sd	s6,16(sp)
    80000a14:	e45e                	sd	s7,8(sp)
    80000a16:	0880                	addi	s0,sp,80
    80000a18:	8aaa                	mv	s5,a0
    80000a1a:	8b2e                	mv	s6,a1
    80000a1c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a1e:	4481                	li	s1,0
    80000a20:	a829                	j	80000a3a <uvmcopy+0x3a>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000a22:	00007517          	auipc	a0,0x7
    80000a26:	6ce50513          	addi	a0,a0,1742 # 800080f0 <etext+0xf0>
    80000a2a:	00005097          	auipc	ra,0x5
    80000a2e:	5fc080e7          	jalr	1532(ra) # 80006026 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    80000a32:	6785                	lui	a5,0x1
    80000a34:	94be                	add	s1,s1,a5
    80000a36:	0944f463          	bgeu	s1,s4,80000abe <uvmcopy+0xbe>
    if((pte = walk(old, i, 0)) == 0)
    80000a3a:	4601                	li	a2,0
    80000a3c:	85a6                	mv	a1,s1
    80000a3e:	8556                	mv	a0,s5
    80000a40:	00000097          	auipc	ra,0x0
    80000a44:	a28080e7          	jalr	-1496(ra) # 80000468 <walk>
    80000a48:	dd69                	beqz	a0,80000a22 <uvmcopy+0x22>
    if((*pte & PTE_V) == 0)
    80000a4a:	6118                	ld	a4,0(a0)
    80000a4c:	00177793          	andi	a5,a4,1
    80000a50:	d3ed                	beqz	a5,80000a32 <uvmcopy+0x32>
      continue; 	    
     // panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a52:	00a75593          	srli	a1,a4,0xa
    80000a56:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a5a:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80000a5e:	fffff097          	auipc	ra,0xfffff
    80000a62:	6ba080e7          	jalr	1722(ra) # 80000118 <kalloc>
    80000a66:	89aa                	mv	s3,a0
    80000a68:	c515                	beqz	a0,80000a94 <uvmcopy+0x94>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	85de                	mv	a1,s7
    80000a6e:	fffff097          	auipc	ra,0xfffff
    80000a72:	76a080e7          	jalr	1898(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a76:	874a                	mv	a4,s2
    80000a78:	86ce                	mv	a3,s3
    80000a7a:	6605                	lui	a2,0x1
    80000a7c:	85a6                	mv	a1,s1
    80000a7e:	855a                	mv	a0,s6
    80000a80:	00000097          	auipc	ra,0x0
    80000a84:	ad0080e7          	jalr	-1328(ra) # 80000550 <mappages>
    80000a88:	d54d                	beqz	a0,80000a32 <uvmcopy+0x32>
      kfree(mem);
    80000a8a:	854e                	mv	a0,s3
    80000a8c:	fffff097          	auipc	ra,0xfffff
    80000a90:	590080e7          	jalr	1424(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a94:	4685                	li	a3,1
    80000a96:	00c4d613          	srli	a2,s1,0xc
    80000a9a:	4581                	li	a1,0
    80000a9c:	855a                	mv	a0,s6
    80000a9e:	00000097          	auipc	ra,0x0
    80000aa2:	c78080e7          	jalr	-904(ra) # 80000716 <uvmunmap>
  return -1;
    80000aa6:	557d                	li	a0,-1
}
    80000aa8:	60a6                	ld	ra,72(sp)
    80000aaa:	6406                	ld	s0,64(sp)
    80000aac:	74e2                	ld	s1,56(sp)
    80000aae:	7942                	ld	s2,48(sp)
    80000ab0:	79a2                	ld	s3,40(sp)
    80000ab2:	7a02                	ld	s4,32(sp)
    80000ab4:	6ae2                	ld	s5,24(sp)
    80000ab6:	6b42                	ld	s6,16(sp)
    80000ab8:	6ba2                	ld	s7,8(sp)
    80000aba:	6161                	addi	sp,sp,80
    80000abc:	8082                	ret
  return 0;
    80000abe:	4501                	li	a0,0
    80000ac0:	b7e5                	j	80000aa8 <uvmcopy+0xa8>
    80000ac2:	4501                	li	a0,0
}
    80000ac4:	8082                	ret

0000000080000ac6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ac6:	1141                	addi	sp,sp,-16
    80000ac8:	e406                	sd	ra,8(sp)
    80000aca:	e022                	sd	s0,0(sp)
    80000acc:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ace:	4601                	li	a2,0
    80000ad0:	00000097          	auipc	ra,0x0
    80000ad4:	998080e7          	jalr	-1640(ra) # 80000468 <walk>
  if(pte == 0)
    80000ad8:	c901                	beqz	a0,80000ae8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ada:	611c                	ld	a5,0(a0)
    80000adc:	9bbd                	andi	a5,a5,-17
    80000ade:	e11c                	sd	a5,0(a0)
}
    80000ae0:	60a2                	ld	ra,8(sp)
    80000ae2:	6402                	ld	s0,0(sp)
    80000ae4:	0141                	addi	sp,sp,16
    80000ae6:	8082                	ret
    panic("uvmclear");
    80000ae8:	00007517          	auipc	a0,0x7
    80000aec:	62850513          	addi	a0,a0,1576 # 80008110 <etext+0x110>
    80000af0:	00005097          	auipc	ra,0x5
    80000af4:	536080e7          	jalr	1334(ra) # 80006026 <panic>

0000000080000af8 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000af8:	c6bd                	beqz	a3,80000b66 <copyout+0x6e>
{
    80000afa:	715d                	addi	sp,sp,-80
    80000afc:	e486                	sd	ra,72(sp)
    80000afe:	e0a2                	sd	s0,64(sp)
    80000b00:	fc26                	sd	s1,56(sp)
    80000b02:	f84a                	sd	s2,48(sp)
    80000b04:	f44e                	sd	s3,40(sp)
    80000b06:	f052                	sd	s4,32(sp)
    80000b08:	ec56                	sd	s5,24(sp)
    80000b0a:	e85a                	sd	s6,16(sp)
    80000b0c:	e45e                	sd	s7,8(sp)
    80000b0e:	e062                	sd	s8,0(sp)
    80000b10:	0880                	addi	s0,sp,80
    80000b12:	8b2a                	mv	s6,a0
    80000b14:	8c2e                	mv	s8,a1
    80000b16:	8a32                	mv	s4,a2
    80000b18:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b1a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b1c:	6a85                	lui	s5,0x1
    80000b1e:	a015                	j	80000b42 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b20:	9562                	add	a0,a0,s8
    80000b22:	0004861b          	sext.w	a2,s1
    80000b26:	85d2                	mv	a1,s4
    80000b28:	41250533          	sub	a0,a0,s2
    80000b2c:	fffff097          	auipc	ra,0xfffff
    80000b30:	6ac080e7          	jalr	1708(ra) # 800001d8 <memmove>

    len -= n;
    80000b34:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b38:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b3a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b3e:	02098263          	beqz	s3,80000b62 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b42:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b46:	85ca                	mv	a1,s2
    80000b48:	855a                	mv	a0,s6
    80000b4a:	00000097          	auipc	ra,0x0
    80000b4e:	9c4080e7          	jalr	-1596(ra) # 8000050e <walkaddr>
    if(pa0 == 0)
    80000b52:	cd01                	beqz	a0,80000b6a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b54:	418904b3          	sub	s1,s2,s8
    80000b58:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b5a:	fc99f3e3          	bgeu	s3,s1,80000b20 <copyout+0x28>
    80000b5e:	84ce                	mv	s1,s3
    80000b60:	b7c1                	j	80000b20 <copyout+0x28>
  }
  return 0;
    80000b62:	4501                	li	a0,0
    80000b64:	a021                	j	80000b6c <copyout+0x74>
    80000b66:	4501                	li	a0,0
}
    80000b68:	8082                	ret
      return -1;
    80000b6a:	557d                	li	a0,-1
}
    80000b6c:	60a6                	ld	ra,72(sp)
    80000b6e:	6406                	ld	s0,64(sp)
    80000b70:	74e2                	ld	s1,56(sp)
    80000b72:	7942                	ld	s2,48(sp)
    80000b74:	79a2                	ld	s3,40(sp)
    80000b76:	7a02                	ld	s4,32(sp)
    80000b78:	6ae2                	ld	s5,24(sp)
    80000b7a:	6b42                	ld	s6,16(sp)
    80000b7c:	6ba2                	ld	s7,8(sp)
    80000b7e:	6c02                	ld	s8,0(sp)
    80000b80:	6161                	addi	sp,sp,80
    80000b82:	8082                	ret

0000000080000b84 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b84:	c6bd                	beqz	a3,80000bf2 <copyin+0x6e>
{
    80000b86:	715d                	addi	sp,sp,-80
    80000b88:	e486                	sd	ra,72(sp)
    80000b8a:	e0a2                	sd	s0,64(sp)
    80000b8c:	fc26                	sd	s1,56(sp)
    80000b8e:	f84a                	sd	s2,48(sp)
    80000b90:	f44e                	sd	s3,40(sp)
    80000b92:	f052                	sd	s4,32(sp)
    80000b94:	ec56                	sd	s5,24(sp)
    80000b96:	e85a                	sd	s6,16(sp)
    80000b98:	e45e                	sd	s7,8(sp)
    80000b9a:	e062                	sd	s8,0(sp)
    80000b9c:	0880                	addi	s0,sp,80
    80000b9e:	8b2a                	mv	s6,a0
    80000ba0:	8a2e                	mv	s4,a1
    80000ba2:	8c32                	mv	s8,a2
    80000ba4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ba6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ba8:	6a85                	lui	s5,0x1
    80000baa:	a015                	j	80000bce <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bac:	9562                	add	a0,a0,s8
    80000bae:	0004861b          	sext.w	a2,s1
    80000bb2:	412505b3          	sub	a1,a0,s2
    80000bb6:	8552                	mv	a0,s4
    80000bb8:	fffff097          	auipc	ra,0xfffff
    80000bbc:	620080e7          	jalr	1568(ra) # 800001d8 <memmove>

    len -= n;
    80000bc0:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bc4:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bc6:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bca:	02098263          	beqz	s3,80000bee <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bce:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bd2:	85ca                	mv	a1,s2
    80000bd4:	855a                	mv	a0,s6
    80000bd6:	00000097          	auipc	ra,0x0
    80000bda:	938080e7          	jalr	-1736(ra) # 8000050e <walkaddr>
    if(pa0 == 0)
    80000bde:	cd01                	beqz	a0,80000bf6 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000be0:	418904b3          	sub	s1,s2,s8
    80000be4:	94d6                	add	s1,s1,s5
    if(n > len)
    80000be6:	fc99f3e3          	bgeu	s3,s1,80000bac <copyin+0x28>
    80000bea:	84ce                	mv	s1,s3
    80000bec:	b7c1                	j	80000bac <copyin+0x28>
  }
  return 0;
    80000bee:	4501                	li	a0,0
    80000bf0:	a021                	j	80000bf8 <copyin+0x74>
    80000bf2:	4501                	li	a0,0
}
    80000bf4:	8082                	ret
      return -1;
    80000bf6:	557d                	li	a0,-1
}
    80000bf8:	60a6                	ld	ra,72(sp)
    80000bfa:	6406                	ld	s0,64(sp)
    80000bfc:	74e2                	ld	s1,56(sp)
    80000bfe:	7942                	ld	s2,48(sp)
    80000c00:	79a2                	ld	s3,40(sp)
    80000c02:	7a02                	ld	s4,32(sp)
    80000c04:	6ae2                	ld	s5,24(sp)
    80000c06:	6b42                	ld	s6,16(sp)
    80000c08:	6ba2                	ld	s7,8(sp)
    80000c0a:	6c02                	ld	s8,0(sp)
    80000c0c:	6161                	addi	sp,sp,80
    80000c0e:	8082                	ret

0000000080000c10 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c10:	c6c5                	beqz	a3,80000cb8 <copyinstr+0xa8>
{
    80000c12:	715d                	addi	sp,sp,-80
    80000c14:	e486                	sd	ra,72(sp)
    80000c16:	e0a2                	sd	s0,64(sp)
    80000c18:	fc26                	sd	s1,56(sp)
    80000c1a:	f84a                	sd	s2,48(sp)
    80000c1c:	f44e                	sd	s3,40(sp)
    80000c1e:	f052                	sd	s4,32(sp)
    80000c20:	ec56                	sd	s5,24(sp)
    80000c22:	e85a                	sd	s6,16(sp)
    80000c24:	e45e                	sd	s7,8(sp)
    80000c26:	0880                	addi	s0,sp,80
    80000c28:	8a2a                	mv	s4,a0
    80000c2a:	8b2e                	mv	s6,a1
    80000c2c:	8bb2                	mv	s7,a2
    80000c2e:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c30:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c32:	6985                	lui	s3,0x1
    80000c34:	a035                	j	80000c60 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c36:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c3a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c3c:	0017b793          	seqz	a5,a5
    80000c40:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c44:	60a6                	ld	ra,72(sp)
    80000c46:	6406                	ld	s0,64(sp)
    80000c48:	74e2                	ld	s1,56(sp)
    80000c4a:	7942                	ld	s2,48(sp)
    80000c4c:	79a2                	ld	s3,40(sp)
    80000c4e:	7a02                	ld	s4,32(sp)
    80000c50:	6ae2                	ld	s5,24(sp)
    80000c52:	6b42                	ld	s6,16(sp)
    80000c54:	6ba2                	ld	s7,8(sp)
    80000c56:	6161                	addi	sp,sp,80
    80000c58:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c5a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c5e:	c8a9                	beqz	s1,80000cb0 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c60:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c64:	85ca                	mv	a1,s2
    80000c66:	8552                	mv	a0,s4
    80000c68:	00000097          	auipc	ra,0x0
    80000c6c:	8a6080e7          	jalr	-1882(ra) # 8000050e <walkaddr>
    if(pa0 == 0)
    80000c70:	c131                	beqz	a0,80000cb4 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c72:	41790833          	sub	a6,s2,s7
    80000c76:	984e                	add	a6,a6,s3
    if(n > max)
    80000c78:	0104f363          	bgeu	s1,a6,80000c7e <copyinstr+0x6e>
    80000c7c:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c7e:	955e                	add	a0,a0,s7
    80000c80:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c84:	fc080be3          	beqz	a6,80000c5a <copyinstr+0x4a>
    80000c88:	985a                	add	a6,a6,s6
    80000c8a:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c8c:	41650633          	sub	a2,a0,s6
    80000c90:	14fd                	addi	s1,s1,-1
    80000c92:	9b26                	add	s6,s6,s1
    80000c94:	00f60733          	add	a4,a2,a5
    80000c98:	00074703          	lbu	a4,0(a4)
    80000c9c:	df49                	beqz	a4,80000c36 <copyinstr+0x26>
        *dst = *p;
    80000c9e:	00e78023          	sb	a4,0(a5)
      --max;
    80000ca2:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000ca6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000ca8:	ff0796e3          	bne	a5,a6,80000c94 <copyinstr+0x84>
      dst++;
    80000cac:	8b42                	mv	s6,a6
    80000cae:	b775                	j	80000c5a <copyinstr+0x4a>
    80000cb0:	4781                	li	a5,0
    80000cb2:	b769                	j	80000c3c <copyinstr+0x2c>
      return -1;
    80000cb4:	557d                	li	a0,-1
    80000cb6:	b779                	j	80000c44 <copyinstr+0x34>
  int got_null = 0;
    80000cb8:	4781                	li	a5,0
  if(got_null){
    80000cba:	0017b793          	seqz	a5,a5
    80000cbe:	40f00533          	neg	a0,a5
}
    80000cc2:	8082                	ret

0000000080000cc4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cc4:	7139                	addi	sp,sp,-64
    80000cc6:	fc06                	sd	ra,56(sp)
    80000cc8:	f822                	sd	s0,48(sp)
    80000cca:	f426                	sd	s1,40(sp)
    80000ccc:	f04a                	sd	s2,32(sp)
    80000cce:	ec4e                	sd	s3,24(sp)
    80000cd0:	e852                	sd	s4,16(sp)
    80000cd2:	e456                	sd	s5,8(sp)
    80000cd4:	e05a                	sd	s6,0(sp)
    80000cd6:	0080                	addi	s0,sp,64
    80000cd8:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cda:	00008497          	auipc	s1,0x8
    80000cde:	7a648493          	addi	s1,s1,1958 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ce2:	8b26                	mv	s6,s1
    80000ce4:	00007a97          	auipc	s5,0x7
    80000ce8:	31ca8a93          	addi	s5,s5,796 # 80008000 <etext>
    80000cec:	04000937          	lui	s2,0x4000
    80000cf0:	197d                	addi	s2,s2,-1
    80000cf2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf4:	00010a17          	auipc	s4,0x10
    80000cf8:	18ca0a13          	addi	s4,s4,396 # 80010e80 <tickslock>
    char *pa = kalloc();
    80000cfc:	fffff097          	auipc	ra,0xfffff
    80000d00:	41c080e7          	jalr	1052(ra) # 80000118 <kalloc>
    80000d04:	862a                	mv	a2,a0
    if(pa == 0)
    80000d06:	c131                	beqz	a0,80000d4a <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d08:	416485b3          	sub	a1,s1,s6
    80000d0c:	858d                	srai	a1,a1,0x3
    80000d0e:	000ab783          	ld	a5,0(s5)
    80000d12:	02f585b3          	mul	a1,a1,a5
    80000d16:	2585                	addiw	a1,a1,1
    80000d18:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d1c:	4719                	li	a4,6
    80000d1e:	6685                	lui	a3,0x1
    80000d20:	40b905b3          	sub	a1,s2,a1
    80000d24:	854e                	mv	a0,s3
    80000d26:	00000097          	auipc	ra,0x0
    80000d2a:	8ca080e7          	jalr	-1846(ra) # 800005f0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d2e:	1e848493          	addi	s1,s1,488
    80000d32:	fd4495e3          	bne	s1,s4,80000cfc <proc_mapstacks+0x38>
  }
}
    80000d36:	70e2                	ld	ra,56(sp)
    80000d38:	7442                	ld	s0,48(sp)
    80000d3a:	74a2                	ld	s1,40(sp)
    80000d3c:	7902                	ld	s2,32(sp)
    80000d3e:	69e2                	ld	s3,24(sp)
    80000d40:	6a42                	ld	s4,16(sp)
    80000d42:	6aa2                	ld	s5,8(sp)
    80000d44:	6b02                	ld	s6,0(sp)
    80000d46:	6121                	addi	sp,sp,64
    80000d48:	8082                	ret
      panic("kalloc");
    80000d4a:	00007517          	auipc	a0,0x7
    80000d4e:	3d650513          	addi	a0,a0,982 # 80008120 <etext+0x120>
    80000d52:	00005097          	auipc	ra,0x5
    80000d56:	2d4080e7          	jalr	724(ra) # 80006026 <panic>

0000000080000d5a <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d5a:	7139                	addi	sp,sp,-64
    80000d5c:	fc06                	sd	ra,56(sp)
    80000d5e:	f822                	sd	s0,48(sp)
    80000d60:	f426                	sd	s1,40(sp)
    80000d62:	f04a                	sd	s2,32(sp)
    80000d64:	ec4e                	sd	s3,24(sp)
    80000d66:	e852                	sd	s4,16(sp)
    80000d68:	e456                	sd	s5,8(sp)
    80000d6a:	e05a                	sd	s6,0(sp)
    80000d6c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d6e:	00007597          	auipc	a1,0x7
    80000d72:	3ba58593          	addi	a1,a1,954 # 80008128 <etext+0x128>
    80000d76:	00008517          	auipc	a0,0x8
    80000d7a:	2da50513          	addi	a0,a0,730 # 80009050 <pid_lock>
    80000d7e:	00005097          	auipc	ra,0x5
    80000d82:	762080e7          	jalr	1890(ra) # 800064e0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d86:	00007597          	auipc	a1,0x7
    80000d8a:	3aa58593          	addi	a1,a1,938 # 80008130 <etext+0x130>
    80000d8e:	00008517          	auipc	a0,0x8
    80000d92:	2da50513          	addi	a0,a0,730 # 80009068 <wait_lock>
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	74a080e7          	jalr	1866(ra) # 800064e0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d9e:	00008497          	auipc	s1,0x8
    80000da2:	6e248493          	addi	s1,s1,1762 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000da6:	00007b17          	auipc	s6,0x7
    80000daa:	39ab0b13          	addi	s6,s6,922 # 80008140 <etext+0x140>
      p->kstack = KSTACK((int) (p - proc));
    80000dae:	8aa6                	mv	s5,s1
    80000db0:	00007a17          	auipc	s4,0x7
    80000db4:	250a0a13          	addi	s4,s4,592 # 80008000 <etext>
    80000db8:	04000937          	lui	s2,0x4000
    80000dbc:	197d                	addi	s2,s2,-1
    80000dbe:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dc0:	00010997          	auipc	s3,0x10
    80000dc4:	0c098993          	addi	s3,s3,192 # 80010e80 <tickslock>
      initlock(&p->lock, "proc");
    80000dc8:	85da                	mv	a1,s6
    80000dca:	8526                	mv	a0,s1
    80000dcc:	00005097          	auipc	ra,0x5
    80000dd0:	714080e7          	jalr	1812(ra) # 800064e0 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000dd4:	415487b3          	sub	a5,s1,s5
    80000dd8:	878d                	srai	a5,a5,0x3
    80000dda:	000a3703          	ld	a4,0(s4)
    80000dde:	02e787b3          	mul	a5,a5,a4
    80000de2:	2785                	addiw	a5,a5,1
    80000de4:	00d7979b          	slliw	a5,a5,0xd
    80000de8:	40f907b3          	sub	a5,s2,a5
    80000dec:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dee:	1e848493          	addi	s1,s1,488
    80000df2:	fd349be3          	bne	s1,s3,80000dc8 <procinit+0x6e>
  }
}
    80000df6:	70e2                	ld	ra,56(sp)
    80000df8:	7442                	ld	s0,48(sp)
    80000dfa:	74a2                	ld	s1,40(sp)
    80000dfc:	7902                	ld	s2,32(sp)
    80000dfe:	69e2                	ld	s3,24(sp)
    80000e00:	6a42                	ld	s4,16(sp)
    80000e02:	6aa2                	ld	s5,8(sp)
    80000e04:	6b02                	ld	s6,0(sp)
    80000e06:	6121                	addi	sp,sp,64
    80000e08:	8082                	ret

0000000080000e0a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e0a:	1141                	addi	sp,sp,-16
    80000e0c:	e422                	sd	s0,8(sp)
    80000e0e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e10:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e12:	2501                	sext.w	a0,a0
    80000e14:	6422                	ld	s0,8(sp)
    80000e16:	0141                	addi	sp,sp,16
    80000e18:	8082                	ret

0000000080000e1a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e1a:	1141                	addi	sp,sp,-16
    80000e1c:	e422                	sd	s0,8(sp)
    80000e1e:	0800                	addi	s0,sp,16
    80000e20:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e22:	2781                	sext.w	a5,a5
    80000e24:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e26:	00008517          	auipc	a0,0x8
    80000e2a:	25a50513          	addi	a0,a0,602 # 80009080 <cpus>
    80000e2e:	953e                	add	a0,a0,a5
    80000e30:	6422                	ld	s0,8(sp)
    80000e32:	0141                	addi	sp,sp,16
    80000e34:	8082                	ret

0000000080000e36 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e36:	1101                	addi	sp,sp,-32
    80000e38:	ec06                	sd	ra,24(sp)
    80000e3a:	e822                	sd	s0,16(sp)
    80000e3c:	e426                	sd	s1,8(sp)
    80000e3e:	1000                	addi	s0,sp,32
  push_off();
    80000e40:	00005097          	auipc	ra,0x5
    80000e44:	6e4080e7          	jalr	1764(ra) # 80006524 <push_off>
    80000e48:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e4a:	2781                	sext.w	a5,a5
    80000e4c:	079e                	slli	a5,a5,0x7
    80000e4e:	00008717          	auipc	a4,0x8
    80000e52:	20270713          	addi	a4,a4,514 # 80009050 <pid_lock>
    80000e56:	97ba                	add	a5,a5,a4
    80000e58:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e5a:	00005097          	auipc	ra,0x5
    80000e5e:	76a080e7          	jalr	1898(ra) # 800065c4 <pop_off>
  return p;
}
    80000e62:	8526                	mv	a0,s1
    80000e64:	60e2                	ld	ra,24(sp)
    80000e66:	6442                	ld	s0,16(sp)
    80000e68:	64a2                	ld	s1,8(sp)
    80000e6a:	6105                	addi	sp,sp,32
    80000e6c:	8082                	ret

0000000080000e6e <lazy_grow_proc>:
{
    80000e6e:	1101                	addi	sp,sp,-32
    80000e70:	ec06                	sd	ra,24(sp)
    80000e72:	e822                	sd	s0,16(sp)
    80000e74:	e426                	sd	s1,8(sp)
    80000e76:	1000                	addi	s0,sp,32
    80000e78:	84aa                	mv	s1,a0
	struct proc* p=myproc();
    80000e7a:	00000097          	auipc	ra,0x0
    80000e7e:	fbc080e7          	jalr	-68(ra) # 80000e36 <myproc>
	p->sz = p->sz+n;
    80000e82:	653c                	ld	a5,72(a0)
    80000e84:	97a6                	add	a5,a5,s1
    80000e86:	e53c                	sd	a5,72(a0)
}
    80000e88:	4501                	li	a0,0
    80000e8a:	60e2                	ld	ra,24(sp)
    80000e8c:	6442                	ld	s0,16(sp)
    80000e8e:	64a2                	ld	s1,8(sp)
    80000e90:	6105                	addi	sp,sp,32
    80000e92:	8082                	ret

0000000080000e94 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e94:	1141                	addi	sp,sp,-16
    80000e96:	e406                	sd	ra,8(sp)
    80000e98:	e022                	sd	s0,0(sp)
    80000e9a:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e9c:	00000097          	auipc	ra,0x0
    80000ea0:	f9a080e7          	jalr	-102(ra) # 80000e36 <myproc>
    80000ea4:	00005097          	auipc	ra,0x5
    80000ea8:	780080e7          	jalr	1920(ra) # 80006624 <release>

  if (first) {
    80000eac:	00008797          	auipc	a5,0x8
    80000eb0:	9047a783          	lw	a5,-1788(a5) # 800087b0 <first.1755>
    80000eb4:	eb89                	bnez	a5,80000ec6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eb6:	00001097          	auipc	ra,0x1
    80000eba:	d0c080e7          	jalr	-756(ra) # 80001bc2 <usertrapret>
}
    80000ebe:	60a2                	ld	ra,8(sp)
    80000ec0:	6402                	ld	s0,0(sp)
    80000ec2:	0141                	addi	sp,sp,16
    80000ec4:	8082                	ret
    first = 0;
    80000ec6:	00008797          	auipc	a5,0x8
    80000eca:	8e07a523          	sw	zero,-1814(a5) # 800087b0 <first.1755>
    fsinit(ROOTDEV);
    80000ece:	4505                	li	a0,1
    80000ed0:	00002097          	auipc	ra,0x2
    80000ed4:	aee080e7          	jalr	-1298(ra) # 800029be <fsinit>
    80000ed8:	bff9                	j	80000eb6 <forkret+0x22>

0000000080000eda <allocpid>:
allocpid() {
    80000eda:	1101                	addi	sp,sp,-32
    80000edc:	ec06                	sd	ra,24(sp)
    80000ede:	e822                	sd	s0,16(sp)
    80000ee0:	e426                	sd	s1,8(sp)
    80000ee2:	e04a                	sd	s2,0(sp)
    80000ee4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ee6:	00008917          	auipc	s2,0x8
    80000eea:	16a90913          	addi	s2,s2,362 # 80009050 <pid_lock>
    80000eee:	854a                	mv	a0,s2
    80000ef0:	00005097          	auipc	ra,0x5
    80000ef4:	680080e7          	jalr	1664(ra) # 80006570 <acquire>
  pid = nextpid;
    80000ef8:	00008797          	auipc	a5,0x8
    80000efc:	8bc78793          	addi	a5,a5,-1860 # 800087b4 <nextpid>
    80000f00:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f02:	0014871b          	addiw	a4,s1,1
    80000f06:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f08:	854a                	mv	a0,s2
    80000f0a:	00005097          	auipc	ra,0x5
    80000f0e:	71a080e7          	jalr	1818(ra) # 80006624 <release>
}
    80000f12:	8526                	mv	a0,s1
    80000f14:	60e2                	ld	ra,24(sp)
    80000f16:	6442                	ld	s0,16(sp)
    80000f18:	64a2                	ld	s1,8(sp)
    80000f1a:	6902                	ld	s2,0(sp)
    80000f1c:	6105                	addi	sp,sp,32
    80000f1e:	8082                	ret

0000000080000f20 <proc_pagetable>:
{
    80000f20:	1101                	addi	sp,sp,-32
    80000f22:	ec06                	sd	ra,24(sp)
    80000f24:	e822                	sd	s0,16(sp)
    80000f26:	e426                	sd	s1,8(sp)
    80000f28:	e04a                	sd	s2,0(sp)
    80000f2a:	1000                	addi	s0,sp,32
    80000f2c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f2e:	00000097          	auipc	ra,0x0
    80000f32:	89e080e7          	jalr	-1890(ra) # 800007cc <uvmcreate>
    80000f36:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f38:	c121                	beqz	a0,80000f78 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f3a:	4729                	li	a4,10
    80000f3c:	00006697          	auipc	a3,0x6
    80000f40:	0c468693          	addi	a3,a3,196 # 80007000 <_trampoline>
    80000f44:	6605                	lui	a2,0x1
    80000f46:	040005b7          	lui	a1,0x4000
    80000f4a:	15fd                	addi	a1,a1,-1
    80000f4c:	05b2                	slli	a1,a1,0xc
    80000f4e:	fffff097          	auipc	ra,0xfffff
    80000f52:	602080e7          	jalr	1538(ra) # 80000550 <mappages>
    80000f56:	02054863          	bltz	a0,80000f86 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f5a:	4719                	li	a4,6
    80000f5c:	05893683          	ld	a3,88(s2)
    80000f60:	6605                	lui	a2,0x1
    80000f62:	020005b7          	lui	a1,0x2000
    80000f66:	15fd                	addi	a1,a1,-1
    80000f68:	05b6                	slli	a1,a1,0xd
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	fffff097          	auipc	ra,0xfffff
    80000f70:	5e4080e7          	jalr	1508(ra) # 80000550 <mappages>
    80000f74:	02054163          	bltz	a0,80000f96 <proc_pagetable+0x76>
}
    80000f78:	8526                	mv	a0,s1
    80000f7a:	60e2                	ld	ra,24(sp)
    80000f7c:	6442                	ld	s0,16(sp)
    80000f7e:	64a2                	ld	s1,8(sp)
    80000f80:	6902                	ld	s2,0(sp)
    80000f82:	6105                	addi	sp,sp,32
    80000f84:	8082                	ret
    uvmfree(pagetable, 0);
    80000f86:	4581                	li	a1,0
    80000f88:	8526                	mv	a0,s1
    80000f8a:	00000097          	auipc	ra,0x0
    80000f8e:	a3e080e7          	jalr	-1474(ra) # 800009c8 <uvmfree>
    return 0;
    80000f92:	4481                	li	s1,0
    80000f94:	b7d5                	j	80000f78 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f96:	4681                	li	a3,0
    80000f98:	4605                	li	a2,1
    80000f9a:	040005b7          	lui	a1,0x4000
    80000f9e:	15fd                	addi	a1,a1,-1
    80000fa0:	05b2                	slli	a1,a1,0xc
    80000fa2:	8526                	mv	a0,s1
    80000fa4:	fffff097          	auipc	ra,0xfffff
    80000fa8:	772080e7          	jalr	1906(ra) # 80000716 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fac:	4581                	li	a1,0
    80000fae:	8526                	mv	a0,s1
    80000fb0:	00000097          	auipc	ra,0x0
    80000fb4:	a18080e7          	jalr	-1512(ra) # 800009c8 <uvmfree>
    return 0;
    80000fb8:	4481                	li	s1,0
    80000fba:	bf7d                	j	80000f78 <proc_pagetable+0x58>

0000000080000fbc <proc_freepagetable>:
{
    80000fbc:	1101                	addi	sp,sp,-32
    80000fbe:	ec06                	sd	ra,24(sp)
    80000fc0:	e822                	sd	s0,16(sp)
    80000fc2:	e426                	sd	s1,8(sp)
    80000fc4:	e04a                	sd	s2,0(sp)
    80000fc6:	1000                	addi	s0,sp,32
    80000fc8:	84aa                	mv	s1,a0
    80000fca:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	040005b7          	lui	a1,0x4000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b2                	slli	a1,a1,0xc
    80000fd8:	fffff097          	auipc	ra,0xfffff
    80000fdc:	73e080e7          	jalr	1854(ra) # 80000716 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fe0:	4681                	li	a3,0
    80000fe2:	4605                	li	a2,1
    80000fe4:	020005b7          	lui	a1,0x2000
    80000fe8:	15fd                	addi	a1,a1,-1
    80000fea:	05b6                	slli	a1,a1,0xd
    80000fec:	8526                	mv	a0,s1
    80000fee:	fffff097          	auipc	ra,0xfffff
    80000ff2:	728080e7          	jalr	1832(ra) # 80000716 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ff6:	85ca                	mv	a1,s2
    80000ff8:	8526                	mv	a0,s1
    80000ffa:	00000097          	auipc	ra,0x0
    80000ffe:	9ce080e7          	jalr	-1586(ra) # 800009c8 <uvmfree>
}
    80001002:	60e2                	ld	ra,24(sp)
    80001004:	6442                	ld	s0,16(sp)
    80001006:	64a2                	ld	s1,8(sp)
    80001008:	6902                	ld	s2,0(sp)
    8000100a:	6105                	addi	sp,sp,32
    8000100c:	8082                	ret

000000008000100e <freeproc>:
{
    8000100e:	1101                	addi	sp,sp,-32
    80001010:	ec06                	sd	ra,24(sp)
    80001012:	e822                	sd	s0,16(sp)
    80001014:	e426                	sd	s1,8(sp)
    80001016:	1000                	addi	s0,sp,32
    80001018:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000101a:	6d28                	ld	a0,88(a0)
    8000101c:	c509                	beqz	a0,80001026 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000101e:	fffff097          	auipc	ra,0xfffff
    80001022:	ffe080e7          	jalr	-2(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001026:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000102a:	68a8                	ld	a0,80(s1)
    8000102c:	c511                	beqz	a0,80001038 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000102e:	64ac                	ld	a1,72(s1)
    80001030:	00000097          	auipc	ra,0x0
    80001034:	f8c080e7          	jalr	-116(ra) # 80000fbc <proc_freepagetable>
  p->pagetable = 0;
    80001038:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000103c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001040:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001044:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001048:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000104c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001050:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001054:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001058:	0004ac23          	sw	zero,24(s1)
}
    8000105c:	60e2                	ld	ra,24(sp)
    8000105e:	6442                	ld	s0,16(sp)
    80001060:	64a2                	ld	s1,8(sp)
    80001062:	6105                	addi	sp,sp,32
    80001064:	8082                	ret

0000000080001066 <allocproc>:
{
    80001066:	1101                	addi	sp,sp,-32
    80001068:	ec06                	sd	ra,24(sp)
    8000106a:	e822                	sd	s0,16(sp)
    8000106c:	e426                	sd	s1,8(sp)
    8000106e:	e04a                	sd	s2,0(sp)
    80001070:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001072:	00008497          	auipc	s1,0x8
    80001076:	40e48493          	addi	s1,s1,1038 # 80009480 <proc>
    8000107a:	00010917          	auipc	s2,0x10
    8000107e:	e0690913          	addi	s2,s2,-506 # 80010e80 <tickslock>
    acquire(&p->lock);
    80001082:	8526                	mv	a0,s1
    80001084:	00005097          	auipc	ra,0x5
    80001088:	4ec080e7          	jalr	1260(ra) # 80006570 <acquire>
    if(p->state == UNUSED) {
    8000108c:	4c9c                	lw	a5,24(s1)
    8000108e:	cf81                	beqz	a5,800010a6 <allocproc+0x40>
      release(&p->lock);
    80001090:	8526                	mv	a0,s1
    80001092:	00005097          	auipc	ra,0x5
    80001096:	592080e7          	jalr	1426(ra) # 80006624 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000109a:	1e848493          	addi	s1,s1,488
    8000109e:	ff2492e3          	bne	s1,s2,80001082 <allocproc+0x1c>
  return 0;
    800010a2:	4481                	li	s1,0
    800010a4:	a889                	j	800010f6 <allocproc+0x90>
  p->pid = allocpid();
    800010a6:	00000097          	auipc	ra,0x0
    800010aa:	e34080e7          	jalr	-460(ra) # 80000eda <allocpid>
    800010ae:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010b0:	4785                	li	a5,1
    800010b2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010b4:	fffff097          	auipc	ra,0xfffff
    800010b8:	064080e7          	jalr	100(ra) # 80000118 <kalloc>
    800010bc:	892a                	mv	s2,a0
    800010be:	eca8                	sd	a0,88(s1)
    800010c0:	c131                	beqz	a0,80001104 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010c2:	8526                	mv	a0,s1
    800010c4:	00000097          	auipc	ra,0x0
    800010c8:	e5c080e7          	jalr	-420(ra) # 80000f20 <proc_pagetable>
    800010cc:	892a                	mv	s2,a0
    800010ce:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010d0:	c531                	beqz	a0,8000111c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010d2:	07000613          	li	a2,112
    800010d6:	4581                	li	a1,0
    800010d8:	06048513          	addi	a0,s1,96
    800010dc:	fffff097          	auipc	ra,0xfffff
    800010e0:	09c080e7          	jalr	156(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010e4:	00000797          	auipc	a5,0x0
    800010e8:	db078793          	addi	a5,a5,-592 # 80000e94 <forkret>
    800010ec:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010ee:	60bc                	ld	a5,64(s1)
    800010f0:	6705                	lui	a4,0x1
    800010f2:	97ba                	add	a5,a5,a4
    800010f4:	f4bc                	sd	a5,104(s1)
}
    800010f6:	8526                	mv	a0,s1
    800010f8:	60e2                	ld	ra,24(sp)
    800010fa:	6442                	ld	s0,16(sp)
    800010fc:	64a2                	ld	s1,8(sp)
    800010fe:	6902                	ld	s2,0(sp)
    80001100:	6105                	addi	sp,sp,32
    80001102:	8082                	ret
    freeproc(p);
    80001104:	8526                	mv	a0,s1
    80001106:	00000097          	auipc	ra,0x0
    8000110a:	f08080e7          	jalr	-248(ra) # 8000100e <freeproc>
    release(&p->lock);
    8000110e:	8526                	mv	a0,s1
    80001110:	00005097          	auipc	ra,0x5
    80001114:	514080e7          	jalr	1300(ra) # 80006624 <release>
    return 0;
    80001118:	84ca                	mv	s1,s2
    8000111a:	bff1                	j	800010f6 <allocproc+0x90>
    freeproc(p);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	ef0080e7          	jalr	-272(ra) # 8000100e <freeproc>
    release(&p->lock);
    80001126:	8526                	mv	a0,s1
    80001128:	00005097          	auipc	ra,0x5
    8000112c:	4fc080e7          	jalr	1276(ra) # 80006624 <release>
    return 0;
    80001130:	84ca                	mv	s1,s2
    80001132:	b7d1                	j	800010f6 <allocproc+0x90>

0000000080001134 <userinit>:
{
    80001134:	1101                	addi	sp,sp,-32
    80001136:	ec06                	sd	ra,24(sp)
    80001138:	e822                	sd	s0,16(sp)
    8000113a:	e426                	sd	s1,8(sp)
    8000113c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	f28080e7          	jalr	-216(ra) # 80001066 <allocproc>
    80001146:	84aa                	mv	s1,a0
  initproc = p;
    80001148:	00008797          	auipc	a5,0x8
    8000114c:	eca7b423          	sd	a0,-312(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001150:	03400613          	li	a2,52
    80001154:	00007597          	auipc	a1,0x7
    80001158:	66c58593          	addi	a1,a1,1644 # 800087c0 <initcode>
    8000115c:	6928                	ld	a0,80(a0)
    8000115e:	fffff097          	auipc	ra,0xfffff
    80001162:	69c080e7          	jalr	1692(ra) # 800007fa <uvminit>
  p->sz = PGSIZE;
    80001166:	6785                	lui	a5,0x1
    80001168:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000116a:	6cb8                	ld	a4,88(s1)
    8000116c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001170:	6cb8                	ld	a4,88(s1)
    80001172:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001174:	4641                	li	a2,16
    80001176:	00007597          	auipc	a1,0x7
    8000117a:	fd258593          	addi	a1,a1,-46 # 80008148 <etext+0x148>
    8000117e:	15848513          	addi	a0,s1,344
    80001182:	fffff097          	auipc	ra,0xfffff
    80001186:	148080e7          	jalr	328(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    8000118a:	00007517          	auipc	a0,0x7
    8000118e:	fce50513          	addi	a0,a0,-50 # 80008158 <etext+0x158>
    80001192:	00002097          	auipc	ra,0x2
    80001196:	25a080e7          	jalr	602(ra) # 800033ec <namei>
    8000119a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000119e:	478d                	li	a5,3
    800011a0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011a2:	8526                	mv	a0,s1
    800011a4:	00005097          	auipc	ra,0x5
    800011a8:	480080e7          	jalr	1152(ra) # 80006624 <release>
}
    800011ac:	60e2                	ld	ra,24(sp)
    800011ae:	6442                	ld	s0,16(sp)
    800011b0:	64a2                	ld	s1,8(sp)
    800011b2:	6105                	addi	sp,sp,32
    800011b4:	8082                	ret

00000000800011b6 <growproc>:
{
    800011b6:	1101                	addi	sp,sp,-32
    800011b8:	ec06                	sd	ra,24(sp)
    800011ba:	e822                	sd	s0,16(sp)
    800011bc:	e426                	sd	s1,8(sp)
    800011be:	e04a                	sd	s2,0(sp)
    800011c0:	1000                	addi	s0,sp,32
    800011c2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011c4:	00000097          	auipc	ra,0x0
    800011c8:	c72080e7          	jalr	-910(ra) # 80000e36 <myproc>
    800011cc:	892a                	mv	s2,a0
  sz = p->sz;
    800011ce:	652c                	ld	a1,72(a0)
    800011d0:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011d4:	00904f63          	bgtz	s1,800011f2 <growproc+0x3c>
  } else if(n < 0){
    800011d8:	0204cc63          	bltz	s1,80001210 <growproc+0x5a>
  p->sz = sz;
    800011dc:	1602                	slli	a2,a2,0x20
    800011de:	9201                	srli	a2,a2,0x20
    800011e0:	04c93423          	sd	a2,72(s2)
  return 0;
    800011e4:	4501                	li	a0,0
}
    800011e6:	60e2                	ld	ra,24(sp)
    800011e8:	6442                	ld	s0,16(sp)
    800011ea:	64a2                	ld	s1,8(sp)
    800011ec:	6902                	ld	s2,0(sp)
    800011ee:	6105                	addi	sp,sp,32
    800011f0:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011f2:	9e25                	addw	a2,a2,s1
    800011f4:	1602                	slli	a2,a2,0x20
    800011f6:	9201                	srli	a2,a2,0x20
    800011f8:	1582                	slli	a1,a1,0x20
    800011fa:	9181                	srli	a1,a1,0x20
    800011fc:	6928                	ld	a0,80(a0)
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	6b6080e7          	jalr	1718(ra) # 800008b4 <uvmalloc>
    80001206:	0005061b          	sext.w	a2,a0
    8000120a:	fa69                	bnez	a2,800011dc <growproc+0x26>
      return -1;
    8000120c:	557d                	li	a0,-1
    8000120e:	bfe1                	j	800011e6 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001210:	9e25                	addw	a2,a2,s1
    80001212:	1602                	slli	a2,a2,0x20
    80001214:	9201                	srli	a2,a2,0x20
    80001216:	1582                	slli	a1,a1,0x20
    80001218:	9181                	srli	a1,a1,0x20
    8000121a:	6928                	ld	a0,80(a0)
    8000121c:	fffff097          	auipc	ra,0xfffff
    80001220:	650080e7          	jalr	1616(ra) # 8000086c <uvmdealloc>
    80001224:	0005061b          	sext.w	a2,a0
    80001228:	bf55                	j	800011dc <growproc+0x26>

000000008000122a <fork>:
{
    8000122a:	7139                	addi	sp,sp,-64
    8000122c:	fc06                	sd	ra,56(sp)
    8000122e:	f822                	sd	s0,48(sp)
    80001230:	f426                	sd	s1,40(sp)
    80001232:	f04a                	sd	s2,32(sp)
    80001234:	ec4e                	sd	s3,24(sp)
    80001236:	e852                	sd	s4,16(sp)
    80001238:	e456                	sd	s5,8(sp)
    8000123a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000123c:	00000097          	auipc	ra,0x0
    80001240:	bfa080e7          	jalr	-1030(ra) # 80000e36 <myproc>
    80001244:	89aa                	mv	s3,a0
  if((np = allocproc()) == 0){
    80001246:	00000097          	auipc	ra,0x0
    8000124a:	e20080e7          	jalr	-480(ra) # 80001066 <allocproc>
    8000124e:	18050163          	beqz	a0,800013d0 <fork+0x1a6>
    80001252:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001254:	0489b603          	ld	a2,72(s3)
    80001258:	692c                	ld	a1,80(a0)
    8000125a:	0509b503          	ld	a0,80(s3)
    8000125e:	fffff097          	auipc	ra,0xfffff
    80001262:	7a2080e7          	jalr	1954(ra) # 80000a00 <uvmcopy>
    80001266:	00054963          	bltz	a0,80001278 <fork+0x4e>
    8000126a:	16898493          	addi	s1,s3,360
    8000126e:	168a0913          	addi	s2,s4,360
    80001272:	1e898a93          	addi	s5,s3,488
    80001276:	a885                	j	800012e6 <fork+0xbc>
    freeproc(np);
    80001278:	8552                	mv	a0,s4
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	d94080e7          	jalr	-620(ra) # 8000100e <freeproc>
    release(&np->lock);
    80001282:	8552                	mv	a0,s4
    80001284:	00005097          	auipc	ra,0x5
    80001288:	3a0080e7          	jalr	928(ra) # 80006624 <release>
    return -1;
    8000128c:	597d                	li	s2,-1
    8000128e:	a23d                	j	800013bc <fork+0x192>
		  np->areaps[i]= vma_alloc();
    80001290:	00004097          	auipc	ra,0x4
    80001294:	7fe080e7          	jalr	2046(ra) # 80005a8e <vma_alloc>
    80001298:	00a93023          	sd	a0,0(s2)
		  np->areaps[i]->addr=p->areaps[i]->addr;
    8000129c:	609c                	ld	a5,0(s1)
    8000129e:	639c                	ld	a5,0(a5)
    800012a0:	e11c                	sd	a5,0(a0)
		  np->areaps[i]->length=p->areaps[i]->length;
    800012a2:	00093783          	ld	a5,0(s2)
    800012a6:	6098                	ld	a4,0(s1)
    800012a8:	6718                	ld	a4,8(a4)
    800012aa:	e798                	sd	a4,8(a5)
		  np->areaps[i]->prot=p->areaps[i]->prot;
    800012ac:	00093783          	ld	a5,0(s2)
    800012b0:	6098                	ld	a4,0(s1)
    800012b2:	01074703          	lbu	a4,16(a4)
    800012b6:	00e78823          	sb	a4,16(a5) # 1010 <_entry-0x7fffeff0>
		  np->areaps[i]->flags=p->areaps[i]->flags;
    800012ba:	00093783          	ld	a5,0(s2)
    800012be:	6098                	ld	a4,0(s1)
    800012c0:	01174703          	lbu	a4,17(a4)
    800012c4:	00e788a3          	sb	a4,17(a5)
		  np->areaps[i]->file=p->areaps[i]->file;
    800012c8:	00093783          	ld	a5,0(s2)
    800012cc:	6098                	ld	a4,0(s1)
    800012ce:	6f18                	ld	a4,24(a4)
    800012d0:	ef98                	sd	a4,24(a5)
		  filedup(p->areaps[i]->file);
    800012d2:	609c                	ld	a5,0(s1)
    800012d4:	6f88                	ld	a0,24(a5)
    800012d6:	00002097          	auipc	ra,0x2
    800012da:	7ac080e7          	jalr	1964(ra) # 80003a82 <filedup>
  for(i=0;i<NOFILE;i++)
    800012de:	04a1                	addi	s1,s1,8
    800012e0:	0921                	addi	s2,s2,8
    800012e2:	01548563          	beq	s1,s5,800012ec <fork+0xc2>
	  if(p->areaps[i])
    800012e6:	609c                	ld	a5,0(s1)
    800012e8:	f7c5                	bnez	a5,80001290 <fork+0x66>
    800012ea:	bfd5                	j	800012de <fork+0xb4>
  np->sz = p->sz;
    800012ec:	0489b783          	ld	a5,72(s3)
    800012f0:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012f4:	0589b683          	ld	a3,88(s3)
    800012f8:	87b6                	mv	a5,a3
    800012fa:	058a3703          	ld	a4,88(s4)
    800012fe:	12068693          	addi	a3,a3,288
    80001302:	0007b803          	ld	a6,0(a5)
    80001306:	6788                	ld	a0,8(a5)
    80001308:	6b8c                	ld	a1,16(a5)
    8000130a:	6f90                	ld	a2,24(a5)
    8000130c:	01073023          	sd	a6,0(a4)
    80001310:	e708                	sd	a0,8(a4)
    80001312:	eb0c                	sd	a1,16(a4)
    80001314:	ef10                	sd	a2,24(a4)
    80001316:	02078793          	addi	a5,a5,32
    8000131a:	02070713          	addi	a4,a4,32
    8000131e:	fed792e3          	bne	a5,a3,80001302 <fork+0xd8>
  np->trapframe->a0 = 0;
    80001322:	058a3783          	ld	a5,88(s4)
    80001326:	0607b823          	sd	zero,112(a5)
    8000132a:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000132e:	15000913          	li	s2,336
    80001332:	a819                	j	80001348 <fork+0x11e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001334:	00002097          	auipc	ra,0x2
    80001338:	74e080e7          	jalr	1870(ra) # 80003a82 <filedup>
    8000133c:	009a07b3          	add	a5,s4,s1
    80001340:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001342:	04a1                	addi	s1,s1,8
    80001344:	01248763          	beq	s1,s2,80001352 <fork+0x128>
    if(p->ofile[i])
    80001348:	009987b3          	add	a5,s3,s1
    8000134c:	6388                	ld	a0,0(a5)
    8000134e:	f17d                	bnez	a0,80001334 <fork+0x10a>
    80001350:	bfcd                	j	80001342 <fork+0x118>
  np->cwd = idup(p->cwd);
    80001352:	1509b503          	ld	a0,336(s3)
    80001356:	00002097          	auipc	ra,0x2
    8000135a:	8a2080e7          	jalr	-1886(ra) # 80002bf8 <idup>
    8000135e:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001362:	4641                	li	a2,16
    80001364:	15898593          	addi	a1,s3,344
    80001368:	158a0513          	addi	a0,s4,344
    8000136c:	fffff097          	auipc	ra,0xfffff
    80001370:	f5e080e7          	jalr	-162(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001374:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001378:	8552                	mv	a0,s4
    8000137a:	00005097          	auipc	ra,0x5
    8000137e:	2aa080e7          	jalr	682(ra) # 80006624 <release>
  acquire(&wait_lock);
    80001382:	00008497          	auipc	s1,0x8
    80001386:	ce648493          	addi	s1,s1,-794 # 80009068 <wait_lock>
    8000138a:	8526                	mv	a0,s1
    8000138c:	00005097          	auipc	ra,0x5
    80001390:	1e4080e7          	jalr	484(ra) # 80006570 <acquire>
  np->parent = p;
    80001394:	033a3c23          	sd	s3,56(s4)
  release(&wait_lock);
    80001398:	8526                	mv	a0,s1
    8000139a:	00005097          	auipc	ra,0x5
    8000139e:	28a080e7          	jalr	650(ra) # 80006624 <release>
  acquire(&np->lock);
    800013a2:	8552                	mv	a0,s4
    800013a4:	00005097          	auipc	ra,0x5
    800013a8:	1cc080e7          	jalr	460(ra) # 80006570 <acquire>
  np->state = RUNNABLE;
    800013ac:	478d                	li	a5,3
    800013ae:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013b2:	8552                	mv	a0,s4
    800013b4:	00005097          	auipc	ra,0x5
    800013b8:	270080e7          	jalr	624(ra) # 80006624 <release>
}
    800013bc:	854a                	mv	a0,s2
    800013be:	70e2                	ld	ra,56(sp)
    800013c0:	7442                	ld	s0,48(sp)
    800013c2:	74a2                	ld	s1,40(sp)
    800013c4:	7902                	ld	s2,32(sp)
    800013c6:	69e2                	ld	s3,24(sp)
    800013c8:	6a42                	ld	s4,16(sp)
    800013ca:	6aa2                	ld	s5,8(sp)
    800013cc:	6121                	addi	sp,sp,64
    800013ce:	8082                	ret
    return -1;
    800013d0:	597d                	li	s2,-1
    800013d2:	b7ed                	j	800013bc <fork+0x192>

00000000800013d4 <scheduler>:
{
    800013d4:	7139                	addi	sp,sp,-64
    800013d6:	fc06                	sd	ra,56(sp)
    800013d8:	f822                	sd	s0,48(sp)
    800013da:	f426                	sd	s1,40(sp)
    800013dc:	f04a                	sd	s2,32(sp)
    800013de:	ec4e                	sd	s3,24(sp)
    800013e0:	e852                	sd	s4,16(sp)
    800013e2:	e456                	sd	s5,8(sp)
    800013e4:	e05a                	sd	s6,0(sp)
    800013e6:	0080                	addi	s0,sp,64
    800013e8:	8792                	mv	a5,tp
  int id = r_tp();
    800013ea:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ec:	00779a93          	slli	s5,a5,0x7
    800013f0:	00008717          	auipc	a4,0x8
    800013f4:	c6070713          	addi	a4,a4,-928 # 80009050 <pid_lock>
    800013f8:	9756                	add	a4,a4,s5
    800013fa:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013fe:	00008717          	auipc	a4,0x8
    80001402:	c8a70713          	addi	a4,a4,-886 # 80009088 <cpus+0x8>
    80001406:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001408:	498d                	li	s3,3
        p->state = RUNNING;
    8000140a:	4b11                	li	s6,4
        c->proc = p;
    8000140c:	079e                	slli	a5,a5,0x7
    8000140e:	00008a17          	auipc	s4,0x8
    80001412:	c42a0a13          	addi	s4,s4,-958 # 80009050 <pid_lock>
    80001416:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001418:	00010917          	auipc	s2,0x10
    8000141c:	a6890913          	addi	s2,s2,-1432 # 80010e80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001420:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001424:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001428:	10079073          	csrw	sstatus,a5
    8000142c:	00008497          	auipc	s1,0x8
    80001430:	05448493          	addi	s1,s1,84 # 80009480 <proc>
    80001434:	a03d                	j	80001462 <scheduler+0x8e>
        p->state = RUNNING;
    80001436:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000143a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000143e:	06048593          	addi	a1,s1,96
    80001442:	8556                	mv	a0,s5
    80001444:	00000097          	auipc	ra,0x0
    80001448:	6d4080e7          	jalr	1748(ra) # 80001b18 <swtch>
        c->proc = 0;
    8000144c:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001450:	8526                	mv	a0,s1
    80001452:	00005097          	auipc	ra,0x5
    80001456:	1d2080e7          	jalr	466(ra) # 80006624 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000145a:	1e848493          	addi	s1,s1,488
    8000145e:	fd2481e3          	beq	s1,s2,80001420 <scheduler+0x4c>
      acquire(&p->lock);
    80001462:	8526                	mv	a0,s1
    80001464:	00005097          	auipc	ra,0x5
    80001468:	10c080e7          	jalr	268(ra) # 80006570 <acquire>
      if(p->state == RUNNABLE) {
    8000146c:	4c9c                	lw	a5,24(s1)
    8000146e:	ff3791e3          	bne	a5,s3,80001450 <scheduler+0x7c>
    80001472:	b7d1                	j	80001436 <scheduler+0x62>

0000000080001474 <sched>:
{
    80001474:	7179                	addi	sp,sp,-48
    80001476:	f406                	sd	ra,40(sp)
    80001478:	f022                	sd	s0,32(sp)
    8000147a:	ec26                	sd	s1,24(sp)
    8000147c:	e84a                	sd	s2,16(sp)
    8000147e:	e44e                	sd	s3,8(sp)
    80001480:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001482:	00000097          	auipc	ra,0x0
    80001486:	9b4080e7          	jalr	-1612(ra) # 80000e36 <myproc>
    8000148a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000148c:	00005097          	auipc	ra,0x5
    80001490:	06a080e7          	jalr	106(ra) # 800064f6 <holding>
    80001494:	c93d                	beqz	a0,8000150a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001496:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001498:	2781                	sext.w	a5,a5
    8000149a:	079e                	slli	a5,a5,0x7
    8000149c:	00008717          	auipc	a4,0x8
    800014a0:	bb470713          	addi	a4,a4,-1100 # 80009050 <pid_lock>
    800014a4:	97ba                	add	a5,a5,a4
    800014a6:	0a87a703          	lw	a4,168(a5)
    800014aa:	4785                	li	a5,1
    800014ac:	06f71763          	bne	a4,a5,8000151a <sched+0xa6>
  if(p->state == RUNNING)
    800014b0:	4c98                	lw	a4,24(s1)
    800014b2:	4791                	li	a5,4
    800014b4:	06f70b63          	beq	a4,a5,8000152a <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014b8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014bc:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014be:	efb5                	bnez	a5,8000153a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014c0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014c2:	00008917          	auipc	s2,0x8
    800014c6:	b8e90913          	addi	s2,s2,-1138 # 80009050 <pid_lock>
    800014ca:	2781                	sext.w	a5,a5
    800014cc:	079e                	slli	a5,a5,0x7
    800014ce:	97ca                	add	a5,a5,s2
    800014d0:	0ac7a983          	lw	s3,172(a5)
    800014d4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014d6:	2781                	sext.w	a5,a5
    800014d8:	079e                	slli	a5,a5,0x7
    800014da:	00008597          	auipc	a1,0x8
    800014de:	bae58593          	addi	a1,a1,-1106 # 80009088 <cpus+0x8>
    800014e2:	95be                	add	a1,a1,a5
    800014e4:	06048513          	addi	a0,s1,96
    800014e8:	00000097          	auipc	ra,0x0
    800014ec:	630080e7          	jalr	1584(ra) # 80001b18 <swtch>
    800014f0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014f2:	2781                	sext.w	a5,a5
    800014f4:	079e                	slli	a5,a5,0x7
    800014f6:	97ca                	add	a5,a5,s2
    800014f8:	0b37a623          	sw	s3,172(a5)
}
    800014fc:	70a2                	ld	ra,40(sp)
    800014fe:	7402                	ld	s0,32(sp)
    80001500:	64e2                	ld	s1,24(sp)
    80001502:	6942                	ld	s2,16(sp)
    80001504:	69a2                	ld	s3,8(sp)
    80001506:	6145                	addi	sp,sp,48
    80001508:	8082                	ret
    panic("sched p->lock");
    8000150a:	00007517          	auipc	a0,0x7
    8000150e:	c5650513          	addi	a0,a0,-938 # 80008160 <etext+0x160>
    80001512:	00005097          	auipc	ra,0x5
    80001516:	b14080e7          	jalr	-1260(ra) # 80006026 <panic>
    panic("sched locks");
    8000151a:	00007517          	auipc	a0,0x7
    8000151e:	c5650513          	addi	a0,a0,-938 # 80008170 <etext+0x170>
    80001522:	00005097          	auipc	ra,0x5
    80001526:	b04080e7          	jalr	-1276(ra) # 80006026 <panic>
    panic("sched running");
    8000152a:	00007517          	auipc	a0,0x7
    8000152e:	c5650513          	addi	a0,a0,-938 # 80008180 <etext+0x180>
    80001532:	00005097          	auipc	ra,0x5
    80001536:	af4080e7          	jalr	-1292(ra) # 80006026 <panic>
    panic("sched interruptible");
    8000153a:	00007517          	auipc	a0,0x7
    8000153e:	c5650513          	addi	a0,a0,-938 # 80008190 <etext+0x190>
    80001542:	00005097          	auipc	ra,0x5
    80001546:	ae4080e7          	jalr	-1308(ra) # 80006026 <panic>

000000008000154a <yield>:
{
    8000154a:	1101                	addi	sp,sp,-32
    8000154c:	ec06                	sd	ra,24(sp)
    8000154e:	e822                	sd	s0,16(sp)
    80001550:	e426                	sd	s1,8(sp)
    80001552:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001554:	00000097          	auipc	ra,0x0
    80001558:	8e2080e7          	jalr	-1822(ra) # 80000e36 <myproc>
    8000155c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	012080e7          	jalr	18(ra) # 80006570 <acquire>
  p->state = RUNNABLE;
    80001566:	478d                	li	a5,3
    80001568:	cc9c                	sw	a5,24(s1)
  sched();
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	f0a080e7          	jalr	-246(ra) # 80001474 <sched>
  release(&p->lock);
    80001572:	8526                	mv	a0,s1
    80001574:	00005097          	auipc	ra,0x5
    80001578:	0b0080e7          	jalr	176(ra) # 80006624 <release>
}
    8000157c:	60e2                	ld	ra,24(sp)
    8000157e:	6442                	ld	s0,16(sp)
    80001580:	64a2                	ld	s1,8(sp)
    80001582:	6105                	addi	sp,sp,32
    80001584:	8082                	ret

0000000080001586 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001586:	7179                	addi	sp,sp,-48
    80001588:	f406                	sd	ra,40(sp)
    8000158a:	f022                	sd	s0,32(sp)
    8000158c:	ec26                	sd	s1,24(sp)
    8000158e:	e84a                	sd	s2,16(sp)
    80001590:	e44e                	sd	s3,8(sp)
    80001592:	1800                	addi	s0,sp,48
    80001594:	89aa                	mv	s3,a0
    80001596:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001598:	00000097          	auipc	ra,0x0
    8000159c:	89e080e7          	jalr	-1890(ra) # 80000e36 <myproc>
    800015a0:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	fce080e7          	jalr	-50(ra) # 80006570 <acquire>
  release(lk);
    800015aa:	854a                	mv	a0,s2
    800015ac:	00005097          	auipc	ra,0x5
    800015b0:	078080e7          	jalr	120(ra) # 80006624 <release>

  // Go to sleep.
  p->chan = chan;
    800015b4:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015b8:	4789                	li	a5,2
    800015ba:	cc9c                	sw	a5,24(s1)

  sched();
    800015bc:	00000097          	auipc	ra,0x0
    800015c0:	eb8080e7          	jalr	-328(ra) # 80001474 <sched>

  // Tidy up.
  p->chan = 0;
    800015c4:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015c8:	8526                	mv	a0,s1
    800015ca:	00005097          	auipc	ra,0x5
    800015ce:	05a080e7          	jalr	90(ra) # 80006624 <release>
  acquire(lk);
    800015d2:	854a                	mv	a0,s2
    800015d4:	00005097          	auipc	ra,0x5
    800015d8:	f9c080e7          	jalr	-100(ra) # 80006570 <acquire>
}
    800015dc:	70a2                	ld	ra,40(sp)
    800015de:	7402                	ld	s0,32(sp)
    800015e0:	64e2                	ld	s1,24(sp)
    800015e2:	6942                	ld	s2,16(sp)
    800015e4:	69a2                	ld	s3,8(sp)
    800015e6:	6145                	addi	sp,sp,48
    800015e8:	8082                	ret

00000000800015ea <wait>:
{
    800015ea:	715d                	addi	sp,sp,-80
    800015ec:	e486                	sd	ra,72(sp)
    800015ee:	e0a2                	sd	s0,64(sp)
    800015f0:	fc26                	sd	s1,56(sp)
    800015f2:	f84a                	sd	s2,48(sp)
    800015f4:	f44e                	sd	s3,40(sp)
    800015f6:	f052                	sd	s4,32(sp)
    800015f8:	ec56                	sd	s5,24(sp)
    800015fa:	e85a                	sd	s6,16(sp)
    800015fc:	e45e                	sd	s7,8(sp)
    800015fe:	e062                	sd	s8,0(sp)
    80001600:	0880                	addi	s0,sp,80
    80001602:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001604:	00000097          	auipc	ra,0x0
    80001608:	832080e7          	jalr	-1998(ra) # 80000e36 <myproc>
    8000160c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000160e:	00008517          	auipc	a0,0x8
    80001612:	a5a50513          	addi	a0,a0,-1446 # 80009068 <wait_lock>
    80001616:	00005097          	auipc	ra,0x5
    8000161a:	f5a080e7          	jalr	-166(ra) # 80006570 <acquire>
    havekids = 0;
    8000161e:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001620:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80001622:	00010997          	auipc	s3,0x10
    80001626:	85e98993          	addi	s3,s3,-1954 # 80010e80 <tickslock>
        havekids = 1;
    8000162a:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000162c:	00008c17          	auipc	s8,0x8
    80001630:	a3cc0c13          	addi	s8,s8,-1476 # 80009068 <wait_lock>
    havekids = 0;
    80001634:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001636:	00008497          	auipc	s1,0x8
    8000163a:	e4a48493          	addi	s1,s1,-438 # 80009480 <proc>
    8000163e:	a0bd                	j	800016ac <wait+0xc2>
          pid = np->pid;
    80001640:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001644:	000b0e63          	beqz	s6,80001660 <wait+0x76>
    80001648:	4691                	li	a3,4
    8000164a:	02c48613          	addi	a2,s1,44
    8000164e:	85da                	mv	a1,s6
    80001650:	05093503          	ld	a0,80(s2)
    80001654:	fffff097          	auipc	ra,0xfffff
    80001658:	4a4080e7          	jalr	1188(ra) # 80000af8 <copyout>
    8000165c:	02054563          	bltz	a0,80001686 <wait+0x9c>
          freeproc(np);
    80001660:	8526                	mv	a0,s1
    80001662:	00000097          	auipc	ra,0x0
    80001666:	9ac080e7          	jalr	-1620(ra) # 8000100e <freeproc>
          release(&np->lock);
    8000166a:	8526                	mv	a0,s1
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	fb8080e7          	jalr	-72(ra) # 80006624 <release>
          release(&wait_lock);
    80001674:	00008517          	auipc	a0,0x8
    80001678:	9f450513          	addi	a0,a0,-1548 # 80009068 <wait_lock>
    8000167c:	00005097          	auipc	ra,0x5
    80001680:	fa8080e7          	jalr	-88(ra) # 80006624 <release>
          return pid;
    80001684:	a09d                	j	800016ea <wait+0x100>
            release(&np->lock);
    80001686:	8526                	mv	a0,s1
    80001688:	00005097          	auipc	ra,0x5
    8000168c:	f9c080e7          	jalr	-100(ra) # 80006624 <release>
            release(&wait_lock);
    80001690:	00008517          	auipc	a0,0x8
    80001694:	9d850513          	addi	a0,a0,-1576 # 80009068 <wait_lock>
    80001698:	00005097          	auipc	ra,0x5
    8000169c:	f8c080e7          	jalr	-116(ra) # 80006624 <release>
            return -1;
    800016a0:	59fd                	li	s3,-1
    800016a2:	a0a1                	j	800016ea <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800016a4:	1e848493          	addi	s1,s1,488
    800016a8:	03348463          	beq	s1,s3,800016d0 <wait+0xe6>
      if(np->parent == p){
    800016ac:	7c9c                	ld	a5,56(s1)
    800016ae:	ff279be3          	bne	a5,s2,800016a4 <wait+0xba>
        acquire(&np->lock);
    800016b2:	8526                	mv	a0,s1
    800016b4:	00005097          	auipc	ra,0x5
    800016b8:	ebc080e7          	jalr	-324(ra) # 80006570 <acquire>
        if(np->state == ZOMBIE){
    800016bc:	4c9c                	lw	a5,24(s1)
    800016be:	f94781e3          	beq	a5,s4,80001640 <wait+0x56>
        release(&np->lock);
    800016c2:	8526                	mv	a0,s1
    800016c4:	00005097          	auipc	ra,0x5
    800016c8:	f60080e7          	jalr	-160(ra) # 80006624 <release>
        havekids = 1;
    800016cc:	8756                	mv	a4,s5
    800016ce:	bfd9                	j	800016a4 <wait+0xba>
    if(!havekids || p->killed){
    800016d0:	c701                	beqz	a4,800016d8 <wait+0xee>
    800016d2:	02892783          	lw	a5,40(s2)
    800016d6:	c79d                	beqz	a5,80001704 <wait+0x11a>
      release(&wait_lock);
    800016d8:	00008517          	auipc	a0,0x8
    800016dc:	99050513          	addi	a0,a0,-1648 # 80009068 <wait_lock>
    800016e0:	00005097          	auipc	ra,0x5
    800016e4:	f44080e7          	jalr	-188(ra) # 80006624 <release>
      return -1;
    800016e8:	59fd                	li	s3,-1
}
    800016ea:	854e                	mv	a0,s3
    800016ec:	60a6                	ld	ra,72(sp)
    800016ee:	6406                	ld	s0,64(sp)
    800016f0:	74e2                	ld	s1,56(sp)
    800016f2:	7942                	ld	s2,48(sp)
    800016f4:	79a2                	ld	s3,40(sp)
    800016f6:	7a02                	ld	s4,32(sp)
    800016f8:	6ae2                	ld	s5,24(sp)
    800016fa:	6b42                	ld	s6,16(sp)
    800016fc:	6ba2                	ld	s7,8(sp)
    800016fe:	6c02                	ld	s8,0(sp)
    80001700:	6161                	addi	sp,sp,80
    80001702:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001704:	85e2                	mv	a1,s8
    80001706:	854a                	mv	a0,s2
    80001708:	00000097          	auipc	ra,0x0
    8000170c:	e7e080e7          	jalr	-386(ra) # 80001586 <sleep>
    havekids = 0;
    80001710:	b715                	j	80001634 <wait+0x4a>

0000000080001712 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001712:	7139                	addi	sp,sp,-64
    80001714:	fc06                	sd	ra,56(sp)
    80001716:	f822                	sd	s0,48(sp)
    80001718:	f426                	sd	s1,40(sp)
    8000171a:	f04a                	sd	s2,32(sp)
    8000171c:	ec4e                	sd	s3,24(sp)
    8000171e:	e852                	sd	s4,16(sp)
    80001720:	e456                	sd	s5,8(sp)
    80001722:	0080                	addi	s0,sp,64
    80001724:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001726:	00008497          	auipc	s1,0x8
    8000172a:	d5a48493          	addi	s1,s1,-678 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000172e:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001730:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001732:	0000f917          	auipc	s2,0xf
    80001736:	74e90913          	addi	s2,s2,1870 # 80010e80 <tickslock>
    8000173a:	a821                	j	80001752 <wakeup+0x40>
        p->state = RUNNABLE;
    8000173c:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001740:	8526                	mv	a0,s1
    80001742:	00005097          	auipc	ra,0x5
    80001746:	ee2080e7          	jalr	-286(ra) # 80006624 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000174a:	1e848493          	addi	s1,s1,488
    8000174e:	03248463          	beq	s1,s2,80001776 <wakeup+0x64>
    if(p != myproc()){
    80001752:	fffff097          	auipc	ra,0xfffff
    80001756:	6e4080e7          	jalr	1764(ra) # 80000e36 <myproc>
    8000175a:	fea488e3          	beq	s1,a0,8000174a <wakeup+0x38>
      acquire(&p->lock);
    8000175e:	8526                	mv	a0,s1
    80001760:	00005097          	auipc	ra,0x5
    80001764:	e10080e7          	jalr	-496(ra) # 80006570 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001768:	4c9c                	lw	a5,24(s1)
    8000176a:	fd379be3          	bne	a5,s3,80001740 <wakeup+0x2e>
    8000176e:	709c                	ld	a5,32(s1)
    80001770:	fd4798e3          	bne	a5,s4,80001740 <wakeup+0x2e>
    80001774:	b7e1                	j	8000173c <wakeup+0x2a>
    }
  }
}
    80001776:	70e2                	ld	ra,56(sp)
    80001778:	7442                	ld	s0,48(sp)
    8000177a:	74a2                	ld	s1,40(sp)
    8000177c:	7902                	ld	s2,32(sp)
    8000177e:	69e2                	ld	s3,24(sp)
    80001780:	6a42                	ld	s4,16(sp)
    80001782:	6aa2                	ld	s5,8(sp)
    80001784:	6121                	addi	sp,sp,64
    80001786:	8082                	ret

0000000080001788 <reparent>:
{
    80001788:	7179                	addi	sp,sp,-48
    8000178a:	f406                	sd	ra,40(sp)
    8000178c:	f022                	sd	s0,32(sp)
    8000178e:	ec26                	sd	s1,24(sp)
    80001790:	e84a                	sd	s2,16(sp)
    80001792:	e44e                	sd	s3,8(sp)
    80001794:	e052                	sd	s4,0(sp)
    80001796:	1800                	addi	s0,sp,48
    80001798:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000179a:	00008497          	auipc	s1,0x8
    8000179e:	ce648493          	addi	s1,s1,-794 # 80009480 <proc>
      pp->parent = initproc;
    800017a2:	00008a17          	auipc	s4,0x8
    800017a6:	86ea0a13          	addi	s4,s4,-1938 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017aa:	0000f997          	auipc	s3,0xf
    800017ae:	6d698993          	addi	s3,s3,1750 # 80010e80 <tickslock>
    800017b2:	a029                	j	800017bc <reparent+0x34>
    800017b4:	1e848493          	addi	s1,s1,488
    800017b8:	01348d63          	beq	s1,s3,800017d2 <reparent+0x4a>
    if(pp->parent == p){
    800017bc:	7c9c                	ld	a5,56(s1)
    800017be:	ff279be3          	bne	a5,s2,800017b4 <reparent+0x2c>
      pp->parent = initproc;
    800017c2:	000a3503          	ld	a0,0(s4)
    800017c6:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017c8:	00000097          	auipc	ra,0x0
    800017cc:	f4a080e7          	jalr	-182(ra) # 80001712 <wakeup>
    800017d0:	b7d5                	j	800017b4 <reparent+0x2c>
}
    800017d2:	70a2                	ld	ra,40(sp)
    800017d4:	7402                	ld	s0,32(sp)
    800017d6:	64e2                	ld	s1,24(sp)
    800017d8:	6942                	ld	s2,16(sp)
    800017da:	69a2                	ld	s3,8(sp)
    800017dc:	6a02                	ld	s4,0(sp)
    800017de:	6145                	addi	sp,sp,48
    800017e0:	8082                	ret

00000000800017e2 <exit>:
{
    800017e2:	715d                	addi	sp,sp,-80
    800017e4:	e486                	sd	ra,72(sp)
    800017e6:	e0a2                	sd	s0,64(sp)
    800017e8:	fc26                	sd	s1,56(sp)
    800017ea:	f84a                	sd	s2,48(sp)
    800017ec:	f44e                	sd	s3,40(sp)
    800017ee:	f052                	sd	s4,32(sp)
    800017f0:	ec56                	sd	s5,24(sp)
    800017f2:	e85a                	sd	s6,16(sp)
    800017f4:	e45e                	sd	s7,8(sp)
    800017f6:	0880                	addi	s0,sp,80
    800017f8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017fa:	fffff097          	auipc	ra,0xfffff
    800017fe:	63c080e7          	jalr	1596(ra) # 80000e36 <myproc>
    80001802:	8aaa                	mv	s5,a0
  if(p == initproc)
    80001804:	00008797          	auipc	a5,0x8
    80001808:	80c7b783          	ld	a5,-2036(a5) # 80009010 <initproc>
    8000180c:	16850493          	addi	s1,a0,360
    80001810:	1e850a13          	addi	s4,a0,488
		  if(vmap->prot&PROT_WRITE&&vmap->flags==MAP_SHARED)
    80001814:	4b85                	li	s7,1
  if(p == initproc)
    80001816:	02a79a63          	bne	a5,a0,8000184a <exit+0x68>
    panic("init exiting");
    8000181a:	00007517          	auipc	a0,0x7
    8000181e:	98e50513          	addi	a0,a0,-1650 # 800081a8 <etext+0x1a8>
    80001822:	00005097          	auipc	ra,0x5
    80001826:	804080e7          	jalr	-2044(ra) # 80006026 <panic>
		  fileclose(vmap->file);
    8000182a:	01893503          	ld	a0,24(s2)
    8000182e:	00002097          	auipc	ra,0x2
    80001832:	2a6080e7          	jalr	678(ra) # 80003ad4 <fileclose>
		  vma_free(vmap);
    80001836:	854a                	mv	a0,s2
    80001838:	00004097          	auipc	ra,0x4
    8000183c:	2bc080e7          	jalr	700(ra) # 80005af4 <vma_free>
		  p->areaps[i]=0;
    80001840:	0009b023          	sd	zero,0(s3)
  for(int i=0;i<NOFILE;i++)
    80001844:	04a1                	addi	s1,s1,8
    80001846:	07448363          	beq	s1,s4,800018ac <exit+0xca>
	  if(p->areaps[i])
    8000184a:	89a6                	mv	s3,s1
    8000184c:	0004b903          	ld	s2,0(s1)
    80001850:	fe090ae3          	beqz	s2,80001844 <exit+0x62>
		  if(vmap->prot&PROT_WRITE&&vmap->flags==MAP_SHARED)
    80001854:	01094783          	lbu	a5,16(s2)
    80001858:	8b89                	andi	a5,a5,2
    8000185a:	dbe1                	beqz	a5,8000182a <exit+0x48>
    8000185c:	01194783          	lbu	a5,17(s2)
    80001860:	fd7795e3          	bne	a5,s7,8000182a <exit+0x48>
			  begin_op();
    80001864:	00002097          	auipc	ra,0x2
    80001868:	da4080e7          	jalr	-604(ra) # 80003608 <begin_op>
			  ilock(vmap->file->ip);
    8000186c:	01893783          	ld	a5,24(s2)
    80001870:	6f88                	ld	a0,24(a5)
    80001872:	00001097          	auipc	ra,0x1
    80001876:	3c4080e7          	jalr	964(ra) # 80002c36 <ilock>
			  writei(vmap->file->ip,1,(uint64)vmap->addr,0,vmap->length);
    8000187a:	01893783          	ld	a5,24(s2)
    8000187e:	00892703          	lw	a4,8(s2)
    80001882:	4681                	li	a3,0
    80001884:	00093603          	ld	a2,0(s2)
    80001888:	85de                	mv	a1,s7
    8000188a:	6f88                	ld	a0,24(a5)
    8000188c:	00001097          	auipc	ra,0x1
    80001890:	756080e7          	jalr	1878(ra) # 80002fe2 <writei>
			  iunlock(vmap->file->ip);
    80001894:	01893783          	ld	a5,24(s2)
    80001898:	6f88                	ld	a0,24(a5)
    8000189a:	00001097          	auipc	ra,0x1
    8000189e:	45e080e7          	jalr	1118(ra) # 80002cf8 <iunlock>
			  end_op();
    800018a2:	00002097          	auipc	ra,0x2
    800018a6:	de6080e7          	jalr	-538(ra) # 80003688 <end_op>
    800018aa:	b741                	j	8000182a <exit+0x48>
    800018ac:	0d0a8493          	addi	s1,s5,208
    800018b0:	150a8913          	addi	s2,s5,336
    800018b4:	a811                	j	800018c8 <exit+0xe6>
      fileclose(f);
    800018b6:	00002097          	auipc	ra,0x2
    800018ba:	21e080e7          	jalr	542(ra) # 80003ad4 <fileclose>
      p->ofile[fd] = 0;
    800018be:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018c2:	04a1                	addi	s1,s1,8
    800018c4:	01248563          	beq	s1,s2,800018ce <exit+0xec>
    if(p->ofile[fd]){
    800018c8:	6088                	ld	a0,0(s1)
    800018ca:	f575                	bnez	a0,800018b6 <exit+0xd4>
    800018cc:	bfdd                	j	800018c2 <exit+0xe0>
  begin_op();
    800018ce:	00002097          	auipc	ra,0x2
    800018d2:	d3a080e7          	jalr	-710(ra) # 80003608 <begin_op>
  iput(p->cwd);
    800018d6:	150ab503          	ld	a0,336(s5)
    800018da:	00001097          	auipc	ra,0x1
    800018de:	516080e7          	jalr	1302(ra) # 80002df0 <iput>
  end_op();
    800018e2:	00002097          	auipc	ra,0x2
    800018e6:	da6080e7          	jalr	-602(ra) # 80003688 <end_op>
  p->cwd = 0;
    800018ea:	140ab823          	sd	zero,336(s5)
  acquire(&wait_lock);
    800018ee:	00007497          	auipc	s1,0x7
    800018f2:	77a48493          	addi	s1,s1,1914 # 80009068 <wait_lock>
    800018f6:	8526                	mv	a0,s1
    800018f8:	00005097          	auipc	ra,0x5
    800018fc:	c78080e7          	jalr	-904(ra) # 80006570 <acquire>
  reparent(p);
    80001900:	8556                	mv	a0,s5
    80001902:	00000097          	auipc	ra,0x0
    80001906:	e86080e7          	jalr	-378(ra) # 80001788 <reparent>
  wakeup(p->parent);
    8000190a:	038ab503          	ld	a0,56(s5)
    8000190e:	00000097          	auipc	ra,0x0
    80001912:	e04080e7          	jalr	-508(ra) # 80001712 <wakeup>
  acquire(&p->lock);
    80001916:	8556                	mv	a0,s5
    80001918:	00005097          	auipc	ra,0x5
    8000191c:	c58080e7          	jalr	-936(ra) # 80006570 <acquire>
  p->xstate = status;
    80001920:	036aa623          	sw	s6,44(s5)
  p->state = ZOMBIE;
    80001924:	4795                	li	a5,5
    80001926:	00faac23          	sw	a5,24(s5)
  release(&wait_lock);
    8000192a:	8526                	mv	a0,s1
    8000192c:	00005097          	auipc	ra,0x5
    80001930:	cf8080e7          	jalr	-776(ra) # 80006624 <release>
  sched();
    80001934:	00000097          	auipc	ra,0x0
    80001938:	b40080e7          	jalr	-1216(ra) # 80001474 <sched>
  panic("zombie exit");
    8000193c:	00007517          	auipc	a0,0x7
    80001940:	87c50513          	addi	a0,a0,-1924 # 800081b8 <etext+0x1b8>
    80001944:	00004097          	auipc	ra,0x4
    80001948:	6e2080e7          	jalr	1762(ra) # 80006026 <panic>

000000008000194c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000194c:	7179                	addi	sp,sp,-48
    8000194e:	f406                	sd	ra,40(sp)
    80001950:	f022                	sd	s0,32(sp)
    80001952:	ec26                	sd	s1,24(sp)
    80001954:	e84a                	sd	s2,16(sp)
    80001956:	e44e                	sd	s3,8(sp)
    80001958:	1800                	addi	s0,sp,48
    8000195a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000195c:	00008497          	auipc	s1,0x8
    80001960:	b2448493          	addi	s1,s1,-1244 # 80009480 <proc>
    80001964:	0000f997          	auipc	s3,0xf
    80001968:	51c98993          	addi	s3,s3,1308 # 80010e80 <tickslock>
    acquire(&p->lock);
    8000196c:	8526                	mv	a0,s1
    8000196e:	00005097          	auipc	ra,0x5
    80001972:	c02080e7          	jalr	-1022(ra) # 80006570 <acquire>
    if(p->pid == pid){
    80001976:	589c                	lw	a5,48(s1)
    80001978:	01278d63          	beq	a5,s2,80001992 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000197c:	8526                	mv	a0,s1
    8000197e:	00005097          	auipc	ra,0x5
    80001982:	ca6080e7          	jalr	-858(ra) # 80006624 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001986:	1e848493          	addi	s1,s1,488
    8000198a:	ff3491e3          	bne	s1,s3,8000196c <kill+0x20>
  }
  return -1;
    8000198e:	557d                	li	a0,-1
    80001990:	a829                	j	800019aa <kill+0x5e>
      p->killed = 1;
    80001992:	4785                	li	a5,1
    80001994:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001996:	4c98                	lw	a4,24(s1)
    80001998:	4789                	li	a5,2
    8000199a:	00f70f63          	beq	a4,a5,800019b8 <kill+0x6c>
      release(&p->lock);
    8000199e:	8526                	mv	a0,s1
    800019a0:	00005097          	auipc	ra,0x5
    800019a4:	c84080e7          	jalr	-892(ra) # 80006624 <release>
      return 0;
    800019a8:	4501                	li	a0,0
}
    800019aa:	70a2                	ld	ra,40(sp)
    800019ac:	7402                	ld	s0,32(sp)
    800019ae:	64e2                	ld	s1,24(sp)
    800019b0:	6942                	ld	s2,16(sp)
    800019b2:	69a2                	ld	s3,8(sp)
    800019b4:	6145                	addi	sp,sp,48
    800019b6:	8082                	ret
        p->state = RUNNABLE;
    800019b8:	478d                	li	a5,3
    800019ba:	cc9c                	sw	a5,24(s1)
    800019bc:	b7cd                	j	8000199e <kill+0x52>

00000000800019be <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019be:	7179                	addi	sp,sp,-48
    800019c0:	f406                	sd	ra,40(sp)
    800019c2:	f022                	sd	s0,32(sp)
    800019c4:	ec26                	sd	s1,24(sp)
    800019c6:	e84a                	sd	s2,16(sp)
    800019c8:	e44e                	sd	s3,8(sp)
    800019ca:	e052                	sd	s4,0(sp)
    800019cc:	1800                	addi	s0,sp,48
    800019ce:	84aa                	mv	s1,a0
    800019d0:	892e                	mv	s2,a1
    800019d2:	89b2                	mv	s3,a2
    800019d4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	460080e7          	jalr	1120(ra) # 80000e36 <myproc>
  if(user_dst){
    800019de:	c08d                	beqz	s1,80001a00 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019e0:	86d2                	mv	a3,s4
    800019e2:	864e                	mv	a2,s3
    800019e4:	85ca                	mv	a1,s2
    800019e6:	6928                	ld	a0,80(a0)
    800019e8:	fffff097          	auipc	ra,0xfffff
    800019ec:	110080e7          	jalr	272(ra) # 80000af8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019f0:	70a2                	ld	ra,40(sp)
    800019f2:	7402                	ld	s0,32(sp)
    800019f4:	64e2                	ld	s1,24(sp)
    800019f6:	6942                	ld	s2,16(sp)
    800019f8:	69a2                	ld	s3,8(sp)
    800019fa:	6a02                	ld	s4,0(sp)
    800019fc:	6145                	addi	sp,sp,48
    800019fe:	8082                	ret
    memmove((char *)dst, src, len);
    80001a00:	000a061b          	sext.w	a2,s4
    80001a04:	85ce                	mv	a1,s3
    80001a06:	854a                	mv	a0,s2
    80001a08:	ffffe097          	auipc	ra,0xffffe
    80001a0c:	7d0080e7          	jalr	2000(ra) # 800001d8 <memmove>
    return 0;
    80001a10:	8526                	mv	a0,s1
    80001a12:	bff9                	j	800019f0 <either_copyout+0x32>

0000000080001a14 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a14:	7179                	addi	sp,sp,-48
    80001a16:	f406                	sd	ra,40(sp)
    80001a18:	f022                	sd	s0,32(sp)
    80001a1a:	ec26                	sd	s1,24(sp)
    80001a1c:	e84a                	sd	s2,16(sp)
    80001a1e:	e44e                	sd	s3,8(sp)
    80001a20:	e052                	sd	s4,0(sp)
    80001a22:	1800                	addi	s0,sp,48
    80001a24:	892a                	mv	s2,a0
    80001a26:	84ae                	mv	s1,a1
    80001a28:	89b2                	mv	s3,a2
    80001a2a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a2c:	fffff097          	auipc	ra,0xfffff
    80001a30:	40a080e7          	jalr	1034(ra) # 80000e36 <myproc>
  if(user_src){
    80001a34:	c08d                	beqz	s1,80001a56 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a36:	86d2                	mv	a3,s4
    80001a38:	864e                	mv	a2,s3
    80001a3a:	85ca                	mv	a1,s2
    80001a3c:	6928                	ld	a0,80(a0)
    80001a3e:	fffff097          	auipc	ra,0xfffff
    80001a42:	146080e7          	jalr	326(ra) # 80000b84 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a46:	70a2                	ld	ra,40(sp)
    80001a48:	7402                	ld	s0,32(sp)
    80001a4a:	64e2                	ld	s1,24(sp)
    80001a4c:	6942                	ld	s2,16(sp)
    80001a4e:	69a2                	ld	s3,8(sp)
    80001a50:	6a02                	ld	s4,0(sp)
    80001a52:	6145                	addi	sp,sp,48
    80001a54:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a56:	000a061b          	sext.w	a2,s4
    80001a5a:	85ce                	mv	a1,s3
    80001a5c:	854a                	mv	a0,s2
    80001a5e:	ffffe097          	auipc	ra,0xffffe
    80001a62:	77a080e7          	jalr	1914(ra) # 800001d8 <memmove>
    return 0;
    80001a66:	8526                	mv	a0,s1
    80001a68:	bff9                	j	80001a46 <either_copyin+0x32>

0000000080001a6a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a6a:	715d                	addi	sp,sp,-80
    80001a6c:	e486                	sd	ra,72(sp)
    80001a6e:	e0a2                	sd	s0,64(sp)
    80001a70:	fc26                	sd	s1,56(sp)
    80001a72:	f84a                	sd	s2,48(sp)
    80001a74:	f44e                	sd	s3,40(sp)
    80001a76:	f052                	sd	s4,32(sp)
    80001a78:	ec56                	sd	s5,24(sp)
    80001a7a:	e85a                	sd	s6,16(sp)
    80001a7c:	e45e                	sd	s7,8(sp)
    80001a7e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a80:	00006517          	auipc	a0,0x6
    80001a84:	5c850513          	addi	a0,a0,1480 # 80008048 <etext+0x48>
    80001a88:	00004097          	auipc	ra,0x4
    80001a8c:	5e8080e7          	jalr	1512(ra) # 80006070 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a90:	00008497          	auipc	s1,0x8
    80001a94:	b4848493          	addi	s1,s1,-1208 # 800095d8 <proc+0x158>
    80001a98:	0000f917          	auipc	s2,0xf
    80001a9c:	54090913          	addi	s2,s2,1344 # 80010fd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aa0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001aa2:	00006997          	auipc	s3,0x6
    80001aa6:	72698993          	addi	s3,s3,1830 # 800081c8 <etext+0x1c8>
    printf("%d %s %s", p->pid, state, p->name);
    80001aaa:	00006a97          	auipc	s5,0x6
    80001aae:	726a8a93          	addi	s5,s5,1830 # 800081d0 <etext+0x1d0>
    printf("\n");
    80001ab2:	00006a17          	auipc	s4,0x6
    80001ab6:	596a0a13          	addi	s4,s4,1430 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aba:	00006b97          	auipc	s7,0x6
    80001abe:	74eb8b93          	addi	s7,s7,1870 # 80008208 <states.1792>
    80001ac2:	a00d                	j	80001ae4 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ac4:	ed86a583          	lw	a1,-296(a3)
    80001ac8:	8556                	mv	a0,s5
    80001aca:	00004097          	auipc	ra,0x4
    80001ace:	5a6080e7          	jalr	1446(ra) # 80006070 <printf>
    printf("\n");
    80001ad2:	8552                	mv	a0,s4
    80001ad4:	00004097          	auipc	ra,0x4
    80001ad8:	59c080e7          	jalr	1436(ra) # 80006070 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001adc:	1e848493          	addi	s1,s1,488
    80001ae0:	03248163          	beq	s1,s2,80001b02 <procdump+0x98>
    if(p->state == UNUSED)
    80001ae4:	86a6                	mv	a3,s1
    80001ae6:	ec04a783          	lw	a5,-320(s1)
    80001aea:	dbed                	beqz	a5,80001adc <procdump+0x72>
      state = "???";
    80001aec:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aee:	fcfb6be3          	bltu	s6,a5,80001ac4 <procdump+0x5a>
    80001af2:	1782                	slli	a5,a5,0x20
    80001af4:	9381                	srli	a5,a5,0x20
    80001af6:	078e                	slli	a5,a5,0x3
    80001af8:	97de                	add	a5,a5,s7
    80001afa:	6390                	ld	a2,0(a5)
    80001afc:	f661                	bnez	a2,80001ac4 <procdump+0x5a>
      state = "???";
    80001afe:	864e                	mv	a2,s3
    80001b00:	b7d1                	j	80001ac4 <procdump+0x5a>
  }
}
    80001b02:	60a6                	ld	ra,72(sp)
    80001b04:	6406                	ld	s0,64(sp)
    80001b06:	74e2                	ld	s1,56(sp)
    80001b08:	7942                	ld	s2,48(sp)
    80001b0a:	79a2                	ld	s3,40(sp)
    80001b0c:	7a02                	ld	s4,32(sp)
    80001b0e:	6ae2                	ld	s5,24(sp)
    80001b10:	6b42                	ld	s6,16(sp)
    80001b12:	6ba2                	ld	s7,8(sp)
    80001b14:	6161                	addi	sp,sp,80
    80001b16:	8082                	ret

0000000080001b18 <swtch>:
    80001b18:	00153023          	sd	ra,0(a0)
    80001b1c:	00253423          	sd	sp,8(a0)
    80001b20:	e900                	sd	s0,16(a0)
    80001b22:	ed04                	sd	s1,24(a0)
    80001b24:	03253023          	sd	s2,32(a0)
    80001b28:	03353423          	sd	s3,40(a0)
    80001b2c:	03453823          	sd	s4,48(a0)
    80001b30:	03553c23          	sd	s5,56(a0)
    80001b34:	05653023          	sd	s6,64(a0)
    80001b38:	05753423          	sd	s7,72(a0)
    80001b3c:	05853823          	sd	s8,80(a0)
    80001b40:	05953c23          	sd	s9,88(a0)
    80001b44:	07a53023          	sd	s10,96(a0)
    80001b48:	07b53423          	sd	s11,104(a0)
    80001b4c:	0005b083          	ld	ra,0(a1)
    80001b50:	0085b103          	ld	sp,8(a1)
    80001b54:	6980                	ld	s0,16(a1)
    80001b56:	6d84                	ld	s1,24(a1)
    80001b58:	0205b903          	ld	s2,32(a1)
    80001b5c:	0285b983          	ld	s3,40(a1)
    80001b60:	0305ba03          	ld	s4,48(a1)
    80001b64:	0385ba83          	ld	s5,56(a1)
    80001b68:	0405bb03          	ld	s6,64(a1)
    80001b6c:	0485bb83          	ld	s7,72(a1)
    80001b70:	0505bc03          	ld	s8,80(a1)
    80001b74:	0585bc83          	ld	s9,88(a1)
    80001b78:	0605bd03          	ld	s10,96(a1)
    80001b7c:	0685bd83          	ld	s11,104(a1)
    80001b80:	8082                	ret

0000000080001b82 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b82:	1141                	addi	sp,sp,-16
    80001b84:	e406                	sd	ra,8(sp)
    80001b86:	e022                	sd	s0,0(sp)
    80001b88:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b8a:	00006597          	auipc	a1,0x6
    80001b8e:	6ae58593          	addi	a1,a1,1710 # 80008238 <states.1792+0x30>
    80001b92:	0000f517          	auipc	a0,0xf
    80001b96:	2ee50513          	addi	a0,a0,750 # 80010e80 <tickslock>
    80001b9a:	00005097          	auipc	ra,0x5
    80001b9e:	946080e7          	jalr	-1722(ra) # 800064e0 <initlock>
}
    80001ba2:	60a2                	ld	ra,8(sp)
    80001ba4:	6402                	ld	s0,0(sp)
    80001ba6:	0141                	addi	sp,sp,16
    80001ba8:	8082                	ret

0000000080001baa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001baa:	1141                	addi	sp,sp,-16
    80001bac:	e422                	sd	s0,8(sp)
    80001bae:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bb0:	00003797          	auipc	a5,0x3
    80001bb4:	7e078793          	addi	a5,a5,2016 # 80005390 <kernelvec>
    80001bb8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bbc:	6422                	ld	s0,8(sp)
    80001bbe:	0141                	addi	sp,sp,16
    80001bc0:	8082                	ret

0000000080001bc2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bc2:	1141                	addi	sp,sp,-16
    80001bc4:	e406                	sd	ra,8(sp)
    80001bc6:	e022                	sd	s0,0(sp)
    80001bc8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bca:	fffff097          	auipc	ra,0xfffff
    80001bce:	26c080e7          	jalr	620(ra) # 80000e36 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bd2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bd6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bd8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001bdc:	00005617          	auipc	a2,0x5
    80001be0:	42460613          	addi	a2,a2,1060 # 80007000 <_trampoline>
    80001be4:	00005697          	auipc	a3,0x5
    80001be8:	41c68693          	addi	a3,a3,1052 # 80007000 <_trampoline>
    80001bec:	8e91                	sub	a3,a3,a2
    80001bee:	040007b7          	lui	a5,0x4000
    80001bf2:	17fd                	addi	a5,a5,-1
    80001bf4:	07b2                	slli	a5,a5,0xc
    80001bf6:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bf8:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bfc:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bfe:	180026f3          	csrr	a3,satp
    80001c02:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c04:	6d38                	ld	a4,88(a0)
    80001c06:	6134                	ld	a3,64(a0)
    80001c08:	6585                	lui	a1,0x1
    80001c0a:	96ae                	add	a3,a3,a1
    80001c0c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c0e:	6d38                	ld	a4,88(a0)
    80001c10:	00000697          	auipc	a3,0x0
    80001c14:	05068693          	addi	a3,a3,80 # 80001c60 <usertrap>
    80001c18:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c1a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c1c:	8692                	mv	a3,tp
    80001c1e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c20:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c24:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c28:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c2c:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c30:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c32:	6f18                	ld	a4,24(a4)
    80001c34:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c38:	692c                	ld	a1,80(a0)
    80001c3a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c3c:	00005717          	auipc	a4,0x5
    80001c40:	45470713          	addi	a4,a4,1108 # 80007090 <userret>
    80001c44:	8f11                	sub	a4,a4,a2
    80001c46:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c48:	577d                	li	a4,-1
    80001c4a:	177e                	slli	a4,a4,0x3f
    80001c4c:	8dd9                	or	a1,a1,a4
    80001c4e:	02000537          	lui	a0,0x2000
    80001c52:	157d                	addi	a0,a0,-1
    80001c54:	0536                	slli	a0,a0,0xd
    80001c56:	9782                	jalr	a5
}
    80001c58:	60a2                	ld	ra,8(sp)
    80001c5a:	6402                	ld	s0,0(sp)
    80001c5c:	0141                	addi	sp,sp,16
    80001c5e:	8082                	ret

0000000080001c60 <usertrap>:
{
    80001c60:	7139                	addi	sp,sp,-64
    80001c62:	fc06                	sd	ra,56(sp)
    80001c64:	f822                	sd	s0,48(sp)
    80001c66:	f426                	sd	s1,40(sp)
    80001c68:	f04a                	sd	s2,32(sp)
    80001c6a:	ec4e                	sd	s3,24(sp)
    80001c6c:	e852                	sd	s4,16(sp)
    80001c6e:	e456                	sd	s5,8(sp)
    80001c70:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c72:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c76:	1007f793          	andi	a5,a5,256
    80001c7a:	e7b9                	bnez	a5,80001cc8 <usertrap+0x68>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c7c:	00003797          	auipc	a5,0x3
    80001c80:	71478793          	addi	a5,a5,1812 # 80005390 <kernelvec>
    80001c84:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c88:	fffff097          	auipc	ra,0xfffff
    80001c8c:	1ae080e7          	jalr	430(ra) # 80000e36 <myproc>
    80001c90:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c92:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c94:	14102773          	csrr	a4,sepc
    80001c98:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c9a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c9e:	47a1                	li	a5,8
    80001ca0:	02f70c63          	beq	a4,a5,80001cd8 <usertrap+0x78>
    80001ca4:	14202773          	csrr	a4,scause
  else if(r_scause()==13||r_scause()==15){
    80001ca8:	47b5                	li	a5,13
    80001caa:	06f70c63          	beq	a4,a5,80001d22 <usertrap+0xc2>
    80001cae:	14202773          	csrr	a4,scause
    80001cb2:	47bd                	li	a5,15
    80001cb4:	06f70763          	beq	a4,a5,80001d22 <usertrap+0xc2>
    p->killed = 1;
    80001cb8:	4785                	li	a5,1
    80001cba:	d51c                	sw	a5,40(a0)
    exit(-1);
    80001cbc:	557d                	li	a0,-1
    80001cbe:	00000097          	auipc	ra,0x0
    80001cc2:	b24080e7          	jalr	-1244(ra) # 800017e2 <exit>
    80001cc6:	a81d                	j	80001cfc <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001cc8:	00006517          	auipc	a0,0x6
    80001ccc:	57850513          	addi	a0,a0,1400 # 80008240 <states.1792+0x38>
    80001cd0:	00004097          	auipc	ra,0x4
    80001cd4:	356080e7          	jalr	854(ra) # 80006026 <panic>
    if(p->killed)
    80001cd8:	551c                	lw	a5,40(a0)
    80001cda:	ef95                	bnez	a5,80001d16 <usertrap+0xb6>
    p->trapframe->epc += 4;
    80001cdc:	6cb8                	ld	a4,88(s1)
    80001cde:	6f1c                	ld	a5,24(a4)
    80001ce0:	0791                	addi	a5,a5,4
    80001ce2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ce8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cec:	10079073          	csrw	sstatus,a5
    syscall();
    80001cf0:	00000097          	auipc	ra,0x0
    80001cf4:	448080e7          	jalr	1096(ra) # 80002138 <syscall>
  if(p->killed)
    80001cf8:	549c                	lw	a5,40(s1)
    80001cfa:	f3e9                	bnez	a5,80001cbc <usertrap+0x5c>
  usertrapret();
    80001cfc:	00000097          	auipc	ra,0x0
    80001d00:	ec6080e7          	jalr	-314(ra) # 80001bc2 <usertrapret>
}
    80001d04:	70e2                	ld	ra,56(sp)
    80001d06:	7442                	ld	s0,48(sp)
    80001d08:	74a2                	ld	s1,40(sp)
    80001d0a:	7902                	ld	s2,32(sp)
    80001d0c:	69e2                	ld	s3,24(sp)
    80001d0e:	6a42                	ld	s4,16(sp)
    80001d10:	6aa2                	ld	s5,8(sp)
    80001d12:	6121                	addi	sp,sp,64
    80001d14:	8082                	ret
      exit(-1);
    80001d16:	557d                	li	a0,-1
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	aca080e7          	jalr	-1334(ra) # 800017e2 <exit>
    80001d20:	bf75                	j	80001cdc <usertrap+0x7c>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d22:	14302a73          	csrr	s4,stval
    if(stval>=p->sz)
    80001d26:	64bc                	ld	a5,72(s1)
    80001d28:	00fa6563          	bltu	s4,a5,80001d32 <usertrap+0xd2>
	    p->killed=1;
    80001d2c:	4785                	li	a5,1
    80001d2e:	d49c                	sw	a5,40(s1)
    80001d30:	b771                	j	80001cbc <usertrap+0x5c>
	    uint64 protectTop=PGROUNDDOWN(p->trapframe->sp);
    80001d32:	6cbc                	ld	a5,88(s1)
    80001d34:	76fd                	lui	a3,0xfffff
    80001d36:	7b98                	ld	a4,48(a5)
    80001d38:	8f75                	and	a4,a4,a3
	    uint64 stvalTop =PGROUNDUP(stval);
    80001d3a:	6785                	lui	a5,0x1
    80001d3c:	17fd                	addi	a5,a5,-1
    80001d3e:	97d2                	add	a5,a5,s4
    80001d40:	8ff5                	and	a5,a5,a3
	    if(protectTop!=stvalTop)
    80001d42:	faf70be3          	beq	a4,a5,80001cf8 <usertrap+0x98>
    80001d46:	16848713          	addi	a4,s1,360
		    for(i=0;i<NOFILE;i++)
    80001d4a:	4781                	li	a5,0
    80001d4c:	4641                	li	a2,16
    80001d4e:	a029                	j	80001d58 <usertrap+0xf8>
    80001d50:	2785                	addiw	a5,a5,1
    80001d52:	0721                	addi	a4,a4,8
    80001d54:	fac782e3          	beq	a5,a2,80001cf8 <usertrap+0x98>
			    if(p->areaps[i]==0)
    80001d58:	00073903          	ld	s2,0(a4)
    80001d5c:	fe090ae3          	beqz	s2,80001d50 <usertrap+0xf0>
			    addr=(uint64)(p->areaps[i]->addr);
    80001d60:	00093983          	ld	s3,0(s2)
			    if(addr<=stval&&stval<addr+p->areaps[i]->length)
    80001d64:	ff3a66e3          	bltu	s4,s3,80001d50 <usertrap+0xf0>
    80001d68:	00893683          	ld	a3,8(s2)
    80001d6c:	96ce                	add	a3,a3,s3
    80001d6e:	feda71e3          	bgeu	s4,a3,80001d50 <usertrap+0xf0>
		    if(i!=NOFILE)
    80001d72:	4741                	li	a4,16
    80001d74:	f8e782e3          	beq	a5,a4,80001cf8 <usertrap+0x98>
			    char* mem=kalloc();
    80001d78:	ffffe097          	auipc	ra,0xffffe
    80001d7c:	3a0080e7          	jalr	928(ra) # 80000118 <kalloc>
    80001d80:	8aaa                	mv	s5,a0
			    if(mem==0)
    80001d82:	c159                	beqz	a0,80001e08 <usertrap+0x1a8>
				    memset(mem,0,PGSIZE);
    80001d84:	6605                	lui	a2,0x1
    80001d86:	4581                	li	a1,0
    80001d88:	ffffe097          	auipc	ra,0xffffe
    80001d8c:	3f0080e7          	jalr	1008(ra) # 80000178 <memset>
				    ilock(vmap->file->ip);
    80001d90:	01893783          	ld	a5,24(s2)
    80001d94:	6f88                	ld	a0,24(a5)
    80001d96:	00001097          	auipc	ra,0x1
    80001d9a:	ea0080e7          	jalr	-352(ra) # 80002c36 <ilock>
				    readi(vmap->file->ip,0,(uint64)mem,PGROUNDDOWN(stval-addr),PGSIZE);
    80001d9e:	413a09bb          	subw	s3,s4,s3
    80001da2:	76fd                	lui	a3,0xfffff
    80001da4:	00d9f6b3          	and	a3,s3,a3
    80001da8:	01893783          	ld	a5,24(s2)
    80001dac:	6705                	lui	a4,0x1
    80001dae:	2681                	sext.w	a3,a3
    80001db0:	8656                	mv	a2,s5
    80001db2:	4581                	li	a1,0
    80001db4:	6f88                	ld	a0,24(a5)
    80001db6:	00001097          	auipc	ra,0x1
    80001dba:	134080e7          	jalr	308(ra) # 80002eea <readi>
				    iunlock(vmap->file->ip);
    80001dbe:	01893783          	ld	a5,24(s2)
    80001dc2:	6f88                	ld	a0,24(a5)
    80001dc4:	00001097          	auipc	ra,0x1
    80001dc8:	f34080e7          	jalr	-204(ra) # 80002cf8 <iunlock>
				    if(vmap->prot&PROT_READ)
    80001dcc:	01094783          	lbu	a5,16(s2)
    80001dd0:	0017f693          	andi	a3,a5,1
			    int prot=PTE_U;
    80001dd4:	4741                	li	a4,16
				    if(vmap->prot&PROT_READ)
    80001dd6:	c291                	beqz	a3,80001dda <usertrap+0x17a>
					    prot |= PTE_R;
    80001dd8:	4749                	li	a4,18
				    if(vmap->prot&PROT_WRITE)
    80001dda:	8b89                	andi	a5,a5,2
    80001ddc:	c399                	beqz	a5,80001de2 <usertrap+0x182>
					    prot |= PTE_W;
    80001dde:	00476713          	ori	a4,a4,4
				    if(mappages(p->pagetable,PGROUNDDOWN(stval),PGSIZE,(uint64)mem,prot)!=0)
    80001de2:	86d6                	mv	a3,s5
    80001de4:	6605                	lui	a2,0x1
    80001de6:	75fd                	lui	a1,0xfffff
    80001de8:	00ba75b3          	and	a1,s4,a1
    80001dec:	68a8                	ld	a0,80(s1)
    80001dee:	ffffe097          	auipc	ra,0xffffe
    80001df2:	762080e7          	jalr	1890(ra) # 80000550 <mappages>
    80001df6:	d109                	beqz	a0,80001cf8 <usertrap+0x98>
					    kfree(mem);
    80001df8:	8556                	mv	a0,s5
    80001dfa:	ffffe097          	auipc	ra,0xffffe
    80001dfe:	222080e7          	jalr	546(ra) # 8000001c <kfree>
					    p->killed=1;
    80001e02:	4785                	li	a5,1
    80001e04:	d49c                	sw	a5,40(s1)
    80001e06:	bd5d                	j	80001cbc <usertrap+0x5c>
				    p->killed=1;
    80001e08:	4785                	li	a5,1
    80001e0a:	d49c                	sw	a5,40(s1)
    80001e0c:	bd45                	j	80001cbc <usertrap+0x5c>

0000000080001e0e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001e0e:	1101                	addi	sp,sp,-32
    80001e10:	ec06                	sd	ra,24(sp)
    80001e12:	e822                	sd	s0,16(sp)
    80001e14:	e426                	sd	s1,8(sp)
    80001e16:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001e18:	0000f497          	auipc	s1,0xf
    80001e1c:	06848493          	addi	s1,s1,104 # 80010e80 <tickslock>
    80001e20:	8526                	mv	a0,s1
    80001e22:	00004097          	auipc	ra,0x4
    80001e26:	74e080e7          	jalr	1870(ra) # 80006570 <acquire>
  ticks++;
    80001e2a:	00007517          	auipc	a0,0x7
    80001e2e:	1ee50513          	addi	a0,a0,494 # 80009018 <ticks>
    80001e32:	411c                	lw	a5,0(a0)
    80001e34:	2785                	addiw	a5,a5,1
    80001e36:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e38:	00000097          	auipc	ra,0x0
    80001e3c:	8da080e7          	jalr	-1830(ra) # 80001712 <wakeup>
  release(&tickslock);
    80001e40:	8526                	mv	a0,s1
    80001e42:	00004097          	auipc	ra,0x4
    80001e46:	7e2080e7          	jalr	2018(ra) # 80006624 <release>
}
    80001e4a:	60e2                	ld	ra,24(sp)
    80001e4c:	6442                	ld	s0,16(sp)
    80001e4e:	64a2                	ld	s1,8(sp)
    80001e50:	6105                	addi	sp,sp,32
    80001e52:	8082                	ret

0000000080001e54 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001e54:	1101                	addi	sp,sp,-32
    80001e56:	ec06                	sd	ra,24(sp)
    80001e58:	e822                	sd	s0,16(sp)
    80001e5a:	e426                	sd	s1,8(sp)
    80001e5c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e5e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001e62:	00074d63          	bltz	a4,80001e7c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001e66:	57fd                	li	a5,-1
    80001e68:	17fe                	slli	a5,a5,0x3f
    80001e6a:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e6c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e6e:	06f70363          	beq	a4,a5,80001ed4 <devintr+0x80>
  }
}
    80001e72:	60e2                	ld	ra,24(sp)
    80001e74:	6442                	ld	s0,16(sp)
    80001e76:	64a2                	ld	s1,8(sp)
    80001e78:	6105                	addi	sp,sp,32
    80001e7a:	8082                	ret
     (scause & 0xff) == 9){
    80001e7c:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001e80:	46a5                	li	a3,9
    80001e82:	fed792e3          	bne	a5,a3,80001e66 <devintr+0x12>
    int irq = plic_claim();
    80001e86:	00003097          	auipc	ra,0x3
    80001e8a:	612080e7          	jalr	1554(ra) # 80005498 <plic_claim>
    80001e8e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e90:	47a9                	li	a5,10
    80001e92:	02f50763          	beq	a0,a5,80001ec0 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001e96:	4785                	li	a5,1
    80001e98:	02f50963          	beq	a0,a5,80001eca <devintr+0x76>
    return 1;
    80001e9c:	4505                	li	a0,1
    } else if(irq){
    80001e9e:	d8f1                	beqz	s1,80001e72 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001ea0:	85a6                	mv	a1,s1
    80001ea2:	00006517          	auipc	a0,0x6
    80001ea6:	3be50513          	addi	a0,a0,958 # 80008260 <states.1792+0x58>
    80001eaa:	00004097          	auipc	ra,0x4
    80001eae:	1c6080e7          	jalr	454(ra) # 80006070 <printf>
      plic_complete(irq);
    80001eb2:	8526                	mv	a0,s1
    80001eb4:	00003097          	auipc	ra,0x3
    80001eb8:	608080e7          	jalr	1544(ra) # 800054bc <plic_complete>
    return 1;
    80001ebc:	4505                	li	a0,1
    80001ebe:	bf55                	j	80001e72 <devintr+0x1e>
      uartintr();
    80001ec0:	00004097          	auipc	ra,0x4
    80001ec4:	5d0080e7          	jalr	1488(ra) # 80006490 <uartintr>
    80001ec8:	b7ed                	j	80001eb2 <devintr+0x5e>
      virtio_disk_intr();
    80001eca:	00004097          	auipc	ra,0x4
    80001ece:	ad2080e7          	jalr	-1326(ra) # 8000599c <virtio_disk_intr>
    80001ed2:	b7c5                	j	80001eb2 <devintr+0x5e>
    if(cpuid() == 0){
    80001ed4:	fffff097          	auipc	ra,0xfffff
    80001ed8:	f36080e7          	jalr	-202(ra) # 80000e0a <cpuid>
    80001edc:	c901                	beqz	a0,80001eec <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ede:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ee2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ee4:	14479073          	csrw	sip,a5
    return 2;
    80001ee8:	4509                	li	a0,2
    80001eea:	b761                	j	80001e72 <devintr+0x1e>
      clockintr();
    80001eec:	00000097          	auipc	ra,0x0
    80001ef0:	f22080e7          	jalr	-222(ra) # 80001e0e <clockintr>
    80001ef4:	b7ed                	j	80001ede <devintr+0x8a>

0000000080001ef6 <kerneltrap>:
{
    80001ef6:	7179                	addi	sp,sp,-48
    80001ef8:	f406                	sd	ra,40(sp)
    80001efa:	f022                	sd	s0,32(sp)
    80001efc:	ec26                	sd	s1,24(sp)
    80001efe:	e84a                	sd	s2,16(sp)
    80001f00:	e44e                	sd	s3,8(sp)
    80001f02:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f04:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f08:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f0c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f10:	1004f793          	andi	a5,s1,256
    80001f14:	cb85                	beqz	a5,80001f44 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f16:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f1a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f1c:	ef85                	bnez	a5,80001f54 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f1e:	00000097          	auipc	ra,0x0
    80001f22:	f36080e7          	jalr	-202(ra) # 80001e54 <devintr>
    80001f26:	cd1d                	beqz	a0,80001f64 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f28:	4789                	li	a5,2
    80001f2a:	06f50a63          	beq	a0,a5,80001f9e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f2e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f32:	10049073          	csrw	sstatus,s1
}
    80001f36:	70a2                	ld	ra,40(sp)
    80001f38:	7402                	ld	s0,32(sp)
    80001f3a:	64e2                	ld	s1,24(sp)
    80001f3c:	6942                	ld	s2,16(sp)
    80001f3e:	69a2                	ld	s3,8(sp)
    80001f40:	6145                	addi	sp,sp,48
    80001f42:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f44:	00006517          	auipc	a0,0x6
    80001f48:	33c50513          	addi	a0,a0,828 # 80008280 <states.1792+0x78>
    80001f4c:	00004097          	auipc	ra,0x4
    80001f50:	0da080e7          	jalr	218(ra) # 80006026 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f54:	00006517          	auipc	a0,0x6
    80001f58:	35450513          	addi	a0,a0,852 # 800082a8 <states.1792+0xa0>
    80001f5c:	00004097          	auipc	ra,0x4
    80001f60:	0ca080e7          	jalr	202(ra) # 80006026 <panic>
    printf("scause %p\n", scause);
    80001f64:	85ce                	mv	a1,s3
    80001f66:	00006517          	auipc	a0,0x6
    80001f6a:	36250513          	addi	a0,a0,866 # 800082c8 <states.1792+0xc0>
    80001f6e:	00004097          	auipc	ra,0x4
    80001f72:	102080e7          	jalr	258(ra) # 80006070 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f76:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f7a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f7e:	00006517          	auipc	a0,0x6
    80001f82:	35a50513          	addi	a0,a0,858 # 800082d8 <states.1792+0xd0>
    80001f86:	00004097          	auipc	ra,0x4
    80001f8a:	0ea080e7          	jalr	234(ra) # 80006070 <printf>
    panic("kerneltrap");
    80001f8e:	00006517          	auipc	a0,0x6
    80001f92:	36250513          	addi	a0,a0,866 # 800082f0 <states.1792+0xe8>
    80001f96:	00004097          	auipc	ra,0x4
    80001f9a:	090080e7          	jalr	144(ra) # 80006026 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f9e:	fffff097          	auipc	ra,0xfffff
    80001fa2:	e98080e7          	jalr	-360(ra) # 80000e36 <myproc>
    80001fa6:	d541                	beqz	a0,80001f2e <kerneltrap+0x38>
    80001fa8:	fffff097          	auipc	ra,0xfffff
    80001fac:	e8e080e7          	jalr	-370(ra) # 80000e36 <myproc>
    80001fb0:	4d18                	lw	a4,24(a0)
    80001fb2:	4791                	li	a5,4
    80001fb4:	f6f71de3          	bne	a4,a5,80001f2e <kerneltrap+0x38>
    yield();
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	592080e7          	jalr	1426(ra) # 8000154a <yield>
    80001fc0:	b7bd                	j	80001f2e <kerneltrap+0x38>

0000000080001fc2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fc2:	1101                	addi	sp,sp,-32
    80001fc4:	ec06                	sd	ra,24(sp)
    80001fc6:	e822                	sd	s0,16(sp)
    80001fc8:	e426                	sd	s1,8(sp)
    80001fca:	1000                	addi	s0,sp,32
    80001fcc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fce:	fffff097          	auipc	ra,0xfffff
    80001fd2:	e68080e7          	jalr	-408(ra) # 80000e36 <myproc>
  switch (n) {
    80001fd6:	4795                	li	a5,5
    80001fd8:	0497e163          	bltu	a5,s1,8000201a <argraw+0x58>
    80001fdc:	048a                	slli	s1,s1,0x2
    80001fde:	00006717          	auipc	a4,0x6
    80001fe2:	34a70713          	addi	a4,a4,842 # 80008328 <states.1792+0x120>
    80001fe6:	94ba                	add	s1,s1,a4
    80001fe8:	409c                	lw	a5,0(s1)
    80001fea:	97ba                	add	a5,a5,a4
    80001fec:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fee:	6d3c                	ld	a5,88(a0)
    80001ff0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ff2:	60e2                	ld	ra,24(sp)
    80001ff4:	6442                	ld	s0,16(sp)
    80001ff6:	64a2                	ld	s1,8(sp)
    80001ff8:	6105                	addi	sp,sp,32
    80001ffa:	8082                	ret
    return p->trapframe->a1;
    80001ffc:	6d3c                	ld	a5,88(a0)
    80001ffe:	7fa8                	ld	a0,120(a5)
    80002000:	bfcd                	j	80001ff2 <argraw+0x30>
    return p->trapframe->a2;
    80002002:	6d3c                	ld	a5,88(a0)
    80002004:	63c8                	ld	a0,128(a5)
    80002006:	b7f5                	j	80001ff2 <argraw+0x30>
    return p->trapframe->a3;
    80002008:	6d3c                	ld	a5,88(a0)
    8000200a:	67c8                	ld	a0,136(a5)
    8000200c:	b7dd                	j	80001ff2 <argraw+0x30>
    return p->trapframe->a4;
    8000200e:	6d3c                	ld	a5,88(a0)
    80002010:	6bc8                	ld	a0,144(a5)
    80002012:	b7c5                	j	80001ff2 <argraw+0x30>
    return p->trapframe->a5;
    80002014:	6d3c                	ld	a5,88(a0)
    80002016:	6fc8                	ld	a0,152(a5)
    80002018:	bfe9                	j	80001ff2 <argraw+0x30>
  panic("argraw");
    8000201a:	00006517          	auipc	a0,0x6
    8000201e:	2e650513          	addi	a0,a0,742 # 80008300 <states.1792+0xf8>
    80002022:	00004097          	auipc	ra,0x4
    80002026:	004080e7          	jalr	4(ra) # 80006026 <panic>

000000008000202a <fetchaddr>:
{
    8000202a:	1101                	addi	sp,sp,-32
    8000202c:	ec06                	sd	ra,24(sp)
    8000202e:	e822                	sd	s0,16(sp)
    80002030:	e426                	sd	s1,8(sp)
    80002032:	e04a                	sd	s2,0(sp)
    80002034:	1000                	addi	s0,sp,32
    80002036:	84aa                	mv	s1,a0
    80002038:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000203a:	fffff097          	auipc	ra,0xfffff
    8000203e:	dfc080e7          	jalr	-516(ra) # 80000e36 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002042:	653c                	ld	a5,72(a0)
    80002044:	02f4f863          	bgeu	s1,a5,80002074 <fetchaddr+0x4a>
    80002048:	00848713          	addi	a4,s1,8
    8000204c:	02e7e663          	bltu	a5,a4,80002078 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002050:	46a1                	li	a3,8
    80002052:	8626                	mv	a2,s1
    80002054:	85ca                	mv	a1,s2
    80002056:	6928                	ld	a0,80(a0)
    80002058:	fffff097          	auipc	ra,0xfffff
    8000205c:	b2c080e7          	jalr	-1236(ra) # 80000b84 <copyin>
    80002060:	00a03533          	snez	a0,a0
    80002064:	40a00533          	neg	a0,a0
}
    80002068:	60e2                	ld	ra,24(sp)
    8000206a:	6442                	ld	s0,16(sp)
    8000206c:	64a2                	ld	s1,8(sp)
    8000206e:	6902                	ld	s2,0(sp)
    80002070:	6105                	addi	sp,sp,32
    80002072:	8082                	ret
    return -1;
    80002074:	557d                	li	a0,-1
    80002076:	bfcd                	j	80002068 <fetchaddr+0x3e>
    80002078:	557d                	li	a0,-1
    8000207a:	b7fd                	j	80002068 <fetchaddr+0x3e>

000000008000207c <fetchstr>:
{
    8000207c:	7179                	addi	sp,sp,-48
    8000207e:	f406                	sd	ra,40(sp)
    80002080:	f022                	sd	s0,32(sp)
    80002082:	ec26                	sd	s1,24(sp)
    80002084:	e84a                	sd	s2,16(sp)
    80002086:	e44e                	sd	s3,8(sp)
    80002088:	1800                	addi	s0,sp,48
    8000208a:	892a                	mv	s2,a0
    8000208c:	84ae                	mv	s1,a1
    8000208e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002090:	fffff097          	auipc	ra,0xfffff
    80002094:	da6080e7          	jalr	-602(ra) # 80000e36 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002098:	86ce                	mv	a3,s3
    8000209a:	864a                	mv	a2,s2
    8000209c:	85a6                	mv	a1,s1
    8000209e:	6928                	ld	a0,80(a0)
    800020a0:	fffff097          	auipc	ra,0xfffff
    800020a4:	b70080e7          	jalr	-1168(ra) # 80000c10 <copyinstr>
  if(err < 0)
    800020a8:	00054763          	bltz	a0,800020b6 <fetchstr+0x3a>
  return strlen(buf);
    800020ac:	8526                	mv	a0,s1
    800020ae:	ffffe097          	auipc	ra,0xffffe
    800020b2:	24e080e7          	jalr	590(ra) # 800002fc <strlen>
}
    800020b6:	70a2                	ld	ra,40(sp)
    800020b8:	7402                	ld	s0,32(sp)
    800020ba:	64e2                	ld	s1,24(sp)
    800020bc:	6942                	ld	s2,16(sp)
    800020be:	69a2                	ld	s3,8(sp)
    800020c0:	6145                	addi	sp,sp,48
    800020c2:	8082                	ret

00000000800020c4 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020c4:	1101                	addi	sp,sp,-32
    800020c6:	ec06                	sd	ra,24(sp)
    800020c8:	e822                	sd	s0,16(sp)
    800020ca:	e426                	sd	s1,8(sp)
    800020cc:	1000                	addi	s0,sp,32
    800020ce:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020d0:	00000097          	auipc	ra,0x0
    800020d4:	ef2080e7          	jalr	-270(ra) # 80001fc2 <argraw>
    800020d8:	c088                	sw	a0,0(s1)
  return 0;
}
    800020da:	4501                	li	a0,0
    800020dc:	60e2                	ld	ra,24(sp)
    800020de:	6442                	ld	s0,16(sp)
    800020e0:	64a2                	ld	s1,8(sp)
    800020e2:	6105                	addi	sp,sp,32
    800020e4:	8082                	ret

00000000800020e6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020e6:	1101                	addi	sp,sp,-32
    800020e8:	ec06                	sd	ra,24(sp)
    800020ea:	e822                	sd	s0,16(sp)
    800020ec:	e426                	sd	s1,8(sp)
    800020ee:	1000                	addi	s0,sp,32
    800020f0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020f2:	00000097          	auipc	ra,0x0
    800020f6:	ed0080e7          	jalr	-304(ra) # 80001fc2 <argraw>
    800020fa:	e088                	sd	a0,0(s1)
  return 0;
}
    800020fc:	4501                	li	a0,0
    800020fe:	60e2                	ld	ra,24(sp)
    80002100:	6442                	ld	s0,16(sp)
    80002102:	64a2                	ld	s1,8(sp)
    80002104:	6105                	addi	sp,sp,32
    80002106:	8082                	ret

0000000080002108 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002108:	1101                	addi	sp,sp,-32
    8000210a:	ec06                	sd	ra,24(sp)
    8000210c:	e822                	sd	s0,16(sp)
    8000210e:	e426                	sd	s1,8(sp)
    80002110:	e04a                	sd	s2,0(sp)
    80002112:	1000                	addi	s0,sp,32
    80002114:	84ae                	mv	s1,a1
    80002116:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002118:	00000097          	auipc	ra,0x0
    8000211c:	eaa080e7          	jalr	-342(ra) # 80001fc2 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002120:	864a                	mv	a2,s2
    80002122:	85a6                	mv	a1,s1
    80002124:	00000097          	auipc	ra,0x0
    80002128:	f58080e7          	jalr	-168(ra) # 8000207c <fetchstr>
}
    8000212c:	60e2                	ld	ra,24(sp)
    8000212e:	6442                	ld	s0,16(sp)
    80002130:	64a2                	ld	s1,8(sp)
    80002132:	6902                	ld	s2,0(sp)
    80002134:	6105                	addi	sp,sp,32
    80002136:	8082                	ret

0000000080002138 <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    80002138:	1101                	addi	sp,sp,-32
    8000213a:	ec06                	sd	ra,24(sp)
    8000213c:	e822                	sd	s0,16(sp)
    8000213e:	e426                	sd	s1,8(sp)
    80002140:	e04a                	sd	s2,0(sp)
    80002142:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	cf2080e7          	jalr	-782(ra) # 80000e36 <myproc>
    8000214c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000214e:	05853903          	ld	s2,88(a0)
    80002152:	0a893783          	ld	a5,168(s2)
    80002156:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000215a:	37fd                	addiw	a5,a5,-1
    8000215c:	4759                	li	a4,22
    8000215e:	00f76f63          	bltu	a4,a5,8000217c <syscall+0x44>
    80002162:	00369713          	slli	a4,a3,0x3
    80002166:	00006797          	auipc	a5,0x6
    8000216a:	1da78793          	addi	a5,a5,474 # 80008340 <syscalls>
    8000216e:	97ba                	add	a5,a5,a4
    80002170:	639c                	ld	a5,0(a5)
    80002172:	c789                	beqz	a5,8000217c <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002174:	9782                	jalr	a5
    80002176:	06a93823          	sd	a0,112(s2)
    8000217a:	a839                	j	80002198 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000217c:	15848613          	addi	a2,s1,344
    80002180:	588c                	lw	a1,48(s1)
    80002182:	00006517          	auipc	a0,0x6
    80002186:	18650513          	addi	a0,a0,390 # 80008308 <states.1792+0x100>
    8000218a:	00004097          	auipc	ra,0x4
    8000218e:	ee6080e7          	jalr	-282(ra) # 80006070 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002192:	6cbc                	ld	a5,88(s1)
    80002194:	577d                	li	a4,-1
    80002196:	fbb8                	sd	a4,112(a5)
  }
}
    80002198:	60e2                	ld	ra,24(sp)
    8000219a:	6442                	ld	s0,16(sp)
    8000219c:	64a2                	ld	s1,8(sp)
    8000219e:	6902                	ld	s2,0(sp)
    800021a0:	6105                	addi	sp,sp,32
    800021a2:	8082                	ret

00000000800021a4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021a4:	1101                	addi	sp,sp,-32
    800021a6:	ec06                	sd	ra,24(sp)
    800021a8:	e822                	sd	s0,16(sp)
    800021aa:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021ac:	fec40593          	addi	a1,s0,-20
    800021b0:	4501                	li	a0,0
    800021b2:	00000097          	auipc	ra,0x0
    800021b6:	f12080e7          	jalr	-238(ra) # 800020c4 <argint>
    return -1;
    800021ba:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021bc:	00054963          	bltz	a0,800021ce <sys_exit+0x2a>
  exit(n);
    800021c0:	fec42503          	lw	a0,-20(s0)
    800021c4:	fffff097          	auipc	ra,0xfffff
    800021c8:	61e080e7          	jalr	1566(ra) # 800017e2 <exit>
  return 0;  // not reached
    800021cc:	4781                	li	a5,0
}
    800021ce:	853e                	mv	a0,a5
    800021d0:	60e2                	ld	ra,24(sp)
    800021d2:	6442                	ld	s0,16(sp)
    800021d4:	6105                	addi	sp,sp,32
    800021d6:	8082                	ret

00000000800021d8 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021d8:	1141                	addi	sp,sp,-16
    800021da:	e406                	sd	ra,8(sp)
    800021dc:	e022                	sd	s0,0(sp)
    800021de:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	c56080e7          	jalr	-938(ra) # 80000e36 <myproc>
}
    800021e8:	5908                	lw	a0,48(a0)
    800021ea:	60a2                	ld	ra,8(sp)
    800021ec:	6402                	ld	s0,0(sp)
    800021ee:	0141                	addi	sp,sp,16
    800021f0:	8082                	ret

00000000800021f2 <sys_fork>:

uint64
sys_fork(void)
{
    800021f2:	1141                	addi	sp,sp,-16
    800021f4:	e406                	sd	ra,8(sp)
    800021f6:	e022                	sd	s0,0(sp)
    800021f8:	0800                	addi	s0,sp,16
  return fork();
    800021fa:	fffff097          	auipc	ra,0xfffff
    800021fe:	030080e7          	jalr	48(ra) # 8000122a <fork>
}
    80002202:	60a2                	ld	ra,8(sp)
    80002204:	6402                	ld	s0,0(sp)
    80002206:	0141                	addi	sp,sp,16
    80002208:	8082                	ret

000000008000220a <sys_wait>:

uint64
sys_wait(void)
{
    8000220a:	1101                	addi	sp,sp,-32
    8000220c:	ec06                	sd	ra,24(sp)
    8000220e:	e822                	sd	s0,16(sp)
    80002210:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002212:	fe840593          	addi	a1,s0,-24
    80002216:	4501                	li	a0,0
    80002218:	00000097          	auipc	ra,0x0
    8000221c:	ece080e7          	jalr	-306(ra) # 800020e6 <argaddr>
    80002220:	87aa                	mv	a5,a0
    return -1;
    80002222:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002224:	0007c863          	bltz	a5,80002234 <sys_wait+0x2a>
  return wait(p);
    80002228:	fe843503          	ld	a0,-24(s0)
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	3be080e7          	jalr	958(ra) # 800015ea <wait>
}
    80002234:	60e2                	ld	ra,24(sp)
    80002236:	6442                	ld	s0,16(sp)
    80002238:	6105                	addi	sp,sp,32
    8000223a:	8082                	ret

000000008000223c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000223c:	7179                	addi	sp,sp,-48
    8000223e:	f406                	sd	ra,40(sp)
    80002240:	f022                	sd	s0,32(sp)
    80002242:	ec26                	sd	s1,24(sp)
    80002244:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002246:	fdc40593          	addi	a1,s0,-36
    8000224a:	4501                	li	a0,0
    8000224c:	00000097          	auipc	ra,0x0
    80002250:	e78080e7          	jalr	-392(ra) # 800020c4 <argint>
    80002254:	87aa                	mv	a5,a0
    return -1;
    80002256:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002258:	0207c063          	bltz	a5,80002278 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000225c:	fffff097          	auipc	ra,0xfffff
    80002260:	bda080e7          	jalr	-1062(ra) # 80000e36 <myproc>
    80002264:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002266:	fdc42503          	lw	a0,-36(s0)
    8000226a:	fffff097          	auipc	ra,0xfffff
    8000226e:	f4c080e7          	jalr	-180(ra) # 800011b6 <growproc>
    80002272:	00054863          	bltz	a0,80002282 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002276:	8526                	mv	a0,s1
}
    80002278:	70a2                	ld	ra,40(sp)
    8000227a:	7402                	ld	s0,32(sp)
    8000227c:	64e2                	ld	s1,24(sp)
    8000227e:	6145                	addi	sp,sp,48
    80002280:	8082                	ret
    return -1;
    80002282:	557d                	li	a0,-1
    80002284:	bfd5                	j	80002278 <sys_sbrk+0x3c>

0000000080002286 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002286:	7139                	addi	sp,sp,-64
    80002288:	fc06                	sd	ra,56(sp)
    8000228a:	f822                	sd	s0,48(sp)
    8000228c:	f426                	sd	s1,40(sp)
    8000228e:	f04a                	sd	s2,32(sp)
    80002290:	ec4e                	sd	s3,24(sp)
    80002292:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002294:	fcc40593          	addi	a1,s0,-52
    80002298:	4501                	li	a0,0
    8000229a:	00000097          	auipc	ra,0x0
    8000229e:	e2a080e7          	jalr	-470(ra) # 800020c4 <argint>
    return -1;
    800022a2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022a4:	06054563          	bltz	a0,8000230e <sys_sleep+0x88>
  acquire(&tickslock);
    800022a8:	0000f517          	auipc	a0,0xf
    800022ac:	bd850513          	addi	a0,a0,-1064 # 80010e80 <tickslock>
    800022b0:	00004097          	auipc	ra,0x4
    800022b4:	2c0080e7          	jalr	704(ra) # 80006570 <acquire>
  ticks0 = ticks;
    800022b8:	00007917          	auipc	s2,0x7
    800022bc:	d6092903          	lw	s2,-672(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800022c0:	fcc42783          	lw	a5,-52(s0)
    800022c4:	cf85                	beqz	a5,800022fc <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022c6:	0000f997          	auipc	s3,0xf
    800022ca:	bba98993          	addi	s3,s3,-1094 # 80010e80 <tickslock>
    800022ce:	00007497          	auipc	s1,0x7
    800022d2:	d4a48493          	addi	s1,s1,-694 # 80009018 <ticks>
    if(myproc()->killed){
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	b60080e7          	jalr	-1184(ra) # 80000e36 <myproc>
    800022de:	551c                	lw	a5,40(a0)
    800022e0:	ef9d                	bnez	a5,8000231e <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022e2:	85ce                	mv	a1,s3
    800022e4:	8526                	mv	a0,s1
    800022e6:	fffff097          	auipc	ra,0xfffff
    800022ea:	2a0080e7          	jalr	672(ra) # 80001586 <sleep>
  while(ticks - ticks0 < n){
    800022ee:	409c                	lw	a5,0(s1)
    800022f0:	412787bb          	subw	a5,a5,s2
    800022f4:	fcc42703          	lw	a4,-52(s0)
    800022f8:	fce7efe3          	bltu	a5,a4,800022d6 <sys_sleep+0x50>
  }
  release(&tickslock);
    800022fc:	0000f517          	auipc	a0,0xf
    80002300:	b8450513          	addi	a0,a0,-1148 # 80010e80 <tickslock>
    80002304:	00004097          	auipc	ra,0x4
    80002308:	320080e7          	jalr	800(ra) # 80006624 <release>
  return 0;
    8000230c:	4781                	li	a5,0
}
    8000230e:	853e                	mv	a0,a5
    80002310:	70e2                	ld	ra,56(sp)
    80002312:	7442                	ld	s0,48(sp)
    80002314:	74a2                	ld	s1,40(sp)
    80002316:	7902                	ld	s2,32(sp)
    80002318:	69e2                	ld	s3,24(sp)
    8000231a:	6121                	addi	sp,sp,64
    8000231c:	8082                	ret
      release(&tickslock);
    8000231e:	0000f517          	auipc	a0,0xf
    80002322:	b6250513          	addi	a0,a0,-1182 # 80010e80 <tickslock>
    80002326:	00004097          	auipc	ra,0x4
    8000232a:	2fe080e7          	jalr	766(ra) # 80006624 <release>
      return -1;
    8000232e:	57fd                	li	a5,-1
    80002330:	bff9                	j	8000230e <sys_sleep+0x88>

0000000080002332 <sys_kill>:

uint64
sys_kill(void)
{
    80002332:	1101                	addi	sp,sp,-32
    80002334:	ec06                	sd	ra,24(sp)
    80002336:	e822                	sd	s0,16(sp)
    80002338:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000233a:	fec40593          	addi	a1,s0,-20
    8000233e:	4501                	li	a0,0
    80002340:	00000097          	auipc	ra,0x0
    80002344:	d84080e7          	jalr	-636(ra) # 800020c4 <argint>
    80002348:	87aa                	mv	a5,a0
    return -1;
    8000234a:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000234c:	0007c863          	bltz	a5,8000235c <sys_kill+0x2a>
  return kill(pid);
    80002350:	fec42503          	lw	a0,-20(s0)
    80002354:	fffff097          	auipc	ra,0xfffff
    80002358:	5f8080e7          	jalr	1528(ra) # 8000194c <kill>
}
    8000235c:	60e2                	ld	ra,24(sp)
    8000235e:	6442                	ld	s0,16(sp)
    80002360:	6105                	addi	sp,sp,32
    80002362:	8082                	ret

0000000080002364 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002364:	1101                	addi	sp,sp,-32
    80002366:	ec06                	sd	ra,24(sp)
    80002368:	e822                	sd	s0,16(sp)
    8000236a:	e426                	sd	s1,8(sp)
    8000236c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000236e:	0000f517          	auipc	a0,0xf
    80002372:	b1250513          	addi	a0,a0,-1262 # 80010e80 <tickslock>
    80002376:	00004097          	auipc	ra,0x4
    8000237a:	1fa080e7          	jalr	506(ra) # 80006570 <acquire>
  xticks = ticks;
    8000237e:	00007497          	auipc	s1,0x7
    80002382:	c9a4a483          	lw	s1,-870(s1) # 80009018 <ticks>
  release(&tickslock);
    80002386:	0000f517          	auipc	a0,0xf
    8000238a:	afa50513          	addi	a0,a0,-1286 # 80010e80 <tickslock>
    8000238e:	00004097          	auipc	ra,0x4
    80002392:	296080e7          	jalr	662(ra) # 80006624 <release>
  return xticks;
}
    80002396:	02049513          	slli	a0,s1,0x20
    8000239a:	9101                	srli	a0,a0,0x20
    8000239c:	60e2                	ld	ra,24(sp)
    8000239e:	6442                	ld	s0,16(sp)
    800023a0:	64a2                	ld	s1,8(sp)
    800023a2:	6105                	addi	sp,sp,32
    800023a4:	8082                	ret

00000000800023a6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023a6:	7179                	addi	sp,sp,-48
    800023a8:	f406                	sd	ra,40(sp)
    800023aa:	f022                	sd	s0,32(sp)
    800023ac:	ec26                	sd	s1,24(sp)
    800023ae:	e84a                	sd	s2,16(sp)
    800023b0:	e44e                	sd	s3,8(sp)
    800023b2:	e052                	sd	s4,0(sp)
    800023b4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023b6:	00006597          	auipc	a1,0x6
    800023ba:	04a58593          	addi	a1,a1,74 # 80008400 <syscalls+0xc0>
    800023be:	0000f517          	auipc	a0,0xf
    800023c2:	ada50513          	addi	a0,a0,-1318 # 80010e98 <bcache>
    800023c6:	00004097          	auipc	ra,0x4
    800023ca:	11a080e7          	jalr	282(ra) # 800064e0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023ce:	00017797          	auipc	a5,0x17
    800023d2:	aca78793          	addi	a5,a5,-1334 # 80018e98 <bcache+0x8000>
    800023d6:	00017717          	auipc	a4,0x17
    800023da:	d2a70713          	addi	a4,a4,-726 # 80019100 <bcache+0x8268>
    800023de:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023e2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023e6:	0000f497          	auipc	s1,0xf
    800023ea:	aca48493          	addi	s1,s1,-1334 # 80010eb0 <bcache+0x18>
    b->next = bcache.head.next;
    800023ee:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023f0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023f2:	00006a17          	auipc	s4,0x6
    800023f6:	016a0a13          	addi	s4,s4,22 # 80008408 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023fa:	2b893783          	ld	a5,696(s2)
    800023fe:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002400:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002404:	85d2                	mv	a1,s4
    80002406:	01048513          	addi	a0,s1,16
    8000240a:	00001097          	auipc	ra,0x1
    8000240e:	4bc080e7          	jalr	1212(ra) # 800038c6 <initsleeplock>
    bcache.head.next->prev = b;
    80002412:	2b893783          	ld	a5,696(s2)
    80002416:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002418:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000241c:	45848493          	addi	s1,s1,1112
    80002420:	fd349de3          	bne	s1,s3,800023fa <binit+0x54>
  }
}
    80002424:	70a2                	ld	ra,40(sp)
    80002426:	7402                	ld	s0,32(sp)
    80002428:	64e2                	ld	s1,24(sp)
    8000242a:	6942                	ld	s2,16(sp)
    8000242c:	69a2                	ld	s3,8(sp)
    8000242e:	6a02                	ld	s4,0(sp)
    80002430:	6145                	addi	sp,sp,48
    80002432:	8082                	ret

0000000080002434 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002434:	7179                	addi	sp,sp,-48
    80002436:	f406                	sd	ra,40(sp)
    80002438:	f022                	sd	s0,32(sp)
    8000243a:	ec26                	sd	s1,24(sp)
    8000243c:	e84a                	sd	s2,16(sp)
    8000243e:	e44e                	sd	s3,8(sp)
    80002440:	1800                	addi	s0,sp,48
    80002442:	89aa                	mv	s3,a0
    80002444:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002446:	0000f517          	auipc	a0,0xf
    8000244a:	a5250513          	addi	a0,a0,-1454 # 80010e98 <bcache>
    8000244e:	00004097          	auipc	ra,0x4
    80002452:	122080e7          	jalr	290(ra) # 80006570 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002456:	00017497          	auipc	s1,0x17
    8000245a:	cfa4b483          	ld	s1,-774(s1) # 80019150 <bcache+0x82b8>
    8000245e:	00017797          	auipc	a5,0x17
    80002462:	ca278793          	addi	a5,a5,-862 # 80019100 <bcache+0x8268>
    80002466:	02f48f63          	beq	s1,a5,800024a4 <bread+0x70>
    8000246a:	873e                	mv	a4,a5
    8000246c:	a021                	j	80002474 <bread+0x40>
    8000246e:	68a4                	ld	s1,80(s1)
    80002470:	02e48a63          	beq	s1,a4,800024a4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002474:	449c                	lw	a5,8(s1)
    80002476:	ff379ce3          	bne	a5,s3,8000246e <bread+0x3a>
    8000247a:	44dc                	lw	a5,12(s1)
    8000247c:	ff2799e3          	bne	a5,s2,8000246e <bread+0x3a>
      b->refcnt++;
    80002480:	40bc                	lw	a5,64(s1)
    80002482:	2785                	addiw	a5,a5,1
    80002484:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002486:	0000f517          	auipc	a0,0xf
    8000248a:	a1250513          	addi	a0,a0,-1518 # 80010e98 <bcache>
    8000248e:	00004097          	auipc	ra,0x4
    80002492:	196080e7          	jalr	406(ra) # 80006624 <release>
      acquiresleep(&b->lock);
    80002496:	01048513          	addi	a0,s1,16
    8000249a:	00001097          	auipc	ra,0x1
    8000249e:	466080e7          	jalr	1126(ra) # 80003900 <acquiresleep>
      return b;
    800024a2:	a8b9                	j	80002500 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024a4:	00017497          	auipc	s1,0x17
    800024a8:	ca44b483          	ld	s1,-860(s1) # 80019148 <bcache+0x82b0>
    800024ac:	00017797          	auipc	a5,0x17
    800024b0:	c5478793          	addi	a5,a5,-940 # 80019100 <bcache+0x8268>
    800024b4:	00f48863          	beq	s1,a5,800024c4 <bread+0x90>
    800024b8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024ba:	40bc                	lw	a5,64(s1)
    800024bc:	cf81                	beqz	a5,800024d4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024be:	64a4                	ld	s1,72(s1)
    800024c0:	fee49de3          	bne	s1,a4,800024ba <bread+0x86>
  panic("bget: no buffers");
    800024c4:	00006517          	auipc	a0,0x6
    800024c8:	f4c50513          	addi	a0,a0,-180 # 80008410 <syscalls+0xd0>
    800024cc:	00004097          	auipc	ra,0x4
    800024d0:	b5a080e7          	jalr	-1190(ra) # 80006026 <panic>
      b->dev = dev;
    800024d4:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800024d8:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800024dc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024e0:	4785                	li	a5,1
    800024e2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024e4:	0000f517          	auipc	a0,0xf
    800024e8:	9b450513          	addi	a0,a0,-1612 # 80010e98 <bcache>
    800024ec:	00004097          	auipc	ra,0x4
    800024f0:	138080e7          	jalr	312(ra) # 80006624 <release>
      acquiresleep(&b->lock);
    800024f4:	01048513          	addi	a0,s1,16
    800024f8:	00001097          	auipc	ra,0x1
    800024fc:	408080e7          	jalr	1032(ra) # 80003900 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002500:	409c                	lw	a5,0(s1)
    80002502:	cb89                	beqz	a5,80002514 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002504:	8526                	mv	a0,s1
    80002506:	70a2                	ld	ra,40(sp)
    80002508:	7402                	ld	s0,32(sp)
    8000250a:	64e2                	ld	s1,24(sp)
    8000250c:	6942                	ld	s2,16(sp)
    8000250e:	69a2                	ld	s3,8(sp)
    80002510:	6145                	addi	sp,sp,48
    80002512:	8082                	ret
    virtio_disk_rw(b, 0);
    80002514:	4581                	li	a1,0
    80002516:	8526                	mv	a0,s1
    80002518:	00003097          	auipc	ra,0x3
    8000251c:	1ae080e7          	jalr	430(ra) # 800056c6 <virtio_disk_rw>
    b->valid = 1;
    80002520:	4785                	li	a5,1
    80002522:	c09c                	sw	a5,0(s1)
  return b;
    80002524:	b7c5                	j	80002504 <bread+0xd0>

0000000080002526 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002526:	1101                	addi	sp,sp,-32
    80002528:	ec06                	sd	ra,24(sp)
    8000252a:	e822                	sd	s0,16(sp)
    8000252c:	e426                	sd	s1,8(sp)
    8000252e:	1000                	addi	s0,sp,32
    80002530:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002532:	0541                	addi	a0,a0,16
    80002534:	00001097          	auipc	ra,0x1
    80002538:	466080e7          	jalr	1126(ra) # 8000399a <holdingsleep>
    8000253c:	cd01                	beqz	a0,80002554 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000253e:	4585                	li	a1,1
    80002540:	8526                	mv	a0,s1
    80002542:	00003097          	auipc	ra,0x3
    80002546:	184080e7          	jalr	388(ra) # 800056c6 <virtio_disk_rw>
}
    8000254a:	60e2                	ld	ra,24(sp)
    8000254c:	6442                	ld	s0,16(sp)
    8000254e:	64a2                	ld	s1,8(sp)
    80002550:	6105                	addi	sp,sp,32
    80002552:	8082                	ret
    panic("bwrite");
    80002554:	00006517          	auipc	a0,0x6
    80002558:	ed450513          	addi	a0,a0,-300 # 80008428 <syscalls+0xe8>
    8000255c:	00004097          	auipc	ra,0x4
    80002560:	aca080e7          	jalr	-1334(ra) # 80006026 <panic>

0000000080002564 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002564:	1101                	addi	sp,sp,-32
    80002566:	ec06                	sd	ra,24(sp)
    80002568:	e822                	sd	s0,16(sp)
    8000256a:	e426                	sd	s1,8(sp)
    8000256c:	e04a                	sd	s2,0(sp)
    8000256e:	1000                	addi	s0,sp,32
    80002570:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002572:	01050913          	addi	s2,a0,16
    80002576:	854a                	mv	a0,s2
    80002578:	00001097          	auipc	ra,0x1
    8000257c:	422080e7          	jalr	1058(ra) # 8000399a <holdingsleep>
    80002580:	c92d                	beqz	a0,800025f2 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002582:	854a                	mv	a0,s2
    80002584:	00001097          	auipc	ra,0x1
    80002588:	3d2080e7          	jalr	978(ra) # 80003956 <releasesleep>

  acquire(&bcache.lock);
    8000258c:	0000f517          	auipc	a0,0xf
    80002590:	90c50513          	addi	a0,a0,-1780 # 80010e98 <bcache>
    80002594:	00004097          	auipc	ra,0x4
    80002598:	fdc080e7          	jalr	-36(ra) # 80006570 <acquire>
  b->refcnt--;
    8000259c:	40bc                	lw	a5,64(s1)
    8000259e:	37fd                	addiw	a5,a5,-1
    800025a0:	0007871b          	sext.w	a4,a5
    800025a4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025a6:	eb05                	bnez	a4,800025d6 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025a8:	68bc                	ld	a5,80(s1)
    800025aa:	64b8                	ld	a4,72(s1)
    800025ac:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025ae:	64bc                	ld	a5,72(s1)
    800025b0:	68b8                	ld	a4,80(s1)
    800025b2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025b4:	00017797          	auipc	a5,0x17
    800025b8:	8e478793          	addi	a5,a5,-1820 # 80018e98 <bcache+0x8000>
    800025bc:	2b87b703          	ld	a4,696(a5)
    800025c0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025c2:	00017717          	auipc	a4,0x17
    800025c6:	b3e70713          	addi	a4,a4,-1218 # 80019100 <bcache+0x8268>
    800025ca:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025cc:	2b87b703          	ld	a4,696(a5)
    800025d0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025d2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025d6:	0000f517          	auipc	a0,0xf
    800025da:	8c250513          	addi	a0,a0,-1854 # 80010e98 <bcache>
    800025de:	00004097          	auipc	ra,0x4
    800025e2:	046080e7          	jalr	70(ra) # 80006624 <release>
}
    800025e6:	60e2                	ld	ra,24(sp)
    800025e8:	6442                	ld	s0,16(sp)
    800025ea:	64a2                	ld	s1,8(sp)
    800025ec:	6902                	ld	s2,0(sp)
    800025ee:	6105                	addi	sp,sp,32
    800025f0:	8082                	ret
    panic("brelse");
    800025f2:	00006517          	auipc	a0,0x6
    800025f6:	e3e50513          	addi	a0,a0,-450 # 80008430 <syscalls+0xf0>
    800025fa:	00004097          	auipc	ra,0x4
    800025fe:	a2c080e7          	jalr	-1492(ra) # 80006026 <panic>

0000000080002602 <bpin>:

void
bpin(struct buf *b) {
    80002602:	1101                	addi	sp,sp,-32
    80002604:	ec06                	sd	ra,24(sp)
    80002606:	e822                	sd	s0,16(sp)
    80002608:	e426                	sd	s1,8(sp)
    8000260a:	1000                	addi	s0,sp,32
    8000260c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000260e:	0000f517          	auipc	a0,0xf
    80002612:	88a50513          	addi	a0,a0,-1910 # 80010e98 <bcache>
    80002616:	00004097          	auipc	ra,0x4
    8000261a:	f5a080e7          	jalr	-166(ra) # 80006570 <acquire>
  b->refcnt++;
    8000261e:	40bc                	lw	a5,64(s1)
    80002620:	2785                	addiw	a5,a5,1
    80002622:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002624:	0000f517          	auipc	a0,0xf
    80002628:	87450513          	addi	a0,a0,-1932 # 80010e98 <bcache>
    8000262c:	00004097          	auipc	ra,0x4
    80002630:	ff8080e7          	jalr	-8(ra) # 80006624 <release>
}
    80002634:	60e2                	ld	ra,24(sp)
    80002636:	6442                	ld	s0,16(sp)
    80002638:	64a2                	ld	s1,8(sp)
    8000263a:	6105                	addi	sp,sp,32
    8000263c:	8082                	ret

000000008000263e <bunpin>:

void
bunpin(struct buf *b) {
    8000263e:	1101                	addi	sp,sp,-32
    80002640:	ec06                	sd	ra,24(sp)
    80002642:	e822                	sd	s0,16(sp)
    80002644:	e426                	sd	s1,8(sp)
    80002646:	1000                	addi	s0,sp,32
    80002648:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000264a:	0000f517          	auipc	a0,0xf
    8000264e:	84e50513          	addi	a0,a0,-1970 # 80010e98 <bcache>
    80002652:	00004097          	auipc	ra,0x4
    80002656:	f1e080e7          	jalr	-226(ra) # 80006570 <acquire>
  b->refcnt--;
    8000265a:	40bc                	lw	a5,64(s1)
    8000265c:	37fd                	addiw	a5,a5,-1
    8000265e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002660:	0000f517          	auipc	a0,0xf
    80002664:	83850513          	addi	a0,a0,-1992 # 80010e98 <bcache>
    80002668:	00004097          	auipc	ra,0x4
    8000266c:	fbc080e7          	jalr	-68(ra) # 80006624 <release>
}
    80002670:	60e2                	ld	ra,24(sp)
    80002672:	6442                	ld	s0,16(sp)
    80002674:	64a2                	ld	s1,8(sp)
    80002676:	6105                	addi	sp,sp,32
    80002678:	8082                	ret

000000008000267a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000267a:	1101                	addi	sp,sp,-32
    8000267c:	ec06                	sd	ra,24(sp)
    8000267e:	e822                	sd	s0,16(sp)
    80002680:	e426                	sd	s1,8(sp)
    80002682:	e04a                	sd	s2,0(sp)
    80002684:	1000                	addi	s0,sp,32
    80002686:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002688:	00d5d59b          	srliw	a1,a1,0xd
    8000268c:	00017797          	auipc	a5,0x17
    80002690:	ee87a783          	lw	a5,-280(a5) # 80019574 <sb+0x1c>
    80002694:	9dbd                	addw	a1,a1,a5
    80002696:	00000097          	auipc	ra,0x0
    8000269a:	d9e080e7          	jalr	-610(ra) # 80002434 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000269e:	0074f713          	andi	a4,s1,7
    800026a2:	4785                	li	a5,1
    800026a4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026a8:	14ce                	slli	s1,s1,0x33
    800026aa:	90d9                	srli	s1,s1,0x36
    800026ac:	00950733          	add	a4,a0,s1
    800026b0:	05874703          	lbu	a4,88(a4)
    800026b4:	00e7f6b3          	and	a3,a5,a4
    800026b8:	c69d                	beqz	a3,800026e6 <bfree+0x6c>
    800026ba:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026bc:	94aa                	add	s1,s1,a0
    800026be:	fff7c793          	not	a5,a5
    800026c2:	8ff9                	and	a5,a5,a4
    800026c4:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800026c8:	00001097          	auipc	ra,0x1
    800026cc:	118080e7          	jalr	280(ra) # 800037e0 <log_write>
  brelse(bp);
    800026d0:	854a                	mv	a0,s2
    800026d2:	00000097          	auipc	ra,0x0
    800026d6:	e92080e7          	jalr	-366(ra) # 80002564 <brelse>
}
    800026da:	60e2                	ld	ra,24(sp)
    800026dc:	6442                	ld	s0,16(sp)
    800026de:	64a2                	ld	s1,8(sp)
    800026e0:	6902                	ld	s2,0(sp)
    800026e2:	6105                	addi	sp,sp,32
    800026e4:	8082                	ret
    panic("freeing free block");
    800026e6:	00006517          	auipc	a0,0x6
    800026ea:	d5250513          	addi	a0,a0,-686 # 80008438 <syscalls+0xf8>
    800026ee:	00004097          	auipc	ra,0x4
    800026f2:	938080e7          	jalr	-1736(ra) # 80006026 <panic>

00000000800026f6 <balloc>:
{
    800026f6:	711d                	addi	sp,sp,-96
    800026f8:	ec86                	sd	ra,88(sp)
    800026fa:	e8a2                	sd	s0,80(sp)
    800026fc:	e4a6                	sd	s1,72(sp)
    800026fe:	e0ca                	sd	s2,64(sp)
    80002700:	fc4e                	sd	s3,56(sp)
    80002702:	f852                	sd	s4,48(sp)
    80002704:	f456                	sd	s5,40(sp)
    80002706:	f05a                	sd	s6,32(sp)
    80002708:	ec5e                	sd	s7,24(sp)
    8000270a:	e862                	sd	s8,16(sp)
    8000270c:	e466                	sd	s9,8(sp)
    8000270e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002710:	00017797          	auipc	a5,0x17
    80002714:	e4c7a783          	lw	a5,-436(a5) # 8001955c <sb+0x4>
    80002718:	cbd1                	beqz	a5,800027ac <balloc+0xb6>
    8000271a:	8baa                	mv	s7,a0
    8000271c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000271e:	00017b17          	auipc	s6,0x17
    80002722:	e3ab0b13          	addi	s6,s6,-454 # 80019558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002726:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002728:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000272a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000272c:	6c89                	lui	s9,0x2
    8000272e:	a831                	j	8000274a <balloc+0x54>
    brelse(bp);
    80002730:	854a                	mv	a0,s2
    80002732:	00000097          	auipc	ra,0x0
    80002736:	e32080e7          	jalr	-462(ra) # 80002564 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000273a:	015c87bb          	addw	a5,s9,s5
    8000273e:	00078a9b          	sext.w	s5,a5
    80002742:	004b2703          	lw	a4,4(s6)
    80002746:	06eaf363          	bgeu	s5,a4,800027ac <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000274a:	41fad79b          	sraiw	a5,s5,0x1f
    8000274e:	0137d79b          	srliw	a5,a5,0x13
    80002752:	015787bb          	addw	a5,a5,s5
    80002756:	40d7d79b          	sraiw	a5,a5,0xd
    8000275a:	01cb2583          	lw	a1,28(s6)
    8000275e:	9dbd                	addw	a1,a1,a5
    80002760:	855e                	mv	a0,s7
    80002762:	00000097          	auipc	ra,0x0
    80002766:	cd2080e7          	jalr	-814(ra) # 80002434 <bread>
    8000276a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000276c:	004b2503          	lw	a0,4(s6)
    80002770:	000a849b          	sext.w	s1,s5
    80002774:	8662                	mv	a2,s8
    80002776:	faa4fde3          	bgeu	s1,a0,80002730 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000277a:	41f6579b          	sraiw	a5,a2,0x1f
    8000277e:	01d7d69b          	srliw	a3,a5,0x1d
    80002782:	00c6873b          	addw	a4,a3,a2
    80002786:	00777793          	andi	a5,a4,7
    8000278a:	9f95                	subw	a5,a5,a3
    8000278c:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002790:	4037571b          	sraiw	a4,a4,0x3
    80002794:	00e906b3          	add	a3,s2,a4
    80002798:	0586c683          	lbu	a3,88(a3) # fffffffffffff058 <end+0xffffffff7ffd6bf8>
    8000279c:	00d7f5b3          	and	a1,a5,a3
    800027a0:	cd91                	beqz	a1,800027bc <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027a2:	2605                	addiw	a2,a2,1
    800027a4:	2485                	addiw	s1,s1,1
    800027a6:	fd4618e3          	bne	a2,s4,80002776 <balloc+0x80>
    800027aa:	b759                	j	80002730 <balloc+0x3a>
  panic("balloc: out of blocks");
    800027ac:	00006517          	auipc	a0,0x6
    800027b0:	ca450513          	addi	a0,a0,-860 # 80008450 <syscalls+0x110>
    800027b4:	00004097          	auipc	ra,0x4
    800027b8:	872080e7          	jalr	-1934(ra) # 80006026 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800027bc:	974a                	add	a4,a4,s2
    800027be:	8fd5                	or	a5,a5,a3
    800027c0:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800027c4:	854a                	mv	a0,s2
    800027c6:	00001097          	auipc	ra,0x1
    800027ca:	01a080e7          	jalr	26(ra) # 800037e0 <log_write>
        brelse(bp);
    800027ce:	854a                	mv	a0,s2
    800027d0:	00000097          	auipc	ra,0x0
    800027d4:	d94080e7          	jalr	-620(ra) # 80002564 <brelse>
  bp = bread(dev, bno);
    800027d8:	85a6                	mv	a1,s1
    800027da:	855e                	mv	a0,s7
    800027dc:	00000097          	auipc	ra,0x0
    800027e0:	c58080e7          	jalr	-936(ra) # 80002434 <bread>
    800027e4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027e6:	40000613          	li	a2,1024
    800027ea:	4581                	li	a1,0
    800027ec:	05850513          	addi	a0,a0,88
    800027f0:	ffffe097          	auipc	ra,0xffffe
    800027f4:	988080e7          	jalr	-1656(ra) # 80000178 <memset>
  log_write(bp);
    800027f8:	854a                	mv	a0,s2
    800027fa:	00001097          	auipc	ra,0x1
    800027fe:	fe6080e7          	jalr	-26(ra) # 800037e0 <log_write>
  brelse(bp);
    80002802:	854a                	mv	a0,s2
    80002804:	00000097          	auipc	ra,0x0
    80002808:	d60080e7          	jalr	-672(ra) # 80002564 <brelse>
}
    8000280c:	8526                	mv	a0,s1
    8000280e:	60e6                	ld	ra,88(sp)
    80002810:	6446                	ld	s0,80(sp)
    80002812:	64a6                	ld	s1,72(sp)
    80002814:	6906                	ld	s2,64(sp)
    80002816:	79e2                	ld	s3,56(sp)
    80002818:	7a42                	ld	s4,48(sp)
    8000281a:	7aa2                	ld	s5,40(sp)
    8000281c:	7b02                	ld	s6,32(sp)
    8000281e:	6be2                	ld	s7,24(sp)
    80002820:	6c42                	ld	s8,16(sp)
    80002822:	6ca2                	ld	s9,8(sp)
    80002824:	6125                	addi	sp,sp,96
    80002826:	8082                	ret

0000000080002828 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002828:	7179                	addi	sp,sp,-48
    8000282a:	f406                	sd	ra,40(sp)
    8000282c:	f022                	sd	s0,32(sp)
    8000282e:	ec26                	sd	s1,24(sp)
    80002830:	e84a                	sd	s2,16(sp)
    80002832:	e44e                	sd	s3,8(sp)
    80002834:	e052                	sd	s4,0(sp)
    80002836:	1800                	addi	s0,sp,48
    80002838:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000283a:	47ad                	li	a5,11
    8000283c:	04b7fe63          	bgeu	a5,a1,80002898 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002840:	ff45849b          	addiw	s1,a1,-12
    80002844:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002848:	0ff00793          	li	a5,255
    8000284c:	0ae7e363          	bltu	a5,a4,800028f2 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002850:	08052583          	lw	a1,128(a0)
    80002854:	c5ad                	beqz	a1,800028be <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002856:	00092503          	lw	a0,0(s2)
    8000285a:	00000097          	auipc	ra,0x0
    8000285e:	bda080e7          	jalr	-1062(ra) # 80002434 <bread>
    80002862:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002864:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002868:	02049593          	slli	a1,s1,0x20
    8000286c:	9181                	srli	a1,a1,0x20
    8000286e:	058a                	slli	a1,a1,0x2
    80002870:	00b784b3          	add	s1,a5,a1
    80002874:	0004a983          	lw	s3,0(s1)
    80002878:	04098d63          	beqz	s3,800028d2 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000287c:	8552                	mv	a0,s4
    8000287e:	00000097          	auipc	ra,0x0
    80002882:	ce6080e7          	jalr	-794(ra) # 80002564 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002886:	854e                	mv	a0,s3
    80002888:	70a2                	ld	ra,40(sp)
    8000288a:	7402                	ld	s0,32(sp)
    8000288c:	64e2                	ld	s1,24(sp)
    8000288e:	6942                	ld	s2,16(sp)
    80002890:	69a2                	ld	s3,8(sp)
    80002892:	6a02                	ld	s4,0(sp)
    80002894:	6145                	addi	sp,sp,48
    80002896:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002898:	02059493          	slli	s1,a1,0x20
    8000289c:	9081                	srli	s1,s1,0x20
    8000289e:	048a                	slli	s1,s1,0x2
    800028a0:	94aa                	add	s1,s1,a0
    800028a2:	0504a983          	lw	s3,80(s1)
    800028a6:	fe0990e3          	bnez	s3,80002886 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800028aa:	4108                	lw	a0,0(a0)
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	e4a080e7          	jalr	-438(ra) # 800026f6 <balloc>
    800028b4:	0005099b          	sext.w	s3,a0
    800028b8:	0534a823          	sw	s3,80(s1)
    800028bc:	b7e9                	j	80002886 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800028be:	4108                	lw	a0,0(a0)
    800028c0:	00000097          	auipc	ra,0x0
    800028c4:	e36080e7          	jalr	-458(ra) # 800026f6 <balloc>
    800028c8:	0005059b          	sext.w	a1,a0
    800028cc:	08b92023          	sw	a1,128(s2)
    800028d0:	b759                	j	80002856 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800028d2:	00092503          	lw	a0,0(s2)
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	e20080e7          	jalr	-480(ra) # 800026f6 <balloc>
    800028de:	0005099b          	sext.w	s3,a0
    800028e2:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800028e6:	8552                	mv	a0,s4
    800028e8:	00001097          	auipc	ra,0x1
    800028ec:	ef8080e7          	jalr	-264(ra) # 800037e0 <log_write>
    800028f0:	b771                	j	8000287c <bmap+0x54>
  panic("bmap: out of range");
    800028f2:	00006517          	auipc	a0,0x6
    800028f6:	b7650513          	addi	a0,a0,-1162 # 80008468 <syscalls+0x128>
    800028fa:	00003097          	auipc	ra,0x3
    800028fe:	72c080e7          	jalr	1836(ra) # 80006026 <panic>

0000000080002902 <iget>:
{
    80002902:	7179                	addi	sp,sp,-48
    80002904:	f406                	sd	ra,40(sp)
    80002906:	f022                	sd	s0,32(sp)
    80002908:	ec26                	sd	s1,24(sp)
    8000290a:	e84a                	sd	s2,16(sp)
    8000290c:	e44e                	sd	s3,8(sp)
    8000290e:	e052                	sd	s4,0(sp)
    80002910:	1800                	addi	s0,sp,48
    80002912:	89aa                	mv	s3,a0
    80002914:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002916:	00017517          	auipc	a0,0x17
    8000291a:	c6250513          	addi	a0,a0,-926 # 80019578 <itable>
    8000291e:	00004097          	auipc	ra,0x4
    80002922:	c52080e7          	jalr	-942(ra) # 80006570 <acquire>
  empty = 0;
    80002926:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002928:	00017497          	auipc	s1,0x17
    8000292c:	c6848493          	addi	s1,s1,-920 # 80019590 <itable+0x18>
    80002930:	00018697          	auipc	a3,0x18
    80002934:	6f068693          	addi	a3,a3,1776 # 8001b020 <log>
    80002938:	a039                	j	80002946 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000293a:	02090b63          	beqz	s2,80002970 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000293e:	08848493          	addi	s1,s1,136
    80002942:	02d48a63          	beq	s1,a3,80002976 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002946:	449c                	lw	a5,8(s1)
    80002948:	fef059e3          	blez	a5,8000293a <iget+0x38>
    8000294c:	4098                	lw	a4,0(s1)
    8000294e:	ff3716e3          	bne	a4,s3,8000293a <iget+0x38>
    80002952:	40d8                	lw	a4,4(s1)
    80002954:	ff4713e3          	bne	a4,s4,8000293a <iget+0x38>
      ip->ref++;
    80002958:	2785                	addiw	a5,a5,1
    8000295a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000295c:	00017517          	auipc	a0,0x17
    80002960:	c1c50513          	addi	a0,a0,-996 # 80019578 <itable>
    80002964:	00004097          	auipc	ra,0x4
    80002968:	cc0080e7          	jalr	-832(ra) # 80006624 <release>
      return ip;
    8000296c:	8926                	mv	s2,s1
    8000296e:	a03d                	j	8000299c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002970:	f7f9                	bnez	a5,8000293e <iget+0x3c>
    80002972:	8926                	mv	s2,s1
    80002974:	b7e9                	j	8000293e <iget+0x3c>
  if(empty == 0)
    80002976:	02090c63          	beqz	s2,800029ae <iget+0xac>
  ip->dev = dev;
    8000297a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000297e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002982:	4785                	li	a5,1
    80002984:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002988:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000298c:	00017517          	auipc	a0,0x17
    80002990:	bec50513          	addi	a0,a0,-1044 # 80019578 <itable>
    80002994:	00004097          	auipc	ra,0x4
    80002998:	c90080e7          	jalr	-880(ra) # 80006624 <release>
}
    8000299c:	854a                	mv	a0,s2
    8000299e:	70a2                	ld	ra,40(sp)
    800029a0:	7402                	ld	s0,32(sp)
    800029a2:	64e2                	ld	s1,24(sp)
    800029a4:	6942                	ld	s2,16(sp)
    800029a6:	69a2                	ld	s3,8(sp)
    800029a8:	6a02                	ld	s4,0(sp)
    800029aa:	6145                	addi	sp,sp,48
    800029ac:	8082                	ret
    panic("iget: no inodes");
    800029ae:	00006517          	auipc	a0,0x6
    800029b2:	ad250513          	addi	a0,a0,-1326 # 80008480 <syscalls+0x140>
    800029b6:	00003097          	auipc	ra,0x3
    800029ba:	670080e7          	jalr	1648(ra) # 80006026 <panic>

00000000800029be <fsinit>:
fsinit(int dev) {
    800029be:	7179                	addi	sp,sp,-48
    800029c0:	f406                	sd	ra,40(sp)
    800029c2:	f022                	sd	s0,32(sp)
    800029c4:	ec26                	sd	s1,24(sp)
    800029c6:	e84a                	sd	s2,16(sp)
    800029c8:	e44e                	sd	s3,8(sp)
    800029ca:	1800                	addi	s0,sp,48
    800029cc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029ce:	4585                	li	a1,1
    800029d0:	00000097          	auipc	ra,0x0
    800029d4:	a64080e7          	jalr	-1436(ra) # 80002434 <bread>
    800029d8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029da:	00017997          	auipc	s3,0x17
    800029de:	b7e98993          	addi	s3,s3,-1154 # 80019558 <sb>
    800029e2:	02000613          	li	a2,32
    800029e6:	05850593          	addi	a1,a0,88
    800029ea:	854e                	mv	a0,s3
    800029ec:	ffffd097          	auipc	ra,0xffffd
    800029f0:	7ec080e7          	jalr	2028(ra) # 800001d8 <memmove>
  brelse(bp);
    800029f4:	8526                	mv	a0,s1
    800029f6:	00000097          	auipc	ra,0x0
    800029fa:	b6e080e7          	jalr	-1170(ra) # 80002564 <brelse>
  if(sb.magic != FSMAGIC)
    800029fe:	0009a703          	lw	a4,0(s3)
    80002a02:	102037b7          	lui	a5,0x10203
    80002a06:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a0a:	02f71263          	bne	a4,a5,80002a2e <fsinit+0x70>
  initlog(dev, &sb);
    80002a0e:	00017597          	auipc	a1,0x17
    80002a12:	b4a58593          	addi	a1,a1,-1206 # 80019558 <sb>
    80002a16:	854a                	mv	a0,s2
    80002a18:	00001097          	auipc	ra,0x1
    80002a1c:	b4c080e7          	jalr	-1204(ra) # 80003564 <initlog>
}
    80002a20:	70a2                	ld	ra,40(sp)
    80002a22:	7402                	ld	s0,32(sp)
    80002a24:	64e2                	ld	s1,24(sp)
    80002a26:	6942                	ld	s2,16(sp)
    80002a28:	69a2                	ld	s3,8(sp)
    80002a2a:	6145                	addi	sp,sp,48
    80002a2c:	8082                	ret
    panic("invalid file system");
    80002a2e:	00006517          	auipc	a0,0x6
    80002a32:	a6250513          	addi	a0,a0,-1438 # 80008490 <syscalls+0x150>
    80002a36:	00003097          	auipc	ra,0x3
    80002a3a:	5f0080e7          	jalr	1520(ra) # 80006026 <panic>

0000000080002a3e <iinit>:
{
    80002a3e:	7179                	addi	sp,sp,-48
    80002a40:	f406                	sd	ra,40(sp)
    80002a42:	f022                	sd	s0,32(sp)
    80002a44:	ec26                	sd	s1,24(sp)
    80002a46:	e84a                	sd	s2,16(sp)
    80002a48:	e44e                	sd	s3,8(sp)
    80002a4a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a4c:	00006597          	auipc	a1,0x6
    80002a50:	a5c58593          	addi	a1,a1,-1444 # 800084a8 <syscalls+0x168>
    80002a54:	00017517          	auipc	a0,0x17
    80002a58:	b2450513          	addi	a0,a0,-1244 # 80019578 <itable>
    80002a5c:	00004097          	auipc	ra,0x4
    80002a60:	a84080e7          	jalr	-1404(ra) # 800064e0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a64:	00017497          	auipc	s1,0x17
    80002a68:	b3c48493          	addi	s1,s1,-1220 # 800195a0 <itable+0x28>
    80002a6c:	00018997          	auipc	s3,0x18
    80002a70:	5c498993          	addi	s3,s3,1476 # 8001b030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a74:	00006917          	auipc	s2,0x6
    80002a78:	a3c90913          	addi	s2,s2,-1476 # 800084b0 <syscalls+0x170>
    80002a7c:	85ca                	mv	a1,s2
    80002a7e:	8526                	mv	a0,s1
    80002a80:	00001097          	auipc	ra,0x1
    80002a84:	e46080e7          	jalr	-442(ra) # 800038c6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a88:	08848493          	addi	s1,s1,136
    80002a8c:	ff3498e3          	bne	s1,s3,80002a7c <iinit+0x3e>
}
    80002a90:	70a2                	ld	ra,40(sp)
    80002a92:	7402                	ld	s0,32(sp)
    80002a94:	64e2                	ld	s1,24(sp)
    80002a96:	6942                	ld	s2,16(sp)
    80002a98:	69a2                	ld	s3,8(sp)
    80002a9a:	6145                	addi	sp,sp,48
    80002a9c:	8082                	ret

0000000080002a9e <ialloc>:
{
    80002a9e:	715d                	addi	sp,sp,-80
    80002aa0:	e486                	sd	ra,72(sp)
    80002aa2:	e0a2                	sd	s0,64(sp)
    80002aa4:	fc26                	sd	s1,56(sp)
    80002aa6:	f84a                	sd	s2,48(sp)
    80002aa8:	f44e                	sd	s3,40(sp)
    80002aaa:	f052                	sd	s4,32(sp)
    80002aac:	ec56                	sd	s5,24(sp)
    80002aae:	e85a                	sd	s6,16(sp)
    80002ab0:	e45e                	sd	s7,8(sp)
    80002ab2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ab4:	00017717          	auipc	a4,0x17
    80002ab8:	ab072703          	lw	a4,-1360(a4) # 80019564 <sb+0xc>
    80002abc:	4785                	li	a5,1
    80002abe:	04e7fa63          	bgeu	a5,a4,80002b12 <ialloc+0x74>
    80002ac2:	8aaa                	mv	s5,a0
    80002ac4:	8bae                	mv	s7,a1
    80002ac6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ac8:	00017a17          	auipc	s4,0x17
    80002acc:	a90a0a13          	addi	s4,s4,-1392 # 80019558 <sb>
    80002ad0:	00048b1b          	sext.w	s6,s1
    80002ad4:	0044d593          	srli	a1,s1,0x4
    80002ad8:	018a2783          	lw	a5,24(s4)
    80002adc:	9dbd                	addw	a1,a1,a5
    80002ade:	8556                	mv	a0,s5
    80002ae0:	00000097          	auipc	ra,0x0
    80002ae4:	954080e7          	jalr	-1708(ra) # 80002434 <bread>
    80002ae8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002aea:	05850993          	addi	s3,a0,88
    80002aee:	00f4f793          	andi	a5,s1,15
    80002af2:	079a                	slli	a5,a5,0x6
    80002af4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002af6:	00099783          	lh	a5,0(s3)
    80002afa:	c785                	beqz	a5,80002b22 <ialloc+0x84>
    brelse(bp);
    80002afc:	00000097          	auipc	ra,0x0
    80002b00:	a68080e7          	jalr	-1432(ra) # 80002564 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b04:	0485                	addi	s1,s1,1
    80002b06:	00ca2703          	lw	a4,12(s4)
    80002b0a:	0004879b          	sext.w	a5,s1
    80002b0e:	fce7e1e3          	bltu	a5,a4,80002ad0 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002b12:	00006517          	auipc	a0,0x6
    80002b16:	9a650513          	addi	a0,a0,-1626 # 800084b8 <syscalls+0x178>
    80002b1a:	00003097          	auipc	ra,0x3
    80002b1e:	50c080e7          	jalr	1292(ra) # 80006026 <panic>
      memset(dip, 0, sizeof(*dip));
    80002b22:	04000613          	li	a2,64
    80002b26:	4581                	li	a1,0
    80002b28:	854e                	mv	a0,s3
    80002b2a:	ffffd097          	auipc	ra,0xffffd
    80002b2e:	64e080e7          	jalr	1614(ra) # 80000178 <memset>
      dip->type = type;
    80002b32:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b36:	854a                	mv	a0,s2
    80002b38:	00001097          	auipc	ra,0x1
    80002b3c:	ca8080e7          	jalr	-856(ra) # 800037e0 <log_write>
      brelse(bp);
    80002b40:	854a                	mv	a0,s2
    80002b42:	00000097          	auipc	ra,0x0
    80002b46:	a22080e7          	jalr	-1502(ra) # 80002564 <brelse>
      return iget(dev, inum);
    80002b4a:	85da                	mv	a1,s6
    80002b4c:	8556                	mv	a0,s5
    80002b4e:	00000097          	auipc	ra,0x0
    80002b52:	db4080e7          	jalr	-588(ra) # 80002902 <iget>
}
    80002b56:	60a6                	ld	ra,72(sp)
    80002b58:	6406                	ld	s0,64(sp)
    80002b5a:	74e2                	ld	s1,56(sp)
    80002b5c:	7942                	ld	s2,48(sp)
    80002b5e:	79a2                	ld	s3,40(sp)
    80002b60:	7a02                	ld	s4,32(sp)
    80002b62:	6ae2                	ld	s5,24(sp)
    80002b64:	6b42                	ld	s6,16(sp)
    80002b66:	6ba2                	ld	s7,8(sp)
    80002b68:	6161                	addi	sp,sp,80
    80002b6a:	8082                	ret

0000000080002b6c <iupdate>:
{
    80002b6c:	1101                	addi	sp,sp,-32
    80002b6e:	ec06                	sd	ra,24(sp)
    80002b70:	e822                	sd	s0,16(sp)
    80002b72:	e426                	sd	s1,8(sp)
    80002b74:	e04a                	sd	s2,0(sp)
    80002b76:	1000                	addi	s0,sp,32
    80002b78:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b7a:	415c                	lw	a5,4(a0)
    80002b7c:	0047d79b          	srliw	a5,a5,0x4
    80002b80:	00017597          	auipc	a1,0x17
    80002b84:	9f05a583          	lw	a1,-1552(a1) # 80019570 <sb+0x18>
    80002b88:	9dbd                	addw	a1,a1,a5
    80002b8a:	4108                	lw	a0,0(a0)
    80002b8c:	00000097          	auipc	ra,0x0
    80002b90:	8a8080e7          	jalr	-1880(ra) # 80002434 <bread>
    80002b94:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b96:	05850793          	addi	a5,a0,88
    80002b9a:	40c8                	lw	a0,4(s1)
    80002b9c:	893d                	andi	a0,a0,15
    80002b9e:	051a                	slli	a0,a0,0x6
    80002ba0:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002ba2:	04449703          	lh	a4,68(s1)
    80002ba6:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002baa:	04649703          	lh	a4,70(s1)
    80002bae:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002bb2:	04849703          	lh	a4,72(s1)
    80002bb6:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002bba:	04a49703          	lh	a4,74(s1)
    80002bbe:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002bc2:	44f8                	lw	a4,76(s1)
    80002bc4:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bc6:	03400613          	li	a2,52
    80002bca:	05048593          	addi	a1,s1,80
    80002bce:	0531                	addi	a0,a0,12
    80002bd0:	ffffd097          	auipc	ra,0xffffd
    80002bd4:	608080e7          	jalr	1544(ra) # 800001d8 <memmove>
  log_write(bp);
    80002bd8:	854a                	mv	a0,s2
    80002bda:	00001097          	auipc	ra,0x1
    80002bde:	c06080e7          	jalr	-1018(ra) # 800037e0 <log_write>
  brelse(bp);
    80002be2:	854a                	mv	a0,s2
    80002be4:	00000097          	auipc	ra,0x0
    80002be8:	980080e7          	jalr	-1664(ra) # 80002564 <brelse>
}
    80002bec:	60e2                	ld	ra,24(sp)
    80002bee:	6442                	ld	s0,16(sp)
    80002bf0:	64a2                	ld	s1,8(sp)
    80002bf2:	6902                	ld	s2,0(sp)
    80002bf4:	6105                	addi	sp,sp,32
    80002bf6:	8082                	ret

0000000080002bf8 <idup>:
{
    80002bf8:	1101                	addi	sp,sp,-32
    80002bfa:	ec06                	sd	ra,24(sp)
    80002bfc:	e822                	sd	s0,16(sp)
    80002bfe:	e426                	sd	s1,8(sp)
    80002c00:	1000                	addi	s0,sp,32
    80002c02:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c04:	00017517          	auipc	a0,0x17
    80002c08:	97450513          	addi	a0,a0,-1676 # 80019578 <itable>
    80002c0c:	00004097          	auipc	ra,0x4
    80002c10:	964080e7          	jalr	-1692(ra) # 80006570 <acquire>
  ip->ref++;
    80002c14:	449c                	lw	a5,8(s1)
    80002c16:	2785                	addiw	a5,a5,1
    80002c18:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c1a:	00017517          	auipc	a0,0x17
    80002c1e:	95e50513          	addi	a0,a0,-1698 # 80019578 <itable>
    80002c22:	00004097          	auipc	ra,0x4
    80002c26:	a02080e7          	jalr	-1534(ra) # 80006624 <release>
}
    80002c2a:	8526                	mv	a0,s1
    80002c2c:	60e2                	ld	ra,24(sp)
    80002c2e:	6442                	ld	s0,16(sp)
    80002c30:	64a2                	ld	s1,8(sp)
    80002c32:	6105                	addi	sp,sp,32
    80002c34:	8082                	ret

0000000080002c36 <ilock>:
{
    80002c36:	1101                	addi	sp,sp,-32
    80002c38:	ec06                	sd	ra,24(sp)
    80002c3a:	e822                	sd	s0,16(sp)
    80002c3c:	e426                	sd	s1,8(sp)
    80002c3e:	e04a                	sd	s2,0(sp)
    80002c40:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c42:	c115                	beqz	a0,80002c66 <ilock+0x30>
    80002c44:	84aa                	mv	s1,a0
    80002c46:	451c                	lw	a5,8(a0)
    80002c48:	00f05f63          	blez	a5,80002c66 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c4c:	0541                	addi	a0,a0,16
    80002c4e:	00001097          	auipc	ra,0x1
    80002c52:	cb2080e7          	jalr	-846(ra) # 80003900 <acquiresleep>
  if(ip->valid == 0){
    80002c56:	40bc                	lw	a5,64(s1)
    80002c58:	cf99                	beqz	a5,80002c76 <ilock+0x40>
}
    80002c5a:	60e2                	ld	ra,24(sp)
    80002c5c:	6442                	ld	s0,16(sp)
    80002c5e:	64a2                	ld	s1,8(sp)
    80002c60:	6902                	ld	s2,0(sp)
    80002c62:	6105                	addi	sp,sp,32
    80002c64:	8082                	ret
    panic("ilock");
    80002c66:	00006517          	auipc	a0,0x6
    80002c6a:	86a50513          	addi	a0,a0,-1942 # 800084d0 <syscalls+0x190>
    80002c6e:	00003097          	auipc	ra,0x3
    80002c72:	3b8080e7          	jalr	952(ra) # 80006026 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c76:	40dc                	lw	a5,4(s1)
    80002c78:	0047d79b          	srliw	a5,a5,0x4
    80002c7c:	00017597          	auipc	a1,0x17
    80002c80:	8f45a583          	lw	a1,-1804(a1) # 80019570 <sb+0x18>
    80002c84:	9dbd                	addw	a1,a1,a5
    80002c86:	4088                	lw	a0,0(s1)
    80002c88:	fffff097          	auipc	ra,0xfffff
    80002c8c:	7ac080e7          	jalr	1964(ra) # 80002434 <bread>
    80002c90:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c92:	05850593          	addi	a1,a0,88
    80002c96:	40dc                	lw	a5,4(s1)
    80002c98:	8bbd                	andi	a5,a5,15
    80002c9a:	079a                	slli	a5,a5,0x6
    80002c9c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c9e:	00059783          	lh	a5,0(a1)
    80002ca2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ca6:	00259783          	lh	a5,2(a1)
    80002caa:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cae:	00459783          	lh	a5,4(a1)
    80002cb2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cb6:	00659783          	lh	a5,6(a1)
    80002cba:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cbe:	459c                	lw	a5,8(a1)
    80002cc0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cc2:	03400613          	li	a2,52
    80002cc6:	05b1                	addi	a1,a1,12
    80002cc8:	05048513          	addi	a0,s1,80
    80002ccc:	ffffd097          	auipc	ra,0xffffd
    80002cd0:	50c080e7          	jalr	1292(ra) # 800001d8 <memmove>
    brelse(bp);
    80002cd4:	854a                	mv	a0,s2
    80002cd6:	00000097          	auipc	ra,0x0
    80002cda:	88e080e7          	jalr	-1906(ra) # 80002564 <brelse>
    ip->valid = 1;
    80002cde:	4785                	li	a5,1
    80002ce0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ce2:	04449783          	lh	a5,68(s1)
    80002ce6:	fbb5                	bnez	a5,80002c5a <ilock+0x24>
      panic("ilock: no type");
    80002ce8:	00005517          	auipc	a0,0x5
    80002cec:	7f050513          	addi	a0,a0,2032 # 800084d8 <syscalls+0x198>
    80002cf0:	00003097          	auipc	ra,0x3
    80002cf4:	336080e7          	jalr	822(ra) # 80006026 <panic>

0000000080002cf8 <iunlock>:
{
    80002cf8:	1101                	addi	sp,sp,-32
    80002cfa:	ec06                	sd	ra,24(sp)
    80002cfc:	e822                	sd	s0,16(sp)
    80002cfe:	e426                	sd	s1,8(sp)
    80002d00:	e04a                	sd	s2,0(sp)
    80002d02:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d04:	c905                	beqz	a0,80002d34 <iunlock+0x3c>
    80002d06:	84aa                	mv	s1,a0
    80002d08:	01050913          	addi	s2,a0,16
    80002d0c:	854a                	mv	a0,s2
    80002d0e:	00001097          	auipc	ra,0x1
    80002d12:	c8c080e7          	jalr	-884(ra) # 8000399a <holdingsleep>
    80002d16:	cd19                	beqz	a0,80002d34 <iunlock+0x3c>
    80002d18:	449c                	lw	a5,8(s1)
    80002d1a:	00f05d63          	blez	a5,80002d34 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d1e:	854a                	mv	a0,s2
    80002d20:	00001097          	auipc	ra,0x1
    80002d24:	c36080e7          	jalr	-970(ra) # 80003956 <releasesleep>
}
    80002d28:	60e2                	ld	ra,24(sp)
    80002d2a:	6442                	ld	s0,16(sp)
    80002d2c:	64a2                	ld	s1,8(sp)
    80002d2e:	6902                	ld	s2,0(sp)
    80002d30:	6105                	addi	sp,sp,32
    80002d32:	8082                	ret
    panic("iunlock");
    80002d34:	00005517          	auipc	a0,0x5
    80002d38:	7b450513          	addi	a0,a0,1972 # 800084e8 <syscalls+0x1a8>
    80002d3c:	00003097          	auipc	ra,0x3
    80002d40:	2ea080e7          	jalr	746(ra) # 80006026 <panic>

0000000080002d44 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d44:	7179                	addi	sp,sp,-48
    80002d46:	f406                	sd	ra,40(sp)
    80002d48:	f022                	sd	s0,32(sp)
    80002d4a:	ec26                	sd	s1,24(sp)
    80002d4c:	e84a                	sd	s2,16(sp)
    80002d4e:	e44e                	sd	s3,8(sp)
    80002d50:	e052                	sd	s4,0(sp)
    80002d52:	1800                	addi	s0,sp,48
    80002d54:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d56:	05050493          	addi	s1,a0,80
    80002d5a:	08050913          	addi	s2,a0,128
    80002d5e:	a021                	j	80002d66 <itrunc+0x22>
    80002d60:	0491                	addi	s1,s1,4
    80002d62:	01248d63          	beq	s1,s2,80002d7c <itrunc+0x38>
    if(ip->addrs[i]){
    80002d66:	408c                	lw	a1,0(s1)
    80002d68:	dde5                	beqz	a1,80002d60 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d6a:	0009a503          	lw	a0,0(s3)
    80002d6e:	00000097          	auipc	ra,0x0
    80002d72:	90c080e7          	jalr	-1780(ra) # 8000267a <bfree>
      ip->addrs[i] = 0;
    80002d76:	0004a023          	sw	zero,0(s1)
    80002d7a:	b7dd                	j	80002d60 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d7c:	0809a583          	lw	a1,128(s3)
    80002d80:	e185                	bnez	a1,80002da0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d82:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d86:	854e                	mv	a0,s3
    80002d88:	00000097          	auipc	ra,0x0
    80002d8c:	de4080e7          	jalr	-540(ra) # 80002b6c <iupdate>
}
    80002d90:	70a2                	ld	ra,40(sp)
    80002d92:	7402                	ld	s0,32(sp)
    80002d94:	64e2                	ld	s1,24(sp)
    80002d96:	6942                	ld	s2,16(sp)
    80002d98:	69a2                	ld	s3,8(sp)
    80002d9a:	6a02                	ld	s4,0(sp)
    80002d9c:	6145                	addi	sp,sp,48
    80002d9e:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002da0:	0009a503          	lw	a0,0(s3)
    80002da4:	fffff097          	auipc	ra,0xfffff
    80002da8:	690080e7          	jalr	1680(ra) # 80002434 <bread>
    80002dac:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002dae:	05850493          	addi	s1,a0,88
    80002db2:	45850913          	addi	s2,a0,1112
    80002db6:	a811                	j	80002dca <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002db8:	0009a503          	lw	a0,0(s3)
    80002dbc:	00000097          	auipc	ra,0x0
    80002dc0:	8be080e7          	jalr	-1858(ra) # 8000267a <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002dc4:	0491                	addi	s1,s1,4
    80002dc6:	01248563          	beq	s1,s2,80002dd0 <itrunc+0x8c>
      if(a[j])
    80002dca:	408c                	lw	a1,0(s1)
    80002dcc:	dde5                	beqz	a1,80002dc4 <itrunc+0x80>
    80002dce:	b7ed                	j	80002db8 <itrunc+0x74>
    brelse(bp);
    80002dd0:	8552                	mv	a0,s4
    80002dd2:	fffff097          	auipc	ra,0xfffff
    80002dd6:	792080e7          	jalr	1938(ra) # 80002564 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dda:	0809a583          	lw	a1,128(s3)
    80002dde:	0009a503          	lw	a0,0(s3)
    80002de2:	00000097          	auipc	ra,0x0
    80002de6:	898080e7          	jalr	-1896(ra) # 8000267a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dea:	0809a023          	sw	zero,128(s3)
    80002dee:	bf51                	j	80002d82 <itrunc+0x3e>

0000000080002df0 <iput>:
{
    80002df0:	1101                	addi	sp,sp,-32
    80002df2:	ec06                	sd	ra,24(sp)
    80002df4:	e822                	sd	s0,16(sp)
    80002df6:	e426                	sd	s1,8(sp)
    80002df8:	e04a                	sd	s2,0(sp)
    80002dfa:	1000                	addi	s0,sp,32
    80002dfc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dfe:	00016517          	auipc	a0,0x16
    80002e02:	77a50513          	addi	a0,a0,1914 # 80019578 <itable>
    80002e06:	00003097          	auipc	ra,0x3
    80002e0a:	76a080e7          	jalr	1898(ra) # 80006570 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e0e:	4498                	lw	a4,8(s1)
    80002e10:	4785                	li	a5,1
    80002e12:	02f70363          	beq	a4,a5,80002e38 <iput+0x48>
  ip->ref--;
    80002e16:	449c                	lw	a5,8(s1)
    80002e18:	37fd                	addiw	a5,a5,-1
    80002e1a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e1c:	00016517          	auipc	a0,0x16
    80002e20:	75c50513          	addi	a0,a0,1884 # 80019578 <itable>
    80002e24:	00004097          	auipc	ra,0x4
    80002e28:	800080e7          	jalr	-2048(ra) # 80006624 <release>
}
    80002e2c:	60e2                	ld	ra,24(sp)
    80002e2e:	6442                	ld	s0,16(sp)
    80002e30:	64a2                	ld	s1,8(sp)
    80002e32:	6902                	ld	s2,0(sp)
    80002e34:	6105                	addi	sp,sp,32
    80002e36:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e38:	40bc                	lw	a5,64(s1)
    80002e3a:	dff1                	beqz	a5,80002e16 <iput+0x26>
    80002e3c:	04a49783          	lh	a5,74(s1)
    80002e40:	fbf9                	bnez	a5,80002e16 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e42:	01048913          	addi	s2,s1,16
    80002e46:	854a                	mv	a0,s2
    80002e48:	00001097          	auipc	ra,0x1
    80002e4c:	ab8080e7          	jalr	-1352(ra) # 80003900 <acquiresleep>
    release(&itable.lock);
    80002e50:	00016517          	auipc	a0,0x16
    80002e54:	72850513          	addi	a0,a0,1832 # 80019578 <itable>
    80002e58:	00003097          	auipc	ra,0x3
    80002e5c:	7cc080e7          	jalr	1996(ra) # 80006624 <release>
    itrunc(ip);
    80002e60:	8526                	mv	a0,s1
    80002e62:	00000097          	auipc	ra,0x0
    80002e66:	ee2080e7          	jalr	-286(ra) # 80002d44 <itrunc>
    ip->type = 0;
    80002e6a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e6e:	8526                	mv	a0,s1
    80002e70:	00000097          	auipc	ra,0x0
    80002e74:	cfc080e7          	jalr	-772(ra) # 80002b6c <iupdate>
    ip->valid = 0;
    80002e78:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e7c:	854a                	mv	a0,s2
    80002e7e:	00001097          	auipc	ra,0x1
    80002e82:	ad8080e7          	jalr	-1320(ra) # 80003956 <releasesleep>
    acquire(&itable.lock);
    80002e86:	00016517          	auipc	a0,0x16
    80002e8a:	6f250513          	addi	a0,a0,1778 # 80019578 <itable>
    80002e8e:	00003097          	auipc	ra,0x3
    80002e92:	6e2080e7          	jalr	1762(ra) # 80006570 <acquire>
    80002e96:	b741                	j	80002e16 <iput+0x26>

0000000080002e98 <iunlockput>:
{
    80002e98:	1101                	addi	sp,sp,-32
    80002e9a:	ec06                	sd	ra,24(sp)
    80002e9c:	e822                	sd	s0,16(sp)
    80002e9e:	e426                	sd	s1,8(sp)
    80002ea0:	1000                	addi	s0,sp,32
    80002ea2:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ea4:	00000097          	auipc	ra,0x0
    80002ea8:	e54080e7          	jalr	-428(ra) # 80002cf8 <iunlock>
  iput(ip);
    80002eac:	8526                	mv	a0,s1
    80002eae:	00000097          	auipc	ra,0x0
    80002eb2:	f42080e7          	jalr	-190(ra) # 80002df0 <iput>
}
    80002eb6:	60e2                	ld	ra,24(sp)
    80002eb8:	6442                	ld	s0,16(sp)
    80002eba:	64a2                	ld	s1,8(sp)
    80002ebc:	6105                	addi	sp,sp,32
    80002ebe:	8082                	ret

0000000080002ec0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ec0:	1141                	addi	sp,sp,-16
    80002ec2:	e422                	sd	s0,8(sp)
    80002ec4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ec6:	411c                	lw	a5,0(a0)
    80002ec8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002eca:	415c                	lw	a5,4(a0)
    80002ecc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ece:	04451783          	lh	a5,68(a0)
    80002ed2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ed6:	04a51783          	lh	a5,74(a0)
    80002eda:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ede:	04c56783          	lwu	a5,76(a0)
    80002ee2:	e99c                	sd	a5,16(a1)
}
    80002ee4:	6422                	ld	s0,8(sp)
    80002ee6:	0141                	addi	sp,sp,16
    80002ee8:	8082                	ret

0000000080002eea <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eea:	457c                	lw	a5,76(a0)
    80002eec:	0ed7e963          	bltu	a5,a3,80002fde <readi+0xf4>
{
    80002ef0:	7159                	addi	sp,sp,-112
    80002ef2:	f486                	sd	ra,104(sp)
    80002ef4:	f0a2                	sd	s0,96(sp)
    80002ef6:	eca6                	sd	s1,88(sp)
    80002ef8:	e8ca                	sd	s2,80(sp)
    80002efa:	e4ce                	sd	s3,72(sp)
    80002efc:	e0d2                	sd	s4,64(sp)
    80002efe:	fc56                	sd	s5,56(sp)
    80002f00:	f85a                	sd	s6,48(sp)
    80002f02:	f45e                	sd	s7,40(sp)
    80002f04:	f062                	sd	s8,32(sp)
    80002f06:	ec66                	sd	s9,24(sp)
    80002f08:	e86a                	sd	s10,16(sp)
    80002f0a:	e46e                	sd	s11,8(sp)
    80002f0c:	1880                	addi	s0,sp,112
    80002f0e:	8baa                	mv	s7,a0
    80002f10:	8c2e                	mv	s8,a1
    80002f12:	8ab2                	mv	s5,a2
    80002f14:	84b6                	mv	s1,a3
    80002f16:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f18:	9f35                	addw	a4,a4,a3
    return 0;
    80002f1a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f1c:	0ad76063          	bltu	a4,a3,80002fbc <readi+0xd2>
  if(off + n > ip->size)
    80002f20:	00e7f463          	bgeu	a5,a4,80002f28 <readi+0x3e>
    n = ip->size - off;
    80002f24:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f28:	0a0b0963          	beqz	s6,80002fda <readi+0xf0>
    80002f2c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f2e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f32:	5cfd                	li	s9,-1
    80002f34:	a82d                	j	80002f6e <readi+0x84>
    80002f36:	020a1d93          	slli	s11,s4,0x20
    80002f3a:	020ddd93          	srli	s11,s11,0x20
    80002f3e:	05890613          	addi	a2,s2,88
    80002f42:	86ee                	mv	a3,s11
    80002f44:	963a                	add	a2,a2,a4
    80002f46:	85d6                	mv	a1,s5
    80002f48:	8562                	mv	a0,s8
    80002f4a:	fffff097          	auipc	ra,0xfffff
    80002f4e:	a74080e7          	jalr	-1420(ra) # 800019be <either_copyout>
    80002f52:	05950d63          	beq	a0,s9,80002fac <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f56:	854a                	mv	a0,s2
    80002f58:	fffff097          	auipc	ra,0xfffff
    80002f5c:	60c080e7          	jalr	1548(ra) # 80002564 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f60:	013a09bb          	addw	s3,s4,s3
    80002f64:	009a04bb          	addw	s1,s4,s1
    80002f68:	9aee                	add	s5,s5,s11
    80002f6a:	0569f763          	bgeu	s3,s6,80002fb8 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f6e:	000ba903          	lw	s2,0(s7)
    80002f72:	00a4d59b          	srliw	a1,s1,0xa
    80002f76:	855e                	mv	a0,s7
    80002f78:	00000097          	auipc	ra,0x0
    80002f7c:	8b0080e7          	jalr	-1872(ra) # 80002828 <bmap>
    80002f80:	0005059b          	sext.w	a1,a0
    80002f84:	854a                	mv	a0,s2
    80002f86:	fffff097          	auipc	ra,0xfffff
    80002f8a:	4ae080e7          	jalr	1198(ra) # 80002434 <bread>
    80002f8e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f90:	3ff4f713          	andi	a4,s1,1023
    80002f94:	40ed07bb          	subw	a5,s10,a4
    80002f98:	413b06bb          	subw	a3,s6,s3
    80002f9c:	8a3e                	mv	s4,a5
    80002f9e:	2781                	sext.w	a5,a5
    80002fa0:	0006861b          	sext.w	a2,a3
    80002fa4:	f8f679e3          	bgeu	a2,a5,80002f36 <readi+0x4c>
    80002fa8:	8a36                	mv	s4,a3
    80002faa:	b771                	j	80002f36 <readi+0x4c>
      brelse(bp);
    80002fac:	854a                	mv	a0,s2
    80002fae:	fffff097          	auipc	ra,0xfffff
    80002fb2:	5b6080e7          	jalr	1462(ra) # 80002564 <brelse>
      tot = -1;
    80002fb6:	59fd                	li	s3,-1
  }
  return tot;
    80002fb8:	0009851b          	sext.w	a0,s3
}
    80002fbc:	70a6                	ld	ra,104(sp)
    80002fbe:	7406                	ld	s0,96(sp)
    80002fc0:	64e6                	ld	s1,88(sp)
    80002fc2:	6946                	ld	s2,80(sp)
    80002fc4:	69a6                	ld	s3,72(sp)
    80002fc6:	6a06                	ld	s4,64(sp)
    80002fc8:	7ae2                	ld	s5,56(sp)
    80002fca:	7b42                	ld	s6,48(sp)
    80002fcc:	7ba2                	ld	s7,40(sp)
    80002fce:	7c02                	ld	s8,32(sp)
    80002fd0:	6ce2                	ld	s9,24(sp)
    80002fd2:	6d42                	ld	s10,16(sp)
    80002fd4:	6da2                	ld	s11,8(sp)
    80002fd6:	6165                	addi	sp,sp,112
    80002fd8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fda:	89da                	mv	s3,s6
    80002fdc:	bff1                	j	80002fb8 <readi+0xce>
    return 0;
    80002fde:	4501                	li	a0,0
}
    80002fe0:	8082                	ret

0000000080002fe2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fe2:	457c                	lw	a5,76(a0)
    80002fe4:	10d7e863          	bltu	a5,a3,800030f4 <writei+0x112>
{
    80002fe8:	7159                	addi	sp,sp,-112
    80002fea:	f486                	sd	ra,104(sp)
    80002fec:	f0a2                	sd	s0,96(sp)
    80002fee:	eca6                	sd	s1,88(sp)
    80002ff0:	e8ca                	sd	s2,80(sp)
    80002ff2:	e4ce                	sd	s3,72(sp)
    80002ff4:	e0d2                	sd	s4,64(sp)
    80002ff6:	fc56                	sd	s5,56(sp)
    80002ff8:	f85a                	sd	s6,48(sp)
    80002ffa:	f45e                	sd	s7,40(sp)
    80002ffc:	f062                	sd	s8,32(sp)
    80002ffe:	ec66                	sd	s9,24(sp)
    80003000:	e86a                	sd	s10,16(sp)
    80003002:	e46e                	sd	s11,8(sp)
    80003004:	1880                	addi	s0,sp,112
    80003006:	8b2a                	mv	s6,a0
    80003008:	8c2e                	mv	s8,a1
    8000300a:	8ab2                	mv	s5,a2
    8000300c:	8936                	mv	s2,a3
    8000300e:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003010:	00e687bb          	addw	a5,a3,a4
    80003014:	0ed7e263          	bltu	a5,a3,800030f8 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003018:	00043737          	lui	a4,0x43
    8000301c:	0ef76063          	bltu	a4,a5,800030fc <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003020:	0c0b8863          	beqz	s7,800030f0 <writei+0x10e>
    80003024:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003026:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000302a:	5cfd                	li	s9,-1
    8000302c:	a091                	j	80003070 <writei+0x8e>
    8000302e:	02099d93          	slli	s11,s3,0x20
    80003032:	020ddd93          	srli	s11,s11,0x20
    80003036:	05848513          	addi	a0,s1,88
    8000303a:	86ee                	mv	a3,s11
    8000303c:	8656                	mv	a2,s5
    8000303e:	85e2                	mv	a1,s8
    80003040:	953a                	add	a0,a0,a4
    80003042:	fffff097          	auipc	ra,0xfffff
    80003046:	9d2080e7          	jalr	-1582(ra) # 80001a14 <either_copyin>
    8000304a:	07950263          	beq	a0,s9,800030ae <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000304e:	8526                	mv	a0,s1
    80003050:	00000097          	auipc	ra,0x0
    80003054:	790080e7          	jalr	1936(ra) # 800037e0 <log_write>
    brelse(bp);
    80003058:	8526                	mv	a0,s1
    8000305a:	fffff097          	auipc	ra,0xfffff
    8000305e:	50a080e7          	jalr	1290(ra) # 80002564 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003062:	01498a3b          	addw	s4,s3,s4
    80003066:	0129893b          	addw	s2,s3,s2
    8000306a:	9aee                	add	s5,s5,s11
    8000306c:	057a7663          	bgeu	s4,s7,800030b8 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003070:	000b2483          	lw	s1,0(s6)
    80003074:	00a9559b          	srliw	a1,s2,0xa
    80003078:	855a                	mv	a0,s6
    8000307a:	fffff097          	auipc	ra,0xfffff
    8000307e:	7ae080e7          	jalr	1966(ra) # 80002828 <bmap>
    80003082:	0005059b          	sext.w	a1,a0
    80003086:	8526                	mv	a0,s1
    80003088:	fffff097          	auipc	ra,0xfffff
    8000308c:	3ac080e7          	jalr	940(ra) # 80002434 <bread>
    80003090:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003092:	3ff97713          	andi	a4,s2,1023
    80003096:	40ed07bb          	subw	a5,s10,a4
    8000309a:	414b86bb          	subw	a3,s7,s4
    8000309e:	89be                	mv	s3,a5
    800030a0:	2781                	sext.w	a5,a5
    800030a2:	0006861b          	sext.w	a2,a3
    800030a6:	f8f674e3          	bgeu	a2,a5,8000302e <writei+0x4c>
    800030aa:	89b6                	mv	s3,a3
    800030ac:	b749                	j	8000302e <writei+0x4c>
      brelse(bp);
    800030ae:	8526                	mv	a0,s1
    800030b0:	fffff097          	auipc	ra,0xfffff
    800030b4:	4b4080e7          	jalr	1204(ra) # 80002564 <brelse>
  }

  if(off > ip->size)
    800030b8:	04cb2783          	lw	a5,76(s6)
    800030bc:	0127f463          	bgeu	a5,s2,800030c4 <writei+0xe2>
    ip->size = off;
    800030c0:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030c4:	855a                	mv	a0,s6
    800030c6:	00000097          	auipc	ra,0x0
    800030ca:	aa6080e7          	jalr	-1370(ra) # 80002b6c <iupdate>

  return tot;
    800030ce:	000a051b          	sext.w	a0,s4
}
    800030d2:	70a6                	ld	ra,104(sp)
    800030d4:	7406                	ld	s0,96(sp)
    800030d6:	64e6                	ld	s1,88(sp)
    800030d8:	6946                	ld	s2,80(sp)
    800030da:	69a6                	ld	s3,72(sp)
    800030dc:	6a06                	ld	s4,64(sp)
    800030de:	7ae2                	ld	s5,56(sp)
    800030e0:	7b42                	ld	s6,48(sp)
    800030e2:	7ba2                	ld	s7,40(sp)
    800030e4:	7c02                	ld	s8,32(sp)
    800030e6:	6ce2                	ld	s9,24(sp)
    800030e8:	6d42                	ld	s10,16(sp)
    800030ea:	6da2                	ld	s11,8(sp)
    800030ec:	6165                	addi	sp,sp,112
    800030ee:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030f0:	8a5e                	mv	s4,s7
    800030f2:	bfc9                	j	800030c4 <writei+0xe2>
    return -1;
    800030f4:	557d                	li	a0,-1
}
    800030f6:	8082                	ret
    return -1;
    800030f8:	557d                	li	a0,-1
    800030fa:	bfe1                	j	800030d2 <writei+0xf0>
    return -1;
    800030fc:	557d                	li	a0,-1
    800030fe:	bfd1                	j	800030d2 <writei+0xf0>

0000000080003100 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003100:	1141                	addi	sp,sp,-16
    80003102:	e406                	sd	ra,8(sp)
    80003104:	e022                	sd	s0,0(sp)
    80003106:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003108:	4639                	li	a2,14
    8000310a:	ffffd097          	auipc	ra,0xffffd
    8000310e:	146080e7          	jalr	326(ra) # 80000250 <strncmp>
}
    80003112:	60a2                	ld	ra,8(sp)
    80003114:	6402                	ld	s0,0(sp)
    80003116:	0141                	addi	sp,sp,16
    80003118:	8082                	ret

000000008000311a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000311a:	7139                	addi	sp,sp,-64
    8000311c:	fc06                	sd	ra,56(sp)
    8000311e:	f822                	sd	s0,48(sp)
    80003120:	f426                	sd	s1,40(sp)
    80003122:	f04a                	sd	s2,32(sp)
    80003124:	ec4e                	sd	s3,24(sp)
    80003126:	e852                	sd	s4,16(sp)
    80003128:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000312a:	04451703          	lh	a4,68(a0)
    8000312e:	4785                	li	a5,1
    80003130:	00f71a63          	bne	a4,a5,80003144 <dirlookup+0x2a>
    80003134:	892a                	mv	s2,a0
    80003136:	89ae                	mv	s3,a1
    80003138:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000313a:	457c                	lw	a5,76(a0)
    8000313c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000313e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003140:	e79d                	bnez	a5,8000316e <dirlookup+0x54>
    80003142:	a8a5                	j	800031ba <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003144:	00005517          	auipc	a0,0x5
    80003148:	3ac50513          	addi	a0,a0,940 # 800084f0 <syscalls+0x1b0>
    8000314c:	00003097          	auipc	ra,0x3
    80003150:	eda080e7          	jalr	-294(ra) # 80006026 <panic>
      panic("dirlookup read");
    80003154:	00005517          	auipc	a0,0x5
    80003158:	3b450513          	addi	a0,a0,948 # 80008508 <syscalls+0x1c8>
    8000315c:	00003097          	auipc	ra,0x3
    80003160:	eca080e7          	jalr	-310(ra) # 80006026 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003164:	24c1                	addiw	s1,s1,16
    80003166:	04c92783          	lw	a5,76(s2)
    8000316a:	04f4f763          	bgeu	s1,a5,800031b8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000316e:	4741                	li	a4,16
    80003170:	86a6                	mv	a3,s1
    80003172:	fc040613          	addi	a2,s0,-64
    80003176:	4581                	li	a1,0
    80003178:	854a                	mv	a0,s2
    8000317a:	00000097          	auipc	ra,0x0
    8000317e:	d70080e7          	jalr	-656(ra) # 80002eea <readi>
    80003182:	47c1                	li	a5,16
    80003184:	fcf518e3          	bne	a0,a5,80003154 <dirlookup+0x3a>
    if(de.inum == 0)
    80003188:	fc045783          	lhu	a5,-64(s0)
    8000318c:	dfe1                	beqz	a5,80003164 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000318e:	fc240593          	addi	a1,s0,-62
    80003192:	854e                	mv	a0,s3
    80003194:	00000097          	auipc	ra,0x0
    80003198:	f6c080e7          	jalr	-148(ra) # 80003100 <namecmp>
    8000319c:	f561                	bnez	a0,80003164 <dirlookup+0x4a>
      if(poff)
    8000319e:	000a0463          	beqz	s4,800031a6 <dirlookup+0x8c>
        *poff = off;
    800031a2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031a6:	fc045583          	lhu	a1,-64(s0)
    800031aa:	00092503          	lw	a0,0(s2)
    800031ae:	fffff097          	auipc	ra,0xfffff
    800031b2:	754080e7          	jalr	1876(ra) # 80002902 <iget>
    800031b6:	a011                	j	800031ba <dirlookup+0xa0>
  return 0;
    800031b8:	4501                	li	a0,0
}
    800031ba:	70e2                	ld	ra,56(sp)
    800031bc:	7442                	ld	s0,48(sp)
    800031be:	74a2                	ld	s1,40(sp)
    800031c0:	7902                	ld	s2,32(sp)
    800031c2:	69e2                	ld	s3,24(sp)
    800031c4:	6a42                	ld	s4,16(sp)
    800031c6:	6121                	addi	sp,sp,64
    800031c8:	8082                	ret

00000000800031ca <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031ca:	711d                	addi	sp,sp,-96
    800031cc:	ec86                	sd	ra,88(sp)
    800031ce:	e8a2                	sd	s0,80(sp)
    800031d0:	e4a6                	sd	s1,72(sp)
    800031d2:	e0ca                	sd	s2,64(sp)
    800031d4:	fc4e                	sd	s3,56(sp)
    800031d6:	f852                	sd	s4,48(sp)
    800031d8:	f456                	sd	s5,40(sp)
    800031da:	f05a                	sd	s6,32(sp)
    800031dc:	ec5e                	sd	s7,24(sp)
    800031de:	e862                	sd	s8,16(sp)
    800031e0:	e466                	sd	s9,8(sp)
    800031e2:	1080                	addi	s0,sp,96
    800031e4:	84aa                	mv	s1,a0
    800031e6:	8b2e                	mv	s6,a1
    800031e8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031ea:	00054703          	lbu	a4,0(a0)
    800031ee:	02f00793          	li	a5,47
    800031f2:	02f70363          	beq	a4,a5,80003218 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031f6:	ffffe097          	auipc	ra,0xffffe
    800031fa:	c40080e7          	jalr	-960(ra) # 80000e36 <myproc>
    800031fe:	15053503          	ld	a0,336(a0)
    80003202:	00000097          	auipc	ra,0x0
    80003206:	9f6080e7          	jalr	-1546(ra) # 80002bf8 <idup>
    8000320a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000320c:	02f00913          	li	s2,47
  len = path - s;
    80003210:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003212:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003214:	4c05                	li	s8,1
    80003216:	a865                	j	800032ce <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003218:	4585                	li	a1,1
    8000321a:	4505                	li	a0,1
    8000321c:	fffff097          	auipc	ra,0xfffff
    80003220:	6e6080e7          	jalr	1766(ra) # 80002902 <iget>
    80003224:	89aa                	mv	s3,a0
    80003226:	b7dd                	j	8000320c <namex+0x42>
      iunlockput(ip);
    80003228:	854e                	mv	a0,s3
    8000322a:	00000097          	auipc	ra,0x0
    8000322e:	c6e080e7          	jalr	-914(ra) # 80002e98 <iunlockput>
      return 0;
    80003232:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003234:	854e                	mv	a0,s3
    80003236:	60e6                	ld	ra,88(sp)
    80003238:	6446                	ld	s0,80(sp)
    8000323a:	64a6                	ld	s1,72(sp)
    8000323c:	6906                	ld	s2,64(sp)
    8000323e:	79e2                	ld	s3,56(sp)
    80003240:	7a42                	ld	s4,48(sp)
    80003242:	7aa2                	ld	s5,40(sp)
    80003244:	7b02                	ld	s6,32(sp)
    80003246:	6be2                	ld	s7,24(sp)
    80003248:	6c42                	ld	s8,16(sp)
    8000324a:	6ca2                	ld	s9,8(sp)
    8000324c:	6125                	addi	sp,sp,96
    8000324e:	8082                	ret
      iunlock(ip);
    80003250:	854e                	mv	a0,s3
    80003252:	00000097          	auipc	ra,0x0
    80003256:	aa6080e7          	jalr	-1370(ra) # 80002cf8 <iunlock>
      return ip;
    8000325a:	bfe9                	j	80003234 <namex+0x6a>
      iunlockput(ip);
    8000325c:	854e                	mv	a0,s3
    8000325e:	00000097          	auipc	ra,0x0
    80003262:	c3a080e7          	jalr	-966(ra) # 80002e98 <iunlockput>
      return 0;
    80003266:	89d2                	mv	s3,s4
    80003268:	b7f1                	j	80003234 <namex+0x6a>
  len = path - s;
    8000326a:	40b48633          	sub	a2,s1,a1
    8000326e:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003272:	094cd463          	bge	s9,s4,800032fa <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003276:	4639                	li	a2,14
    80003278:	8556                	mv	a0,s5
    8000327a:	ffffd097          	auipc	ra,0xffffd
    8000327e:	f5e080e7          	jalr	-162(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003282:	0004c783          	lbu	a5,0(s1)
    80003286:	01279763          	bne	a5,s2,80003294 <namex+0xca>
    path++;
    8000328a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000328c:	0004c783          	lbu	a5,0(s1)
    80003290:	ff278de3          	beq	a5,s2,8000328a <namex+0xc0>
    ilock(ip);
    80003294:	854e                	mv	a0,s3
    80003296:	00000097          	auipc	ra,0x0
    8000329a:	9a0080e7          	jalr	-1632(ra) # 80002c36 <ilock>
    if(ip->type != T_DIR){
    8000329e:	04499783          	lh	a5,68(s3)
    800032a2:	f98793e3          	bne	a5,s8,80003228 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800032a6:	000b0563          	beqz	s6,800032b0 <namex+0xe6>
    800032aa:	0004c783          	lbu	a5,0(s1)
    800032ae:	d3cd                	beqz	a5,80003250 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032b0:	865e                	mv	a2,s7
    800032b2:	85d6                	mv	a1,s5
    800032b4:	854e                	mv	a0,s3
    800032b6:	00000097          	auipc	ra,0x0
    800032ba:	e64080e7          	jalr	-412(ra) # 8000311a <dirlookup>
    800032be:	8a2a                	mv	s4,a0
    800032c0:	dd51                	beqz	a0,8000325c <namex+0x92>
    iunlockput(ip);
    800032c2:	854e                	mv	a0,s3
    800032c4:	00000097          	auipc	ra,0x0
    800032c8:	bd4080e7          	jalr	-1068(ra) # 80002e98 <iunlockput>
    ip = next;
    800032cc:	89d2                	mv	s3,s4
  while(*path == '/')
    800032ce:	0004c783          	lbu	a5,0(s1)
    800032d2:	05279763          	bne	a5,s2,80003320 <namex+0x156>
    path++;
    800032d6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032d8:	0004c783          	lbu	a5,0(s1)
    800032dc:	ff278de3          	beq	a5,s2,800032d6 <namex+0x10c>
  if(*path == 0)
    800032e0:	c79d                	beqz	a5,8000330e <namex+0x144>
    path++;
    800032e2:	85a6                	mv	a1,s1
  len = path - s;
    800032e4:	8a5e                	mv	s4,s7
    800032e6:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032e8:	01278963          	beq	a5,s2,800032fa <namex+0x130>
    800032ec:	dfbd                	beqz	a5,8000326a <namex+0xa0>
    path++;
    800032ee:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800032f0:	0004c783          	lbu	a5,0(s1)
    800032f4:	ff279ce3          	bne	a5,s2,800032ec <namex+0x122>
    800032f8:	bf8d                	j	8000326a <namex+0xa0>
    memmove(name, s, len);
    800032fa:	2601                	sext.w	a2,a2
    800032fc:	8556                	mv	a0,s5
    800032fe:	ffffd097          	auipc	ra,0xffffd
    80003302:	eda080e7          	jalr	-294(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003306:	9a56                	add	s4,s4,s5
    80003308:	000a0023          	sb	zero,0(s4)
    8000330c:	bf9d                	j	80003282 <namex+0xb8>
  if(nameiparent){
    8000330e:	f20b03e3          	beqz	s6,80003234 <namex+0x6a>
    iput(ip);
    80003312:	854e                	mv	a0,s3
    80003314:	00000097          	auipc	ra,0x0
    80003318:	adc080e7          	jalr	-1316(ra) # 80002df0 <iput>
    return 0;
    8000331c:	4981                	li	s3,0
    8000331e:	bf19                	j	80003234 <namex+0x6a>
  if(*path == 0)
    80003320:	d7fd                	beqz	a5,8000330e <namex+0x144>
  while(*path != '/' && *path != 0)
    80003322:	0004c783          	lbu	a5,0(s1)
    80003326:	85a6                	mv	a1,s1
    80003328:	b7d1                	j	800032ec <namex+0x122>

000000008000332a <dirlink>:
{
    8000332a:	7139                	addi	sp,sp,-64
    8000332c:	fc06                	sd	ra,56(sp)
    8000332e:	f822                	sd	s0,48(sp)
    80003330:	f426                	sd	s1,40(sp)
    80003332:	f04a                	sd	s2,32(sp)
    80003334:	ec4e                	sd	s3,24(sp)
    80003336:	e852                	sd	s4,16(sp)
    80003338:	0080                	addi	s0,sp,64
    8000333a:	892a                	mv	s2,a0
    8000333c:	8a2e                	mv	s4,a1
    8000333e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003340:	4601                	li	a2,0
    80003342:	00000097          	auipc	ra,0x0
    80003346:	dd8080e7          	jalr	-552(ra) # 8000311a <dirlookup>
    8000334a:	e93d                	bnez	a0,800033c0 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000334c:	04c92483          	lw	s1,76(s2)
    80003350:	c49d                	beqz	s1,8000337e <dirlink+0x54>
    80003352:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003354:	4741                	li	a4,16
    80003356:	86a6                	mv	a3,s1
    80003358:	fc040613          	addi	a2,s0,-64
    8000335c:	4581                	li	a1,0
    8000335e:	854a                	mv	a0,s2
    80003360:	00000097          	auipc	ra,0x0
    80003364:	b8a080e7          	jalr	-1142(ra) # 80002eea <readi>
    80003368:	47c1                	li	a5,16
    8000336a:	06f51163          	bne	a0,a5,800033cc <dirlink+0xa2>
    if(de.inum == 0)
    8000336e:	fc045783          	lhu	a5,-64(s0)
    80003372:	c791                	beqz	a5,8000337e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003374:	24c1                	addiw	s1,s1,16
    80003376:	04c92783          	lw	a5,76(s2)
    8000337a:	fcf4ede3          	bltu	s1,a5,80003354 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000337e:	4639                	li	a2,14
    80003380:	85d2                	mv	a1,s4
    80003382:	fc240513          	addi	a0,s0,-62
    80003386:	ffffd097          	auipc	ra,0xffffd
    8000338a:	f06080e7          	jalr	-250(ra) # 8000028c <strncpy>
  de.inum = inum;
    8000338e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003392:	4741                	li	a4,16
    80003394:	86a6                	mv	a3,s1
    80003396:	fc040613          	addi	a2,s0,-64
    8000339a:	4581                	li	a1,0
    8000339c:	854a                	mv	a0,s2
    8000339e:	00000097          	auipc	ra,0x0
    800033a2:	c44080e7          	jalr	-956(ra) # 80002fe2 <writei>
    800033a6:	872a                	mv	a4,a0
    800033a8:	47c1                	li	a5,16
  return 0;
    800033aa:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033ac:	02f71863          	bne	a4,a5,800033dc <dirlink+0xb2>
}
    800033b0:	70e2                	ld	ra,56(sp)
    800033b2:	7442                	ld	s0,48(sp)
    800033b4:	74a2                	ld	s1,40(sp)
    800033b6:	7902                	ld	s2,32(sp)
    800033b8:	69e2                	ld	s3,24(sp)
    800033ba:	6a42                	ld	s4,16(sp)
    800033bc:	6121                	addi	sp,sp,64
    800033be:	8082                	ret
    iput(ip);
    800033c0:	00000097          	auipc	ra,0x0
    800033c4:	a30080e7          	jalr	-1488(ra) # 80002df0 <iput>
    return -1;
    800033c8:	557d                	li	a0,-1
    800033ca:	b7dd                	j	800033b0 <dirlink+0x86>
      panic("dirlink read");
    800033cc:	00005517          	auipc	a0,0x5
    800033d0:	14c50513          	addi	a0,a0,332 # 80008518 <syscalls+0x1d8>
    800033d4:	00003097          	auipc	ra,0x3
    800033d8:	c52080e7          	jalr	-942(ra) # 80006026 <panic>
    panic("dirlink");
    800033dc:	00005517          	auipc	a0,0x5
    800033e0:	24c50513          	addi	a0,a0,588 # 80008628 <syscalls+0x2e8>
    800033e4:	00003097          	auipc	ra,0x3
    800033e8:	c42080e7          	jalr	-958(ra) # 80006026 <panic>

00000000800033ec <namei>:

struct inode*
namei(char *path)
{
    800033ec:	1101                	addi	sp,sp,-32
    800033ee:	ec06                	sd	ra,24(sp)
    800033f0:	e822                	sd	s0,16(sp)
    800033f2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033f4:	fe040613          	addi	a2,s0,-32
    800033f8:	4581                	li	a1,0
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	dd0080e7          	jalr	-560(ra) # 800031ca <namex>
}
    80003402:	60e2                	ld	ra,24(sp)
    80003404:	6442                	ld	s0,16(sp)
    80003406:	6105                	addi	sp,sp,32
    80003408:	8082                	ret

000000008000340a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000340a:	1141                	addi	sp,sp,-16
    8000340c:	e406                	sd	ra,8(sp)
    8000340e:	e022                	sd	s0,0(sp)
    80003410:	0800                	addi	s0,sp,16
    80003412:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003414:	4585                	li	a1,1
    80003416:	00000097          	auipc	ra,0x0
    8000341a:	db4080e7          	jalr	-588(ra) # 800031ca <namex>
}
    8000341e:	60a2                	ld	ra,8(sp)
    80003420:	6402                	ld	s0,0(sp)
    80003422:	0141                	addi	sp,sp,16
    80003424:	8082                	ret

0000000080003426 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003426:	1101                	addi	sp,sp,-32
    80003428:	ec06                	sd	ra,24(sp)
    8000342a:	e822                	sd	s0,16(sp)
    8000342c:	e426                	sd	s1,8(sp)
    8000342e:	e04a                	sd	s2,0(sp)
    80003430:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003432:	00018917          	auipc	s2,0x18
    80003436:	bee90913          	addi	s2,s2,-1042 # 8001b020 <log>
    8000343a:	01892583          	lw	a1,24(s2)
    8000343e:	02892503          	lw	a0,40(s2)
    80003442:	fffff097          	auipc	ra,0xfffff
    80003446:	ff2080e7          	jalr	-14(ra) # 80002434 <bread>
    8000344a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000344c:	02c92683          	lw	a3,44(s2)
    80003450:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003452:	02d05763          	blez	a3,80003480 <write_head+0x5a>
    80003456:	00018797          	auipc	a5,0x18
    8000345a:	bfa78793          	addi	a5,a5,-1030 # 8001b050 <log+0x30>
    8000345e:	05c50713          	addi	a4,a0,92
    80003462:	36fd                	addiw	a3,a3,-1
    80003464:	1682                	slli	a3,a3,0x20
    80003466:	9281                	srli	a3,a3,0x20
    80003468:	068a                	slli	a3,a3,0x2
    8000346a:	00018617          	auipc	a2,0x18
    8000346e:	bea60613          	addi	a2,a2,-1046 # 8001b054 <log+0x34>
    80003472:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003474:	4390                	lw	a2,0(a5)
    80003476:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003478:	0791                	addi	a5,a5,4
    8000347a:	0711                	addi	a4,a4,4
    8000347c:	fed79ce3          	bne	a5,a3,80003474 <write_head+0x4e>
  }
  bwrite(buf);
    80003480:	8526                	mv	a0,s1
    80003482:	fffff097          	auipc	ra,0xfffff
    80003486:	0a4080e7          	jalr	164(ra) # 80002526 <bwrite>
  brelse(buf);
    8000348a:	8526                	mv	a0,s1
    8000348c:	fffff097          	auipc	ra,0xfffff
    80003490:	0d8080e7          	jalr	216(ra) # 80002564 <brelse>
}
    80003494:	60e2                	ld	ra,24(sp)
    80003496:	6442                	ld	s0,16(sp)
    80003498:	64a2                	ld	s1,8(sp)
    8000349a:	6902                	ld	s2,0(sp)
    8000349c:	6105                	addi	sp,sp,32
    8000349e:	8082                	ret

00000000800034a0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a0:	00018797          	auipc	a5,0x18
    800034a4:	bac7a783          	lw	a5,-1108(a5) # 8001b04c <log+0x2c>
    800034a8:	0af05d63          	blez	a5,80003562 <install_trans+0xc2>
{
    800034ac:	7139                	addi	sp,sp,-64
    800034ae:	fc06                	sd	ra,56(sp)
    800034b0:	f822                	sd	s0,48(sp)
    800034b2:	f426                	sd	s1,40(sp)
    800034b4:	f04a                	sd	s2,32(sp)
    800034b6:	ec4e                	sd	s3,24(sp)
    800034b8:	e852                	sd	s4,16(sp)
    800034ba:	e456                	sd	s5,8(sp)
    800034bc:	e05a                	sd	s6,0(sp)
    800034be:	0080                	addi	s0,sp,64
    800034c0:	8b2a                	mv	s6,a0
    800034c2:	00018a97          	auipc	s5,0x18
    800034c6:	b8ea8a93          	addi	s5,s5,-1138 # 8001b050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ca:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034cc:	00018997          	auipc	s3,0x18
    800034d0:	b5498993          	addi	s3,s3,-1196 # 8001b020 <log>
    800034d4:	a035                	j	80003500 <install_trans+0x60>
      bunpin(dbuf);
    800034d6:	8526                	mv	a0,s1
    800034d8:	fffff097          	auipc	ra,0xfffff
    800034dc:	166080e7          	jalr	358(ra) # 8000263e <bunpin>
    brelse(lbuf);
    800034e0:	854a                	mv	a0,s2
    800034e2:	fffff097          	auipc	ra,0xfffff
    800034e6:	082080e7          	jalr	130(ra) # 80002564 <brelse>
    brelse(dbuf);
    800034ea:	8526                	mv	a0,s1
    800034ec:	fffff097          	auipc	ra,0xfffff
    800034f0:	078080e7          	jalr	120(ra) # 80002564 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034f4:	2a05                	addiw	s4,s4,1
    800034f6:	0a91                	addi	s5,s5,4
    800034f8:	02c9a783          	lw	a5,44(s3)
    800034fc:	04fa5963          	bge	s4,a5,8000354e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003500:	0189a583          	lw	a1,24(s3)
    80003504:	014585bb          	addw	a1,a1,s4
    80003508:	2585                	addiw	a1,a1,1
    8000350a:	0289a503          	lw	a0,40(s3)
    8000350e:	fffff097          	auipc	ra,0xfffff
    80003512:	f26080e7          	jalr	-218(ra) # 80002434 <bread>
    80003516:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003518:	000aa583          	lw	a1,0(s5)
    8000351c:	0289a503          	lw	a0,40(s3)
    80003520:	fffff097          	auipc	ra,0xfffff
    80003524:	f14080e7          	jalr	-236(ra) # 80002434 <bread>
    80003528:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000352a:	40000613          	li	a2,1024
    8000352e:	05890593          	addi	a1,s2,88
    80003532:	05850513          	addi	a0,a0,88
    80003536:	ffffd097          	auipc	ra,0xffffd
    8000353a:	ca2080e7          	jalr	-862(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000353e:	8526                	mv	a0,s1
    80003540:	fffff097          	auipc	ra,0xfffff
    80003544:	fe6080e7          	jalr	-26(ra) # 80002526 <bwrite>
    if(recovering == 0)
    80003548:	f80b1ce3          	bnez	s6,800034e0 <install_trans+0x40>
    8000354c:	b769                	j	800034d6 <install_trans+0x36>
}
    8000354e:	70e2                	ld	ra,56(sp)
    80003550:	7442                	ld	s0,48(sp)
    80003552:	74a2                	ld	s1,40(sp)
    80003554:	7902                	ld	s2,32(sp)
    80003556:	69e2                	ld	s3,24(sp)
    80003558:	6a42                	ld	s4,16(sp)
    8000355a:	6aa2                	ld	s5,8(sp)
    8000355c:	6b02                	ld	s6,0(sp)
    8000355e:	6121                	addi	sp,sp,64
    80003560:	8082                	ret
    80003562:	8082                	ret

0000000080003564 <initlog>:
{
    80003564:	7179                	addi	sp,sp,-48
    80003566:	f406                	sd	ra,40(sp)
    80003568:	f022                	sd	s0,32(sp)
    8000356a:	ec26                	sd	s1,24(sp)
    8000356c:	e84a                	sd	s2,16(sp)
    8000356e:	e44e                	sd	s3,8(sp)
    80003570:	1800                	addi	s0,sp,48
    80003572:	892a                	mv	s2,a0
    80003574:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003576:	00018497          	auipc	s1,0x18
    8000357a:	aaa48493          	addi	s1,s1,-1366 # 8001b020 <log>
    8000357e:	00005597          	auipc	a1,0x5
    80003582:	faa58593          	addi	a1,a1,-86 # 80008528 <syscalls+0x1e8>
    80003586:	8526                	mv	a0,s1
    80003588:	00003097          	auipc	ra,0x3
    8000358c:	f58080e7          	jalr	-168(ra) # 800064e0 <initlock>
  log.start = sb->logstart;
    80003590:	0149a583          	lw	a1,20(s3)
    80003594:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003596:	0109a783          	lw	a5,16(s3)
    8000359a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000359c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035a0:	854a                	mv	a0,s2
    800035a2:	fffff097          	auipc	ra,0xfffff
    800035a6:	e92080e7          	jalr	-366(ra) # 80002434 <bread>
  log.lh.n = lh->n;
    800035aa:	4d3c                	lw	a5,88(a0)
    800035ac:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035ae:	02f05563          	blez	a5,800035d8 <initlog+0x74>
    800035b2:	05c50713          	addi	a4,a0,92
    800035b6:	00018697          	auipc	a3,0x18
    800035ba:	a9a68693          	addi	a3,a3,-1382 # 8001b050 <log+0x30>
    800035be:	37fd                	addiw	a5,a5,-1
    800035c0:	1782                	slli	a5,a5,0x20
    800035c2:	9381                	srli	a5,a5,0x20
    800035c4:	078a                	slli	a5,a5,0x2
    800035c6:	06050613          	addi	a2,a0,96
    800035ca:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800035cc:	4310                	lw	a2,0(a4)
    800035ce:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800035d0:	0711                	addi	a4,a4,4
    800035d2:	0691                	addi	a3,a3,4
    800035d4:	fef71ce3          	bne	a4,a5,800035cc <initlog+0x68>
  brelse(buf);
    800035d8:	fffff097          	auipc	ra,0xfffff
    800035dc:	f8c080e7          	jalr	-116(ra) # 80002564 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035e0:	4505                	li	a0,1
    800035e2:	00000097          	auipc	ra,0x0
    800035e6:	ebe080e7          	jalr	-322(ra) # 800034a0 <install_trans>
  log.lh.n = 0;
    800035ea:	00018797          	auipc	a5,0x18
    800035ee:	a607a123          	sw	zero,-1438(a5) # 8001b04c <log+0x2c>
  write_head(); // clear the log
    800035f2:	00000097          	auipc	ra,0x0
    800035f6:	e34080e7          	jalr	-460(ra) # 80003426 <write_head>
}
    800035fa:	70a2                	ld	ra,40(sp)
    800035fc:	7402                	ld	s0,32(sp)
    800035fe:	64e2                	ld	s1,24(sp)
    80003600:	6942                	ld	s2,16(sp)
    80003602:	69a2                	ld	s3,8(sp)
    80003604:	6145                	addi	sp,sp,48
    80003606:	8082                	ret

0000000080003608 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003608:	1101                	addi	sp,sp,-32
    8000360a:	ec06                	sd	ra,24(sp)
    8000360c:	e822                	sd	s0,16(sp)
    8000360e:	e426                	sd	s1,8(sp)
    80003610:	e04a                	sd	s2,0(sp)
    80003612:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003614:	00018517          	auipc	a0,0x18
    80003618:	a0c50513          	addi	a0,a0,-1524 # 8001b020 <log>
    8000361c:	00003097          	auipc	ra,0x3
    80003620:	f54080e7          	jalr	-172(ra) # 80006570 <acquire>
  while(1){
    if(log.committing){
    80003624:	00018497          	auipc	s1,0x18
    80003628:	9fc48493          	addi	s1,s1,-1540 # 8001b020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000362c:	4979                	li	s2,30
    8000362e:	a039                	j	8000363c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003630:	85a6                	mv	a1,s1
    80003632:	8526                	mv	a0,s1
    80003634:	ffffe097          	auipc	ra,0xffffe
    80003638:	f52080e7          	jalr	-174(ra) # 80001586 <sleep>
    if(log.committing){
    8000363c:	50dc                	lw	a5,36(s1)
    8000363e:	fbed                	bnez	a5,80003630 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003640:	509c                	lw	a5,32(s1)
    80003642:	0017871b          	addiw	a4,a5,1
    80003646:	0007069b          	sext.w	a3,a4
    8000364a:	0027179b          	slliw	a5,a4,0x2
    8000364e:	9fb9                	addw	a5,a5,a4
    80003650:	0017979b          	slliw	a5,a5,0x1
    80003654:	54d8                	lw	a4,44(s1)
    80003656:	9fb9                	addw	a5,a5,a4
    80003658:	00f95963          	bge	s2,a5,8000366a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000365c:	85a6                	mv	a1,s1
    8000365e:	8526                	mv	a0,s1
    80003660:	ffffe097          	auipc	ra,0xffffe
    80003664:	f26080e7          	jalr	-218(ra) # 80001586 <sleep>
    80003668:	bfd1                	j	8000363c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000366a:	00018517          	auipc	a0,0x18
    8000366e:	9b650513          	addi	a0,a0,-1610 # 8001b020 <log>
    80003672:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003674:	00003097          	auipc	ra,0x3
    80003678:	fb0080e7          	jalr	-80(ra) # 80006624 <release>
      break;
    }
  }
}
    8000367c:	60e2                	ld	ra,24(sp)
    8000367e:	6442                	ld	s0,16(sp)
    80003680:	64a2                	ld	s1,8(sp)
    80003682:	6902                	ld	s2,0(sp)
    80003684:	6105                	addi	sp,sp,32
    80003686:	8082                	ret

0000000080003688 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003688:	7139                	addi	sp,sp,-64
    8000368a:	fc06                	sd	ra,56(sp)
    8000368c:	f822                	sd	s0,48(sp)
    8000368e:	f426                	sd	s1,40(sp)
    80003690:	f04a                	sd	s2,32(sp)
    80003692:	ec4e                	sd	s3,24(sp)
    80003694:	e852                	sd	s4,16(sp)
    80003696:	e456                	sd	s5,8(sp)
    80003698:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000369a:	00018497          	auipc	s1,0x18
    8000369e:	98648493          	addi	s1,s1,-1658 # 8001b020 <log>
    800036a2:	8526                	mv	a0,s1
    800036a4:	00003097          	auipc	ra,0x3
    800036a8:	ecc080e7          	jalr	-308(ra) # 80006570 <acquire>
  log.outstanding -= 1;
    800036ac:	509c                	lw	a5,32(s1)
    800036ae:	37fd                	addiw	a5,a5,-1
    800036b0:	0007891b          	sext.w	s2,a5
    800036b4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036b6:	50dc                	lw	a5,36(s1)
    800036b8:	efb9                	bnez	a5,80003716 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036ba:	06091663          	bnez	s2,80003726 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800036be:	00018497          	auipc	s1,0x18
    800036c2:	96248493          	addi	s1,s1,-1694 # 8001b020 <log>
    800036c6:	4785                	li	a5,1
    800036c8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036ca:	8526                	mv	a0,s1
    800036cc:	00003097          	auipc	ra,0x3
    800036d0:	f58080e7          	jalr	-168(ra) # 80006624 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036d4:	54dc                	lw	a5,44(s1)
    800036d6:	06f04763          	bgtz	a5,80003744 <end_op+0xbc>
    acquire(&log.lock);
    800036da:	00018497          	auipc	s1,0x18
    800036de:	94648493          	addi	s1,s1,-1722 # 8001b020 <log>
    800036e2:	8526                	mv	a0,s1
    800036e4:	00003097          	auipc	ra,0x3
    800036e8:	e8c080e7          	jalr	-372(ra) # 80006570 <acquire>
    log.committing = 0;
    800036ec:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036f0:	8526                	mv	a0,s1
    800036f2:	ffffe097          	auipc	ra,0xffffe
    800036f6:	020080e7          	jalr	32(ra) # 80001712 <wakeup>
    release(&log.lock);
    800036fa:	8526                	mv	a0,s1
    800036fc:	00003097          	auipc	ra,0x3
    80003700:	f28080e7          	jalr	-216(ra) # 80006624 <release>
}
    80003704:	70e2                	ld	ra,56(sp)
    80003706:	7442                	ld	s0,48(sp)
    80003708:	74a2                	ld	s1,40(sp)
    8000370a:	7902                	ld	s2,32(sp)
    8000370c:	69e2                	ld	s3,24(sp)
    8000370e:	6a42                	ld	s4,16(sp)
    80003710:	6aa2                	ld	s5,8(sp)
    80003712:	6121                	addi	sp,sp,64
    80003714:	8082                	ret
    panic("log.committing");
    80003716:	00005517          	auipc	a0,0x5
    8000371a:	e1a50513          	addi	a0,a0,-486 # 80008530 <syscalls+0x1f0>
    8000371e:	00003097          	auipc	ra,0x3
    80003722:	908080e7          	jalr	-1784(ra) # 80006026 <panic>
    wakeup(&log);
    80003726:	00018497          	auipc	s1,0x18
    8000372a:	8fa48493          	addi	s1,s1,-1798 # 8001b020 <log>
    8000372e:	8526                	mv	a0,s1
    80003730:	ffffe097          	auipc	ra,0xffffe
    80003734:	fe2080e7          	jalr	-30(ra) # 80001712 <wakeup>
  release(&log.lock);
    80003738:	8526                	mv	a0,s1
    8000373a:	00003097          	auipc	ra,0x3
    8000373e:	eea080e7          	jalr	-278(ra) # 80006624 <release>
  if(do_commit){
    80003742:	b7c9                	j	80003704 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003744:	00018a97          	auipc	s5,0x18
    80003748:	90ca8a93          	addi	s5,s5,-1780 # 8001b050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000374c:	00018a17          	auipc	s4,0x18
    80003750:	8d4a0a13          	addi	s4,s4,-1836 # 8001b020 <log>
    80003754:	018a2583          	lw	a1,24(s4)
    80003758:	012585bb          	addw	a1,a1,s2
    8000375c:	2585                	addiw	a1,a1,1
    8000375e:	028a2503          	lw	a0,40(s4)
    80003762:	fffff097          	auipc	ra,0xfffff
    80003766:	cd2080e7          	jalr	-814(ra) # 80002434 <bread>
    8000376a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000376c:	000aa583          	lw	a1,0(s5)
    80003770:	028a2503          	lw	a0,40(s4)
    80003774:	fffff097          	auipc	ra,0xfffff
    80003778:	cc0080e7          	jalr	-832(ra) # 80002434 <bread>
    8000377c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000377e:	40000613          	li	a2,1024
    80003782:	05850593          	addi	a1,a0,88
    80003786:	05848513          	addi	a0,s1,88
    8000378a:	ffffd097          	auipc	ra,0xffffd
    8000378e:	a4e080e7          	jalr	-1458(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003792:	8526                	mv	a0,s1
    80003794:	fffff097          	auipc	ra,0xfffff
    80003798:	d92080e7          	jalr	-622(ra) # 80002526 <bwrite>
    brelse(from);
    8000379c:	854e                	mv	a0,s3
    8000379e:	fffff097          	auipc	ra,0xfffff
    800037a2:	dc6080e7          	jalr	-570(ra) # 80002564 <brelse>
    brelse(to);
    800037a6:	8526                	mv	a0,s1
    800037a8:	fffff097          	auipc	ra,0xfffff
    800037ac:	dbc080e7          	jalr	-580(ra) # 80002564 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037b0:	2905                	addiw	s2,s2,1
    800037b2:	0a91                	addi	s5,s5,4
    800037b4:	02ca2783          	lw	a5,44(s4)
    800037b8:	f8f94ee3          	blt	s2,a5,80003754 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037bc:	00000097          	auipc	ra,0x0
    800037c0:	c6a080e7          	jalr	-918(ra) # 80003426 <write_head>
    install_trans(0); // Now install writes to home locations
    800037c4:	4501                	li	a0,0
    800037c6:	00000097          	auipc	ra,0x0
    800037ca:	cda080e7          	jalr	-806(ra) # 800034a0 <install_trans>
    log.lh.n = 0;
    800037ce:	00018797          	auipc	a5,0x18
    800037d2:	8607af23          	sw	zero,-1922(a5) # 8001b04c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037d6:	00000097          	auipc	ra,0x0
    800037da:	c50080e7          	jalr	-944(ra) # 80003426 <write_head>
    800037de:	bdf5                	j	800036da <end_op+0x52>

00000000800037e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037e0:	1101                	addi	sp,sp,-32
    800037e2:	ec06                	sd	ra,24(sp)
    800037e4:	e822                	sd	s0,16(sp)
    800037e6:	e426                	sd	s1,8(sp)
    800037e8:	e04a                	sd	s2,0(sp)
    800037ea:	1000                	addi	s0,sp,32
    800037ec:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037ee:	00018917          	auipc	s2,0x18
    800037f2:	83290913          	addi	s2,s2,-1998 # 8001b020 <log>
    800037f6:	854a                	mv	a0,s2
    800037f8:	00003097          	auipc	ra,0x3
    800037fc:	d78080e7          	jalr	-648(ra) # 80006570 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003800:	02c92603          	lw	a2,44(s2)
    80003804:	47f5                	li	a5,29
    80003806:	06c7c563          	blt	a5,a2,80003870 <log_write+0x90>
    8000380a:	00018797          	auipc	a5,0x18
    8000380e:	8327a783          	lw	a5,-1998(a5) # 8001b03c <log+0x1c>
    80003812:	37fd                	addiw	a5,a5,-1
    80003814:	04f65e63          	bge	a2,a5,80003870 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003818:	00018797          	auipc	a5,0x18
    8000381c:	8287a783          	lw	a5,-2008(a5) # 8001b040 <log+0x20>
    80003820:	06f05063          	blez	a5,80003880 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003824:	4781                	li	a5,0
    80003826:	06c05563          	blez	a2,80003890 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000382a:	44cc                	lw	a1,12(s1)
    8000382c:	00018717          	auipc	a4,0x18
    80003830:	82470713          	addi	a4,a4,-2012 # 8001b050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003834:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003836:	4314                	lw	a3,0(a4)
    80003838:	04b68c63          	beq	a3,a1,80003890 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000383c:	2785                	addiw	a5,a5,1
    8000383e:	0711                	addi	a4,a4,4
    80003840:	fef61be3          	bne	a2,a5,80003836 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003844:	0621                	addi	a2,a2,8
    80003846:	060a                	slli	a2,a2,0x2
    80003848:	00017797          	auipc	a5,0x17
    8000384c:	7d878793          	addi	a5,a5,2008 # 8001b020 <log>
    80003850:	963e                	add	a2,a2,a5
    80003852:	44dc                	lw	a5,12(s1)
    80003854:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003856:	8526                	mv	a0,s1
    80003858:	fffff097          	auipc	ra,0xfffff
    8000385c:	daa080e7          	jalr	-598(ra) # 80002602 <bpin>
    log.lh.n++;
    80003860:	00017717          	auipc	a4,0x17
    80003864:	7c070713          	addi	a4,a4,1984 # 8001b020 <log>
    80003868:	575c                	lw	a5,44(a4)
    8000386a:	2785                	addiw	a5,a5,1
    8000386c:	d75c                	sw	a5,44(a4)
    8000386e:	a835                	j	800038aa <log_write+0xca>
    panic("too big a transaction");
    80003870:	00005517          	auipc	a0,0x5
    80003874:	cd050513          	addi	a0,a0,-816 # 80008540 <syscalls+0x200>
    80003878:	00002097          	auipc	ra,0x2
    8000387c:	7ae080e7          	jalr	1966(ra) # 80006026 <panic>
    panic("log_write outside of trans");
    80003880:	00005517          	auipc	a0,0x5
    80003884:	cd850513          	addi	a0,a0,-808 # 80008558 <syscalls+0x218>
    80003888:	00002097          	auipc	ra,0x2
    8000388c:	79e080e7          	jalr	1950(ra) # 80006026 <panic>
  log.lh.block[i] = b->blockno;
    80003890:	00878713          	addi	a4,a5,8
    80003894:	00271693          	slli	a3,a4,0x2
    80003898:	00017717          	auipc	a4,0x17
    8000389c:	78870713          	addi	a4,a4,1928 # 8001b020 <log>
    800038a0:	9736                	add	a4,a4,a3
    800038a2:	44d4                	lw	a3,12(s1)
    800038a4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038a6:	faf608e3          	beq	a2,a5,80003856 <log_write+0x76>
  }
  release(&log.lock);
    800038aa:	00017517          	auipc	a0,0x17
    800038ae:	77650513          	addi	a0,a0,1910 # 8001b020 <log>
    800038b2:	00003097          	auipc	ra,0x3
    800038b6:	d72080e7          	jalr	-654(ra) # 80006624 <release>
}
    800038ba:	60e2                	ld	ra,24(sp)
    800038bc:	6442                	ld	s0,16(sp)
    800038be:	64a2                	ld	s1,8(sp)
    800038c0:	6902                	ld	s2,0(sp)
    800038c2:	6105                	addi	sp,sp,32
    800038c4:	8082                	ret

00000000800038c6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038c6:	1101                	addi	sp,sp,-32
    800038c8:	ec06                	sd	ra,24(sp)
    800038ca:	e822                	sd	s0,16(sp)
    800038cc:	e426                	sd	s1,8(sp)
    800038ce:	e04a                	sd	s2,0(sp)
    800038d0:	1000                	addi	s0,sp,32
    800038d2:	84aa                	mv	s1,a0
    800038d4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038d6:	00005597          	auipc	a1,0x5
    800038da:	ca258593          	addi	a1,a1,-862 # 80008578 <syscalls+0x238>
    800038de:	0521                	addi	a0,a0,8
    800038e0:	00003097          	auipc	ra,0x3
    800038e4:	c00080e7          	jalr	-1024(ra) # 800064e0 <initlock>
  lk->name = name;
    800038e8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038ec:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038f0:	0204a423          	sw	zero,40(s1)
}
    800038f4:	60e2                	ld	ra,24(sp)
    800038f6:	6442                	ld	s0,16(sp)
    800038f8:	64a2                	ld	s1,8(sp)
    800038fa:	6902                	ld	s2,0(sp)
    800038fc:	6105                	addi	sp,sp,32
    800038fe:	8082                	ret

0000000080003900 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003900:	1101                	addi	sp,sp,-32
    80003902:	ec06                	sd	ra,24(sp)
    80003904:	e822                	sd	s0,16(sp)
    80003906:	e426                	sd	s1,8(sp)
    80003908:	e04a                	sd	s2,0(sp)
    8000390a:	1000                	addi	s0,sp,32
    8000390c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000390e:	00850913          	addi	s2,a0,8
    80003912:	854a                	mv	a0,s2
    80003914:	00003097          	auipc	ra,0x3
    80003918:	c5c080e7          	jalr	-932(ra) # 80006570 <acquire>
  while (lk->locked) {
    8000391c:	409c                	lw	a5,0(s1)
    8000391e:	cb89                	beqz	a5,80003930 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003920:	85ca                	mv	a1,s2
    80003922:	8526                	mv	a0,s1
    80003924:	ffffe097          	auipc	ra,0xffffe
    80003928:	c62080e7          	jalr	-926(ra) # 80001586 <sleep>
  while (lk->locked) {
    8000392c:	409c                	lw	a5,0(s1)
    8000392e:	fbed                	bnez	a5,80003920 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003930:	4785                	li	a5,1
    80003932:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003934:	ffffd097          	auipc	ra,0xffffd
    80003938:	502080e7          	jalr	1282(ra) # 80000e36 <myproc>
    8000393c:	591c                	lw	a5,48(a0)
    8000393e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003940:	854a                	mv	a0,s2
    80003942:	00003097          	auipc	ra,0x3
    80003946:	ce2080e7          	jalr	-798(ra) # 80006624 <release>
}
    8000394a:	60e2                	ld	ra,24(sp)
    8000394c:	6442                	ld	s0,16(sp)
    8000394e:	64a2                	ld	s1,8(sp)
    80003950:	6902                	ld	s2,0(sp)
    80003952:	6105                	addi	sp,sp,32
    80003954:	8082                	ret

0000000080003956 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003956:	1101                	addi	sp,sp,-32
    80003958:	ec06                	sd	ra,24(sp)
    8000395a:	e822                	sd	s0,16(sp)
    8000395c:	e426                	sd	s1,8(sp)
    8000395e:	e04a                	sd	s2,0(sp)
    80003960:	1000                	addi	s0,sp,32
    80003962:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003964:	00850913          	addi	s2,a0,8
    80003968:	854a                	mv	a0,s2
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	c06080e7          	jalr	-1018(ra) # 80006570 <acquire>
  lk->locked = 0;
    80003972:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003976:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000397a:	8526                	mv	a0,s1
    8000397c:	ffffe097          	auipc	ra,0xffffe
    80003980:	d96080e7          	jalr	-618(ra) # 80001712 <wakeup>
  release(&lk->lk);
    80003984:	854a                	mv	a0,s2
    80003986:	00003097          	auipc	ra,0x3
    8000398a:	c9e080e7          	jalr	-866(ra) # 80006624 <release>
}
    8000398e:	60e2                	ld	ra,24(sp)
    80003990:	6442                	ld	s0,16(sp)
    80003992:	64a2                	ld	s1,8(sp)
    80003994:	6902                	ld	s2,0(sp)
    80003996:	6105                	addi	sp,sp,32
    80003998:	8082                	ret

000000008000399a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000399a:	7179                	addi	sp,sp,-48
    8000399c:	f406                	sd	ra,40(sp)
    8000399e:	f022                	sd	s0,32(sp)
    800039a0:	ec26                	sd	s1,24(sp)
    800039a2:	e84a                	sd	s2,16(sp)
    800039a4:	e44e                	sd	s3,8(sp)
    800039a6:	1800                	addi	s0,sp,48
    800039a8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039aa:	00850913          	addi	s2,a0,8
    800039ae:	854a                	mv	a0,s2
    800039b0:	00003097          	auipc	ra,0x3
    800039b4:	bc0080e7          	jalr	-1088(ra) # 80006570 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039b8:	409c                	lw	a5,0(s1)
    800039ba:	ef99                	bnez	a5,800039d8 <holdingsleep+0x3e>
    800039bc:	4481                	li	s1,0
  release(&lk->lk);
    800039be:	854a                	mv	a0,s2
    800039c0:	00003097          	auipc	ra,0x3
    800039c4:	c64080e7          	jalr	-924(ra) # 80006624 <release>
  return r;
}
    800039c8:	8526                	mv	a0,s1
    800039ca:	70a2                	ld	ra,40(sp)
    800039cc:	7402                	ld	s0,32(sp)
    800039ce:	64e2                	ld	s1,24(sp)
    800039d0:	6942                	ld	s2,16(sp)
    800039d2:	69a2                	ld	s3,8(sp)
    800039d4:	6145                	addi	sp,sp,48
    800039d6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039d8:	0284a983          	lw	s3,40(s1)
    800039dc:	ffffd097          	auipc	ra,0xffffd
    800039e0:	45a080e7          	jalr	1114(ra) # 80000e36 <myproc>
    800039e4:	5904                	lw	s1,48(a0)
    800039e6:	413484b3          	sub	s1,s1,s3
    800039ea:	0014b493          	seqz	s1,s1
    800039ee:	bfc1                	j	800039be <holdingsleep+0x24>

00000000800039f0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039f0:	1141                	addi	sp,sp,-16
    800039f2:	e406                	sd	ra,8(sp)
    800039f4:	e022                	sd	s0,0(sp)
    800039f6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039f8:	00005597          	auipc	a1,0x5
    800039fc:	b9058593          	addi	a1,a1,-1136 # 80008588 <syscalls+0x248>
    80003a00:	00017517          	auipc	a0,0x17
    80003a04:	76850513          	addi	a0,a0,1896 # 8001b168 <ftable>
    80003a08:	00003097          	auipc	ra,0x3
    80003a0c:	ad8080e7          	jalr	-1320(ra) # 800064e0 <initlock>
}
    80003a10:	60a2                	ld	ra,8(sp)
    80003a12:	6402                	ld	s0,0(sp)
    80003a14:	0141                	addi	sp,sp,16
    80003a16:	8082                	ret

0000000080003a18 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a18:	1101                	addi	sp,sp,-32
    80003a1a:	ec06                	sd	ra,24(sp)
    80003a1c:	e822                	sd	s0,16(sp)
    80003a1e:	e426                	sd	s1,8(sp)
    80003a20:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a22:	00017517          	auipc	a0,0x17
    80003a26:	74650513          	addi	a0,a0,1862 # 8001b168 <ftable>
    80003a2a:	00003097          	auipc	ra,0x3
    80003a2e:	b46080e7          	jalr	-1210(ra) # 80006570 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a32:	00017497          	auipc	s1,0x17
    80003a36:	74e48493          	addi	s1,s1,1870 # 8001b180 <ftable+0x18>
    80003a3a:	00018717          	auipc	a4,0x18
    80003a3e:	6e670713          	addi	a4,a4,1766 # 8001c120 <ftable+0xfb8>
    if(f->ref == 0){
    80003a42:	40dc                	lw	a5,4(s1)
    80003a44:	cf99                	beqz	a5,80003a62 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a46:	02848493          	addi	s1,s1,40
    80003a4a:	fee49ce3          	bne	s1,a4,80003a42 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a4e:	00017517          	auipc	a0,0x17
    80003a52:	71a50513          	addi	a0,a0,1818 # 8001b168 <ftable>
    80003a56:	00003097          	auipc	ra,0x3
    80003a5a:	bce080e7          	jalr	-1074(ra) # 80006624 <release>
  return 0;
    80003a5e:	4481                	li	s1,0
    80003a60:	a819                	j	80003a76 <filealloc+0x5e>
      f->ref = 1;
    80003a62:	4785                	li	a5,1
    80003a64:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a66:	00017517          	auipc	a0,0x17
    80003a6a:	70250513          	addi	a0,a0,1794 # 8001b168 <ftable>
    80003a6e:	00003097          	auipc	ra,0x3
    80003a72:	bb6080e7          	jalr	-1098(ra) # 80006624 <release>
}
    80003a76:	8526                	mv	a0,s1
    80003a78:	60e2                	ld	ra,24(sp)
    80003a7a:	6442                	ld	s0,16(sp)
    80003a7c:	64a2                	ld	s1,8(sp)
    80003a7e:	6105                	addi	sp,sp,32
    80003a80:	8082                	ret

0000000080003a82 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a82:	1101                	addi	sp,sp,-32
    80003a84:	ec06                	sd	ra,24(sp)
    80003a86:	e822                	sd	s0,16(sp)
    80003a88:	e426                	sd	s1,8(sp)
    80003a8a:	1000                	addi	s0,sp,32
    80003a8c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a8e:	00017517          	auipc	a0,0x17
    80003a92:	6da50513          	addi	a0,a0,1754 # 8001b168 <ftable>
    80003a96:	00003097          	auipc	ra,0x3
    80003a9a:	ada080e7          	jalr	-1318(ra) # 80006570 <acquire>
  if(f->ref < 1)
    80003a9e:	40dc                	lw	a5,4(s1)
    80003aa0:	02f05263          	blez	a5,80003ac4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003aa4:	2785                	addiw	a5,a5,1
    80003aa6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003aa8:	00017517          	auipc	a0,0x17
    80003aac:	6c050513          	addi	a0,a0,1728 # 8001b168 <ftable>
    80003ab0:	00003097          	auipc	ra,0x3
    80003ab4:	b74080e7          	jalr	-1164(ra) # 80006624 <release>
  return f;
}
    80003ab8:	8526                	mv	a0,s1
    80003aba:	60e2                	ld	ra,24(sp)
    80003abc:	6442                	ld	s0,16(sp)
    80003abe:	64a2                	ld	s1,8(sp)
    80003ac0:	6105                	addi	sp,sp,32
    80003ac2:	8082                	ret
    panic("filedup");
    80003ac4:	00005517          	auipc	a0,0x5
    80003ac8:	acc50513          	addi	a0,a0,-1332 # 80008590 <syscalls+0x250>
    80003acc:	00002097          	auipc	ra,0x2
    80003ad0:	55a080e7          	jalr	1370(ra) # 80006026 <panic>

0000000080003ad4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ad4:	7139                	addi	sp,sp,-64
    80003ad6:	fc06                	sd	ra,56(sp)
    80003ad8:	f822                	sd	s0,48(sp)
    80003ada:	f426                	sd	s1,40(sp)
    80003adc:	f04a                	sd	s2,32(sp)
    80003ade:	ec4e                	sd	s3,24(sp)
    80003ae0:	e852                	sd	s4,16(sp)
    80003ae2:	e456                	sd	s5,8(sp)
    80003ae4:	0080                	addi	s0,sp,64
    80003ae6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ae8:	00017517          	auipc	a0,0x17
    80003aec:	68050513          	addi	a0,a0,1664 # 8001b168 <ftable>
    80003af0:	00003097          	auipc	ra,0x3
    80003af4:	a80080e7          	jalr	-1408(ra) # 80006570 <acquire>
  if(f->ref < 1)
    80003af8:	40dc                	lw	a5,4(s1)
    80003afa:	06f05163          	blez	a5,80003b5c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003afe:	37fd                	addiw	a5,a5,-1
    80003b00:	0007871b          	sext.w	a4,a5
    80003b04:	c0dc                	sw	a5,4(s1)
    80003b06:	06e04363          	bgtz	a4,80003b6c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b0a:	0004a903          	lw	s2,0(s1)
    80003b0e:	0094ca83          	lbu	s5,9(s1)
    80003b12:	0104ba03          	ld	s4,16(s1)
    80003b16:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b1a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b1e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b22:	00017517          	auipc	a0,0x17
    80003b26:	64650513          	addi	a0,a0,1606 # 8001b168 <ftable>
    80003b2a:	00003097          	auipc	ra,0x3
    80003b2e:	afa080e7          	jalr	-1286(ra) # 80006624 <release>

  if(ff.type == FD_PIPE){
    80003b32:	4785                	li	a5,1
    80003b34:	04f90d63          	beq	s2,a5,80003b8e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b38:	3979                	addiw	s2,s2,-2
    80003b3a:	4785                	li	a5,1
    80003b3c:	0527e063          	bltu	a5,s2,80003b7c <fileclose+0xa8>
    begin_op();
    80003b40:	00000097          	auipc	ra,0x0
    80003b44:	ac8080e7          	jalr	-1336(ra) # 80003608 <begin_op>
    iput(ff.ip);
    80003b48:	854e                	mv	a0,s3
    80003b4a:	fffff097          	auipc	ra,0xfffff
    80003b4e:	2a6080e7          	jalr	678(ra) # 80002df0 <iput>
    end_op();
    80003b52:	00000097          	auipc	ra,0x0
    80003b56:	b36080e7          	jalr	-1226(ra) # 80003688 <end_op>
    80003b5a:	a00d                	j	80003b7c <fileclose+0xa8>
    panic("fileclose");
    80003b5c:	00005517          	auipc	a0,0x5
    80003b60:	a3c50513          	addi	a0,a0,-1476 # 80008598 <syscalls+0x258>
    80003b64:	00002097          	auipc	ra,0x2
    80003b68:	4c2080e7          	jalr	1218(ra) # 80006026 <panic>
    release(&ftable.lock);
    80003b6c:	00017517          	auipc	a0,0x17
    80003b70:	5fc50513          	addi	a0,a0,1532 # 8001b168 <ftable>
    80003b74:	00003097          	auipc	ra,0x3
    80003b78:	ab0080e7          	jalr	-1360(ra) # 80006624 <release>
  }
}
    80003b7c:	70e2                	ld	ra,56(sp)
    80003b7e:	7442                	ld	s0,48(sp)
    80003b80:	74a2                	ld	s1,40(sp)
    80003b82:	7902                	ld	s2,32(sp)
    80003b84:	69e2                	ld	s3,24(sp)
    80003b86:	6a42                	ld	s4,16(sp)
    80003b88:	6aa2                	ld	s5,8(sp)
    80003b8a:	6121                	addi	sp,sp,64
    80003b8c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b8e:	85d6                	mv	a1,s5
    80003b90:	8552                	mv	a0,s4
    80003b92:	00000097          	auipc	ra,0x0
    80003b96:	34c080e7          	jalr	844(ra) # 80003ede <pipeclose>
    80003b9a:	b7cd                	j	80003b7c <fileclose+0xa8>

0000000080003b9c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b9c:	715d                	addi	sp,sp,-80
    80003b9e:	e486                	sd	ra,72(sp)
    80003ba0:	e0a2                	sd	s0,64(sp)
    80003ba2:	fc26                	sd	s1,56(sp)
    80003ba4:	f84a                	sd	s2,48(sp)
    80003ba6:	f44e                	sd	s3,40(sp)
    80003ba8:	0880                	addi	s0,sp,80
    80003baa:	84aa                	mv	s1,a0
    80003bac:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bae:	ffffd097          	auipc	ra,0xffffd
    80003bb2:	288080e7          	jalr	648(ra) # 80000e36 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bb6:	409c                	lw	a5,0(s1)
    80003bb8:	37f9                	addiw	a5,a5,-2
    80003bba:	4705                	li	a4,1
    80003bbc:	04f76763          	bltu	a4,a5,80003c0a <filestat+0x6e>
    80003bc0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bc2:	6c88                	ld	a0,24(s1)
    80003bc4:	fffff097          	auipc	ra,0xfffff
    80003bc8:	072080e7          	jalr	114(ra) # 80002c36 <ilock>
    stati(f->ip, &st);
    80003bcc:	fb840593          	addi	a1,s0,-72
    80003bd0:	6c88                	ld	a0,24(s1)
    80003bd2:	fffff097          	auipc	ra,0xfffff
    80003bd6:	2ee080e7          	jalr	750(ra) # 80002ec0 <stati>
    iunlock(f->ip);
    80003bda:	6c88                	ld	a0,24(s1)
    80003bdc:	fffff097          	auipc	ra,0xfffff
    80003be0:	11c080e7          	jalr	284(ra) # 80002cf8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003be4:	46e1                	li	a3,24
    80003be6:	fb840613          	addi	a2,s0,-72
    80003bea:	85ce                	mv	a1,s3
    80003bec:	05093503          	ld	a0,80(s2)
    80003bf0:	ffffd097          	auipc	ra,0xffffd
    80003bf4:	f08080e7          	jalr	-248(ra) # 80000af8 <copyout>
    80003bf8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bfc:	60a6                	ld	ra,72(sp)
    80003bfe:	6406                	ld	s0,64(sp)
    80003c00:	74e2                	ld	s1,56(sp)
    80003c02:	7942                	ld	s2,48(sp)
    80003c04:	79a2                	ld	s3,40(sp)
    80003c06:	6161                	addi	sp,sp,80
    80003c08:	8082                	ret
  return -1;
    80003c0a:	557d                	li	a0,-1
    80003c0c:	bfc5                	j	80003bfc <filestat+0x60>

0000000080003c0e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c0e:	7179                	addi	sp,sp,-48
    80003c10:	f406                	sd	ra,40(sp)
    80003c12:	f022                	sd	s0,32(sp)
    80003c14:	ec26                	sd	s1,24(sp)
    80003c16:	e84a                	sd	s2,16(sp)
    80003c18:	e44e                	sd	s3,8(sp)
    80003c1a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c1c:	00854783          	lbu	a5,8(a0)
    80003c20:	c3d5                	beqz	a5,80003cc4 <fileread+0xb6>
    80003c22:	84aa                	mv	s1,a0
    80003c24:	89ae                	mv	s3,a1
    80003c26:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c28:	411c                	lw	a5,0(a0)
    80003c2a:	4705                	li	a4,1
    80003c2c:	04e78963          	beq	a5,a4,80003c7e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c30:	470d                	li	a4,3
    80003c32:	04e78d63          	beq	a5,a4,80003c8c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c36:	4709                	li	a4,2
    80003c38:	06e79e63          	bne	a5,a4,80003cb4 <fileread+0xa6>
    ilock(f->ip);
    80003c3c:	6d08                	ld	a0,24(a0)
    80003c3e:	fffff097          	auipc	ra,0xfffff
    80003c42:	ff8080e7          	jalr	-8(ra) # 80002c36 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c46:	874a                	mv	a4,s2
    80003c48:	5094                	lw	a3,32(s1)
    80003c4a:	864e                	mv	a2,s3
    80003c4c:	4585                	li	a1,1
    80003c4e:	6c88                	ld	a0,24(s1)
    80003c50:	fffff097          	auipc	ra,0xfffff
    80003c54:	29a080e7          	jalr	666(ra) # 80002eea <readi>
    80003c58:	892a                	mv	s2,a0
    80003c5a:	00a05563          	blez	a0,80003c64 <fileread+0x56>
      f->off += r;
    80003c5e:	509c                	lw	a5,32(s1)
    80003c60:	9fa9                	addw	a5,a5,a0
    80003c62:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c64:	6c88                	ld	a0,24(s1)
    80003c66:	fffff097          	auipc	ra,0xfffff
    80003c6a:	092080e7          	jalr	146(ra) # 80002cf8 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c6e:	854a                	mv	a0,s2
    80003c70:	70a2                	ld	ra,40(sp)
    80003c72:	7402                	ld	s0,32(sp)
    80003c74:	64e2                	ld	s1,24(sp)
    80003c76:	6942                	ld	s2,16(sp)
    80003c78:	69a2                	ld	s3,8(sp)
    80003c7a:	6145                	addi	sp,sp,48
    80003c7c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c7e:	6908                	ld	a0,16(a0)
    80003c80:	00000097          	auipc	ra,0x0
    80003c84:	3c8080e7          	jalr	968(ra) # 80004048 <piperead>
    80003c88:	892a                	mv	s2,a0
    80003c8a:	b7d5                	j	80003c6e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c8c:	02451783          	lh	a5,36(a0)
    80003c90:	03079693          	slli	a3,a5,0x30
    80003c94:	92c1                	srli	a3,a3,0x30
    80003c96:	4725                	li	a4,9
    80003c98:	02d76863          	bltu	a4,a3,80003cc8 <fileread+0xba>
    80003c9c:	0792                	slli	a5,a5,0x4
    80003c9e:	00017717          	auipc	a4,0x17
    80003ca2:	42a70713          	addi	a4,a4,1066 # 8001b0c8 <devsw>
    80003ca6:	97ba                	add	a5,a5,a4
    80003ca8:	639c                	ld	a5,0(a5)
    80003caa:	c38d                	beqz	a5,80003ccc <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003cac:	4505                	li	a0,1
    80003cae:	9782                	jalr	a5
    80003cb0:	892a                	mv	s2,a0
    80003cb2:	bf75                	j	80003c6e <fileread+0x60>
    panic("fileread");
    80003cb4:	00005517          	auipc	a0,0x5
    80003cb8:	8f450513          	addi	a0,a0,-1804 # 800085a8 <syscalls+0x268>
    80003cbc:	00002097          	auipc	ra,0x2
    80003cc0:	36a080e7          	jalr	874(ra) # 80006026 <panic>
    return -1;
    80003cc4:	597d                	li	s2,-1
    80003cc6:	b765                	j	80003c6e <fileread+0x60>
      return -1;
    80003cc8:	597d                	li	s2,-1
    80003cca:	b755                	j	80003c6e <fileread+0x60>
    80003ccc:	597d                	li	s2,-1
    80003cce:	b745                	j	80003c6e <fileread+0x60>

0000000080003cd0 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003cd0:	715d                	addi	sp,sp,-80
    80003cd2:	e486                	sd	ra,72(sp)
    80003cd4:	e0a2                	sd	s0,64(sp)
    80003cd6:	fc26                	sd	s1,56(sp)
    80003cd8:	f84a                	sd	s2,48(sp)
    80003cda:	f44e                	sd	s3,40(sp)
    80003cdc:	f052                	sd	s4,32(sp)
    80003cde:	ec56                	sd	s5,24(sp)
    80003ce0:	e85a                	sd	s6,16(sp)
    80003ce2:	e45e                	sd	s7,8(sp)
    80003ce4:	e062                	sd	s8,0(sp)
    80003ce6:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003ce8:	00954783          	lbu	a5,9(a0)
    80003cec:	10078663          	beqz	a5,80003df8 <filewrite+0x128>
    80003cf0:	892a                	mv	s2,a0
    80003cf2:	8aae                	mv	s5,a1
    80003cf4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cf6:	411c                	lw	a5,0(a0)
    80003cf8:	4705                	li	a4,1
    80003cfa:	02e78263          	beq	a5,a4,80003d1e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cfe:	470d                	li	a4,3
    80003d00:	02e78663          	beq	a5,a4,80003d2c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d04:	4709                	li	a4,2
    80003d06:	0ee79163          	bne	a5,a4,80003de8 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d0a:	0ac05d63          	blez	a2,80003dc4 <filewrite+0xf4>
    int i = 0;
    80003d0e:	4981                	li	s3,0
    80003d10:	6b05                	lui	s6,0x1
    80003d12:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d16:	6b85                	lui	s7,0x1
    80003d18:	c00b8b9b          	addiw	s7,s7,-1024
    80003d1c:	a861                	j	80003db4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d1e:	6908                	ld	a0,16(a0)
    80003d20:	00000097          	auipc	ra,0x0
    80003d24:	22e080e7          	jalr	558(ra) # 80003f4e <pipewrite>
    80003d28:	8a2a                	mv	s4,a0
    80003d2a:	a045                	j	80003dca <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d2c:	02451783          	lh	a5,36(a0)
    80003d30:	03079693          	slli	a3,a5,0x30
    80003d34:	92c1                	srli	a3,a3,0x30
    80003d36:	4725                	li	a4,9
    80003d38:	0cd76263          	bltu	a4,a3,80003dfc <filewrite+0x12c>
    80003d3c:	0792                	slli	a5,a5,0x4
    80003d3e:	00017717          	auipc	a4,0x17
    80003d42:	38a70713          	addi	a4,a4,906 # 8001b0c8 <devsw>
    80003d46:	97ba                	add	a5,a5,a4
    80003d48:	679c                	ld	a5,8(a5)
    80003d4a:	cbdd                	beqz	a5,80003e00 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d4c:	4505                	li	a0,1
    80003d4e:	9782                	jalr	a5
    80003d50:	8a2a                	mv	s4,a0
    80003d52:	a8a5                	j	80003dca <filewrite+0xfa>
    80003d54:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d58:	00000097          	auipc	ra,0x0
    80003d5c:	8b0080e7          	jalr	-1872(ra) # 80003608 <begin_op>
      ilock(f->ip);
    80003d60:	01893503          	ld	a0,24(s2)
    80003d64:	fffff097          	auipc	ra,0xfffff
    80003d68:	ed2080e7          	jalr	-302(ra) # 80002c36 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d6c:	8762                	mv	a4,s8
    80003d6e:	02092683          	lw	a3,32(s2)
    80003d72:	01598633          	add	a2,s3,s5
    80003d76:	4585                	li	a1,1
    80003d78:	01893503          	ld	a0,24(s2)
    80003d7c:	fffff097          	auipc	ra,0xfffff
    80003d80:	266080e7          	jalr	614(ra) # 80002fe2 <writei>
    80003d84:	84aa                	mv	s1,a0
    80003d86:	00a05763          	blez	a0,80003d94 <filewrite+0xc4>
        f->off += r;
    80003d8a:	02092783          	lw	a5,32(s2)
    80003d8e:	9fa9                	addw	a5,a5,a0
    80003d90:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d94:	01893503          	ld	a0,24(s2)
    80003d98:	fffff097          	auipc	ra,0xfffff
    80003d9c:	f60080e7          	jalr	-160(ra) # 80002cf8 <iunlock>
      end_op();
    80003da0:	00000097          	auipc	ra,0x0
    80003da4:	8e8080e7          	jalr	-1816(ra) # 80003688 <end_op>

      if(r != n1){
    80003da8:	009c1f63          	bne	s8,s1,80003dc6 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003dac:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003db0:	0149db63          	bge	s3,s4,80003dc6 <filewrite+0xf6>
      int n1 = n - i;
    80003db4:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003db8:	84be                	mv	s1,a5
    80003dba:	2781                	sext.w	a5,a5
    80003dbc:	f8fb5ce3          	bge	s6,a5,80003d54 <filewrite+0x84>
    80003dc0:	84de                	mv	s1,s7
    80003dc2:	bf49                	j	80003d54 <filewrite+0x84>
    int i = 0;
    80003dc4:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003dc6:	013a1f63          	bne	s4,s3,80003de4 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dca:	8552                	mv	a0,s4
    80003dcc:	60a6                	ld	ra,72(sp)
    80003dce:	6406                	ld	s0,64(sp)
    80003dd0:	74e2                	ld	s1,56(sp)
    80003dd2:	7942                	ld	s2,48(sp)
    80003dd4:	79a2                	ld	s3,40(sp)
    80003dd6:	7a02                	ld	s4,32(sp)
    80003dd8:	6ae2                	ld	s5,24(sp)
    80003dda:	6b42                	ld	s6,16(sp)
    80003ddc:	6ba2                	ld	s7,8(sp)
    80003dde:	6c02                	ld	s8,0(sp)
    80003de0:	6161                	addi	sp,sp,80
    80003de2:	8082                	ret
    ret = (i == n ? n : -1);
    80003de4:	5a7d                	li	s4,-1
    80003de6:	b7d5                	j	80003dca <filewrite+0xfa>
    panic("filewrite");
    80003de8:	00004517          	auipc	a0,0x4
    80003dec:	7d050513          	addi	a0,a0,2000 # 800085b8 <syscalls+0x278>
    80003df0:	00002097          	auipc	ra,0x2
    80003df4:	236080e7          	jalr	566(ra) # 80006026 <panic>
    return -1;
    80003df8:	5a7d                	li	s4,-1
    80003dfa:	bfc1                	j	80003dca <filewrite+0xfa>
      return -1;
    80003dfc:	5a7d                	li	s4,-1
    80003dfe:	b7f1                	j	80003dca <filewrite+0xfa>
    80003e00:	5a7d                	li	s4,-1
    80003e02:	b7e1                	j	80003dca <filewrite+0xfa>

0000000080003e04 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e04:	7179                	addi	sp,sp,-48
    80003e06:	f406                	sd	ra,40(sp)
    80003e08:	f022                	sd	s0,32(sp)
    80003e0a:	ec26                	sd	s1,24(sp)
    80003e0c:	e84a                	sd	s2,16(sp)
    80003e0e:	e44e                	sd	s3,8(sp)
    80003e10:	e052                	sd	s4,0(sp)
    80003e12:	1800                	addi	s0,sp,48
    80003e14:	84aa                	mv	s1,a0
    80003e16:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e18:	0005b023          	sd	zero,0(a1)
    80003e1c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	bf8080e7          	jalr	-1032(ra) # 80003a18 <filealloc>
    80003e28:	e088                	sd	a0,0(s1)
    80003e2a:	c551                	beqz	a0,80003eb6 <pipealloc+0xb2>
    80003e2c:	00000097          	auipc	ra,0x0
    80003e30:	bec080e7          	jalr	-1044(ra) # 80003a18 <filealloc>
    80003e34:	00aa3023          	sd	a0,0(s4)
    80003e38:	c92d                	beqz	a0,80003eaa <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e3a:	ffffc097          	auipc	ra,0xffffc
    80003e3e:	2de080e7          	jalr	734(ra) # 80000118 <kalloc>
    80003e42:	892a                	mv	s2,a0
    80003e44:	c125                	beqz	a0,80003ea4 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e46:	4985                	li	s3,1
    80003e48:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e4c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e50:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e54:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e58:	00004597          	auipc	a1,0x4
    80003e5c:	77058593          	addi	a1,a1,1904 # 800085c8 <syscalls+0x288>
    80003e60:	00002097          	auipc	ra,0x2
    80003e64:	680080e7          	jalr	1664(ra) # 800064e0 <initlock>
  (*f0)->type = FD_PIPE;
    80003e68:	609c                	ld	a5,0(s1)
    80003e6a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e6e:	609c                	ld	a5,0(s1)
    80003e70:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e74:	609c                	ld	a5,0(s1)
    80003e76:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e7a:	609c                	ld	a5,0(s1)
    80003e7c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e80:	000a3783          	ld	a5,0(s4)
    80003e84:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e88:	000a3783          	ld	a5,0(s4)
    80003e8c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e90:	000a3783          	ld	a5,0(s4)
    80003e94:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e98:	000a3783          	ld	a5,0(s4)
    80003e9c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ea0:	4501                	li	a0,0
    80003ea2:	a025                	j	80003eca <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ea4:	6088                	ld	a0,0(s1)
    80003ea6:	e501                	bnez	a0,80003eae <pipealloc+0xaa>
    80003ea8:	a039                	j	80003eb6 <pipealloc+0xb2>
    80003eaa:	6088                	ld	a0,0(s1)
    80003eac:	c51d                	beqz	a0,80003eda <pipealloc+0xd6>
    fileclose(*f0);
    80003eae:	00000097          	auipc	ra,0x0
    80003eb2:	c26080e7          	jalr	-986(ra) # 80003ad4 <fileclose>
  if(*f1)
    80003eb6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003eba:	557d                	li	a0,-1
  if(*f1)
    80003ebc:	c799                	beqz	a5,80003eca <pipealloc+0xc6>
    fileclose(*f1);
    80003ebe:	853e                	mv	a0,a5
    80003ec0:	00000097          	auipc	ra,0x0
    80003ec4:	c14080e7          	jalr	-1004(ra) # 80003ad4 <fileclose>
  return -1;
    80003ec8:	557d                	li	a0,-1
}
    80003eca:	70a2                	ld	ra,40(sp)
    80003ecc:	7402                	ld	s0,32(sp)
    80003ece:	64e2                	ld	s1,24(sp)
    80003ed0:	6942                	ld	s2,16(sp)
    80003ed2:	69a2                	ld	s3,8(sp)
    80003ed4:	6a02                	ld	s4,0(sp)
    80003ed6:	6145                	addi	sp,sp,48
    80003ed8:	8082                	ret
  return -1;
    80003eda:	557d                	li	a0,-1
    80003edc:	b7fd                	j	80003eca <pipealloc+0xc6>

0000000080003ede <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ede:	1101                	addi	sp,sp,-32
    80003ee0:	ec06                	sd	ra,24(sp)
    80003ee2:	e822                	sd	s0,16(sp)
    80003ee4:	e426                	sd	s1,8(sp)
    80003ee6:	e04a                	sd	s2,0(sp)
    80003ee8:	1000                	addi	s0,sp,32
    80003eea:	84aa                	mv	s1,a0
    80003eec:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003eee:	00002097          	auipc	ra,0x2
    80003ef2:	682080e7          	jalr	1666(ra) # 80006570 <acquire>
  if(writable){
    80003ef6:	02090d63          	beqz	s2,80003f30 <pipeclose+0x52>
    pi->writeopen = 0;
    80003efa:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003efe:	21848513          	addi	a0,s1,536
    80003f02:	ffffe097          	auipc	ra,0xffffe
    80003f06:	810080e7          	jalr	-2032(ra) # 80001712 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f0a:	2204b783          	ld	a5,544(s1)
    80003f0e:	eb95                	bnez	a5,80003f42 <pipeclose+0x64>
    release(&pi->lock);
    80003f10:	8526                	mv	a0,s1
    80003f12:	00002097          	auipc	ra,0x2
    80003f16:	712080e7          	jalr	1810(ra) # 80006624 <release>
    kfree((char*)pi);
    80003f1a:	8526                	mv	a0,s1
    80003f1c:	ffffc097          	auipc	ra,0xffffc
    80003f20:	100080e7          	jalr	256(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f24:	60e2                	ld	ra,24(sp)
    80003f26:	6442                	ld	s0,16(sp)
    80003f28:	64a2                	ld	s1,8(sp)
    80003f2a:	6902                	ld	s2,0(sp)
    80003f2c:	6105                	addi	sp,sp,32
    80003f2e:	8082                	ret
    pi->readopen = 0;
    80003f30:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f34:	21c48513          	addi	a0,s1,540
    80003f38:	ffffd097          	auipc	ra,0xffffd
    80003f3c:	7da080e7          	jalr	2010(ra) # 80001712 <wakeup>
    80003f40:	b7e9                	j	80003f0a <pipeclose+0x2c>
    release(&pi->lock);
    80003f42:	8526                	mv	a0,s1
    80003f44:	00002097          	auipc	ra,0x2
    80003f48:	6e0080e7          	jalr	1760(ra) # 80006624 <release>
}
    80003f4c:	bfe1                	j	80003f24 <pipeclose+0x46>

0000000080003f4e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f4e:	7159                	addi	sp,sp,-112
    80003f50:	f486                	sd	ra,104(sp)
    80003f52:	f0a2                	sd	s0,96(sp)
    80003f54:	eca6                	sd	s1,88(sp)
    80003f56:	e8ca                	sd	s2,80(sp)
    80003f58:	e4ce                	sd	s3,72(sp)
    80003f5a:	e0d2                	sd	s4,64(sp)
    80003f5c:	fc56                	sd	s5,56(sp)
    80003f5e:	f85a                	sd	s6,48(sp)
    80003f60:	f45e                	sd	s7,40(sp)
    80003f62:	f062                	sd	s8,32(sp)
    80003f64:	ec66                	sd	s9,24(sp)
    80003f66:	1880                	addi	s0,sp,112
    80003f68:	84aa                	mv	s1,a0
    80003f6a:	8aae                	mv	s5,a1
    80003f6c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f6e:	ffffd097          	auipc	ra,0xffffd
    80003f72:	ec8080e7          	jalr	-312(ra) # 80000e36 <myproc>
    80003f76:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f78:	8526                	mv	a0,s1
    80003f7a:	00002097          	auipc	ra,0x2
    80003f7e:	5f6080e7          	jalr	1526(ra) # 80006570 <acquire>
  while(i < n){
    80003f82:	0d405163          	blez	s4,80004044 <pipewrite+0xf6>
    80003f86:	8ba6                	mv	s7,s1
  int i = 0;
    80003f88:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f8a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f8c:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f90:	21c48c13          	addi	s8,s1,540
    80003f94:	a08d                	j	80003ff6 <pipewrite+0xa8>
      release(&pi->lock);
    80003f96:	8526                	mv	a0,s1
    80003f98:	00002097          	auipc	ra,0x2
    80003f9c:	68c080e7          	jalr	1676(ra) # 80006624 <release>
      return -1;
    80003fa0:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fa2:	854a                	mv	a0,s2
    80003fa4:	70a6                	ld	ra,104(sp)
    80003fa6:	7406                	ld	s0,96(sp)
    80003fa8:	64e6                	ld	s1,88(sp)
    80003faa:	6946                	ld	s2,80(sp)
    80003fac:	69a6                	ld	s3,72(sp)
    80003fae:	6a06                	ld	s4,64(sp)
    80003fb0:	7ae2                	ld	s5,56(sp)
    80003fb2:	7b42                	ld	s6,48(sp)
    80003fb4:	7ba2                	ld	s7,40(sp)
    80003fb6:	7c02                	ld	s8,32(sp)
    80003fb8:	6ce2                	ld	s9,24(sp)
    80003fba:	6165                	addi	sp,sp,112
    80003fbc:	8082                	ret
      wakeup(&pi->nread);
    80003fbe:	8566                	mv	a0,s9
    80003fc0:	ffffd097          	auipc	ra,0xffffd
    80003fc4:	752080e7          	jalr	1874(ra) # 80001712 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fc8:	85de                	mv	a1,s7
    80003fca:	8562                	mv	a0,s8
    80003fcc:	ffffd097          	auipc	ra,0xffffd
    80003fd0:	5ba080e7          	jalr	1466(ra) # 80001586 <sleep>
    80003fd4:	a839                	j	80003ff2 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fd6:	21c4a783          	lw	a5,540(s1)
    80003fda:	0017871b          	addiw	a4,a5,1
    80003fde:	20e4ae23          	sw	a4,540(s1)
    80003fe2:	1ff7f793          	andi	a5,a5,511
    80003fe6:	97a6                	add	a5,a5,s1
    80003fe8:	f9f44703          	lbu	a4,-97(s0)
    80003fec:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ff0:	2905                	addiw	s2,s2,1
  while(i < n){
    80003ff2:	03495d63          	bge	s2,s4,8000402c <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003ff6:	2204a783          	lw	a5,544(s1)
    80003ffa:	dfd1                	beqz	a5,80003f96 <pipewrite+0x48>
    80003ffc:	0289a783          	lw	a5,40(s3)
    80004000:	fbd9                	bnez	a5,80003f96 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004002:	2184a783          	lw	a5,536(s1)
    80004006:	21c4a703          	lw	a4,540(s1)
    8000400a:	2007879b          	addiw	a5,a5,512
    8000400e:	faf708e3          	beq	a4,a5,80003fbe <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004012:	4685                	li	a3,1
    80004014:	01590633          	add	a2,s2,s5
    80004018:	f9f40593          	addi	a1,s0,-97
    8000401c:	0509b503          	ld	a0,80(s3)
    80004020:	ffffd097          	auipc	ra,0xffffd
    80004024:	b64080e7          	jalr	-1180(ra) # 80000b84 <copyin>
    80004028:	fb6517e3          	bne	a0,s6,80003fd6 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000402c:	21848513          	addi	a0,s1,536
    80004030:	ffffd097          	auipc	ra,0xffffd
    80004034:	6e2080e7          	jalr	1762(ra) # 80001712 <wakeup>
  release(&pi->lock);
    80004038:	8526                	mv	a0,s1
    8000403a:	00002097          	auipc	ra,0x2
    8000403e:	5ea080e7          	jalr	1514(ra) # 80006624 <release>
  return i;
    80004042:	b785                	j	80003fa2 <pipewrite+0x54>
  int i = 0;
    80004044:	4901                	li	s2,0
    80004046:	b7dd                	j	8000402c <pipewrite+0xde>

0000000080004048 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004048:	715d                	addi	sp,sp,-80
    8000404a:	e486                	sd	ra,72(sp)
    8000404c:	e0a2                	sd	s0,64(sp)
    8000404e:	fc26                	sd	s1,56(sp)
    80004050:	f84a                	sd	s2,48(sp)
    80004052:	f44e                	sd	s3,40(sp)
    80004054:	f052                	sd	s4,32(sp)
    80004056:	ec56                	sd	s5,24(sp)
    80004058:	e85a                	sd	s6,16(sp)
    8000405a:	0880                	addi	s0,sp,80
    8000405c:	84aa                	mv	s1,a0
    8000405e:	892e                	mv	s2,a1
    80004060:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004062:	ffffd097          	auipc	ra,0xffffd
    80004066:	dd4080e7          	jalr	-556(ra) # 80000e36 <myproc>
    8000406a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000406c:	8b26                	mv	s6,s1
    8000406e:	8526                	mv	a0,s1
    80004070:	00002097          	auipc	ra,0x2
    80004074:	500080e7          	jalr	1280(ra) # 80006570 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004078:	2184a703          	lw	a4,536(s1)
    8000407c:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004080:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004084:	02f71463          	bne	a4,a5,800040ac <piperead+0x64>
    80004088:	2244a783          	lw	a5,548(s1)
    8000408c:	c385                	beqz	a5,800040ac <piperead+0x64>
    if(pr->killed){
    8000408e:	028a2783          	lw	a5,40(s4)
    80004092:	ebc1                	bnez	a5,80004122 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004094:	85da                	mv	a1,s6
    80004096:	854e                	mv	a0,s3
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	4ee080e7          	jalr	1262(ra) # 80001586 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040a0:	2184a703          	lw	a4,536(s1)
    800040a4:	21c4a783          	lw	a5,540(s1)
    800040a8:	fef700e3          	beq	a4,a5,80004088 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ac:	09505263          	blez	s5,80004130 <piperead+0xe8>
    800040b0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040b2:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040b4:	2184a783          	lw	a5,536(s1)
    800040b8:	21c4a703          	lw	a4,540(s1)
    800040bc:	02f70d63          	beq	a4,a5,800040f6 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040c0:	0017871b          	addiw	a4,a5,1
    800040c4:	20e4ac23          	sw	a4,536(s1)
    800040c8:	1ff7f793          	andi	a5,a5,511
    800040cc:	97a6                	add	a5,a5,s1
    800040ce:	0187c783          	lbu	a5,24(a5)
    800040d2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040d6:	4685                	li	a3,1
    800040d8:	fbf40613          	addi	a2,s0,-65
    800040dc:	85ca                	mv	a1,s2
    800040de:	050a3503          	ld	a0,80(s4)
    800040e2:	ffffd097          	auipc	ra,0xffffd
    800040e6:	a16080e7          	jalr	-1514(ra) # 80000af8 <copyout>
    800040ea:	01650663          	beq	a0,s6,800040f6 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ee:	2985                	addiw	s3,s3,1
    800040f0:	0905                	addi	s2,s2,1
    800040f2:	fd3a91e3          	bne	s5,s3,800040b4 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040f6:	21c48513          	addi	a0,s1,540
    800040fa:	ffffd097          	auipc	ra,0xffffd
    800040fe:	618080e7          	jalr	1560(ra) # 80001712 <wakeup>
  release(&pi->lock);
    80004102:	8526                	mv	a0,s1
    80004104:	00002097          	auipc	ra,0x2
    80004108:	520080e7          	jalr	1312(ra) # 80006624 <release>
  return i;
}
    8000410c:	854e                	mv	a0,s3
    8000410e:	60a6                	ld	ra,72(sp)
    80004110:	6406                	ld	s0,64(sp)
    80004112:	74e2                	ld	s1,56(sp)
    80004114:	7942                	ld	s2,48(sp)
    80004116:	79a2                	ld	s3,40(sp)
    80004118:	7a02                	ld	s4,32(sp)
    8000411a:	6ae2                	ld	s5,24(sp)
    8000411c:	6b42                	ld	s6,16(sp)
    8000411e:	6161                	addi	sp,sp,80
    80004120:	8082                	ret
      release(&pi->lock);
    80004122:	8526                	mv	a0,s1
    80004124:	00002097          	auipc	ra,0x2
    80004128:	500080e7          	jalr	1280(ra) # 80006624 <release>
      return -1;
    8000412c:	59fd                	li	s3,-1
    8000412e:	bff9                	j	8000410c <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004130:	4981                	li	s3,0
    80004132:	b7d1                	j	800040f6 <piperead+0xae>

0000000080004134 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004134:	df010113          	addi	sp,sp,-528
    80004138:	20113423          	sd	ra,520(sp)
    8000413c:	20813023          	sd	s0,512(sp)
    80004140:	ffa6                	sd	s1,504(sp)
    80004142:	fbca                	sd	s2,496(sp)
    80004144:	f7ce                	sd	s3,488(sp)
    80004146:	f3d2                	sd	s4,480(sp)
    80004148:	efd6                	sd	s5,472(sp)
    8000414a:	ebda                	sd	s6,464(sp)
    8000414c:	e7de                	sd	s7,456(sp)
    8000414e:	e3e2                	sd	s8,448(sp)
    80004150:	ff66                	sd	s9,440(sp)
    80004152:	fb6a                	sd	s10,432(sp)
    80004154:	f76e                	sd	s11,424(sp)
    80004156:	0c00                	addi	s0,sp,528
    80004158:	84aa                	mv	s1,a0
    8000415a:	dea43c23          	sd	a0,-520(s0)
    8000415e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004162:	ffffd097          	auipc	ra,0xffffd
    80004166:	cd4080e7          	jalr	-812(ra) # 80000e36 <myproc>
    8000416a:	892a                	mv	s2,a0

  begin_op();
    8000416c:	fffff097          	auipc	ra,0xfffff
    80004170:	49c080e7          	jalr	1180(ra) # 80003608 <begin_op>

  if((ip = namei(path)) == 0){
    80004174:	8526                	mv	a0,s1
    80004176:	fffff097          	auipc	ra,0xfffff
    8000417a:	276080e7          	jalr	630(ra) # 800033ec <namei>
    8000417e:	c92d                	beqz	a0,800041f0 <exec+0xbc>
    80004180:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004182:	fffff097          	auipc	ra,0xfffff
    80004186:	ab4080e7          	jalr	-1356(ra) # 80002c36 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000418a:	04000713          	li	a4,64
    8000418e:	4681                	li	a3,0
    80004190:	e5040613          	addi	a2,s0,-432
    80004194:	4581                	li	a1,0
    80004196:	8526                	mv	a0,s1
    80004198:	fffff097          	auipc	ra,0xfffff
    8000419c:	d52080e7          	jalr	-686(ra) # 80002eea <readi>
    800041a0:	04000793          	li	a5,64
    800041a4:	00f51a63          	bne	a0,a5,800041b8 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041a8:	e5042703          	lw	a4,-432(s0)
    800041ac:	464c47b7          	lui	a5,0x464c4
    800041b0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041b4:	04f70463          	beq	a4,a5,800041fc <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041b8:	8526                	mv	a0,s1
    800041ba:	fffff097          	auipc	ra,0xfffff
    800041be:	cde080e7          	jalr	-802(ra) # 80002e98 <iunlockput>
    end_op();
    800041c2:	fffff097          	auipc	ra,0xfffff
    800041c6:	4c6080e7          	jalr	1222(ra) # 80003688 <end_op>
  }
  return -1;
    800041ca:	557d                	li	a0,-1
}
    800041cc:	20813083          	ld	ra,520(sp)
    800041d0:	20013403          	ld	s0,512(sp)
    800041d4:	74fe                	ld	s1,504(sp)
    800041d6:	795e                	ld	s2,496(sp)
    800041d8:	79be                	ld	s3,488(sp)
    800041da:	7a1e                	ld	s4,480(sp)
    800041dc:	6afe                	ld	s5,472(sp)
    800041de:	6b5e                	ld	s6,464(sp)
    800041e0:	6bbe                	ld	s7,456(sp)
    800041e2:	6c1e                	ld	s8,448(sp)
    800041e4:	7cfa                	ld	s9,440(sp)
    800041e6:	7d5a                	ld	s10,432(sp)
    800041e8:	7dba                	ld	s11,424(sp)
    800041ea:	21010113          	addi	sp,sp,528
    800041ee:	8082                	ret
    end_op();
    800041f0:	fffff097          	auipc	ra,0xfffff
    800041f4:	498080e7          	jalr	1176(ra) # 80003688 <end_op>
    return -1;
    800041f8:	557d                	li	a0,-1
    800041fa:	bfc9                	j	800041cc <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041fc:	854a                	mv	a0,s2
    800041fe:	ffffd097          	auipc	ra,0xffffd
    80004202:	d22080e7          	jalr	-734(ra) # 80000f20 <proc_pagetable>
    80004206:	8baa                	mv	s7,a0
    80004208:	d945                	beqz	a0,800041b8 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000420a:	e7042983          	lw	s3,-400(s0)
    8000420e:	e8845783          	lhu	a5,-376(s0)
    80004212:	c7ad                	beqz	a5,8000427c <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004214:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004216:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004218:	6c85                	lui	s9,0x1
    8000421a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000421e:	def43823          	sd	a5,-528(s0)
    80004222:	a42d                	j	8000444c <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004224:	00004517          	auipc	a0,0x4
    80004228:	3ac50513          	addi	a0,a0,940 # 800085d0 <syscalls+0x290>
    8000422c:	00002097          	auipc	ra,0x2
    80004230:	dfa080e7          	jalr	-518(ra) # 80006026 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004234:	8756                	mv	a4,s5
    80004236:	012d86bb          	addw	a3,s11,s2
    8000423a:	4581                	li	a1,0
    8000423c:	8526                	mv	a0,s1
    8000423e:	fffff097          	auipc	ra,0xfffff
    80004242:	cac080e7          	jalr	-852(ra) # 80002eea <readi>
    80004246:	2501                	sext.w	a0,a0
    80004248:	1aaa9963          	bne	s5,a0,800043fa <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    8000424c:	6785                	lui	a5,0x1
    8000424e:	0127893b          	addw	s2,a5,s2
    80004252:	77fd                	lui	a5,0xfffff
    80004254:	01478a3b          	addw	s4,a5,s4
    80004258:	1f897163          	bgeu	s2,s8,8000443a <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    8000425c:	02091593          	slli	a1,s2,0x20
    80004260:	9181                	srli	a1,a1,0x20
    80004262:	95ea                	add	a1,a1,s10
    80004264:	855e                	mv	a0,s7
    80004266:	ffffc097          	auipc	ra,0xffffc
    8000426a:	2a8080e7          	jalr	680(ra) # 8000050e <walkaddr>
    8000426e:	862a                	mv	a2,a0
    if(pa == 0)
    80004270:	d955                	beqz	a0,80004224 <exec+0xf0>
      n = PGSIZE;
    80004272:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004274:	fd9a70e3          	bgeu	s4,s9,80004234 <exec+0x100>
      n = sz - i;
    80004278:	8ad2                	mv	s5,s4
    8000427a:	bf6d                	j	80004234 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000427c:	4901                	li	s2,0
  iunlockput(ip);
    8000427e:	8526                	mv	a0,s1
    80004280:	fffff097          	auipc	ra,0xfffff
    80004284:	c18080e7          	jalr	-1000(ra) # 80002e98 <iunlockput>
  end_op();
    80004288:	fffff097          	auipc	ra,0xfffff
    8000428c:	400080e7          	jalr	1024(ra) # 80003688 <end_op>
  p = myproc();
    80004290:	ffffd097          	auipc	ra,0xffffd
    80004294:	ba6080e7          	jalr	-1114(ra) # 80000e36 <myproc>
    80004298:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000429a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000429e:	6785                	lui	a5,0x1
    800042a0:	17fd                	addi	a5,a5,-1
    800042a2:	993e                	add	s2,s2,a5
    800042a4:	757d                	lui	a0,0xfffff
    800042a6:	00a977b3          	and	a5,s2,a0
    800042aa:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042ae:	6609                	lui	a2,0x2
    800042b0:	963e                	add	a2,a2,a5
    800042b2:	85be                	mv	a1,a5
    800042b4:	855e                	mv	a0,s7
    800042b6:	ffffc097          	auipc	ra,0xffffc
    800042ba:	5fe080e7          	jalr	1534(ra) # 800008b4 <uvmalloc>
    800042be:	8b2a                	mv	s6,a0
  ip = 0;
    800042c0:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042c2:	12050c63          	beqz	a0,800043fa <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042c6:	75f9                	lui	a1,0xffffe
    800042c8:	95aa                	add	a1,a1,a0
    800042ca:	855e                	mv	a0,s7
    800042cc:	ffffc097          	auipc	ra,0xffffc
    800042d0:	7fa080e7          	jalr	2042(ra) # 80000ac6 <uvmclear>
  stackbase = sp - PGSIZE;
    800042d4:	7c7d                	lui	s8,0xfffff
    800042d6:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800042d8:	e0043783          	ld	a5,-512(s0)
    800042dc:	6388                	ld	a0,0(a5)
    800042de:	c535                	beqz	a0,8000434a <exec+0x216>
    800042e0:	e9040993          	addi	s3,s0,-368
    800042e4:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042e8:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800042ea:	ffffc097          	auipc	ra,0xffffc
    800042ee:	012080e7          	jalr	18(ra) # 800002fc <strlen>
    800042f2:	2505                	addiw	a0,a0,1
    800042f4:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042f8:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042fc:	13896363          	bltu	s2,s8,80004422 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004300:	e0043d83          	ld	s11,-512(s0)
    80004304:	000dba03          	ld	s4,0(s11)
    80004308:	8552                	mv	a0,s4
    8000430a:	ffffc097          	auipc	ra,0xffffc
    8000430e:	ff2080e7          	jalr	-14(ra) # 800002fc <strlen>
    80004312:	0015069b          	addiw	a3,a0,1
    80004316:	8652                	mv	a2,s4
    80004318:	85ca                	mv	a1,s2
    8000431a:	855e                	mv	a0,s7
    8000431c:	ffffc097          	auipc	ra,0xffffc
    80004320:	7dc080e7          	jalr	2012(ra) # 80000af8 <copyout>
    80004324:	10054363          	bltz	a0,8000442a <exec+0x2f6>
    ustack[argc] = sp;
    80004328:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000432c:	0485                	addi	s1,s1,1
    8000432e:	008d8793          	addi	a5,s11,8
    80004332:	e0f43023          	sd	a5,-512(s0)
    80004336:	008db503          	ld	a0,8(s11)
    8000433a:	c911                	beqz	a0,8000434e <exec+0x21a>
    if(argc >= MAXARG)
    8000433c:	09a1                	addi	s3,s3,8
    8000433e:	fb3c96e3          	bne	s9,s3,800042ea <exec+0x1b6>
  sz = sz1;
    80004342:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004346:	4481                	li	s1,0
    80004348:	a84d                	j	800043fa <exec+0x2c6>
  sp = sz;
    8000434a:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000434c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000434e:	00349793          	slli	a5,s1,0x3
    80004352:	f9040713          	addi	a4,s0,-112
    80004356:	97ba                	add	a5,a5,a4
    80004358:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000435c:	00148693          	addi	a3,s1,1
    80004360:	068e                	slli	a3,a3,0x3
    80004362:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004366:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000436a:	01897663          	bgeu	s2,s8,80004376 <exec+0x242>
  sz = sz1;
    8000436e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004372:	4481                	li	s1,0
    80004374:	a059                	j	800043fa <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004376:	e9040613          	addi	a2,s0,-368
    8000437a:	85ca                	mv	a1,s2
    8000437c:	855e                	mv	a0,s7
    8000437e:	ffffc097          	auipc	ra,0xffffc
    80004382:	77a080e7          	jalr	1914(ra) # 80000af8 <copyout>
    80004386:	0a054663          	bltz	a0,80004432 <exec+0x2fe>
  p->trapframe->a1 = sp;
    8000438a:	058ab783          	ld	a5,88(s5)
    8000438e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004392:	df843783          	ld	a5,-520(s0)
    80004396:	0007c703          	lbu	a4,0(a5)
    8000439a:	cf11                	beqz	a4,800043b6 <exec+0x282>
    8000439c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000439e:	02f00693          	li	a3,47
    800043a2:	a039                	j	800043b0 <exec+0x27c>
      last = s+1;
    800043a4:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043a8:	0785                	addi	a5,a5,1
    800043aa:	fff7c703          	lbu	a4,-1(a5)
    800043ae:	c701                	beqz	a4,800043b6 <exec+0x282>
    if(*s == '/')
    800043b0:	fed71ce3          	bne	a4,a3,800043a8 <exec+0x274>
    800043b4:	bfc5                	j	800043a4 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800043b6:	4641                	li	a2,16
    800043b8:	df843583          	ld	a1,-520(s0)
    800043bc:	158a8513          	addi	a0,s5,344
    800043c0:	ffffc097          	auipc	ra,0xffffc
    800043c4:	f0a080e7          	jalr	-246(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800043c8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043cc:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800043d0:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043d4:	058ab783          	ld	a5,88(s5)
    800043d8:	e6843703          	ld	a4,-408(s0)
    800043dc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043de:	058ab783          	ld	a5,88(s5)
    800043e2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043e6:	85ea                	mv	a1,s10
    800043e8:	ffffd097          	auipc	ra,0xffffd
    800043ec:	bd4080e7          	jalr	-1068(ra) # 80000fbc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043f0:	0004851b          	sext.w	a0,s1
    800043f4:	bbe1                	j	800041cc <exec+0x98>
    800043f6:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043fa:	e0843583          	ld	a1,-504(s0)
    800043fe:	855e                	mv	a0,s7
    80004400:	ffffd097          	auipc	ra,0xffffd
    80004404:	bbc080e7          	jalr	-1092(ra) # 80000fbc <proc_freepagetable>
  if(ip){
    80004408:	da0498e3          	bnez	s1,800041b8 <exec+0x84>
  return -1;
    8000440c:	557d                	li	a0,-1
    8000440e:	bb7d                	j	800041cc <exec+0x98>
    80004410:	e1243423          	sd	s2,-504(s0)
    80004414:	b7dd                	j	800043fa <exec+0x2c6>
    80004416:	e1243423          	sd	s2,-504(s0)
    8000441a:	b7c5                	j	800043fa <exec+0x2c6>
    8000441c:	e1243423          	sd	s2,-504(s0)
    80004420:	bfe9                	j	800043fa <exec+0x2c6>
  sz = sz1;
    80004422:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004426:	4481                	li	s1,0
    80004428:	bfc9                	j	800043fa <exec+0x2c6>
  sz = sz1;
    8000442a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000442e:	4481                	li	s1,0
    80004430:	b7e9                	j	800043fa <exec+0x2c6>
  sz = sz1;
    80004432:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004436:	4481                	li	s1,0
    80004438:	b7c9                	j	800043fa <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000443a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000443e:	2b05                	addiw	s6,s6,1
    80004440:	0389899b          	addiw	s3,s3,56
    80004444:	e8845783          	lhu	a5,-376(s0)
    80004448:	e2fb5be3          	bge	s6,a5,8000427e <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000444c:	2981                	sext.w	s3,s3
    8000444e:	03800713          	li	a4,56
    80004452:	86ce                	mv	a3,s3
    80004454:	e1840613          	addi	a2,s0,-488
    80004458:	4581                	li	a1,0
    8000445a:	8526                	mv	a0,s1
    8000445c:	fffff097          	auipc	ra,0xfffff
    80004460:	a8e080e7          	jalr	-1394(ra) # 80002eea <readi>
    80004464:	03800793          	li	a5,56
    80004468:	f8f517e3          	bne	a0,a5,800043f6 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000446c:	e1842783          	lw	a5,-488(s0)
    80004470:	4705                	li	a4,1
    80004472:	fce796e3          	bne	a5,a4,8000443e <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004476:	e4043603          	ld	a2,-448(s0)
    8000447a:	e3843783          	ld	a5,-456(s0)
    8000447e:	f8f669e3          	bltu	a2,a5,80004410 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004482:	e2843783          	ld	a5,-472(s0)
    80004486:	963e                	add	a2,a2,a5
    80004488:	f8f667e3          	bltu	a2,a5,80004416 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000448c:	85ca                	mv	a1,s2
    8000448e:	855e                	mv	a0,s7
    80004490:	ffffc097          	auipc	ra,0xffffc
    80004494:	424080e7          	jalr	1060(ra) # 800008b4 <uvmalloc>
    80004498:	e0a43423          	sd	a0,-504(s0)
    8000449c:	d141                	beqz	a0,8000441c <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000449e:	e2843d03          	ld	s10,-472(s0)
    800044a2:	df043783          	ld	a5,-528(s0)
    800044a6:	00fd77b3          	and	a5,s10,a5
    800044aa:	fba1                	bnez	a5,800043fa <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044ac:	e2042d83          	lw	s11,-480(s0)
    800044b0:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044b4:	f80c03e3          	beqz	s8,8000443a <exec+0x306>
    800044b8:	8a62                	mv	s4,s8
    800044ba:	4901                	li	s2,0
    800044bc:	b345                	j	8000425c <exec+0x128>

00000000800044be <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044be:	7179                	addi	sp,sp,-48
    800044c0:	f406                	sd	ra,40(sp)
    800044c2:	f022                	sd	s0,32(sp)
    800044c4:	ec26                	sd	s1,24(sp)
    800044c6:	e84a                	sd	s2,16(sp)
    800044c8:	1800                	addi	s0,sp,48
    800044ca:	892e                	mv	s2,a1
    800044cc:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800044ce:	fdc40593          	addi	a1,s0,-36
    800044d2:	ffffe097          	auipc	ra,0xffffe
    800044d6:	bf2080e7          	jalr	-1038(ra) # 800020c4 <argint>
    800044da:	04054063          	bltz	a0,8000451a <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044de:	fdc42703          	lw	a4,-36(s0)
    800044e2:	47bd                	li	a5,15
    800044e4:	02e7ed63          	bltu	a5,a4,8000451e <argfd+0x60>
    800044e8:	ffffd097          	auipc	ra,0xffffd
    800044ec:	94e080e7          	jalr	-1714(ra) # 80000e36 <myproc>
    800044f0:	fdc42703          	lw	a4,-36(s0)
    800044f4:	01a70793          	addi	a5,a4,26
    800044f8:	078e                	slli	a5,a5,0x3
    800044fa:	953e                	add	a0,a0,a5
    800044fc:	611c                	ld	a5,0(a0)
    800044fe:	c395                	beqz	a5,80004522 <argfd+0x64>
    return -1;
  if(pfd)
    80004500:	00090463          	beqz	s2,80004508 <argfd+0x4a>
    *pfd = fd;
    80004504:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004508:	4501                	li	a0,0
  if(pf)
    8000450a:	c091                	beqz	s1,8000450e <argfd+0x50>
    *pf = f;
    8000450c:	e09c                	sd	a5,0(s1)
}
    8000450e:	70a2                	ld	ra,40(sp)
    80004510:	7402                	ld	s0,32(sp)
    80004512:	64e2                	ld	s1,24(sp)
    80004514:	6942                	ld	s2,16(sp)
    80004516:	6145                	addi	sp,sp,48
    80004518:	8082                	ret
    return -1;
    8000451a:	557d                	li	a0,-1
    8000451c:	bfcd                	j	8000450e <argfd+0x50>
    return -1;
    8000451e:	557d                	li	a0,-1
    80004520:	b7fd                	j	8000450e <argfd+0x50>
    80004522:	557d                	li	a0,-1
    80004524:	b7ed                	j	8000450e <argfd+0x50>

0000000080004526 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004526:	1101                	addi	sp,sp,-32
    80004528:	ec06                	sd	ra,24(sp)
    8000452a:	e822                	sd	s0,16(sp)
    8000452c:	e426                	sd	s1,8(sp)
    8000452e:	1000                	addi	s0,sp,32
    80004530:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004532:	ffffd097          	auipc	ra,0xffffd
    80004536:	904080e7          	jalr	-1788(ra) # 80000e36 <myproc>
    8000453a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000453c:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd6c70>
    80004540:	4501                	li	a0,0
    80004542:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004544:	6398                	ld	a4,0(a5)
    80004546:	cb19                	beqz	a4,8000455c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004548:	2505                	addiw	a0,a0,1
    8000454a:	07a1                	addi	a5,a5,8
    8000454c:	fed51ce3          	bne	a0,a3,80004544 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004550:	557d                	li	a0,-1
}
    80004552:	60e2                	ld	ra,24(sp)
    80004554:	6442                	ld	s0,16(sp)
    80004556:	64a2                	ld	s1,8(sp)
    80004558:	6105                	addi	sp,sp,32
    8000455a:	8082                	ret
      p->ofile[fd] = f;
    8000455c:	01a50793          	addi	a5,a0,26
    80004560:	078e                	slli	a5,a5,0x3
    80004562:	963e                	add	a2,a2,a5
    80004564:	e204                	sd	s1,0(a2)
      return fd;
    80004566:	b7f5                	j	80004552 <fdalloc+0x2c>

0000000080004568 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004568:	715d                	addi	sp,sp,-80
    8000456a:	e486                	sd	ra,72(sp)
    8000456c:	e0a2                	sd	s0,64(sp)
    8000456e:	fc26                	sd	s1,56(sp)
    80004570:	f84a                	sd	s2,48(sp)
    80004572:	f44e                	sd	s3,40(sp)
    80004574:	f052                	sd	s4,32(sp)
    80004576:	ec56                	sd	s5,24(sp)
    80004578:	0880                	addi	s0,sp,80
    8000457a:	89ae                	mv	s3,a1
    8000457c:	8ab2                	mv	s5,a2
    8000457e:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004580:	fb040593          	addi	a1,s0,-80
    80004584:	fffff097          	auipc	ra,0xfffff
    80004588:	e86080e7          	jalr	-378(ra) # 8000340a <nameiparent>
    8000458c:	892a                	mv	s2,a0
    8000458e:	12050f63          	beqz	a0,800046cc <create+0x164>
    return 0;

  ilock(dp);
    80004592:	ffffe097          	auipc	ra,0xffffe
    80004596:	6a4080e7          	jalr	1700(ra) # 80002c36 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000459a:	4601                	li	a2,0
    8000459c:	fb040593          	addi	a1,s0,-80
    800045a0:	854a                	mv	a0,s2
    800045a2:	fffff097          	auipc	ra,0xfffff
    800045a6:	b78080e7          	jalr	-1160(ra) # 8000311a <dirlookup>
    800045aa:	84aa                	mv	s1,a0
    800045ac:	c921                	beqz	a0,800045fc <create+0x94>
    iunlockput(dp);
    800045ae:	854a                	mv	a0,s2
    800045b0:	fffff097          	auipc	ra,0xfffff
    800045b4:	8e8080e7          	jalr	-1816(ra) # 80002e98 <iunlockput>
    ilock(ip);
    800045b8:	8526                	mv	a0,s1
    800045ba:	ffffe097          	auipc	ra,0xffffe
    800045be:	67c080e7          	jalr	1660(ra) # 80002c36 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045c2:	2981                	sext.w	s3,s3
    800045c4:	4789                	li	a5,2
    800045c6:	02f99463          	bne	s3,a5,800045ee <create+0x86>
    800045ca:	0444d783          	lhu	a5,68(s1)
    800045ce:	37f9                	addiw	a5,a5,-2
    800045d0:	17c2                	slli	a5,a5,0x30
    800045d2:	93c1                	srli	a5,a5,0x30
    800045d4:	4705                	li	a4,1
    800045d6:	00f76c63          	bltu	a4,a5,800045ee <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800045da:	8526                	mv	a0,s1
    800045dc:	60a6                	ld	ra,72(sp)
    800045de:	6406                	ld	s0,64(sp)
    800045e0:	74e2                	ld	s1,56(sp)
    800045e2:	7942                	ld	s2,48(sp)
    800045e4:	79a2                	ld	s3,40(sp)
    800045e6:	7a02                	ld	s4,32(sp)
    800045e8:	6ae2                	ld	s5,24(sp)
    800045ea:	6161                	addi	sp,sp,80
    800045ec:	8082                	ret
    iunlockput(ip);
    800045ee:	8526                	mv	a0,s1
    800045f0:	fffff097          	auipc	ra,0xfffff
    800045f4:	8a8080e7          	jalr	-1880(ra) # 80002e98 <iunlockput>
    return 0;
    800045f8:	4481                	li	s1,0
    800045fa:	b7c5                	j	800045da <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045fc:	85ce                	mv	a1,s3
    800045fe:	00092503          	lw	a0,0(s2)
    80004602:	ffffe097          	auipc	ra,0xffffe
    80004606:	49c080e7          	jalr	1180(ra) # 80002a9e <ialloc>
    8000460a:	84aa                	mv	s1,a0
    8000460c:	c529                	beqz	a0,80004656 <create+0xee>
  ilock(ip);
    8000460e:	ffffe097          	auipc	ra,0xffffe
    80004612:	628080e7          	jalr	1576(ra) # 80002c36 <ilock>
  ip->major = major;
    80004616:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000461a:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000461e:	4785                	li	a5,1
    80004620:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004624:	8526                	mv	a0,s1
    80004626:	ffffe097          	auipc	ra,0xffffe
    8000462a:	546080e7          	jalr	1350(ra) # 80002b6c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000462e:	2981                	sext.w	s3,s3
    80004630:	4785                	li	a5,1
    80004632:	02f98a63          	beq	s3,a5,80004666 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004636:	40d0                	lw	a2,4(s1)
    80004638:	fb040593          	addi	a1,s0,-80
    8000463c:	854a                	mv	a0,s2
    8000463e:	fffff097          	auipc	ra,0xfffff
    80004642:	cec080e7          	jalr	-788(ra) # 8000332a <dirlink>
    80004646:	06054b63          	bltz	a0,800046bc <create+0x154>
  iunlockput(dp);
    8000464a:	854a                	mv	a0,s2
    8000464c:	fffff097          	auipc	ra,0xfffff
    80004650:	84c080e7          	jalr	-1972(ra) # 80002e98 <iunlockput>
  return ip;
    80004654:	b759                	j	800045da <create+0x72>
    panic("create: ialloc");
    80004656:	00004517          	auipc	a0,0x4
    8000465a:	f9a50513          	addi	a0,a0,-102 # 800085f0 <syscalls+0x2b0>
    8000465e:	00002097          	auipc	ra,0x2
    80004662:	9c8080e7          	jalr	-1592(ra) # 80006026 <panic>
    dp->nlink++;  // for ".."
    80004666:	04a95783          	lhu	a5,74(s2)
    8000466a:	2785                	addiw	a5,a5,1
    8000466c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004670:	854a                	mv	a0,s2
    80004672:	ffffe097          	auipc	ra,0xffffe
    80004676:	4fa080e7          	jalr	1274(ra) # 80002b6c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000467a:	40d0                	lw	a2,4(s1)
    8000467c:	00004597          	auipc	a1,0x4
    80004680:	f8458593          	addi	a1,a1,-124 # 80008600 <syscalls+0x2c0>
    80004684:	8526                	mv	a0,s1
    80004686:	fffff097          	auipc	ra,0xfffff
    8000468a:	ca4080e7          	jalr	-860(ra) # 8000332a <dirlink>
    8000468e:	00054f63          	bltz	a0,800046ac <create+0x144>
    80004692:	00492603          	lw	a2,4(s2)
    80004696:	00004597          	auipc	a1,0x4
    8000469a:	f7258593          	addi	a1,a1,-142 # 80008608 <syscalls+0x2c8>
    8000469e:	8526                	mv	a0,s1
    800046a0:	fffff097          	auipc	ra,0xfffff
    800046a4:	c8a080e7          	jalr	-886(ra) # 8000332a <dirlink>
    800046a8:	f80557e3          	bgez	a0,80004636 <create+0xce>
      panic("create dots");
    800046ac:	00004517          	auipc	a0,0x4
    800046b0:	f6450513          	addi	a0,a0,-156 # 80008610 <syscalls+0x2d0>
    800046b4:	00002097          	auipc	ra,0x2
    800046b8:	972080e7          	jalr	-1678(ra) # 80006026 <panic>
    panic("create: dirlink");
    800046bc:	00004517          	auipc	a0,0x4
    800046c0:	f6450513          	addi	a0,a0,-156 # 80008620 <syscalls+0x2e0>
    800046c4:	00002097          	auipc	ra,0x2
    800046c8:	962080e7          	jalr	-1694(ra) # 80006026 <panic>
    return 0;
    800046cc:	84aa                	mv	s1,a0
    800046ce:	b731                	j	800045da <create+0x72>

00000000800046d0 <sys_dup>:
{
    800046d0:	7179                	addi	sp,sp,-48
    800046d2:	f406                	sd	ra,40(sp)
    800046d4:	f022                	sd	s0,32(sp)
    800046d6:	ec26                	sd	s1,24(sp)
    800046d8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046da:	fd840613          	addi	a2,s0,-40
    800046de:	4581                	li	a1,0
    800046e0:	4501                	li	a0,0
    800046e2:	00000097          	auipc	ra,0x0
    800046e6:	ddc080e7          	jalr	-548(ra) # 800044be <argfd>
    return -1;
    800046ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046ec:	02054363          	bltz	a0,80004712 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046f0:	fd843503          	ld	a0,-40(s0)
    800046f4:	00000097          	auipc	ra,0x0
    800046f8:	e32080e7          	jalr	-462(ra) # 80004526 <fdalloc>
    800046fc:	84aa                	mv	s1,a0
    return -1;
    800046fe:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004700:	00054963          	bltz	a0,80004712 <sys_dup+0x42>
  filedup(f);
    80004704:	fd843503          	ld	a0,-40(s0)
    80004708:	fffff097          	auipc	ra,0xfffff
    8000470c:	37a080e7          	jalr	890(ra) # 80003a82 <filedup>
  return fd;
    80004710:	87a6                	mv	a5,s1
}
    80004712:	853e                	mv	a0,a5
    80004714:	70a2                	ld	ra,40(sp)
    80004716:	7402                	ld	s0,32(sp)
    80004718:	64e2                	ld	s1,24(sp)
    8000471a:	6145                	addi	sp,sp,48
    8000471c:	8082                	ret

000000008000471e <sys_read>:
{
    8000471e:	7179                	addi	sp,sp,-48
    80004720:	f406                	sd	ra,40(sp)
    80004722:	f022                	sd	s0,32(sp)
    80004724:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004726:	fe840613          	addi	a2,s0,-24
    8000472a:	4581                	li	a1,0
    8000472c:	4501                	li	a0,0
    8000472e:	00000097          	auipc	ra,0x0
    80004732:	d90080e7          	jalr	-624(ra) # 800044be <argfd>
    return -1;
    80004736:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004738:	04054163          	bltz	a0,8000477a <sys_read+0x5c>
    8000473c:	fe440593          	addi	a1,s0,-28
    80004740:	4509                	li	a0,2
    80004742:	ffffe097          	auipc	ra,0xffffe
    80004746:	982080e7          	jalr	-1662(ra) # 800020c4 <argint>
    return -1;
    8000474a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000474c:	02054763          	bltz	a0,8000477a <sys_read+0x5c>
    80004750:	fd840593          	addi	a1,s0,-40
    80004754:	4505                	li	a0,1
    80004756:	ffffe097          	auipc	ra,0xffffe
    8000475a:	990080e7          	jalr	-1648(ra) # 800020e6 <argaddr>
    return -1;
    8000475e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004760:	00054d63          	bltz	a0,8000477a <sys_read+0x5c>
  return fileread(f, p, n);
    80004764:	fe442603          	lw	a2,-28(s0)
    80004768:	fd843583          	ld	a1,-40(s0)
    8000476c:	fe843503          	ld	a0,-24(s0)
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	49e080e7          	jalr	1182(ra) # 80003c0e <fileread>
    80004778:	87aa                	mv	a5,a0
}
    8000477a:	853e                	mv	a0,a5
    8000477c:	70a2                	ld	ra,40(sp)
    8000477e:	7402                	ld	s0,32(sp)
    80004780:	6145                	addi	sp,sp,48
    80004782:	8082                	ret

0000000080004784 <sys_write>:
{
    80004784:	7179                	addi	sp,sp,-48
    80004786:	f406                	sd	ra,40(sp)
    80004788:	f022                	sd	s0,32(sp)
    8000478a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000478c:	fe840613          	addi	a2,s0,-24
    80004790:	4581                	li	a1,0
    80004792:	4501                	li	a0,0
    80004794:	00000097          	auipc	ra,0x0
    80004798:	d2a080e7          	jalr	-726(ra) # 800044be <argfd>
    return -1;
    8000479c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000479e:	04054163          	bltz	a0,800047e0 <sys_write+0x5c>
    800047a2:	fe440593          	addi	a1,s0,-28
    800047a6:	4509                	li	a0,2
    800047a8:	ffffe097          	auipc	ra,0xffffe
    800047ac:	91c080e7          	jalr	-1764(ra) # 800020c4 <argint>
    return -1;
    800047b0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047b2:	02054763          	bltz	a0,800047e0 <sys_write+0x5c>
    800047b6:	fd840593          	addi	a1,s0,-40
    800047ba:	4505                	li	a0,1
    800047bc:	ffffe097          	auipc	ra,0xffffe
    800047c0:	92a080e7          	jalr	-1750(ra) # 800020e6 <argaddr>
    return -1;
    800047c4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047c6:	00054d63          	bltz	a0,800047e0 <sys_write+0x5c>
  return filewrite(f, p, n);
    800047ca:	fe442603          	lw	a2,-28(s0)
    800047ce:	fd843583          	ld	a1,-40(s0)
    800047d2:	fe843503          	ld	a0,-24(s0)
    800047d6:	fffff097          	auipc	ra,0xfffff
    800047da:	4fa080e7          	jalr	1274(ra) # 80003cd0 <filewrite>
    800047de:	87aa                	mv	a5,a0
}
    800047e0:	853e                	mv	a0,a5
    800047e2:	70a2                	ld	ra,40(sp)
    800047e4:	7402                	ld	s0,32(sp)
    800047e6:	6145                	addi	sp,sp,48
    800047e8:	8082                	ret

00000000800047ea <sys_close>:
{
    800047ea:	1101                	addi	sp,sp,-32
    800047ec:	ec06                	sd	ra,24(sp)
    800047ee:	e822                	sd	s0,16(sp)
    800047f0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047f2:	fe040613          	addi	a2,s0,-32
    800047f6:	fec40593          	addi	a1,s0,-20
    800047fa:	4501                	li	a0,0
    800047fc:	00000097          	auipc	ra,0x0
    80004800:	cc2080e7          	jalr	-830(ra) # 800044be <argfd>
    return -1;
    80004804:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004806:	02054463          	bltz	a0,8000482e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000480a:	ffffc097          	auipc	ra,0xffffc
    8000480e:	62c080e7          	jalr	1580(ra) # 80000e36 <myproc>
    80004812:	fec42783          	lw	a5,-20(s0)
    80004816:	07e9                	addi	a5,a5,26
    80004818:	078e                	slli	a5,a5,0x3
    8000481a:	97aa                	add	a5,a5,a0
    8000481c:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004820:	fe043503          	ld	a0,-32(s0)
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	2b0080e7          	jalr	688(ra) # 80003ad4 <fileclose>
  return 0;
    8000482c:	4781                	li	a5,0
}
    8000482e:	853e                	mv	a0,a5
    80004830:	60e2                	ld	ra,24(sp)
    80004832:	6442                	ld	s0,16(sp)
    80004834:	6105                	addi	sp,sp,32
    80004836:	8082                	ret

0000000080004838 <sys_fstat>:
{
    80004838:	1101                	addi	sp,sp,-32
    8000483a:	ec06                	sd	ra,24(sp)
    8000483c:	e822                	sd	s0,16(sp)
    8000483e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004840:	fe840613          	addi	a2,s0,-24
    80004844:	4581                	li	a1,0
    80004846:	4501                	li	a0,0
    80004848:	00000097          	auipc	ra,0x0
    8000484c:	c76080e7          	jalr	-906(ra) # 800044be <argfd>
    return -1;
    80004850:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004852:	02054563          	bltz	a0,8000487c <sys_fstat+0x44>
    80004856:	fe040593          	addi	a1,s0,-32
    8000485a:	4505                	li	a0,1
    8000485c:	ffffe097          	auipc	ra,0xffffe
    80004860:	88a080e7          	jalr	-1910(ra) # 800020e6 <argaddr>
    return -1;
    80004864:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004866:	00054b63          	bltz	a0,8000487c <sys_fstat+0x44>
  return filestat(f, st);
    8000486a:	fe043583          	ld	a1,-32(s0)
    8000486e:	fe843503          	ld	a0,-24(s0)
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	32a080e7          	jalr	810(ra) # 80003b9c <filestat>
    8000487a:	87aa                	mv	a5,a0
}
    8000487c:	853e                	mv	a0,a5
    8000487e:	60e2                	ld	ra,24(sp)
    80004880:	6442                	ld	s0,16(sp)
    80004882:	6105                	addi	sp,sp,32
    80004884:	8082                	ret

0000000080004886 <sys_link>:
{
    80004886:	7169                	addi	sp,sp,-304
    80004888:	f606                	sd	ra,296(sp)
    8000488a:	f222                	sd	s0,288(sp)
    8000488c:	ee26                	sd	s1,280(sp)
    8000488e:	ea4a                	sd	s2,272(sp)
    80004890:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004892:	08000613          	li	a2,128
    80004896:	ed040593          	addi	a1,s0,-304
    8000489a:	4501                	li	a0,0
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	86c080e7          	jalr	-1940(ra) # 80002108 <argstr>
    return -1;
    800048a4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048a6:	10054e63          	bltz	a0,800049c2 <sys_link+0x13c>
    800048aa:	08000613          	li	a2,128
    800048ae:	f5040593          	addi	a1,s0,-176
    800048b2:	4505                	li	a0,1
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	854080e7          	jalr	-1964(ra) # 80002108 <argstr>
    return -1;
    800048bc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048be:	10054263          	bltz	a0,800049c2 <sys_link+0x13c>
  begin_op();
    800048c2:	fffff097          	auipc	ra,0xfffff
    800048c6:	d46080e7          	jalr	-698(ra) # 80003608 <begin_op>
  if((ip = namei(old)) == 0){
    800048ca:	ed040513          	addi	a0,s0,-304
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	b1e080e7          	jalr	-1250(ra) # 800033ec <namei>
    800048d6:	84aa                	mv	s1,a0
    800048d8:	c551                	beqz	a0,80004964 <sys_link+0xde>
  ilock(ip);
    800048da:	ffffe097          	auipc	ra,0xffffe
    800048de:	35c080e7          	jalr	860(ra) # 80002c36 <ilock>
  if(ip->type == T_DIR){
    800048e2:	04449703          	lh	a4,68(s1)
    800048e6:	4785                	li	a5,1
    800048e8:	08f70463          	beq	a4,a5,80004970 <sys_link+0xea>
  ip->nlink++;
    800048ec:	04a4d783          	lhu	a5,74(s1)
    800048f0:	2785                	addiw	a5,a5,1
    800048f2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048f6:	8526                	mv	a0,s1
    800048f8:	ffffe097          	auipc	ra,0xffffe
    800048fc:	274080e7          	jalr	628(ra) # 80002b6c <iupdate>
  iunlock(ip);
    80004900:	8526                	mv	a0,s1
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	3f6080e7          	jalr	1014(ra) # 80002cf8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000490a:	fd040593          	addi	a1,s0,-48
    8000490e:	f5040513          	addi	a0,s0,-176
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	af8080e7          	jalr	-1288(ra) # 8000340a <nameiparent>
    8000491a:	892a                	mv	s2,a0
    8000491c:	c935                	beqz	a0,80004990 <sys_link+0x10a>
  ilock(dp);
    8000491e:	ffffe097          	auipc	ra,0xffffe
    80004922:	318080e7          	jalr	792(ra) # 80002c36 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004926:	00092703          	lw	a4,0(s2)
    8000492a:	409c                	lw	a5,0(s1)
    8000492c:	04f71d63          	bne	a4,a5,80004986 <sys_link+0x100>
    80004930:	40d0                	lw	a2,4(s1)
    80004932:	fd040593          	addi	a1,s0,-48
    80004936:	854a                	mv	a0,s2
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	9f2080e7          	jalr	-1550(ra) # 8000332a <dirlink>
    80004940:	04054363          	bltz	a0,80004986 <sys_link+0x100>
  iunlockput(dp);
    80004944:	854a                	mv	a0,s2
    80004946:	ffffe097          	auipc	ra,0xffffe
    8000494a:	552080e7          	jalr	1362(ra) # 80002e98 <iunlockput>
  iput(ip);
    8000494e:	8526                	mv	a0,s1
    80004950:	ffffe097          	auipc	ra,0xffffe
    80004954:	4a0080e7          	jalr	1184(ra) # 80002df0 <iput>
  end_op();
    80004958:	fffff097          	auipc	ra,0xfffff
    8000495c:	d30080e7          	jalr	-720(ra) # 80003688 <end_op>
  return 0;
    80004960:	4781                	li	a5,0
    80004962:	a085                	j	800049c2 <sys_link+0x13c>
    end_op();
    80004964:	fffff097          	auipc	ra,0xfffff
    80004968:	d24080e7          	jalr	-732(ra) # 80003688 <end_op>
    return -1;
    8000496c:	57fd                	li	a5,-1
    8000496e:	a891                	j	800049c2 <sys_link+0x13c>
    iunlockput(ip);
    80004970:	8526                	mv	a0,s1
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	526080e7          	jalr	1318(ra) # 80002e98 <iunlockput>
    end_op();
    8000497a:	fffff097          	auipc	ra,0xfffff
    8000497e:	d0e080e7          	jalr	-754(ra) # 80003688 <end_op>
    return -1;
    80004982:	57fd                	li	a5,-1
    80004984:	a83d                	j	800049c2 <sys_link+0x13c>
    iunlockput(dp);
    80004986:	854a                	mv	a0,s2
    80004988:	ffffe097          	auipc	ra,0xffffe
    8000498c:	510080e7          	jalr	1296(ra) # 80002e98 <iunlockput>
  ilock(ip);
    80004990:	8526                	mv	a0,s1
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	2a4080e7          	jalr	676(ra) # 80002c36 <ilock>
  ip->nlink--;
    8000499a:	04a4d783          	lhu	a5,74(s1)
    8000499e:	37fd                	addiw	a5,a5,-1
    800049a0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049a4:	8526                	mv	a0,s1
    800049a6:	ffffe097          	auipc	ra,0xffffe
    800049aa:	1c6080e7          	jalr	454(ra) # 80002b6c <iupdate>
  iunlockput(ip);
    800049ae:	8526                	mv	a0,s1
    800049b0:	ffffe097          	auipc	ra,0xffffe
    800049b4:	4e8080e7          	jalr	1256(ra) # 80002e98 <iunlockput>
  end_op();
    800049b8:	fffff097          	auipc	ra,0xfffff
    800049bc:	cd0080e7          	jalr	-816(ra) # 80003688 <end_op>
  return -1;
    800049c0:	57fd                	li	a5,-1
}
    800049c2:	853e                	mv	a0,a5
    800049c4:	70b2                	ld	ra,296(sp)
    800049c6:	7412                	ld	s0,288(sp)
    800049c8:	64f2                	ld	s1,280(sp)
    800049ca:	6952                	ld	s2,272(sp)
    800049cc:	6155                	addi	sp,sp,304
    800049ce:	8082                	ret

00000000800049d0 <sys_mmap>:
{
    800049d0:	7139                	addi	sp,sp,-64
    800049d2:	fc06                	sd	ra,56(sp)
    800049d4:	f822                	sd	s0,48(sp)
    800049d6:	f426                	sd	s1,40(sp)
    800049d8:	f04a                	sd	s2,32(sp)
    800049da:	ec4e                	sd	s3,24(sp)
    800049dc:	0080                	addi	s0,sp,64
	if(argint(1,&length)<0||argint(2,&prot)<0||argint(3,&flags)<0||argint(4,&fd)<0)
    800049de:	fcc40593          	addi	a1,s0,-52
    800049e2:	4505                	li	a0,1
    800049e4:	ffffd097          	auipc	ra,0xffffd
    800049e8:	6e0080e7          	jalr	1760(ra) # 800020c4 <argint>
		return 0xffffffffffffffff;
    800049ec:	54fd                	li	s1,-1
	if(argint(1,&length)<0||argint(2,&prot)<0||argint(3,&flags)<0||argint(4,&fd)<0)
    800049ee:	10054663          	bltz	a0,80004afa <sys_mmap+0x12a>
    800049f2:	fc840593          	addi	a1,s0,-56
    800049f6:	4509                	li	a0,2
    800049f8:	ffffd097          	auipc	ra,0xffffd
    800049fc:	6cc080e7          	jalr	1740(ra) # 800020c4 <argint>
    80004a00:	0e054d63          	bltz	a0,80004afa <sys_mmap+0x12a>
    80004a04:	fc440593          	addi	a1,s0,-60
    80004a08:	450d                	li	a0,3
    80004a0a:	ffffd097          	auipc	ra,0xffffd
    80004a0e:	6ba080e7          	jalr	1722(ra) # 800020c4 <argint>
    80004a12:	0e054463          	bltz	a0,80004afa <sys_mmap+0x12a>
    80004a16:	fc040593          	addi	a1,s0,-64
    80004a1a:	4511                	li	a0,4
    80004a1c:	ffffd097          	auipc	ra,0xffffd
    80004a20:	6a8080e7          	jalr	1704(ra) # 800020c4 <argint>
    80004a24:	0c054b63          	bltz	a0,80004afa <sys_mmap+0x12a>
	pr=myproc();
    80004a28:	ffffc097          	auipc	ra,0xffffc
    80004a2c:	40e080e7          	jalr	1038(ra) # 80000e36 <myproc>
    80004a30:	892a                	mv	s2,a0
	if(!pr->ofile[fd]->readable)
    80004a32:	fc042783          	lw	a5,-64(s0)
    80004a36:	07e9                	addi	a5,a5,26
    80004a38:	078e                	slli	a5,a5,0x3
    80004a3a:	97aa                	add	a5,a5,a0
    80004a3c:	639c                	ld	a5,0(a5)
    80004a3e:	0087c703          	lbu	a4,8(a5)
    80004a42:	e709                	bnez	a4,80004a4c <sys_mmap+0x7c>
		if(prot&PROT_READ)
    80004a44:	fc842703          	lw	a4,-56(s0)
    80004a48:	8b05                	andi	a4,a4,1
    80004a4a:	eb45                	bnez	a4,80004afa <sys_mmap+0x12a>
	if(!pr->ofile[fd]->writable)
    80004a4c:	0097c783          	lbu	a5,9(a5)
    80004a50:	eb91                	bnez	a5,80004a64 <sys_mmap+0x94>
		if(prot&PROT_WRITE && flags==MAP_SHARED)
    80004a52:	fc842783          	lw	a5,-56(s0)
    80004a56:	8b89                	andi	a5,a5,2
    80004a58:	c791                	beqz	a5,80004a64 <sys_mmap+0x94>
    80004a5a:	fc442703          	lw	a4,-60(s0)
    80004a5e:	4785                	li	a5,1
    80004a60:	0af70563          	beq	a4,a5,80004b0a <sys_mmap+0x13a>
	if((vmap=vma_alloc())==0)
    80004a64:	00001097          	auipc	ra,0x1
    80004a68:	02a080e7          	jalr	42(ra) # 80005a8e <vma_alloc>
    80004a6c:	89aa                	mv	s3,a0
    80004a6e:	c145                	beqz	a0,80004b0e <sys_mmap+0x13e>
	acquire(&pr->lock);
    80004a70:	854a                	mv	a0,s2
    80004a72:	00002097          	auipc	ra,0x2
    80004a76:	afe080e7          	jalr	-1282(ra) # 80006570 <acquire>
	for(i=0;i<NOFILE;i++)
    80004a7a:	16890793          	addi	a5,s2,360
    80004a7e:	4481                	li	s1,0
    80004a80:	46c1                	li	a3,16
		if(pr->areaps[i]==0)
    80004a82:	6398                	ld	a4,0(a5)
    80004a84:	c719                	beqz	a4,80004a92 <sys_mmap+0xc2>
	for(i=0;i<NOFILE;i++)
    80004a86:	2485                	addiw	s1,s1,1
    80004a88:	07a1                	addi	a5,a5,8
    80004a8a:	fed49ce3          	bne	s1,a3,80004a82 <sys_mmap+0xb2>
		return 0xffffffffffffffff;
    80004a8e:	54fd                	li	s1,-1
    80004a90:	a0ad                	j	80004afa <sys_mmap+0x12a>
			pr->areaps[i]=vmap;
    80004a92:	02c48793          	addi	a5,s1,44
    80004a96:	078e                	slli	a5,a5,0x3
    80004a98:	97ca                	add	a5,a5,s2
    80004a9a:	0137b423          	sd	s3,8(a5)
			release(&pr->lock);
    80004a9e:	854a                	mv	a0,s2
    80004aa0:	00002097          	auipc	ra,0x2
    80004aa4:	b84080e7          	jalr	-1148(ra) # 80006624 <release>
	if(i==NOFILE)
    80004aa8:	47c1                	li	a5,16
    80004aaa:	06f48463          	beq	s1,a5,80004b12 <sys_mmap+0x142>
	sz=pr->sz;
    80004aae:	04893483          	ld	s1,72(s2)
	if(lazy_grow_proc(length)<0)
    80004ab2:	fcc42503          	lw	a0,-52(s0)
    80004ab6:	ffffc097          	auipc	ra,0xffffc
    80004aba:	3b8080e7          	jalr	952(ra) # 80000e6e <lazy_grow_proc>
    80004abe:	04054c63          	bltz	a0,80004b16 <sys_mmap+0x146>
	vmap->addr=(char*)sz;
    80004ac2:	0099b023          	sd	s1,0(s3)
	vmap->length=length;
    80004ac6:	fcc42783          	lw	a5,-52(s0)
    80004aca:	00f9b423          	sd	a5,8(s3)
	vmap->prot=(prot & PROT_READ)|(prot&PROT_WRITE);
    80004ace:	fc844783          	lbu	a5,-56(s0)
    80004ad2:	8b8d                	andi	a5,a5,3
    80004ad4:	00f98823          	sb	a5,16(s3)
	vmap->flags=flags;
    80004ad8:	fc442783          	lw	a5,-60(s0)
    80004adc:	00f988a3          	sb	a5,17(s3)
	vmap->file=pr->ofile[fd];
    80004ae0:	fc042783          	lw	a5,-64(s0)
    80004ae4:	07e9                	addi	a5,a5,26
    80004ae6:	078e                	slli	a5,a5,0x3
    80004ae8:	993e                	add	s2,s2,a5
    80004aea:	00093503          	ld	a0,0(s2)
    80004aee:	00a9bc23          	sd	a0,24(s3)
	filedup(pr->ofile[fd]);
    80004af2:	fffff097          	auipc	ra,0xfffff
    80004af6:	f90080e7          	jalr	-112(ra) # 80003a82 <filedup>
}
    80004afa:	8526                	mv	a0,s1
    80004afc:	70e2                	ld	ra,56(sp)
    80004afe:	7442                	ld	s0,48(sp)
    80004b00:	74a2                	ld	s1,40(sp)
    80004b02:	7902                	ld	s2,32(sp)
    80004b04:	69e2                	ld	s3,24(sp)
    80004b06:	6121                	addi	sp,sp,64
    80004b08:	8082                	ret
			return 0xffffffffffffffff;
    80004b0a:	54fd                	li	s1,-1
    80004b0c:	b7fd                	j	80004afa <sys_mmap+0x12a>
		return 0xffffffffffffffff;
    80004b0e:	54fd                	li	s1,-1
    80004b10:	b7ed                	j	80004afa <sys_mmap+0x12a>
		return 0xffffffffffffffff;
    80004b12:	54fd                	li	s1,-1
    80004b14:	b7dd                	j	80004afa <sys_mmap+0x12a>
		return 0xffffffffffffffff;
    80004b16:	54fd                	li	s1,-1
    80004b18:	b7cd                	j	80004afa <sys_mmap+0x12a>

0000000080004b1a <sys_munmap>:
{
    80004b1a:	715d                	addi	sp,sp,-80
    80004b1c:	e486                	sd	ra,72(sp)
    80004b1e:	e0a2                	sd	s0,64(sp)
    80004b20:	fc26                	sd	s1,56(sp)
    80004b22:	f84a                	sd	s2,48(sp)
    80004b24:	f44e                	sd	s3,40(sp)
    80004b26:	f052                	sd	s4,32(sp)
    80004b28:	ec56                	sd	s5,24(sp)
    80004b2a:	0880                	addi	s0,sp,80
	struct proc* pr=myproc();
    80004b2c:	ffffc097          	auipc	ra,0xffffc
    80004b30:	30a080e7          	jalr	778(ra) # 80000e36 <myproc>
    80004b34:	8a2a                	mv	s4,a0
	if(argint(0,&startAddr)<0||argint(1,&length)<0)
    80004b36:	fbc40593          	addi	a1,s0,-68
    80004b3a:	4501                	li	a0,0
    80004b3c:	ffffd097          	auipc	ra,0xffffd
    80004b40:	588080e7          	jalr	1416(ra) # 800020c4 <argint>
		return -1;
    80004b44:	57fd                	li	a5,-1
	if(argint(0,&startAddr)<0||argint(1,&length)<0)
    80004b46:	10054863          	bltz	a0,80004c56 <sys_munmap+0x13c>
    80004b4a:	fb840593          	addi	a1,s0,-72
    80004b4e:	4505                	li	a0,1
    80004b50:	ffffd097          	auipc	ra,0xffffd
    80004b54:	574080e7          	jalr	1396(ra) # 800020c4 <argint>
    80004b58:	10054963          	bltz	a0,80004c6a <sys_munmap+0x150>
    80004b5c:	168a0493          	addi	s1,s4,360
	for(int i=0;i<NOFILE;i++)
    80004b60:	4901                	li	s2,0
    80004b62:	4ac1                	li	s5,16
    80004b64:	a881                	j	80004bb4 <sys_munmap+0x9a>
			uvmunmap(pr->pagetable,(uint64)startAddr,length/PGSIZE,1);
    80004b66:	fb842783          	lw	a5,-72(s0)
    80004b6a:	41f7d61b          	sraiw	a2,a5,0x1f
    80004b6e:	0146561b          	srliw	a2,a2,0x14
    80004b72:	9e3d                	addw	a2,a2,a5
    80004b74:	4685                	li	a3,1
    80004b76:	40c6561b          	sraiw	a2,a2,0xc
    80004b7a:	fbc42583          	lw	a1,-68(s0)
    80004b7e:	050a3503          	ld	a0,80(s4)
    80004b82:	ffffc097          	auipc	ra,0xffffc
    80004b86:	b94080e7          	jalr	-1132(ra) # 80000716 <uvmunmap>
			if(length==pr->areaps[i]->length)
    80004b8a:	fb842683          	lw	a3,-72(s0)
    80004b8e:	0009b783          	ld	a5,0(s3)
    80004b92:	6798                	ld	a4,8(a5)
    80004b94:	08e68f63          	beq	a3,a4,80004c32 <sys_munmap+0x118>
				pr->areaps[i]->addr+=length;
    80004b98:	6398                	ld	a4,0(a5)
    80004b9a:	9736                	add	a4,a4,a3
    80004b9c:	e398                	sd	a4,0(a5)
				pr->areaps[i]->length-=length;
    80004b9e:	0009b703          	ld	a4,0(s3)
    80004ba2:	fb842683          	lw	a3,-72(s0)
    80004ba6:	671c                	ld	a5,8(a4)
    80004ba8:	8f95                	sub	a5,a5,a3
    80004baa:	e71c                	sd	a5,8(a4)
	for(int i=0;i<NOFILE;i++)
    80004bac:	2905                	addiw	s2,s2,1
    80004bae:	04a1                	addi	s1,s1,8
    80004bb0:	0b590263          	beq	s2,s5,80004c54 <sys_munmap+0x13a>
		if(pr->areaps[i]==0)
    80004bb4:	89a6                	mv	s3,s1
    80004bb6:	609c                	ld	a5,0(s1)
    80004bb8:	dbf5                	beqz	a5,80004bac <sys_munmap+0x92>
		if((uint64)pr->areaps[i]->addr==startAddr)
    80004bba:	fbc42703          	lw	a4,-68(s0)
    80004bbe:	6394                	ld	a3,0(a5)
    80004bc0:	fee696e3          	bne	a3,a4,80004bac <sys_munmap+0x92>
			if(length>=pr->areaps[i]->length)
    80004bc4:	6798                	ld	a4,8(a5)
    80004bc6:	fb842683          	lw	a3,-72(s0)
    80004bca:	00e6e463          	bltu	a3,a4,80004bd2 <sys_munmap+0xb8>
				length=pr->areaps[i]->length;
    80004bce:	fae42c23          	sw	a4,-72(s0)
			if(pr->areaps[i]->prot&PROT_WRITE&&pr->areaps[i]->flags==MAP_SHARED)
    80004bd2:	0107c703          	lbu	a4,16(a5)
    80004bd6:	8b09                	andi	a4,a4,2
    80004bd8:	d759                	beqz	a4,80004b66 <sys_munmap+0x4c>
    80004bda:	0117c703          	lbu	a4,17(a5)
    80004bde:	4785                	li	a5,1
    80004be0:	f8f713e3          	bne	a4,a5,80004b66 <sys_munmap+0x4c>
				begin_op();
    80004be4:	fffff097          	auipc	ra,0xfffff
    80004be8:	a24080e7          	jalr	-1500(ra) # 80003608 <begin_op>
				ilock(pr->areaps[i]->file->ip);
    80004bec:	0009b783          	ld	a5,0(s3)
    80004bf0:	6f9c                	ld	a5,24(a5)
    80004bf2:	6f88                	ld	a0,24(a5)
    80004bf4:	ffffe097          	auipc	ra,0xffffe
    80004bf8:	042080e7          	jalr	66(ra) # 80002c36 <ilock>
				writei(pr->areaps[i]->file->ip,1,(uint64)startAddr,0,length);
    80004bfc:	0009b783          	ld	a5,0(s3)
    80004c00:	6f9c                	ld	a5,24(a5)
    80004c02:	fb842703          	lw	a4,-72(s0)
    80004c06:	4681                	li	a3,0
    80004c08:	fbc42603          	lw	a2,-68(s0)
    80004c0c:	4585                	li	a1,1
    80004c0e:	6f88                	ld	a0,24(a5)
    80004c10:	ffffe097          	auipc	ra,0xffffe
    80004c14:	3d2080e7          	jalr	978(ra) # 80002fe2 <writei>
				iunlock(pr->areaps[i]->file->ip);
    80004c18:	0009b783          	ld	a5,0(s3)
    80004c1c:	6f9c                	ld	a5,24(a5)
    80004c1e:	6f88                	ld	a0,24(a5)
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	0d8080e7          	jalr	216(ra) # 80002cf8 <iunlock>
				end_op();
    80004c28:	fffff097          	auipc	ra,0xfffff
    80004c2c:	a60080e7          	jalr	-1440(ra) # 80003688 <end_op>
    80004c30:	bf1d                	j	80004b66 <sys_munmap+0x4c>
				fileclose(pr->areaps[i]->file);
    80004c32:	6f88                	ld	a0,24(a5)
    80004c34:	fffff097          	auipc	ra,0xfffff
    80004c38:	ea0080e7          	jalr	-352(ra) # 80003ad4 <fileclose>
				vma_free(pr->areaps[i]);
    80004c3c:	090e                	slli	s2,s2,0x3
    80004c3e:	9952                	add	s2,s2,s4
    80004c40:	16893503          	ld	a0,360(s2)
    80004c44:	00001097          	auipc	ra,0x1
    80004c48:	eb0080e7          	jalr	-336(ra) # 80005af4 <vma_free>
				pr->areaps[i]=0;
    80004c4c:	16093423          	sd	zero,360(s2)
				return 0;
    80004c50:	4781                	li	a5,0
    80004c52:	a011                	j	80004c56 <sys_munmap+0x13c>
	return -1;
    80004c54:	57fd                	li	a5,-1
}
    80004c56:	853e                	mv	a0,a5
    80004c58:	60a6                	ld	ra,72(sp)
    80004c5a:	6406                	ld	s0,64(sp)
    80004c5c:	74e2                	ld	s1,56(sp)
    80004c5e:	7942                	ld	s2,48(sp)
    80004c60:	79a2                	ld	s3,40(sp)
    80004c62:	7a02                	ld	s4,32(sp)
    80004c64:	6ae2                	ld	s5,24(sp)
    80004c66:	6161                	addi	sp,sp,80
    80004c68:	8082                	ret
		return -1;
    80004c6a:	57fd                	li	a5,-1
    80004c6c:	b7ed                	j	80004c56 <sys_munmap+0x13c>

0000000080004c6e <sys_unlink>:
{
    80004c6e:	7151                	addi	sp,sp,-240
    80004c70:	f586                	sd	ra,232(sp)
    80004c72:	f1a2                	sd	s0,224(sp)
    80004c74:	eda6                	sd	s1,216(sp)
    80004c76:	e9ca                	sd	s2,208(sp)
    80004c78:	e5ce                	sd	s3,200(sp)
    80004c7a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c7c:	08000613          	li	a2,128
    80004c80:	f3040593          	addi	a1,s0,-208
    80004c84:	4501                	li	a0,0
    80004c86:	ffffd097          	auipc	ra,0xffffd
    80004c8a:	482080e7          	jalr	1154(ra) # 80002108 <argstr>
    80004c8e:	18054163          	bltz	a0,80004e10 <sys_unlink+0x1a2>
  begin_op();
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	976080e7          	jalr	-1674(ra) # 80003608 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c9a:	fb040593          	addi	a1,s0,-80
    80004c9e:	f3040513          	addi	a0,s0,-208
    80004ca2:	ffffe097          	auipc	ra,0xffffe
    80004ca6:	768080e7          	jalr	1896(ra) # 8000340a <nameiparent>
    80004caa:	84aa                	mv	s1,a0
    80004cac:	c979                	beqz	a0,80004d82 <sys_unlink+0x114>
  ilock(dp);
    80004cae:	ffffe097          	auipc	ra,0xffffe
    80004cb2:	f88080e7          	jalr	-120(ra) # 80002c36 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004cb6:	00004597          	auipc	a1,0x4
    80004cba:	94a58593          	addi	a1,a1,-1718 # 80008600 <syscalls+0x2c0>
    80004cbe:	fb040513          	addi	a0,s0,-80
    80004cc2:	ffffe097          	auipc	ra,0xffffe
    80004cc6:	43e080e7          	jalr	1086(ra) # 80003100 <namecmp>
    80004cca:	14050a63          	beqz	a0,80004e1e <sys_unlink+0x1b0>
    80004cce:	00004597          	auipc	a1,0x4
    80004cd2:	93a58593          	addi	a1,a1,-1734 # 80008608 <syscalls+0x2c8>
    80004cd6:	fb040513          	addi	a0,s0,-80
    80004cda:	ffffe097          	auipc	ra,0xffffe
    80004cde:	426080e7          	jalr	1062(ra) # 80003100 <namecmp>
    80004ce2:	12050e63          	beqz	a0,80004e1e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ce6:	f2c40613          	addi	a2,s0,-212
    80004cea:	fb040593          	addi	a1,s0,-80
    80004cee:	8526                	mv	a0,s1
    80004cf0:	ffffe097          	auipc	ra,0xffffe
    80004cf4:	42a080e7          	jalr	1066(ra) # 8000311a <dirlookup>
    80004cf8:	892a                	mv	s2,a0
    80004cfa:	12050263          	beqz	a0,80004e1e <sys_unlink+0x1b0>
  ilock(ip);
    80004cfe:	ffffe097          	auipc	ra,0xffffe
    80004d02:	f38080e7          	jalr	-200(ra) # 80002c36 <ilock>
  if(ip->nlink < 1)
    80004d06:	04a91783          	lh	a5,74(s2)
    80004d0a:	08f05263          	blez	a5,80004d8e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d0e:	04491703          	lh	a4,68(s2)
    80004d12:	4785                	li	a5,1
    80004d14:	08f70563          	beq	a4,a5,80004d9e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004d18:	4641                	li	a2,16
    80004d1a:	4581                	li	a1,0
    80004d1c:	fc040513          	addi	a0,s0,-64
    80004d20:	ffffb097          	auipc	ra,0xffffb
    80004d24:	458080e7          	jalr	1112(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d28:	4741                	li	a4,16
    80004d2a:	f2c42683          	lw	a3,-212(s0)
    80004d2e:	fc040613          	addi	a2,s0,-64
    80004d32:	4581                	li	a1,0
    80004d34:	8526                	mv	a0,s1
    80004d36:	ffffe097          	auipc	ra,0xffffe
    80004d3a:	2ac080e7          	jalr	684(ra) # 80002fe2 <writei>
    80004d3e:	47c1                	li	a5,16
    80004d40:	0af51563          	bne	a0,a5,80004dea <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004d44:	04491703          	lh	a4,68(s2)
    80004d48:	4785                	li	a5,1
    80004d4a:	0af70863          	beq	a4,a5,80004dfa <sys_unlink+0x18c>
  iunlockput(dp);
    80004d4e:	8526                	mv	a0,s1
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	148080e7          	jalr	328(ra) # 80002e98 <iunlockput>
  ip->nlink--;
    80004d58:	04a95783          	lhu	a5,74(s2)
    80004d5c:	37fd                	addiw	a5,a5,-1
    80004d5e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d62:	854a                	mv	a0,s2
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	e08080e7          	jalr	-504(ra) # 80002b6c <iupdate>
  iunlockput(ip);
    80004d6c:	854a                	mv	a0,s2
    80004d6e:	ffffe097          	auipc	ra,0xffffe
    80004d72:	12a080e7          	jalr	298(ra) # 80002e98 <iunlockput>
  end_op();
    80004d76:	fffff097          	auipc	ra,0xfffff
    80004d7a:	912080e7          	jalr	-1774(ra) # 80003688 <end_op>
  return 0;
    80004d7e:	4501                	li	a0,0
    80004d80:	a84d                	j	80004e32 <sys_unlink+0x1c4>
    end_op();
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	906080e7          	jalr	-1786(ra) # 80003688 <end_op>
    return -1;
    80004d8a:	557d                	li	a0,-1
    80004d8c:	a05d                	j	80004e32 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004d8e:	00004517          	auipc	a0,0x4
    80004d92:	8a250513          	addi	a0,a0,-1886 # 80008630 <syscalls+0x2f0>
    80004d96:	00001097          	auipc	ra,0x1
    80004d9a:	290080e7          	jalr	656(ra) # 80006026 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d9e:	04c92703          	lw	a4,76(s2)
    80004da2:	02000793          	li	a5,32
    80004da6:	f6e7f9e3          	bgeu	a5,a4,80004d18 <sys_unlink+0xaa>
    80004daa:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004dae:	4741                	li	a4,16
    80004db0:	86ce                	mv	a3,s3
    80004db2:	f1840613          	addi	a2,s0,-232
    80004db6:	4581                	li	a1,0
    80004db8:	854a                	mv	a0,s2
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	130080e7          	jalr	304(ra) # 80002eea <readi>
    80004dc2:	47c1                	li	a5,16
    80004dc4:	00f51b63          	bne	a0,a5,80004dda <sys_unlink+0x16c>
    if(de.inum != 0)
    80004dc8:	f1845783          	lhu	a5,-232(s0)
    80004dcc:	e7a1                	bnez	a5,80004e14 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004dce:	29c1                	addiw	s3,s3,16
    80004dd0:	04c92783          	lw	a5,76(s2)
    80004dd4:	fcf9ede3          	bltu	s3,a5,80004dae <sys_unlink+0x140>
    80004dd8:	b781                	j	80004d18 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004dda:	00004517          	auipc	a0,0x4
    80004dde:	86e50513          	addi	a0,a0,-1938 # 80008648 <syscalls+0x308>
    80004de2:	00001097          	auipc	ra,0x1
    80004de6:	244080e7          	jalr	580(ra) # 80006026 <panic>
    panic("unlink: writei");
    80004dea:	00004517          	auipc	a0,0x4
    80004dee:	87650513          	addi	a0,a0,-1930 # 80008660 <syscalls+0x320>
    80004df2:	00001097          	auipc	ra,0x1
    80004df6:	234080e7          	jalr	564(ra) # 80006026 <panic>
    dp->nlink--;
    80004dfa:	04a4d783          	lhu	a5,74(s1)
    80004dfe:	37fd                	addiw	a5,a5,-1
    80004e00:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e04:	8526                	mv	a0,s1
    80004e06:	ffffe097          	auipc	ra,0xffffe
    80004e0a:	d66080e7          	jalr	-666(ra) # 80002b6c <iupdate>
    80004e0e:	b781                	j	80004d4e <sys_unlink+0xe0>
    return -1;
    80004e10:	557d                	li	a0,-1
    80004e12:	a005                	j	80004e32 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004e14:	854a                	mv	a0,s2
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	082080e7          	jalr	130(ra) # 80002e98 <iunlockput>
  iunlockput(dp);
    80004e1e:	8526                	mv	a0,s1
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	078080e7          	jalr	120(ra) # 80002e98 <iunlockput>
  end_op();
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	860080e7          	jalr	-1952(ra) # 80003688 <end_op>
  return -1;
    80004e30:	557d                	li	a0,-1
}
    80004e32:	70ae                	ld	ra,232(sp)
    80004e34:	740e                	ld	s0,224(sp)
    80004e36:	64ee                	ld	s1,216(sp)
    80004e38:	694e                	ld	s2,208(sp)
    80004e3a:	69ae                	ld	s3,200(sp)
    80004e3c:	616d                	addi	sp,sp,240
    80004e3e:	8082                	ret

0000000080004e40 <sys_open>:

uint64
sys_open(void)
{
    80004e40:	7131                	addi	sp,sp,-192
    80004e42:	fd06                	sd	ra,184(sp)
    80004e44:	f922                	sd	s0,176(sp)
    80004e46:	f526                	sd	s1,168(sp)
    80004e48:	f14a                	sd	s2,160(sp)
    80004e4a:	ed4e                	sd	s3,152(sp)
    80004e4c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004e4e:	08000613          	li	a2,128
    80004e52:	f5040593          	addi	a1,s0,-176
    80004e56:	4501                	li	a0,0
    80004e58:	ffffd097          	auipc	ra,0xffffd
    80004e5c:	2b0080e7          	jalr	688(ra) # 80002108 <argstr>
    return -1;
    80004e60:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004e62:	0c054163          	bltz	a0,80004f24 <sys_open+0xe4>
    80004e66:	f4c40593          	addi	a1,s0,-180
    80004e6a:	4505                	li	a0,1
    80004e6c:	ffffd097          	auipc	ra,0xffffd
    80004e70:	258080e7          	jalr	600(ra) # 800020c4 <argint>
    80004e74:	0a054863          	bltz	a0,80004f24 <sys_open+0xe4>

  begin_op();
    80004e78:	ffffe097          	auipc	ra,0xffffe
    80004e7c:	790080e7          	jalr	1936(ra) # 80003608 <begin_op>

  if(omode & O_CREATE){
    80004e80:	f4c42783          	lw	a5,-180(s0)
    80004e84:	2007f793          	andi	a5,a5,512
    80004e88:	cbdd                	beqz	a5,80004f3e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004e8a:	4681                	li	a3,0
    80004e8c:	4601                	li	a2,0
    80004e8e:	4589                	li	a1,2
    80004e90:	f5040513          	addi	a0,s0,-176
    80004e94:	fffff097          	auipc	ra,0xfffff
    80004e98:	6d4080e7          	jalr	1748(ra) # 80004568 <create>
    80004e9c:	892a                	mv	s2,a0
    if(ip == 0){
    80004e9e:	c959                	beqz	a0,80004f34 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ea0:	04491703          	lh	a4,68(s2)
    80004ea4:	478d                	li	a5,3
    80004ea6:	00f71763          	bne	a4,a5,80004eb4 <sys_open+0x74>
    80004eaa:	04695703          	lhu	a4,70(s2)
    80004eae:	47a5                	li	a5,9
    80004eb0:	0ce7ec63          	bltu	a5,a4,80004f88 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004eb4:	fffff097          	auipc	ra,0xfffff
    80004eb8:	b64080e7          	jalr	-1180(ra) # 80003a18 <filealloc>
    80004ebc:	89aa                	mv	s3,a0
    80004ebe:	10050263          	beqz	a0,80004fc2 <sys_open+0x182>
    80004ec2:	fffff097          	auipc	ra,0xfffff
    80004ec6:	664080e7          	jalr	1636(ra) # 80004526 <fdalloc>
    80004eca:	84aa                	mv	s1,a0
    80004ecc:	0e054663          	bltz	a0,80004fb8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ed0:	04491703          	lh	a4,68(s2)
    80004ed4:	478d                	li	a5,3
    80004ed6:	0cf70463          	beq	a4,a5,80004f9e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004eda:	4789                	li	a5,2
    80004edc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004ee0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004ee4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004ee8:	f4c42783          	lw	a5,-180(s0)
    80004eec:	0017c713          	xori	a4,a5,1
    80004ef0:	8b05                	andi	a4,a4,1
    80004ef2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ef6:	0037f713          	andi	a4,a5,3
    80004efa:	00e03733          	snez	a4,a4
    80004efe:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f02:	4007f793          	andi	a5,a5,1024
    80004f06:	c791                	beqz	a5,80004f12 <sys_open+0xd2>
    80004f08:	04491703          	lh	a4,68(s2)
    80004f0c:	4789                	li	a5,2
    80004f0e:	08f70f63          	beq	a4,a5,80004fac <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004f12:	854a                	mv	a0,s2
    80004f14:	ffffe097          	auipc	ra,0xffffe
    80004f18:	de4080e7          	jalr	-540(ra) # 80002cf8 <iunlock>
  end_op();
    80004f1c:	ffffe097          	auipc	ra,0xffffe
    80004f20:	76c080e7          	jalr	1900(ra) # 80003688 <end_op>

  return fd;
}
    80004f24:	8526                	mv	a0,s1
    80004f26:	70ea                	ld	ra,184(sp)
    80004f28:	744a                	ld	s0,176(sp)
    80004f2a:	74aa                	ld	s1,168(sp)
    80004f2c:	790a                	ld	s2,160(sp)
    80004f2e:	69ea                	ld	s3,152(sp)
    80004f30:	6129                	addi	sp,sp,192
    80004f32:	8082                	ret
      end_op();
    80004f34:	ffffe097          	auipc	ra,0xffffe
    80004f38:	754080e7          	jalr	1876(ra) # 80003688 <end_op>
      return -1;
    80004f3c:	b7e5                	j	80004f24 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004f3e:	f5040513          	addi	a0,s0,-176
    80004f42:	ffffe097          	auipc	ra,0xffffe
    80004f46:	4aa080e7          	jalr	1194(ra) # 800033ec <namei>
    80004f4a:	892a                	mv	s2,a0
    80004f4c:	c905                	beqz	a0,80004f7c <sys_open+0x13c>
    ilock(ip);
    80004f4e:	ffffe097          	auipc	ra,0xffffe
    80004f52:	ce8080e7          	jalr	-792(ra) # 80002c36 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004f56:	04491703          	lh	a4,68(s2)
    80004f5a:	4785                	li	a5,1
    80004f5c:	f4f712e3          	bne	a4,a5,80004ea0 <sys_open+0x60>
    80004f60:	f4c42783          	lw	a5,-180(s0)
    80004f64:	dba1                	beqz	a5,80004eb4 <sys_open+0x74>
      iunlockput(ip);
    80004f66:	854a                	mv	a0,s2
    80004f68:	ffffe097          	auipc	ra,0xffffe
    80004f6c:	f30080e7          	jalr	-208(ra) # 80002e98 <iunlockput>
      end_op();
    80004f70:	ffffe097          	auipc	ra,0xffffe
    80004f74:	718080e7          	jalr	1816(ra) # 80003688 <end_op>
      return -1;
    80004f78:	54fd                	li	s1,-1
    80004f7a:	b76d                	j	80004f24 <sys_open+0xe4>
      end_op();
    80004f7c:	ffffe097          	auipc	ra,0xffffe
    80004f80:	70c080e7          	jalr	1804(ra) # 80003688 <end_op>
      return -1;
    80004f84:	54fd                	li	s1,-1
    80004f86:	bf79                	j	80004f24 <sys_open+0xe4>
    iunlockput(ip);
    80004f88:	854a                	mv	a0,s2
    80004f8a:	ffffe097          	auipc	ra,0xffffe
    80004f8e:	f0e080e7          	jalr	-242(ra) # 80002e98 <iunlockput>
    end_op();
    80004f92:	ffffe097          	auipc	ra,0xffffe
    80004f96:	6f6080e7          	jalr	1782(ra) # 80003688 <end_op>
    return -1;
    80004f9a:	54fd                	li	s1,-1
    80004f9c:	b761                	j	80004f24 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004f9e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004fa2:	04691783          	lh	a5,70(s2)
    80004fa6:	02f99223          	sh	a5,36(s3)
    80004faa:	bf2d                	j	80004ee4 <sys_open+0xa4>
    itrunc(ip);
    80004fac:	854a                	mv	a0,s2
    80004fae:	ffffe097          	auipc	ra,0xffffe
    80004fb2:	d96080e7          	jalr	-618(ra) # 80002d44 <itrunc>
    80004fb6:	bfb1                	j	80004f12 <sys_open+0xd2>
      fileclose(f);
    80004fb8:	854e                	mv	a0,s3
    80004fba:	fffff097          	auipc	ra,0xfffff
    80004fbe:	b1a080e7          	jalr	-1254(ra) # 80003ad4 <fileclose>
    iunlockput(ip);
    80004fc2:	854a                	mv	a0,s2
    80004fc4:	ffffe097          	auipc	ra,0xffffe
    80004fc8:	ed4080e7          	jalr	-300(ra) # 80002e98 <iunlockput>
    end_op();
    80004fcc:	ffffe097          	auipc	ra,0xffffe
    80004fd0:	6bc080e7          	jalr	1724(ra) # 80003688 <end_op>
    return -1;
    80004fd4:	54fd                	li	s1,-1
    80004fd6:	b7b9                	j	80004f24 <sys_open+0xe4>

0000000080004fd8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004fd8:	7175                	addi	sp,sp,-144
    80004fda:	e506                	sd	ra,136(sp)
    80004fdc:	e122                	sd	s0,128(sp)
    80004fde:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004fe0:	ffffe097          	auipc	ra,0xffffe
    80004fe4:	628080e7          	jalr	1576(ra) # 80003608 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004fe8:	08000613          	li	a2,128
    80004fec:	f7040593          	addi	a1,s0,-144
    80004ff0:	4501                	li	a0,0
    80004ff2:	ffffd097          	auipc	ra,0xffffd
    80004ff6:	116080e7          	jalr	278(ra) # 80002108 <argstr>
    80004ffa:	02054963          	bltz	a0,8000502c <sys_mkdir+0x54>
    80004ffe:	4681                	li	a3,0
    80005000:	4601                	li	a2,0
    80005002:	4585                	li	a1,1
    80005004:	f7040513          	addi	a0,s0,-144
    80005008:	fffff097          	auipc	ra,0xfffff
    8000500c:	560080e7          	jalr	1376(ra) # 80004568 <create>
    80005010:	cd11                	beqz	a0,8000502c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005012:	ffffe097          	auipc	ra,0xffffe
    80005016:	e86080e7          	jalr	-378(ra) # 80002e98 <iunlockput>
  end_op();
    8000501a:	ffffe097          	auipc	ra,0xffffe
    8000501e:	66e080e7          	jalr	1646(ra) # 80003688 <end_op>
  return 0;
    80005022:	4501                	li	a0,0
}
    80005024:	60aa                	ld	ra,136(sp)
    80005026:	640a                	ld	s0,128(sp)
    80005028:	6149                	addi	sp,sp,144
    8000502a:	8082                	ret
    end_op();
    8000502c:	ffffe097          	auipc	ra,0xffffe
    80005030:	65c080e7          	jalr	1628(ra) # 80003688 <end_op>
    return -1;
    80005034:	557d                	li	a0,-1
    80005036:	b7fd                	j	80005024 <sys_mkdir+0x4c>

0000000080005038 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005038:	7135                	addi	sp,sp,-160
    8000503a:	ed06                	sd	ra,152(sp)
    8000503c:	e922                	sd	s0,144(sp)
    8000503e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005040:	ffffe097          	auipc	ra,0xffffe
    80005044:	5c8080e7          	jalr	1480(ra) # 80003608 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005048:	08000613          	li	a2,128
    8000504c:	f7040593          	addi	a1,s0,-144
    80005050:	4501                	li	a0,0
    80005052:	ffffd097          	auipc	ra,0xffffd
    80005056:	0b6080e7          	jalr	182(ra) # 80002108 <argstr>
    8000505a:	04054a63          	bltz	a0,800050ae <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    8000505e:	f6c40593          	addi	a1,s0,-148
    80005062:	4505                	li	a0,1
    80005064:	ffffd097          	auipc	ra,0xffffd
    80005068:	060080e7          	jalr	96(ra) # 800020c4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000506c:	04054163          	bltz	a0,800050ae <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005070:	f6840593          	addi	a1,s0,-152
    80005074:	4509                	li	a0,2
    80005076:	ffffd097          	auipc	ra,0xffffd
    8000507a:	04e080e7          	jalr	78(ra) # 800020c4 <argint>
     argint(1, &major) < 0 ||
    8000507e:	02054863          	bltz	a0,800050ae <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005082:	f6841683          	lh	a3,-152(s0)
    80005086:	f6c41603          	lh	a2,-148(s0)
    8000508a:	458d                	li	a1,3
    8000508c:	f7040513          	addi	a0,s0,-144
    80005090:	fffff097          	auipc	ra,0xfffff
    80005094:	4d8080e7          	jalr	1240(ra) # 80004568 <create>
     argint(2, &minor) < 0 ||
    80005098:	c919                	beqz	a0,800050ae <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000509a:	ffffe097          	auipc	ra,0xffffe
    8000509e:	dfe080e7          	jalr	-514(ra) # 80002e98 <iunlockput>
  end_op();
    800050a2:	ffffe097          	auipc	ra,0xffffe
    800050a6:	5e6080e7          	jalr	1510(ra) # 80003688 <end_op>
  return 0;
    800050aa:	4501                	li	a0,0
    800050ac:	a031                	j	800050b8 <sys_mknod+0x80>
    end_op();
    800050ae:	ffffe097          	auipc	ra,0xffffe
    800050b2:	5da080e7          	jalr	1498(ra) # 80003688 <end_op>
    return -1;
    800050b6:	557d                	li	a0,-1
}
    800050b8:	60ea                	ld	ra,152(sp)
    800050ba:	644a                	ld	s0,144(sp)
    800050bc:	610d                	addi	sp,sp,160
    800050be:	8082                	ret

00000000800050c0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800050c0:	7135                	addi	sp,sp,-160
    800050c2:	ed06                	sd	ra,152(sp)
    800050c4:	e922                	sd	s0,144(sp)
    800050c6:	e526                	sd	s1,136(sp)
    800050c8:	e14a                	sd	s2,128(sp)
    800050ca:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050cc:	ffffc097          	auipc	ra,0xffffc
    800050d0:	d6a080e7          	jalr	-662(ra) # 80000e36 <myproc>
    800050d4:	892a                	mv	s2,a0
  
  begin_op();
    800050d6:	ffffe097          	auipc	ra,0xffffe
    800050da:	532080e7          	jalr	1330(ra) # 80003608 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800050de:	08000613          	li	a2,128
    800050e2:	f6040593          	addi	a1,s0,-160
    800050e6:	4501                	li	a0,0
    800050e8:	ffffd097          	auipc	ra,0xffffd
    800050ec:	020080e7          	jalr	32(ra) # 80002108 <argstr>
    800050f0:	04054b63          	bltz	a0,80005146 <sys_chdir+0x86>
    800050f4:	f6040513          	addi	a0,s0,-160
    800050f8:	ffffe097          	auipc	ra,0xffffe
    800050fc:	2f4080e7          	jalr	756(ra) # 800033ec <namei>
    80005100:	84aa                	mv	s1,a0
    80005102:	c131                	beqz	a0,80005146 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005104:	ffffe097          	auipc	ra,0xffffe
    80005108:	b32080e7          	jalr	-1230(ra) # 80002c36 <ilock>
  if(ip->type != T_DIR){
    8000510c:	04449703          	lh	a4,68(s1)
    80005110:	4785                	li	a5,1
    80005112:	04f71063          	bne	a4,a5,80005152 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005116:	8526                	mv	a0,s1
    80005118:	ffffe097          	auipc	ra,0xffffe
    8000511c:	be0080e7          	jalr	-1056(ra) # 80002cf8 <iunlock>
  iput(p->cwd);
    80005120:	15093503          	ld	a0,336(s2)
    80005124:	ffffe097          	auipc	ra,0xffffe
    80005128:	ccc080e7          	jalr	-820(ra) # 80002df0 <iput>
  end_op();
    8000512c:	ffffe097          	auipc	ra,0xffffe
    80005130:	55c080e7          	jalr	1372(ra) # 80003688 <end_op>
  p->cwd = ip;
    80005134:	14993823          	sd	s1,336(s2)
  return 0;
    80005138:	4501                	li	a0,0
}
    8000513a:	60ea                	ld	ra,152(sp)
    8000513c:	644a                	ld	s0,144(sp)
    8000513e:	64aa                	ld	s1,136(sp)
    80005140:	690a                	ld	s2,128(sp)
    80005142:	610d                	addi	sp,sp,160
    80005144:	8082                	ret
    end_op();
    80005146:	ffffe097          	auipc	ra,0xffffe
    8000514a:	542080e7          	jalr	1346(ra) # 80003688 <end_op>
    return -1;
    8000514e:	557d                	li	a0,-1
    80005150:	b7ed                	j	8000513a <sys_chdir+0x7a>
    iunlockput(ip);
    80005152:	8526                	mv	a0,s1
    80005154:	ffffe097          	auipc	ra,0xffffe
    80005158:	d44080e7          	jalr	-700(ra) # 80002e98 <iunlockput>
    end_op();
    8000515c:	ffffe097          	auipc	ra,0xffffe
    80005160:	52c080e7          	jalr	1324(ra) # 80003688 <end_op>
    return -1;
    80005164:	557d                	li	a0,-1
    80005166:	bfd1                	j	8000513a <sys_chdir+0x7a>

0000000080005168 <sys_exec>:

uint64
sys_exec(void)
{
    80005168:	7145                	addi	sp,sp,-464
    8000516a:	e786                	sd	ra,456(sp)
    8000516c:	e3a2                	sd	s0,448(sp)
    8000516e:	ff26                	sd	s1,440(sp)
    80005170:	fb4a                	sd	s2,432(sp)
    80005172:	f74e                	sd	s3,424(sp)
    80005174:	f352                	sd	s4,416(sp)
    80005176:	ef56                	sd	s5,408(sp)
    80005178:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000517a:	08000613          	li	a2,128
    8000517e:	f4040593          	addi	a1,s0,-192
    80005182:	4501                	li	a0,0
    80005184:	ffffd097          	auipc	ra,0xffffd
    80005188:	f84080e7          	jalr	-124(ra) # 80002108 <argstr>
    return -1;
    8000518c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000518e:	0c054a63          	bltz	a0,80005262 <sys_exec+0xfa>
    80005192:	e3840593          	addi	a1,s0,-456
    80005196:	4505                	li	a0,1
    80005198:	ffffd097          	auipc	ra,0xffffd
    8000519c:	f4e080e7          	jalr	-178(ra) # 800020e6 <argaddr>
    800051a0:	0c054163          	bltz	a0,80005262 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800051a4:	10000613          	li	a2,256
    800051a8:	4581                	li	a1,0
    800051aa:	e4040513          	addi	a0,s0,-448
    800051ae:	ffffb097          	auipc	ra,0xffffb
    800051b2:	fca080e7          	jalr	-54(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800051b6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800051ba:	89a6                	mv	s3,s1
    800051bc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800051be:	02000a13          	li	s4,32
    800051c2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800051c6:	00391513          	slli	a0,s2,0x3
    800051ca:	e3040593          	addi	a1,s0,-464
    800051ce:	e3843783          	ld	a5,-456(s0)
    800051d2:	953e                	add	a0,a0,a5
    800051d4:	ffffd097          	auipc	ra,0xffffd
    800051d8:	e56080e7          	jalr	-426(ra) # 8000202a <fetchaddr>
    800051dc:	02054a63          	bltz	a0,80005210 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    800051e0:	e3043783          	ld	a5,-464(s0)
    800051e4:	c3b9                	beqz	a5,8000522a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800051e6:	ffffb097          	auipc	ra,0xffffb
    800051ea:	f32080e7          	jalr	-206(ra) # 80000118 <kalloc>
    800051ee:	85aa                	mv	a1,a0
    800051f0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800051f4:	cd11                	beqz	a0,80005210 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800051f6:	6605                	lui	a2,0x1
    800051f8:	e3043503          	ld	a0,-464(s0)
    800051fc:	ffffd097          	auipc	ra,0xffffd
    80005200:	e80080e7          	jalr	-384(ra) # 8000207c <fetchstr>
    80005204:	00054663          	bltz	a0,80005210 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005208:	0905                	addi	s2,s2,1
    8000520a:	09a1                	addi	s3,s3,8
    8000520c:	fb491be3          	bne	s2,s4,800051c2 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005210:	10048913          	addi	s2,s1,256
    80005214:	6088                	ld	a0,0(s1)
    80005216:	c529                	beqz	a0,80005260 <sys_exec+0xf8>
    kfree(argv[i]);
    80005218:	ffffb097          	auipc	ra,0xffffb
    8000521c:	e04080e7          	jalr	-508(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005220:	04a1                	addi	s1,s1,8
    80005222:	ff2499e3          	bne	s1,s2,80005214 <sys_exec+0xac>
  return -1;
    80005226:	597d                	li	s2,-1
    80005228:	a82d                	j	80005262 <sys_exec+0xfa>
      argv[i] = 0;
    8000522a:	0a8e                	slli	s5,s5,0x3
    8000522c:	fc040793          	addi	a5,s0,-64
    80005230:	9abe                	add	s5,s5,a5
    80005232:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005236:	e4040593          	addi	a1,s0,-448
    8000523a:	f4040513          	addi	a0,s0,-192
    8000523e:	fffff097          	auipc	ra,0xfffff
    80005242:	ef6080e7          	jalr	-266(ra) # 80004134 <exec>
    80005246:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005248:	10048993          	addi	s3,s1,256
    8000524c:	6088                	ld	a0,0(s1)
    8000524e:	c911                	beqz	a0,80005262 <sys_exec+0xfa>
    kfree(argv[i]);
    80005250:	ffffb097          	auipc	ra,0xffffb
    80005254:	dcc080e7          	jalr	-564(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005258:	04a1                	addi	s1,s1,8
    8000525a:	ff3499e3          	bne	s1,s3,8000524c <sys_exec+0xe4>
    8000525e:	a011                	j	80005262 <sys_exec+0xfa>
  return -1;
    80005260:	597d                	li	s2,-1
}
    80005262:	854a                	mv	a0,s2
    80005264:	60be                	ld	ra,456(sp)
    80005266:	641e                	ld	s0,448(sp)
    80005268:	74fa                	ld	s1,440(sp)
    8000526a:	795a                	ld	s2,432(sp)
    8000526c:	79ba                	ld	s3,424(sp)
    8000526e:	7a1a                	ld	s4,416(sp)
    80005270:	6afa                	ld	s5,408(sp)
    80005272:	6179                	addi	sp,sp,464
    80005274:	8082                	ret

0000000080005276 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005276:	7139                	addi	sp,sp,-64
    80005278:	fc06                	sd	ra,56(sp)
    8000527a:	f822                	sd	s0,48(sp)
    8000527c:	f426                	sd	s1,40(sp)
    8000527e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005280:	ffffc097          	auipc	ra,0xffffc
    80005284:	bb6080e7          	jalr	-1098(ra) # 80000e36 <myproc>
    80005288:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000528a:	fd840593          	addi	a1,s0,-40
    8000528e:	4501                	li	a0,0
    80005290:	ffffd097          	auipc	ra,0xffffd
    80005294:	e56080e7          	jalr	-426(ra) # 800020e6 <argaddr>
    return -1;
    80005298:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000529a:	0e054063          	bltz	a0,8000537a <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000529e:	fc840593          	addi	a1,s0,-56
    800052a2:	fd040513          	addi	a0,s0,-48
    800052a6:	fffff097          	auipc	ra,0xfffff
    800052aa:	b5e080e7          	jalr	-1186(ra) # 80003e04 <pipealloc>
    return -1;
    800052ae:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800052b0:	0c054563          	bltz	a0,8000537a <sys_pipe+0x104>
  fd0 = -1;
    800052b4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800052b8:	fd043503          	ld	a0,-48(s0)
    800052bc:	fffff097          	auipc	ra,0xfffff
    800052c0:	26a080e7          	jalr	618(ra) # 80004526 <fdalloc>
    800052c4:	fca42223          	sw	a0,-60(s0)
    800052c8:	08054c63          	bltz	a0,80005360 <sys_pipe+0xea>
    800052cc:	fc843503          	ld	a0,-56(s0)
    800052d0:	fffff097          	auipc	ra,0xfffff
    800052d4:	256080e7          	jalr	598(ra) # 80004526 <fdalloc>
    800052d8:	fca42023          	sw	a0,-64(s0)
    800052dc:	06054863          	bltz	a0,8000534c <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052e0:	4691                	li	a3,4
    800052e2:	fc440613          	addi	a2,s0,-60
    800052e6:	fd843583          	ld	a1,-40(s0)
    800052ea:	68a8                	ld	a0,80(s1)
    800052ec:	ffffc097          	auipc	ra,0xffffc
    800052f0:	80c080e7          	jalr	-2036(ra) # 80000af8 <copyout>
    800052f4:	02054063          	bltz	a0,80005314 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800052f8:	4691                	li	a3,4
    800052fa:	fc040613          	addi	a2,s0,-64
    800052fe:	fd843583          	ld	a1,-40(s0)
    80005302:	0591                	addi	a1,a1,4
    80005304:	68a8                	ld	a0,80(s1)
    80005306:	ffffb097          	auipc	ra,0xffffb
    8000530a:	7f2080e7          	jalr	2034(ra) # 80000af8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000530e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005310:	06055563          	bgez	a0,8000537a <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005314:	fc442783          	lw	a5,-60(s0)
    80005318:	07e9                	addi	a5,a5,26
    8000531a:	078e                	slli	a5,a5,0x3
    8000531c:	97a6                	add	a5,a5,s1
    8000531e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005322:	fc042503          	lw	a0,-64(s0)
    80005326:	0569                	addi	a0,a0,26
    80005328:	050e                	slli	a0,a0,0x3
    8000532a:	9526                	add	a0,a0,s1
    8000532c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005330:	fd043503          	ld	a0,-48(s0)
    80005334:	ffffe097          	auipc	ra,0xffffe
    80005338:	7a0080e7          	jalr	1952(ra) # 80003ad4 <fileclose>
    fileclose(wf);
    8000533c:	fc843503          	ld	a0,-56(s0)
    80005340:	ffffe097          	auipc	ra,0xffffe
    80005344:	794080e7          	jalr	1940(ra) # 80003ad4 <fileclose>
    return -1;
    80005348:	57fd                	li	a5,-1
    8000534a:	a805                	j	8000537a <sys_pipe+0x104>
    if(fd0 >= 0)
    8000534c:	fc442783          	lw	a5,-60(s0)
    80005350:	0007c863          	bltz	a5,80005360 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005354:	01a78513          	addi	a0,a5,26
    80005358:	050e                	slli	a0,a0,0x3
    8000535a:	9526                	add	a0,a0,s1
    8000535c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005360:	fd043503          	ld	a0,-48(s0)
    80005364:	ffffe097          	auipc	ra,0xffffe
    80005368:	770080e7          	jalr	1904(ra) # 80003ad4 <fileclose>
    fileclose(wf);
    8000536c:	fc843503          	ld	a0,-56(s0)
    80005370:	ffffe097          	auipc	ra,0xffffe
    80005374:	764080e7          	jalr	1892(ra) # 80003ad4 <fileclose>
    return -1;
    80005378:	57fd                	li	a5,-1
}
    8000537a:	853e                	mv	a0,a5
    8000537c:	70e2                	ld	ra,56(sp)
    8000537e:	7442                	ld	s0,48(sp)
    80005380:	74a2                	ld	s1,40(sp)
    80005382:	6121                	addi	sp,sp,64
    80005384:	8082                	ret
	...

0000000080005390 <kernelvec>:
    80005390:	7111                	addi	sp,sp,-256
    80005392:	e006                	sd	ra,0(sp)
    80005394:	e40a                	sd	sp,8(sp)
    80005396:	e80e                	sd	gp,16(sp)
    80005398:	ec12                	sd	tp,24(sp)
    8000539a:	f016                	sd	t0,32(sp)
    8000539c:	f41a                	sd	t1,40(sp)
    8000539e:	f81e                	sd	t2,48(sp)
    800053a0:	fc22                	sd	s0,56(sp)
    800053a2:	e0a6                	sd	s1,64(sp)
    800053a4:	e4aa                	sd	a0,72(sp)
    800053a6:	e8ae                	sd	a1,80(sp)
    800053a8:	ecb2                	sd	a2,88(sp)
    800053aa:	f0b6                	sd	a3,96(sp)
    800053ac:	f4ba                	sd	a4,104(sp)
    800053ae:	f8be                	sd	a5,112(sp)
    800053b0:	fcc2                	sd	a6,120(sp)
    800053b2:	e146                	sd	a7,128(sp)
    800053b4:	e54a                	sd	s2,136(sp)
    800053b6:	e94e                	sd	s3,144(sp)
    800053b8:	ed52                	sd	s4,152(sp)
    800053ba:	f156                	sd	s5,160(sp)
    800053bc:	f55a                	sd	s6,168(sp)
    800053be:	f95e                	sd	s7,176(sp)
    800053c0:	fd62                	sd	s8,184(sp)
    800053c2:	e1e6                	sd	s9,192(sp)
    800053c4:	e5ea                	sd	s10,200(sp)
    800053c6:	e9ee                	sd	s11,208(sp)
    800053c8:	edf2                	sd	t3,216(sp)
    800053ca:	f1f6                	sd	t4,224(sp)
    800053cc:	f5fa                	sd	t5,232(sp)
    800053ce:	f9fe                	sd	t6,240(sp)
    800053d0:	b27fc0ef          	jal	ra,80001ef6 <kerneltrap>
    800053d4:	6082                	ld	ra,0(sp)
    800053d6:	6122                	ld	sp,8(sp)
    800053d8:	61c2                	ld	gp,16(sp)
    800053da:	7282                	ld	t0,32(sp)
    800053dc:	7322                	ld	t1,40(sp)
    800053de:	73c2                	ld	t2,48(sp)
    800053e0:	7462                	ld	s0,56(sp)
    800053e2:	6486                	ld	s1,64(sp)
    800053e4:	6526                	ld	a0,72(sp)
    800053e6:	65c6                	ld	a1,80(sp)
    800053e8:	6666                	ld	a2,88(sp)
    800053ea:	7686                	ld	a3,96(sp)
    800053ec:	7726                	ld	a4,104(sp)
    800053ee:	77c6                	ld	a5,112(sp)
    800053f0:	7866                	ld	a6,120(sp)
    800053f2:	688a                	ld	a7,128(sp)
    800053f4:	692a                	ld	s2,136(sp)
    800053f6:	69ca                	ld	s3,144(sp)
    800053f8:	6a6a                	ld	s4,152(sp)
    800053fa:	7a8a                	ld	s5,160(sp)
    800053fc:	7b2a                	ld	s6,168(sp)
    800053fe:	7bca                	ld	s7,176(sp)
    80005400:	7c6a                	ld	s8,184(sp)
    80005402:	6c8e                	ld	s9,192(sp)
    80005404:	6d2e                	ld	s10,200(sp)
    80005406:	6dce                	ld	s11,208(sp)
    80005408:	6e6e                	ld	t3,216(sp)
    8000540a:	7e8e                	ld	t4,224(sp)
    8000540c:	7f2e                	ld	t5,232(sp)
    8000540e:	7fce                	ld	t6,240(sp)
    80005410:	6111                	addi	sp,sp,256
    80005412:	10200073          	sret
    80005416:	00000013          	nop
    8000541a:	00000013          	nop
    8000541e:	0001                	nop

0000000080005420 <timervec>:
    80005420:	34051573          	csrrw	a0,mscratch,a0
    80005424:	e10c                	sd	a1,0(a0)
    80005426:	e510                	sd	a2,8(a0)
    80005428:	e914                	sd	a3,16(a0)
    8000542a:	6d0c                	ld	a1,24(a0)
    8000542c:	7110                	ld	a2,32(a0)
    8000542e:	6194                	ld	a3,0(a1)
    80005430:	96b2                	add	a3,a3,a2
    80005432:	e194                	sd	a3,0(a1)
    80005434:	4589                	li	a1,2
    80005436:	14459073          	csrw	sip,a1
    8000543a:	6914                	ld	a3,16(a0)
    8000543c:	6510                	ld	a2,8(a0)
    8000543e:	610c                	ld	a1,0(a0)
    80005440:	34051573          	csrrw	a0,mscratch,a0
    80005444:	30200073          	mret
	...

000000008000544a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000544a:	1141                	addi	sp,sp,-16
    8000544c:	e422                	sd	s0,8(sp)
    8000544e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005450:	0c0007b7          	lui	a5,0xc000
    80005454:	4705                	li	a4,1
    80005456:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005458:	c3d8                	sw	a4,4(a5)
}
    8000545a:	6422                	ld	s0,8(sp)
    8000545c:	0141                	addi	sp,sp,16
    8000545e:	8082                	ret

0000000080005460 <plicinithart>:

void
plicinithart(void)
{
    80005460:	1141                	addi	sp,sp,-16
    80005462:	e406                	sd	ra,8(sp)
    80005464:	e022                	sd	s0,0(sp)
    80005466:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005468:	ffffc097          	auipc	ra,0xffffc
    8000546c:	9a2080e7          	jalr	-1630(ra) # 80000e0a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005470:	0085171b          	slliw	a4,a0,0x8
    80005474:	0c0027b7          	lui	a5,0xc002
    80005478:	97ba                	add	a5,a5,a4
    8000547a:	40200713          	li	a4,1026
    8000547e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005482:	00d5151b          	slliw	a0,a0,0xd
    80005486:	0c2017b7          	lui	a5,0xc201
    8000548a:	953e                	add	a0,a0,a5
    8000548c:	00052023          	sw	zero,0(a0)
}
    80005490:	60a2                	ld	ra,8(sp)
    80005492:	6402                	ld	s0,0(sp)
    80005494:	0141                	addi	sp,sp,16
    80005496:	8082                	ret

0000000080005498 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005498:	1141                	addi	sp,sp,-16
    8000549a:	e406                	sd	ra,8(sp)
    8000549c:	e022                	sd	s0,0(sp)
    8000549e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054a0:	ffffc097          	auipc	ra,0xffffc
    800054a4:	96a080e7          	jalr	-1686(ra) # 80000e0a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800054a8:	00d5179b          	slliw	a5,a0,0xd
    800054ac:	0c201537          	lui	a0,0xc201
    800054b0:	953e                	add	a0,a0,a5
  return irq;
}
    800054b2:	4148                	lw	a0,4(a0)
    800054b4:	60a2                	ld	ra,8(sp)
    800054b6:	6402                	ld	s0,0(sp)
    800054b8:	0141                	addi	sp,sp,16
    800054ba:	8082                	ret

00000000800054bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800054bc:	1101                	addi	sp,sp,-32
    800054be:	ec06                	sd	ra,24(sp)
    800054c0:	e822                	sd	s0,16(sp)
    800054c2:	e426                	sd	s1,8(sp)
    800054c4:	1000                	addi	s0,sp,32
    800054c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800054c8:	ffffc097          	auipc	ra,0xffffc
    800054cc:	942080e7          	jalr	-1726(ra) # 80000e0a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800054d0:	00d5151b          	slliw	a0,a0,0xd
    800054d4:	0c2017b7          	lui	a5,0xc201
    800054d8:	97aa                	add	a5,a5,a0
    800054da:	c3c4                	sw	s1,4(a5)
}
    800054dc:	60e2                	ld	ra,24(sp)
    800054de:	6442                	ld	s0,16(sp)
    800054e0:	64a2                	ld	s1,8(sp)
    800054e2:	6105                	addi	sp,sp,32
    800054e4:	8082                	ret

00000000800054e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800054e6:	1141                	addi	sp,sp,-16
    800054e8:	e406                	sd	ra,8(sp)
    800054ea:	e022                	sd	s0,0(sp)
    800054ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800054ee:	479d                	li	a5,7
    800054f0:	06a7c963          	blt	a5,a0,80005562 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800054f4:	00018797          	auipc	a5,0x18
    800054f8:	b0c78793          	addi	a5,a5,-1268 # 8001d000 <disk>
    800054fc:	00a78733          	add	a4,a5,a0
    80005500:	6789                	lui	a5,0x2
    80005502:	97ba                	add	a5,a5,a4
    80005504:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005508:	e7ad                	bnez	a5,80005572 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000550a:	00451793          	slli	a5,a0,0x4
    8000550e:	0001a717          	auipc	a4,0x1a
    80005512:	af270713          	addi	a4,a4,-1294 # 8001f000 <disk+0x2000>
    80005516:	6314                	ld	a3,0(a4)
    80005518:	96be                	add	a3,a3,a5
    8000551a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000551e:	6314                	ld	a3,0(a4)
    80005520:	96be                	add	a3,a3,a5
    80005522:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005526:	6314                	ld	a3,0(a4)
    80005528:	96be                	add	a3,a3,a5
    8000552a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000552e:	6318                	ld	a4,0(a4)
    80005530:	97ba                	add	a5,a5,a4
    80005532:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005536:	00018797          	auipc	a5,0x18
    8000553a:	aca78793          	addi	a5,a5,-1334 # 8001d000 <disk>
    8000553e:	97aa                	add	a5,a5,a0
    80005540:	6509                	lui	a0,0x2
    80005542:	953e                	add	a0,a0,a5
    80005544:	4785                	li	a5,1
    80005546:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000554a:	0001a517          	auipc	a0,0x1a
    8000554e:	ace50513          	addi	a0,a0,-1330 # 8001f018 <disk+0x2018>
    80005552:	ffffc097          	auipc	ra,0xffffc
    80005556:	1c0080e7          	jalr	448(ra) # 80001712 <wakeup>
}
    8000555a:	60a2                	ld	ra,8(sp)
    8000555c:	6402                	ld	s0,0(sp)
    8000555e:	0141                	addi	sp,sp,16
    80005560:	8082                	ret
    panic("free_desc 1");
    80005562:	00003517          	auipc	a0,0x3
    80005566:	10e50513          	addi	a0,a0,270 # 80008670 <syscalls+0x330>
    8000556a:	00001097          	auipc	ra,0x1
    8000556e:	abc080e7          	jalr	-1348(ra) # 80006026 <panic>
    panic("free_desc 2");
    80005572:	00003517          	auipc	a0,0x3
    80005576:	10e50513          	addi	a0,a0,270 # 80008680 <syscalls+0x340>
    8000557a:	00001097          	auipc	ra,0x1
    8000557e:	aac080e7          	jalr	-1364(ra) # 80006026 <panic>

0000000080005582 <virtio_disk_init>:
{
    80005582:	1101                	addi	sp,sp,-32
    80005584:	ec06                	sd	ra,24(sp)
    80005586:	e822                	sd	s0,16(sp)
    80005588:	e426                	sd	s1,8(sp)
    8000558a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000558c:	00003597          	auipc	a1,0x3
    80005590:	10458593          	addi	a1,a1,260 # 80008690 <syscalls+0x350>
    80005594:	0001a517          	auipc	a0,0x1a
    80005598:	b9450513          	addi	a0,a0,-1132 # 8001f128 <disk+0x2128>
    8000559c:	00001097          	auipc	ra,0x1
    800055a0:	f44080e7          	jalr	-188(ra) # 800064e0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055a4:	100017b7          	lui	a5,0x10001
    800055a8:	4398                	lw	a4,0(a5)
    800055aa:	2701                	sext.w	a4,a4
    800055ac:	747277b7          	lui	a5,0x74727
    800055b0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055b4:	0ef71163          	bne	a4,a5,80005696 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800055b8:	100017b7          	lui	a5,0x10001
    800055bc:	43dc                	lw	a5,4(a5)
    800055be:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055c0:	4705                	li	a4,1
    800055c2:	0ce79a63          	bne	a5,a4,80005696 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055c6:	100017b7          	lui	a5,0x10001
    800055ca:	479c                	lw	a5,8(a5)
    800055cc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800055ce:	4709                	li	a4,2
    800055d0:	0ce79363          	bne	a5,a4,80005696 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800055d4:	100017b7          	lui	a5,0x10001
    800055d8:	47d8                	lw	a4,12(a5)
    800055da:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055dc:	554d47b7          	lui	a5,0x554d4
    800055e0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800055e4:	0af71963          	bne	a4,a5,80005696 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055e8:	100017b7          	lui	a5,0x10001
    800055ec:	4705                	li	a4,1
    800055ee:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055f0:	470d                	li	a4,3
    800055f2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055f4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800055f6:	c7ffe737          	lui	a4,0xc7ffe
    800055fa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd62ff>
    800055fe:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005600:	2701                	sext.w	a4,a4
    80005602:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005604:	472d                	li	a4,11
    80005606:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005608:	473d                	li	a4,15
    8000560a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000560c:	6705                	lui	a4,0x1
    8000560e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005610:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005614:	5bdc                	lw	a5,52(a5)
    80005616:	2781                	sext.w	a5,a5
  if(max == 0)
    80005618:	c7d9                	beqz	a5,800056a6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000561a:	471d                	li	a4,7
    8000561c:	08f77d63          	bgeu	a4,a5,800056b6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005620:	100014b7          	lui	s1,0x10001
    80005624:	47a1                	li	a5,8
    80005626:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005628:	6609                	lui	a2,0x2
    8000562a:	4581                	li	a1,0
    8000562c:	00018517          	auipc	a0,0x18
    80005630:	9d450513          	addi	a0,a0,-1580 # 8001d000 <disk>
    80005634:	ffffb097          	auipc	ra,0xffffb
    80005638:	b44080e7          	jalr	-1212(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000563c:	00018717          	auipc	a4,0x18
    80005640:	9c470713          	addi	a4,a4,-1596 # 8001d000 <disk>
    80005644:	00c75793          	srli	a5,a4,0xc
    80005648:	2781                	sext.w	a5,a5
    8000564a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000564c:	0001a797          	auipc	a5,0x1a
    80005650:	9b478793          	addi	a5,a5,-1612 # 8001f000 <disk+0x2000>
    80005654:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005656:	00018717          	auipc	a4,0x18
    8000565a:	a2a70713          	addi	a4,a4,-1494 # 8001d080 <disk+0x80>
    8000565e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005660:	00019717          	auipc	a4,0x19
    80005664:	9a070713          	addi	a4,a4,-1632 # 8001e000 <disk+0x1000>
    80005668:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000566a:	4705                	li	a4,1
    8000566c:	00e78c23          	sb	a4,24(a5)
    80005670:	00e78ca3          	sb	a4,25(a5)
    80005674:	00e78d23          	sb	a4,26(a5)
    80005678:	00e78da3          	sb	a4,27(a5)
    8000567c:	00e78e23          	sb	a4,28(a5)
    80005680:	00e78ea3          	sb	a4,29(a5)
    80005684:	00e78f23          	sb	a4,30(a5)
    80005688:	00e78fa3          	sb	a4,31(a5)
}
    8000568c:	60e2                	ld	ra,24(sp)
    8000568e:	6442                	ld	s0,16(sp)
    80005690:	64a2                	ld	s1,8(sp)
    80005692:	6105                	addi	sp,sp,32
    80005694:	8082                	ret
    panic("could not find virtio disk");
    80005696:	00003517          	auipc	a0,0x3
    8000569a:	00a50513          	addi	a0,a0,10 # 800086a0 <syscalls+0x360>
    8000569e:	00001097          	auipc	ra,0x1
    800056a2:	988080e7          	jalr	-1656(ra) # 80006026 <panic>
    panic("virtio disk has no queue 0");
    800056a6:	00003517          	auipc	a0,0x3
    800056aa:	01a50513          	addi	a0,a0,26 # 800086c0 <syscalls+0x380>
    800056ae:	00001097          	auipc	ra,0x1
    800056b2:	978080e7          	jalr	-1672(ra) # 80006026 <panic>
    panic("virtio disk max queue too short");
    800056b6:	00003517          	auipc	a0,0x3
    800056ba:	02a50513          	addi	a0,a0,42 # 800086e0 <syscalls+0x3a0>
    800056be:	00001097          	auipc	ra,0x1
    800056c2:	968080e7          	jalr	-1688(ra) # 80006026 <panic>

00000000800056c6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800056c6:	7159                	addi	sp,sp,-112
    800056c8:	f486                	sd	ra,104(sp)
    800056ca:	f0a2                	sd	s0,96(sp)
    800056cc:	eca6                	sd	s1,88(sp)
    800056ce:	e8ca                	sd	s2,80(sp)
    800056d0:	e4ce                	sd	s3,72(sp)
    800056d2:	e0d2                	sd	s4,64(sp)
    800056d4:	fc56                	sd	s5,56(sp)
    800056d6:	f85a                	sd	s6,48(sp)
    800056d8:	f45e                	sd	s7,40(sp)
    800056da:	f062                	sd	s8,32(sp)
    800056dc:	ec66                	sd	s9,24(sp)
    800056de:	e86a                	sd	s10,16(sp)
    800056e0:	1880                	addi	s0,sp,112
    800056e2:	892a                	mv	s2,a0
    800056e4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800056e6:	00c52c83          	lw	s9,12(a0)
    800056ea:	001c9c9b          	slliw	s9,s9,0x1
    800056ee:	1c82                	slli	s9,s9,0x20
    800056f0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800056f4:	0001a517          	auipc	a0,0x1a
    800056f8:	a3450513          	addi	a0,a0,-1484 # 8001f128 <disk+0x2128>
    800056fc:	00001097          	auipc	ra,0x1
    80005700:	e74080e7          	jalr	-396(ra) # 80006570 <acquire>
  for(int i = 0; i < 3; i++){
    80005704:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005706:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005708:	00018b97          	auipc	s7,0x18
    8000570c:	8f8b8b93          	addi	s7,s7,-1800 # 8001d000 <disk>
    80005710:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005712:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005714:	8a4e                	mv	s4,s3
    80005716:	a051                	j	8000579a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005718:	00fb86b3          	add	a3,s7,a5
    8000571c:	96da                	add	a3,a3,s6
    8000571e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005722:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005724:	0207c563          	bltz	a5,8000574e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005728:	2485                	addiw	s1,s1,1
    8000572a:	0711                	addi	a4,a4,4
    8000572c:	25548063          	beq	s1,s5,8000596c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005730:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005732:	0001a697          	auipc	a3,0x1a
    80005736:	8e668693          	addi	a3,a3,-1818 # 8001f018 <disk+0x2018>
    8000573a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000573c:	0006c583          	lbu	a1,0(a3)
    80005740:	fde1                	bnez	a1,80005718 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005742:	2785                	addiw	a5,a5,1
    80005744:	0685                	addi	a3,a3,1
    80005746:	ff879be3          	bne	a5,s8,8000573c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000574a:	57fd                	li	a5,-1
    8000574c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000574e:	02905a63          	blez	s1,80005782 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005752:	f9042503          	lw	a0,-112(s0)
    80005756:	00000097          	auipc	ra,0x0
    8000575a:	d90080e7          	jalr	-624(ra) # 800054e6 <free_desc>
      for(int j = 0; j < i; j++)
    8000575e:	4785                	li	a5,1
    80005760:	0297d163          	bge	a5,s1,80005782 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005764:	f9442503          	lw	a0,-108(s0)
    80005768:	00000097          	auipc	ra,0x0
    8000576c:	d7e080e7          	jalr	-642(ra) # 800054e6 <free_desc>
      for(int j = 0; j < i; j++)
    80005770:	4789                	li	a5,2
    80005772:	0097d863          	bge	a5,s1,80005782 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005776:	f9842503          	lw	a0,-104(s0)
    8000577a:	00000097          	auipc	ra,0x0
    8000577e:	d6c080e7          	jalr	-660(ra) # 800054e6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005782:	0001a597          	auipc	a1,0x1a
    80005786:	9a658593          	addi	a1,a1,-1626 # 8001f128 <disk+0x2128>
    8000578a:	0001a517          	auipc	a0,0x1a
    8000578e:	88e50513          	addi	a0,a0,-1906 # 8001f018 <disk+0x2018>
    80005792:	ffffc097          	auipc	ra,0xffffc
    80005796:	df4080e7          	jalr	-524(ra) # 80001586 <sleep>
  for(int i = 0; i < 3; i++){
    8000579a:	f9040713          	addi	a4,s0,-112
    8000579e:	84ce                	mv	s1,s3
    800057a0:	bf41                	j	80005730 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800057a2:	20058713          	addi	a4,a1,512
    800057a6:	00471693          	slli	a3,a4,0x4
    800057aa:	00018717          	auipc	a4,0x18
    800057ae:	85670713          	addi	a4,a4,-1962 # 8001d000 <disk>
    800057b2:	9736                	add	a4,a4,a3
    800057b4:	4685                	li	a3,1
    800057b6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800057ba:	20058713          	addi	a4,a1,512
    800057be:	00471693          	slli	a3,a4,0x4
    800057c2:	00018717          	auipc	a4,0x18
    800057c6:	83e70713          	addi	a4,a4,-1986 # 8001d000 <disk>
    800057ca:	9736                	add	a4,a4,a3
    800057cc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800057d0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800057d4:	7679                	lui	a2,0xffffe
    800057d6:	963e                	add	a2,a2,a5
    800057d8:	0001a697          	auipc	a3,0x1a
    800057dc:	82868693          	addi	a3,a3,-2008 # 8001f000 <disk+0x2000>
    800057e0:	6298                	ld	a4,0(a3)
    800057e2:	9732                	add	a4,a4,a2
    800057e4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800057e6:	6298                	ld	a4,0(a3)
    800057e8:	9732                	add	a4,a4,a2
    800057ea:	4541                	li	a0,16
    800057ec:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800057ee:	6298                	ld	a4,0(a3)
    800057f0:	9732                	add	a4,a4,a2
    800057f2:	4505                	li	a0,1
    800057f4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800057f8:	f9442703          	lw	a4,-108(s0)
    800057fc:	6288                	ld	a0,0(a3)
    800057fe:	962a                	add	a2,a2,a0
    80005800:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd5bae>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005804:	0712                	slli	a4,a4,0x4
    80005806:	6290                	ld	a2,0(a3)
    80005808:	963a                	add	a2,a2,a4
    8000580a:	05890513          	addi	a0,s2,88
    8000580e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005810:	6294                	ld	a3,0(a3)
    80005812:	96ba                	add	a3,a3,a4
    80005814:	40000613          	li	a2,1024
    80005818:	c690                	sw	a2,8(a3)
  if(write)
    8000581a:	140d0063          	beqz	s10,8000595a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000581e:	00019697          	auipc	a3,0x19
    80005822:	7e26b683          	ld	a3,2018(a3) # 8001f000 <disk+0x2000>
    80005826:	96ba                	add	a3,a3,a4
    80005828:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000582c:	00017817          	auipc	a6,0x17
    80005830:	7d480813          	addi	a6,a6,2004 # 8001d000 <disk>
    80005834:	00019517          	auipc	a0,0x19
    80005838:	7cc50513          	addi	a0,a0,1996 # 8001f000 <disk+0x2000>
    8000583c:	6114                	ld	a3,0(a0)
    8000583e:	96ba                	add	a3,a3,a4
    80005840:	00c6d603          	lhu	a2,12(a3)
    80005844:	00166613          	ori	a2,a2,1
    80005848:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000584c:	f9842683          	lw	a3,-104(s0)
    80005850:	6110                	ld	a2,0(a0)
    80005852:	9732                	add	a4,a4,a2
    80005854:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005858:	20058613          	addi	a2,a1,512
    8000585c:	0612                	slli	a2,a2,0x4
    8000585e:	9642                	add	a2,a2,a6
    80005860:	577d                	li	a4,-1
    80005862:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005866:	00469713          	slli	a4,a3,0x4
    8000586a:	6114                	ld	a3,0(a0)
    8000586c:	96ba                	add	a3,a3,a4
    8000586e:	03078793          	addi	a5,a5,48
    80005872:	97c2                	add	a5,a5,a6
    80005874:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005876:	611c                	ld	a5,0(a0)
    80005878:	97ba                	add	a5,a5,a4
    8000587a:	4685                	li	a3,1
    8000587c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000587e:	611c                	ld	a5,0(a0)
    80005880:	97ba                	add	a5,a5,a4
    80005882:	4809                	li	a6,2
    80005884:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005888:	611c                	ld	a5,0(a0)
    8000588a:	973e                	add	a4,a4,a5
    8000588c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005890:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005894:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005898:	6518                	ld	a4,8(a0)
    8000589a:	00275783          	lhu	a5,2(a4)
    8000589e:	8b9d                	andi	a5,a5,7
    800058a0:	0786                	slli	a5,a5,0x1
    800058a2:	97ba                	add	a5,a5,a4
    800058a4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800058a8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800058ac:	6518                	ld	a4,8(a0)
    800058ae:	00275783          	lhu	a5,2(a4)
    800058b2:	2785                	addiw	a5,a5,1
    800058b4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800058b8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800058bc:	100017b7          	lui	a5,0x10001
    800058c0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800058c4:	00492703          	lw	a4,4(s2)
    800058c8:	4785                	li	a5,1
    800058ca:	02f71163          	bne	a4,a5,800058ec <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800058ce:	0001a997          	auipc	s3,0x1a
    800058d2:	85a98993          	addi	s3,s3,-1958 # 8001f128 <disk+0x2128>
  while(b->disk == 1) {
    800058d6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800058d8:	85ce                	mv	a1,s3
    800058da:	854a                	mv	a0,s2
    800058dc:	ffffc097          	auipc	ra,0xffffc
    800058e0:	caa080e7          	jalr	-854(ra) # 80001586 <sleep>
  while(b->disk == 1) {
    800058e4:	00492783          	lw	a5,4(s2)
    800058e8:	fe9788e3          	beq	a5,s1,800058d8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800058ec:	f9042903          	lw	s2,-112(s0)
    800058f0:	20090793          	addi	a5,s2,512
    800058f4:	00479713          	slli	a4,a5,0x4
    800058f8:	00017797          	auipc	a5,0x17
    800058fc:	70878793          	addi	a5,a5,1800 # 8001d000 <disk>
    80005900:	97ba                	add	a5,a5,a4
    80005902:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005906:	00019997          	auipc	s3,0x19
    8000590a:	6fa98993          	addi	s3,s3,1786 # 8001f000 <disk+0x2000>
    8000590e:	00491713          	slli	a4,s2,0x4
    80005912:	0009b783          	ld	a5,0(s3)
    80005916:	97ba                	add	a5,a5,a4
    80005918:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000591c:	854a                	mv	a0,s2
    8000591e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005922:	00000097          	auipc	ra,0x0
    80005926:	bc4080e7          	jalr	-1084(ra) # 800054e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000592a:	8885                	andi	s1,s1,1
    8000592c:	f0ed                	bnez	s1,8000590e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000592e:	00019517          	auipc	a0,0x19
    80005932:	7fa50513          	addi	a0,a0,2042 # 8001f128 <disk+0x2128>
    80005936:	00001097          	auipc	ra,0x1
    8000593a:	cee080e7          	jalr	-786(ra) # 80006624 <release>
}
    8000593e:	70a6                	ld	ra,104(sp)
    80005940:	7406                	ld	s0,96(sp)
    80005942:	64e6                	ld	s1,88(sp)
    80005944:	6946                	ld	s2,80(sp)
    80005946:	69a6                	ld	s3,72(sp)
    80005948:	6a06                	ld	s4,64(sp)
    8000594a:	7ae2                	ld	s5,56(sp)
    8000594c:	7b42                	ld	s6,48(sp)
    8000594e:	7ba2                	ld	s7,40(sp)
    80005950:	7c02                	ld	s8,32(sp)
    80005952:	6ce2                	ld	s9,24(sp)
    80005954:	6d42                	ld	s10,16(sp)
    80005956:	6165                	addi	sp,sp,112
    80005958:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000595a:	00019697          	auipc	a3,0x19
    8000595e:	6a66b683          	ld	a3,1702(a3) # 8001f000 <disk+0x2000>
    80005962:	96ba                	add	a3,a3,a4
    80005964:	4609                	li	a2,2
    80005966:	00c69623          	sh	a2,12(a3)
    8000596a:	b5c9                	j	8000582c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000596c:	f9042583          	lw	a1,-112(s0)
    80005970:	20058793          	addi	a5,a1,512
    80005974:	0792                	slli	a5,a5,0x4
    80005976:	00017517          	auipc	a0,0x17
    8000597a:	73250513          	addi	a0,a0,1842 # 8001d0a8 <disk+0xa8>
    8000597e:	953e                	add	a0,a0,a5
  if(write)
    80005980:	e20d11e3          	bnez	s10,800057a2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005984:	20058713          	addi	a4,a1,512
    80005988:	00471693          	slli	a3,a4,0x4
    8000598c:	00017717          	auipc	a4,0x17
    80005990:	67470713          	addi	a4,a4,1652 # 8001d000 <disk>
    80005994:	9736                	add	a4,a4,a3
    80005996:	0a072423          	sw	zero,168(a4)
    8000599a:	b505                	j	800057ba <virtio_disk_rw+0xf4>

000000008000599c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000599c:	1101                	addi	sp,sp,-32
    8000599e:	ec06                	sd	ra,24(sp)
    800059a0:	e822                	sd	s0,16(sp)
    800059a2:	e426                	sd	s1,8(sp)
    800059a4:	e04a                	sd	s2,0(sp)
    800059a6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800059a8:	00019517          	auipc	a0,0x19
    800059ac:	78050513          	addi	a0,a0,1920 # 8001f128 <disk+0x2128>
    800059b0:	00001097          	auipc	ra,0x1
    800059b4:	bc0080e7          	jalr	-1088(ra) # 80006570 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059b8:	10001737          	lui	a4,0x10001
    800059bc:	533c                	lw	a5,96(a4)
    800059be:	8b8d                	andi	a5,a5,3
    800059c0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800059c2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800059c6:	00019797          	auipc	a5,0x19
    800059ca:	63a78793          	addi	a5,a5,1594 # 8001f000 <disk+0x2000>
    800059ce:	6b94                	ld	a3,16(a5)
    800059d0:	0207d703          	lhu	a4,32(a5)
    800059d4:	0026d783          	lhu	a5,2(a3)
    800059d8:	06f70163          	beq	a4,a5,80005a3a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059dc:	00017917          	auipc	s2,0x17
    800059e0:	62490913          	addi	s2,s2,1572 # 8001d000 <disk>
    800059e4:	00019497          	auipc	s1,0x19
    800059e8:	61c48493          	addi	s1,s1,1564 # 8001f000 <disk+0x2000>
    __sync_synchronize();
    800059ec:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059f0:	6898                	ld	a4,16(s1)
    800059f2:	0204d783          	lhu	a5,32(s1)
    800059f6:	8b9d                	andi	a5,a5,7
    800059f8:	078e                	slli	a5,a5,0x3
    800059fa:	97ba                	add	a5,a5,a4
    800059fc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800059fe:	20078713          	addi	a4,a5,512
    80005a02:	0712                	slli	a4,a4,0x4
    80005a04:	974a                	add	a4,a4,s2
    80005a06:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005a0a:	e731                	bnez	a4,80005a56 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a0c:	20078793          	addi	a5,a5,512
    80005a10:	0792                	slli	a5,a5,0x4
    80005a12:	97ca                	add	a5,a5,s2
    80005a14:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005a16:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a1a:	ffffc097          	auipc	ra,0xffffc
    80005a1e:	cf8080e7          	jalr	-776(ra) # 80001712 <wakeup>

    disk.used_idx += 1;
    80005a22:	0204d783          	lhu	a5,32(s1)
    80005a26:	2785                	addiw	a5,a5,1
    80005a28:	17c2                	slli	a5,a5,0x30
    80005a2a:	93c1                	srli	a5,a5,0x30
    80005a2c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a30:	6898                	ld	a4,16(s1)
    80005a32:	00275703          	lhu	a4,2(a4)
    80005a36:	faf71be3          	bne	a4,a5,800059ec <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005a3a:	00019517          	auipc	a0,0x19
    80005a3e:	6ee50513          	addi	a0,a0,1774 # 8001f128 <disk+0x2128>
    80005a42:	00001097          	auipc	ra,0x1
    80005a46:	be2080e7          	jalr	-1054(ra) # 80006624 <release>
}
    80005a4a:	60e2                	ld	ra,24(sp)
    80005a4c:	6442                	ld	s0,16(sp)
    80005a4e:	64a2                	ld	s1,8(sp)
    80005a50:	6902                	ld	s2,0(sp)
    80005a52:	6105                	addi	sp,sp,32
    80005a54:	8082                	ret
      panic("virtio_disk_intr status");
    80005a56:	00003517          	auipc	a0,0x3
    80005a5a:	caa50513          	addi	a0,a0,-854 # 80008700 <syscalls+0x3c0>
    80005a5e:	00000097          	auipc	ra,0x0
    80005a62:	5c8080e7          	jalr	1480(ra) # 80006026 <panic>

0000000080005a66 <vma_init>:
	struct vm_area_struct areas[NOFILE];
}  vma_table;

void
vma_init(void)
{
    80005a66:	1141                	addi	sp,sp,-16
    80005a68:	e406                	sd	ra,8(sp)
    80005a6a:	e022                	sd	s0,0(sp)
    80005a6c:	0800                	addi	s0,sp,16
	initlock(&vma_table.lock,"vma_table");
    80005a6e:	00003597          	auipc	a1,0x3
    80005a72:	caa58593          	addi	a1,a1,-854 # 80008718 <syscalls+0x3d8>
    80005a76:	0001a517          	auipc	a0,0x1a
    80005a7a:	58a50513          	addi	a0,a0,1418 # 80020000 <vma_table>
    80005a7e:	00001097          	auipc	ra,0x1
    80005a82:	a62080e7          	jalr	-1438(ra) # 800064e0 <initlock>
}
    80005a86:	60a2                	ld	ra,8(sp)
    80005a88:	6402                	ld	s0,0(sp)
    80005a8a:	0141                	addi	sp,sp,16
    80005a8c:	8082                	ret

0000000080005a8e <vma_alloc>:

struct vm_area_struct*
vma_alloc(void)
{
    80005a8e:	1101                	addi	sp,sp,-32
    80005a90:	ec06                	sd	ra,24(sp)
    80005a92:	e822                	sd	s0,16(sp)
    80005a94:	e426                	sd	s1,8(sp)
    80005a96:	1000                	addi	s0,sp,32
	struct vm_area_struct* vmap;
	acquire(&vma_table.lock);
    80005a98:	0001a517          	auipc	a0,0x1a
    80005a9c:	56850513          	addi	a0,a0,1384 # 80020000 <vma_table>
    80005aa0:	00001097          	auipc	ra,0x1
    80005aa4:	ad0080e7          	jalr	-1328(ra) # 80006570 <acquire>
	for(vmap=vma_table.areas;vmap<vma_table.areas+NOFILE;vmap++)
    80005aa8:	0001a497          	auipc	s1,0x1a
    80005aac:	57048493          	addi	s1,s1,1392 # 80020018 <vma_table+0x18>
    80005ab0:	0001a717          	auipc	a4,0x1a
    80005ab4:	76870713          	addi	a4,a4,1896 # 80020218 <vma_table+0x218>
	{
		if(vmap->file==0)
    80005ab8:	6c9c                	ld	a5,24(s1)
    80005aba:	c785                	beqz	a5,80005ae2 <vma_alloc+0x54>
	for(vmap=vma_table.areas;vmap<vma_table.areas+NOFILE;vmap++)
    80005abc:	02048493          	addi	s1,s1,32
    80005ac0:	fee49ce3          	bne	s1,a4,80005ab8 <vma_alloc+0x2a>
		{
			release(&vma_table.lock);
			return vmap;
		}
	}
	release(&vma_table.lock);
    80005ac4:	0001a517          	auipc	a0,0x1a
    80005ac8:	53c50513          	addi	a0,a0,1340 # 80020000 <vma_table>
    80005acc:	00001097          	auipc	ra,0x1
    80005ad0:	b58080e7          	jalr	-1192(ra) # 80006624 <release>
	return 0;
    80005ad4:	4481                	li	s1,0

}
    80005ad6:	8526                	mv	a0,s1
    80005ad8:	60e2                	ld	ra,24(sp)
    80005ada:	6442                	ld	s0,16(sp)
    80005adc:	64a2                	ld	s1,8(sp)
    80005ade:	6105                	addi	sp,sp,32
    80005ae0:	8082                	ret
			release(&vma_table.lock);
    80005ae2:	0001a517          	auipc	a0,0x1a
    80005ae6:	51e50513          	addi	a0,a0,1310 # 80020000 <vma_table>
    80005aea:	00001097          	auipc	ra,0x1
    80005aee:	b3a080e7          	jalr	-1222(ra) # 80006624 <release>
			return vmap;
    80005af2:	b7d5                	j	80005ad6 <vma_alloc+0x48>

0000000080005af4 <vma_free>:

void
vma_free(struct vm_area_struct* vmap)
{
    80005af4:	1141                	addi	sp,sp,-16
    80005af6:	e422                	sd	s0,8(sp)
    80005af8:	0800                	addi	s0,sp,16
	vmap->file =0;
    80005afa:	00053c23          	sd	zero,24(a0)
}
    80005afe:	6422                	ld	s0,8(sp)
    80005b00:	0141                	addi	sp,sp,16
    80005b02:	8082                	ret

0000000080005b04 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005b04:	1141                	addi	sp,sp,-16
    80005b06:	e422                	sd	s0,8(sp)
    80005b08:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b0a:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005b0e:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005b12:	0037979b          	slliw	a5,a5,0x3
    80005b16:	02004737          	lui	a4,0x2004
    80005b1a:	97ba                	add	a5,a5,a4
    80005b1c:	0200c737          	lui	a4,0x200c
    80005b20:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005b24:	000f4637          	lui	a2,0xf4
    80005b28:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005b2c:	95b2                	add	a1,a1,a2
    80005b2e:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005b30:	00269713          	slli	a4,a3,0x2
    80005b34:	9736                	add	a4,a4,a3
    80005b36:	00371693          	slli	a3,a4,0x3
    80005b3a:	0001a717          	auipc	a4,0x1a
    80005b3e:	6e670713          	addi	a4,a4,1766 # 80020220 <timer_scratch>
    80005b42:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005b44:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005b46:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005b48:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005b4c:	00000797          	auipc	a5,0x0
    80005b50:	8d478793          	addi	a5,a5,-1836 # 80005420 <timervec>
    80005b54:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b58:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b5c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b60:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b64:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005b68:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b6c:	30479073          	csrw	mie,a5
}
    80005b70:	6422                	ld	s0,8(sp)
    80005b72:	0141                	addi	sp,sp,16
    80005b74:	8082                	ret

0000000080005b76 <start>:
{
    80005b76:	1141                	addi	sp,sp,-16
    80005b78:	e406                	sd	ra,8(sp)
    80005b7a:	e022                	sd	s0,0(sp)
    80005b7c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b7e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005b82:	7779                	lui	a4,0xffffe
    80005b84:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd639f>
    80005b88:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b8a:	6705                	lui	a4,0x1
    80005b8c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b90:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b92:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b96:	ffffa797          	auipc	a5,0xffffa
    80005b9a:	79078793          	addi	a5,a5,1936 # 80000326 <main>
    80005b9e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005ba2:	4781                	li	a5,0
    80005ba4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005ba8:	67c1                	lui	a5,0x10
    80005baa:	17fd                	addi	a5,a5,-1
    80005bac:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005bb0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005bb4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005bb8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005bbc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005bc0:	57fd                	li	a5,-1
    80005bc2:	83a9                	srli	a5,a5,0xa
    80005bc4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005bc8:	47bd                	li	a5,15
    80005bca:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005bce:	00000097          	auipc	ra,0x0
    80005bd2:	f36080e7          	jalr	-202(ra) # 80005b04 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005bd6:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005bda:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005bdc:	823e                	mv	tp,a5
  asm volatile("mret");
    80005bde:	30200073          	mret
}
    80005be2:	60a2                	ld	ra,8(sp)
    80005be4:	6402                	ld	s0,0(sp)
    80005be6:	0141                	addi	sp,sp,16
    80005be8:	8082                	ret

0000000080005bea <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005bea:	715d                	addi	sp,sp,-80
    80005bec:	e486                	sd	ra,72(sp)
    80005bee:	e0a2                	sd	s0,64(sp)
    80005bf0:	fc26                	sd	s1,56(sp)
    80005bf2:	f84a                	sd	s2,48(sp)
    80005bf4:	f44e                	sd	s3,40(sp)
    80005bf6:	f052                	sd	s4,32(sp)
    80005bf8:	ec56                	sd	s5,24(sp)
    80005bfa:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005bfc:	04c05663          	blez	a2,80005c48 <consolewrite+0x5e>
    80005c00:	8a2a                	mv	s4,a0
    80005c02:	84ae                	mv	s1,a1
    80005c04:	89b2                	mv	s3,a2
    80005c06:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005c08:	5afd                	li	s5,-1
    80005c0a:	4685                	li	a3,1
    80005c0c:	8626                	mv	a2,s1
    80005c0e:	85d2                	mv	a1,s4
    80005c10:	fbf40513          	addi	a0,s0,-65
    80005c14:	ffffc097          	auipc	ra,0xffffc
    80005c18:	e00080e7          	jalr	-512(ra) # 80001a14 <either_copyin>
    80005c1c:	01550c63          	beq	a0,s5,80005c34 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005c20:	fbf44503          	lbu	a0,-65(s0)
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	78e080e7          	jalr	1934(ra) # 800063b2 <uartputc>
  for(i = 0; i < n; i++){
    80005c2c:	2905                	addiw	s2,s2,1
    80005c2e:	0485                	addi	s1,s1,1
    80005c30:	fd299de3          	bne	s3,s2,80005c0a <consolewrite+0x20>
  }

  return i;
}
    80005c34:	854a                	mv	a0,s2
    80005c36:	60a6                	ld	ra,72(sp)
    80005c38:	6406                	ld	s0,64(sp)
    80005c3a:	74e2                	ld	s1,56(sp)
    80005c3c:	7942                	ld	s2,48(sp)
    80005c3e:	79a2                	ld	s3,40(sp)
    80005c40:	7a02                	ld	s4,32(sp)
    80005c42:	6ae2                	ld	s5,24(sp)
    80005c44:	6161                	addi	sp,sp,80
    80005c46:	8082                	ret
  for(i = 0; i < n; i++){
    80005c48:	4901                	li	s2,0
    80005c4a:	b7ed                	j	80005c34 <consolewrite+0x4a>

0000000080005c4c <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005c4c:	7119                	addi	sp,sp,-128
    80005c4e:	fc86                	sd	ra,120(sp)
    80005c50:	f8a2                	sd	s0,112(sp)
    80005c52:	f4a6                	sd	s1,104(sp)
    80005c54:	f0ca                	sd	s2,96(sp)
    80005c56:	ecce                	sd	s3,88(sp)
    80005c58:	e8d2                	sd	s4,80(sp)
    80005c5a:	e4d6                	sd	s5,72(sp)
    80005c5c:	e0da                	sd	s6,64(sp)
    80005c5e:	fc5e                	sd	s7,56(sp)
    80005c60:	f862                	sd	s8,48(sp)
    80005c62:	f466                	sd	s9,40(sp)
    80005c64:	f06a                	sd	s10,32(sp)
    80005c66:	ec6e                	sd	s11,24(sp)
    80005c68:	0100                	addi	s0,sp,128
    80005c6a:	8b2a                	mv	s6,a0
    80005c6c:	8aae                	mv	s5,a1
    80005c6e:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005c70:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005c74:	00022517          	auipc	a0,0x22
    80005c78:	6ec50513          	addi	a0,a0,1772 # 80028360 <cons>
    80005c7c:	00001097          	auipc	ra,0x1
    80005c80:	8f4080e7          	jalr	-1804(ra) # 80006570 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c84:	00022497          	auipc	s1,0x22
    80005c88:	6dc48493          	addi	s1,s1,1756 # 80028360 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c8c:	89a6                	mv	s3,s1
    80005c8e:	00022917          	auipc	s2,0x22
    80005c92:	76a90913          	addi	s2,s2,1898 # 800283f8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005c96:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c98:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005c9a:	4da9                	li	s11,10
  while(n > 0){
    80005c9c:	07405863          	blez	s4,80005d0c <consoleread+0xc0>
    while(cons.r == cons.w){
    80005ca0:	0984a783          	lw	a5,152(s1)
    80005ca4:	09c4a703          	lw	a4,156(s1)
    80005ca8:	02f71463          	bne	a4,a5,80005cd0 <consoleread+0x84>
      if(myproc()->killed){
    80005cac:	ffffb097          	auipc	ra,0xffffb
    80005cb0:	18a080e7          	jalr	394(ra) # 80000e36 <myproc>
    80005cb4:	551c                	lw	a5,40(a0)
    80005cb6:	e7b5                	bnez	a5,80005d22 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005cb8:	85ce                	mv	a1,s3
    80005cba:	854a                	mv	a0,s2
    80005cbc:	ffffc097          	auipc	ra,0xffffc
    80005cc0:	8ca080e7          	jalr	-1846(ra) # 80001586 <sleep>
    while(cons.r == cons.w){
    80005cc4:	0984a783          	lw	a5,152(s1)
    80005cc8:	09c4a703          	lw	a4,156(s1)
    80005ccc:	fef700e3          	beq	a4,a5,80005cac <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005cd0:	0017871b          	addiw	a4,a5,1
    80005cd4:	08e4ac23          	sw	a4,152(s1)
    80005cd8:	07f7f713          	andi	a4,a5,127
    80005cdc:	9726                	add	a4,a4,s1
    80005cde:	01874703          	lbu	a4,24(a4)
    80005ce2:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005ce6:	079c0663          	beq	s8,s9,80005d52 <consoleread+0x106>
    cbuf = c;
    80005cea:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005cee:	4685                	li	a3,1
    80005cf0:	f8f40613          	addi	a2,s0,-113
    80005cf4:	85d6                	mv	a1,s5
    80005cf6:	855a                	mv	a0,s6
    80005cf8:	ffffc097          	auipc	ra,0xffffc
    80005cfc:	cc6080e7          	jalr	-826(ra) # 800019be <either_copyout>
    80005d00:	01a50663          	beq	a0,s10,80005d0c <consoleread+0xc0>
    dst++;
    80005d04:	0a85                	addi	s5,s5,1
    --n;
    80005d06:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005d08:	f9bc1ae3          	bne	s8,s11,80005c9c <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005d0c:	00022517          	auipc	a0,0x22
    80005d10:	65450513          	addi	a0,a0,1620 # 80028360 <cons>
    80005d14:	00001097          	auipc	ra,0x1
    80005d18:	910080e7          	jalr	-1776(ra) # 80006624 <release>

  return target - n;
    80005d1c:	414b853b          	subw	a0,s7,s4
    80005d20:	a811                	j	80005d34 <consoleread+0xe8>
        release(&cons.lock);
    80005d22:	00022517          	auipc	a0,0x22
    80005d26:	63e50513          	addi	a0,a0,1598 # 80028360 <cons>
    80005d2a:	00001097          	auipc	ra,0x1
    80005d2e:	8fa080e7          	jalr	-1798(ra) # 80006624 <release>
        return -1;
    80005d32:	557d                	li	a0,-1
}
    80005d34:	70e6                	ld	ra,120(sp)
    80005d36:	7446                	ld	s0,112(sp)
    80005d38:	74a6                	ld	s1,104(sp)
    80005d3a:	7906                	ld	s2,96(sp)
    80005d3c:	69e6                	ld	s3,88(sp)
    80005d3e:	6a46                	ld	s4,80(sp)
    80005d40:	6aa6                	ld	s5,72(sp)
    80005d42:	6b06                	ld	s6,64(sp)
    80005d44:	7be2                	ld	s7,56(sp)
    80005d46:	7c42                	ld	s8,48(sp)
    80005d48:	7ca2                	ld	s9,40(sp)
    80005d4a:	7d02                	ld	s10,32(sp)
    80005d4c:	6de2                	ld	s11,24(sp)
    80005d4e:	6109                	addi	sp,sp,128
    80005d50:	8082                	ret
      if(n < target){
    80005d52:	000a071b          	sext.w	a4,s4
    80005d56:	fb777be3          	bgeu	a4,s7,80005d0c <consoleread+0xc0>
        cons.r--;
    80005d5a:	00022717          	auipc	a4,0x22
    80005d5e:	68f72f23          	sw	a5,1694(a4) # 800283f8 <cons+0x98>
    80005d62:	b76d                	j	80005d0c <consoleread+0xc0>

0000000080005d64 <consputc>:
{
    80005d64:	1141                	addi	sp,sp,-16
    80005d66:	e406                	sd	ra,8(sp)
    80005d68:	e022                	sd	s0,0(sp)
    80005d6a:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005d6c:	10000793          	li	a5,256
    80005d70:	00f50a63          	beq	a0,a5,80005d84 <consputc+0x20>
    uartputc_sync(c);
    80005d74:	00000097          	auipc	ra,0x0
    80005d78:	564080e7          	jalr	1380(ra) # 800062d8 <uartputc_sync>
}
    80005d7c:	60a2                	ld	ra,8(sp)
    80005d7e:	6402                	ld	s0,0(sp)
    80005d80:	0141                	addi	sp,sp,16
    80005d82:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d84:	4521                	li	a0,8
    80005d86:	00000097          	auipc	ra,0x0
    80005d8a:	552080e7          	jalr	1362(ra) # 800062d8 <uartputc_sync>
    80005d8e:	02000513          	li	a0,32
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	546080e7          	jalr	1350(ra) # 800062d8 <uartputc_sync>
    80005d9a:	4521                	li	a0,8
    80005d9c:	00000097          	auipc	ra,0x0
    80005da0:	53c080e7          	jalr	1340(ra) # 800062d8 <uartputc_sync>
    80005da4:	bfe1                	j	80005d7c <consputc+0x18>

0000000080005da6 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005da6:	1101                	addi	sp,sp,-32
    80005da8:	ec06                	sd	ra,24(sp)
    80005daa:	e822                	sd	s0,16(sp)
    80005dac:	e426                	sd	s1,8(sp)
    80005dae:	e04a                	sd	s2,0(sp)
    80005db0:	1000                	addi	s0,sp,32
    80005db2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005db4:	00022517          	auipc	a0,0x22
    80005db8:	5ac50513          	addi	a0,a0,1452 # 80028360 <cons>
    80005dbc:	00000097          	auipc	ra,0x0
    80005dc0:	7b4080e7          	jalr	1972(ra) # 80006570 <acquire>

  switch(c){
    80005dc4:	47d5                	li	a5,21
    80005dc6:	0af48663          	beq	s1,a5,80005e72 <consoleintr+0xcc>
    80005dca:	0297ca63          	blt	a5,s1,80005dfe <consoleintr+0x58>
    80005dce:	47a1                	li	a5,8
    80005dd0:	0ef48763          	beq	s1,a5,80005ebe <consoleintr+0x118>
    80005dd4:	47c1                	li	a5,16
    80005dd6:	10f49a63          	bne	s1,a5,80005eea <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005dda:	ffffc097          	auipc	ra,0xffffc
    80005dde:	c90080e7          	jalr	-880(ra) # 80001a6a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005de2:	00022517          	auipc	a0,0x22
    80005de6:	57e50513          	addi	a0,a0,1406 # 80028360 <cons>
    80005dea:	00001097          	auipc	ra,0x1
    80005dee:	83a080e7          	jalr	-1990(ra) # 80006624 <release>
}
    80005df2:	60e2                	ld	ra,24(sp)
    80005df4:	6442                	ld	s0,16(sp)
    80005df6:	64a2                	ld	s1,8(sp)
    80005df8:	6902                	ld	s2,0(sp)
    80005dfa:	6105                	addi	sp,sp,32
    80005dfc:	8082                	ret
  switch(c){
    80005dfe:	07f00793          	li	a5,127
    80005e02:	0af48e63          	beq	s1,a5,80005ebe <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005e06:	00022717          	auipc	a4,0x22
    80005e0a:	55a70713          	addi	a4,a4,1370 # 80028360 <cons>
    80005e0e:	0a072783          	lw	a5,160(a4)
    80005e12:	09872703          	lw	a4,152(a4)
    80005e16:	9f99                	subw	a5,a5,a4
    80005e18:	07f00713          	li	a4,127
    80005e1c:	fcf763e3          	bltu	a4,a5,80005de2 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005e20:	47b5                	li	a5,13
    80005e22:	0cf48763          	beq	s1,a5,80005ef0 <consoleintr+0x14a>
      consputc(c);
    80005e26:	8526                	mv	a0,s1
    80005e28:	00000097          	auipc	ra,0x0
    80005e2c:	f3c080e7          	jalr	-196(ra) # 80005d64 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e30:	00022797          	auipc	a5,0x22
    80005e34:	53078793          	addi	a5,a5,1328 # 80028360 <cons>
    80005e38:	0a07a703          	lw	a4,160(a5)
    80005e3c:	0017069b          	addiw	a3,a4,1
    80005e40:	0006861b          	sext.w	a2,a3
    80005e44:	0ad7a023          	sw	a3,160(a5)
    80005e48:	07f77713          	andi	a4,a4,127
    80005e4c:	97ba                	add	a5,a5,a4
    80005e4e:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005e52:	47a9                	li	a5,10
    80005e54:	0cf48563          	beq	s1,a5,80005f1e <consoleintr+0x178>
    80005e58:	4791                	li	a5,4
    80005e5a:	0cf48263          	beq	s1,a5,80005f1e <consoleintr+0x178>
    80005e5e:	00022797          	auipc	a5,0x22
    80005e62:	59a7a783          	lw	a5,1434(a5) # 800283f8 <cons+0x98>
    80005e66:	0807879b          	addiw	a5,a5,128
    80005e6a:	f6f61ce3          	bne	a2,a5,80005de2 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e6e:	863e                	mv	a2,a5
    80005e70:	a07d                	j	80005f1e <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005e72:	00022717          	auipc	a4,0x22
    80005e76:	4ee70713          	addi	a4,a4,1262 # 80028360 <cons>
    80005e7a:	0a072783          	lw	a5,160(a4)
    80005e7e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005e82:	00022497          	auipc	s1,0x22
    80005e86:	4de48493          	addi	s1,s1,1246 # 80028360 <cons>
    while(cons.e != cons.w &&
    80005e8a:	4929                	li	s2,10
    80005e8c:	f4f70be3          	beq	a4,a5,80005de2 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005e90:	37fd                	addiw	a5,a5,-1
    80005e92:	07f7f713          	andi	a4,a5,127
    80005e96:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e98:	01874703          	lbu	a4,24(a4)
    80005e9c:	f52703e3          	beq	a4,s2,80005de2 <consoleintr+0x3c>
      cons.e--;
    80005ea0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ea4:	10000513          	li	a0,256
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	ebc080e7          	jalr	-324(ra) # 80005d64 <consputc>
    while(cons.e != cons.w &&
    80005eb0:	0a04a783          	lw	a5,160(s1)
    80005eb4:	09c4a703          	lw	a4,156(s1)
    80005eb8:	fcf71ce3          	bne	a4,a5,80005e90 <consoleintr+0xea>
    80005ebc:	b71d                	j	80005de2 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ebe:	00022717          	auipc	a4,0x22
    80005ec2:	4a270713          	addi	a4,a4,1186 # 80028360 <cons>
    80005ec6:	0a072783          	lw	a5,160(a4)
    80005eca:	09c72703          	lw	a4,156(a4)
    80005ece:	f0f70ae3          	beq	a4,a5,80005de2 <consoleintr+0x3c>
      cons.e--;
    80005ed2:	37fd                	addiw	a5,a5,-1
    80005ed4:	00022717          	auipc	a4,0x22
    80005ed8:	52f72623          	sw	a5,1324(a4) # 80028400 <cons+0xa0>
      consputc(BACKSPACE);
    80005edc:	10000513          	li	a0,256
    80005ee0:	00000097          	auipc	ra,0x0
    80005ee4:	e84080e7          	jalr	-380(ra) # 80005d64 <consputc>
    80005ee8:	bded                	j	80005de2 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005eea:	ee048ce3          	beqz	s1,80005de2 <consoleintr+0x3c>
    80005eee:	bf21                	j	80005e06 <consoleintr+0x60>
      consputc(c);
    80005ef0:	4529                	li	a0,10
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	e72080e7          	jalr	-398(ra) # 80005d64 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005efa:	00022797          	auipc	a5,0x22
    80005efe:	46678793          	addi	a5,a5,1126 # 80028360 <cons>
    80005f02:	0a07a703          	lw	a4,160(a5)
    80005f06:	0017069b          	addiw	a3,a4,1
    80005f0a:	0006861b          	sext.w	a2,a3
    80005f0e:	0ad7a023          	sw	a3,160(a5)
    80005f12:	07f77713          	andi	a4,a4,127
    80005f16:	97ba                	add	a5,a5,a4
    80005f18:	4729                	li	a4,10
    80005f1a:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005f1e:	00022797          	auipc	a5,0x22
    80005f22:	4cc7af23          	sw	a2,1246(a5) # 800283fc <cons+0x9c>
        wakeup(&cons.r);
    80005f26:	00022517          	auipc	a0,0x22
    80005f2a:	4d250513          	addi	a0,a0,1234 # 800283f8 <cons+0x98>
    80005f2e:	ffffb097          	auipc	ra,0xffffb
    80005f32:	7e4080e7          	jalr	2020(ra) # 80001712 <wakeup>
    80005f36:	b575                	j	80005de2 <consoleintr+0x3c>

0000000080005f38 <consoleinit>:

void
consoleinit(void)
{
    80005f38:	1141                	addi	sp,sp,-16
    80005f3a:	e406                	sd	ra,8(sp)
    80005f3c:	e022                	sd	s0,0(sp)
    80005f3e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f40:	00002597          	auipc	a1,0x2
    80005f44:	7e858593          	addi	a1,a1,2024 # 80008728 <syscalls+0x3e8>
    80005f48:	00022517          	auipc	a0,0x22
    80005f4c:	41850513          	addi	a0,a0,1048 # 80028360 <cons>
    80005f50:	00000097          	auipc	ra,0x0
    80005f54:	590080e7          	jalr	1424(ra) # 800064e0 <initlock>

  uartinit();
    80005f58:	00000097          	auipc	ra,0x0
    80005f5c:	330080e7          	jalr	816(ra) # 80006288 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005f60:	00015797          	auipc	a5,0x15
    80005f64:	16878793          	addi	a5,a5,360 # 8001b0c8 <devsw>
    80005f68:	00000717          	auipc	a4,0x0
    80005f6c:	ce470713          	addi	a4,a4,-796 # 80005c4c <consoleread>
    80005f70:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f72:	00000717          	auipc	a4,0x0
    80005f76:	c7870713          	addi	a4,a4,-904 # 80005bea <consolewrite>
    80005f7a:	ef98                	sd	a4,24(a5)
}
    80005f7c:	60a2                	ld	ra,8(sp)
    80005f7e:	6402                	ld	s0,0(sp)
    80005f80:	0141                	addi	sp,sp,16
    80005f82:	8082                	ret

0000000080005f84 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f84:	7179                	addi	sp,sp,-48
    80005f86:	f406                	sd	ra,40(sp)
    80005f88:	f022                	sd	s0,32(sp)
    80005f8a:	ec26                	sd	s1,24(sp)
    80005f8c:	e84a                	sd	s2,16(sp)
    80005f8e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f90:	c219                	beqz	a2,80005f96 <printint+0x12>
    80005f92:	08054663          	bltz	a0,8000601e <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005f96:	2501                	sext.w	a0,a0
    80005f98:	4881                	li	a7,0
    80005f9a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005f9e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005fa0:	2581                	sext.w	a1,a1
    80005fa2:	00002617          	auipc	a2,0x2
    80005fa6:	7b660613          	addi	a2,a2,1974 # 80008758 <digits>
    80005faa:	883a                	mv	a6,a4
    80005fac:	2705                	addiw	a4,a4,1
    80005fae:	02b577bb          	remuw	a5,a0,a1
    80005fb2:	1782                	slli	a5,a5,0x20
    80005fb4:	9381                	srli	a5,a5,0x20
    80005fb6:	97b2                	add	a5,a5,a2
    80005fb8:	0007c783          	lbu	a5,0(a5)
    80005fbc:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005fc0:	0005079b          	sext.w	a5,a0
    80005fc4:	02b5553b          	divuw	a0,a0,a1
    80005fc8:	0685                	addi	a3,a3,1
    80005fca:	feb7f0e3          	bgeu	a5,a1,80005faa <printint+0x26>

  if(sign)
    80005fce:	00088b63          	beqz	a7,80005fe4 <printint+0x60>
    buf[i++] = '-';
    80005fd2:	fe040793          	addi	a5,s0,-32
    80005fd6:	973e                	add	a4,a4,a5
    80005fd8:	02d00793          	li	a5,45
    80005fdc:	fef70823          	sb	a5,-16(a4)
    80005fe0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005fe4:	02e05763          	blez	a4,80006012 <printint+0x8e>
    80005fe8:	fd040793          	addi	a5,s0,-48
    80005fec:	00e784b3          	add	s1,a5,a4
    80005ff0:	fff78913          	addi	s2,a5,-1
    80005ff4:	993a                	add	s2,s2,a4
    80005ff6:	377d                	addiw	a4,a4,-1
    80005ff8:	1702                	slli	a4,a4,0x20
    80005ffa:	9301                	srli	a4,a4,0x20
    80005ffc:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006000:	fff4c503          	lbu	a0,-1(s1)
    80006004:	00000097          	auipc	ra,0x0
    80006008:	d60080e7          	jalr	-672(ra) # 80005d64 <consputc>
  while(--i >= 0)
    8000600c:	14fd                	addi	s1,s1,-1
    8000600e:	ff2499e3          	bne	s1,s2,80006000 <printint+0x7c>
}
    80006012:	70a2                	ld	ra,40(sp)
    80006014:	7402                	ld	s0,32(sp)
    80006016:	64e2                	ld	s1,24(sp)
    80006018:	6942                	ld	s2,16(sp)
    8000601a:	6145                	addi	sp,sp,48
    8000601c:	8082                	ret
    x = -xx;
    8000601e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006022:	4885                	li	a7,1
    x = -xx;
    80006024:	bf9d                	j	80005f9a <printint+0x16>

0000000080006026 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006026:	1101                	addi	sp,sp,-32
    80006028:	ec06                	sd	ra,24(sp)
    8000602a:	e822                	sd	s0,16(sp)
    8000602c:	e426                	sd	s1,8(sp)
    8000602e:	1000                	addi	s0,sp,32
    80006030:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006032:	00022797          	auipc	a5,0x22
    80006036:	3e07a723          	sw	zero,1006(a5) # 80028420 <pr+0x18>
  printf("panic: ");
    8000603a:	00002517          	auipc	a0,0x2
    8000603e:	6f650513          	addi	a0,a0,1782 # 80008730 <syscalls+0x3f0>
    80006042:	00000097          	auipc	ra,0x0
    80006046:	02e080e7          	jalr	46(ra) # 80006070 <printf>
  printf(s);
    8000604a:	8526                	mv	a0,s1
    8000604c:	00000097          	auipc	ra,0x0
    80006050:	024080e7          	jalr	36(ra) # 80006070 <printf>
  printf("\n");
    80006054:	00002517          	auipc	a0,0x2
    80006058:	ff450513          	addi	a0,a0,-12 # 80008048 <etext+0x48>
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	014080e7          	jalr	20(ra) # 80006070 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006064:	4785                	li	a5,1
    80006066:	00003717          	auipc	a4,0x3
    8000606a:	faf72b23          	sw	a5,-74(a4) # 8000901c <panicked>
  for(;;)
    8000606e:	a001                	j	8000606e <panic+0x48>

0000000080006070 <printf>:
{
    80006070:	7131                	addi	sp,sp,-192
    80006072:	fc86                	sd	ra,120(sp)
    80006074:	f8a2                	sd	s0,112(sp)
    80006076:	f4a6                	sd	s1,104(sp)
    80006078:	f0ca                	sd	s2,96(sp)
    8000607a:	ecce                	sd	s3,88(sp)
    8000607c:	e8d2                	sd	s4,80(sp)
    8000607e:	e4d6                	sd	s5,72(sp)
    80006080:	e0da                	sd	s6,64(sp)
    80006082:	fc5e                	sd	s7,56(sp)
    80006084:	f862                	sd	s8,48(sp)
    80006086:	f466                	sd	s9,40(sp)
    80006088:	f06a                	sd	s10,32(sp)
    8000608a:	ec6e                	sd	s11,24(sp)
    8000608c:	0100                	addi	s0,sp,128
    8000608e:	8a2a                	mv	s4,a0
    80006090:	e40c                	sd	a1,8(s0)
    80006092:	e810                	sd	a2,16(s0)
    80006094:	ec14                	sd	a3,24(s0)
    80006096:	f018                	sd	a4,32(s0)
    80006098:	f41c                	sd	a5,40(s0)
    8000609a:	03043823          	sd	a6,48(s0)
    8000609e:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800060a2:	00022d97          	auipc	s11,0x22
    800060a6:	37edad83          	lw	s11,894(s11) # 80028420 <pr+0x18>
  if(locking)
    800060aa:	020d9b63          	bnez	s11,800060e0 <printf+0x70>
  if (fmt == 0)
    800060ae:	040a0263          	beqz	s4,800060f2 <printf+0x82>
  va_start(ap, fmt);
    800060b2:	00840793          	addi	a5,s0,8
    800060b6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060ba:	000a4503          	lbu	a0,0(s4)
    800060be:	16050263          	beqz	a0,80006222 <printf+0x1b2>
    800060c2:	4481                	li	s1,0
    if(c != '%'){
    800060c4:	02500a93          	li	s5,37
    switch(c){
    800060c8:	07000b13          	li	s6,112
  consputc('x');
    800060cc:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060ce:	00002b97          	auipc	s7,0x2
    800060d2:	68ab8b93          	addi	s7,s7,1674 # 80008758 <digits>
    switch(c){
    800060d6:	07300c93          	li	s9,115
    800060da:	06400c13          	li	s8,100
    800060de:	a82d                	j	80006118 <printf+0xa8>
    acquire(&pr.lock);
    800060e0:	00022517          	auipc	a0,0x22
    800060e4:	32850513          	addi	a0,a0,808 # 80028408 <pr>
    800060e8:	00000097          	auipc	ra,0x0
    800060ec:	488080e7          	jalr	1160(ra) # 80006570 <acquire>
    800060f0:	bf7d                	j	800060ae <printf+0x3e>
    panic("null fmt");
    800060f2:	00002517          	auipc	a0,0x2
    800060f6:	64e50513          	addi	a0,a0,1614 # 80008740 <syscalls+0x400>
    800060fa:	00000097          	auipc	ra,0x0
    800060fe:	f2c080e7          	jalr	-212(ra) # 80006026 <panic>
      consputc(c);
    80006102:	00000097          	auipc	ra,0x0
    80006106:	c62080e7          	jalr	-926(ra) # 80005d64 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000610a:	2485                	addiw	s1,s1,1
    8000610c:	009a07b3          	add	a5,s4,s1
    80006110:	0007c503          	lbu	a0,0(a5)
    80006114:	10050763          	beqz	a0,80006222 <printf+0x1b2>
    if(c != '%'){
    80006118:	ff5515e3          	bne	a0,s5,80006102 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000611c:	2485                	addiw	s1,s1,1
    8000611e:	009a07b3          	add	a5,s4,s1
    80006122:	0007c783          	lbu	a5,0(a5)
    80006126:	0007891b          	sext.w	s2,a5
    if(c == 0)
    8000612a:	cfe5                	beqz	a5,80006222 <printf+0x1b2>
    switch(c){
    8000612c:	05678a63          	beq	a5,s6,80006180 <printf+0x110>
    80006130:	02fb7663          	bgeu	s6,a5,8000615c <printf+0xec>
    80006134:	09978963          	beq	a5,s9,800061c6 <printf+0x156>
    80006138:	07800713          	li	a4,120
    8000613c:	0ce79863          	bne	a5,a4,8000620c <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80006140:	f8843783          	ld	a5,-120(s0)
    80006144:	00878713          	addi	a4,a5,8
    80006148:	f8e43423          	sd	a4,-120(s0)
    8000614c:	4605                	li	a2,1
    8000614e:	85ea                	mv	a1,s10
    80006150:	4388                	lw	a0,0(a5)
    80006152:	00000097          	auipc	ra,0x0
    80006156:	e32080e7          	jalr	-462(ra) # 80005f84 <printint>
      break;
    8000615a:	bf45                	j	8000610a <printf+0x9a>
    switch(c){
    8000615c:	0b578263          	beq	a5,s5,80006200 <printf+0x190>
    80006160:	0b879663          	bne	a5,s8,8000620c <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006164:	f8843783          	ld	a5,-120(s0)
    80006168:	00878713          	addi	a4,a5,8
    8000616c:	f8e43423          	sd	a4,-120(s0)
    80006170:	4605                	li	a2,1
    80006172:	45a9                	li	a1,10
    80006174:	4388                	lw	a0,0(a5)
    80006176:	00000097          	auipc	ra,0x0
    8000617a:	e0e080e7          	jalr	-498(ra) # 80005f84 <printint>
      break;
    8000617e:	b771                	j	8000610a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006180:	f8843783          	ld	a5,-120(s0)
    80006184:	00878713          	addi	a4,a5,8
    80006188:	f8e43423          	sd	a4,-120(s0)
    8000618c:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006190:	03000513          	li	a0,48
    80006194:	00000097          	auipc	ra,0x0
    80006198:	bd0080e7          	jalr	-1072(ra) # 80005d64 <consputc>
  consputc('x');
    8000619c:	07800513          	li	a0,120
    800061a0:	00000097          	auipc	ra,0x0
    800061a4:	bc4080e7          	jalr	-1084(ra) # 80005d64 <consputc>
    800061a8:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800061aa:	03c9d793          	srli	a5,s3,0x3c
    800061ae:	97de                	add	a5,a5,s7
    800061b0:	0007c503          	lbu	a0,0(a5)
    800061b4:	00000097          	auipc	ra,0x0
    800061b8:	bb0080e7          	jalr	-1104(ra) # 80005d64 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800061bc:	0992                	slli	s3,s3,0x4
    800061be:	397d                	addiw	s2,s2,-1
    800061c0:	fe0915e3          	bnez	s2,800061aa <printf+0x13a>
    800061c4:	b799                	j	8000610a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800061c6:	f8843783          	ld	a5,-120(s0)
    800061ca:	00878713          	addi	a4,a5,8
    800061ce:	f8e43423          	sd	a4,-120(s0)
    800061d2:	0007b903          	ld	s2,0(a5)
    800061d6:	00090e63          	beqz	s2,800061f2 <printf+0x182>
      for(; *s; s++)
    800061da:	00094503          	lbu	a0,0(s2)
    800061de:	d515                	beqz	a0,8000610a <printf+0x9a>
        consputc(*s);
    800061e0:	00000097          	auipc	ra,0x0
    800061e4:	b84080e7          	jalr	-1148(ra) # 80005d64 <consputc>
      for(; *s; s++)
    800061e8:	0905                	addi	s2,s2,1
    800061ea:	00094503          	lbu	a0,0(s2)
    800061ee:	f96d                	bnez	a0,800061e0 <printf+0x170>
    800061f0:	bf29                	j	8000610a <printf+0x9a>
        s = "(null)";
    800061f2:	00002917          	auipc	s2,0x2
    800061f6:	54690913          	addi	s2,s2,1350 # 80008738 <syscalls+0x3f8>
      for(; *s; s++)
    800061fa:	02800513          	li	a0,40
    800061fe:	b7cd                	j	800061e0 <printf+0x170>
      consputc('%');
    80006200:	8556                	mv	a0,s5
    80006202:	00000097          	auipc	ra,0x0
    80006206:	b62080e7          	jalr	-1182(ra) # 80005d64 <consputc>
      break;
    8000620a:	b701                	j	8000610a <printf+0x9a>
      consputc('%');
    8000620c:	8556                	mv	a0,s5
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	b56080e7          	jalr	-1194(ra) # 80005d64 <consputc>
      consputc(c);
    80006216:	854a                	mv	a0,s2
    80006218:	00000097          	auipc	ra,0x0
    8000621c:	b4c080e7          	jalr	-1204(ra) # 80005d64 <consputc>
      break;
    80006220:	b5ed                	j	8000610a <printf+0x9a>
  if(locking)
    80006222:	020d9163          	bnez	s11,80006244 <printf+0x1d4>
}
    80006226:	70e6                	ld	ra,120(sp)
    80006228:	7446                	ld	s0,112(sp)
    8000622a:	74a6                	ld	s1,104(sp)
    8000622c:	7906                	ld	s2,96(sp)
    8000622e:	69e6                	ld	s3,88(sp)
    80006230:	6a46                	ld	s4,80(sp)
    80006232:	6aa6                	ld	s5,72(sp)
    80006234:	6b06                	ld	s6,64(sp)
    80006236:	7be2                	ld	s7,56(sp)
    80006238:	7c42                	ld	s8,48(sp)
    8000623a:	7ca2                	ld	s9,40(sp)
    8000623c:	7d02                	ld	s10,32(sp)
    8000623e:	6de2                	ld	s11,24(sp)
    80006240:	6129                	addi	sp,sp,192
    80006242:	8082                	ret
    release(&pr.lock);
    80006244:	00022517          	auipc	a0,0x22
    80006248:	1c450513          	addi	a0,a0,452 # 80028408 <pr>
    8000624c:	00000097          	auipc	ra,0x0
    80006250:	3d8080e7          	jalr	984(ra) # 80006624 <release>
}
    80006254:	bfc9                	j	80006226 <printf+0x1b6>

0000000080006256 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006256:	1101                	addi	sp,sp,-32
    80006258:	ec06                	sd	ra,24(sp)
    8000625a:	e822                	sd	s0,16(sp)
    8000625c:	e426                	sd	s1,8(sp)
    8000625e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006260:	00022497          	auipc	s1,0x22
    80006264:	1a848493          	addi	s1,s1,424 # 80028408 <pr>
    80006268:	00002597          	auipc	a1,0x2
    8000626c:	4e858593          	addi	a1,a1,1256 # 80008750 <syscalls+0x410>
    80006270:	8526                	mv	a0,s1
    80006272:	00000097          	auipc	ra,0x0
    80006276:	26e080e7          	jalr	622(ra) # 800064e0 <initlock>
  pr.locking = 1;
    8000627a:	4785                	li	a5,1
    8000627c:	cc9c                	sw	a5,24(s1)
}
    8000627e:	60e2                	ld	ra,24(sp)
    80006280:	6442                	ld	s0,16(sp)
    80006282:	64a2                	ld	s1,8(sp)
    80006284:	6105                	addi	sp,sp,32
    80006286:	8082                	ret

0000000080006288 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006288:	1141                	addi	sp,sp,-16
    8000628a:	e406                	sd	ra,8(sp)
    8000628c:	e022                	sd	s0,0(sp)
    8000628e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006290:	100007b7          	lui	a5,0x10000
    80006294:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006298:	f8000713          	li	a4,-128
    8000629c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800062a0:	470d                	li	a4,3
    800062a2:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800062a6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800062aa:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800062ae:	469d                	li	a3,7
    800062b0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800062b4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800062b8:	00002597          	auipc	a1,0x2
    800062bc:	4b858593          	addi	a1,a1,1208 # 80008770 <digits+0x18>
    800062c0:	00022517          	auipc	a0,0x22
    800062c4:	16850513          	addi	a0,a0,360 # 80028428 <uart_tx_lock>
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	218080e7          	jalr	536(ra) # 800064e0 <initlock>
}
    800062d0:	60a2                	ld	ra,8(sp)
    800062d2:	6402                	ld	s0,0(sp)
    800062d4:	0141                	addi	sp,sp,16
    800062d6:	8082                	ret

00000000800062d8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800062d8:	1101                	addi	sp,sp,-32
    800062da:	ec06                	sd	ra,24(sp)
    800062dc:	e822                	sd	s0,16(sp)
    800062de:	e426                	sd	s1,8(sp)
    800062e0:	1000                	addi	s0,sp,32
    800062e2:	84aa                	mv	s1,a0
  push_off();
    800062e4:	00000097          	auipc	ra,0x0
    800062e8:	240080e7          	jalr	576(ra) # 80006524 <push_off>

  if(panicked){
    800062ec:	00003797          	auipc	a5,0x3
    800062f0:	d307a783          	lw	a5,-720(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062f4:	10000737          	lui	a4,0x10000
  if(panicked){
    800062f8:	c391                	beqz	a5,800062fc <uartputc_sync+0x24>
    for(;;)
    800062fa:	a001                	j	800062fa <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062fc:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006300:	0ff7f793          	andi	a5,a5,255
    80006304:	0207f793          	andi	a5,a5,32
    80006308:	dbf5                	beqz	a5,800062fc <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000630a:	0ff4f793          	andi	a5,s1,255
    8000630e:	10000737          	lui	a4,0x10000
    80006312:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006316:	00000097          	auipc	ra,0x0
    8000631a:	2ae080e7          	jalr	686(ra) # 800065c4 <pop_off>
}
    8000631e:	60e2                	ld	ra,24(sp)
    80006320:	6442                	ld	s0,16(sp)
    80006322:	64a2                	ld	s1,8(sp)
    80006324:	6105                	addi	sp,sp,32
    80006326:	8082                	ret

0000000080006328 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006328:	00003717          	auipc	a4,0x3
    8000632c:	cf873703          	ld	a4,-776(a4) # 80009020 <uart_tx_r>
    80006330:	00003797          	auipc	a5,0x3
    80006334:	cf87b783          	ld	a5,-776(a5) # 80009028 <uart_tx_w>
    80006338:	06e78c63          	beq	a5,a4,800063b0 <uartstart+0x88>
{
    8000633c:	7139                	addi	sp,sp,-64
    8000633e:	fc06                	sd	ra,56(sp)
    80006340:	f822                	sd	s0,48(sp)
    80006342:	f426                	sd	s1,40(sp)
    80006344:	f04a                	sd	s2,32(sp)
    80006346:	ec4e                	sd	s3,24(sp)
    80006348:	e852                	sd	s4,16(sp)
    8000634a:	e456                	sd	s5,8(sp)
    8000634c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000634e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006352:	00022a17          	auipc	s4,0x22
    80006356:	0d6a0a13          	addi	s4,s4,214 # 80028428 <uart_tx_lock>
    uart_tx_r += 1;
    8000635a:	00003497          	auipc	s1,0x3
    8000635e:	cc648493          	addi	s1,s1,-826 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006362:	00003997          	auipc	s3,0x3
    80006366:	cc698993          	addi	s3,s3,-826 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000636a:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000636e:	0ff7f793          	andi	a5,a5,255
    80006372:	0207f793          	andi	a5,a5,32
    80006376:	c785                	beqz	a5,8000639e <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006378:	01f77793          	andi	a5,a4,31
    8000637c:	97d2                	add	a5,a5,s4
    8000637e:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006382:	0705                	addi	a4,a4,1
    80006384:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006386:	8526                	mv	a0,s1
    80006388:	ffffb097          	auipc	ra,0xffffb
    8000638c:	38a080e7          	jalr	906(ra) # 80001712 <wakeup>
    
    WriteReg(THR, c);
    80006390:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006394:	6098                	ld	a4,0(s1)
    80006396:	0009b783          	ld	a5,0(s3)
    8000639a:	fce798e3          	bne	a5,a4,8000636a <uartstart+0x42>
  }
}
    8000639e:	70e2                	ld	ra,56(sp)
    800063a0:	7442                	ld	s0,48(sp)
    800063a2:	74a2                	ld	s1,40(sp)
    800063a4:	7902                	ld	s2,32(sp)
    800063a6:	69e2                	ld	s3,24(sp)
    800063a8:	6a42                	ld	s4,16(sp)
    800063aa:	6aa2                	ld	s5,8(sp)
    800063ac:	6121                	addi	sp,sp,64
    800063ae:	8082                	ret
    800063b0:	8082                	ret

00000000800063b2 <uartputc>:
{
    800063b2:	7179                	addi	sp,sp,-48
    800063b4:	f406                	sd	ra,40(sp)
    800063b6:	f022                	sd	s0,32(sp)
    800063b8:	ec26                	sd	s1,24(sp)
    800063ba:	e84a                	sd	s2,16(sp)
    800063bc:	e44e                	sd	s3,8(sp)
    800063be:	e052                	sd	s4,0(sp)
    800063c0:	1800                	addi	s0,sp,48
    800063c2:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800063c4:	00022517          	auipc	a0,0x22
    800063c8:	06450513          	addi	a0,a0,100 # 80028428 <uart_tx_lock>
    800063cc:	00000097          	auipc	ra,0x0
    800063d0:	1a4080e7          	jalr	420(ra) # 80006570 <acquire>
  if(panicked){
    800063d4:	00003797          	auipc	a5,0x3
    800063d8:	c487a783          	lw	a5,-952(a5) # 8000901c <panicked>
    800063dc:	c391                	beqz	a5,800063e0 <uartputc+0x2e>
    for(;;)
    800063de:	a001                	j	800063de <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063e0:	00003797          	auipc	a5,0x3
    800063e4:	c487b783          	ld	a5,-952(a5) # 80009028 <uart_tx_w>
    800063e8:	00003717          	auipc	a4,0x3
    800063ec:	c3873703          	ld	a4,-968(a4) # 80009020 <uart_tx_r>
    800063f0:	02070713          	addi	a4,a4,32
    800063f4:	02f71b63          	bne	a4,a5,8000642a <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800063f8:	00022a17          	auipc	s4,0x22
    800063fc:	030a0a13          	addi	s4,s4,48 # 80028428 <uart_tx_lock>
    80006400:	00003497          	auipc	s1,0x3
    80006404:	c2048493          	addi	s1,s1,-992 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006408:	00003917          	auipc	s2,0x3
    8000640c:	c2090913          	addi	s2,s2,-992 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006410:	85d2                	mv	a1,s4
    80006412:	8526                	mv	a0,s1
    80006414:	ffffb097          	auipc	ra,0xffffb
    80006418:	172080e7          	jalr	370(ra) # 80001586 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000641c:	00093783          	ld	a5,0(s2)
    80006420:	6098                	ld	a4,0(s1)
    80006422:	02070713          	addi	a4,a4,32
    80006426:	fef705e3          	beq	a4,a5,80006410 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000642a:	00022497          	auipc	s1,0x22
    8000642e:	ffe48493          	addi	s1,s1,-2 # 80028428 <uart_tx_lock>
    80006432:	01f7f713          	andi	a4,a5,31
    80006436:	9726                	add	a4,a4,s1
    80006438:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000643c:	0785                	addi	a5,a5,1
    8000643e:	00003717          	auipc	a4,0x3
    80006442:	bef73523          	sd	a5,-1046(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006446:	00000097          	auipc	ra,0x0
    8000644a:	ee2080e7          	jalr	-286(ra) # 80006328 <uartstart>
      release(&uart_tx_lock);
    8000644e:	8526                	mv	a0,s1
    80006450:	00000097          	auipc	ra,0x0
    80006454:	1d4080e7          	jalr	468(ra) # 80006624 <release>
}
    80006458:	70a2                	ld	ra,40(sp)
    8000645a:	7402                	ld	s0,32(sp)
    8000645c:	64e2                	ld	s1,24(sp)
    8000645e:	6942                	ld	s2,16(sp)
    80006460:	69a2                	ld	s3,8(sp)
    80006462:	6a02                	ld	s4,0(sp)
    80006464:	6145                	addi	sp,sp,48
    80006466:	8082                	ret

0000000080006468 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006468:	1141                	addi	sp,sp,-16
    8000646a:	e422                	sd	s0,8(sp)
    8000646c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000646e:	100007b7          	lui	a5,0x10000
    80006472:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006476:	8b85                	andi	a5,a5,1
    80006478:	cb91                	beqz	a5,8000648c <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000647a:	100007b7          	lui	a5,0x10000
    8000647e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006482:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006486:	6422                	ld	s0,8(sp)
    80006488:	0141                	addi	sp,sp,16
    8000648a:	8082                	ret
    return -1;
    8000648c:	557d                	li	a0,-1
    8000648e:	bfe5                	j	80006486 <uartgetc+0x1e>

0000000080006490 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006490:	1101                	addi	sp,sp,-32
    80006492:	ec06                	sd	ra,24(sp)
    80006494:	e822                	sd	s0,16(sp)
    80006496:	e426                	sd	s1,8(sp)
    80006498:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000649a:	54fd                	li	s1,-1
    int c = uartgetc();
    8000649c:	00000097          	auipc	ra,0x0
    800064a0:	fcc080e7          	jalr	-52(ra) # 80006468 <uartgetc>
    if(c == -1)
    800064a4:	00950763          	beq	a0,s1,800064b2 <uartintr+0x22>
      break;
    consoleintr(c);
    800064a8:	00000097          	auipc	ra,0x0
    800064ac:	8fe080e7          	jalr	-1794(ra) # 80005da6 <consoleintr>
  while(1){
    800064b0:	b7f5                	j	8000649c <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800064b2:	00022497          	auipc	s1,0x22
    800064b6:	f7648493          	addi	s1,s1,-138 # 80028428 <uart_tx_lock>
    800064ba:	8526                	mv	a0,s1
    800064bc:	00000097          	auipc	ra,0x0
    800064c0:	0b4080e7          	jalr	180(ra) # 80006570 <acquire>
  uartstart();
    800064c4:	00000097          	auipc	ra,0x0
    800064c8:	e64080e7          	jalr	-412(ra) # 80006328 <uartstart>
  release(&uart_tx_lock);
    800064cc:	8526                	mv	a0,s1
    800064ce:	00000097          	auipc	ra,0x0
    800064d2:	156080e7          	jalr	342(ra) # 80006624 <release>
}
    800064d6:	60e2                	ld	ra,24(sp)
    800064d8:	6442                	ld	s0,16(sp)
    800064da:	64a2                	ld	s1,8(sp)
    800064dc:	6105                	addi	sp,sp,32
    800064de:	8082                	ret

00000000800064e0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800064e0:	1141                	addi	sp,sp,-16
    800064e2:	e422                	sd	s0,8(sp)
    800064e4:	0800                	addi	s0,sp,16
  lk->name = name;
    800064e6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800064e8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800064ec:	00053823          	sd	zero,16(a0)
}
    800064f0:	6422                	ld	s0,8(sp)
    800064f2:	0141                	addi	sp,sp,16
    800064f4:	8082                	ret

00000000800064f6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800064f6:	411c                	lw	a5,0(a0)
    800064f8:	e399                	bnez	a5,800064fe <holding+0x8>
    800064fa:	4501                	li	a0,0
  return r;
}
    800064fc:	8082                	ret
{
    800064fe:	1101                	addi	sp,sp,-32
    80006500:	ec06                	sd	ra,24(sp)
    80006502:	e822                	sd	s0,16(sp)
    80006504:	e426                	sd	s1,8(sp)
    80006506:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006508:	6904                	ld	s1,16(a0)
    8000650a:	ffffb097          	auipc	ra,0xffffb
    8000650e:	910080e7          	jalr	-1776(ra) # 80000e1a <mycpu>
    80006512:	40a48533          	sub	a0,s1,a0
    80006516:	00153513          	seqz	a0,a0
}
    8000651a:	60e2                	ld	ra,24(sp)
    8000651c:	6442                	ld	s0,16(sp)
    8000651e:	64a2                	ld	s1,8(sp)
    80006520:	6105                	addi	sp,sp,32
    80006522:	8082                	ret

0000000080006524 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006524:	1101                	addi	sp,sp,-32
    80006526:	ec06                	sd	ra,24(sp)
    80006528:	e822                	sd	s0,16(sp)
    8000652a:	e426                	sd	s1,8(sp)
    8000652c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000652e:	100024f3          	csrr	s1,sstatus
    80006532:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006536:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006538:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000653c:	ffffb097          	auipc	ra,0xffffb
    80006540:	8de080e7          	jalr	-1826(ra) # 80000e1a <mycpu>
    80006544:	5d3c                	lw	a5,120(a0)
    80006546:	cf89                	beqz	a5,80006560 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006548:	ffffb097          	auipc	ra,0xffffb
    8000654c:	8d2080e7          	jalr	-1838(ra) # 80000e1a <mycpu>
    80006550:	5d3c                	lw	a5,120(a0)
    80006552:	2785                	addiw	a5,a5,1
    80006554:	dd3c                	sw	a5,120(a0)
}
    80006556:	60e2                	ld	ra,24(sp)
    80006558:	6442                	ld	s0,16(sp)
    8000655a:	64a2                	ld	s1,8(sp)
    8000655c:	6105                	addi	sp,sp,32
    8000655e:	8082                	ret
    mycpu()->intena = old;
    80006560:	ffffb097          	auipc	ra,0xffffb
    80006564:	8ba080e7          	jalr	-1862(ra) # 80000e1a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006568:	8085                	srli	s1,s1,0x1
    8000656a:	8885                	andi	s1,s1,1
    8000656c:	dd64                	sw	s1,124(a0)
    8000656e:	bfe9                	j	80006548 <push_off+0x24>

0000000080006570 <acquire>:
{
    80006570:	1101                	addi	sp,sp,-32
    80006572:	ec06                	sd	ra,24(sp)
    80006574:	e822                	sd	s0,16(sp)
    80006576:	e426                	sd	s1,8(sp)
    80006578:	1000                	addi	s0,sp,32
    8000657a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000657c:	00000097          	auipc	ra,0x0
    80006580:	fa8080e7          	jalr	-88(ra) # 80006524 <push_off>
  if(holding(lk))
    80006584:	8526                	mv	a0,s1
    80006586:	00000097          	auipc	ra,0x0
    8000658a:	f70080e7          	jalr	-144(ra) # 800064f6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000658e:	4705                	li	a4,1
  if(holding(lk))
    80006590:	e115                	bnez	a0,800065b4 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006592:	87ba                	mv	a5,a4
    80006594:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006598:	2781                	sext.w	a5,a5
    8000659a:	ffe5                	bnez	a5,80006592 <acquire+0x22>
  __sync_synchronize();
    8000659c:	0ff0000f          	fence
  lk->cpu = mycpu();
    800065a0:	ffffb097          	auipc	ra,0xffffb
    800065a4:	87a080e7          	jalr	-1926(ra) # 80000e1a <mycpu>
    800065a8:	e888                	sd	a0,16(s1)
}
    800065aa:	60e2                	ld	ra,24(sp)
    800065ac:	6442                	ld	s0,16(sp)
    800065ae:	64a2                	ld	s1,8(sp)
    800065b0:	6105                	addi	sp,sp,32
    800065b2:	8082                	ret
    panic("acquire");
    800065b4:	00002517          	auipc	a0,0x2
    800065b8:	1c450513          	addi	a0,a0,452 # 80008778 <digits+0x20>
    800065bc:	00000097          	auipc	ra,0x0
    800065c0:	a6a080e7          	jalr	-1430(ra) # 80006026 <panic>

00000000800065c4 <pop_off>:

void
pop_off(void)
{
    800065c4:	1141                	addi	sp,sp,-16
    800065c6:	e406                	sd	ra,8(sp)
    800065c8:	e022                	sd	s0,0(sp)
    800065ca:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800065cc:	ffffb097          	auipc	ra,0xffffb
    800065d0:	84e080e7          	jalr	-1970(ra) # 80000e1a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065d4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800065d8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800065da:	e78d                	bnez	a5,80006604 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800065dc:	5d3c                	lw	a5,120(a0)
    800065de:	02f05b63          	blez	a5,80006614 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800065e2:	37fd                	addiw	a5,a5,-1
    800065e4:	0007871b          	sext.w	a4,a5
    800065e8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800065ea:	eb09                	bnez	a4,800065fc <pop_off+0x38>
    800065ec:	5d7c                	lw	a5,124(a0)
    800065ee:	c799                	beqz	a5,800065fc <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065f0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800065f4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065f8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800065fc:	60a2                	ld	ra,8(sp)
    800065fe:	6402                	ld	s0,0(sp)
    80006600:	0141                	addi	sp,sp,16
    80006602:	8082                	ret
    panic("pop_off - interruptible");
    80006604:	00002517          	auipc	a0,0x2
    80006608:	17c50513          	addi	a0,a0,380 # 80008780 <digits+0x28>
    8000660c:	00000097          	auipc	ra,0x0
    80006610:	a1a080e7          	jalr	-1510(ra) # 80006026 <panic>
    panic("pop_off");
    80006614:	00002517          	auipc	a0,0x2
    80006618:	18450513          	addi	a0,a0,388 # 80008798 <digits+0x40>
    8000661c:	00000097          	auipc	ra,0x0
    80006620:	a0a080e7          	jalr	-1526(ra) # 80006026 <panic>

0000000080006624 <release>:
{
    80006624:	1101                	addi	sp,sp,-32
    80006626:	ec06                	sd	ra,24(sp)
    80006628:	e822                	sd	s0,16(sp)
    8000662a:	e426                	sd	s1,8(sp)
    8000662c:	1000                	addi	s0,sp,32
    8000662e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006630:	00000097          	auipc	ra,0x0
    80006634:	ec6080e7          	jalr	-314(ra) # 800064f6 <holding>
    80006638:	c115                	beqz	a0,8000665c <release+0x38>
  lk->cpu = 0;
    8000663a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000663e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006642:	0f50000f          	fence	iorw,ow
    80006646:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000664a:	00000097          	auipc	ra,0x0
    8000664e:	f7a080e7          	jalr	-134(ra) # 800065c4 <pop_off>
}
    80006652:	60e2                	ld	ra,24(sp)
    80006654:	6442                	ld	s0,16(sp)
    80006656:	64a2                	ld	s1,8(sp)
    80006658:	6105                	addi	sp,sp,32
    8000665a:	8082                	ret
    panic("release");
    8000665c:	00002517          	auipc	a0,0x2
    80006660:	14450513          	addi	a0,a0,324 # 800087a0 <digits+0x48>
    80006664:	00000097          	auipc	ra,0x0
    80006668:	9c2080e7          	jalr	-1598(ra) # 80006026 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
