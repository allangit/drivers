####################################################################################################################################
#Institución:                          Instituto Tecnológico de Costa Rica

#Realizado por:		   Jairo Mauricio Valverde Cruz           jmvc04@gmail.com

#Proyecto:   Detector de secuencia: 1101. Proyecto creado con fines didácticos

#Herramienta:        Version E-2010.12-SP1 for linux -- Jan 13, 2011

#Fecha de creación:  29 Agosto 2011 

#Refrencias (detalladas en el Manual - Wiki):
# 1. Bindu, 2009. 
# 2. Manuales de Design Compiler.
####################################################################################################################################


# El siguente comando concatena al search path los directorios listados
set search_path {/home/jvalverde/detector/integracion_fisica/temporizado_layout/libs} 
set search_path    "$search_path ./libs ./reports ./source ./scripts"

# El comando set establece un valor para una variable. 
set link_library  "* saed90nm_max.db saed90nm_min.db saed90nm_typ.db"
set target_library "saed90nm_max.db"

echo "search_path:       $search_path"
echo "link_library:      $link_library"
echo "target_library:    $target_library"

# Leer el archivo de verilog obtenido al final de la implementación física (detector_phy.v)
read_verilog /home/jvalverde/detector/integracion_fisica/temporizado_layout/source/detector_phy.v

#Definir el módulo principal
current_design detector_secuencia

#Leer las capacitancias parásitas máximas
read_parasitics -format SPEF /home/jvalverde/detector/integracion_fisica/temporizado_layout/source/detector_phy.spef.max

#Leer las especificaciones de temporizado
read_sdc /home/jvalverde/detector/integracion_fisica/temporizado_layout/source/detector_phy.sdc

#Generar reportes de temporizado
report_timing -from [all_inputs] -to [all_registers -data_pins] -max_paths 40 > reports/entrada_registro.txt
report_timing -from [all_register -clock_pins] -to [all_registers -data_pins] -max_paths 40 > reports/registro_registro.txt
report_timing -from [all_register -clock_pins] -to [all_outputs] -max_paths 40 > reports/registro_salida.txt

#Leer las capacitancias parásitas mínimas
read_parasitics -format SPEF /home/jvalverde/detector/integracion_fisica/temporizado_layout/source/detector_phy.spef.min

#Generar el reporte de temporizado de registro a registro con el tiempo de transición y la capacitancia
report_timing -transition_time -capacitance -nets -input_pins -from [all_registers -clock_pins] -to [all_registers -data_pins] > reports/criticas_tran_cap.txt










