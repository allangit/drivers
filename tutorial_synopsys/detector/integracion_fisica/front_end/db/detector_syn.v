
module divisor_frecuencia ( clk, reset, clk_2 );
  input clk, reset;
  output clk_2;
  wire   N4;

  DFFX1 clk_2_reg ( .D(N4), .CLK(clk), .Q(clk_2) );
  NOR2X0 U3 ( .IN1(clk_2), .IN2(reset), .QN(N4) );
endmodule


module detector_secuencia ( clk, reset, dato, detectada );
  input clk, reset, dato;
  output detectada;
  wire   clk_2, secuenciaFSM_nextstate_0_, secuenciaFSM_state_0_,
         secuenciaFSM_state_1_, n2, n4, n7, n8;

  divisor_frecuencia divisor_frecuencia ( .clk(clk), .reset(reset), .clk_2(
        clk_2) );
  DFFASX1 secuenciaFSM_state_reg_1_ ( .D(n4), .CLK(clk_2), .SETB(n2), .QN(
        secuenciaFSM_state_1_) );
  DFFARX1 secuenciaFSM_state_reg_0_ ( .D(secuenciaFSM_nextstate_0_), .CLK(
        clk_2), .RSTB(n2), .Q(secuenciaFSM_state_0_) );
  AOI21X1 U7 ( .IN1(secuenciaFSM_state_1_), .IN2(dato), .IN3(
        secuenciaFSM_state_0_), .QN(n7) );
  AO221X1 U8 ( .IN1(n7), .IN2(dato), .IN3(n7), .IN4(secuenciaFSM_state_1_), 
        .IN5(detectada), .Q(secuenciaFSM_nextstate_0_) );
  NAND2X0 U9 ( .IN1(secuenciaFSM_state_0_), .IN2(dato), .QN(n8) );
  AND3X1 U10 ( .IN1(secuenciaFSM_state_0_), .IN2(secuenciaFSM_state_1_), .IN3(
        dato), .Q(detectada) );
  MUX21X1 U11 ( .IN1(n8), .IN2(secuenciaFSM_state_0_), .S(
        secuenciaFSM_state_1_), .Q(n4) );
  INVX0 U12 ( .INP(reset), .ZN(n2) );
endmodule

