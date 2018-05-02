-------------------------------------------------------------------------------
-- Entity: dim_log
-- Company: HSLU
-- Engineer: J.Carlen, M. von Flüe
-- 
-------------------------------------------------------------------------------
-- Description: (ECS Testat 1)
-- Calculate Values(Time On/Off) for LEDs for "RGB Farbmischer"
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity dim_log is
port (
        rst_pi         : in  std_logic;
        clk_pi         : in  std_logic;
        act_sync_pi    : in  std_logic_vector(2 downto 0);
        dim_down_pi    : in  std_logic;
        dim_up_pi      : in  std_logic;
        led_value_r_po : out std_logic_vector(4 downto 0);
        led_value_g_po : out std_logic_vector(3 downto 0);
        led_value_b_po : out std_logic_vector(2 downto 0)
        );
end dim_log;

architecture rtl of dim_log is
 signal  value_red   : unsigned(4 downto 0);
 signal  value_green : unsigned(3 downto 0);
 signal  value_blue  : unsigned(2 downto 0);
begin
 dim_logic: process(rst_pi, clk_pi)
 begin
    if rst_pi = '1' then
        led_value_r_po <= (others => '0');
        led_value_g_po <= (others => '0');
        led_value_b_po <= (others => '0');
        value_red      <= (others => '0');
        value_green    <= (others => '0'); 
        value_blue     <= (others => '0');
    elsif rising_edge(clk_pi) then
        --Switch2 enabled
        if act_sync_pi(2) = '1' then
            if value_red < 2**5-1 and dim_up_pi = '1' then
                value_red <= value_red + 1;
            elsif value_red > 0 and dim_down_pi = '1' then
                 value_red <= value_red - 1;                        
            end if;
            led_value_r_po <= std_logic_vector(value_red);
        end if;
        --Switch1 enabled
        if act_sync_pi(1) = '1' then
            if value_green < 2**4-1 and dim_up_pi = '1' then
                value_green <= value_green + 1;
            elsif value_green > 0 and dim_down_pi = '1' then
                value_green <= value_green - 1;                        
            end if;
            led_value_g_po <= std_logic_vector(value_green);    
        end if;
        --Switch0 enabled
        if act_sync_pi(0) = '1' then
            if value_blue < 2**3-1 and dim_up_pi = '1' then
                value_blue <= value_blue + 1;
            elsif value_blue > 0 and dim_down_pi = '1' then
                value_blue <= value_blue - 1;                        
            end if;
            led_value_b_po <= std_logic_vector(value_blue);                        
        end if;
    end if;
  end process;

end rtl;
