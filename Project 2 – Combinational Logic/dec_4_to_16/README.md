# Four-Sixteen Decoder

## Objective

This 4-to-16 decoder takes one 4-bit input and outputs a 16-bit representation of the input. This module uses the concept of one-hot decoding where each output would have one output that would correspond to the input. 

An application for this decoder would be to convert a 4-bit binary value to its hexadecimal representation. 

To verify this module, the binary bits of the input is converted into their decimal representation and compared to the output’s decimal representation to see if they match.

## Waveforms

Simulation results from the Verilog representation of this Four-Sixteen Decoder

![Project 2 Waveform for Four-Sixteen Decoder](/Project%202%20–%20Combinational%20Logic/dec_4_to_16/Simulation%20Waveforms/project2_416decoder.png)

## Source Files
- **Four-Sixteen Decoder Module** - dec_4_to_16.v
- **Four-Sixteen Decoder Test Bench** - dec_4_to_16_test.v
