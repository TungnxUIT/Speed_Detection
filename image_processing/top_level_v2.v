module top_level_v2(
	input clk50,
	input resetPll_n,
	input switch,
	output vga_vsync, vga_hsync,
	output[9:0] vga_r, vga_g, vga_b,
	output sync_n, blank_n,
	output reg vga_clk = 0,
	output led
	//output[11:0] data_out
);

//image size 160x148
parameter image_width = 160;
parameter image_height = 148;
parameter data_size = 12 - 1;
parameter address_size = 15 - 1;

/*pll inst_myPll(
	.clk_in_clk(clk50),    //  clk_in.clkS
	.reset_n_reset(resetPll_n), // reset_n.reset
	.clk_out_clk(vga_clk)    // clk_out.clk
);*/


wire[address_size : 0] data_address;
wire mem_clk;
wire[data_size : 0] raw_data;

always @(posedge clk50) begin
	if(resetPll_n == 0) begin
		vga_clk <= 0;
	end
	else 
	vga_clk <= ~vga_clk;
end


image_mem inst_imageMem(
	.address(data_address),
	.clock(vga_clk),
	.q(raw_data)
);

wire[data_size: 0] processed_data;

/*processing inst_Process(
    .data_in(raw_data),
    .switch(switch),
    .data_out(processed_data)
);*/

vga_controller inst_vgaController(
	.clk_in(vga_clk),
	.reset(resetPll_n),
	.raw_data(raw_data),
	//.clk_out(vga_clk),
	.hsync(vga_hsync),
	.vsync(vga_vsync),
	.r(vga_r),
	.g(vga_g),
	.b(vga_b),
	.sync_n(sync_n),
	.blank_n(blank_n),
	.read_address(data_address)
);

//assign data_out = raw_data;
assign mem_clk = vga_clk;
assign led = switch;

endmodule