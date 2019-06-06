section .data

array:          dq      0, 5, 3, 8, -6, 1, -8, -2, 38 , 54, 2
array_len:      equ     ($ - array) / 8

min_err_msg:    db      "Minimum incorrect! %d", 10, 0
max_err_msg:    db      "Maximum incorrect! %d", 10, 0
ok_msg:         db      "OK!", 10, 0

; These should be local (on the stack) but whatever.
min:            dq      0
max:            dq      0

section .text
extern printf
global main

main:
    push rbp
    mov rbp, rsp

    mov rdi, array
    mov rsi, array_len
    mov rdx, min
    mov rcx, max
    call minmax

    cmp qword [min], -8
    je .min_correct

    mov rdi, min_err_msg
    mov rsi, qword [min]
    call printf
    jmp .return

.min_correct:
    cmp qword [max], 54
    je .max_correct

    mov rdi, max_err_msg
    mov rsi, qword [max]
    call printf
    jmp .return

.max_correct:
    mov rdi, ok_msg
    call printf

.return:
    mov rax, 0
    pop rbp
    ret

;;; -----------------------------------------------------------------------------------

minmax:
    mov rcx, rsi    ; loop counter
    mov r14, 100
    mov r15, -10
    
    .loop:
        cmp r14, [rdi]
        jle .not_min        ; if rdi < r14
            mov r14, [rdi]  ; rdi is new min
        .not_min:
        cmp r15, [rdi]
        jge .not_max        ; if rdi > r15
            mov r15, [rdi]  ; r15 is new max
        .not_max:
        add rdi, 8          ; mov to next member
    loop .loop

    mov [min], r14
    mov [max], r15

    ret
