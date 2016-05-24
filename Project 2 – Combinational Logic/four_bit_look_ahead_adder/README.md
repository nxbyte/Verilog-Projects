# Four-Bit Look Ahead Adder

## Objective

This 4-bit look ahead adder is an improved implementation of a 4-bit ripple adder by eliminating the propagation delay found in the ripple 4-bit adder. For each output, this implementation computes each previous carry simultaneously instead of waiting for the previous adder block to yield a carry. In this adder, the first carry bit is set to zero and simplified the logic because there was no initial carry bit as the input. While this implementation uses more gates and more complex logic to accomplish the same task as the ripple adder, this implementation would add two 4-bit numbers faster than the ripple version.

## Waveforms

Simulation results from the Verilog representation of this Four-Bit Look Ahead Adder

![Project 2 Waveform for Four-Sixteen Decoder](/Project 2 – Combinational Logic/four_bit_look_ahead_adder/Simulation Waveforms/project2_four_bit_adder.png)

## Source Files
- **Four-Bit Look Ahead Adder Module** - four_bit_adder_EC.v
- **Four-Bit Look Ahead Adder Test Bench** - four_bit_adder_EC_test.v
