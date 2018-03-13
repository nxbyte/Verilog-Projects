`timescale 1ns / 1ps

/*
	Group Members: Nikita Eisenhauer and Warren Seto

	Lab Name: ARM LEGv8 CPU Testbench  (Single-Cycle) 
*/

module CPU_TEST;
  
  /* Clock Signal */
  reg CLOCK;
  
  /* Wires to connect instruction memory to CPU */
  wire [63:0] instructionPC;
  wire [31:0] instructionOut;
  
  /* Wires to connect registers to CPU */
  wire [4:0] READ_REG_1;
  wire [4:0] READ_REG_2;
  wire [4:0] WRITE_REG;
  wire [63:0] WRITE_DATA;
  wire [63:0] DATA_OUT_1;
  wire [63:0] DATA_OUT_2;
  
  /* Wires to connect Data Memory to CPU */
  wire [63:0] data_memory_out;
  wire [63:0] ALU_Result_Out;
  
  /* Wires to connect CPU Control Lines to Memories */
  wire CONTROL_REG2LOC;
  wire CONTROL_REGWRITE;
  wire CONTROL_MEMREAD;
  wire CONTROL_MEMWRITE;
  wire CONTROL_BRANCH;
  
  /* Instruction Memory Module */
  Instruction_Memory mem1 (
    instructionPC, 
    instructionOut
  );
  
  /* Registers Module */
  Registers mem2 (
    READ_REG_1, 
    READ_REG_2, 
    WRITE_REG, 
    WRITE_DATA, 
    CONTROL_REGWRITE, 
    DATA_OUT_1, 
    DATA_OUT_2
  );
  
  /* Data Memory Module */
  Data_Memory mem3 (
    ALU_Result_Out, 
    DATA_OUT_2, 
    CONTROL_MEMREAD, 
    CONTROL_MEMWRITE, 
    data_memory_out
  );
  
  /* CPU Module */
  ARM_CPU core (
    .CLOCK(CLOCK),
    .INSTRUCTION(instructionOut), 
    .PC(instructionPC), 
    .CONTROL_REG2LOC(CONTROL_REG2LOC), 
    .CONTROL_REGWRITE(CONTROL_REGWRITE), 
    .CONTROL_MEMREAD(CONTROL_MEMREAD),
    .CONTROL_MEMWRITE(CONTROL_MEMWRITE), 
    .CONTROL_BRANCH(CONTROL_BRANCH), 
    .READ_REG_1(READ_REG_1), 
    .READ_REG_2(READ_REG_2), 
    .WRITE_REG(WRITE_REG), 
    .REG_DATA1(DATA_OUT_1), 
    .REG_DATA2(DATA_OUT_2), 
    .ALU_Result_Out(ALU_Result_Out), 
    .data_memory_out(data_memory_out), 
    .WRITE_REG_DATA(WRITE_DATA)
  );
  
  /* Setup the clock */
  initial begin
    CLOCK = 1'b0;
    
    #30 $finish;
  end
  
  /* Toggle the clock */
  always begin
    #1 CLOCK = ~CLOCK;
  end
  
endmodule