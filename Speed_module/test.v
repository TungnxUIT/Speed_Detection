module test(output reg[8:0] result);

  // Khai báo biến cho kết quả và số cần nhân
  //reg [7:0] result; // Dùng 8-bit để lưu trữ kết quả

  // Nhân với 0.75
  always @* begin
    result = 8'd100 * 0.75; // Nhân với 0.75
  end

  // Hiển thị kết quả
  initial begin
    $display("Kết quả của phép nhân là %d", result);
  end

endmodule