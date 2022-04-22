.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp) # a0
    sw s1, 4(sp) # a1
    sw s2, 8(sp) # a2
    sw s3, 12(sp) # file descriptor
    sw s4, 16(sp) # rows
    sw s5, 20(sp) # cols
    sw s6, 24(sp) # matrix[]
    sw ra, 28(sp)

    # Save arguments
    add s0, zero, a0
    add s1, zero, a1
    add s2, zero, a2
	
    # Call fopen
    add a1, zero, s0
    addi a2, zero, 0
    jal ra, fopen
    # fopen error
    addi t0, zero, -1
    beq a0, t0, exit_90
    add s3, zero, a0

    # Call fread to read rows
    add a1, zero, s3
    add a2, zero, s1
    addi a3, zero, 4
    jal ra, fread
    # fread error
    addi t0, zero, 4
    bne a0, t0, exit_91
    lw s4, 0(s1)

    # Call fread to read cols
    add a1, zero, s3
    add a2, zero, s2
    addi a3, zero, 4
    jal ra, fread
    # fread error
    addi t0, zero, 4
    bne a0, t0, exit_91
    lw s5, 0(s2)

    # malloc(rows * cols * 4)
    mul a0, s4, s5
    slli a0, a0, 2
    jal ra, malloc
    # malloc error
    beq a0, zero, exit_88
    add s6, zero, a0

    # Call fread to read matrix
    add a1, zero, s3
    add a2, zero, s6
    mul a3, s4, s5
    slli a3, a3, 2
    jal ra, fread
    # fread error
    mul t0, s4, s5
    slli t0, t0, 2
    bne a0, t0, exit_91
    
    # Call fclose
    add a1, zero, s3
    jal ra, fclose
    # fclose error
    blt a0, zero, exit_92

    # Return pointer to the matrix
    add a0, zero, s6

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32

    ret

exit_88:
    addi a1, zero, 88
    jal zero, exit2
exit_90:
    addi a1, zero, 90
    jal zero, exit2
exit_91:
    addi a1, zero, 91
    jal zero, exit2
exit_92:
    addi a1, zero, 92
    jal zero, exit2
