module processing (
    input [11:0] data_in,
    input switch,
    output reg [11:0] data_out
);
//parameter idle = 0;
parameter normal = 0;
parameter grayscale = 1;

reg [3:0] r, g, b;
reg [11:0] gray;
reg [1:0] mode;

always @(posedge switch) begin
    if (switch == 1) begin
        case (mode)
            normal: mode <= grayscale;
            grayscale: mode <= normal;
            //default: mode <= normal;
        endcase
    end
end

always @* begin
	r <= data_in[11:8];
	g <= data_in[7:4];
   b <= data_in[3:0];
	gray <= ((r + g + b) << 1) - (r + g + b);
    case (mode)
        normal: begin
				data_out <= data_in;
        end
        grayscale: begin
            data_out <= gray; 
        end
        default: begin
            data_out <= 12'd0;
        end
    endcase
end

endmodule
