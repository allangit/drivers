####################################################################################################################################
#Institución:                          Instituto Tecnológico de Costa Rica

#Realizado por:		   Jairo Mauricio Valverde Cruz           jmvc04@gmail.com

#Proyecto:   Detector de secuencia: 1101. Proyecto creado con fines didácticos.

#Herramienta:        Design Compiler  Version E-2010.12-SP1 for linux -- Jan 17, 2011

#Fecha de creación:  27 Agosto 2011 

#Updates: 12 Agosto 2012 (ACR, Roberto Cerdas)

#Refrencias (detalladas en el Manual - Wiki):
# 1. A. Chacón, 2009.  
# 2. Manuales de Design Compiler.
# 3. Bindu, 2009. 
####################################################################################################################################

# Eliminar diseños previos
remove_design -designs

# Primero se analiza el módulo principal
analyze -library WORK -format verilog {detector_secuencia.v}

#Luego se analiza los otros módulos
analyze -format verilog {divisor_frecuencia.v \
secuenciaFSM.v}

#Elaboramos el módulo principal
elaborate detector_secuencia -architecture verilog -library WORK

#Enlazar los demás módulos al módulo principal
link

#Escribir el archivo *.ddc (base de datos sin sintetizar)
write -hierarchy -format ddc -output \
./db/detector_syn_unmapped.ddc

#Aplicar especificaciones de diseño (constraints)
source detector_syn_constraints.tcl
propagate_constraints

#Revisar el diseño
check_design

#Compilar el diseño
compile_ultra

#Escribir la lista de nodos a nivel de compuertas (Gate Level Netlist) que se utiliza para:
#- Verificar el funcionamiento lógico del sistema digital después de la Síntesis RTL.
#- Como una de las entradas para el sintetizador físico (IC Compiler).
set verilogout_no_tri true
change_names -hierarchy -rules verilog
write -hierarchy -format verilog -output \
./db/detector_syn.v

#Generar los reportes

report_power -analysis_effort high > reports/detector_syn_power.txt
report_area > reports/detector_syn_area.txt
report_cell > reports/detector_syn_cell.txt
report_qor > reports/detector_syn_qor.txt
report_timing > reports/detector_syn_timing.txt
report_port > reports/detector_syn_port.txt

#Escribir el archivo *.ddc (base de datos sintetizada)
write -hierarchy -format ddc -output \
./db/detector_syn_mapped.ddc

#Escribir el archivo *.sdc (Synopsys Design Constraints), utilizado como una de las entradas 
#para el sintetizador físico (IC Compiler)
write_sdc ./db/detector_syn.sdc

#Revisar la configuración de temporizado
check_timing
