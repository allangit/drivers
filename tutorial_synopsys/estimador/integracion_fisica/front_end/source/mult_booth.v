//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:40:33 05/03/2008 
// Design Name: 
// Module Name:    mult_booth 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Algoritmo de Booth para multiplicar, 
//              modificado para reducir consumo
//              No se pasan bits menos significativos, para emular la division por
//              16 a la salida que requiere este sistema.
//              Puesto que Q_reg solo tendra hasta 4 bits positivos, pero necesitamos
//              Los 5 bits para el algoritmo, este se lo ponemos como apendice 
//              siempre en 0. 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mult_booth(clk, reset_L, Q, M, done, start, P);
// parametrers
parameter   M_size  = 8,   // Multiplicand number of bits
            Q_size  = 8,   // Multiplier, number of bits
            P_size  = 16;
				// Q_size da el numero de iteraciones

  //inputs
    input clk;
    input reset_L;
    input signed [(M_size-1):0] M;
    input signed [(Q_size-1):0] Q;
	 input start; //Arranque del multiplicador
	 //outputs
    output done; //Resultado listo
    output signed [(P_size-1):0] P;
                         
// variables internas
//Estas son shorthands para no escribir tanto
wire [ (P_size-1):0]      P;      // product: P=M*Q
wire [ (M_size-1):0 ]     M;      // multiplicand
wire [ (Q_size-1):0 ]     Q;      // multiplier

// internal signals
reg     signed      [ (M_size-1) : 0] M_reg;
reg     signed      [ (Q_size-1) : 0] Q_reg;
reg     signed      [ (M_size-1) : 0] A_reg; //Registro acumulador
reg     signed      [  M_size : 0 ]   next_A;
reg     signed      [  (Q_size) : 0 ]   C_reg; //Contador de iteracion
reg     signed                        Q_1; //Qn+1
reg     signed                        work;
reg     done; 

// Algorithm Begin
always @( posedge clk or negedge reset_L )
begin : booth_algorith
    if (!reset_L)
       begin : reset_registers
         M_reg <= 0;
         Q_reg <= 0;
         A_reg <= 0;
         C_reg <= 0;
         Q_1   <= 0;
         done <= 0;
       end // end_erset_registers
    else if (start) 
//Se cargan registros de operandos y se se actualizan sennales de control
           begin : init_registers
             M_reg <= M;
             Q_reg <= Q;
             A_reg <= 0;
             C_reg <= {1'b1, {Q_size{1'b0}}}; //El tamanno de Q nos da las cuentas
				 // Creamos una variable del tamano+1  del multiplicando y la vamos desplazando
				 // Cuando llegamos al 1, es que acabamos las iteracions. Nos ahorramos un
				 // restador y usamos un desplazador. Especie de codificacion OneHot. Solo dos
				 // cambios de bit por iteracion. 
             Q_1      <= 0;
             done     <= 0;
             work     <= 1'b1;
                                        
           end // end_init_registers
			
		// Si no viene arranque, y estamos en operacion (!p_done) entonces
     // Se suma, resto o se hace shift aritmetico dependiendo de Qn y Qn+1;		
         else if (!done)
            begin : shift_regs
             if ( C_reg[0]== 0 ) //No hemos llegado al final iteracion
                begin : not_done
                  
                   { A_reg, Q_reg, Q_1 } <= { next_A, Q_reg }; //shift right
                   C_reg <= { 1'b0, C_reg[ Q_size : 1 ] }; //shr del C_ref
                end
             else
               begin : p_is_done
                   done <= 1'b1;
               end // end_p_is_done
            end // end_shift_regs
end // end_booth_algorithm


// booth algorithm multiplexer
always @( * )
begin
    if ( { Q_reg[0], Q_1 } == 2'b10 )
    begin : substract_branch
         next_A <= A_reg - M_reg;
    end // end_substract
    else if ( { Q_reg[0], Q_1 } == 2'b01 )
    begin : add_branch
         next_A    <= A_reg + M_reg;
    end // end_add
    else
    begin : only_shift
         next_A    <= A_reg;
    end // end_only_shift
end
// output assignment
assign P = { A_reg, Q_reg }; //Solo necesitamos P=A_Reg


endmodule
