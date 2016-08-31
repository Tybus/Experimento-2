`timescale 1ns / 1ps
//------------------------------------------------
module UPCOUNTER_POSEDGE # (parameter SIZE=16)
(
input wire Clock, Reset,
input wire [SIZE-1:0] Initial,
input wire Enable,
output reg [SIZE-1:0] Q
);


  always @(posedge Clock )
  begin
      if (Reset)
        Q = Initial;
      else
		begin
		if (Enable)
			Q = Q + 1;
			
		end			
  end

endmodule
//----------------------------------------------------
module FFD_POSEDGE_SYNCRONOUS_RESET # ( parameter SIZE=8 )
(
	input wire				Clock,
	input wire				Reset,
	input wire				Enable,
	input wire [SIZE-1:0]	D,
	output reg [SIZE-1:0]	Q
);
	

always @ (posedge Clock) 
begin
	if ( Reset )
		Q <= 0;
	else
	begin	
		if (Enable) 
			Q <= D; 
	end	
 
end//always

endmodule


//----------------------------------------------------------------------

module MUX_MUL # (parameter SIZE=16)(
	input wire [1:0]					B,
	input wire [SIZE-1:0]			A,
	output reg [SIZE-1:0]			OUT
);


always @(*)
begin
	case(B)
	2'b00:
		OUT <= 0;
	2'b01:
		OUT <= A;
	2'b10:
		OUT <= A<<1;
	2'b11:
		OUT <= A<<1 + A;	
	endcase
end

endmodule

module MULTIPLIER4 #(parameter SIZE =4)(
	input wire [3:0]				A,
	input wire [3:0]				B,
	output wire [7:0]				OUT
);	
	wire[3:0] bajo, alto;

	MUX_MUL mul1(
		.B (B[1:0]),
		.A (A),
		.OUT(bajo)
	);
	MUX_MUL mul2(
		.B (B[3:2]),
		.A(A),
		.OUT(alto)
	);
	wire[7:0] tmp;
	assign tmp = alto<<2;
	assign OUT = tmp + bajo;
	
endmodule

module MULTIPLIER #(parameter SIZE =16)(
	input wire [SIZE-1:0]		wA,
	input wire [SIZE-1:0]		wB,
	output reg [2*SIZE-1:0]	oOUT
);	
	
	wire [SIZE/2-1:0] wResultTemp [2*SIZE-1:0]; //wire [SIZE/2-1:0] wResultTemp [2*SIZE-1:0]
	wire [SIZE/2-1:0]	wResultToAdd [2*SIZE -1 :0];
	wire [SIZE/2-1:0] wAddSteps [2*SIZE -1 :0];
	assign wAddSteps[0] = wResultToAdd[0];
	
	genvar i;
	generate
		for (i = 0; (2*i +1) < SIZE/2; i = i+1)
		begin: MY_MUL_GEN
				MUX_MUL multiplicador
				(
						.B( wB[2*i+1:2*i] ),  //TODO
						.A( wA ),
						.OUT( wResultTemp[i] )
				);			
				
				assign wResultToAdd[i] = wResultTemp[i] << (2*i);
				if(i!=0)
					assign wAddSteps[i] = wAddSteps[i-1] + wResultToAdd[i];
		end		
	endgenerate	
	
	always @ ( * )
		oOUT <= wAddSteps[SIZE/2-1];
		
endmodule	