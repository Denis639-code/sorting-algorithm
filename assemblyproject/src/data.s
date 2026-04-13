.section .data
buffer:      .space 10000*10000          # this is just for storing how much the buffer be, we have set it to enormous just to make sure it reads all
array:       .space 20000*10000              # Reserve space for 10 (x, y) pairs (10 * 8 bytes = 80), you can adjust it manually
length:      .long 0             # Variable to contain length
tab_buf:     .byte 9                # Tab character
newline_buf: .byte 10               # Newline character
error_msg_open: .ascii "Error opening file.\n"  # Error message for file open
error_msg_read: .ascii "Error reading file, check for invalid characters.\n"  # Error message for read
tolong: .ascii "Sorry my friend it's tooo loong :/" # just if its over 16-bit integer

