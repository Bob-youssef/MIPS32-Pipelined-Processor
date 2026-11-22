# Test program 2: covers ori/andi/xori (zero extend), negative addi, nor, sw, lw,
# beq not taken, beq taken and j
# expected: $t0=0x80FF $t1=0xFFFFFFF0 $t2=0x80F0 $t3=0x55 $t4=0 $t5=0x55 $t6=0 $t7=0x8100
#           dmem[1] (address 4) = 0x55, dmem[2] (address 8) = 0x8100

        ori  $t0, $0, 0x80FF    # 0x00  $t0 = 0x000080FF (zero extended)
        addi $t1, $0, -16       # 0x04  $t1 = 0xFFFFFFF0
        nop                     # 0x08
        nop                     # 0x0C
        xori $t3, $t0, 0x80AA   # 0x10  $t3 = 0x55
        andi $t2, $t1, 0x80F0   # 0x14  $t2 = 0x80F0
        nor  $t4, $t0, $t1      # 0x18  $t4 = 0
        sw   $t3, 4($0)         # 0x1C  mem[4] = 0x55
        lw   $t5, 4($0)         # 0x20  $t5 = 0x55
        beq  $t0, $t1, fail1    # 0x24  not taken
        nop                     # 0x28
        nop                     # 0x2C
        nop                     # 0x30
        beq  $t3, $t5, taken    # 0x34  taken -> 0x48
        nop                     # 0x38
        nop                     # 0x3C
        nop                     # 0x40
        addi $t6, $0, 999       # 0x44  skipped
taken:  j    jump_lbl           # 0x48  -> 0x54
        nop                     # 0x4C
fail1:  addi $t6, $0, 888       # 0x50  skipped
jump_lbl:
        addi $t7, $t2, 16       # 0x54  $t7 = 0x8100
        nop                     # 0x58
        nop                     # 0x5C
        sw   $t7, 8($0)         # 0x60  mem[8] = 0x8100
