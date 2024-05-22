module number_display(
	input clk, 
	input [7:0] data1,
	input [7:0] data2,
	output reg [7:0] char1,
	output reg [7:0] char2,
	output reg [7:0] char3,
	output reg [7:0] char4,
	output reg [7:0] char5,
	output reg [7:0] char6
	);
reg [3:0] digit1, digit2, digit3, digit4, digit5, digit6;

always@(posedge clk) begin
	digit1 = (data1/100);
	case(digit1)
			0: char1 = "0";
			1: char1 = "1";
			2: char1 = "2";
			3: char1 = "3";
			4: char1 = "4";
			5: char1 = "5";
			6: char1 = "6";
			7: char1 = "7";
			8: char1 = "8";
			9: char1 = "9";
			default: char1 = "0";
	endcase
end

always@(posedge clk) begin
	digit2 = (data1 % 100)/10;
	case(digit2)
			0: char2 = "0";
			1: char2 = "1";
			2: char2 = "2";
			3: char2 = "3";
			4: char2 = "4";
			5: char2 = "5";
			6: char2 = "6";
			7: char2 = "7";
			8: char2 = "8";
			9: char2 = "9";
			default: char2 = "0"	;
	endcase
end

always@(posedge clk) begin
	digit3 = (data1 % 10);
	case(digit3)
			0: char3 = "0";
			1: char3 = "1";
			2: char3 = "2";
			3: char3 = "3";
			4: char3 = "4";
			5: char3 = "5";
			6: char3 = "6";
			7: char3 = "7";
			8: char3 = "8";
			9: char3 = "9";
			default: char3 = "0"	;
	endcase
end

always@(posedge clk) begin
	digit4 = (data2/100);
	case(digit4)
			0: char4 = "0";
			1: char4 = "1";
			2: char4 = "2";
			3: char4 = "3";
			4: char4 = "4";
			5: char4 = "5";
			6: char4 = "6";
			7: char4 = "7";
			8: char4 = "8";
			9: char4 = "9";
			default: char4 = "0"	;
		endcase
end

always@(posedge clk) begin
	digit5 = (data2 % 100)/10;
	case(digit5)
			0: char5 = "0";
			1: char5 = "1";
			2: char5 = "2";
			3: char5 = "3";
			4: char5 = "4";
			5: char5 = "5";
			6: char5 = "6";
			7: char5 = "7";
			8: char5 = "8";
			9: char5 = "9";
			default: char5 = "0"	;
			endcase
end

always@(posedge clk) begin
	digit6 = (data2 % 10);
	case(digit6)
			0: char6 = "0";
			1: char6 = "1";
			2: char6 = "2";
			3: char6 = "3";
			4: char6 = "4";
			5: char6 = "5";
			6: char6 = "6";
			7: char6 = "7";
			8: char6 = "8";
			9: char6 = "9";
			default: char6 = "0"	;
			endcase
end
endmodule