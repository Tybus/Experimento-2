`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:30:52 01/30/2011
// Design Name:   MiniAlu
// Module Name:   D:/Proyecto/RTL/Dev/MiniALU/TestBench.v
// Project Name:  MiniALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MiniAlu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBench;

	// Inputs
	reg[15:0] A;
	reg[15:0] B;

	// Outputs
	wire [31:0] OUT;

	// Instantiate the Unit Under Test (UUT)
	MULTIPLIER multi(
		.wA(A), 
		.wB(B), 
		.oOUT(OUT)
	);
	

	initial begin
		// Initialize Inputs
		A = 16'd5;
		B = 16'd5;
	end
      
endmodule

