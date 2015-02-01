####################################################################################################################################

#Institución:                          Instituto Tecnológico de Costa Rica

#Realizado por:		   Jairo Mauricio Valverde Cruz           jmvc04@gmail.com

#Proyecto:   Detector de secuencia: 1101. Proyecto creado con fines didácticos.

#Herramienta:        Design Compiler  Version E-2010.12-SP1 for linux -- Jan 17, 2011

#Fecha de creación:  27 Agosto 2011  
#Fecha de modificación:  14 Agosto 2012
#                       Se actualiza frecuencia de trabajo a 50MHz (ACR)
#Refrencias (detalladas en el Manual - Wiki):
# 1. A. Chacón, 2009.  
# 2. Manuales de Design Compiler.
# 3. Bindu, 2009. 
####################################################################################################################################


########Definición de las variables a utilizar###########

set LIB_NAME saed90nm_max.db

set CLK_PERIOD 20 
set CLK_NAME clk

set CLK_2_NAME divisor_frecuencia/clk_2

# Se definen las tolerancias del reloj. Normalmente, esta informacion debe ser provista desde el backend.
set CLK_UNCERTAINTY_SETUP 2
set CLK_UNCERTAINTY_HOLD 2
set CLK_TRANSITION 1
set CLK_LATENCY_SOURCE 1
set CLK_LATENCY 1

# Define los tiempos de interfaz con los modulos de entrada y salida
set INPUT_DELAY_MAX 2
set INPUT_DELAY_MIN 1
set OUTPUT_DELAY_MAX 4
set OUTPUT_DELAY_MIN 2
#No hay limite de area
set MAX_AREA 0
# Numero maximo de carga a la salida de las compuertas
set FANOUT 10
# El reloj nunca es optimizado por DesignCompiler. Para eso se usara el programa
# Clock-Sythesis del IC Compiler
set ALL_IN_EX_CLK_NAME [remove_from_collection [all_inputs] [get_ports $CLK_NAME]]
# Las entradas son manejadas por este tipo de celda
set INPUT_CELL INVX8

#########################################################################################################


##########################Configuación del reloj clk   ##################################################
#Se configura el clock a una frecuencia de 50 MHz                                        -> page 5-8
create_clock -period $CLK_PERIOD [get_ports $CLK_NAME]

#No colocar buffers en la red del reloj siempre y cuando los flip-flops cargen en alto
set_dont_touch_network [get_clocks $CLK_NAME]

#Configuración de clock skew (retardos entre las diferentes ramificaciones del reloj)    -> page 5-11, 7-21
set_clock_uncertainty -setup $CLK_UNCERTAINTY_SETUP [get_clocks $CLK_NAME]
set_clock_uncertainty -hold $CLK_UNCERTAINTY_HOLD [get_clocks $CLK_NAME]

#Configuración del retardo de transición del clock					 -> page 5-13
set_clock_transition $CLK_TRANSITION [get_clocks $CLK_NAME]

#Configuración del retardo del clock en la entrada                                       -> page 5-12
set_clock_latency -source $CLK_LATENCY_SOURCE [get_clocks $CLK_NAME]
set_clock_latency $CLK_LATENCY [get_clocks $CLK_NAME]
##########################################################################################################


##########################Configuación del los relojes generados internamente ############################

## reloj clk_2 
create_generated_clock -name $CLK_2_NAME -divide_by 2 -source [get_ports $CLK_NAME] [get_pins $CLK_2_NAME]                                   
set_dont_touch_network [get_clocks $CLK_2_NAME]
                                   
########################################################################################################## 
                         

#Configuración del retardo de todas las señales de entrada, excepto la del clock         -> page 5-19, 7-
set_input_delay -max $INPUT_DELAY_MAX -clock $CLK_NAME $ALL_IN_EX_CLK_NAME
set_input_delay -min $INPUT_DELAY_MIN -clock $CLK_NAME $ALL_IN_EX_CLK_NAME

#Configuración del retardo en las señales de salida				         -> page 5-26, 7-18
set_output_delay -max $OUTPUT_DELAY_MAX -clock $CLK_2_NAME [get_ports detectada]
set_output_delay -min $OUTPUT_DELAY_MIN -clock $CLK_2_NAME [get_ports detectada]

#Configuración del fanout
set_max_fanout $FANOUT $current_design

#Optimizar el uso del área
set_max_area $MAX_AREA

#Configuración de la celda que maneja todas las entradas (cell driving inputs)   ------   pg -6-22 Chip Synthesis
set_driving_cell -lib_cell $INPUT_CELL $ALL_IN_EX_CLK_NAME
