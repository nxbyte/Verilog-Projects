`timescale 1ns / 1ps

/*
	Group Members: Nikita Eisenhauer and Warren Seto

	Lab Name: ARM LEGv8 CPU Design (Single-Cycle) 
*/

module ARM_CPU
(
  input CLOCK,
  input [31:0] INSTRUCTION,
  input [63:0] REG_DATA1,
  input [63:0] REG_DATA2,
  input [63:0] data_memory_out,
  output reg CONTROL_REG2LOC,
  output reg CONTROL_REGWRITE,
  output reg CONTROL_MEMREAD,
  output reg CONTROL_MEMWRITE,
  output reg CONTROL_BRANCH,
  output reg [4:0] READ_REG_1,
  output [4:0] READ_REG_2,
  output reg [4:0] WRITE_REG,
  output [63:0] ALU_Result_Out,
  output [63:0] WRITE_REG_DATA,
  output reg [63:0] PC
);
  
  reg [4:0] tempRegNum1;
  reg [4:0] tempRegNum2;
  reg [10:0] tempInstruction;
  
  reg CONTROL_MEM2REG;
  reg CONTROL_ALUSRC;
  reg CONTROL_UNCON_BRANCH;
  reg [1:0] CONTROL_ALU_OP;
  
  wire tempALUZero;
  wire[3:0] tempALUControl;
  wire[63:0] tempALUInput2;
  wire[63:0] tempImmediate;
  wire [63:0] tempShiftImmediate;
  
  wire [63:0] nextnextPC;
  reg CONTROL_JUMP;
  wire [63:0] nextPC; 
  wire nextPCZero;
  wire [63:0] shiftPC;
  wire shiftPCZero;
  reg tempBranchZero;
  
  /* Multiplexer for the Program Counter */
  PCMux mux1(nextPC, shiftPC, CONTROL_JUMP, nextnextPC);
  
  /* Multiplexer before the Register */
  RegisterMux mux2(tempRegNum1, tempRegNum2, CONTROL_REG2LOC, READ_REG_2);

  /* Multiplexer before the ALU */
  ALUMux mux3(REG_DATA2, tempImmediate, CONTROL_ALUSRC, tempALUInput2);
  
  /* Multiplexer after the Data memory */
  DataMemMux mux4(data_memory_out, ALU_Result_Out, CONTROL_MEM2REG, WRITE_REG_DATA);
  
  /* Sign Extention Module */
  SignExtend mod1(INSTRUCTION, tempImmediate);
  
  /* Shift left by two module */
  ShiftLeft2 mod2(tempImmediate, tempShiftImmediate);
  
  /* ALU Control for the ALU */
  ALU_Control mod3(CONTROL_ALU_OP, tempInstruction, tempALUControl);
 
  /* ALU Result between the Registers and the Data Memory */
  ALU aluResult(REG_DATA1, tempALUInput2, tempALUControl, ALU_Result_Out, tempALUZero);

  /* An ALU module to calulcate the next sequential PC */
  ALU adderNextPC(PC, 64'h00000004, 4'b0010, nextPC, nextPCZero);
  
  /* An ALU module to calulcate a shifted PC */
  ALU adderShiftPC(PC, tempShiftImmediate, 4'b0010, shiftPC, shiftPCZero);
  
  
  /* Initialize when the CPU is first run */
  initial begin
    PC = 0;
    
    CONTROL_REG2LOC = 1'bz;
    CONTROL_MEM2REG = 1'bz;
    CONTROL_REGWRITE = 1'bz;
    CONTROL_MEMREAD = 1'bz;
    CONTROL_MEMWRITE = 1'bz;
    CONTROL_ALUSRC = 1'bz;
    CONTROL_BRANCH = 1'b0;
    CONTROL_UNCON_BRANCH = 1'b0;
    
    tempBranchZero = tempALUZero & CONTROL_BRANCH;
    CONTROL_JUMP = CONTROL_UNCON_BRANCH | tempBranchZero;
    
  end

  /* Parse and set the CPU's Control bits */
  always @(posedge CLOCK or INSTRUCTION) begin

    // Set the PC to the jumped value
    if (CONTROL_JUMP == 1'b1) begin
      PC = #1 nextnextPC - 4;
    end

	 /* Parse the incoming instruction for a given PC */
    tempInstruction = INSTRUCTION[31:21];
    tempRegNum1 = INSTRUCTION[20:16];
    tempRegNum2 = INSTRUCTION[4:0];
	 READ_REG_1 = INSTRUCTION[9:5];
    WRITE_REG = INSTRUCTION[4:0];

    if (INSTRUCTION[31:26] == 6'b000101) begin // Control bits for B
      
      CONTROL_REG2LOC = 1'b0;
      CONTROL_MEM2REG = 1'b0;
      CONTROL_REGWRITE = 1'b0;
      CONTROL_MEMREAD = 1'b0;
      CONTROL_MEMWRITE = 1'b0;
      
      CONTROL_ALUSRC = 1'b0;
      CONTROL_ALU_OP = 2'b01;
      CONTROL_BRANCH = 1'b0;
      CONTROL_UNCON_BRANCH = 1'b1;
      
    end else if (INSTRUCTION[31:24] == 8'b10110100) begin // Control bits for CBZ

      CONTROL_REG2LOC = 1'b0;
      CONTROL_MEM2REG = 1'b0;
      CONTROL_REGWRITE = 1'b0;
      CONTROL_MEMREAD = 1'b0;
      CONTROL_MEMWRITE = 1'b0;
      
      CONTROL_ALUSRC = 1'b0;
      CONTROL_ALU_OP = 2'b01;
      CONTROL_BRANCH = 1'b1;
      CONTROL_UNCON_BRANCH = 1'b0;
      
    end else begin // R-Type Control Bits
      
      CONTROL_BRANCH = 1'b0;
      CONTROL_UNCON_BRANCH = 1'b0;
      
      case (tempInstruction)
        11'b11111000010 : begin // Control bits for LDUR
 
          CONTROL_REG2LOC = 1'bx;
          CONTROL_MEM2REG = 1'b1;
          CONTROL_REGWRITE = 1'b1;
          CONTROL_MEMREAD = 1'b1;
          CONTROL_MEMWRITE = 1'b0;
          CONTROL_ALUSRC = 1'b1;
          CONTROL_ALU_OP = 2'b00;
        end
        
        11'b11111000000 : begin //Control bits for STUR
          
          // Control Bits
          CONTROL_REG2LOC = 1'b1;
          CONTROL_MEM2REG = 1'bx;
          CONTROL_REGWRITE = 1'b0;
          CONTROL_MEMREAD = 1'b0;
          CONTROL_MEMWRITE = 1'b1;
          CONTROL_ALUSRC = 1'b1;
          CONTROL_ALU_OP = 2'b00;
        end
        
        11'b10001011000 : begin //Control bits for ADD
          
          CONTROL_REG2LOC = 1'b0;
          CONTROL_MEM2REG = 1'b0;
          CONTROL_REGWRITE = 1'b1;
          CONTROL_MEMREAD = 1'b0;
          CONTROL_MEMWRITE = 1'b0;
          CONTROL_ALUSRC = 1'b0;
          CONTROL_ALU_OP = 2'b10;
        end
        
        11'b11001011000 : begin //Control bits for SUB

          CONTROL_REG2LOC = 1'b0;
          CONTROL_MEM2REG = 1'b0;
          CONTROL_REGWRITE = 1'b1;
          CONTROL_MEMREAD = 1'b0;
          CONTROL_MEMWRITE = 1'b0;
          CONTROL_ALUSRC = 1'b0;
          CONTROL_ALU_OP = 2'b10;
        end
        
        11'b10001010000 : begin //Control bits for AND

          CONTROL_REG2LOC = 1'b0;
          CONTROL_MEM2REG = 1'b0;
          CONTROL_REGWRITE = 1'b1;
          CONTROL_MEMREAD = 1'b0;
          CONTROL_MEMWRITE = 1'b0;
          CONTROL_ALUSRC = 1'b0;
          CONTROL_ALU_OP = 2'b10;
        end
        
        11'b10101010000 : begin //Control bits for ORR
          
          CONTROL_REG2LOC = 1'b0;
          CONTROL_MEM2REG = 1'b0;
          CONTROL_REGWRITE = 1'b1;
          CONTROL_MEMREAD = 1'b0;
          CONTROL_MEMWRITE = 1'b0;
          CONTROL_ALUSRC = 1'b0;
          CONTROL_ALU_OP = 2'b10;
        end
      endcase
    end
    
	 /* Determine whether to branch */
    tempBranchZero = tempALUZero & CONTROL_BRANCH;
    CONTROL_JUMP = CONTROL_UNCON_BRANCH | tempBranchZero;

	 /* For non-branch code, set the next sequential PC value */
    if (CONTROL_JUMP == 1'b0) begin
    	PC <= #1 nextnextPC;
    end
  end
endmodule

module PCMux
(
  input [63:0] pcInput,
  input [63:0] shiftInput,
  input CONTROL_JUMP,
  output reg [63:0] pcOut
);
  
  always @(pcInput, shiftInput, CONTROL_JUMP, pcOut) begin
    if (CONTROL_JUMP == 0) begin
      pcOut = pcInput;
    end
    
    else begin
      pcOut = shiftInput;
    end
  end
  
endmodule



module RegisterMux
(
  input [4:0] input1,
  input [4:0] input2,
  input CONTROL_REG2LOC,
  output reg [4:0] muxOutput
);
    
  always @(input1, input2, CONTROL_REG2LOC) begin
    
    if (CONTROL_REG2LOC == 0) begin
      muxOutput = input1;
    end
    
    else begin
      muxOutput = input2;
    end 
  end
endmodule


module ALUMux
(
  input [63:0] input1,
  input [63:0] input2,
  input CONTROL_ALUSRC,
  output reg [63:0] out
);
  
  always @(input1, input2, CONTROL_ALUSRC, out) begin
    
    if (CONTROL_ALUSRC == 0) begin
      out = input1;
    end
    
    else begin
      out = input2;
    end 
  end
  
endmodule


module DataMemMux
(
  input [63:0] readData,
  input [63:0] aluOutput,
  input CONTROL_MEM2REG,
  output reg [63:0] out
);
  
  always @(readData, aluOutput, CONTROL_MEM2REG, out) begin
    if (CONTROL_MEM2REG == 0) begin
      out = aluOutput;
    end
    
    else begin
      out = readData;
    end
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


module ShiftLeft2
(
  input [63:0] inputData,
  output reg [63:0] outputData
);
  
  always @(inputData) begin
    outputData = inputData << 2;
  end
  
endmodule

module ALU_Control
(
  input [1:0] ALU_Op,
  input [10:0] ALU_INSTRUCTION,
  output reg [3:0] ALU_Out
);

  always @(ALU_Op or ALU_INSTRUCTION) begin
    
    case (ALU_Op)
      2'b00 : ALU_Out = 4'b0010;
      2'b01 : ALU_Out = 4'b0111;
      2'b10 : begin
       
        case (ALU_INSTRUCTION)
          11'b10001011000 : ALU_Out = 4'b0010; // ADD
          11'b11001011000 : ALU_Out = 4'b0110; // SUB
          11'b10001010000 : ALU_Out = 4'b0000; // AND
          11'b10101010000 : ALU_Out = 4'b0001; // ORR
        endcase
        
      end
    endcase
    
  end
  
endmodule


module ALU
(
  input [63:0] A,
  input [63:0] B,
  input [3:0] CONTROL,
  output reg [63:0] RESULT,
  output reg ZEROFLAG
);
  
  always @(A or B or CONTROL) begin
    case (CONTROL)
      4'b0000 : RESULT = A & B;
      4'b0001 : RESULT = A | B;
      4'b0010 : RESULT = A + B;
      4'b0110 : RESULT = A - B;
      4'b0111 : RESULT = B;
      4'b1100 : RESULT = ~(A | B);
    endcase

    if (RESULT == 0) begin
      ZEROFLAG = 1'b1;
    end else begin
      ZEROFLAG = 1'b0;
    end
  end
  
endmodule


module Instruction_Memory
(
  input [63:0] PC,
  output reg [31:0] CPU_Instruction
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
    
    CPU_Instruction[8:0] = Data[PC+3];
    CPU_Instruction[16:8] = Data[PC+2];
    CPU_Instruction[24:16] = Data[PC+1];
    CPU_Instruction[31:24] = Data[PC];
	 
  end
  
endmodule


module Registers
(
  input [4:0] read1,
  input [4:0] read2,
  input [4:0] writeReg,
  input [63:0] writeData,
  input CONTROL_REGWRITE,
  output reg [63:0] data1,
  output reg [63:0] data2
);

  reg [63:0] Data[31:0];

  integer initCount;
  
  initial begin
  
    for (initCount = 0; initCount < 31; initCount = initCount + 1) begin
      Data[initCount] = initCount;
    end
	
    Data[31] = 64’h00000000;
 
  end
  
  always @(read1, read2, writeReg, writeData, CONTROL_REGWRITE) begin

    data1 = Data[read1];
    data2 = Data[read2];

    if (CONTROL_REGWRITE == 1) begin
      Data[writeReg] = writeData;
    end
  end
  
endmodule

module Data_Memory
(
  input [63:0] inputAddress,
  input [63:0] inputData,
  input CONTROL_MemRead,
  input CONTROL_MemWrite,
  output reg [63:0] outputData
);

  reg [63:0] Data[31:0];
  
  integer initCount;
  
  initial begin
    for (initCount = 0; initCount < 32; initCount = initCount + 1) begin
      Data[initCount] = initCount * 100;
    end
	 
	 Data[10] = 1540;
	 Data[11] = 2117;
  end
  
    always @(inputAddress, inputData, CONTROL_MemRead, CONTROL_MemWrite) begin
      if (CONTROL_MemWrite == 1) begin

           Data[inputAddress] = inputData;
      end
      if (CONTROL_MemRead == 1) begin
           outputData = Data[inputAddress];
      end
    end
endmodule
