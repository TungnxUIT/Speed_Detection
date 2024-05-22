library verilog;
use verilog.vl_types.all;
entity uart_rx_tb is
    generic(
        DIVISOR         : integer := 80;
        PERIOD          : integer := 7900;
        clock_period    : integer := 100
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DIVISOR : constant is 1;
    attribute mti_svvh_generic_type of PERIOD : constant is 1;
    attribute mti_svvh_generic_type of clock_period : constant is 1;
end uart_rx_tb;
