section .text:
	global _start				; Must be declared for linker (ld)

_start:							; Tells entry point
	mov edx, len				; Message length
	mov ecx, msg				; Message pointer
	mov ebx, 1					; File descriptor (stdout)
	mov eax, 4					; System call number (sys_write)
	int 0x80					; Call kernel

	mov eax, 1					; System call number (sys_exit)
	int 0x80					; Call kernel

section .data:
msg db 'Hello ,world!', 0xa		; String to be printed
len equ $-msg					; Get string length
