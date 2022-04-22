.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    # Error checks
    bge zero, a1, exit_72
    bge zero, a2, exit_72
    bge zero, a4, exit_73    
    bge zero, a5, exit_73   
    bne a2, a4, exit_74
    # Prologue
    addi, sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    add s0, zero, a0
    add s1, zero, a1
    add s2, zero, a2
    add s3, zero, a3
    add s4, zero, a4
    add s5, zero, a5
    add s6, zero, a6
outer_loop_start:
    add t0, zero, zero # index i
outer_loop_body:
    bge t0, s1, outer_loop_end
inner_loop_start:
    add t1, zero, zero # index j
inner_loop_body:
    bge t1, s5, inner_loop_end
    addi, sp, sp, -12
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)

    mul a0, t0, s2
    slli a0, a0, 2
    add a0, s0, a0 # address of m0[i][0]
    slli a1, t1, 2
    add a1, s3, a1 # address of m1[0][j]
    add a2, zero, s2
    addi a3, zero, 1
    add a4, zero, s5

    jal ra, dot # call dot

    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    addi, sp, sp, 12

    mul t2, t0, s5
    add t2, t2, t1
    slli t2, t2, 2
    add t2, s6, t2 # address of d[i][j]
    sw a0, 0(t2) # d[i][j] = a0

inner_loop_continue:
    addi t1, t1, 1
    jal zero, inner_loop_body
inner_loop_end:
outer_loop_continue:
    addi t0, t0, 1
    jal zero, outer_loop_body
outer_loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    addi, sp, sp, 28
    ret

exit_72:
    addi a1, zero, 72
    jal zero, exit2
exit_73:
    addi a1, zero, 73
    jal zero, exit2
exit_74:
    addi a1, zero, 74
    jal zero, exit2