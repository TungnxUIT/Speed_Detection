module speed_mem#(
	parameter width = 8,
	parameter depth = 6
)
(
	input 						clk,
	input 						rst_n,
	input[width - 1:0] 		i_speed,
	input[depth - 1:0] 		i_addr_speed,
	input[depth - 1:0] 		i_rdaddr_speed0, i_rdaddr_speed1,
	input							wen,
	input							i_change_id0, i_change_id1,
	output reg[width - 1:0]	o_speed0,
	output reg[width - 1:0]	o_speed1,
	output reg[depth - 1:0]	o_id0, o_id1
);

reg[width - 1:0] register [2 ** depth - 1:0];
reg[depth - 1:0] rdaddr_speed0 = 0;
reg[depth - 1:0] rdaddr_speed1 = 0;
integer i;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		rdaddr_speed0 <= 0;
		rdaddr_speed1 <= 0;
		for(i = 0; i < 2 ** depth - 1; i = i + 1)
			register[i] <= 0;
	end
	else begin
		if(wen) begin
			register[i_addr_speed] <= i_speed;
		end
		rdaddr_speed0 <= (i_change_id0) ? i_rdaddr_speed0 : rdaddr_speed0;
		rdaddr_speed1 <= (i_change_id1) ? i_rdaddr_speed1 : rdaddr_speed1;
	end
end


always@* begin
		o_speed0 <= register[rdaddr_speed0];
		o_speed1 <= register[rdaddr_speed1];
		o_id0 <= rdaddr_speed0;
		o_id1 <= rdaddr_speed1;
end

endmodule