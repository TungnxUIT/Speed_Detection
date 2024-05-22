onerror {quit -f}
vlib work
vlog -work work image_processing.vo
vlog -work work image_processing.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.top_level_v2_vlg_vec_tst
vcd file -direction image_processing.msim.vcd
vcd add -internal top_level_v2_vlg_vec_tst/*
vcd add -internal top_level_v2_vlg_vec_tst/i1/*
add wave /*
run -all
