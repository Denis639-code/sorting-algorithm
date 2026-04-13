#here we are using insertionsort for our sorts algorithm
.include "data.s"
.section .text

.extern "done"
.extern "printNum"


for_loop:
    cmpl length, %ebx              # now we are comparing the length with ebx index
    jge print_array                 # If ebx >= length, go to print_array

    # Load current pair (x, y) to be inserted
    movl array(, %ebx, 8), %edx    # edx = x of current pair
    movl array+4(, %ebx, 8), %esi   # esi = y of current pair

    # Start inner loop to insert in sorted part
    movl %ebx, %ecx                # ecx = ebx (initialize j) we are initializing the j and then moving it back just like insertionsort
    decl %ecx                       # here is  j = ebx - 1
#------------------------------------------------

inner_loop:
    cmpl $0, %ecx                   # we are checking if we have reached the start of the array
    jl insert                       # If j < 0, then we are going to the insert step

    # here we loading the y-value of the current sorted element to compare
    movl array+4(, %ecx, 8), %edi    # edi is the  y-value of array[j]
    cmpl %esi, %edi                 # we are comparing array[j].y with our value key.y
    jg shift                       # If array[j].y > key.y,then we jump to the shift function

    jmp insert                      # If array[j].y <= key.y, then we are jumping to the insert function

#------------------------------------------------
shift:
    movl array(, %ecx, 8), %edi      # edi = array[j].x value
    movl %edi, array+8(, %ecx, 8)    # array[j+1].x = array[j].x shifting the value x one step back in the array
    movl array+4(, %ecx, 8), %edi      # edi = array[j].y and y-value is moving along
    movl %edi, array+12(, %ecx, 8)    # array[j+1].y = array[j].y now we shifting the x,y together

    decl %ecx                       # j--
    jmp inner_loop                  # here we continue shifting the elements

#------------------------------------------------
insert:
    # Adjust index for insertion (j+1)
    incl %ecx                       # now our ecx is j+1 
    # now we want to place the (x, y) we are pairing in its correct position
    movl %edx, array(, %ecx, 8)     # array[j+1].x = key.x
    movl %esi, array+4(, %ecx, 8)    # array[j+1].y = key.y

    # Move to the next element in the outer loop
    addl $1, %ebx                   # i++
    jmp for_loop                    # now we are repeating for next element

#------------------------------------------------

print_array:
    movl $0, %ebx                   # we are now reseting the index to 0 for printing

#------------------------------------------------

print_loop:
    cmpl length, %ebx               # we are now comparing the length with index ebx                    
    jge done # If ebx >= length, then we are done with printing

    # we are now loading the array[ebx].x into edi for printNum
    movl array(, %ebx, 8), %edi      # edi = array[ebx].x
    call printNum                    # now we are printing the x-coordinate

    #  this is going to print a tab after the first number
    movq $1, %rax                   # the syscall for write
    movq $1, %rdi                   # moving tov standout output
    movq $tab_buf, %rsi             # moving the value ascii code from the data.s for tab
    movq $1, %rdx                   # every length is one byte 
    syscall

    # now we are loading array[ebx].y into edi using printNum from the lab snippet-code
    movl array+4(, %ebx, 8), %edi    # edi = array[ebx].y
    call printNum                    # printing the y-coordinate

    # this is printing a newline after the second number
    movq $1, %rax                   # syscall: sys_write
    movq $1, %rdi                   # this is for stdout
    movq $newline_buf, %rsi         # values in ascii for the newline
    movq $1, %rdx                   # length is every one byte
    syscall

    addl $1, %ebx                   # now we are moving to the next pair
    jmp print_loop                  # we are repeating the function print_loop

