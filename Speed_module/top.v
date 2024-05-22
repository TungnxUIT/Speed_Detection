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

wire[width - 1:0] x_data, y_data, x_mem, y_mem, speed_data;
wire[depth - 1:0] id_data0, id_data1;
wire[depth:		0] x_addr, y_addr;
wire					wen_location, wen_speed;
wire					change_id0, change_id1;

uart_rx#(.divisor(divisor)) uart(
	.i_clock(clk),
	.i_rx_serial(i_rx_serial),
	.o_rx_data(car_data),
	.o_rx_done(rx_done)
);

speed#(.width(width), .depth(depth)) inst_speed
(
	.clk(clk),
	.rst_n(rst_n),
	.start(rx_done),
	.i_car(car_data),	
	.i_x(x_data),
	.i_y(y_data),
	.o_x(x_mem),
	.o_y(y_mem),
	.o_idx(x_addr),
	.o_idy(y_addr),
	.o_speed(speed_data),
	.o_id0(id_data0),
	.o_id1(id_data1),
	.o_wen_speed(wen_speed),
	.o_wen_location(wen_location),
	.o_change_id0(change_id0),
	.o_change_id1(change_id1)
);

location_mem#(.width(width), .depth(depth + 1)) inst_location_mem(
	.clk(clk),
	.rst_n(rst_n),
	.i_a(x_mem),
	.i_b(y_mem),
	.i_addr_a(x_addr),
	.i_addr_b(y_addr),
	.wen(wen_location),
	.o_a(x_data),
	.o_b(y_data)
);

speed_mem#(.width(width), .depth(depth)) inst_speed_mem(
	.clk(clk),
	.rst_n(rst_n),
	.i_speed(speed_data),
	.i_addr_speed(id_data0),
	.i_rdaddr_speed0(id_data0),
	.i_rdaddr_speed1(id_data1),
	.wen(wen_speed),
	.o_speed0(o_speed0),
	.o_speed1(o_speed1),
	.o_id0(rdaddr_speed0),
	.o_id1(rdaddr_speed1),
	.i_change_id0(change_id0),
	.i_change_id1(change_id1),
);

/*speed_module#(.width(width), .depth(depth)) speed(
	.clk(clk),
	.rst_n(rst_n),
	.start(rx_done),
	//.i_rdaddr_speed(rdaddr_speed),
	.i_car(car_data),
	.o_speed0(o_speed0),
	.o_speed1(o_speed1),
	.o_id0(rdaddr_speed0),
	.o_id1(rdaddr_speed1)
);*/

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