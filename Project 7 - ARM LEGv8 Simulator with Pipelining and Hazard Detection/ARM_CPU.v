`timescale 1ns / 1ps

module ARM_CPU
(
  input RESET,
  input CLOCK,
  input [31:0] IC,
  input [63:0] mem_data_in,
  output reg [63:0] PC,
  output [63:0] mem_address_out,
  output [63:0] mem_data_out,
  output control_memwrite_out,
  output control_memread_out
);
	wire Hazard_PCWrite;
	wire Hazard_IFIDWrite;

	always @(posedge CLOCK) begin
		if (Hazard_PCWrite !== 1'b1) begin
			 if (PC === 64'bx) begin
				PC <= 0;
			 end else if (PCSrc_wire == 1'b1) begin
				PC <= jump_PC_wire;
			 end else begin
				PC <= PC + 4;
		end
	 end
	end
  
  /* Stage : Instruction Fetch */
  wire PCSrc_wire;
  wire [63:0] jump_PC_wire;
  wire [63:0] IFID_PC;
  wire [31:0] IFID_IC;
  IFID cache1 (CLOCK, PC, IC, Hazard_IFIDWrite, IFID_PC, IFID_IC);


  /* Stage : Instruction Decode */
  wire IDEX_memRead;
  wire [4:0] IDEX_write_reg;
  wire Control_mux_wire;
  HazardDetection moda (IDEX_memRead, IDEX_write_reg, IFID_PC, IFID_IC, Hazard_IFIDWrite, Hazard_PCWrite, Control_mux_wire);
  
  wire [1:0] CONTROL_aluop; // EX
  wire CONTROL_alusrc; // EX
  wire CONTROL_isZeroBranch; // M
  wire CONTROL_isUnconBranch; // M
  wire CONTROL_memRead; // M
  wire CONTROL_memwrite; // M
  wire CONTROL_regwrite; // WB
  wire CONTROL_mem2reg; // WB
  ARM_Control unit1 (IFID_IC[31:21], CONTROL_aluop, CONTROL_alusrc, CONTROL_isZeroBranch, CONTROL_isUnconBranch, CONTROL_memRead, CONTROL_memwrite, CONTROL_regwrite, CONTROL_mem2reg);
  
  wire [1:0] CONTROL_aluop_wire; // EX
  wire CONTROL_alusrc_wire; // EX
  wire CONTROL_isZeroBranch_wire; // M
  wire CONTROL_isUnconBranch_wire; // M
  wire CONTROL_memRead_wire; // M
  wire CONTROL_memwrite_wire; // M
  wire CONTROL_regwrite_wire; // WB
  wire CONTROL_mem2reg_wire; // WB
  Control_Mux maaa (CONTROL_aluop, CONTROL_alusrc, CONTROL_isZeroBranch, CONTROL_isUnconBranch, CONTROL_memRead, CONTROL_memwrite, CONTROL_regwrite, CONTROL_mem2reg, Control_mux_wire, CONTROL_aluop_wire, CONTROL_alusrc_wire, CONTROL_isZeroBranch_wire, CONTROL_isUnconBranch_wire, CONTROL_memRead_wire, CONTROL_memwrite_wire, CONTROL_regwrite_wire, CONTROL_mem2reg_wire);
  
  wire [4:0] reg2_wire;
  ID_Mux unit2(IFID_IC[20:16], IFID_IC[4:0], IFID_IC[28], reg2_wire);
  
  wire [63:0] reg1_data, reg2_data;
  wire MEMWB_regwrite;
  wire [4:0] MEMWB_write_reg;
  wire [63:0] write_reg_data;
  Registers unit3(CLOCK, IFID_IC[9:5], reg2_wire, MEMWB_write_reg, write_reg_data, MEMWB_regwrite, reg1_data, reg2_data);
   
  wire [63:0] sign_extend_wire;
  SignExtend unit4 (IFID_IC, sign_extend_wire);
  
  wire [1:0] IDEX_aluop;
  wire IDEX_alusrc;
  wire IDEX_isZeroBranch;
  wire IDEX_isUnconBranch;
  wire IDEX_memwrite;
  wire IDEX_regwrite;
  wire IDEX_mem2reg;
  wire [63:0] IDEX_reg1_data;
  wire [63:0] IDEX_reg2_data;
  wire [63:0] IDEX_PC;
  wire [63:0] IDEX_sign_extend;
  wire [10:0] IDEX_alu_control;
  wire [4:0] IDEX_forward_reg1;
  wire [4:0] IDEX_forward_reg2;
  IDEX cache2 (CLOCK, CONTROL_aluop_wire, CONTROL_alusrc_wire, CONTROL_isZeroBranch_wire, CONTROL_isUnconBranch_wire, CONTROL_memRead_wire, CONTROL_memwrite_wire, CONTROL_regwrite_wire, CONTROL_mem2reg_wire, IFID_PC, reg1_data, reg2_data, sign_extend_wire, IFID_IC[31:21], IFID_IC[4:0], IFID_IC[9:5], reg2_wire, IDEX_aluop, IDEX_alusrc, IDEX_isZeroBranch, IDEX_isUnconBranch, IDEX_memRead, IDEX_memwrite, IDEX_regwrite, IDEX_mem2reg, IDEX_PC, IDEX_reg1_data, IDEX_reg2_data, IDEX_sign_extend, IDEX_alu_control, IDEX_write_reg, IDEX_forward_reg1, IDEX_forward_reg2);


  /* Stage : Execute */
  wire [63:0] shift_left_wire;
  wire [63:0] PC_jump;
  wire jump_is_zero;
  Shift_Left unit5 (IDEX_sign_extend, shift_left_wire);
  ALU unit6 (IDEX_PC, shift_left_wire, 4'b0010, PC_jump, jump_is_zero);

  wire [4:0] EXMEM_write_reg;
  wire EXMEM_regwrite;
  wire EXMEM_mem2reg;
  wire [1:0] Forward_A;
  wire [1:0] Forward_B;
  ForwardingUnit modd (IDEX_forward_reg1, IDEX_forward_reg2, EXMEM_write_reg, MEMWB_write_reg, EXMEM_regwrite, MEMWB_regwrite, Forward_A, Forward_B);

  wire [63:0] alu_1_wire;
  Forward_ALU_Mux lal1 (IDEX_reg1_data, write_reg_data, mem_address_out, Forward_A, alu_1_wire);
  
  wire [63:0] alu_2_wire;
  Forward_ALU_Mux lal2 (IDEX_reg2_data, write_reg_data, mem_address_out, Forward_B, alu_2_wire);
  
  wire [3:0] alu_main_control_wire;
  ALU_Control unit7(IDEX_aluop, IDEX_alu_control, alu_main_control_wire);
  
  wire [63:0] alu_data2_wire;
  ALU_Mux mux3(alu_2_wire, IDEX_sign_extend, IDEX_alusrc, alu_data2_wire);
  
  wire alu_main_is_zero;
  wire [63:0] alu_main_result;
  ALU main_alu(alu_1_wire, alu_data2_wire, alu_main_control_wire, alu_main_result, alu_main_is_zero);
  
  wire EXMEM_isZeroBranch;
  wire EXMEM_isUnconBranch;
  wire EXMEM_alu_zero;
  EXMEM cache3(CLOCK, IDEX_isZeroBranch, IDEX_isUnconBranch, IDEX_memRead, IDEX_memwrite, IDEX_regwrite, IDEX_mem2reg, PC_jump, alu_main_is_zero, alu_main_result, IDEX_reg2_data, IDEX_write_reg, EXMEM_isZeroBranch, EXMEM_isUnconBranch, control_memread_out, control_memwrite_out, EXMEM_regwrite, EXMEM_mem2reg, jump_PC_wire, EXMEM_alu_zero, mem_address_out, mem_data_out, EXMEM_write_reg);
  
  
  /* Stage : Memory */
  Branch unit8 (EXMEM_isUnconBranch, EXMEM_isZeroBranch, EXMEM_alu_zero, PCSrc_wire);
  
  wire [63:0] MEMWB_address;
  wire [63:0] MEMWB_read_data;
  MEMWB cache4(CLOCK, mem_address_out, mem_data_in, EXMEM_write_reg, EXMEM_regwrite, EXMEM_mem2reg, MEMWB_address, MEMWB_read_data, MEMWB_write_reg, MEMWB_regwrite, MEMWB_mem2reg);


  /* Stage : Writeback */
  WB_Mux unit9 (MEMWB_address, MEMWB_read_data, MEMWB_mem2reg, write_reg_data);
endmodule


module ForwardingUnit
(
	input [4:0] EX_Rn_in,
	input [4:0] EX_Rm_in,
	input [4:0] MEM_Rd_in,
	input [4:0] WB_Rd_in,
	input MEM_regwrite_in,
	input WB_regwrite_in,
	output reg [1:0] A_out,
	output reg [1:0] B_out
);
  always @(*) begin
		if ((WB_regwrite_in == 1'b1) && 
				(WB_Rd_in !== 31) && 
			/*	(!((MEM_regwrite_in == 1'b1) && (MEM_Rd_in !== 31) && (MEM_Rd_in !== EX_Rn_in))) && */
				(WB_Rd_in === EX_Rn_in)) begin
			A_out <= 2'b01;
		end else if ((MEM_regwrite_in == 1'b1) && 
				(MEM_Rd_in !== 31) && 
				(MEM_Rd_in === EX_Rn_in)) begin
			A_out <= 2'b10;
		end else begin
			A_out <= 2'b00;
		end
			
		if ((WB_regwrite_in == 1'b1) && 
				(WB_Rd_in !== 31) && 
			/*	(!((MEM_regwrite_in == 1'b1) && (MEM_Rd_in !== 31) && (MEM_Rd_in !== EX_Rm_in))) && */
				(WB_Rd_in === EX_Rm_in)) begin
			B_out <= 2'b01;
		end else if ((MEM_regwrite_in == 1'b1) && 
				(MEM_Rd_in !== 31) && 
				(MEM_Rd_in === EX_Rm_in)) begin
			B_out <= 2'b10;
		end else begin
			B_out <= 2'b00;
		end
  end
endmodule


module HazardDetection
(
	input EX_memRead_in,
	input [4:0] EX_write_reg,
	input [63:0] ID_PC,
	input [31:0] ID_IC,
	output reg IFID_write_out,
	output reg PC_Write_out,
	output reg Control_mux_out
);
	always @(*) begin
		if (EX_memRead_in == 1'b1 && ((EX_write_reg === ID_IC[9:5]) || (EX_write_reg === ID_IC[20:16]))) begin
			IFID_write_out <= 1'b1;
			PC_Write_out <= 1'b1;
			Control_mux_out <= 1'b1;
		end else begin
			IFID_write_out <= 1'b0;
			PC_Write_out <= 1'b0;
			Control_mux_out <= 1'b0;
		end
		
	end
endmodule


module IFID
(
  input CLOCK,
  input [63:0] PC_in,
  input [31:0] IC_in,
  input Hazard_in,
  output reg [63:0] PC_out,
  output reg [31:0] IC_out
);
	always @(negedge CLOCK) begin
		if (Hazard_in !== 1'b1) begin
			PC_out <= PC_in;
			IC_out <= IC_in;
		end
  end
endmodule
  
  
module IDEX 
(
  input CLOCK,
  input [1:0] aluop_in,
  input alusrc_in,
  input isZeroBranch_in,
  input isUnconBranch_in,
  input memRead_in,
  input memwrite_in,
  input regwrite_in,
  input mem2reg_in,
  input [63:0] PC_in,		
  input [63:0] regdata1_in,
  input [63:0] regdata2_in,
  input [63:0] sign_extend_in,
  input [10:0] alu_control_in,
  input [4:0] write_reg_in,
  input [4:0] forward_reg_1_in,		// Forwarding
  input [4:0] forward_reg_2_in,		// Forwarding
  output reg [1:0] aluop_out,
  output reg alusrc_out,
  output reg isZeroBranch_out,
  output reg isUnconBranch_out,
  output reg memRead_out,
  output reg memwrite_out,
  output reg regwrite_out,
  output reg mem2reg_out,
  output reg [63:0] PC_out,
  output reg [63:0] regdata1_out,
  output reg [63:0] regdata2_out,
  output reg [63:0] sign_extend_out,
  output reg [10:0] alu_control_out,
  output reg [4:0] write_reg_out,
  output reg [4:0] forward_reg_1_out,		// Forwarding
  output reg [4:0] forward_reg_2_out		// Forwarding
);
  always @(negedge CLOCK) begin
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
    
    /* Values for variable stages */
    sign_extend_out <= sign_extend_in;
  	 alu_control_out <= alu_control_in;
  	 write_reg_out <= write_reg_in;
	 forward_reg_1_out <= forward_reg_1_in;
	 forward_reg_2_out <= forward_reg_2_in;
  end
endmodule


module EXMEM
(
  input CLOCK,
  input isZeroBranch_in, 	// M Stage
  input isUnconBranch_in, 	// M Stage
  input memRead_in, 		// M Stage
  input memwrite_in, 		// M Stage
  input regwrite_in, 		// WB Stage
  input mem2reg_in, 		// WB Stage
  input [63:0] shifted_PC_in,
  input alu_zero_in,
  input [63:0] alu_result_in,
  input [63:0] write_data_mem_in,
  input [4:0] write_reg_in,
  output reg isZeroBranch_out, 	// M Stage
  output reg isUnconBranch_out, // M Stage
  output reg memRead_out, 		// M Stage
  output reg memwrite_out, 		// M Stage
  output reg regwrite_out,		// WB Stage
  output reg mem2reg_out,		// WB Stage
  output reg [63:0] shifted_PC_out,
  output reg alu_zero_out,
  output reg [63:0] alu_result_out,
  output reg [63:0] write_data_mem_out,
  output reg [4:0] write_reg_out
);
	always @(negedge CLOCK) begin
		/* Values for M */
		isZeroBranch_out <= isZeroBranch_in;
		isUnconBranch_out <= isUnconBranch_in;
		memRead_out <= memRead_in;
		memwrite_out <= memwrite_in;
    
		/* Values for WB */
		regwrite_out <= regwrite_in;
		mem2reg_out <= mem2reg_in;
    
		/* Values for all Stages */
		shifted_PC_out <= shifted_PC_in;
		alu_zero_out <= alu_zero_in;
		alu_result_out <= alu_result_in;
		write_data_mem_out <= write_data_mem_in;
		write_reg_out <= write_reg_in;
	end
endmodule


module MEMWB
(
  input CLOCK,
  input [63:0] mem_address_in,
  input [63:0] mem_data_in,
  input [4:0] write_reg_in,
  input regwrite_in,
  input mem2reg_in,
  output reg [63:0] mem_address_out,
  output reg [63:0] mem_data_out,
  output reg [4:0] write_reg_out,
  output reg regwrite_out,
  output reg mem2reg_out
);
  always @(negedge CLOCK) begin
    regwrite_out <= regwrite_in;
    mem2reg_out <= mem2reg_in;
    mem_address_out <= mem_address_in;
    mem_data_out <= mem_data_in;
    write_reg_out <= write_reg_in;
  end
endmodule


module Registers
(
  input CLOCK,
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
	
    Data[31] = 64'h00000000;
  end
  
  always @(posedge CLOCK) begin
    if (CONTROL_REGWRITE == 1'b1) begin
      Data[writeReg] = writeData;
    end

    data1 = Data[read1];
    data2 = Data[read2];
        
      // Debug use only
        for (initCount = 0; initCount < 32; initCount = initCount + 1) begin
            $display("REGISTER[%0d] = %0d", initCount, Data[initCount]);
        end
      
  end
endmodule


module IC
(
  input [63:0] PC_in,
  output reg [31:0] instruction_out
);
  reg [8:0] Data[63:0];

  initial begin
    // LDUR x0, [x2, #3]
    Data[0] = 8'hf8; Data[1] = 8'h40; Data[2] = 8'h30; Data[3] = 8'h40;
    
    // ADD x9, x0, x5
    Data[4] = 8'h8b; Data[5] = 8'h05; Data[6] = 8'h00; Data[7] = 8'h09;
    
    // ORR x10, x1, x9
    Data[8] = 8'haa; Data[9] = 8'h09; Data[10] = 8'h00; Data[11] = 8'h2a;
    
    // AND x11, x9, x0
    Data[12] = 8'h8a; Data[13] = 8'h00; Data[14] = 8'h01; Data[15] = 8'h2b;
	 
    // SUB x12 x0 x11
    Data[16] = 8'hcb; Data[17] = 8'h0b; Data[18] = 8'h00; Data[19] = 8'h0c;
	 
    // STUR x9, [x3, #6]
    Data[20] = 8'hf8; Data[21] = 8'h00; Data[22] = 8'h60; Data[23] = 8'h69;
    
    // STUR x10, [x4, #6]
    Data[24] = 8'hf8; Data[25] = 8'h00; Data[26] = 8'h60; Data[27] = 8'h8a;
    
    // STUR x11, [x5, #6]
    Data[28] = 8'hf8; Data[29] = 8'h00; Data[30] = 8'h60; Data[31] = 8'hab;

    // STUR x12, [x6, #6]
    Data[32] = 8'hf8; Data[33] = 8'h00; Data[34] = 8'h60; Data[35] = 8'hcc;	 
	 
    // B #10
    Data[36] = 8'h14; Data[37] = 8'h00; Data[38] = 8'h00; Data[39] = 8'h0a;
  end

  always @(PC_in) begin
    instruction_out[8:0] = Data[PC_in + 3];
    instruction_out[16:8] = Data[PC_in + 2];
    instruction_out[24:16] = Data[PC_in + 1];
    instruction_out[31:24] = Data[PC_in];
  end
endmodule


module Data_Memory
(
  input [63:0] inputAddress,
  input [63:0] inputData,
  input CONTROL_MemWrite,
  input CONTROL_MemRead,
  output reg [63:0] outputData
);
	reg [63:0] Data[31:0];
	integer initCount;
  
	initial begin
		for (initCount = 0; initCount < 32; initCount = initCount + 1) begin
			Data[initCount] = initCount * 5;
		end
	end
	always @(*) begin
		if (CONTROL_MemWrite == 1'b1) begin 
        Data[inputAddress] = inputData;
      end else if (CONTROL_MemRead == 1'b1) begin
        outputData = Data[inputAddress];
      end else begin
        outputData = 64'hxxxxxxxx;
      end
      
      // Debug use only
        for (initCount = 0; initCount < 32; initCount = initCount + 1) begin
            $display("RAM[%0d] = %0d", initCount, Data[initCount]);
        end
      
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
  always @(*) begin
    case (CONTROL)
      4'b0000 : RESULT = A & B;
      4'b0001 : RESULT = A | B;
      4'b0010 : RESULT = A + B;
      4'b0110 : RESULT = A - B;
      4'b0111 : RESULT = B;
      4'b1100 : RESULT = ~(A | B);
      default : RESULT = 64'hxxxxxxxx;
    endcase

    if (RESULT == 0) begin
      ZEROFLAG = 1'b1;
    end else if (RESULT != 0) begin
      ZEROFLAG = 1'b0;
    end else begin
      ZEROFLAG = 1'bx;
    end
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
      2'b00 : ALU_Out <= 4'b0010;
      2'b01 : ALU_Out <= 4'b0111;
      2'b10 : begin
       
        case (ALU_INSTRUCTION)
          11'b10001011000 : ALU_Out <= 4'b0010; // ADD
          11'b11001011000 : ALU_Out <= 4'b0110; // SUB
          11'b10001010000 : ALU_Out <= 4'b0000; // AND
          11'b10101010000 : ALU_Out <= 4'b0001; // ORR
        endcase
      end
      default : ALU_Out = 4'bxxxx;
    endcase  
  end
endmodule


module Control_Mux
(
  input [1:0] CONTROL_aluop_in,
  input CONTROL_alusrc_in,
  input CONTROL_isZeroBranch_in,
  input CONTROL_isUnconBranch_in,
  input CONTROL_memRead_in,
  input CONTROL_memwrite_in,
  input CONTROL_regwrite_in,
  input CONTROL_mem2reg_in,
  input mux_control_in,
  output reg [1:0] CONTROL_aluop_out,
  output reg CONTROL_alusrc_out,
  output reg CONTROL_isZeroBranch_out,
  output reg CONTROL_isUnconBranch_out,
  output reg CONTROL_memRead_out,
  output reg CONTROL_memwrite_out,
  output reg CONTROL_regwrite_out,
  output reg CONTROL_mem2reg_out
);
	always @(*) begin
		if (mux_control_in === 1'b1) begin
		  CONTROL_aluop_out <= 2'b00;
		  CONTROL_alusrc_out <= 1'b0;
		  CONTROL_isZeroBranch_out <= 1'b0;
		  CONTROL_isUnconBranch_out <= 1'b0;
		  CONTROL_memRead_out <= 1'b0;
		  CONTROL_memwrite_out <= 1'b0;
		  CONTROL_regwrite_out <= 1'b0;
		  CONTROL_mem2reg_out <= 1'b0;
		end else begin
		  CONTROL_aluop_out <= CONTROL_aluop_in;
		  CONTROL_alusrc_out <= CONTROL_alusrc_in;
		  CONTROL_isZeroBranch_out <= CONTROL_isZeroBranch_in;
		  CONTROL_isUnconBranch_out <= CONTROL_isUnconBranch_in;
		  CONTROL_memRead_out <= CONTROL_memRead_in;
		  CONTROL_memwrite_out <= CONTROL_memwrite_in;
		  CONTROL_regwrite_out <= CONTROL_regwrite_in;
		  CONTROL_mem2reg_out <= CONTROL_mem2reg_in;
		end
	end
endmodule


module Forward_ALU_Mux
(
  input [63:0] reg_ex_in,
  input [63:0] reg_wb_in,
  input [63:0] reg_mem_in,
  input [1:0] forward_control_in,
  output reg [63:0] reg_out
);
	always @(*) begin
		case (forward_control_in)
        2'b01 : reg_out <= reg_wb_in;
        2'b10 : reg_out <= reg_mem_in;
        default : reg_out <= reg_ex_in;
      endcase
	end
endmodule


module ALU_Mux
(
  input [63:0] input1,
  input [63:0] input2,
  input CONTROL_ALUSRC,
  output reg [63:0] out
);
  always @(input1, input2, CONTROL_ALUSRC, out) begin
    if (CONTROL_ALUSRC === 0) begin
      out <= input1;
    end
    
    else begin
      out <= input2;
    end 
  end
endmodule


module ID_Mux
(
  input [4:0] read1_in,
  input [4:0] read2_in,
  input reg2loc_in,
  output reg [4:0] reg_out
);
  always @(read1_in, read2_in, reg2loc_in) begin
    case (reg2loc_in)
        1'b0 : begin
            reg_out <= read1_in;
        end
        1'b1 : begin
            reg_out <= read2_in;
        end
        default : begin
            reg_out <= 1'bx;
        end
    endcase
  end
endmodule


module WB_Mux
(
  input [63:0] input1,
  input [63:0] input2,
  input mem2reg_control,
  output reg [63:0] out
);
  always @(*) begin
    if (mem2reg_control == 0) begin
      out <= input1;
    end
    
    else begin
      out <= input2;
    end 
  end
endmodule


module Shift_Left
(
  input [63:0] data_in,
  output reg [63:0] data_out
);
  always @(data_in) begin
    data_out <= data_in << 2;
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
        
    end else begin // D Type, ignored if R type
        outImmediate[9:0] = inputInstruction[20:12];
        outImmediate[63:10] = {64{outImmediate[9]}};
    end
  end
endmodule


module Branch
(
  input unconditional_branch_in,
  input conditional_branch_in,
  input alu_main_is_zero,
  output reg PC_src_out
);
	reg conditional_branch_temp;

    always @(unconditional_branch_in, conditional_branch_in, alu_main_is_zero) begin
        conditional_branch_temp <= conditional_branch_in & alu_main_is_zero;
        PC_src_out <= unconditional_branch_in | conditional_branch_temp;
    end
endmodule


module ARM_Control
(
  input [10:0] instruction,
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
    if (instruction[10:5] == 6'b000101) begin // B
      control_mem2reg <= 1'bx;
      control_memRead <= 1'b0;
      control_memwrite <= 1'b0;
      control_alusrc <= 1'b0;
      control_aluop <= 2'b01;
      control_isZeroBranch <= 1'b0;
      control_isUnconBranch <= 1'b1;
      control_regwrite <= 1'b0;
		
    end else if (instruction[10:3] == 8'b10110100) begin // CBZ
      control_mem2reg <= 1'bx;
      control_memRead <= 1'b0;
      control_memwrite <= 1'b0;
      control_alusrc <= 1'b0;
      control_aluop <= 2'b01;
      control_isZeroBranch <= 1'b1;
      control_isUnconBranch <= 1'b0;
      control_regwrite <= 1'b0;
		
    end else begin // R-Type Instructions
      control_isZeroBranch <= 1'b0;
      control_isUnconBranch <= 1'b0;
      
      case (instruction[10:0])
        11'b11111000010 : begin // LDUR
          control_mem2reg <= 1'b1;
          control_memRead <= 1'b1;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b1;
          control_aluop <= 2'b00;
          control_regwrite <= 1'b1;
        end
        
        11'b11111000000 : begin // STUR
          control_mem2reg <= 1'bx;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b1;
          control_alusrc <= 1'b1;
          control_aluop <= 2'b00;
          control_regwrite <= 1'b0;
        end
        
        11'b10001011000 : begin // ADD
          control_mem2reg <= 1'b0;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b0;
          control_aluop <= 2'b10;
          control_regwrite <= 1'b1;
        end
        
        11'b11001011000 : begin // SUB
          control_mem2reg <= 1'b0;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b0;
          control_aluop <= 2'b10;
          control_regwrite <= 1'b1;
        end
        
        11'b10001010000 : begin // AND
          control_mem2reg <= 1'b0;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b0;
          control_aluop <= 2'b10;
          control_regwrite <= 1'b1;
        end
        
        11'b10101010000 : begin // ORR
          control_mem2reg <= 1'b0;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b0;
          control_aluop <= 2'b10;
          control_regwrite <= 1'b1;
        end
        
        default : begin // NOP
          control_isZeroBranch <= 1'bx;
      	 control_isUnconBranch <= 1'bx;
          control_mem2reg <= 1'bx;
          control_memRead <= 1'bx;
          control_memwrite <= 1'bx;
          control_alusrc <= 1'bx;
          control_aluop <= 2'bxx;
          control_regwrite <= 1'bx;
        end
      endcase
    end
  end
endmodule