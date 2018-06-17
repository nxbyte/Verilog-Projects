`timescale 1ns / 1ps

/*
	Group Members: Kevin Ingram and Warren Seto

	Lab Name: Traffic Light Controller (Lab 3)
	Project Name: eng312_proj3
	Design Name: Traffic_Test_B_eng312_proj3.v
	Design Description: Verilog Test Bench to Implement Test B (6 AM)
*/

module Traffic_Test;

	// Inputs
	reg NS_VEHICLE_DETECT;
	reg EW_VEHICLE_DETECT;

	// Outputs
	wire NS_RED;
	wire NS_YELLOW;
	wire NS_GREEN;
	wire EW_RED;
	wire EW_YELLOW;
	wire EW_GREEN;

	// Clock
	reg clk;

	// Counters
	wire[4:0] count1;
	wire[3:0] count2;
	wire[1:0] count3;

	// Counter Modules
	nsCounter clock1(clk, count1); 	 // Count a total of 32 seconds
	ewCounter clock2(clk, count2); 	 // Counts a total of 16 seconds
	yellowCounter clock3(clk, count3); // Counts a total of 4 seconds

	// Main Traffic Module
	Traffic CORE (count1, count2, count3, NS_VEHICLE_DETECT, EW_VEHICLE_DETECT, NS_RED, NS_YELLOW, NS_GREEN, EW_RED, EW_YELLOW, EW_GREEN);

	initial begin

		clk = 0;
		NS_VEHICLE_DETECT = 0;
		EW_VEHICLE_DETECT = 1;

		$display("                         NS | EW ");
		$display("              (Time) | R Y G R Y G ");
		$monitor("%d | %h %h %h %h %h %h", $time, NS_RED, NS_YELLOW, NS_GREEN, EW_RED, EW_YELLOW, EW_GREEN);

		#1000 $finish;
	end

	always begin
		#1 clk = ~clk;
	end

	always @ (clk) begin
		if ($time % 21 == 0) begin
			NS_VEHICLE_DETECT = ~NS_VEHICLE_DETECT;
			EW_VEHICLE_DETECT = ~EW_VEHICLE_DETECT;
		end
	end
endmodule
