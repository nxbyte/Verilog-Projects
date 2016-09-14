# Priority Encoder

## Objective

This priority encoder takes one 4-bit input and outputs the binary representation of the index of the active input bit with the highest priority. Also, the module will indicate if the output generated is valid by toggling the valid bit, VLD. This solves the issue of having two inputs active at the same time by having the input of the highest priority take precedence.

## Waveforms

Simulation results from the Verilog representation of this Priority Encoder

![Project 2 Waveform for Priority Encoder](/Project 2 – Combinational Logic/priority_encoder/Simulation Waveforms/project2_priority_encoder.png)

## Source Files
- **Priority Encoder Module** - priority_encoder.v
- **Priority Encoder Test Bench** - priority_encoder_test.v
