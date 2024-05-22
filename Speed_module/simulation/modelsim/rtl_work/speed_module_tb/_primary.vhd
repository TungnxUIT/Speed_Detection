library verilog;
use verilog.vl_types.all;
entity speed_module_tb is
    generic(
        WIDTH           : integer := 8;
        DEPTH           : integer := 8
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DEPTH : constant is 1;
end speed_module_tb;
