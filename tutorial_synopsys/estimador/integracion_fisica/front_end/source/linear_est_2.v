//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Alfonso Chacon Rodriguez
// 
// Create Date:    10:25:29 05/03/2008 
// Design Name: 
// Module Name:    linear_est 
// Project Name:   Medidor de retardo
// Target Devices: ASIC/ Spartan 3
// Tool versions: 
// Description: Estimador basado en filtro Kalman, matrices invariantes
//  (filtro alfa-beta)
//  Algoritmo:
/*% Linear estimator
% Estimador lineal de retardo, usando modelo de filtro alfa-beta, de Kalman
%
%
% Partimos del modelo segun [1], actualizado para este caso segun [2]
%
% Definicion de variables
%
% W_k= ganancia de Kalman
% sigma_v= varianza ruido de modelo
% sigma_w= varianza ruido de sensor
% sigma_pk= sigma_p(k) varianza de estimacion estimada
% sigma_pk1= sigma_p(k|k-1) varianza de estimacion predicha
% sigma_pk1_k1= sigma_p(k-1|k-1) varianza de estimacion anterior
% x_k_k1= x(k|k-1) estado predicho a partir estado anterior
% x_k1_k1= x(k-1|k-1) estado anterior
% x_k= x(k) Estado estimado
% v_k= v(k) Innovacion
% s_k= s(k) Varianza de estimacion
% z_k_k1= z(k|k-1) Medida predicha
% z_k= z(k) Medida del sensor
%
% Ecuaciones
%
% Ecuacion del modelo
% x(k|k-1)= x(k-1|k-1) Suponemos un modelo constante e invariable
% z(k|k-1)=x(k|k-1)    Matriz H de modelo de observacion es la identidad
% x(k)=  x(k|k-1) + W(k)v(k)  El estado estimado es el estado predicho mas
% la innovacion por la ganancia de Kalman
% v(k)=  z(k)-x(k|k-1) Innovacion
%
% W(k) = sigma_p(k|k-1)/s(k)  =[sigma_p(k-1|k-1) + sigma_v]/s(k)
% s(k) = sigma_w+ sigma_p(k|k-1)
% sigma_p(k) =  sigma_p(k|k-1)- s(k)W(k)^2 
%  La ganancia de Kalman W(k) se calcula offline, y se utiliza su valor
final como ganancia estatica en el algoritmo verilog, luego de comprobarla
en Matlab.
Asi, las ecuaciones se reducen a:
    x_k_k1= x_k1_k1; % predecimos el estado 
    z_k_k1= x_k_k1; % predecimos la medicion
    v_k=  z_k - z_k_k1; % calculamos la innovacion
    x_k = x_k_k1 + round((W_k*v_k));
    %guardamos variables para proxima iteracion
    x_k1_k1=x_k; %guardamos estado estimado
    x_vector_pred=[x_vector_pred x_k_k1];
    x_vector_3= [x_vector_3  x_k]; %guardamos evolucion para plotear

*/
// Entradas
//  clk, reset_L
//  l_r= Load, Read. En bajo, carga la constante de W a usar en data[3:0]
//                    (por defecto 0.625)
//                   En alto, el bus data entrega el dato estimado de retardo
//  z = medicion del TOF_counter
//  count = Hay cuenta nueva en TOF_counter
//  W_ext = 4 bits. Carga valor de W segun tabla
//                    W   ganancia equiv.
//                  1111    0.9375
//                  1110    0.875
//                  1101    0.8125
//                  1100    0.75
//                  1011    0.6875
//                  1010    0.625 (por defecto)
//                  1001    0.5625
//                  1000    0.5
//                  0111    0.4375 ...
//                  
//
// Salidas
//  data  = Bus bidireccional de datos (l_r=0), o de carga de W (l_r=1)
//  data_ready = dato valido a la salida
//
// Dependencies: tof_counter.v: TOF mesurements (z(k))
//               mult_booth.v : Multiplicador Booth optimizado, 8x4
//
// Revision: 
// Revision 0.01 - 3 mayo, 2008
// Additional Comments: 
// Revision 0.02 - 9 junio, 2008
//  Corregimos problema de fix en la salida del multiplicador
//
//////////////////////////////////////////////////////////////////////////////////
module linear_est_2(clk, reset_L, z, count, data_ready, data, W_ext, l_r);
    
  `include "constants.h"    
    input clk;
    input reset_L;
    input signed [7:0] z; //Medida desde el sensor
    input count;   //Dato en el sensor
    input l_r;     //1-Load W (W_ext[3:0]), 0- Read estimacion (data[7:0])
                   //Senal debe sostenerse por al menos 2 clks
    input [3:0] W_ext; // Valor externo de ganancia
    //Salidas
    output data_ready; //Valor estimado listo
    output [7:0] data;    //Valor estimado (salida) o ganancia Kalman
    

// Variables internas
reg data_ready;

reg signed [3:0] W; //Ganancia de Kalman 
//reg signed [7:0] z_oper; //variable de sensor de entrada
wire signed [8:0] v_k; //innovacion. Consideramos un bit extra para poder
//cubrir el rango hasta 256 (evolucionando desde retardos con signo
//diferente las diferencias pueden superar 127)
reg signed [7:0] x_k1_k1; //  x(k-1|k-1) 


wire signed [7:0] x_k; //
reg load_x;     //Control de carga registro de salida, estado
reg load_W_reg; //Control de carga registro de ganancia W
//wire load_z;     //Carga del registro de medicion de sensor (TOF counter)


reg [2:0] state, next_state; //Registros FSM

// Conexion al multiplicador

wire signed [4:0] Q; //Multiplicador, W en este caso
wire signed [8:0] M; //Multiplicando, innovacion
wire signed [13:0] P; //Producto v_k*W
wire signed [7:0] result; //Producto v_k*W, P[11:4]
reg  start_mult;     //Arranque para el multiplicador
wire done;           //Aviso del multiplicador de que hay producto listo 


//Ruta de datos
//Registros intermedios


assign Q={1'b0,W}; //Ganancia siempre positiva
assign M=v_k; 
// *** Corregido para redondear **** 
// result= P DIV 16. Se ejecuta (P sar 4)+P[3]
// La suma de P[3] redondea si el numero frac es mayor de 0.5
assign result=P[11:4]+P[3]; //result (P divido 16), 8 bits


// SUmador para x(k)=x(k-1|k-1)+W*v(k)
//assign load_z=count; //esta misma sennal carga el registro con z y dispara FSM
assign x_k=result+x_k1_k1;

// Restador para innovacion  v_k=z(k)-x(k-1|k-1)
//assign v_k=z_oper-x_k1_k1;
assign v_k=z-x_k1_k1;

// Almacenamiento variable del sensor de TOF
//always@(posedge clk or negedge reset_L)
//
// if (!reset_L)
//  z_oper<=0;
// else if (load_z)
//  z_oper<=z;
  

//***** registro de salida y de estado anterior x(k-1|k-1) 
always@(posedge clk or negedge reset_L)

 if (!reset_L)
   x_k1_k1<=0;
 else if (load_x)
   x_k1_k1<=x_k;
   
   
  
//***** Registro de Data Ready
always @(posedge clk or negedge reset_L)
begin
    if (!reset_L)
        data_ready<=0;
    else
        data_ready<=load_x;
end

//***** Carga de Registro de ganancia W *******
// Ver tabla de valores al inicio del archivo


always @(posedge clk or negedge reset_L)
begin
    if (!reset_L)
        W<=4'hA; //por defecto, W=AH=0.625
    else if (load_W_reg)
        W<=W_ext;
end

 //***** Carga de Registro Estado ******* 
always @(posedge clk or negedge reset_L)
begin
    if (!reset_L)
        state<=0; //por defecto, W=AH=0.625
    else
        state<=next_state;
end
 
  
//**************  FSM de control *************************

// ************* Logica de siguiente estado ****************

always@*

begin
    case (state)
        start_le:  begin //Con un count hay una nueva medicion
                  if (l_r)
                    next_state=load_W_le;
                  else if (count)
                    next_state=load_mult_le;
                  else
                    next_state=start_le;
                end
              
        load_W_le:      begin
                       next_state=start_le;
                     end   
                     
                         
        load_mult_le:   begin
                       next_state=mult_le;
                     end
        
        mult_le:   begin //Mientras el multiplicador no termine, seguimos aca
                   if (done)
                     next_state= start_le;
                   else
                     next_state= mult_le;
                end
        default: next_state=start_le;
        
   endcase
 end// Termina proceso logica de estado
  
  
 // ************ Logica de salida **************
 //
 always@*
 
 begin
 
    start_mult=0;
    load_W_reg=0;
    load_x=0;
    
    case (state)
        start_le:  begin //Con un count hay una nueva medicion
                  end
        
        load_W_le:  begin
                     load_W_reg=1;
                    end      
       
       
        load_mult_le:  begin
                         start_mult=1;
                       end
        
        mult_le:   begin //Mientras el multiplicador no termine, seguimos aca
                     if (done)
                       load_x=1;
                     else
                       load_x=0;   
                end
        default:
          begin     
             start_mult=0;
             load_W_reg=0;
             load_x=0;
           end
        
   endcase
 end// Termina proceso logica de salida
      
// ************* Instancias ruta de datos externa ********************



//Debe estar la instancia el módulo multilicador (mult_booth, archivo: mult_booth.v)
//con los siguientes parámetros: M_size(9), Q_size(5), P_size(14).

//Las señales de este módulo hacia el multiplicador son: clk, reset_L, Q, M, done, start, start_mult, P.









	    
//***************** Salidas

assign data=x_k1_k1; 
	    
endmodule
