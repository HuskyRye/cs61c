.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi t0, zero, 1
    bge a1, t0, loop_start
    addi a1, zero, 78
    jal zero, exit2
loop_start:
    add t0, zero, zero # index
loop_body:
    bge t0, a1, loop_end # while t0 < a1
    slli t1, t0, 2
    add t1, a0, t1 # address of a0[t0]
    lw t2, 0(t1)
    bge t2, zero, loop_continue
    sw zero, 0(t1)
loop_continue:
    addi t0, t0, 1
    jal zero, loop_body
loop_end:
    # Epilogue
	ret
