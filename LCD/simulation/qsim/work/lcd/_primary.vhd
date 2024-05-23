library verilog;
use verilog.vl_types.all;
entity lcd is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        lcd_rs          : out    vl_logic;
        lcd_rw          : out    vl_logic;
        lcd_en          : out    vl_logic;
        lcd_data        : out    vl_logic_vector(7 downto 0);
        char1           : out    vl_logic_vector(7 downto 0);
        char2           : out    vl_logic_vector(7 downto 0);
        char3           : out    vl_logic_vector(7 downto 0);
        char4           : out    vl_logic_vector(7 downto 0);
        char5           : out    vl_logic_vector(7 downto 0);
        char6           : out    vl_logic_vector(7 downto 0)
    );
end lcd;
