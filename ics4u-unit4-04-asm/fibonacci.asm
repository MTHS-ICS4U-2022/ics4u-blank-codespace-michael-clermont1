; --------------------------------------------------------------
; Created by: Michael Clermont
; Created on: Jan 2023
; Writes out 7 fibonacci numbers
; Runs on 64-bit x86 Linux only.
; --------------------------------------------------------------


section .bss
    someNumber: RESD 1                     ; 4 bytes


section .data
    ; constants here
    newLine: db 10                       ; UNICODE 10 is new line character
    done: db 10, "Done.", 10             ; string to print
    doneLen: equ $-done                  ; length of string


section .text
    global _start                        ; entry point for linker


    _start:                             ; start here
        mov r8, 0                       ; move the integer 0 into r8 - fib number 1
        mov r9, 1                       ; move the integer 1 into r9  - fib number 2
        mov r12, 0                      ; initialize counter register

        push r8                      ; print first fib num
        call PrintSingleDigitInt     ; call our print single digit function
        add rsp, 4                   ; pop but throw away the value
        


        IncrementLabel:
            ; doing a do ... while loop!
            mov r10, r8                  ; initialize temp num
            add r10, r9                  ; generate fib result
            push r9                      ; print result
            call PrintSingleDigitInt     ; call our print single digit function
            add rsp, 4                   ; pop but throw away the value
            mov r8, r9                   ; move fib num 2 into r8
            mov r9, r10                  ; move result into r9
            inc r12                      ; increment counter
            cmp r12, 5                   ; compare r8 and ascii 5
            jle IncrementLabel           ; jump if <= goto "LoopLable"


        ; write done to screen
        mov rax, 1                  ; system call for write
        mov rdi, 1                  ; file handle 1 is stdout
        mov rsi, done               ; address of string to output
        mov rdx, doneLen            ; number of bytes
        syscall                     ; invoke operating system to do the write


        mov rax, 60                 ; system call for exit
        mov rdi, 0                  ; exit code 0
        syscall                     ; invoke operating system to exit



PrintSingleDigitInt:
    ; takes in a single digit int and prints the assci equivalent


    ; when a function is called, the return value is placed on the stack
    ; we need to keep this, so that we can return to the correct place in our program!
    pop r14                     ; pop the return address to r9
    pop r15                     ; pop the "parameter" we placed on the stack
    add r15, 48                 ; add the ascii offset
    push r15                    ; place it back onto the stack


    ; write value on the stack to STDOUT
    mov rax, 1                  ; system call for write
    mov rdi, 1                  ; file handle 1 is stdout
    mov rsi, rsp                ; the string to write popped from the top of the stack
    mov rdx, 1                  ; number of bytes
    syscall                     ; invoke operating system to do the write


    ; print a new line
    mov rax, 1                  ; system call for write
    mov rdi, 1                  ; file handle 1 is stdout
    mov rsi, newLine            ; address of string to output
    mov rdx, 1                  ; number of bytes
    syscall                     ; invoke operating system to do the write


    push r14                    ; put the return address back on the stack to get back
    ret                         ; return