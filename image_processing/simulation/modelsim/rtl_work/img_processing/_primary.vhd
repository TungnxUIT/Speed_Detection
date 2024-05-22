library verilog;
use verilog.vl_types.all;
entity img_processing is
    generic(
        img_width       : integer := 160;
        img_height      : integer := 148;
        size            : vl_notype;
        data_size       : integer := 11;
        address_size    : integer := 14
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        red             : out    vl_logic_vector(7 downto 0);
        green           : out    vl_logic_vector(7 downto 0);
        blue            : out    vl_logic_vector(7 downto 0);
        data_grayscale  : out    vl_logic_vector(7 downto 0);
        write_en        : out    vl_logic;
        done            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of img_width : constant is 1;
    attribute mti_svvh_generic_type of img_height : constant is 1;
    attribute mti_svvh_generic_type of size : constant is 3;
    attribute mti_svvh_generic_type of data_size : constant is 1;
    attribute mti_svvh_generic_type of address_size : constant is 1;
end img_processing;
