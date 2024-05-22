module vga_controller(
	input clk_in,
	input reset,
	input[11:0] raw_data,
	//output clk_out,
	output reg hsync, vsync,
	output reg[9:0] r, g, b,
	output sync_n, blank_n,
	output reg[14:0] read_address
);
parameter[10:0] HM = 800; //horizontal max
parameter[10:0] HV = 640; //horizontal real
parameter[10:0] HF = 16;	//horizontal front porch
parameter[10:0] HS = 96;	//horizontal synch pulse
parameter[10:0] HB = 48;	//horizontal back porch
parameter[10:0] VM = 525; //Vertical max
parameter[10:0] VV = 480; //vertical real
parameter[10:0] VF = 10;
parameter[10:0] VS = 2;
parameter[10:0] VB = 33;
parameter[10:0] img_width = 160;
parameter[10:0] img_height = 148;
parameter[10:0] hcentre = HF + HS + HB + (HV / 2);
parameter[10:0] vcentre = VF + VS + VB + (VV / 2);
parameter[10:0] h_start = hcentre - (img_width / 2);
parameter[10:0] h_stop = h_start + img_width;
parameter[10:0] v_start = 100;
parameter[10:0] v_stop = v_start + img_height;

reg[10:0] hpos = 0;
reg[10:0] vpos = 0;
reg[10:0] pixel_col = 0;
reg[10:0] pixel_row = 0;
reg[10:0] pixel_number = 0;
reg video;
always@(posedge clk_in) begin
	if(!reset) begin
		hpos <= 0;
		vpos <= 0;
		video <= 0;
		pixel_col <= 0;
		pixel_number <= 0;
		pixel_row <= 0;
		video <= 0;
		read_address <= 0;
	end
	else begin
		if(hpos >= HM) begin
			hpos <= 0;
			if(vpos >= VM) begin
				vpos <= 0;
			end
			else vpos <= vpos + 1;
		end
		else hpos <= hpos + 1;
		
		if((hpos >= HV + HF) && (hpos <= HV + HF + HS - 1)) hsync <= 0;
			else hsync <= 1;
		if((vpos >= VV + VF) && (vpos <= VV + VF + VS - 1)) vsync <= 0;
			else vsync <= 1;
		
		if((hpos >= h_start) && (hpos <= h_stop)) begin
			if((vpos >= v_start) && (vpos <= v_stop)) begin
				video <= 1;
				pixel_col <= hpos - h_start;
				pixel_row <= vpos - v_start;
				pixel_number <= pixel_col + pixel_row * img_width;
				read_address <= pixel_number;
				r <= {2'b11, raw_data[11:8], raw_data[11:8]};
			g <= {2'b11, raw_data[7:4], raw_data[7:4]};
			b <= {2'b11, raw_data[3:0], raw_data[3:0]};
			end
			else video <= 0;
		end
		else video <= 0;
		if(!video) begin
		r <= 10'b1111111111;
			g <= 0;
			b <= 0;
		end
		/*if((hpos < img_width) && (vpos < img_height)) video <= 1;
		else video <= 0;
		if(video) begin
			if(read_address < img_width * img_height) read_address <= read_address + 1;
			else read_address <= 0;
			r <= {2'b11, raw_data[11:8], raw_data[11:8]};
			g <= {2'b11, raw_data[7:4], raw_data[7:4]};
			b <= {2'b11, raw_data[3:0], raw_data[3:0]};
		end
		else begin
		r <= 10'b1111111111;
			g <= 0;
			b <= 0;
		end
		if(vsync) read_address <= 0;*/
	end
end

/*always@* begin
	case(video) 
		0: begin
			r <= 10'b1111111111;
			g <= 0;
			b <= 0;
		end
		1: begin
			/*r <= {2'b11, raw_data[11:8], raw_data[11:8]};
			g <= {2'b11, raw_data[7:4], raw_data[7:4]};
			b <= {2'b11, raw_data[3:0], raw_data[3:0]};*/
			/*r <= {2'b11, 8'b0};
			g <= {2'b11, 8'b0};
			b <= {2'b11, 8'b0};
		end
	endcase
end*/


assign blank_n = video;
assign sync_n = 1;
//assign clk_out = clk_in;

endmodule