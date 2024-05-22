module speed_tb;

  // Parameters
  parameter width = 9;
  parameter depth = 8;

  // Signals
  reg clk;
  reg rst_n;
  reg start;

  reg [width - 1:0] i_car;
  reg [width - 1:0] i_x;
  reg [width - 1:0] i_y;
  wire [width - 1:0] o_x;
  wire [width - 1:0] o_y;
  wire [depth :0] o_idx;
  wire [depth :0] o_idy;
  wire [width - 1:0] o_speed;
  wire [depth - 1:0] o_id;
  wire o_wen_speed;
  wire o_wen_location;

  // Instantiate the module under test
  speed #(width, depth) dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .i_car(i_car),
    .i_x(i_x),
    .i_y(i_y),
    .o_x(o_x),
    .o_y(o_y),
    .o_idx(o_idx),
    .o_idy(o_idy),
    .o_speed(o_speed),
    .o_id(o_id),
    .o_wen_speed(o_wen_speed),
    .o_wen_location(o_wen_location)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Test stimulus
  initial begin
    // Initialize inputs
    clk = 0;
    rst_n = 0;
    start = 0;
    i_car = 0;
    i_x = 0;
    i_y = 0;

    // Reset
    #10 rst_n = 1;

    // Testcase 1: Set inputs and start calculation
	 #20 i_car = 9'd100; // Example input value
		  i_y = 354; i_x = 100;
    #20 start = 1;
	 #5
	 #10 i_car = 9'd100;	//x
	 #10 i_car = 9'd310;	//y
	 
	 // Testcase 2
	 #20 i_car = 9'd50;
		  i_y = 245;
	 #10 i_car = 9'd100; //x
	 #10 i_car = 9'd202; //y	
	 
	 // Testcase 3
	 #20 i_car = 9'd20;
		  i_y = 210;
	 #10 i_car = 9'd100;
	 #10 i_car = 9'd250;

    // Additional testcases can be added here with appropriate delay and input values

    // End simulation
    //#100 $finish;
	 $stop;
  end

endmodule
