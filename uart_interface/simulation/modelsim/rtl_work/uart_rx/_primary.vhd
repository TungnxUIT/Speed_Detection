library verilog;
use verilog.vl_types.all;
entity uart_rx is
    generic(
        divisor         : integer := 1150
    );
    port(
        i_clock         : in     vl_logic;
        i_rx_received   : in     vl_logic;
        o_rx_data       : out    vl_logic_vector(8 downto 0);
        o_rx_done       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of divisor : constant is 1;
end uart_rx;
