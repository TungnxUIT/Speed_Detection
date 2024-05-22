module uart_rx_testing(
	input			i_clock,
	input 		i_rx_serial,
	//input			i_rst_n
	output[7:0] o_rx_data,
	output		o_rx_done,
	output reg	o_led
);

parameter divisor = 2604;
localparam[7:0] test_value = 8'd125;

initial begin
	o_led = 1;
end

uart_rx#(.divisor(divisor)) UART_RX(
	.i_clock(i_clock),
	.i_rx_serial(i_rx_serial),
	.o_rx_data(o_rx_data),
	.o_rx_done(o_rx_done)
);

always@(posedge i_clock) begin
	if(o_rx_data == test_value)
		o_led <= 0;
	else
		o_led <= 1;
end

endmodule