module uart_tx_testing#(
    parameter divisor = 2604  
)(
    input       i_clock,
    input 		i_tx_start,
    output		o_tx_done,
	output	o_tx_serial,
	output		o_tx_active
);
parameter depth = 12;
reg[7:0] data [depth - 1:0];
wire tx_done, active, start, o_clock, lock;
reg s;
reg[7:0] index;

initial begin
    s = 0;
    index = 0;
    data[0] = "H";
    data[1] = "e";
    data[2] = "l";
    data[3] = "l";
    data[4] = "o";
    data[5] = " ";
    data[6] = "W";
    data[7] = "o";
    data[8] = "r";
    data[9] = "l";
    data[10] = "d";
    data[11] = " ";
end

uart_tx#(.divisor(divisor), .depth(depth)) tx(
    .i_clock(o_clock),
	.i_tx_start(start),
	.i_tx_data(data[index]),
	.o_tx_done(tx_done),
	.o_tx_serial(o_tx_serial),
	.o_tx_active(active)
);

/*rPLL #( // For GW1NR-9C C6/I5 (Tang Nano 9K proto dev board)
  .FCLKIN("27"),
  .IDIV_SEL(8), // -> PFD = 3 MHz (range: 3-400 MHz)
  .FBDIV_SEL(4), // -> CLKOUT = 15 MHz (range: 3.125-600 MHz)
  .ODIV_SEL(32) // -> VCO = 480 MHz (range: 400-1200 MHz)
) pll (.CLKOUTP(), .CLKOUTD(), .CLKOUTD3(), .RESET(1'b0), .RESET_P(1'b0), .CLKFB(1'b0), .FBDSEL(6'b0), .IDSEL(6'b0), .ODSEL(6'b0), .PSDA(4'b0), .DUTYDA(4'b0), .FDLY(4'b0),
  .CLKIN(i_clock), // 27 MHz
  .CLKOUT(o_clock), // 58.5 MHz
  .LOCK(lock)
);*/

always@(posedge i_clock) begin
    if(tx_done == 1'b1) begin
        if(index == depth - 1)
            index <= 0;
        else index <= index + 1;
    end
end
assign start = (lock == 1'b1) ? ~i_tx_start : 0;
assign o_tx_done = ~tx_done;
assign o_tx_active = ~active;

endmodule