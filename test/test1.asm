# Test program 1 (given in the handout)
# expected: $t0=5 $t1=10 $t2=15 $t3=5 $t4=0 $t5=15 $t6=15 $t7=40 $s0=5 $s1=5

        addi $t0, $0, 5         # 0x00
        addi $t1, $0, 10        # 0x04
        nop                     # 0x08
        nop                     # 0x0C
        add  $t2, $t0, $t1      # 0x10  $t2 = 15
        sub  $t3, $t1, $t0      # 0x14  $t3 = 5
        and  $t4, $t0, $t1      # 0x18  $t4 = 0
        or   $t5, $t0, $t1      # 0x1C  $t5 = 15
        xor  $t6, $t0, $t1      # 0x20  $t6 = 15
        sll  $t7, $t1, 2        # 0x24  $t7 = 40
        srl  $s0, $t1, 1        # 0x28  $s0 = 5
        sra  $s1, $t1, 1        # 0x2C  $s1 = 5
