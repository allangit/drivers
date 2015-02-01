`timescale 1us / 1us

module testbench;

	// Inputs
	reg clk;
	reg reset;
	reg dato;

	// Outputs
	wire detectada;
	

	// Instantiate the Unit Under Test (UUT)
	detector_secuencia uut (
		.clk(clk), 
		.reset(reset), 
		.dato(dato), 
		.detectada(detectada)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		dato = 0;

		#80 reset = 1; //hacer reset
		
		#40 reset = 0; 

      #40 dato = 1;  //secuencia= 1
		
		#160 dato = 0; //secuencia= 110
		
		#80 dato = 1;  //secuencia= 1101 -> detectada = 1

      #160 dato = 0; //secuencia= 110110

      #80 dato = 1;  //secuencia= 1101101 -> detectada = 1		
		
		#80 dato = 0;  //secuencia= 11011010
      
		#80 dato = 1;  //secuencia= 110110101	
 
      #240 dato = 0; //secuencia= 110110101110

      #80 dato = 1;  //secuencia= 1101101011101 -> detectada = 1		
     		
		
	end
	
      always
       #20 clk = ~clk;   //generador clk, f=50 kHz
		 
endmodule

