module uart_tx#(
	parameter divisor = 1406,
	parameter depth = 12
)
(
	input 		i_clock,
	input 		i_tx_start,
	input[7:0]	i_tx_data,
	output		o_tx_done,
	output reg	o_tx_serial,
	output		o_tx_active
);

parameter s_idle 				= 3'd0;
parameter s_tx_start_bit 	= 3'd1;
parameter s_tx_data_bit 	= 3'd2;
parameter s_tx_stop_bit		= 3'd3;
parameter s_cleanup			= 3'd4;

reg[15:0] 	clock_count = 0;
reg[2:0]		state = 0;
reg[2:0]		r_bit_index = 0;
reg			r_tx_done = 0;
reg			r_tx_active = 0;
reg[7:0]		r_tx_data = 0;
reg[7:0]	d = 0;


always@(posedge i_clock) begin
	case(state)
		s_idle: begin
			clock_count <= 0;
			r_bit_index <= 0;
			r_tx_done	<= 0;
			o_tx_serial	<= 1;
			r_tx_active <= 0;
			if(i_tx_start == 1'b1) begin
				state <= s_tx_start_bit;
				r_tx_data <= i_tx_data;
				r_tx_active <= 1;
			end
			else begin 
				state <= s_idle;
				d <= 0;
			end
		end
		s_tx_start_bit: begin
			if(d == depth) begin
				if(i_tx_start == 1'b0) 
					d <= 0;
				state <= s_idle;
			end
			else begin
				o_tx_serial <= 0;		//Start bit = 0
				if(clock_count < divisor - 1) begin		//Wait one clock cycle (divisor - 1 cycle) before go to state data bit
					clock_count <= clock_count + 1;
					state <= s_tx_start_bit;
				end
				else begin
					clock_count <= 0;
					state <= s_tx_data_bit;
					d <= d + 1;
				end
			end
		end
		s_tx_data_bit: begin
			o_tx_serial <= r_tx_data[r_bit_index];
			if(clock_count < divisor - 1) begin
				clock_count <= clock_count + 1;
				state <= s_tx_data_bit;
			end
			else begin
				clock_count <= 0;
				if(r_bit_index < 7) begin
					state <= s_tx_data_bit;
					r_bit_index <= r_bit_index + 1;
				end
				else begin
					state <= s_tx_stop_bit;
					r_bit_index <= 0;
				end
			end
		end
		s_tx_stop_bit: begin		
			o_tx_serial <= 1'b1;			// Stop bit = 1
			if(clock_count < divisor - 1) begin
				clock_count <= clock_count + 1;
				state <= s_tx_stop_bit;
			end
			else begin
				clock_count <= 0;
				state <= s_cleanup;
				r_tx_done <= 1;
				r_tx_active <= 0;
			end
		end
		s_cleanup: begin
			state <= s_idle;
			r_tx_done <= 0;
		end
	endcase
end	

assign o_tx_active = r_tx_active;
assign o_tx_done = r_tx_done;	

endmodule