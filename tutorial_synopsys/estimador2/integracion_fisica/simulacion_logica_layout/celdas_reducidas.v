`timescale 1ns / 1ns

module DFFX1 (D,CLK,Q,QN);

output  Q,QN;
input   D,CLK;
reg notifier;

pullup (rstb);
pullup (setb);
saed90_dff_pos (Q_buf, D, CLK, rstb, setb, notifier);  
buf (Q,Q_buf);
not (QN,Q_buf);

    not (nD, D);
    not (nCLK, CLK);

  // Timing logics defined for default constraint check
  pullup  (CLK_check);
  pullup  (D_check);
endmodule



module DFFARX1 (D,CLK,RSTB,Q,QN);
output  Q,QN;
input   D,CLK,RSTB;
reg notifier;
pullup (setb);
saed90_dff_pos (Q_buf, D, CLK, RSTB, setb, notifier);  
buf (Q, Q_buf);
not (QN,Q_buf);

    not (nD, D);
    not (nCLK, CLK);
    and (CLK_D, CLK, D);
    and (CLK_nD, CLK, nD);
    and (nCLK_D, nCLK, D);
    and (nCLK_nD, nCLK, nD);
    and (RSTB_D, RSTB, D);
    and (RSTB_nD, RSTB, nD);

    buf      (RSTB_i, RSTB);
    buf  (CLK_check, RSTB_i);
    buf  (D_check, RSTB_i);
endmodule


module XOR2X1 (IN1,IN2,Q);
output  Q;
input   IN1,IN2;

xor #1 (Q,IN2,IN1);
endmodule


module HADDX1 (A0,B0,SO,C1);
output  SO,C1;
input   A0,B0;

xor  #1  (SO,B0,A0);
and  #1  (C1,B0,A0);
endmodule


module INVX0 (INP,ZN);
output  ZN;
input   INP;

not #1 (ZN,INP);
endmodule


module XNOR2X1 (IN1,IN2,Q);
output  Q;
input   IN1,IN2;

xnor #1 (Q,IN2,IN1);
endmodule


module NOR2X0 (IN1,IN2,QN);
output  QN;
input   IN1,IN2;

nor #1 (QN,IN2,IN1);
endmodule


module DFFNX1 (D,CLK,Q,QN);
output  Q,QN;
input   D,CLK;
reg notifier;

pullup (rstb);
pullup (setb);
saed90_dff_neg (Q_buf, D, CLK, rstb, setb, notifier);  
buf (Q,Q_buf);
not (QN,Q_buf);

    not (nD, D);
    not (nCLK, CLK);

  // Timing logics defined for default constraint check
  pullup  (CLK_check);
  pullup  (D_check);
endmodule

module AOI21X1 (IN1,IN2,IN3,QN);

output  QN;
input   IN1,IN2,IN3;

and (g_1_out,IN1,IN2);
nor #1 (QN,g_1_out,IN3);
endmodule


module DFFASX1 (D,CLK,SETB,Q,QN);
output  Q,QN;
input   D,CLK,SETB;
reg notifier;

pullup (rstb);
saed90_dff_pos (Q_buf, D, CLK, rstb, SETB, notifier);  
buf (Q, Q_buf);
not (QN,Q_buf);

    not (nD, D);
    not (nCLK, CLK);
    and (SETB_D, SETB, D);
    and (SETB_nD, SETB, nD);
    and (CLK_D, CLK, D);
    and (CLK_nD, CLK, nD);
    and (nCLK_D, nCLK, D);
    and (nCLK_nD, nCLK, nD);

  // Timing logics defined for default constraint check
 buf      (SETB_i, SETB);
buf  (CLK_check, SETB_i);
  buf  (D_check, SETB_i);
endmodule


module FADDX1 (A,B,CI,S,CO);
output  S,CO;
input   A,B,CI;

wire nCI, nA, nB, aq1, aq2, aq3, aq4, aq5, aq6, aq7;

not (nCI, CI);
not (nA, A);
not (nB, B);

and (aq1, nCI, nB, A);
and (aq2, nCI, B, nA);
and (aq3, CI, nA, nB);
and (aq4, CI, B, A);
and (aq5, nCI, B, A);
and (aq6, CI, nB, A);
and (aq7, CI, B, nA);

or (S, aq1, aq2, aq3, aq4);

or (CO, aq4, aq5, aq6, aq7);
endmodule


module NAND4X0 (IN1,IN2,IN3,IN4,QN);
output  QN;
input   IN1,IN2,IN3,IN4;

nand #1 (QN,IN4,IN3,IN2,IN1);
endmodule

module AND2X1 (IN1,IN2,Q);
output  Q;
input   IN1,IN2;

and #1 (Q,IN2,IN1);
endmodule


module NAND2X0 (IN1,IN2,QN);
output  QN;
input   IN1,IN2;

nand #1 (QN,IN2,IN1);
endmodule


module AO221X1 (IN1,IN2,IN3,IN4,IN5,Q);
output  Q;
input   IN1,IN2,IN3,IN4,IN5;

and (g_1_out,IN2,IN1);
and (g_2_out,IN3,IN4);
or #1 (Q,g_1_out,g_2_out,IN5);
endmodule

module OA21X2 (IN1,IN2,IN3,Q);
output  Q;
input   IN1,IN2,IN3;

or (g_2_out,IN1,IN2);
and #1 (Q,IN3,g_2_out);
endmodule


module OA221X1 (IN1,IN2,IN3,IN4,IN5,Q);
output  Q;
input   IN1,IN2,IN3,IN4,IN5;

or (g_2_out,IN2,IN1);
or (g_3_out,IN3,IN4);
and #1 (Q,IN5,g_2_out,g_3_out);
endmodule

module AO22X1 (IN1,IN2,IN3,IN4,Q);
output  Q;
input   IN1,IN2,IN3,IN4;

and (g_1_out,IN2,IN1);
and (g_2_out,IN4,IN3);
or #1 (Q,g_1_out,g_2_out);
endmodule

module XOR3X1 (IN1,IN2,IN3,Q);
output  Q;
input   IN1,IN2,IN3;

xor #1 (Q,IN3,IN2,IN1);
endmodule


module OR4X1 (IN1,IN2,IN3,IN4,Q);
output  Q;
input   IN1,IN2,IN3,IN4;

or #1 (Q,IN4,IN3,IN2,IN1);
endmodule


module NAND2X1 (IN1,IN2,QN);
output  QN;
input   IN1,IN2;

nand #1 (QN,IN2,IN1);
endmodule


module NOR3X0 (IN1,IN2,IN3,QN);
output  QN;
input   IN1,IN2,IN3;

nor #1 (QN,IN3,IN2,IN1);
endmodule

module AND3X1 (IN1,IN2,IN3,Q);
output  Q;
input   IN1,IN2,IN3;

and #1 (Q,IN3,IN2,IN1);
endmodule


module INVX2 (INP,ZN);
output  ZN;
input   INP;

not #1 (ZN,INP);
endmodule


module NOR4X0 (IN1,IN2,IN3,IN4,QN);
output  QN;
input   IN1,IN2,IN3,IN4;

nor #1 (QN,IN4,IN3,IN2,IN1);
endmodule


module OR2X1 (IN1,IN2,Q);
output  Q;
input   IN1,IN2;

or #1 (Q,IN2,IN1);
endmodule

module AND4X1 (IN1,IN2,IN3,IN4,Q);
output  Q;
input   IN1,IN2,IN3,IN4;

and #1 (Q,IN4,IN3,IN2,IN1);
endmodule


module AO222X1 (IN1,IN2,IN3,IN4,IN5,IN6,Q);
output  Q;
input   IN1,IN2,IN3,IN4,IN5,IN6;

and (g_1_out,IN2,IN1);
and (g_2_out,IN4,IN3);
and (g_3_out,IN6,IN5);
or #1 (Q,g_1_out,g_2_out,g_3_out);
endmodule

module MUX21X1 (IN1,IN2,S,Q);
output  Q;
input   IN1,IN2,S;

wire nS, aq1, aq2;

not (nS, S);
and (aq1, nS, IN1);
and (aq2, S, IN2);
or (Q, aq1, aq2);
endmodule

module XNOR3X1 (IN1,IN2,IN3,Q);

output  Q;
input   IN1,IN2,IN3;

xnor #1 (Q,IN3,IN2,IN1);
endmodule


module AOI22X1 (IN1,IN2,IN3,IN4,QN);

output  QN;
input   IN1,IN2,IN3,IN4;

and (g_1_out,IN2,IN1);
and (g_2_out,IN4,IN3);
nor #1 (QN,g_1_out,g_2_out);
endmodule


primitive saed90_xbuf (o, i, dummy);
   output o;     
   input i, dummy;
   table         
   // i dummy : o
      0   1   : 0 ;
      1   1   : 1 ;
      x   1   : 1 ;
   endtable      
endprimitive 


primitive saed90_mux (q, d0, d1, s );
   output q;
   input s, d0, d1;

   table
   // d0  d1  s   : q 
      0   ?   0   : 0 ;
      1   ?   0   : 1 ;
      ?   0   1   : 0 ;
      ?   1   1   : 1 ;
      0   0   x   : 0 ;
      1   1   x   : 1 ;
   endtable
endprimitive


primitive saed90_dff_pos (q, d, clk, rstb, setb, notifier);
   output q;
   input d, clk, rstb, setb, notifier;
   reg q;
   table
   // d   clk   rstb   setb  ntfr	  Q
      ?     ?     0     ?     ?  :  ?  :  0  ; // RST dominate SET
      ?     ?     1     0     ?  :  ?  :  1  ; // SET is set   
      ?     ?     1     x     ?  :  0  :  x  ; // SET affect Q
      ?     ?     1     x     ?  :  1  :  1  ; // Q=1,preset=X
      ?     ?     x     1     ?  :  0  :  0  ; // Q=0,clear=X
      0    (01)   ?     1     ?  :  ?  :  0  ; // Latch 0
      0     *     ?     1     ?  :  0  :  0  ; // Keep 0 (D==Q)
      1    (01)   1     ?     ?  :  ?  :  1  ; // Latch 1   
      1     *     1     ?     ?  :  1  :  1  ; // Keep 1 (D==Q)
      ?    (1?)   1     1     ?  :  ?  :  -  ; // ignore negative edge of clock
      ?    (?0)   1     1     ?  :  ?  :  -  ; // ignore negative edge of clock
      ?     ?    (?1)   1     ?  :  ?  :  -  ; // ignore positive edge of RST
      ?     ?     1    (?1)   ?  :  ?  :  -  ; // ignore posative edge of SET
      *     ?     1     1     ?  :  ?  :  -  ; // ignore data change on steady clock
//    ?     ?     ?     ?     *  :  ?  :  x  ; // timing check violation
   endtable
endprimitive

primitive saed90_dff_neg (q, d, clk, rstb, setb, notifier);
   output q;
   input d, clk, rstb, setb, notifier;
   reg q;
   table
   // d   clk   rstb   setb  ntfr	  Q
      ?     ?     0     ?     ?  :  ?  :  0  ; // RST dominate SET
      ?     ?     1     0     ?  :  ?  :  1  ; // SET is set   
      ?     ?     1     x     ?  :  0  :  x  ; // SET affect Q
      ?     ?     1     x     ?  :  1  :  1  ; // Q=1,preset=X
      ?     ?     x     1     ?  :  0  :  0  ; // Q=0,clear=X
      0    (10)   ?     1     ?  :  ?  :  0  ; // Latch 0
      0     *     ?     1     ?  :  0  :  0  ; // Keep 0 (D==Q)
      1    (10)   1     ?     ?  :  ?  :  1  ; // Latch 1   
      1     *     1     ?     ?  :  1  :  1  ; // Keep 1 (D==Q)
      ?    (0?)   1     1     ?  :  ?  :  -  ; // ignore positive edge of clock
      ?    (?1)   1     1     ?  :  ?  :  -  ; // ignore positive edge of clock
      ?     ?    (?1)   1     ?  :  ?  :  -  ; // ignore positive edge of RST
      ?     ?     1    (?1)   ?  :  ?  :  -  ; // ignore posative edge of SET
      *     ?     1     1     ?  :  ?  :  -  ; // ignore data change on steady clock
//    ?     ?     ?     ?     *  :  ?  :  x  ; // timing check violation
   endtable
endprimitive


primitive saed90_dla_high (q, d, clk, rst, set, notifier);
   output q;
   reg q;
   input d, clk, rst, set, notifier;
   table
 //   d     clk   rst   set   ntfr          Q
      1     1     1     ?     ?   :  ?  :  1  ; // Latch 1
      0     1     ?     1     ?   :  ?  :  0  ; // Latch 0
      0    (10)   1     1     ?   :  ?  :  0  ; // Latch 0 after falling edge
      1    (10)   1     1     ?   :  ?  :  1  ; // Latch 1 after falling edge
      *     0     ?     ?     ?   :  ?  :  -  ; // no changes
      ?     ?     ?     0     ?   :  ?  :  1  ; // preset to 1
      ?     0     1     *     ?   :  1  :  1  ;
      1     ?     1     *     ?   :  1  :  1  ;
      1     *     1     ?     ?   :  1  :  1  ;
      ?     ?     0     1     ?   :  ?  :  0  ; // reset to 0
      ?     0     *     1     ?   :  0  :  0  ;
      0     ?     *     1     ?   :  0  :  0  ;
      0     *     ?     1     ?   :  0  :  0  ;
//    ?     ?     ?     ?     *   :  ?  :  x  ; // toggle notifier
   endtable
endprimitive


primitive saed90_dla_low (q, d, clk, rst, set, notifier);
   output q;
   reg q;
   input d, clk, rst, set, notifier;
   table
 //   d     clk   rst   set   ntfr          Q
      1     0     1     ?     ?   :  ?  :  1  ; // Latch 1
      0     0     ?     1     ?   :  ?  :  0  ; // Latch 0
      0    (01)   1     1     ?   :  ?  :  0  ; // Latch 0 after rising edge
      1    (01)   1     1     ?   :  ?  :  1  ; // Latch 1 after rising edge
      *     1     ?     ?     ?   :  ?  :  -  ; // no changes
      ?     ?     ?     0     ?   :  ?  :  1  ; // preset to 1
      ?     1     1     *     ?   :  1  :  1  ;
      1     ?     1     *     ?   :  1  :  1  ;
      1     *     1     ?     ?   :  1  :  1  ;
      ?     ?     0     1     ?   :  ?  :  0  ; // reset to 0
      ?     1     *     1     ?   :  0  :  0  ;
      0     ?     *     1     ?   :  0  :  0  ;
      0     *     ?     1     ?   :  0  :  0  ;
//    ?     ?     ?     ?     *   :  ?  :  x  ; // toggle notifier
   endtable
endprimitive













