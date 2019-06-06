section .data

dup_array:          dq      0, 2, 4, 6, 8, 8, 4, 5, 6
dup_array_len:      equ     ($-dup_array)/8

nodup_array:        dq      0, 2, 4, 6, 8, 1, 5, 7, 8
nodup_array_len:    equ     ($-nodup_array)/8

dup_msg:            db      "Wrong (has duplicate)!", 10, 0
nodup_msg:          db      "Wrong (no duplicate)!", 10, 0
end_msg:            db      "OK!", 10, 0

section .text
extern printf
global main

main:
    push rbp
    mov rbp, rsp

    mov rax, 0

.first_test:
    mov rdi, dup_array
    mov rsi, dup_array_len
    call has_duplicate_pair
    cmp rax, 1
    je .second_test

    mov rdi, nodup_msg
    call printf
    pop rbp
    mov rax, 0
    ret

.second_test:
    mov rdi, nodup_array
    mov rsi, nodup_array_len
    call has_duplicate_pair
    cmp rax, 0
    je .ok

    mov rdi, dup_msg
    call printf
    pop rbp
    mov rax, 0
    ret

.ok:
    mov rdi, end_msg
    call printf

    mov rax, 0
    pop rbp
    ret

; --------------------------------------------------------------------------------------

has_duplicate_pair:
    mov rcx, rsi        ; counter
    mov rbx, rdi        ; base ptr for rdi array

    .loop:
        mov r8, [rdi]    ; member to be compared
        lea rdi, [rdi+8] ; move to next member

        cmp r8, [rdi]
        je .duplicate
        add rbx, 8
        mov rdi, rbx

    loop .loop

    mov rax, 0
    ret

    .duplicate:
        mov rax, 1
        ret

    ret
