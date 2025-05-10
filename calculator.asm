extern printf
extern atoi

section .data
msg db "[+] CALCULATOR WITH x86_x64 ASSEMBLY!", 0xa , 0x0
len equ $-msg
msg1 db "[+] Enter First Number: " , 0x0
len1 equ $-msg1
msg2 db "[+] Enter Second Number: ", 0x0
len2 equ $-msg2
msg3 db "[x] DIVISOR IS ZERO, DIVISION CAN'T BE DONE", 0xa , 0x0
len3 equ $-msg3
msg4 db "[x] INPUT IS NOT A VALID INTEGER!" , 0xa , 0x0
len4 equ $-msg4
input_len_1 equ 10
input_len_2 equ 10
new_line db 0xa
fmt_str1 db "[+] The two numbers are: %d , %d" , 0xa , 0xa , 0x0
fmt_str2 db "[+] ADDITION -> %d" , 0xa , 0x0
fmt_str3 db "[+] SUBTRACTION -> %d" , 0xa , 0x0
fmt_str4 db "[+] MULTIPLICATION -> %d" , 0xa , 0x0
fmt_str5 db "[+] DIVISION QUOTIENT -> %d" , 0xa , 0x0
fmt_str6 db "[+] DIVISION REMAINDER -> %d" , 0xa , 0xa , 0x0

section .bss
input_buf_1 resb input_len_1 + 1
input_buf_2 resb input_len_2 + 1

input_q_1 resq 1	; 1 qword -> 8 bytes
input_q_2 resq 1	; 1 qword -> 8 bytes
remainder_q resq 1	; 1 qword -> 8 bytes

section .text
global main

main:
push rbp	
mov rbp , rsp
	
xor rax , rax
; PRINT INTRO
mov rdi , 1
mov rsi , msg
mov rdx , len
call prints_output

_READING_INPUT_:
xor rax , rax
; PRINT FOR INPUT_1
mov rdi , 1
mov rsi , msg1
mov rdx , len1
call prints_output

; READ INPUT_1
xor rax , rax
mov rdi , 0
mov rsi , input_buf_1
mov rdx , input_len_1
call read_input

; CONVERT INPUT_1 TO INTEGER
xor rax , rax
mov rdi , input_buf_1
call str_to_int
mov [input_q_1] , rax
cmp rax , 0	;CHECK ERR (if it's not a valid integer)
jz input_err
xor rax , rax

; PRINT FOR INPUT_2
mov rdi , 1
mov rsi , msg2
mov rdx , len2
call prints_output

; READ INPUT_2
xor rax , rax
mov rdi , 0
mov rsi , input_buf_2
mov rdx , input_len_2
call read_input

; CONVERT INPUT_2 TO INTEGER
xor rax , rax
mov rdi , input_buf_2
call str_to_int
mov [input_q_2] , rax
cmp rax , 0	; CHECK ERR
jz input_err

; PRINT BOTH INPUTS
xor rax , rax
mov rdi , fmt_str1
mov rsi , [input_q_1] 
mov rdx , [input_q_2]
call prints_fmt_output


; ADD
mov r8 , [input_q_1]
mov r9 , [input_q_2]
add r8 , r9
mov rdi , fmt_str2
mov rsi , r8
call prints_fmt_output

; SUB
mov r8 , [input_q_1]
mov r9 , [input_q_2]
sub r8 , r9
mov rdi , fmt_str3
mov rsi , r8
call prints_fmt_output

; MULT
mov r8 , [input_q_1]
mov r9 , [input_q_2]
imul r8 , r9
mov rdi , fmt_str4
mov rsi , r8
call prints_fmt_output

; DIVISION
mov rax , [input_q_1]
cqo	; sign-extend RAX into RDX (to make RDX:RAX the full dividend 128 bits)
mov rbx , [input_q_2]
cmp rbx , 0
jz div_by_zero
idiv rbx	; signed-division: RDX:RAX / RBX
; quotient is stored in RAX and remainder is stored in RDX

; save the remainder to a variable
mov [remainder_q] , rdx
; PRINT QUOTIENT
mov rdi , fmt_str5
mov rsi , rax
call prints_fmt_output
; PRINT REMAINDER
mov rdi , fmt_str6
mov rsi , [remainder_q]
call prints_fmt_output

jmp _READING_INPUT_

DONE:
leave	;mov rsp,rbp / pop rbp
ret



read_input:
push rbp
mov rbp , rsp
xor rax , rax
syscall
leave
ret

prints_output:
push rbp
mov rbp , rsp
mov rax , 1
syscall
leave
ret

prints_fmt_output:
push rbp
mov rbp , rsp
call printf
leave
ret

str_to_int:
push rbp
mov rbp , rsp
call atoi
leave
ret


div_by_zero:
; PRINT ERROR MESSAGE FOR DIVISION THEN CONTINUE
xor rax , rax
mov rdi , 1
mov rsi , msg3
mov rdx , len3
call prints_output
jmp DONE


input_err:
; PRINT ERROR MESSAGE THEN EXIT
xor rax , rax
mov rdi , 1
mov rsi , msg4
mov rdx , len4
call prints_output
jmp _READING_INPUT_

