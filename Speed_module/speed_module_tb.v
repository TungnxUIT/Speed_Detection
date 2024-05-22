`timescale 1ns/1ps

module speed_module_tb;

    // Parameters
    parameter WIDTH = 8;
    parameter DEPTH = 8;

    // Signals
    reg clk;
    reg rst_n;
    reg start;
	 //reg[DEPTH-1:0] i_rdaddr_speed;
    reg [WIDTH-1:0] i_car;
    wire [WIDTH-1:0] o_speed;
    wire [DEPTH - 1:0] o_id;
	 //wire[WIDTH -1:0]x, y;
	 reg[WIDTH - 1:0] mem [2 ** 20 - 1 : 0];
	 reg[31:0] i, count;
	 
	 initial begin
		$readmemb("D:/Study/UIT/DA/DA1/tool/detect_and_tracking_cars_python/results_bin.txt", mem);
	end
    // Instantiate the module under test
    speed_module #(
        .width(WIDTH),
        .depth(DEPTH)
    ) dut (
	.clk(clk),
	.rst_n(rst_n),
	.start(start),
	//.i_rdaddr_speed(i_rdaddr_speed),
	.i_car(i_car),
	.o_speed(o_speed),
	.o_id(o_id)
    );
    // Clock generation
    always #5 clk = ~clk;
	 always@(posedge clk) begin
		if(start) begin
			i_car <= mem[i];
			i <= i + 1;
		end
	 end

	 always@(posedge clk) begin
		if(o_speed) begin
			$display("id: %d, speed: %d", o_id, o_speed);
			count <= count + 1;
		end
		//if (o_speed == 112) $stop;
	 end
    // Reset generation
    initial begin
	 
    // Initialize inputs
    clk = 0;
    rst_n = 0;
    start = 0;
    i_car = 0;
	 //i_rdaddr_speed = 'd18;
	 i = 0;
	 count <= 0;
	 #3 rst_n = 1;
	 start = 1;

    // Reset
   /* #10 rst_n = 1;

    // Testcase 1: Set inputs and start calculation
	 #20 i_car = 9'd100; // Example input value
		  
    #20 start = 1;
	 #5
	 #10 i_car = 9'd100;	//x
	 #10 i_car = 9'd310;	//y
	 i_rdaddr_speed = 100;
	 
	 // Testcase 2
	 #20 i_car = 9'd100;
		  
	 #10 i_car = 9'd100; //x
	 #10 i_car = 9'd291; //y
	 i_rdaddr_speed = 100; 
	 
	 // Testcase 3
	 #20 i_car = 9'd20;
		  
	 #10 i_car = 9'd100;
	 #10 i_car = 9'd250;
	 i_rdaddr_speed = 20;
	 

    // Additional testcases can be added here with appropriate delay and input values

    // End simulation
    //#100 $finish;*/
	// $stop;
  end

    // Monitor
    // You can add code here to monitor the outputs if needed

endmodule
