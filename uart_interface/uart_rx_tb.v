`timescale 1ns/10ps
module uart_rx_tb;

    // Parameters
    parameter DIVISOR = 80;
	 parameter PERIOD = 7900;
	 parameter clock_period = 100;

    // Signals
    reg i_clock;
    reg i_rx_received;
    wire [8:0] o_rx_data;
    wire o_rx_done;

    // Instantiate the UART Receiver
    uart_rx #(.divisor(DIVISOR)) uart_receiver (
        .i_clock(i_clock),
        .i_rx_received(i_rx_received),
        .o_rx_data(o_rx_data),
        .o_rx_done(o_rx_done)
    );

    // Clock Generation
    always #(clock_period/2) i_clock <= !i_clock;

    // Initial Stimulus
    initial begin
        i_clock = 0;
        i_rx_received = 1; // Initial state is idle
        
        // Wait for some time to ensure the receiver is idle
        #100;

        // Start transmitting a test frame
        // Simulate a start bit followed by 9 data bits (101010101)
        i_rx_received = 0;
		  #PERIOD
		  // 9 Data bit
        i_rx_received = 1; // Data bit 0
        #PERIOD;
        i_rx_received = 1; // Data bit 1
        #PERIOD;
        i_rx_received = 0; // Data bit 0
        #PERIOD;
        i_rx_received = 0; // Data bit 1
        #PERIOD;
        i_rx_received = 1; // Data bit 0
        #PERIOD;
        i_rx_received = 1; // Data bit 1
        #PERIOD;
        i_rx_received = 0; // Data bit 0
        #PERIOD;
        i_rx_received = 0; // Data bit 1
        #PERIOD;
        i_rx_received = 0; // Data bit 0
        #PERIOD;
        i_rx_received = 1; // Stop bit
        #PERIOD;


        // Check the received data

        // Check if the frame reception is completed

        // End simulation
        //$stop;
    end
		 always@(posedge i_clock) begin
        if (o_rx_done) begin
            $display("Frame reception completed successfully.");
				$display("Received data: %b", o_rx_data);
				$stop;
			end
			end
endmodule
