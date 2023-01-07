; ---------------------------------------------------------------
; Read a 2 digit decimal number and then print it to the console.
; Runs on 64-bit x86 Linux only.
; ---------------------------------------------------------------

section .bss
    variable: RESD 1               ; 4 bytes 

section .data
     newline db 10                  ; UNICODE 10 is new line character
     prompt: db "Enter a 2 digit number: "
     promptLen: equ $-prompt

     response_start: db "The number is: "
     response_start_len: equ $-response_start

     done: db "Done."
     doneLen: equ $-done

section .text
    global _start                  ; entry point for linker

    _start:                        ; start here
        mov rax, 1                 ; write
        mov rdi, 1                 ; std out
        mov rsi, prompt            ; pointer to the value
        mov rdx, promptLen         ; length of output (in bytes)
        syscall

        ; read 2 bytes from stdin 
        mov rax, 3                 ; 3 is recognized by the system as meaning "read"
        mov rdx, 0                 ; read from standard input
        mov rcx, variable          ; address of number to input
        mov rdx, 2                 ; number of bytes
        int 0x80                   ; call the kernel

        ; print a new line
        mov rax, 1
        mov rdi, 1
        mov rsi, newline
        mov rdx, 1
        syscall

        ; Write the start of the response
        mov rax, 1
        mov rdi, 1
        mov rsi, response_start
        mov rdx, response_start_len
        syscall

        ; print a byte to stdout
        mov rax, 4                 ; the system interprets 4 as "write"
        mov rbx, 1                 ; standard output (print to terminal)
        mov rcx, variable          ; pointer to the value being passed
        mov rdx, 2                 ; length of output (in bytes)
        int 0x80                   ; call the kernel

        ; print a new line
        mov rax, 1
        mov rdi, 1
        mov rsi, newline
        mov rdx, 1
        syscall

        ; print a new line
        mov rax, 1
        mov rdi, 1
        mov rsi, newline
        mov rdx, 1
        syscall

        ; print done to stdout
        mov rax, 1                 ; system call for write
        mov rdi, 1                 ; file handle 1 is stdout
        mov rsi, done              ; address of string to output
        mov rdx, doneLen           ; number of bytes
        syscall                    ; invoke operating system to do the write 

        ; print a new line
        mov rax, 1
        mov rdi, 1
        mov rsi, newline
        mov rdx, 1
        syscall

        mov rax, 60                ; system call for exit 
        mov rdi, 0                 ; exit code 0 
        syscall                    ; invoke operating system to exit 