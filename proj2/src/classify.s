.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    addi t0, zero, 5
    bne a0, t0, exit_89

    # Prologue
    addi sp, sp, -52
    sw s0, 0(sp) # M0_PATH -> m0_matrix[]
    sw s1, 4(sp) # M1_PATH
    sw s2, 8(sp) # INPUT_PATH
    sw s3, 12(sp) # OUTPUT_PATH
    sw s4, 16(sp) # m0_rows
    sw s5, 20(sp) # m0_cols
    sw s6, 24(sp) # m1_rows
    sw s7, 28(sp) # m1_cols
    sw s8, 32(sp) # input_rows
    sw s9, 36(sp) # input_cols
    sw s10, 40(sp) # hidden_layer
    sw s11, 44(sp) # scores
    sw ra, 48(sp)

    # Save arguments
    lw s0, 4(a1)
    lw s1, 8(a1)
    lw s2, 12(a1)
    lw s3, 16(a1)

    addi sp, sp, -4
    sw a2, 0(sp)

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    add a0, zero, s0
    addi sp, sp, -8
    addi a1, sp, 0
    addi a2, sp, 4
    jal ra, read_matrix
    add s0, zero, a0
    lw s4, 0(sp)
    lw s5, 4(sp)
    addi sp, sp, 8

    # Load pretrained m1
    add a0, zero, s1
    addi sp, sp, -8
    addi a1, sp, 0
    addi a2, sp, 4
    jal ra, read_matrix
    add s1, zero, a0
    lw s6, 0(sp)
    lw s7, 4(sp)
    addi sp, sp, 8

    # Load input matrix
    add a0, zero, s2
    addi sp, sp, -8
    addi a1, sp, 0
    addi a2, sp, 4
    jal ra, read_matrix
    add s2, zero, a0
    lw s8, 0(sp)
    lw s9, 4(sp)
    addi sp, sp, 8

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    
    # malloc for hidden_layer
    mul a0, s4, s9
    slli a0, a0, 2
    jal ra, malloc
    add s10, zero, a0

    # hidden_layer = matmul(m0, input)
    add a0, zero, s0
    add a1, zero, s4
    add a2, zero, s5
    add a3, zero, s2
    add a4, zero, s8
    add a5, zero, s9
    add a6, zero, s10
    jal ra, matmul

    # relu(hidden_layer)
    add a0, zero, s10
    mul a1, s4, s9
    jal ra relu

    # malloc for scores
    mul a0, s6, s9
    slli a0, a0, 2
    jal ra, malloc
    add s11, zero, a0

    # scores = matmul(m1, hidden_layer)
    add a0, zero, s1
    add a1, zero, s6
    add a2, zero, s7
    add a3, zero, s10
    add a4, zero, s4
    add a5, zero, s9
    add a6, zero, s11
    jal ra, matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    add a0, zero, s3
    add a1, zero, s11
    add a2, zero, s6
    add a3, zero, s9
    jal ra, write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    add a0, zero, s11
    mul a1, s6, s9
    jal ra, argmax

    # print if a2 == 0
    lw t0, 0(sp)
    addi sp, sp, 4
    bne t0, zero, print_nothing

    # Print classification
    add a1, zero, a0
    jal ra, print_int

    # Print newline afterwards for clarity
    addi a1, zero, '\n'
    jal ra, print_char


print_nothing:
    # free hidden_layer
    add a0, zero, s10
    jal ra, free

    # free scores
    add a0, zero, s11
    jal ra, free

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 40(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52

    ret

exit_88:
    addi a1, zero, 88
    jal zero, exit2
exit_89:
    addi a1, zero, 89
    jal zero, exit2
