%define			ENDL	0xa		; ascii 10

SYS_EXIT  		equ 	1 		; For eax
SYS_READ 	 	equ 	3 		; For eax
SYS_WRITE 		equ 	4 		; For eax
STDIN     		equ 	0 		; For ebx
STDOUT    		equ 	1		; For ebx


	section .text
global _start

_start:
	; Write the input text
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, inputTxt
	mov edx, inputLen
	int 0x80					; Call kernel

	mov eax, SYS_READ
	mov ebx, STDIN
	mov ecx, buffer
	mov edx, bufferSize
	int 0x80 					; Call kernel

	; Write the hello text
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, helloTxt
	mov edx, helloLen
	int 0x80					; Call kernel

	; Write the user name
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, buffer
	mov edx, bufferSize
	int 0x80					; Call kernel

	mov ebx, 0 					; Set exit code to 0 for success
	jmp exit

;
; Exits the app
; Params:
;	ebx: Exit code
; Returns:
;	NO RETURN
;
exit:
	mov eax, SYS_EXIT
	int 0x80

	section .data
inputTxt	db 		'Please enter your name: '
inputLen 	equ 	$ - inputTxt
helloTxt 	db 		'Hallo und Freut mich, ' 		; The German phrase for hello and nice to meet you, 
helloLen 	equ 	$ - helloTxt

bufferSize	equ 	100

	section .bss
buffer 		resb 	bufferSize
