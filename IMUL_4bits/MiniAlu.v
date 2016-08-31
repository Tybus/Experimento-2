
`timescale 1ns / 1ps
`include "Defintions.v"


module MiniAlu
(
 input wire Clock,
 input wire Reset,
 output wire [7:0] oLed

 
);

wire [15:0]  wIP,wIP_temp;
reg          rWriteEnable,rBranchTaken;
wire [27:0]  wInstruction;
wire [3:0]   wOperation;
reg  [15:0]  rResult;
wire [7:0]   wSourceAddr0,wSourceAddr1,wDestination;
wire [15:0]  wSourceData0,wSourceData1,wIPInitialValue,wImmediateValue;
wire [11:0]  wCarry, wTempResult;

ROM InstructionRom 
(
	.iAddress(     wIP          ),
	.oInstruction( wInstruction )
);

RAM_DUAL_READ_PORT DataRam
(
	.Clock(         Clock        ),
	.iWriteEnable(  rWriteEnable ),
	.iReadAddress0( wInstruction[7:0] ),
	.iReadAddress1( wInstruction[15:8] ),
	.iWriteAddress( wDestination ),
	.iDataIn(       rResult      ),
	.oDataOut0(     wSourceData0 ),
	.oDataOut1(     wSourceData1 )
);

assign wIPInitialValue = (Reset) ? 8'b0 : wDestination;
UPCOUNTER_POSEDGE IP
(
.Clock(   Clock                ), 
.Reset(   Reset | rBranchTaken ),
.Initial( wIPInitialValue + 1  ),
.Enable(  1'b1                 ),
.Q(       wIP_temp             )
);
assign wIP = (rBranchTaken) ? wIPInitialValue : wIP_temp;

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD1 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[27:24]),
	.Q(wOperation)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD2
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[7:0]),
	.Q(wSourceAddr0)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD3
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[15:8]),
	.Q(wSourceAddr1)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD4
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[23:16]),
	.Q(wDestination)
);


reg rFFLedEN;
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LEDS
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFFLedEN ),
	.D( wSourceData1 ),
	.Q( oLed    )
);


		MODULE_ADDER ADDER0(
			.iA(wSourceData0[0]&wSourceData1[1]), 
			.iB(wSourceData0[1]&wSourceData1[0]), 
			.iCi(1'b0),
			.oCarry(wCarry[0]),
			.oResult(wTempResult[0])
		);
		
		MODULE_ADDER ADDER1(
			.iA(wSourceData0[2]&wSourceData1[0]), 
			.iB(wSourceData0[1]&wSourceData1[1]), 
			.iCi(wCarry[0]),
			.oCarry(wCarry[1]),
			.oResult(wTempResult[1])
		);
		
		MODULE_ADDER ADDER2(
			.iA(wSourceData0[3]&wSourceData1[0]), 
			.iB(wSourceData0[2]&wSourceData1[1]), 
			.iCi(wCarry[1]),
			.oCarry(wCarry[2]),
			.oResult(wTempResult[2])
		);
	
		MODULE_ADDER ADDER3(
			.iA(1'b0), 
			.iB(wSourceData0[3]&wSourceData1[1]), 
			.iCi(wCarry[2]),
			.oCarry(wCarry[3]),
			.oResult(wTempResult[3])
		);
	
		MODULE_ADDER ADDER4(
			.iA(wTempResult[1]), 
			.iB(wSourceData0[0]&wSourceData1[2]), 
			.iCi(1'b0),
			.oCarry(wCarry[4]),
			.oResult(wTempResult[4])
		);
	
		MODULE_ADDER ADDER5(
			.iA(wTempResult[2]), 
			.iB(wSourceData0[1]&wSourceData1[2]), 
			.iCi(wCarry[4]),
			.oCarry(wCarry[5]),
			.oResult(wTempResult[5])
		);
	
		MODULE_ADDER ADDER6(
			.iA(wTempResult[3]), 
			.iB(wSourceData0[2]&wSourceData1[2]), 
			.iCi(wCarry[5]),
			.oCarry(wCarry[6]),
			.oResult(wTempResult[6])
		);
	
		MODULE_ADDER ADDER7(
			.iA(wCarry[3]), 
			.iB(wSourceData0[3]&wSourceData1[2]), 
			.iCi(wCarry[6]),
			.oCarry(wCarry[7]),
			.oResult(wTempResult[7])
		);
	
		MODULE_ADDER ADDER8(
			.iA(wTempResult[5]), 
			.iB(wSourceData0[0]&wSourceData1[3]), 
			.iCi(1'b0),
			.oCarry(wCarry[8]),
			.oResult(wTempResult[8])
		);
	
		MODULE_ADDER ADDER9(
			.iA(wTempResult[6]), 
			.iB(wSourceData0[1]&wSourceData1[3]), 
			.iCi(wCarry[8]),
			.oCarry(wCarry[9]),
			.oResult(wTempResult[9])
		);
		
		MODULE_ADDER ADDER10(
			.iA(wTempResult[7]), 
			.iB(wSourceData0[2]&wSourceData1[3]), 
			.iCi(wCarry[9]),
			.oCarry(wCarry[10]),
			.oResult(wTempResult[10])
		);
			
		MODULE_ADDER ADDER11(
			.iA(wCarry[7]), 
			.iB(wSourceData0[3]&wSourceData1[3]), 
			.iCi(wCarry[10]),
			.oCarry(wCarry[11]),
			.oResult(wTempResult[11])
		);

assign wImmediateValue = {wSourceAddr1,wSourceAddr0};



always @ ( * )
begin
	case (wOperation)
	//-------------------------------------
	`NOP:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
	end
	//-------------------------------------
	`ADD:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 + wSourceData0;
	end
	//-------------------------------------
	`STO:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
	end
	//-------------------------------------
	`BLE:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		if (wSourceData1 <= wSourceData0 )
			rBranchTaken <= 1'b1;
		else
			rBranchTaken <= 1'b0;
		
	end
	//-------------------------------------	
	`JMP:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
	end
	//-------------------------------------	
	`LED:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end
	//-------------------------------------
	`IMUL:
	begin 
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		
		rResult [0] <= wSourceData0[0]&wSourceData1[0];
		rResult [1] <= wTempResult[0];
		rResult [2] <= wTempResult[4];
		rResult [3] <= wTempResult[8];
		rResult [4] <= wTempResult[9];
		rResult [5] <= wTempResult[10];
		rResult [6] <= wTempResult[11];
		rResult [7] <= wCarry[11];
		
		rResult [15:8] <= 8'b0;
	end
	//-------------------------------------
	default:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end	
	//-------------------------------------	
	endcase	
end


endmodule
