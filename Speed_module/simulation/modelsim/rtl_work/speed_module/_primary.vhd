library verilog;
use verilog.vl_types.all;
entity speed_module is
    generic(
        width           : integer := 8;
        depth           : integer := 6
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        start           : in     vl_logic;
        i_car           : in     vl_logic_vector;
        o_speed         : out    vl_logic_vector;
        o_id            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
    attribute mti_svvh_generic_type of depth : constant is 1;
end speed_module;
