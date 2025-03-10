onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -L gtwizard_ultrascale_v1_7_12 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.gtwizard_ultrascale_0 xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {gtwizard_ultrascale_0.udo}

run -all

quit -force
