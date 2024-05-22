`timescale 1ps / 1ps

module img_processing_tb();
	reg clk;
	reg reset;
	wire[7:0] red, green, blue;
	wire done;
	wire write_en;
	wire[7:0] data_grayscale;
	
 img_processing dut (
        .clk(clk),
        .reset(reset),
        .red(red),
        .green(green),
        .blue(blue),
        .done(done),
		  .write_en(write_en),
		  .data_grayscale(data_grayscale)
    );

	always #5 clk <= ~clk;
	reg header_done;
	integer BMP_header [0 : 54 - 1];
	integer i;
	integer fd;
	
	initial begin
		clk = 0;
		reset = 1;
		header_done = 0;
	BMP_header[ 0] = 66;BMP_header[28] =24;
	BMP_header[ 1] = 77;BMP_header[29] = 0;
	BMP_header[ 2] = 54;BMP_header[30] = 0;
	BMP_header[ 3] =  0;BMP_header[31] = 0;
	BMP_header[ 4] = 18;BMP_header[32] = 0;
	BMP_header[ 5] =  0;BMP_header[33] = 0;
	BMP_header[ 6] =  0;BMP_header[34] = 0;
	BMP_header[ 7] =  0;BMP_header[35] = 0;
	BMP_header[ 8] =  0;BMP_header[36] = 0;
	BMP_header[ 9] =  0;BMP_header[37] = 0;
	BMP_header[10] = 54;BMP_header[38] = 0;
	BMP_header[11] =  0;BMP_header[39] = 0;
	BMP_header[12] =  0;BMP_header[40] = 0;
	BMP_header[13] =  0;BMP_header[41] = 0;
	BMP_header[14] = 40;BMP_header[42] = 0;
	BMP_header[15] =  0;BMP_header[43] = 0;
	BMP_header[16] =  0;BMP_header[44] = 0;
	BMP_header[17] =  0;BMP_header[45] = 0;
	BMP_header[18] =  160;BMP_header[46] = 0;
	BMP_header[19] =  0;BMP_header[47] = 0;
	BMP_header[20] =  0;BMP_header[48] = 0;
	BMP_header[21] =  0;BMP_header[49] = 0;
	BMP_header[22] =  148;BMP_header[50] = 0;
	BMP_header[23] =  0;BMP_header[51] = 0;	
	BMP_header[24] =  0;BMP_header[52] = 0;
	BMP_header[25] =  0;BMP_header[53] = 0;
	BMP_header[26] =  1;
	BMP_header[27] =  0;
	#10
	 header_done = 1;
	 
	end
	
	always@(posedge clk) begin
		if(header_done) begin
			fd = $fopen("output.bmp", "wb+");
			for(i=0; i< 54; i=i+1) begin
            $fwrite(fd, "%c", BMP_header[i][7:0]); // write the header
			end
			reset = 0;
			header_done = 0;
		end	
		else begin
		if(write_en) begin
			$fwrite(fd, "%c", blue);
			$fwrite(fd, "%c", green);
			$fwrite(fd, "%c", red);	
			/*$fwrite(fd, "%c", data_grayscale);
			$fwrite(fd, "%c", data_grayscale);
			$fwrite(fd, "%c", data_grayscale);*/
		end
		end
		if(done) $stop;
	end
	
	 
endmodule