#Compilamos todo dentro de la libreria de 
vlib test_lib
vmap test_lib ./test_lib

vcom -2008 -check_synthesis -reportprogress 300 -mixedsvvh -work test_lib ./mult_by_constant.vhd
vcom -2008 -reportprogress 300 -mixedsvvh -work test_lib ./file_tb.vhd

vsim -L test_lib -t 1ps -novopt test_lib.file_tb

#Despues viene el wave y al final el run.
do wave.do
run 50 us