library verilog;
use verilog.vl_types.all;
entity number_display is
    port(
        clk             : in     vl_logic;
        data1           : in     vl_logic_vector(7 downto 0);
        data2           : in     vl_logic_vector(7 downto 0);
        char1           : out    vl_logic_vector(7 downto 0);
        char2           : out    vl_logic_vector(7 downto 0);
        char3           : out    vl_logic_vector(7 downto 0);
        char4           : out    vl_logic_vector(7 downto 0);
        char5           : out    vl_logic_vector(7 downto 0);
        char6           : out    vl_logic_vector(7 downto 0)
    );
end number_display;
