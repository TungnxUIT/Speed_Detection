module uart_rx#(
	parameter divisor = 1406
)
(
	input			i_clock,
	input 		i_rx_serial,
	//input			i_rst_n
	output[7:0] o_rx_data,
	output		o_rx_done
);
parameter s_idle 				= 3'd0;
parameter s_rx_start_bit 	= 3'd1;
parameter s_rx_data_bit 	= 3'd2;
parameter s_rx_stop_bit		= 3'd3;
parameter s_cleanup			= 3'd4;

//Use double register to solve metasability
reg r_rx_1 		= 1'b1;
reg r_rx_received 	= 1'b1;

reg[15:0] 	r_clock_count = 0;
reg[7:0]		r_rx_data  = 0;
reg			r_rx_done = 0;
reg[2:0]		state = 0;
reg[2:0]		r_bit_index = 0;


always@(posedge i_clock) begin
	r_rx_1 		<= i_rx_serial;
	r_rx_received 	<= r_rx_1;
end

always@(posedge i_clock) begin
	case(state) 
		s_idle: begin
			r_clock_count 	<= 0;
			r_rx_done 		<= 0;
			r_bit_index 	<= 0;
			if(r_rx_received == 1'b0) 
				state <= s_rx_start_bit;
			else
				state <= s_idle;
		end
		s_rx_start_bit: begin
			//check the middle of start bit to make sure it's still low
			if(r_clock_count == (divisor -1) / 2) begin
				if(r_rx_received == 1'b0) begin
					//Move to state bit data when come to the middle of start bit
					state <= s_rx_data_bit;
					r_clock_count <= 0;
				end
				else state <= s_idle;
			end
			else begin
				r_clock_count <= r_clock_count + 1;
				state <= s_rx_start_bit;
			end
		end
		s_rx_data_bit: begin
		//Wait one cycle to meet the right bit data as we first move to this state at the middle of start bit
		//We will always collect bit data at the middle of them
			if(r_clock_count < divisor - 1) begin
				state <= s_rx_data_bit;
				r_clock_count <= r_clock_count + 1;
			end
			//Receive the data bit
			else begin
				r_clock_count <= 0;
				r_rx_data[r_bit_index] <= r_rx_received;
				
				//Check if we have collected all 9 bit data
				if(r_bit_index < 7) begin
					r_bit_index <= r_bit_index + 1;
					state <= s_rx_data_bit;
				end
				else begin
					r_bit_index <= 0;
					state <= s_rx_stop_bit;
				end
			end
		end
		s_rx_stop_bit: begin		//Stop bit = 1
			if(r_clock_count < divisor - 1) begin
				r_clock_count <= r_clock_count + 1;
				state <= s_rx_stop_bit;
			end
			else begin
				r_rx_done <= 1;
				r_clock_count <= 0;
				state <= s_cleanup;
			end
		end
		s_cleanup: begin
			state <= s_idle;
			r_rx_done <= 0;
		end
		default: state <= s_idle;
	endcase
end

assign o_rx_data = r_rx_data;
assign o_rx_done = r_rx_done;


endmodule