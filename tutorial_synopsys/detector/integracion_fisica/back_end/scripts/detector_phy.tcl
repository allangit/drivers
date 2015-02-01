####################################################################################################################################
#Institución:                          Instituto Tecnológico de Costa Rica

#Realiza por:		   Jairo Mauricio Valverde Cruz           jmvc04@gmail.com

#Proyecto:   Detector de secuencia: 1101. Proyecto creado con fines didácticos.

#Herramienta:        IC Compiler   Version E-2010.12-ICC-SP1 for linux -- Jan 10, 2011

#Fecha de creación:  01 Marzo 2011, editado 29 Agosto 2011

#Refrencias (detalladas en el Manual - Wiki):
# 1. Bindu, 2009.
# 2. Manuales de IC Compiler.            
####################################################################################################################################

# El siguente comando concatena al search path los directorios listados
set search_path {/home/jvalverde/detector/integracion_fisica/back_end} 
set search_path    "$search_path ./libs ./db ./source ./scripts"

# Configuración de las bibliotecas de síntesis. 
set link_library  "* saed90nm_max.db saed90nm_min.db saed90nm_typ.db"
set target_library "saed90nm_max.db"
set symbol_library "saed90nm.sdb"

#Muestra la configuración de las biliotecas de síntesis.
echo "\n\nSettings:"
echo "search_path:       $search_path"
echo "link_library:      $link_library"
echo "target_library:    $target_library"
echo "symbol_library:    $symbol_library"

#remover diseños anteriores
remove_design -designs

#Definir VSS y VDD
set mw_logic0_net VSS
set mw_logic1_net VDD

#Especificar los archivos TLUplus:Son utilizados para extraer el archivo ".spef" (capacitancias parásitas)
set_tlu_plus_files -max_tluplus ./libs/tluplus/saed90nm_1p9m_1t_Cmax.tluplus -min_tluplus ./libs/tluplus/saed90nm_1p9m_1t_Cmin.tluplus -tech2itf_map ./libs/tech/tech2itf.map

#Crear una nueva base de datos Milkway, solo se hace una vez para cada diseño
#create_mw_lib  -technology /home/jvalverde/detector/integracion_fisica/back_end/libs/tech/astroTechFile.tf -mw_reference_library {/home/jvalverde/detector/integracion_fisica/back_end/libs/saed90nm_fr/} -bus_naming_style {[%d]}  /home/jvalverde/detector/integracion_fisica/back_end/libs/saed90nm_fr/DETECTOR.mw

#Abrir la base de datos MIlkway
open_mw_lib ./libs/saed90nm_fr/DETECTOR.mw

#Importa el Gate-Level-Netlist obtenido en la Síntesis RTL
import_designs -format verilog {detector_syn.v} -top detector_secuencia

#Resolver múltiples instancias
uniquify_fp_mw_cel
link

#Leer las especificaciones de temporizado. Archivo sdc "synopsys design constraints"
read_sdc {detector_syn.sdc}

##################################################Floorplanning############################################################

#Iniciar la etapa de descripción física (floorplan)
initialize_floorplan -core_utilization 0.6 -start_first_row -left_io2core 5.0 -bottom_io2core 5.0 -right_io2core 5.0 -top_io2core 5.0 -pin_snap

#Conectar los pines de alimentación del chip
derive_pg_connection -power_net "VDD" -ground_net "VSS"
derive_pg_connection -power_net "VDD" -ground_net "VSS" -tie

#Crear los anillos de alimentación para VSS y VDD
create_rectangular_rings -nets {VSS} -left_offset 0.5 -left_segment_layer M6 -left_segment_width 1.0 -extend_ll -extend_lh -right_offset 0.5 -right_segment_layer M6 -right_segment_width 1.0 -extend_rl -extend_rh -bottom_offset 0.5 -bottom_segment_layer M7 -bottom_segment_width 1.0 -extend_bl -extend_bh -top_offset 0.5 -top_segment_layer M7 -top_segment_width 1.0 -extend_tl -extend_th

create_rectangular_rings -nets {VDD} -left_offset 1.8 -left_segment_layer M6 -left_segment_width 1.0 -extend_ll -extend_lh -right_offset 1.8 -right_segment_layer M6 -right_segment_width 1.0 -extend_rl -extend_rh -bottom_offset 1.8 -bottom_segment_layer M7 -bottom_segment_width 1.0 -extend_bl -extend_bh -top_offset 1.8 -top_segment_layer M7 -top_segment_width 1.0 -extend_tl -extend_th

create_power_strap -nets { VDD } -layer M6 -direction vertical -width 3
create_power_strap -nets { VSS } -layer M6 -direction vertical -width 3

##################################################Placement##############################################################
#Reducir la cantidad de buffers e inversores, sin afectar la calidad del resultado
set_buffer_opt_strategy -effort low

#Iniciar la etapa de colocación física (placement)
create_fp_placement

#Guardar el diseño de la colocación física
save_mw_cel -as detector_placement

##################################################Routing################################################################
#Ininicializa routing
route_zrt_auto -max_detail_route_iterations 10

#Verificar el Routing
verify_zrt_route

#Extraer el netlist
write_verilog ./db/detector_phy.v

#########################################################################################################################

#Extraer las capcitancias parásitas
write_parasitics -output {./db/detector_phy.spef}

#Escribir el archivo con los datos de retado del layout. Standard Delay Format (SDF)
write_sdf ./db/detector_phy.sdf

#Extraer el archivo con las especificaciones de temporizado. sdc (Synopsys Design Constraints)
write_sdc ./db/detector_phy.sdc

#Escribir el archivo .ddc y el .def
write -format ddc -output {./db/detector_phy.ddc}
write_def -output "/home/jvalverde/detector/integracion_fisica/back_end/db/detector_phy.def"

#Guardar el diseño después del enrutado físico:
save_mw_cel -as detector_routing

#Crear el GSDII
write_stream -format gds -lib_name /home/jvalverde/detector/integracion_fisica/back_end/libs/saed90nm_fr/DETECTOR.mw -cells {detector_routing } ./db/GDSII_detector

#Reportes Routing
report_qor > reports/detector_phy_qor.txt
report_power > reports/detector_phy_power.txt



