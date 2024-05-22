`timescale 1ns/1ps

module top_tb;

  // Parameters
  parameter width = 8;
  parameter depth = 6;
   parameter DIVISOR = 80;
	 parameter PERIOD = 7900;
	 parameter clock_period = 100;

  // Inputs
  reg clk = 0;
  reg rst_n = 1;
  reg i_rx_serial;
  reg [depth - 1:0] i_rdaddr_speed;
  

  // Outputs
  wire [width - 1:0] o_speed;
  wire [width-1:0] uart_data;
  wire	rx_finish;
  
  reg[31:0] count;

  // Instantiate the module under test
  top#(.width(width), .depth(depth), .divisor(DIVISOR)) dut (
    .clk(clk),
    .rst_n(rst_n),
    .i_rx_serial(i_rx_serial),
    .i_rdaddr_speed(i_rdaddr_speed),
    .o_speed(o_speed),
	 .rx_finish(rx_finish),
	 .uart_data(uart_data)
  );

  // Clock generation
  always #(clock_period/2) clk <= !clk;

  task UART_WRITE_BYTE;
    input [7:0] i_Data;
    integer     ii;
    begin
       
      // Send Start Bit
      i_rx_serial <= 1'b0;
      #(PERIOD);
       
       
      // Send Data Byte
      for (ii=0; ii<8; ii=ii+1)
        begin
          i_rx_serial <= i_Data[ii];
          #(PERIOD);
        end
       
      // Send Stop Bit
      i_rx_serial <= 1'b1;
      #(PERIOD);
     end
  endtask // UART_WRITE_BYTE
  // Initial stimulus
  initial begin
    // Reset
    rst_n = 0;
	 count = 0;
	 i_rx_serial = 1;
	 i_rdaddr_speed = 18;
    #10;
    rst_n = 1;
	 #100;
	@(posedge clk);
	UART_WRITE_BYTE(8'd18);	//id
	@(posedge clk);
	UART_WRITE_BYTE(8'd10);	//x
	@(posedge clk);
	UART_WRITE_BYTE(8'd240);	//y
	@(posedge clk);
	UART_WRITE_BYTE(8'hFF);	//wait
	@(posedge clk);
	UART_WRITE_BYTE(8'd10);	//id
	@(posedge clk);
	UART_WRITE_BYTE(8'd100);	//x
	@(posedge clk);
	UART_WRITE_BYTE(8'd200);	//y
	@(posedge clk);
	UART_WRITE_BYTE(8'hFF);	//wait
	@(posedge clk);
	UART_WRITE_BYTE(8'd18);	//id
	@(posedge clk);
	UART_WRITE_BYTE(8'd100);	//x
	@(posedge clk);
	UART_WRITE_BYTE(8'd215);	//y
	@(posedge clk);
	UART_WRITE_BYTE(8'hFF);	//wait
  end

  // Monitor
  always @(posedge clk) begin
    // Display output values
	 if(rx_finish) begin
    $display("%d", uart_data);
	 $stop;
	 end
	 if(o_speed != 0) begin
	 $display("%d", o_speed);
	 $finish;
	 end
  end

endmodule