.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Prologue
    addi t0, zero, 1
    blt a2, t0, exit_75
    blt a3, t0, exit_76
    blt a4, t0, exit_76
    
    add t0, zero, zero # sum
loop_start:
    add t1, zero, zero # index
loop_body:
    bge t1, a2, loop_end # while t1 < a2
    mul t2, t1, a3
    slli t2, t2, 2
    add t2, a0, t2 # address of a0[i*v0]
    lw t3, 0(t2) # a0[i*v0]
    mul t4, t1, a4
    slli t4, t4, 2
    add t4, a1, t4 # address of a0[i*v1]
    lw t5, 0(t4) # a1[i*v1]
    mul t6, t3, t5 # a0[i*v0] * a1[i*v1]
    add t0, t0, t6 # sum += a0[i*v0] * a1[i*v1]
loop_continue:
    addi t1, t1, 1
    jal zero, loop_body
loop_end:
    add a0, zero, t0
    # Epilogue
    ret

exit_75:
    addi a1, zero, 75
    jal zero, exit2
exit_76:
    addi a1, zero, 76
    jal zero, exit2
