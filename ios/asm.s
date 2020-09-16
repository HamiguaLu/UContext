
//x86_64位体系
#if __x86_64__

.globl _setmcontext
_setmcontext:
	movq	16(%rdi), %rsi
	movq	24(%rdi), %rdx
	movq	32(%rdi), %rcx
	movq	40(%rdi), %r8
	movq	48(%rdi), %r9
	movq	56(%rdi), %rax
	movq	64(%rdi), %rbx
	movq	72(%rdi), %rbp
	movq	80(%rdi), %r10
	movq	88(%rdi), %r11
	movq	96(%rdi), %r12
	movq	104(%rdi), %r13
	movq	112(%rdi), %r14
	movq	120(%rdi), %r15
	movq	184(%rdi), %rsp
	pushq	160(%rdi)	/* new %eip */
	movq	8(%rdi), %rdi
	ret

.globl _getmcontext
_getmcontext:
	movq	%rdi, 8(%rdi)
	movq	%rsi, 16(%rdi)
	movq	%rdx, 24(%rdi)
	movq	%rcx, 32(%rdi)
	movq	%r8, 40(%rdi)
	movq	%r9, 48(%rdi)
	movq	$1, 56(%rdi)	/* %rax */
	movq	%rbx, 64(%rdi)
	movq	%rbp, 72(%rdi)
	movq	%r10, 80(%rdi)
	movq	%r11, 88(%rdi)
	movq	%r12, 96(%rdi)
	movq	%r13, 104(%rdi)
	movq	%r14, 112(%rdi)
	movq	%r15, 120(%rdi)

	movq	(%rsp), %rcx	/* %rip */
	movq	%rcx, 160(%rdi)
	leaq	8(%rsp), %rcx	/* %rsp */
	movq	%rcx, 184(%rdi)
	
	movq	32(%rdi), %rcx	/* restore %rcx */
	movq	$0, %rax
	ret
	
//arm64体系
#elif __arm64__

#define REGSZ					8
#define R0_OFFSET				8
#define SP_OFFSET				(R0_OFFSET + 31* REGSZ)
#define PC_OFFSET				(R0_OFFSET + 32* REGSZ)
#define PSTATE_OFFSET			(R0_OFFSET + 33 * REGSZ)


.globl _setmcontext
_setmcontext:
	/* restore GPRs */
	ldp	x18, x19, [x0, #R0_OFFSET + (18 * REGSZ)]
	ldp	x20, x21, [x0, #R0_OFFSET + (20 * REGSZ)]
	ldp	x22, x23, [x0, #R0_OFFSET + (22 * REGSZ)]
	ldp	x24, x25, [x0, #R0_OFFSET + (24 * REGSZ)]
	ldp	x26, x27, [x0, #R0_OFFSET + (26 * REGSZ)]
	ldp	x28, x29, [x0, #R0_OFFSET + (28 * REGSZ)]
	ldr	x30,      [x0, #R0_OFFSET + (30 * REGSZ)]

	/* save current stack pointer */
	ldr	x2, [x0, #SP_OFFSET]
	mov	sp, x2

	/* TODO: SIMD / FPRs */

	/* save current program counter in link register */
	ldr	x16, [x0, #PC_OFFSET]

	/* restore args */
	ldp	x2, x3, [x0, #R0_OFFSET + (2 * REGSZ)]
	ldp	x4, x5, [x0, #R0_OFFSET + (4 * REGSZ)]
	ldp	x6, x7, [x0, #R0_OFFSET + (6 * REGSZ)]
	ldp	x0, x1, [x0, #R0_OFFSET + (0 * REGSZ)]

	/* jump to new PC */
	br	x16

.globl _getmcontext
_getmcontext:
	str	xzr, [x0, #R0_OFFSET + (0 * REGSZ)]

	/* save GPRs */
	stp	x0, x1,   [x0, #R0_OFFSET + (0 * REGSZ)]
	stp	x2, x3,   [x0, #R0_OFFSET + (2 * REGSZ)]
	stp	x4, x5,   [x0, #R0_OFFSET + (4 * REGSZ)]
	stp	x6, x7,   [x0, #R0_OFFSET + (6 * REGSZ)]
	stp	x8, x9,   [x0, #R0_OFFSET + (8 * REGSZ)]
	stp	x10, x11, [x0, #R0_OFFSET + (10 * REGSZ)]
	stp	x12, x13, [x0, #R0_OFFSET + (12 * REGSZ)]
	stp	x14, x15, [x0, #R0_OFFSET + (14 * REGSZ)]
	stp	x16, x17, [x0, #R0_OFFSET + (16 * REGSZ)]
	stp	x18, x19, [x0, #R0_OFFSET + (18 * REGSZ)]
	stp	x20, x21, [x0, #R0_OFFSET + (20 * REGSZ)]
	stp	x22, x23, [x0, #R0_OFFSET + (22 * REGSZ)]
	stp	x24, x25, [x0, #R0_OFFSET + (24 * REGSZ)]
	stp	x26, x27, [x0, #R0_OFFSET + (26 * REGSZ)]
	stp	x28, x29, [x0, #R0_OFFSET + (28 * REGSZ)]
	str	x30,      [x0, #R0_OFFSET + (30 * REGSZ)]

	/* save current program counter in link register */
	str	x30, [x0, #PC_OFFSET]

	/* save current stack pointer */
	mov	x2, sp
	str	x2, [x0, #SP_OFFSET]

	/* save pstate */
	str	xzr, [x0, #PSTATE_OFFSET]

	/* TODO: SIMD / FPRs */

	mov	x0, #0
	ret





#endif
