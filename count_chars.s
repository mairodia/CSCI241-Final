section .data

test_string:    db      "Hello, world!", 10, 0

ok_msg:         db      "OK!", 10, 0
error_msg:      db      "Incorrect result: expected %d, got %d.", 10, 0

section .text

extern printf
global main

main:
    push rbp
    mov rbp, rsp

    mov rdi, test_string
    mov sil, 'l'
    call count_chars
    cmp rax, 3
    je .second_test

    mov rdi, error_msg
    mov rsi, 3
    mov rdx, rax
    call printf

    mov rax, 0
    pop rbp
    ret

.second_test:

    mov rdi, test_string
    mov sil, 'o'
    call count_chars
    cmp rax, 2
    je .ok

    mov rdi, error_msg
    mov rsi, 2
    mov rdx, rax
    call printf

    mov rax, 0
    pop rbp
    ret

.ok:

    mov rdi, ok_msg
    call printf

    mov rax, 0
    pop rbp
    ret

; ---------------------------------------------------------------------------------------

count_chars:
    xor rbx, rbx        ; set rbx = 0
    xor rax, rax        ; set rax = 0
    .compare:
        cmp byte[rdi], sil  ; cmp byte[rdi] and byte[rsi]
        jne .else
            inc rax     ; if rdi = rsi, rax ++
        .else:
        inc rdi          ; move to next byte
        cmp byte[rdi], 0 ; are we at space or endline?
        jne .compare
            cmp rbx, 0   ; is this the first 0?
            jne .exit    ; if not, it's endline. exit
            inc rbx      ; if yes, it's a space. increment
            jne .compare ; and continue
    .exit:
    ret
