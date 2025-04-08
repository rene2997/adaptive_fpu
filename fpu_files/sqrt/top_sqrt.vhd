----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.04.2025 15:25:37
-- Design Name: 
-- Module Name: top_sqrt - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_sqrt is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           op : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           result_rdy_out : out STD_LOGIC;
           start : in STD_LOGIC);
end top_sqrt;

architecture Behavioral of top_sqrt is
    component floating_point_sqrt 
        Port (
            aclk : in std_logic;
            s_axis_a_tvalid : in std_logic;
            s_axis_a_tready : out std_logic;
            s_axis_a_tdata : in std_logic_vector(31 downto 0);
            m_axis_result_tvalid : out std_logic;
            m_axis_result_tdata : out std_logic_vector(31 downto 0));
    end component floating_point_sqrt;
    
    type state_type is (idle,waiting_for_pipeline,calculating);
    signal state,next_state : state_type;
    signal a_ready, a_valid, next_a_valid : std_logic;
    signal fpu_result : std_logic_vector(31 downto 0);
    signal result_rdy_fpu : std_logic;
    signal result_rdy, next_result_rdy : std_logic;
    
begin
    result <= fpu_result when result_rdy = '1' else (others => '0');
    result_rdy_out <= result_rdy;
    
    sqrt1 : component floating_point_sqrt
    port map(
        aclk => clk,
        s_axis_a_tvalid => a_valid,
        s_axis_a_tready => a_ready,
        s_axis_a_tdata => a,
        m_axis_result_tvalid => result_rdy_fpu,
        m_axis_result_tdata => fpu_result);
    
process(state,result_rdy,result_rdy_fpu,start) is
begin  
    next_state <= state;  
    next_result_rdy <= result_rdy;
    a_valid <='0';
    case state is
        when idle =>
            if start = '1' then
                a_valid <= '1';
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
