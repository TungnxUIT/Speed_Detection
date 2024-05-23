library verilog;
use verilog.vl_types.all;
entity number_display_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        data1           : in     vl_logic_vector(7 downto 0);
        data2           : in     vl_logic_vector(7 downto 0);
        sampler_tx      : out    vl_logic
    );
end number_display_vlg_sample_tst;
