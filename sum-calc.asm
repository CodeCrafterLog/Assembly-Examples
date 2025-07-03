%define			ENDL	0xa		; ascii 10

SYS_EXIT  		equ 	1 		; For eax
SYS_READ 	 	equ 	3 		; For eax
SYS_WRITE 		equ 	4 		; For eax
STDIN     		equ 	0 		; For ebx
STDOUT    		equ 	1		; For ebx

	section .text
global _start

_start:
	; Write the hello text
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, helloTxt
	mov edx, helloLen
	int 0x80					; Call kernel

	xor eax, eax 				; Reset eax for result

	jmp main_loop

;
; Parses a string to int
; Params:
;	ecx: start of string
;	edx: string max length
; Returns:
;	edx: the number (signed)
;
parse_int:
	push eax					; Used to store result before moving it to edx
	push ebx					; Used to store current char
	push ecx					; Used to store start of string
	push esi 					; Used for sign flag
	; edx is used to store the result number so we don't push/pop it

	xor esi, esi
	mov al, [negSign]
	cmp byte [ecx], al
	je .pi_neg
	xor eax, eax 				; Reset eax for result
	jmp .pi_reservs				; Begin normally

.pi_neg:
	mov esi, 1 					; Set the sign flag
	inc ecx 					; Move pointer to next char
	dec edx						; Decrement max size

.pi_reservs:
	xor eax, eax

.pi_loop:
	movzx ebx, byte [ecx]
	inc ecx 					; Ready for next char
	; Check if we hit max size
	cmp edx, 0 					; Check if edx is 0
	je .pi_done

	; Decrement max size
	dec edx

	; Check if it's in bound
	cmp ebx, '0'
	jb .pi_done					; Below '0'
	cmp ebx, '9'
	ja .pi_done					; Above '9'

	; No more problems let's parse
	sub ebx, '0'				; Convert ascii to digit
	imul eax, 10				; Shift the digits so far
	add eax, ebx				; Add the digit

	jmp .pi_loop				; Continue the loop

.pi_done:
	mov edx, eax				; From now edx stores the result
	cmp esi, 0
	je .pi_restore
	neg edx

.pi_restore:
	pop esi
	pop ecx
	pop ebx
	pop eax
	ret

;
; Converts an integer to a string, saves the result to buffer
; Params:
; 	eax: the integer
; 	ecx: start of the buffer
;
	section .data
const10:	dd 	10
	section .text
to_string:
	push eax
	push ecx
	
	cmp eax, 0
	jl .neg_handle
	
.ts_start:
	call .ts_recursion
	jmp .finish
	
.neg_handle:
	neg eax               	; make EAX positive
	push ebx				; Save ebx
	mov bl, [negSign]		; Use ebx to store the minusSign
	mov byte [ecx], bl   	; Add minus to buffer
	pop ebx					; Restore ebx
	inc ecx               	; advance buffer
	jmp .ts_start

.ts_recursion:
	push eax
	push edx
	xor edx, edx
	div dword [const10]
	or eax, eax
	jz .emit_digit
	call .ts_recursion
	
.emit_digit:
	add dl, '0'
	mov byte [ecx], dl
	inc ecx
	pop edx
	pop eax
	ret

.finish:
	pop ecx
	pop eax
	ret

;
; Program main loop
;
main_loop:
	push eax					; Save the main register

	; Write the input text
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, inputTxt
	mov edx, inputLen
	int 0x80					; Call kernel

	; Read the input
	mov eax, SYS_READ
	mov ebx, STDIN
	mov ecx, stringBuffer
	mov edx, numSize
	int 0x80

	; Parse the input
	mov ecx, stringBuffer
	mov edx, numSize
	call parse_int

	; Clear the buffer
	mov ecx, numSize
	mov edi, stringBuffer
	mov eax, 0
	rep stosb

	or edx, edx					; Set the zero flag
	jz main_done				; Main loop finish

	pop eax
	add eax, edx
	
	jmp main_loop				; Continue the loop

main_done:
	pop edx

	; To string
	mov eax, edx
	mov ecx, stringBuffer
	call to_string

	; Print the result
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, stringBuffer
	mov edx, numSize
	int 0x80					; Call kernel

	; Print a new line for beauty
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, newLine
	mov edx, 1
	int 0x80					; Call kernel

	; Exit
	mov ebx, 0 					; Exit code = 0
	jmp exit					; Exit

;
; Exits the app
; Params:
;	ebx: Exit code
; Returns:
;	NO RETURN
;
exit:
	mov eax, SYS_EXIT
	mov ebx, 0 					; Exit code=0
	int 0x80					; Call kernel

	section .data
newLine db 0xa
negSign	db '-'
numSize equ 11

inputTxt db 'Enter a number or empty/0: '
inputLen equ $ - inputTxt

helloTxt db	'Basic sum calculator using only assembly.', ENDL, \
			'Made by Sina Kasesaz.', ENDL, \
			'Please enter any value x and expect a result r, where -2^31 <= x, r <= 2^31-1', ENDL
helloLen equ $ - helloTxt

	section .bss					; Variables here
stringBuffer resb numSize
