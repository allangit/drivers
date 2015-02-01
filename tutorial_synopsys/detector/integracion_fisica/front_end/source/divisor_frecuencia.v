`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:53:45 08/26/2011 
// Design Name: 
// Module Name:    divisor_frecuencia 
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
module divisor_frecuencia(
    input clk,
	 input reset,
	 output reg clk_2
    );

always @(posedge clk)
    if (reset) clk_2 <=1'b0;
	 else clk_2 <= clk_2+1;
	
endmodule
