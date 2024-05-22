`timescale 1ns/1ps

module speed#(
	parameter width = 8,
	parameter depth = 6
	//parameter 
)
(
	input 									clk,
	input 									rst_n,
	input 									start,
	input[width - 1:0] 					i_car,	
	input[width - 1:0] 					i_x,
	input[width - 1:0] 					i_y,
	output reg[width - 1:0] 			o_x,
	output reg[width - 1:0] 			o_y,
	output reg[depth	  :0] 			o_idx,
	output reg[depth    :0] 			o_idy,
	output reg[width - 1:0]				o_speed,
	output reg[depth - 1:0]				o_id0, o_id1,
	output reg								o_wen_speed,
	output reg								o_wen_location,
	output reg								o_change_id0, o_change_id1					
	//output[width - 1:0] x, y
);

localparam scale0 = 32'd3;
localparam scale1 = 32'd4;

localparam idle_state = 3'd0;
localparam id_state = 	3'd1;
localparam x_state = 	3'd2;
localparam y_state = 	3'd3;
localparam math_state = 3'd4;

localparam wait_id	= 3'd5;
localparam wait_x		= 3'd6;
localparam wait_y		= 3'd7;



reg[width - 1:0]  x_reg, y_reg;
reg[31:0] id_reg;
reg[depth-1:0]	 id_reg0, id_reg1;
reg[2:0] state, next_state;
reg speed_allow;
reg[31:0] count0 = 0;
reg[31:0] count1 = 0;

	


always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		state <= idle_state;
	else begin 
		state <= next_state;
	end
	end

always@(*) begin
	case(state)
		idle_state: next_state <= 	(start) ? id_state : idle_state;
		id_state: next_state <=  (start) ?	 x_state : wait_id;
		x_state: next_state <=  (start)	? y_state : wait_x;
		y_state: next_state <=  (start)	? math_state : wait_y;
		math_state: next_state <= (start) ? id_state : idle_state;
		
		wait_id: next_state <=  (start) ?	x_state : wait_id;
		wait_x: next_state <=  (start)	? y_state : wait_x;
		wait_y: next_state <=  (start)	? math_state : wait_y;
		default: next_state <=	idle_state;
	endcase
end

initial begin
	o_change_id0 <= 0;
	o_change_id1 <= 0;
	id_reg0 <= 0;
	id_reg1 <= 0;
end

always@(posedge clk) begin
	case(next_state) 
		idle_state: begin
			//id_reg <= 0;
			//x_reg <= 0;
			//y_reg <= 0;
			o_x <= 0;
			o_y <= 0;
			o_idx <= 0;
			o_idy <= 0;
			o_speed <= 0;
			o_id0 <= 0;
			o_id1 <= 0;
			o_change_id0 <= 0;
			o_change_id1 <= 0;
			//o_wen_location <= 0;
			//o_wen_speed <= 0;
			speed_allow <= 0;
			//n <= 0;
			//nn <= 0;
		end
		id_state: begin
			// do something
		end
		x_state: begin
			o_id0 <= id_reg[depth-1:0];
			o_idx <= id_reg[depth-1:0];
			o_idy <= id_reg[depth-1:0] + (2 ** (depth - 1));
			if (id_reg[depth-1:0] != id_reg0) o_id1 <= id_reg[depth-1:0];
			//o_wen_location <= 0;	
		end
		y_state: begin
			// do something
		end
		math_state: begin
			o_x <= x_reg;
			o_y <= y_reg;
			
			if(i_x == 0 && i_y == 0) begin	//New car
				speed_allow <= 0;
			end
		
			else begin		//Old car, caculate velocity
			
				if(id_reg0 != o_id0) begin
					count0 <= count0 + 1;
					if (count0 == scale0) begin
						o_change_id0 <= 1;
						id_reg0 <= o_id0;
						count0 <= 0;
					end
					else begin 
						id_reg0 <= id_reg0;
						o_change_id0 <= 0;
					end
				end
				else count0 <= 0;
				
				if(id_reg1 != o_id1) begin
					count1 <= count1 + 1;
					if (count1 == scale1) begin
						o_change_id1 <= 1;
						id_reg1 <= o_id1;
						count1 <= 0;
					end
					else begin 
						id_reg1 <= id_reg1;
						o_change_id1 <= 0;
					end
				end
				else count1 <= 0;
				
				if(y_reg < i_y) begin
					if(i_y < 150) begin
						o_speed <= ((i_y - y_reg) << 3) + ((i_y - y_reg) << 2) - ((i_y - y_reg) >> 1);
					end
					else if (i_y < 200) begin
						o_speed <= ((i_y - y_reg) << 2) + ((i_y - y_reg) >> 2) + ((i_y - y_reg) >> 1) ;
					end
					else if(i_y < 250) begin
						o_speed <= ((i_y - y_reg) << 1) + ((i_y - y_reg)) + ((i_y - y_reg) >> 2);
					end
					else begin
						o_speed <= ((i_y - y_reg) << 1) + ((i_y - y_reg) >> 2);
					end
					speed_allow <= 1;
				end
				else speed_allow <= 0;
			end
		end
		wait_x: begin
			o_id0 <= o_id0;
			o_idx <= o_idx;
			o_idy <= o_idy;
		end
		wait_y: begin
			
		end
		wait_id: begin
		
		end
		default: begin
			o_x <= 0;
			o_y <= 0;
			o_idx <= 0;
			o_idy <= 0;
			o_speed <= 0;
			o_id0 <= 0;
			o_id1 <= 0;
			speed_allow <= 0;
			o_change_id0 <= 0;
			o_change_id1 <= 0;
		end
	endcase
end

always@(negedge clk) begin
	case(state) 
		idle_state: begin
			// do something
			id_reg <= 0;
			x_reg <= 0;
			y_reg <= 0;
			o_wen_location <= 0;
			o_wen_speed <= 0;
		end
		id_state: begin
			id_reg[width-1:0] <= i_car;
			o_wen_speed <= 0;
			o_wen_location <= 0;
		end
		x_state: begin
			x_reg <= i_car;
		end
		y_state: begin
			y_reg <= i_car;
		end
		math_state: begin
			o_wen_speed <= speed_allow;
			o_wen_location <= 1;
		end
		wait_id: begin
			id_reg <= id_reg;
			o_wen_speed <= o_wen_speed;
			o_wen_location <= o_wen_location;
		end
		wait_x: begin
			x_reg <= x_reg;
		end
		wait_y: begin
			y_reg <= y_reg;
		end
	endcase
end

assign s = state;

endmodule




