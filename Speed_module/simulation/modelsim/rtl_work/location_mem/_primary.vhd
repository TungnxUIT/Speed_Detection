library verilog;
use verilog.vl_types.all;
entity location_mem is
    generic(
        width           : integer := 8;
        depth           : integer := 7
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        i_a             : in     vl_logic_vector;
        i_b             : in     vl_logic_vector;
        i_addr_a        : in     vl_logic_vector;
        i_addr_b        : in     vl_logic_vector;
        wen             : in     vl_logic;
        o_a             : out    vl_logic_vector;
        o_b             : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
    attribute mti_svvh_generic_type of depth : constant is 1;
end location_mem;
