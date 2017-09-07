.syntax unified
.data

/* Divisor 13 for 128000 bauds */

/* Yes, they're both the same... according to TRM */
uart_write_addr:
uart_dll_addr:
.int 0xff690000

uart_lcr_addr:
.int 0xff69000c

uart_mcr_addr:
.int 0xff690010

uart_usr_addr:
.int 0xff69007c


meow:
.asciz "Hello meow !"

.text

.globl it_begins
it_begins:

	ldr r0, =uart_write_addr
	ldr r0, [r0]

	ldr r1, =uart_lcr_addr
	ldr r1, [r1]

	ldr r2, =meow

	ldr r3, =uart_usr_addr
	ldr r3, [r3]

	ldr r7, =uart_mcr_addr
	ldr r7, [r7]

.Lprinting:
.Lcheck_if_busy: /* Check if USR[0] is set. Loop until it isn't */
	ldr r4, [r3]
	mov r5, #1
	and r4, r4, r5
	cmp r4, r5
	bne .Lcheck_if_busy
/* Set LCR[7] so that the next write to r0 setup the baud rate
   clock divisor */
.Lset_lcr_7:
	ldrb r4, [r1]
	lsl r5, r5, #7
	orr r4, r4, r5
	strb r4, [r1]
	isb /* Be sure that every instruction got executed */
/* Set the baud rate clock divisor (13 for 128000 bauds) */
.Lset_dll_dlh:
	mov r4, #13
	strb r4, [r0]
	isb /* Same here */
/* Write data to THR */
.Lwrite_data_to_thr:
	ldrb r4, [r2]
	strb r4, [r0]
	mov r6, r4 /* Backup the character to loop afterwards */
.Lset_the_mcr:
	ldrb r4, [r7]
	mov r5, #1
	orr r4, r4, r5
	strb r4, [r7]
.Lprint_next_character_if_any_left:
	cmp r6, #0
	bne .Lprinting
.Lloop_forever:
	b .

