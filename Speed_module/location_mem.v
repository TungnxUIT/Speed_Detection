module location_mem#(
	parameter width = 8,
	parameter depth = 7
)
(
	input 						clk,
	input 						rst_n,
	input[width - 1:0] 		i_a,
	input[width - 1:0] 		i_b,
	input[depth - 1:0] 		i_addr_a,
	input[depth - 1:0] 		i_addr_b,
	input 						wen,
	output reg[width - 1:0] o_a,
	output reg[width - 1:0] o_b
);

reg[width - 1:0] mem [2 ** depth - 1:0];
integer i;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) 
		for(i = 0; i < (2 ** depth - 1); i = i + 1)
			mem[i] <= 0;
	else begin
		if(wen) begin
			mem[i_addr_a] <= i_a;
			mem[i_addr_b] <= i_b;
		end
		/*else begin
			o_a <= mem[i_addr_a];
			o_b <= mem[i_addr_b];
		end*/
	end
end

always@* begin
		o_a <= mem[i_addr_a];
		o_b <= mem[i_addr_b];
end

endmodule