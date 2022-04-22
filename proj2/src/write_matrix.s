.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp) # a0
    sw s1, 4(sp) # a1
    sw s2, 8(sp) # a2
    sw s3, 12(sp) # a3
    sw s4, 16(sp) # file descriptor
    sw ra, 20(sp)

    # Save arguments
    add s0, zero, a0
    add s1, zero, a1
    add s2, zero, a2
    add s3, zero, a3

    # fopen
    add a1, zero, s0
    addi a2, zero, 1
    jal ra, fopen
    # fopen error
    addi t0, zero, -1
    beq a0, t0, exit_93
    add s4, zero, a0

    # fwrite dim info
    add a1, zero, s4
    addi sp, sp, -8
    sw s2, 0(sp)
    sw s3, 4(sp)
    add a2, zero, sp
    addi a3, zero, 2
    addi a4, zero, 4
    jal ra, fwrite
    addi sp, sp, 8
    addi t0, zero, 2
    bne a0, t0, exit_94
    
    # fwrite matrix
    add a1, zero, s4
    add a2, zero, s1
    mul a3, s2, s3
    addi a4, zero, 4
    jal ra, fwrite
    mul t0, s2, s3
    bne a0, t0, exit_94

    # fclose
    add a1, zero, s4
    jal ra, fclose
    # fclose error
    addi t0, zero, -1
    beq a0, t0, exit_95

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    ret

exit_93:
    addi a1, zero, 93
    jal zero, exit2
exit_94:
    addi a1, zero, 94
    jal zero, exit2
exit_95:
    addi a1, zero, 95
    jal zero, exit2
