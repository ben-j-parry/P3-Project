jumps have been completed

only 6 instructions remain
these are the branches and should fall like dominos

notable issues:

byte addressing in the program counter - would be good if the pc would increment by 4

load instructions - they currently take 2 copies of a load instructions, would be good if i can change this so the load instructions are multicycle
			  implement a pipeline register here perhaps for if there is a load instruction?

sign extension - may be missing sign extension in some places such as ALU

the immediate bits of jal have been changed - not a major issue especially as i have to make my own machine code


https://riscvasm.lucasteske.dev/#
JAL is not functional on this website

20 bit imm, 5 bit rd, 7 bit opcode
easy peasy