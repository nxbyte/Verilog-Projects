`timescale 1ns / 1ps

/*
    Group Members: Luis Calderon and Warren Seto

    Lab Name: Introduction to Xilinx (Lab 1)
    Project Name: eng312_proj1
    Design Name: half_adder
    Design Description: Verilog Code for a half-adder
*/

// Input & Output components to use in the half-adder
module half_adder
(
  input iA,
  input iB,
  output oSUM,
  output oCARRY
);

  // This uses an exclusive OR gate to find the SUM of two inputs
  assign oSUM = iA ^ iB;

  // This uses an AND gate to find the CARRY of two inputs
  assign oCARRY = iA & iB;
endmodule
