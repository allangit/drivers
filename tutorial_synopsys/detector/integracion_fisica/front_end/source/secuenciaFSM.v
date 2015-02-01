`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:44:56 08/26/2011 
// Design Name: 
// Module Name:    secuenciaFSM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module secuenciaFSM(
    input clk_2,
    input reset,
    input dato,
    output reg detectada
    );

reg [1:0] state, nextstate;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

//State register
always @(posedge clk_2, posedge reset)
     if (reset) state <= S0;
	  else state <= nextstate;

//Next state logic
always @(state, dato)
  case (state)
  S0: if (dato) nextstate <= S1;
      else   nextstate <= S0;  
		
  S1: if (dato) nextstate <= S2;
      else   nextstate <= S0;

  S2: if (dato) nextstate <= S2;
      else   nextstate <= S3;	

  S3: if (dato) nextstate <= S1;
      else   nextstate <= S0;	
		
  default: nextstate <= S0;
  
  endcase

//output logic
always @ (state or dato)
  case(state)
  S0: detectada <= 0; 

  S1: detectada <= 0;  
 
  S2: detectada <= 0;  
 
  S3: if (dato) detectada <= 1; 
      else   detectada <= 0; 
  
  default: detectada <=0;
  
  endcase

endmodule
