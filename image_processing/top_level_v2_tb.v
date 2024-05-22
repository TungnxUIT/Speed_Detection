`timescale 1ps/1ps

module top_level_v2_tb();
	reg clk50;
	reg resetPll_n;
	reg switch;
	wire vga_vsync, vga_hsync;
	wire[9:0] vga_r, vga_g, vga_b;
	wire sync_n, blank_n;
	wire vga_clk;
	wire led;
	//wire[11:0] data_out;
	
	top_level_v2 DUT(
		.clk50(clk50),
		.resetPll_n(resetPll_n),
		.switch(switch),
		.vga_vsync(vga_vsync),
		.vga_hsync(vga_hsync),
		.vga_r(vga_r),
		.vga_g(vga_g),
		.vga_b(vga_b),
		.sync_n(sync_n),
		.blank_n(blank_n),
		.vga_clk(vga_clk),
		.led(led),
		//.data_out(data_out)
	);
	
	always #5 begin clk50 <= ~clk50; end

	
	initial begin
		clk50 = 0;
		resetPll_n = 1;
		#5 resetPll_n = 0;
	end
endmodule