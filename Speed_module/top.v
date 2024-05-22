module top#(
	parameter width = 8,
	parameter depth = 8,
	parameter divisor = 2604	//50Mhz / 19200
)(
	input 					clk,
	input 					rst_n,
	//input 					start,
	input						i_rx_serial,
	//input[depth - 1:0]	i_rdaddr_speed,
	//LCD
	output					lcd_on,
	output					lcd_rs,
	output 					lcd_rw,
	output					lcd_en,
	output[width - 1:0]	lcd_data
	
);

wire[width - 1:0]		car_data;
wire 						rx_done;
wire[width - 1:0]		o_speed0, o_speed1;
wire[depth - 1:0] 	rdaddr_speed0, rdaddr_speed1;

uart_rx#(.divisor(divisor)) uart(
	.i_clock(clk),
	.i_rx_serial(i_rx_serial),
	.o_rx_data(car_data),
	.o_rx_done(rx_done)
);

speed_module#(.width(width), .depth(depth)) speed(
	.clk(clk),
	.rst_n(rst_n),
	.start(rx_done),
	//.i_rdaddr_speed(rdaddr_speed),
	.i_car(car_data),
	.o_speed0(o_speed0),
	.o_speed1(o_speed1),
	.o_id0(rdaddr_speed0),
	.o_id1(rdaddr_speed1)
);

lcd lcd(
	.clk(clk),
	.rst_n(rst_n)	,
	.data1(rdaddr_speed0),
	.data2(o_speed0),
	.data3(rdaddr_speed1),
	.data4(o_speed1),
	
	.lcd_on(lcd_on),
	.lcd_rs(lcd_rs)		,
	.lcd_rw(lcd_rw)		,
	.lcd_en(lcd_en)		,
	.lcd_data (lcd_data)
);

endmodule