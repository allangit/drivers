//Modulo de cuenta de Tiempo de vuelo (TOF) entre 
//Flanco Y1 y flanco Y2
// Algoritmo de control del contador TOF 
//          1.  if (edge(Y1) | edge(Y2))
//                  set(start)
//
//          2. if (start(Y1) & edge(Y2))| count_max
//                 set(stop&load)
//             else if (start(Y2) & edge(Y2) | count_min
//                 set(stop&load)
//             else
//                  discard
//             
//         dir_+ <= start(Y1) //Si dispara Y1, incrementamos
//         dir_- <= start(Y2) //Si dispara Y2, decrementamos


module tof_counter(clk, reset_L, Y1, Y2,
                     tof_count, tof_ready );
`include "constants.h"
//Inputs
input clk;
input reset_L;
input Y1;
input Y2; //Entradas sincronizadas

//Outputs
output signed [7:0] tof_count;
//output input_sel; //Variable de control de mux entrada
output tof_ready; //Hay un nuevo dato en el TOF Counter


//Registros salida
reg signed [7:0] tof_count;
//reg input_sel;
reg tof_ready; //Indica una nueva medicion del TOF
//wire tof_ov; //Si el TOF esta saturado

//Internal variables
reg signed [7:0] counter, counter_prev; //Registro contador
reg [1:0] state, next_state; 
reg Y1_K,  Y1_K1; //Y1(k), Y1(k+1). Para deteccion de flanco en Y1
reg Y2_K, Y2_K1; //Y2(k), Y2(k+1). Para deteccion de flanco en Y2.
                 //Necesitmos compensar latencia FSM con un FF mas
                 
                 
reg load_Y_edge; //Para guardar los flancos
reg clr_Y_edge; //Limpia regitsros de flancos
reg load_tof;   //Para cargar registro de salida
reg Y1_edge_reg, Y2_edge_reg; //Para guardar flanco disparador
reg stop_count; //Variable para parar la cuenta

wire Y1_edge_start, Y2_edge_start; // Para reportar flancos arranque
wire Y1_edge_stop, Y2_edge_stop; // Para reportar flancos parada
wire start_count; //Variable que arranca la cuenta
wire max_count_neg, max_count_pos; //, count_ov; //Para saturacion



//******************Contador implementado como FSM*****************
//Logica de siguiente estado
always@*
begin
    case (state)
      start_state:if (start_count)
                     next_state=count_state;
                   else  
                    next_state=start_state;
    
      count_state:if (stop_count)
                     next_state=start_state;
                  else
                    next_state=count_state;
     default:     next_state=start_state; 
                    
    endcase
end //del proceso
                       
        
//Logica de salida   
always@*
begin
    //Valores por defecto
   counter_prev=0;
   load_tof=0;
   load_Y_edge=0;
   clr_Y_edge=0;
    case (state)
        start_state: if (start_count)
                       //Si arrancamos la cuenta, guardamos los flancos
                       begin 
                         load_Y_edge=1;
                         
                        end
                     else
                        begin
                         load_Y_edge=0;
                         
                        end
        
        count_state: if (stop_count)
                 begin
                  load_tof=1; //sacamos cuenta
                  clr_Y_edge=1; 
                 end
               else if ((Y1_edge_reg)&(!max_count_pos)) //Si disparo Y1, sumamos retardo
                  counter_prev=counter+1;//hasta el limite del contador
               else if ((Y2_edge_reg)&(!max_count_neg)) //si disparo Y2, restamos retardo
                  counter_prev=counter-1;
               else
                  counter_prev=counter; //si no, nos mantenemos
               
        default: begin 
                   counter_prev=0;     
                   load_tof=0;
                   load_Y_edge=0;
                   clr_Y_edge=0;
                end
    endcase
end //del proceso

//Memoria de Estado y de salidas

//Registro de estado 
always@(posedge clk or negedge reset_L)

   if (!reset_L)
 	   state<=0;
 	   
	else
	   state<=next_state;
	   
//Logica de arranque y de parada

assign start_count = Y1_edge_start | Y2_edge_start;

always@* //La logica de parada es un poco mas compleja
begin //Solo se para si viene el flanco esperado
   if(Y1_edge_reg & Y2_edge_stop) //si arrancamos por Y1, esperamos
     stop_count=1;               //flanco parada en Y2 y paramos 
   else if(Y2_edge_reg & Y1_edge_stop) //si arrancamos por Y2, esperamos
     stop_count=1;               //flanco parada en Y1 y paramos
   else
    stop_count=0; //Si no seguimos contando
end

//Registro de contador

always@(posedge clk or negedge reset_L)
if (!reset_L)
  counter<=0;
else
  counter<=counter_prev;
    

 

//*************** Fin de FSM *******************

//**********************************************
// Pipeline de registro de Y1 y Y2
	 
always@(posedge clk or negedge reset_L)
   if (!reset_L)
	   begin
		  Y1_K <= 0;
		  Y2_K <= 0;
		  Y1_K1<=0;
		  Y2_K1<=0;
        
		end
	else
	   begin
		  Y1_K <= Y1;
		  Y2_K <= Y2;
		  Y1_K1<=Y1_K;
		  Y2_K1<=Y2_K; 
       
		end	   
//Generamos senales para que FSM detecte flanco arranque y parada
assign Y1_edge_start= Y1_K^Y1;
assign Y2_edge_start= Y2_K^Y2;
assign Y1_edge_stop= Y1_K1^Y1_K;
assign Y2_edge_stop= Y2_K1^Y2_K;


//Registros de los flancos de arranque para saber quien de Y1 o Y2 disparo
always@(posedge clk or negedge reset_L)
if (!reset_L)
  begin
     Y1_edge_reg<=0;
     Y2_edge_reg<=0;
  end
else if (load_Y_edge) //Guardamos el flanco que dispara
  begin
    Y1_edge_reg<=Y1_edge_start;
    Y2_edge_reg<=Y2_edge_start;
  end
else if (clr_Y_edge) //limpiamos el registro
  begin
    Y1_edge_reg<=0;
    Y2_edge_reg<=0;
  end 

//***********************************************

//*********** TOF Counter ***********************

//Contador temporal Dejamos prevista para CLK gating


//Carga de registro de salida	 
always@(posedge clk or negedge reset_L)
   if (!reset_L)
     begin
      tof_count<=0;
      
     end
   else if (load_tof)
     begin
        tof_count<=counter;
      
     end

//Registro de senal de //Handshake de que hubo un cambio en TOF
 always@(posedge clk or negedge reset_L)
   if (!reset_L)
     begin
      tof_ready<=0;
     end
   else
     begin
        tof_ready<=load_tof;
     end
 
 
 
assign max_count_neg=(counter==8'h80);
assign max_count_pos=(counter==8'h7f);

//assign count_ov= max_count_neg|max_count_pos; //Overflow interno




endmodule
