module top_level(
	input clk27,
	input resetPll_n,
	output vga_vsync, vga_hsync,
	output[3:0] vga_r, vga_g, vga_b,
	output sync_n, blank_n,
	output vga_clk,
	output led
);
//image size 160x140
parameter image_width = 160;
parameter image_height = 140;
parameter data_size = 12 - 1;
parameter address_size = 15 - 1;

pll inst_myPll(
	.clk_in_clk(clk27),    //  clk_in.clk
	.reset_n_reset(resetPll_n), // reset_n.reset
	.clk_out_clk(vga_clk)    // clk_out.clk
);

wire[address_size : 0] data_address;
wire mem_clk;
wire[data_size : 0] raw_data;

image_mem inst_imageMem(
	.address(data_address),
	.clock(mem_clk),
	.q(raw_data)
);

vga_controller inst_vgaController(
	.clk_in(mem_clk),
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

assign mem_clk = vga_clk;
assign led = resetPll_n;

endmodule