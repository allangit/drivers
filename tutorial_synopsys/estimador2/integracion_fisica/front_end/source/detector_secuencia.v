`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:05:53 08/26/2011 
// Design Name: 
// Module Name:    detector_secuencia 
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
module detector_secuencia(
    input clk,
    input reset,
    input dato,
    output detectada
    );

wire clk_2;

divisor_frecuencia divisor_frecuencia(clk, reset, clk_2);
secuenciaFSM secuenciaFSM(clk_2, reset, dato, detectada);

endmodule
