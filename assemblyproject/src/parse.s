.include "insert.s"
.type parse_loop, @function
.globl parse_loop
parse_loop:
    
    parse_nextline:
    xor %eax, %eax                  # we want to clear the eax to store the number
    xor %ecx, %ecx                  # the same goes for ecx for valid digits count


read_x:
    # reading the x value
    movb (%rsi), %cl                # now we are loading 8-byte from the buffer
    cmpb $0x20, %cl                 # this is for checking if it is a space (0x20) just to make sure its done
    je end_read_x                   # If it is a space, then we are finished reading x
    cmpb $0x09, %cl                 # just checking for tab (0x09) just like from the assignment ascii code
    je end_read_x                   # if it is a tab, finish reading x
    cmpb $0, %cl                    # Checks for null terminator
    je sort_pairs                   # If yes, move on to sorting.

    subb $48, %cl                   # we want to Convert ASCII to an integer 
    cmpb $0, %cl                    # we want to see if it is a valid digit
    jb file_read_error              # If it is less than 0, we throw a read error.
    cmpb $9, %cl                    # now we are checking if its greater than 9
    ja file_read_error              # If it is greater than 9, we throw a read error.

    imull $10, %eax                 # here we multiplying current number by 10 for storing more numbers into a single digit
    addl %ecx, %eax                 # we are adding the new digit to the number
    inc %rsi                        # now we are moving to next byte
    jmp read_x                      # this goes again for repeat reading x
#------------------------------------------------
end_read_x:
    cmpl $32767, %eax               # comparing y with 32767, so it dosent go over 16-bit rule from the assignment
    jg invalid                      # jumping to invalid if x > 32767
    movl %eax, array(, %ebx, 8)    # now we are storing x in array

    inc %rsi                        # moving to the next byte

    # Read the y value
    xor %eax, %eax                  # clearing eax to store the number
    xor %ecx, %ecx                  # clearing ecx for valid digits count
#------------------------------------------------
read_y:
    movb (%rsi), %cl                # the same for read_x
    cmpb $0x0A, %cl                 # Check for newline (0x0A)
    je increase_length                   
    cmpb $0, %cl                    
    je increase_length                   

    subb $48, %cl                   # Convert ASCII to integer

    cmpb $0, %cl                    
    jb file_read_error              # Throws a read error if the byte has a value below 0    
    cmpb $9, %cl                   
    ja file_read_error              # throws a read error if the byte has a value above 9  

    imull $10, %eax                 
    addl %ecx, %eax                 
    inc %rsi                        

    jmp read_y                      # Repeat reading y
#------------------------------------------------
increase_length:
    incl length
end_read_y:
    movl %eax, array+4(, %ebx, 8)  # the same principle for end_read_x, we are just moving the address 4 bytes further in the array
    cmpl $32767, %eax               # comparing y with 32767
    jg invalid                      # jumping to invalid if y > 32767
    inc %ebx                        # now we increment for moving to the next pair in the list
    jmp inc_loop
#------------------------------------------------

#------------------------------------------------
inc_loop:
inc %rsi
jmp parse_loop
#------------------------------------------------
sort_pairs:
    movl $1, %ebx                  # Start from the second pair 
    jmp for_loop

