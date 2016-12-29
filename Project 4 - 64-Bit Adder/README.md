# Project 4 - 64-Bit Adder

## Objective

The group needed to design three different types of 64-bit adders that use various types of internal adder implementations:

- The first model of the 64-bit adder was designed using a structural gate-level implementation of a full adder linked together into a ripple-carry adder. 

- The second model was implemented using a structural gate-level implementation of a 2-bit look ahead adder combined together into a look ahead adder, which unlike the ripple adder version, allow for quicker computation, as each internal modular look ahead module is parallel in nature (although the overall structure is sequential). Each modular circuit is capable of taking 4 bits and summing them into a two bit output. 

- The last model was an abstracted implementation of a full adder written in a behavioral Verilog sense with no specific logic circuit design. 

For each implementation of the 64-bit adder, the group planned to test each type of adder with two tests: a small iterative method and a large sum. Test 1 sums together all possible combinations from 0 to 31 while Test 2 sums together two large 32-bit numbers. 

## Source Directories

- **Ripple Carry Adder** - /ripple_adder_64

- **2-Bit Look Ahead Adder** - /look_ahead_adder_64

- **Behavioral Adder** - /behavioral_adder_64