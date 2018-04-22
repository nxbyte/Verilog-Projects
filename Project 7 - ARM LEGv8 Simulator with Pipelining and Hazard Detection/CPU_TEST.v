`timescale 1ns / 1ps

module CPU_TEST;
  
  /* CPU Signals */
  reg RESET;
  reg CLOCK;
  
  /* Connect CPU to Instruction Memory */
  wire [63:0] PC_wire;
  wire [31:0] IC_wire;
  
  /* Connect CPU to Data Memory */
  wire [63:0] mem_address;
  wire [63:0] mem_data_in;
  wire control_memwrite;
  wire control_memread;
  wire [63:0] mem_data_out;
  
  ARM_CPU core (RESET, CLOCK, IC_wire, mem_data_out, PC_wire, mem_address, mem_data_in, control_memwrite, control_memread);
  IC mem1 (PC_wire, IC_wire);
  Data_Memory mem2 (mem_address, mem_data_in, control_memwrite, control_memread, mem_data_out);
  
  /* Setup the clock */
  initial begin
    CLOCK = 1'b0;
    RESET = 1'b1;
    #30 $finish;
  end
  
  /* Toggle the clock */
  always begin
    #1 CLOCK = ~CLOCK; RESET = 1'b0;
  end
  
endmodule