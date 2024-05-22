module img_processing(
	input clk,
	input reset,
	output reg[7:0] red, green, blue,
	output reg[7:0] data_grayscale,
	output reg write_en,
	output done
);

//image size 160x148
parameter img_width = 160;
parameter img_height = 148;
parameter size = img_width * img_height;
parameter data_size = 12 - 1;
parameter address_size = 15 - 1;

reg[address_size : 0] data_address;
wire[data_size : 0] raw_data;

image_mem inst_imageMem(
	.address(data_address),
	.clock(clk),
	.q(raw_data)
);


always@(posedge clk or posedge reset) begin
	if(reset) begin
		red <= 0;
		green <= 0;
		blue <= 0;
		data_address <= 0;
		write_en <= 0;
		data_address <= 0;
	end
	else begin
		red <= {raw_data[11:8], raw_data[11:8]};
		green <= {raw_data[7:4], raw_data[7:4]};
		blue <= {raw_data[3:0], raw_data[3:0]};
		data_grayscale <= (red + green + blue) / 3;
		data_address <= data_address + 1;
		write_en <= 1;
	end
end


assign done = (data_address == size) ? 1 : 0;
	
endmodule