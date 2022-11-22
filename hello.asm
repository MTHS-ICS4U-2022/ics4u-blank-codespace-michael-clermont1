section .bss
    ; variables

section .data
    hello: db "Hello, World!", 10    ; string to print
    helloLen: equ $-hello            ; length of string


section .text
    global _star    ; entry point for linker

    _start:         ; start here
        mov  rax,1         ; sys_write
        mov  rdi,1         ; stdout
        mov  rsi,hello     ; message to write
        mov  rdx,helloLen  ; message length
        syscall            ; call kernel

        ; end program
        mov  rax,60        ; sys_exit
        mov  rdi,0         ; error code 0 (succes)
        syscall            ; call kernel