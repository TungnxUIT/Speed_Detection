library verilog;
use verilog.vl_types.all;
entity lcd_vlg_check_tst is
    port(
        char1           : in     vl_logic_vector(7 downto 0);
        char2           : in     vl_logic_vector(7 downto 0);
        char3           : in     vl_logic_vector(7 downto 0);
        char4           : in     vl_logic_vector(7 downto 0);
        char5           : in     vl_logic_vector(7 downto 0);
        char6           : in     vl_logic_vector(7 downto 0);
        lcd_data        : in     vl_logic_vector(7 downto 0);
        lcd_en          : in     vl_logic;
        lcd_rs          : in     vl_logic;
        lcd_rw          : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end lcd_vlg_check_tst;
