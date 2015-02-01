//////////////////////////////////////////////////////////////////////////////////
// Company:  Instituto Tecnologico de Costa Rica
// Engineer: Alfonso Chacon Rodriguez
// 
// Create Date:    11:15:58 02/29/2008 
// Design Name: 
// Module Name:    top_linear_est
// Project Name:   Delay estimator
// Target Devices: 
// Tool versions: 
// Description: Two different algorithms are developed for delay estimation.
//              a. Linear estimator, based on an Kalman (alpha/beta) filter
//              b. Binary search algorithm
//              Both algorithms follow a closed loop structure. Input comes 
//              Time Of Fligth unit, that gives a discrete measurement between
//              the edges of two digital signals. Signals are previously syncrhonized
//              and routed through a multiplezer to allow for positive/negative delays
//
// Dependencies: 
//             tof_counter.v: TOF mesurements (z(k))
//             linear_est.v: Calculo de estimadores
//             osu_std_cell.v : Primitivas de pads
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top_linear_est_pad(clk,reset_L,  X1, X2,
                          Y_output, data_ready,
                          l_r, W_ext);
`include "constants.h"
//Inputs desde los pads
    input clk;
    input reset_L;
    input X1;
    input X2;
	 input l_r;     //1-Load W (W_ext[3:0]), 0- Read estimacion (data[7:0])
                   //Senal debe sostenerse por al menos 2 clks
    input [3:0] W_ext; // Valor externo de ganancia
    
//Outputs
	 output  [7:0] Y_output;
	 output        data_ready;
	 
//Variables de salida y de conexion

//Conexion a pads
   wire data_ready;
   wire [7:0] Y_output;
   
//Conexion interna

   wire  clk;
   wire  reset_L;
   wire  X1;
   wire  X2;
   wire  l_r;//1-Load W (W_ext[3:0]), 0- Read estimacion (data[7:0])
                   //Senal debe sostenerse por al menos 2 clks
   wire  [3:0] W_ext; //Valor externo de ganancia
   
   // wire data_ready;
   // wire [7:0] Y_output;

   wire  Y1 ;
	wire  Y2 ;
	wire  [7:0]  tof_count;
   //wire  input_sel;  //Seleccion en el mux
   wire  tof_ready; //TEnemos una nueva cuenta en el TOF

   
//Variables internas 
   	
   	reg X1_meta, X1_sync, X2_meta, X2_sync;
   	//Sincronizamos X1 y X2

always@(posedge clk or negedge reset_L)

 if (~reset_L)
    begin
	    X1_meta<=0;
		 X2_meta<=0;
	    X1_sync<=0;
		 X2_sync<=0;
    end
 else 
      begin
       X1_meta<=X1;
		 X2_meta<=X2;
	    X1_sync<=X1_meta;
		 X2_sync<=X2_meta;
      end
//
	
//Logica de seleccion

//X2 se supone retardada (por defecto) y 
//es Y2. 
//   input_sel, 0: Y1<=X1, Y2<=X2
//              1: Y1<=X2, Y1<=X1
 
//assign Y2= (input_sel)? X1_sync:X2_sync; 


//assign Y1= (input_sel)? X2_sync:X1_sync;
//
assign Y1=X1_sync;
assign Y2=X2_sync;


// Instanciacion de unidades

//*********** Medidor de TOF *****************************

tof_counter tof_u1 (.clk(clk), .reset_L(reset_L),
                    .tof_count(tof_count),
                    .Y1(Y1), .Y2(Y2), .tof_ready(tof_ready));
  
 //Por ahora pegamos las senales de salida del TOF counter
 
 //assign Y_output =tof_count;
 //assign data_ready =tof_ready;
                    
//*************Unidad de estimacion lineal *******************
linear_est_2 lin_u1(.clk(clk), 
              .reset_L(reset_L), 
              .z(tof_count), 
              .count(tof_ready), 
              .data(Y_output), 
              .data_ready(data_ready),
              .l_r(l_r),
              .W_ext(W_ext));

//*************Conexion a Pads osu_std_cells AMI 0.5

//Pads Salida



endmodule
