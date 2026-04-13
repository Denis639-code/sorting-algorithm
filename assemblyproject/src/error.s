# This is only checking for errors if it doesn't run properbly
.include "data.s"
.section .text

.type invalid, @function
.globl invalid
invalid:
    # this is printing the invalid message
    movq $1, %rax                     # we are using syscall: sys_write
    movq $1, %rdi                     # writing to stdout
    lea tolong(%rip), %rsi            # we are loading the address of the invalid message from data.s
    movq $38, %rdx                    # Length of the invalid message
    syscall                           

    jmp done                          # here we are jumping to done to exit the program


.type file_open_error, @function
.globl file_open_error
file_open_error:
    # printing the error message and exit
    movq $1, %rax                      
    movq $2, %rdi # stderr                  
    lea error_msg_open(%rip), %rsi    # loading the error message
    movq $25, %rdx                     # the length of the error message
    syscall

    # Exit the program
    movl $60, %eax                     # syscall for exit the program
    xor %edi, %edi                     # we are making a bitwise for clearing the %edi register
    syscall

.type file_read_error, @function
.globl file_read_error
file_read_error:
    movq $1, %rax                      
    movq $2, %rdi # stderr                      
    lea error_msg_read(%rip), %rsi    # loading the error message
    movq $51, %rdx                     # the length of the error message
    syscall

    # Exit the program
    movl $60, %eax                     # syscall for exit the program
    xor %edi, %edi                     # we are making a bitwise for clearing the %edi register
    syscall

.type done, @function
.globl done
done:
    # Exit the program
    movl $60, %eax                  # syscall for exit
    xor %edi, %edi                  # clearing the %edi register for making the status as 0
    syscall
    