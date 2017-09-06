.syntax unified
.data

uart_write_addr:
.int 0xff690000
uart_lsr_addr:
.int 0xff690014

meow:
.asciz "Hello meow !"

.text

.globl it_begins
it_begins:
	/* This move uart_write_addr symbol address to r0 */
	ldr r0, =uart_write_addr // r0 = &uart_write_addr
	/* We actually want the value stored at that address (0xff690000) */
	ldr r0, [r0] // r0 = 0xff690000

	/* This loads the uart_lsr_addr symbol address to r1 and
	   then loads the value stored at that address to r1.
	   The LSR is actually needed on Rockchip systems. If the 5th bit
	   is set to 1 then data can be sent again.
	*/
	ldr r1, =uart_lsr_addr  // r1 = &uart_lsr_addr
	ldr r1, [r1]            // r1 = 0xff690014

	/* This move meow symbol address to r2 */
	ldr r2, =meow

.Lprinting:
	/* Loads a character from the message address and update it to be
	   ready to load the next character on the next loop iteration. */
	ldrb r3, [r2], #1 /* This will increment r2. (add r2, #1) */
/* Checks if LSR[5] is set. We must loop until this bit is set
	 else the data written in the UART register won't be sent. */

	/* Write the character in the uart and loop */
	/* According to RK3288 TRM, you can only setup the first 8 bits */
	strb r3, [r0]
	/* Check if that character is not '\0' */
	cmp r3, #0
	bne .Lprinting
	/* If the character was '\0', we're done and we'll loop indefinitely */
	b .

	// See the diagram in the documentation. It's slightly more complex...
