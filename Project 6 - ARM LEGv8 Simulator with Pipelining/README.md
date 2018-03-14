# Project 6 - ARM LEGv8 Simulator with Pipelining

## Objective

This functional multi-cycle/pipelined (not hazard protected) processor is capable of performing basic arithmetic, logic and data operations. It is based on the ARM 64-bit architecture, with 32 registers each 64-bits wide with instruction lengths of 32-bits. 

Basic assembly instructions: ``LDUR``, ``STUR``, ``ADD``, ``SUB``, ``ORR``, ``AND``, ``CBZ`` and ``B`` are supported by the CPU, with ``LDUR`` and ``STUR`` supporting immediate values when performing certain operations to the registers module.

In this version of the ARM CPU, the processor is pipelined to allow multiple instructions to run simultaneously. This is made possible with the addition of buffers/caches in between each stage of the processor's operation. This optimization reduces the amount of time to run each instruction; however, it does not protect against atomic reads in between register-base instructions. This flaw (hazard) will be addressed in the next revision of the processor (Project 7).

During development, the group wrote a sample program (in ARMv7 assembly) and tested it on a Cypress PSoC 5LP and recorded its registers after each instruction. The group then verified this custom CPU with the state of the registers from the Cypress PSoC 5LP.

When working with the unconditional branch, instead of a written label the tested instruction use immediate values to where the location of memory where the program counter will branch to. 

Since the ARM CPU is little endian, the instruction memory in this project is designed to have 64 8-bits for each index. 

The Data Memory is made up of 31 64-bit values to show that the values could be accessed and stored via the CPU. 

With the instruction memory, data memory and registers located outside the CPU itself, the project could be incrementally tested and treated as independent components on a physical board. 

## Supported ISA

The examples below use the following 'variables' to show off the functionaility for each instruction:

- ``r#``: Register # in the CPU (From 0 to 31)
- ``RAM``: Random Access Memory (RAM) or Data Memory
- ``PC``: Program Counter

### LDUR: Load RAM into Registers

Example 1: ``LDUR r2, [r10]``

- Sudo-C code: ``r2 = RAM[r10]``
- Explanation: Retrieve the value in memory at location ``r10`` and put that value into register ``r2``

Example 2: ``LDUR r3, [r10, #1]``

- Sudo-C code: ``r3 = RAM[r10 + 1]``
- Explanation: Retrieve the value in memory at the location ``r10 + immediate (1)`` and put that value into register ``r3``

### STUR: Store Registers into RAM

Example 1: ``STUR r1, [r9]``

- Sudo-C code: ``RAM[r9] = r1``
- Explanation: Store the value of ``r1`` into memory at the location ``r9``

Example 2: ``STUR r4, [r7, #1]``

- Sudo-C code: ``RAM[r7 + 1] = r4``
- Explanation: Store the value of ``r4`` into memory at the location ``r7 + immediate (1)``

### ADD: Add Registers

Example: ``ADD r5, r3, r2``

- Sudo-C code: ``r5 = r3 + r2``
- Explanation: Add the values of ``r3`` and ``r2`` then put the result into ``r5``

*Note: This does not support immediate values. Only values within the registers!*

### SUB: Subtract Registers

Example: ``SUB r4, r3, r2``

- Sudo-C code: ``r4 = r3 - r2``
- Explanation: Subtract the values of ``r3`` and ``r2``  then put the result into ``r4``

*Note: This does not support immediate values. Only values within the registers!*

### ORR: Bit-wise OR Registers

Example: ``ORR r6, r2, r3``

- Sudo-C code: ``r6 = r2 | r3``
- Explanation: Bit-wise OR the values of ``r2`` and ``r3`` then put the result into ``r6``

*Note: This does not support immediate values. Only values within the registers!*

### AND: Bit-wise AND Registers

Example: ``AND r4, r3, r2``

- Sudo-C code: ``r4 = r3 & r2``
- Explanation: Bit-wise AND the values of ``r3`` and ``r2`` and put the result into ``r4``

*Note: This does not support immediate values. Only values within the registers!*

### CBZ: Conditional Jump (when the value in Register is zero)

Example: ``CBZ r1, #2``

- Sudo-C code: ``if (r1 == 0) { PC = PC + 2 } else { PC++ }``
- Explanation: If the value of ``r1`` is zero then jump two instructions, otherwise, continue executing ``PC++``

### B: Unconditional (arbitrary) Jump

Example: ``B #2``

- Sudo-C: ``PC = PC + 2``
- Explanation: Jump two instructions

## Source Directories

- **ARM LEGv8 CPU Module** - ARM_CPU.v

- **ARM LEGv8 Testbench** - CPU_TEST.v
