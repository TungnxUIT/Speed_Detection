library verilog;
use verilog.vl_types.all;
entity number_display_vlg_check_tst is
    port(
        char1           : in     vl_logic_vector(7 downto 0);
        char2           : in     vl_logic_vector(7 downto 0);
        char3           : in     vl_logic_vector(7 downto 0);
        char4           : in     vl_logic_vector(7 downto 0);
        char5           : in     vl_logic_vector(7 downto 0);
        char6           : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end number_display_vlg_check_tst;
