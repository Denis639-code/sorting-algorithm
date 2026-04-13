OBJS = main.o parse.o data.o utils.o error.o insert.o

# this is the assembler flags for debugging used from the slides in the lecture
ASFLAGS = -g

# Target executable main
TARGET = sorter

# Default target to link all object files into the executable
$(TARGET): $(OBJS)
	ld -o $(TARGET) $(OBJS)

# Rule to convert every single assembly each .s file into a .o file
%.o: %.s
	as $(ASFLAGS) $< -o $@

# Clean up object files and the executable
.PHONY: clean
clean:
	rm -f *.o $(TARGET)
