library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fpu_top is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           op : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           result_rdy_out : out STD_LOGIC;
           start : in STD_LOGIC);
end fpu_top;

architecture Behavioral of fpu_top is

    component floating_point_adder
        Port (
            aclk                    : in  std_logic;
            s_axis_a_tvalid         : in  std_logic;
            s_axis_a_tdata          : in  std_logic_vector(31 downto 0);
            s_axis_b_tvalid         : in  std_logic;
            s_axis_b_tdata          : in  std_logic_vector(31 downto 0);
            s_axis_operation_tvalid : in  std_logic;
            s_axis_operation_tdata  : in  std_logic_vector(7 downto 0);
            m_axis_result_tvalid    : out std_logic;
            m_axis_result_tdata     : out std_logic_vector(31 downto 0)
        );
    end component;

    type state_type is (idle,waiting_for_pipeline,calculating);
    signal state,next_state : state_type;
    signal a_valid, b_valid, op_valid: std_logic;
    signal fpu_result : std_logic_vector(31 downto 0);
    signal result_rdy_fpu : std_logic;
    signal result_rdy, next_result_rdy : std_logic;
    
    
begin

    result <= fpu_result when result_rdy = '1' else (others => '0');
    result_rdy_out <= result_rdy;
    
    fpu_inst : floating_point_adder
        port map (
            aclk                    => clk,
            s_axis_a_tvalid         => a_valid,
            s_axis_a_tdata          => a,
            s_axis_b_tvalid         => b_valid,
            s_axis_b_tdata          => b,
            s_axis_operation_tvalid => op_valid,
            s_axis_operation_tdata  => op,
            m_axis_result_tvalid    => result_rdy_fpu,
            m_axis_result_tdata     => fpu_result
        );
        
process(state,result_rdy,result_rdy_fpu,start) is
begin  
    next_state <= state;  
    next_result_rdy <= result_rdy;
    a_valid <='0';
    b_valid <='0';
    op_valid <='0';
    case state is
        when idle =>
            if start = '1' then
                b_valid <= '1';
                a_valid <= '1';
                op_valid <='1';
                next_state <= waiting_for_pipeline;
                next_result_rdy <= '0';
            end if;
            
        when waiting_for_pipeline =>
            if result_rdy_fpu = '0' then
                next_state <= calculating;
            end if;
        
        when calculating =>
            if result_rdy_fpu = '1' then
                next_state <= idle;
                next_result_rdy <= '1';
                
            end if;
        
    end case;
end process;

process(clk,reset) is
begin
    if rising_edge(clk) then
        if reset = '1' then
            state <= idle;
            result_rdy <= '0';
        else 
            state <= next_state;
            result_rdy <= next_result_rdy;
        end if;
    end if;
end process;
end Behavioral;
