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
 
end

endmodule
//----------------------------------------------------
module MODULE_ADDER(
	input wire iA, 
	input wire iB, 
	input wire iCi, 
	output wire oCarry, 
	output wire oResult
);

	assign {oCarry, oResult } = iA + iB + iCi ;

endmodule
//----------------------------------------------------
module MODULE_MUL #(parameter Max_Cols = 16, Max_Rows = 16)(
	input wire [15:0] iA,
	input wire [15:0] iB,
	output wire [31:0] oResult
);

	wire [Max_Rows-1:0] wTempResult [Max_Cols-1:0];
	wire [Max_Rows:0] wCarry [Max_Cols:0];

	genvar CurrentRow, CurrentCol;
	
	generate
	
		for(CurrentRow = 0; CurrentRow < Max_Rows; CurrentRow = CurrentRow + 1)
			begin
				assign wCarry[CurrentRow][0] = 1'b0;
	
				if (CurrentRow == 0)
					begin
						for(CurrentCol = 0; CurrentCol < Max_Cols-1; CurrentCol = CurrentCol + 1)
							if(CurrentCol == Max_Cols-1)
								begin
									
									assign wCarry[CurrentRow][CurrentCol] = 1'b0;
								
									MODULE_ADDER ADDER(
										.iA(wCarry[CurrentRow][CurrentCol+1]), 
										.iB(iB[CurrentRow+1]&iA[CurrentCol]), 
										.iCi(wCarry[CurrentRow+1][CurrentCol]), 
										.oCarry(wCarry[CurrentRow+1][CurrentCol+1]), 
										.oResult(wTempResult[CurrentRow][CurrentCol])
									);
								end
							else
								begin:MUL
									MODULE_ADDER ADDER(
										.iA(iB[CurrentRow]&iA[CurrentCol+1]), 
										.iB(iB[CurrentRow+1]&iA[CurrentCol]), 
										.iCi(wCarry[CurrentRow+1][CurrentCol]), 
										.oCarry(wCarry[CurrentRow+1][CurrentCol+1]), 
										.oResult(wTempResult[CurrentRow][CurrentCol])
									);
								end	
					end
				
				else
					for(CurrentCol = 0; CurrentCol < Max_Cols; CurrentCol = CurrentCol + 1)
						if(CurrentCol == Max_Cols-1)
							begin
								MODULE_ADDER ADDER(
									.iA(wCarry[CurrentRow][CurrentCol+1]), 
									.iB(iB[CurrentRow+1]&iA[CurrentCol]), 
									.iCi(wCarry[CurrentRow+1][CurrentCol]), 
									.oCarry(wCarry[CurrentRow+1][CurrentCol+1]), 
									.oResult(wTempResult[CurrentRow][CurrentCol])
								);
							end
						else
							begin:MUL
								MODULE_ADDER ADDER(
									.iA(wTempResult[CurrentRow-1][CurrentCol+1]), 
									.iB(iB[CurrentRow+1]&iA[CurrentCol]), 
									.iCi(wCarry[CurrentRow+1][CurrentCol]), 
									.oCarry(wCarry[CurrentRow+1][CurrentCol+1]), 
									.oResult(wTempResult[CurrentRow][CurrentCol])
								);
							end
			end
		
		for(CurrentRow=0; CurrentRow < Max_Rows; CurrentRow = CurrentRow + 1)
			for(CurrentCol=0; CurrentCol < Max_Cols; CurrentCol = CurrentCol + 1)
				begin
					if(CurrentCol==0)
						assign oResult[CurrentRow+1] = wTempResult[CurrentRow][CurrentCol];
					if(CurrentRow == Max_Rows-1)
						assign oResult[CurrentRow+CurrentCol] = wTempResult[CurrentRow][CurrentCol];
				end			
	endgenerate
	
	assign oResult[(2*Max_Rows)-1] = wCarry[Max_Rows-1][Max_Cols-1];
	assign oResult[0] = iA[0]&iB[0];
	
endmodule
//----------------------------------------------------------------------


