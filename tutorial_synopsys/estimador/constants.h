//**********************************
// Estados de la FSM TOF_counter

parameter  start_state   = 2'b00,
           count_state   = 2'b01,
	       count2_state = 2'b10;


//Definimos las constantes de control del mux del Data_path
// 00 <= pasa por mux reg = reg
// 01 <= pasa por mux reg+1 = inc_reg
// 10 <= pasa por mux reg-1 = dec_reg
			 
//parameter keep_reg = 2'b01,
//	  inc_reg  = 2'b10,
//	  dec_reg  = 2'b11;


//**********************************
//Estados de la FSM linear_est
parameter  start_le      =3'b000,
	       load_W_le     =3'b001,
	       load_mult_le  = 3'b010,
	       mult_le       =3'b011;
	      
//***********************************
//Estados de la FSM bin_search
parameter  start_bs    =3'b000,
           //compare_pos =3'b001,
           //compare_neg =3'b101,
	       compare    =3'b001,
	       increment_x = 3'b010,
	       decrement_x =3'b011,
	       update_y   =3'b100;
	       
//Parametros de simulacion

parameter PERIOD = 50;
parameter PERIOD_SLOW=50; //A 200kHz, periodo de 5us, o 50x100ns
