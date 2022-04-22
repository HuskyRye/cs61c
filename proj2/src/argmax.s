.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # Prologue
    addi t0, zero, 1
    bge a1, t0, next
    addi a1, zero, 77
    jal zero, exit2
next:
    lw t1, 0(a0) # t1 = a0[0], max value
    addi t4, zero, 0 # max index
loop_start:
    add t0, zero, zero # index t0
loop_body:
    bge t0, a1, loop_end # while t0 < a1
    slli t2, t0, 2
    add t2, a0, t2 # address of a0[t0]
    lw t3, 0(t2)
    bge t1, t3, loop_continue
    add t1, zero, t3
    add t4, zero, t0
loop_continue:
    addi t0, t0, 1
    jal zero, loop_body
loop_end:
    # Epilogue
    add a0, zero, t4
    ret
