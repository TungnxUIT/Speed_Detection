library verilog;
use verilog.vl_types.all;
entity image_mem is
    port(
        address         : in     vl_logic_vector(14 downto 0);
        clock           : in     vl_logic;
        q               : out    vl_logic_vector(11 downto 0)
    );
end image_mem;
