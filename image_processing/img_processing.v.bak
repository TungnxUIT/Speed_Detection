module img_processing(
	input clk,
	input reset,
	output done
);

//image size 160x148
parameter image_width = 160;
parameter image_height = 148;
parameter size = img_width * img_height;
parameter data_size = 12 - 1;
parameter address_size = 15 - 1;

wire[address_size : 0] data_address;
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
	end
	else begin
		red <= {raw_data[11:8], raw_data[11:8]};
		green <= {raw_data[7:4], raw_data[7:4]]};
		blue <= [raw_data[3:0], raw_data[3:0]};
	end
end

always@(negedge clk) begin
	data_address <= data_address + 1;
end

assign done = (data_address == size) ? 1 : 0;
	
end