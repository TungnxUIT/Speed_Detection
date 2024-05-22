library verilog;
use verilog.vl_types.all;
entity speed is
    generic(
        width           : integer := 8;
        depth           : integer := 6
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        start           : in     vl_logic;
        i_car           : in     vl_logic_vector;
        i_x             : in     vl_logic_vector;
        i_y             : in     vl_logic_vector;
        o_x             : out    vl_logic_vector;
        o_y             : out    vl_logic_vector;
        o_idx           : out    vl_logic_vector;
        o_idy           : out    vl_logic_vector;
        o_speed         : out    vl_logic_vector;
        o_id            : out    vl_logic_vector;
        o_wen_speed     : out    vl_logic;
        o_wen_location  : out    vl_logic;
        o_change_id     : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
    attribute mti_svvh_generic_type of depth : constant is 1;
end speed;
