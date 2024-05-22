module speed_module#(
	parameter width = 8,
	parameter depth = 6
)
(
	input 					clk,
	input 					rst_n,
	input 					start,
	//input[depth - 1:0]	i_rdaddr_speed,
	input[width - 1:0]	i_car,
	output[width - 1:0] 	o_speed0, o_speed1,
	output[depth - 1:0] 	o_id0, o_id1
	//output[width - 1:0]x, y
);

parameter divisor = 1406;
//parameter location_depth = depth + 1;


wire[width - 1:	      0] x_data, y_data, x_mem, y_mem, speed_data;
wire[depth - 1:0] id_data0, id_data1;
wire[depth:		0] x_addr, y_addr;
wire								wen_location, wen_speed;
wire[width - 1:0]		car_data;
wire 						rx_done;
wire						change_id0, change_id1;

/*uart_rx#(.divisor(divisor)) inst_uart(
	.i_clock(clk),
	.i_rx_serial(i_rx_serial),
	.o_rx_data(car_data),
	.o_rx_done(rx_done)
);*/

speed#(.width(width), .depth(depth)) inst_speed
(
	.clk(clk),
	.rst_n(rst_n),
	.start(start),
	.i_car(i_car),	
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
	.o_id0(o_id0),
	.o_id1(o_id1),
	.i_change_id0(change_id0),
	.i_change_id1(change_id1),
);


endmodule