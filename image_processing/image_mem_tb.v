`timescale 1ps/100fs
module image_mem_tb ();

	reg	[14:0]  address;
	reg	  clock;
	wire	[11:0]  q;
	
	always #10 begin clock <= ~clock; address = $random; end
	
	initial begin
		clock = 0;
	end
	
	endmodule