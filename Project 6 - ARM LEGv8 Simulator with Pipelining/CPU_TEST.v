`timescale 1ns / 1ps

module CPU_TEST;
  
  /* Clock Signal */
  reg CLOCK;
  
  wire [63:0] PC_wire;
  wire [31:0] IC_wire;
  
  ARM_CPU core (CLOCK, IC_wire, PC_wire);
  
  IC RAM1 (PC_wire, IC_wire);
  
  /* Setup the clock */
  initial begin
    CLOCK = 1'b0;
    
    #13 $finish;
  end
  
  /* Toggle the clock */
  always begin
    #1 CLOCK = ~CLOCK;
  end
  
endmodule