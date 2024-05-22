transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Study/UIT/DA/DA1/verilog/uart_interface {D:/Study/UIT/DA/DA1/verilog/uart_interface/uart_rx.v}

vlog -vlog01compat -work work +incdir+D:/Study/UIT/DA/DA1/verilog/uart_interface {D:/Study/UIT/DA/DA1/verilog/uart_interface/uart_rx_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver -L rtl_work -L work -voptargs="+acc"  uart_rx_tb

add wave *
view structure
view signals
run -all
