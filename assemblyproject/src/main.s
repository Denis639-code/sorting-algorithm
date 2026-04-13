#main file
.include "data.s"
.section .text
.globl _start
.extern "printNum"
.extern "done"
#------------------------------------------------

_start:
    # Open the file
    # this is loading the filename from the command-line argument
    movq 16(%rsp), %rdi                      # this is loading the first commandline
    
    # Open the file
    movq $2, %rax                           # now we are opening the file
    movq $0, %rsi                         # this is used for reading the file
    syscall                                  
    movq %rax, %rdi                         # here we are storing the returned file descriptor in %rdi

    # we want to make sure if the file was opened successfully
    cmpq $-1, %rax                          # we want to compare the file descripter with -1
    je file_open_error                      # If open failed, jump to error handling
#------------------------------------------------
    # here we have made so that it reads up to 100million bytes from the file
    readfile:
    movq $0, %rax                    # the syscall number for read (0)
    leaq buffer(%rip), %rsi          # the address of the buffer
    movq $10000*10000, %rdx               #  we want to make it read alot to make sure it reads all of them
    syscall                           # this is invoking the syscall
    
    movq %rax, %rcx                  # here we are saving the number of bytes read into %rcx
    testq %rax, %rax                 # here we are checking if any bytes were read
    jz close_file                    # if it is happened that zero bytes were read, skip writing

    
#------------------------------------------------
    # we are now estimating the beginning of buffer & array index
    movl $0, %ebx                  # the index to fill the array
    lea buffer(%rip), %rsi         # the start of the buffer
#------------------------------------------------
jmp parse_loop # Jumps to a function in parse.s
#------------------------------------------------

#------------------------------------------------
.type close_file, @function
.globl close_file
close_file:
    # Close the file
    movq $3, %rax                           # syscall number for close
    syscall  
#------------------------------------------------

#------------------------------------------------
call done # just to make sure the program is done
#------------------------------------------------


