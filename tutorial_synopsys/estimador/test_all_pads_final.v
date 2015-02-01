
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:15:23 12/04/2006
// Design Name:   top_unit
// Module Name:   C:/ProyectosFPGA/adaptivo_ver4/test_total.v
// Project Name:  adaptivo_ver4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_all_pads_final;
`include "constants.h" 



	// Inputs to the units under test
	reg x1;
	reg x2;
	reg clk;
	reg reset_L;
	reg l_r;
	reg [3:0] W_ext;

	// Outputs
	wire signed [7:0] Y_output_bin, Y_output_le;
	wire data_ready_bin,  data_ready_le;
	wire signed [7:0] tof_count; //para sacar lo que mide el contador ToF
	
	
	//variables de simulacion
	
	integer retardo, ret_teor; //estas variables se usan para definir los periodos y retardos
	                     //de las senales a simular.
	integer periodo_senal;
	integer loops; //Numero de veces que iteremos senal
	integer i;
   integer hand; //handle para el archivo a revisar en matlab
   
	// Instantiate the Unit Under Test (UUT)
//Testeamos en paralelo, el buscador binario
/*top_bin_search_pad uut1 (.clk_pad(clk),
               .reset_L_pad(reset_L),
               .X1_pad(x1),
               .X2_pad(x2),
               .Y_output_pad(Y_output_bin),
               .data_ready_pad(data_ready_bin)); */
               
 //y el estimador lineal              
               
top_linear_est_pad uut2 (.clk(clk),
               .reset_L(reset_L),
               .X1(x1),
               .X2(x2),
               .Y_output(Y_output_le),
               .data_ready(data_ready_le),
               .l_r(l_r),
               .W_ext(W_ext));
               


               
//Sacamos medicion del sensor TOF     
     assign tof_count=	uut2.tof_count;          
   // assign tof_count=retardo;

//Proceso de testeo              
	initial begin
	 
	
	      
//$display("\tx1,\tx2,\tdata_ready,\tret, \tTOF, \tY_bin, \tdata_ready_lin,\tY_lin"); 
//$monitor("\t%b,\t%b,\t%b,\t%d, \t%d, \t%d, \t%b, \t%d",
  //              x1, x2, data_ready_bin, ret_teor, tof_count,
  //                  Y_output_bin, data_ready_le, Y_output_le);         
              
    // Vamos a guardar en un archivo de texto para poder evaluar en Matlab
    
//hand=$fopen("archivo_sim_syn_chk.txt");
//$fdisplay(hand, "\tclk,\tx1,\tx2,\tdata_ready,\tret,\tTOF, \tY_bin, \tdata_ready_lin,\tY_lin, \tdata_ready_lin2,\tY_lin2"); 
//$fmonitor(hand, "\t%b,\t%b,\t%b,\t%b,\t%d, \t%d, \t%d, \t%b, \t%d,\t%b, \t%d",
//                clk, x1, x2, data_ready_bin, ret_teor, tof_count,
//                    Y_output_bin, data_ready_le, Y_output_le,
//                    data_ready_le_2, Y_output_le_2 );
    
          
		// Initialize Inputs

		x1 = 0;
		x2 = 0;
		reset_L=0;
		l_r=0; //Vamos a leer solo por ahora
		W_ext=4'h8;
      retardo=0;
		// Wait 100 ns for global reset to finish
		#100;
        reset_L=1;
		// Add stimulus here
		
		//Cargamos nueva constante en chip 2
		@(posedge clk)
		W_ext=4'hB; //0.6875,  constante
		l_r=1;
		//mantenemos por al menos dos ciclos
		@(posedge clk)
		@(posedge clk)
		l_r=0;
		
	     //Desfase 10 ciclos
		   wait_task(20); //espera 20 ciclos
			loops=6;
			periodo_senal=150; //1000 tics de clock dura medio periodo una senal de 10k
		                       //con periodo de clock=5us
			retardo=65; //con un retardo de 10 tics
			
			atrasa(retardo, periodo_senal, loops);//atrasa 10 tics
					
         //adelanta(retardo, periodo_senal, loops);//adelanta 10 tics
        
	    //$stop;
	      retardo=130;
	    //ahora con un retardo mayor
	      //loops=20;
	      
       adelanta(retardo, periodo_senal, loops);//atrasa 
	    atrasa(retardo, periodo_senal, loops);//ahora adelantamos
	    adelanta(retardo, periodo_senal, loops);//atrasa//$stop;
	  	 retardo=46;
	    //ahora con un adelanto mayor
	    //loops=20;
	    
       adelanta(retardo, periodo_senal, loops);
	    
	    
	   	 //ahora adelantamos hasta saturacion
	  	  //ahora con un adelanto mayor
	    //loops=20;
	    retardo=25;
	    
	    adelanta(retardo, periodo_senal, loops); 
	    
	 //Ahora para el otro lado
	     //loops=20; //para que alcance la evolucion
	     
	     atrasa(retardo, periodo_senal, loops);
	    
	    // loops=20;
        retardo=1;
	//para terminar las ponemos en fase
	     atrasa(retardo, periodo_senal, loops);
	     adelanta(retardo, periodo_senal, loops);
	//$stop;
		 
       retardo=2;
	//para terminar las ponemos en fase
	     
        atrasa(retardo, periodo_senal, loops);
   //     adelanta(retardo, periodo_senal, loops);
	
        retardo=5;
        
	//     atrasa(retardo, periodo_senal, loops);
	     
	     adelanta(retardo, periodo_senal, loops);
		  
 //      retardo=1;
	//     atrasa(retardo, periodo_senal, loops);
	    retardo=48;
	    adelanta(retardo, periodo_senal, loops);		  		  
		  
   //     retardo=150;
	//     atrasa(retardo, periodo_senal, loops);
	//     adelanta(retardo, periodo_senal, loops);
	     atrasa(retardo, periodo_senal, loops);
	     //cerramos archivo de monitoreo y salimos
	    
	    //$fclose(hand);
		 $stop;

	end
	
		
	//clock generation
	initial begin
	
      clk = 1'b0;
      #(PERIOD_SLOW/2);
      forever
         #(PERIOD_SLOW/2) clk = ~clk;
   end
   
//********************************************************	
//Procedimiento que espera index ciclos de reloj	
task wait_task;
	     input integer index;
	//Variable de cuenta
   integer	j; //variable de cuenta del for

   begin
            //$display("Llamada a espera con T=\t\index,\tclk");
            //$display("\t%d, \t%b", index, clk);
           
            	for (j=1; j<=index; j=j+1) //Vamos a contar cinco pulsos de clk (retardo de Y2=4)
             begin 
              @(posedge clk);
              //#10;
             end
	end
endtask	

//******* Task que genera senal atrasada ******
task atrasa;
	     input integer ret; //valor del retraso
	     input integer per; //valor del periodo
	     input integer lazo;//valor de interacion o ciclos que repite la senal
	     reg  signed [3:0] noise; //Variable de ruido de 4 bits 
	//Variable de cuenta
   integer	j; //variable de cuenta del for

   begin
    ret_teor=retardo;
   	for (j=1; j<=lazo; j=j+1) //Vamos a contar dos ciclos grandes
       begin
      //Colocamos un poco de incertidumbre en ret y per, usando la funcion
       //random
        noise=$random%4; //4 bits de ruido
        //noise=0;
        ret=ret+(noise/2); //2 bits de ruido en retardo
        per=per+(noise); 
           
		   //generamos un atraso de retardo en X2
		   x1=1; x2=0;
		   wait_task(ret); //espera retardo
		   x1=1; x2=1;
		   wait_task(per); //espera periodo
		   x1=0; x2=1;
		   wait_task(ret); //espera retardo
		   x1=0; x2=0;
		   wait_task(per); //espera periodo
	    end// del ciclo for
	end
 endtask
//*******************************************************

	
	//******* Task que genera senal adelantada ******
	//**** Es identica a atrasa, solo que va conmutando al reves x1 y x2
	
	task adelanta;
	     input integer ret; //valor del retraso
	     input integer per; //valor del periodo
	     input integer lazo;//valor de interacion o ciclos que repite la senal
	     reg  signed [3:0] noise; //Variable de ruido de 4 bits 
	//Variable de cuenta
   integer	j; //variable de cuenta del for

   begin       
        ret_teor=(-1)*retardo;
	    	for (j=1; j<=lazo; j=j+1) //Vamos a contar dos ciclos grandes
         begin  
          noise=$random%4; //4 bits de ruido
          //noise=0;
          ret=ret+(noise/2); //2 bits de ruido en retardo
          per=per+(noise);      
         
		   //ahora con X2 adelantado con un valor de -"retardo"
		   x1=0; x2=1;
		   wait_task(ret); //adelanto
		   x1=1; x2=1;
		   wait_task(per); //espera periodo
		   x1=1; x2=0;
		   wait_task(ret); //adelanto
		   x1=0; x2=0;
		   wait_task(per); //espera periodo
	      end// del ciclo for
	end
	
	
	
endtask	


      
      
endmodule

