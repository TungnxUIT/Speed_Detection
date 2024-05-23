module lcd(
	input	clk,
	input	rst_n	,
	input [7:0] data1,
	input [7:0] data2,
	input [7:0] data3,
	input [7:0] data4,
	
	output wire lcd_on,
	output	reg lcd_rs		,
	output	wire lcd_rw		,
	output	reg lcd_en		,
	output	reg[7:0]	lcd_data 
	);
 
	reg	[17:0]	cnt				;
	reg	[3:0]	state_c			;
	reg	[3:0]	state_n			;
	reg	[4:0]	char_cnt		;
	reg	[7:0]	data_display	;
 
	localparam
		IDLE			= 4'd0	,
		INIT 			= 4'd1	,
		S0				= 4'd2	,
		S1				= 4'd3	,
		S2				= 4'd4	,
		S3				= 4'd5	,
		ROW1_ADDR		= 4'd6	,
		WRITE			= 4'd7	,
		ROW2_ADDR		= 4'd8	,
		stop			= 4'd9	;
 
 
	assign lcd_rw = 1'b0;
	assign lcd_on = 1'b1;

	reg [7:0] prev_data1;
	reg [7:0] prev_data2;
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 17'd0;
		end
		else begin
			if (cnt==17'd100_000 - 1) begin
				cnt <= 17'd0;
			end
			else begin
				cnt <= cnt + 1'b1;
			end
		end
	end
 
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			lcd_en <= 0;
		end
		else if (cnt==17'd50_000 - 1) begin
			lcd_en <= 1;
		end
		else if (cnt==17'd100_000 - 1) begin
			lcd_en <= 0;
		end
	end
 //speed:xxx, id:xxx -> 15 char
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			char_cnt <= 0;
		end
		else if (state_c==WRITE && cnt==17'd50_000 - 1) begin
			if (char_cnt==5'd19) begin
				char_cnt <= 5'd0;
			end
			else begin
				char_cnt <= char_cnt + 1'b1;
			end
		end
	end
reg [7:0] char1, char2, char3, char4, char5, char6;
reg [7:0] char7, char8, char9, char10, char11, char12;
wire [7:0] char1t, char2t, char3t, char4t, char5t, char6t;
wire [7:0] char7t, char8t, char9t, char10t, char11t, char12t;
number_display number0(.clk(clk),.data1(data1),.data2(data2),.char1(char1t),.char2(char2t),.char3(char3t),.char4(char4t),.char5(char5t),.char6(char6t));
number_display number1(.clk(clk),.data1(data3),.data2(data4),.char1(char7t),.char2(char8t),.char3(char9t),.char4(char10t),.char5(char11t),.char6(char12t));
always @(*) begin
	char1 <= char1t;
	char2 <= char2t;
	char3 <= char3t;
	char4 <= char4t;
	char5 <= char5t;
	char6 <= char6t;
	char7 <= char7t;
	char8 <= char8t;
	char9 <= char9t;
	char10 <= char10t;
	char11 <= char11t;
	char12 <= char12t;
end
	always @(*) begin
		case(char_cnt)
			5'd0: data_display   = char1;
			5'd1: data_display   = char2;
			5'd2: data_display   = char3;
			5'd3: data_display   = " ";
			5'd4: data_display   = " ";
			5'd5: data_display   = " ";
			5'd6: data_display   = " ";
			5'd7: data_display   = char4;
			5'd8: data_display   = char5;
			5'd9: data_display   = char6;
			5'd10: data_display   = char7;
			5'd11: data_display   = char8;
			5'd12: data_display   = char9;
			5'd13: data_display  = " ";
			5'd14: data_display  = " ";
			5'd15: data_display  = " ";
			5'd16: data_display  = " ";
			5'd17: data_display  = char10;
			5'd18: data_display  = char11;
			5'd19: data_display  = char12;
			default: data_display = " ";
		endcase
	end
 
 //State machine
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state_c <= IDLE;
		end
		else if(cnt==17'd50_000 - 1) begin
			state_c <= state_n;
		end
	end
 
	reg	[19:0]	cnt_15ms;
	reg		flag	;
	always@(posedge clk or negedge rst_n)begin
		if (!rst_n) begin
			cnt_15ms <= 0;
		end
		else if (state_c == IDLE) begin
			cnt_15ms <= cnt_15ms + 1'b1;
		end
		else cnt_15ms <= 0;
	end
 
	always@(posedge clk or negedge rst_n)begin
		if (!rst_n) begin
			flag <= 0;
		end
		else if (state_c==IDLE && cnt_15ms==20'd750000) begin
			flag <= 1;
		end
	end

	always @(*) begin
		case(state_c)
			IDLE:
				begin
					if (flag) begin
						state_n = INIT;
					end
					else begin
						state_n = state_c;
					end
					prev_data1 = data1;
					prev_data2 = data2;
				end
			INIT 	:
				begin
					state_n = S0;
				end
			S0  	:
				begin
					state_n = S1;
				end
			S1  	:
				begin
					state_n = S2;
				end
			S2  	:
				begin
					state_n = S3;
				end
			S3  	:
				begin
					state_n = ROW1_ADDR;
				end
			ROW1_ADDR:
				begin
					state_n = WRITE;
				end
			WRITE		:
				begin
					if (char_cnt==5'd9) begin
						state_n = ROW2_ADDR;
					end
					else if (char_cnt==5'd19) begin
						state_n = stop;
					end
					else begin
						state_n = state_c;
					end
				end
			ROW2_ADDR:
				begin
					state_n = WRITE;
				end
			stop		:
				begin
					if (prev_data1 != data1) begin
						state_n = IDLE;
						end
					else if (prev_data2 != data2) begin
						state_n = IDLE;
						end
					else state_n = stop; 
				end
			default:state_n = IDLE;
		endcase
	end
 
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			lcd_data <= 8'd0;
		end
		else begin
			case(state_c)
			   //start lcd
				IDLE		:begin lcd_data <= 8'h38; lcd_rs <= 0;end
				INIT 		:begin lcd_data <= 8'h38; lcd_rs <= 0;end
				S0		:begin lcd_data <= 8'h08; lcd_rs <= 0;end
				S1		:begin lcd_data <= 8'h01; lcd_rs <= 0;end
				S2		:begin lcd_data <= 8'h06; lcd_rs <= 0;end
				S3		:begin lcd_data <= 8'h0c; lcd_rs <= 0;end
				//write
				ROW1_ADDR	:begin lcd_data <= 8'h80; lcd_rs <= 0;end
				WRITE		:begin lcd_data <= data_display; lcd_rs <= 1;end
				ROW2_ADDR	:begin lcd_data <= 8'hc0; lcd_rs <= 0;end
				stop		:begin lcd_data <= 8'h0c; lcd_rs <= 0;end
				default:;
			endcase
		end
	end
endmodule