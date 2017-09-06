.syntax unified
.data

uart_write_addr:
.int 0x101f1000
uart_read_addr:
.int 0x101f2000
uart_is_buffer_full_addr:
.int 0x101f3000

meow:
.asciz "Hello meow !"

.text

.globl it_begins
it_begins:
/* This move uart_write_addr symbol address to r0 */
	ldr r0, =uart_write_addr
/* We actually want the value stored at that address (0x101f1000) */
	ldr r0, [r0]
/* This move meow symbol address to r2 */
	ldr r2, =meow

.Lprinting:
	/* Loads a character from the message address and update it to be
	   ready to load the next character on the next loop iteration. */
	ldrb r3, [r2], #1 /* This will increment r2. (add r2, #1) */

	/* Write the character in the uart and loop */
	str r3, [r0]
	/* Check if that character is not '\0' */
	cmp r3, #0
	bne .Lprinting
	/* If the character was '\0', we're done and we'll loop indefinitely */
	b .
