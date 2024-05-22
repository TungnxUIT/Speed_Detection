module uart#(
	parameter divisor = 1000
)
(
	input 		i_clock,
	input 		i_rx_serial,
	input			i_tx_start,
	input[7:0]	i_tx_data,	
	output		o_tx_serial,
	output		o_tx_done,
	output[8:0]	o_rx_data,
	output		o_rx_done
);

uart_tx UART_TX(
	.i_clock(i_clock),
	.i_tx_start(i_tx_start),
	.i_tx_data(i_tx_data),
	.o_tx_done(o_tx_done),
	.o_tx_serial(o_tx_serial),
	.o_tx_active(o_tx_active)
);

uart_rx UART_RX(
	.i_clock(i_clock),
	.i_rx_received(i_rx_serial),
	.o_rx_data(o_rx_data),
	.o_rx_done(o_rx_done)
);

endmodule