`timescale 1ns / 1ps

/*
	Phase 1: Start to IDEX (Complete)
    Phase 2: IDEX to MEM/WB
    Phase 3: Full & Debugging/Testing
*/

module PC
  (
    input CLOCK,
    input [63:0] new_PC,
    output reg [63:0] PC_out
  );
  
    initial begin
      PC_out = 0;
    end
  
  always @(CLOCK) begin
  	PC_out <= new_PC;
  end
  
endmodule


module Add4
(
  input [63:0] PC,
  output reg [63:0] newPC
);
  
  always@(PC) begin
    newPC = PC + 4;
  end

endmodule


module SignExtend
(
  input [31:0] inputInstruction,
  output reg [63:0] outImmediate
);
  
    always @(inputInstruction) begin
      
      if (inputInstruction[31:26] == 6'b000101) begin // B
      
        outImmediate[25:0] = inputInstruction[25:0];
        outImmediate[63:26] = {64{outImmediate[25]}};
      
      end else if (inputInstruction[31:24] == 8'b10110100) begin // CBZ

        outImmediate[19:0] = inputInstruction[23:5];
        outImmediate[63:20] = {64{outImmediate[19]}};
        
      end else begin // D Type

        outImmediate[9:0] = inputInstruction[20:12];
        outImmediate[63:10] = {64{outImmediate[9]}};
      end
    end
  
endmodule


module Mux2
(
  input [4:0] read1,
  input [4:0] read2,
  input control_reg2loc,
  output reg [4:0] mux2reg_wire
);

  always @(read1, read2, control_reg2loc) begin
    
    case (control_reg2loc)
      

        
        1'b0 : begin
    mux2reg_wire <= read1;
        end
              1'b1 : begin
    mux2reg_wire <= read2;
        end
              default : begin
                mux2reg_wire <= 1'bx;
              end
    endcase
  end
  
endmodule


module IFID
(
  input [63:0] PC_in,
  input [31:0] IC_in,
  output reg [63:0] PC_out,
  output reg [31:0] IC_out
);
  
  always @(*) begin
    PC_out <= PC_in;
    IC_out <= IC_in;
  end
endmodule


module IDEX 
(
  input [1:0] aluop_in, 	// EX Stage
  input alusrc_in, 			// EX Stage
  input isZeroBranch_in, 	// M Stage
  input isUnconBranch_in, 	// M Stage
  input memRead_in, 		// M Stage
  input memwrite_in, 		// M Stage
  input regwrite_in, 		// WB Stage
  input mem2reg_in, 		// WB Stage
  input [63:0] PC_in,		
  input [63:0] regdata1_in,
  input [63:0] regdata2_in,

  output reg [1:0] aluop_out, 	// EX Stage
  output reg alusrc_out, 		// EX Stage
  output reg isZeroBranch_out, 	// M Stage
  output reg isUnconBranch_out, // M Stage
  output reg memRead_out, 		// M Stage
  output reg memwrite_out, 		// M Stage
  output reg regwrite_out,		// WB Stage
  output reg mem2reg_out,		// WB Stage
  output reg [63:0] PC_out,
  output reg [63:0] regdata1_out,
  output reg [63:0] regdata2_out 
);
  
  always @(*) begin
    /* Values for EX */
    aluop_out <= aluop_in;
	alusrc_out <= alusrc_in;
    
    /* Values for M */
  	isZeroBranch_out <= isZeroBranch_in;
    isUnconBranch_out <= isUnconBranch_in;
  	memRead_out <= memRead_in;
 	memwrite_out <= memwrite_in;
    
    /* Values for WB */
    regwrite_out <= regwrite_in;
  	mem2reg_out <= mem2reg_in;
    
    /* Values for all Stages */
    PC_out <= PC_in;
    regdata1_out <= regdata1_in;
    regdata2_out <= regdata2_in;
  end
endmodule


module Register
(
  input [4:0] read1,
  input [4:0] read2,
  output reg [63:0] data1,
  output reg [63:0] data2
);

  reg [63:0] Data[31:0];
  integer initCount;
  
  initial begin
    for (initCount = 0; initCount < 31; initCount = initCount + 1) begin
      Data[initCount] = initCount;
    end
	
    Data[31] = 64'h00000000;
  end
  
  always @(read1, read2) begin
    data1 = Data[read1];
    data2 = Data[read2];
  end
endmodule

module IC
(
  input [63:0] PC,
  output reg [31:0] Instruction
);
    
  reg [8:0] Data[63:0];
    
  initial begin

    // LDUR x2, [x10]
    Data[0] = 8'hF8;
    Data[1] = 8'h40;
    Data[2] = 8'h01;
    Data[3] = 8'h42;

    // LDUR x3, [x10, #1]
    Data[4] = 8'hF8;
    Data[5] = 8'h40;
    Data[6] = 8'h11;
    Data[7] = 8'h43;
    
    // SUB x4, x3, x2
    Data[8] = 8'hCB;
    Data[9] = 8'h02;
    Data[10] = 8'h00;
    Data[11] = 8'h64;

    // ADD x5, x3, x2
    Data[12] = 8'h8B;
    Data[13] = 8'h02;
    Data[14] = 8'h00;
    Data[15] = 8'h65;

    // CBZ x1, #2
    Data[16] = 8'hB4;
    Data[17] = 8'h00;
    Data[18] = 8'h00;
    Data[19] = 8'h41;

    // CBZ x0, #2
    Data[20] = 8'hB4;
    Data[21] = 8'h00;
    Data[22] = 8'h00;
    Data[23] = 8'h40;
	 
	 // LDUR x2 [x10]
    Data[24] = 8'hF8;
    Data[25] = 8'h40;
    Data[26] = 8'h01;
    Data[27] = 8'h42;

	 // ORR x6, x2, x3
    Data[28] = 8'hAA;
    Data[29] = 8'h03;
    Data[30] = 8'h00;
    Data[31] = 8'h46;

	 // AND x7, x2, x3
    Data[32] = 8'h8A;
    Data[33] = 8'h03;
    Data[34] = 8'h00;
    Data[35] = 8'h47;

    // STUR x4, [x7, #1]
    Data[36] = 8'hF8;
    Data[37] = 8'h00;
    Data[38] = 8'h10;
    Data[39] = 8'hE4;

	 // B #2
    Data[40] = 8'h14;
    Data[41] = 8'h00;
    Data[42] = 8'h00;
    Data[43] = 8'h03;

	 // LDUR x3, [x10, #1]
    Data[44] = 8'hF8;
    Data[45] = 8'h40;
    Data[46] = 8'h11;
    Data[47] = 8'h43;

	 // ADD x8, x0, x1
    Data[48] = 8'h8B;
    Data[49] = 8'h01;
    Data[50] = 8'h00;
    Data[51] = 8'h08;
  end
  
  always @(PC) begin
    Instruction[8:0] = Data[PC+3];
    Instruction[16:8] = Data[PC+2];
    Instruction[24:16] = Data[PC+1];
    Instruction[31:24] = Data[PC];
  end
endmodule


module Control
  (
    input [10:0] instruction,
    output reg control_reg2loc,
    output reg [1:0] control_aluop,
	output reg control_alusrc,
  	output reg control_isZeroBranch,
    output reg control_isUnconBranch,
  	output reg control_memRead,
 	output reg control_memwrite,
    output reg control_regwrite,
  	output reg control_mem2reg
  );
  
  always @(instruction) begin
    
    control_reg2loc <= 1'b1;
    
    /* B */
    if (instruction[10:5] == 6'b000101) begin // Control bits for B
      //$display("B");
      control_mem2reg <= 1'bx;
      control_memRead <= 1'b0;
      control_memwrite <= 1'b0;
      control_alusrc <= 1'b0;
      control_aluop <= 2'b01;
      control_isZeroBranch <= 1'b0;
      control_isUnconBranch <= 1'b1;
      control_regwrite <= 1'b0;
    end

    /* CBZ */
    else if (instruction[10:3] == 8'b10110100) begin // Control bits for CBZ
      //$display("CBZ");
      control_mem2reg <= 1'bx;
      control_memRead <= 1'b0;
      control_memwrite <= 1'b0;
      control_alusrc <= 1'b0;
      control_aluop <= 2'b01;
      control_isZeroBranch <= 1'b1;
      control_isUnconBranch <= 1'b0;
      control_regwrite <= 1'b0;
    end
    
    /* R-Type Instructions */
    else begin
      control_isZeroBranch <= 1'b0;
      control_isUnconBranch <= 1'b0;
      
      case (instruction[10:0])
        
        /* LDUR */
        11'b11111000010 : begin
          //$display("LDUR");
          control_mem2reg <= 1'b1;
          control_memRead <= 1'b1;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b1;
          control_aluop <= 2'b00;
          control_regwrite <= 1'b1;
          control_reg2loc <= 1'bx;
        end
        
        /* STUR */
        11'b11111000000 : begin
          //$display("STUR");
          control_mem2reg <= 1'bx;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b1;
          control_alusrc <= 1'b1;
          control_aluop <= 2'b00;
          control_regwrite <= 1'b0;
        end
        
        /* ADD */
        11'b10001011000 : begin
          //$display("ADD");
          control_mem2reg <= 1'b0;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b0;
          control_aluop <= 2'b10;
          control_regwrite <= 1'b1;
        end
        
        /* SUB */
        11'b11001011000 : begin
          //$display("SUB");
          control_mem2reg <= 1'b0;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b0;
          control_aluop <= 2'b10;
          control_regwrite <= 1'b1;
        end
        
        /* AND */
        11'b10001010000 : begin
          //$display("AND");
          control_mem2reg <= 1'b0;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b0;
          control_aluop <= 2'b10;
          control_regwrite <= 1'b1;
        end
        
        /* ORR */
        11'b10101010000 : begin
          //$display("ORR");
          control_mem2reg <= 1'b0;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b0;
          control_aluop <= 2'b10;
          control_regwrite <= 1'b1;
        end
        
        default : begin
          control_isZeroBranch <= 1'bx;
      	  control_isUnconBranch <= 1'bx;
          control_mem2reg <= 1'bx;
          control_memRead <= 1'bx;
          control_memwrite <= 1'bx;
          control_alusrc <= 1'bx;
          control_aluop <= 2'bxx;
          control_regwrite <= 1'bx;
          control_reg2loc <= 1'bx;
        end
      endcase
    end
  end
  
endmodule

    
module ARM_CPU
(
  input CLOCK,
  input [31:0] IC,
  output [63:0] PC_out
);
  
  wire [63:0] new_PC;
  Add4 plus1 (PC_out, new_PC);
  PC counter (CLOCK, new_PC, PC_out);
  
  wire [63:0] IFID_PC;
  wire [31:0] IFID_IC;
  IFID cache1 (PC_out, IC, IFID_PC, IFID_IC);

  wire [1:0] control_aluop;
  wire control_alusrc;
  wire control_isZeroBranch;
  wire control_isUnconBranch;
  wire control_memRead;
  wire control_memwrite;
  wire control_regwrite;
  wire control_mem2reg;
  wire control_reg2loc;
  Control maine (IFID_IC[31:21], control_reg2loc, control_aluop, control_alusrc, control_isZeroBranch, control_isUnconBranch, control_memRead, control_memwrite, control_regwrite, control_mem2reg);
  
  wire [4:0] temp_reg2_in;
  Mux2 laa(IFID_IC[20:16], IFID_IC[4:0], control_reg2loc, temp_reg2_in);
  
  wire [63:0] reg_data_1;
  wire [63:0] reg_data_2;
  Register inna(IFID_IC[9:5], temp_reg2_in, reg_data_1, reg_data_2);
  
  wire [1:0] IDEX_aluop;
  wire IDEX_alusrc;
  wire IDEX_isZeroBranch;
  wire IDEX_isUnconBranch;
  wire IDEX_memRead;
  wire IDEX_memwrite;
  wire IDEX_regwrite;
  wire IDEX_mem2reg;
  wire [63:0] IDEX_reg_data_1;
  wire [63:0] IDEX_reg_data_2;
  wire [63:0] IDEX_PC;
  IDEX cache2 (control_aluop, control_alusrc, control_isZeroBranch, control_isUnconBranch, control_memRead, control_memwrite, control_regwrite, control_mem2reg, IFID_PC, reg_data_1, reg_data_2,  IDEX_aluop, IDEX_alusrc, IDEX_isZeroBranch, IDEX_isUnconBranch, IDEX_memRead, IDEX_memwrite, IDEX_regwrite, IDEX_mem2reg, IDEX_PC, IDEX_reg_data_1, IDEX_reg_data_2);


  
  

  
  
  always @(IFID_IC) begin
    $display("%h = %b %b %b %b %b %b %b %b %d %d", IFID_IC, control_reg2loc, control_aluop, control_alusrc, control_isZeroBranch, control_isUnconBranch, control_memRead, control_memwrite, control_regwrite, control_mem2reg, IDEX_reg_data_1, IDEX_reg_data_2);
  end
  
  
  
  
  
  
  
  
  
  
  
  
endmodule