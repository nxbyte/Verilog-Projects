`timescale 1ns / 1ps

/*
    Group Members: Kevin Ingram and Warren Seto

    Lab Name: Traffic Light Controller (Lab 3)
    Project Name: eng312_proj3
    Design Name: Traffic_eng312_proj3.v
    Design Description: Verilog Module that uses the following modules to operate: nsCounter, ewCounter, yellowCounter
*/

module Traffic
(
  input [4:0] nsCounter,
  input [3:0] ewCounter,
  input [1:0] yellowCounter,
  input NS_VEHICLE_DETECT,
  input EW_VEHICLE_DETECT,
  output reg NS_RED,
  output reg NS_YELLOW,
  output reg NS_GREEN,
  output reg EW_RED,
  output reg EW_YELLOW,
  output reg EW_GREEN
);

  // Sets the start state at: 001100
  initial begin
    NS_RED <= 0;
    NS_YELLOW <= 0;
    NS_GREEN <= 1;
    EW_RED <= 1;
    EW_YELLOW <= 0;
    EW_GREEN <= 0;
  end

  always @ (nsCounter) begin
  	// Sets the start state at: 010100
    if (nsCounter == 31 & EW_VEHICLE_DETECT & NS_GREEN) begin
       NS_RED <= 0;
       NS_YELLOW <= 1;
       NS_GREEN <= 0;
       EW_RED <= 1;
       EW_YELLOW <= 0;
       EW_GREEN <= 0;
    end
  end

  // Sets the start state at: 100010
  always @ (ewCounter) begin
    if (ewCounter == 15 & EW_GREEN) begin
       NS_RED <= 1;
       NS_YELLOW <= 0;
       NS_GREEN <= 0;
       EW_RED <= 0;
       EW_YELLOW <= 1;
       EW_GREEN <= 0;
    end
  end

  // Sets the start state at: 001100
  always @ (yellowCounter) begin
    if (yellowCounter == 3 & NS_YELLOW) begin
       NS_RED <= 1;
       NS_YELLOW <= 0;
       NS_GREEN <= 0;
       EW_RED <= 0;
       EW_YELLOW <= 0;
       EW_GREEN <= 1;
    end

    // Sets the start state at: 100001
    if (yellowCounter == 3 & EW_YELLOW) begin
       NS_RED <= 0;
       NS_YELLOW <= 0;
       NS_GREEN <= 1;
       EW_RED <= 1;
       EW_YELLOW <= 0;
       EW_GREEN <= 0;
    end
  end
endmodule


/*
    A Counter for the North-South Traffic Light
    Counts from 0-31
*/
module nsCounter
(
    input clk,
    output [4:0] count
);

  wire clk;
  reg[4:0] count;

  initial
    	count = 0;

  always @ ( negedge clk )
    		count[0] <= ~count[0];

  always @ ( negedge count[0] )
    		count[1] <= ~count[1];

  always @ ( negedge count[1] )
    		count[2] <= ~count[2];

  always @ ( negedge count[2] )
    		count[3] <= ~count[3];

  always @ ( negedge count[3] )
    		count[4] <= ~count[4];

endmodule


/*
    A Counter for the East-West Traffic Light
    Counts from 0-15
*/
module ewCounter
(
    input clk,
    output [3:0] count
);

  wire clk;
  reg[3:0] count;

  initial
    	count = 0;

  always @ ( negedge clk )
    		count[0] <= ~count[0];

  always @ ( negedge count[0] )
    		count[1] <= ~count[1];

  always @ ( negedge count[1] )
    		count[2] <= ~count[2];

  always @ ( negedge count[2] )
    		count[3] <= ~count[3];

endmodule


/*
    A Counter for the common yellow Traffic Light
    Counts from 0-3
*/
module yellowCounter
(
  input clk,
 	output [1:0] count
);

  wire clk;
  reg[1:0] count;

  initial
    	count = 0;

  always @ ( negedge clk )
    		count[0] <= ~count[0];

  always @ ( negedge count[0] )
    		count[1] <= ~count[1];

endmodule
