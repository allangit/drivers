###################################################################

# Created by write_sdc on Thu Aug 16 14:17:21 2012

###################################################################
set sdc_version 1.9

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA
set_max_fanout 10 [current_design]
set_max_area 0
set_driving_cell -lib_cell INVX8 [get_ports reset]
set_driving_cell -lib_cell INVX8 [get_ports dato]
create_clock [get_ports clk]  -period 20  -waveform {0 10}
set_clock_latency 1  [get_clocks clk]
set_clock_latency -source 1  [get_clocks clk]
set_clock_uncertainty 2  [get_clocks clk]
set_clock_transition -max -rise 1 [get_clocks clk]
set_clock_transition -max -fall 1 [get_clocks clk]
set_clock_transition -min -rise 1 [get_clocks clk]
set_clock_transition -min -fall 1 [get_clocks clk]
create_generated_clock [get_pins divisor_frecuencia/clk_2]  -name divisor_frecuencia/clk_2  -source [get_ports clk]  -divide_by 2
set_input_delay -clock clk  -max 2  [get_ports reset]
set_input_delay -clock clk  -min 1  [get_ports reset]
set_input_delay -clock clk  -max 2  [get_ports dato]
set_input_delay -clock clk  -min 1  [get_ports dato]
set_output_delay -clock divisor_frecuencia/clk_2  -max 4  [get_ports detectada]
set_output_delay -clock divisor_frecuencia/clk_2  -min 2  [get_ports detectada]
