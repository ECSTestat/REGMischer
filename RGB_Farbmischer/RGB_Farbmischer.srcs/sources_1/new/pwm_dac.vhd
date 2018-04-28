----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2018 15:23:34
-- Design Name: 
-- Module Name: pwm_dac - Behavioral
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
use ieee.numeric_std.all;
use ieee.math_real.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm_dac is
generic (
    N : integer := 3; --Default 3
    P : integer := 0 --Defautl 0        
    );
port (
    rst_pi       : in  std_logic;
    clk_pi       : in  std_logic;
    led_value_pi : in  std_logic_vector(N-1 downto 0);
    led_po       : out std_logic
    );
end pwm_dac;

architecture rtl of pwm_dac is
   signal ref_cnt_enb : unsigned((P-1) downto 0);
   signal ref_cnt     : unsigned(N downto 0);
      
begin
    LED_pwm: process (rst_pi,clk_pi)
    begin
        if (rst_pi = '1') then 
            led_po <= '0';
        elsif (rising_edge(clk_pi)) then
            if (ref_cnt_enb < P) then
                ref_cnt_enb <= ref_cnt_enb + 1;
            elsif (ref_cnt < (2**N)-2) then
                ref_cnt <= ref_cnt + 1;
                ref_cnt_enb <= (others => '0');
            else
                ref_cnt <= (others => '0');
            end if;
            if ref_cnt>unsigned(led_value_pi) then
               led_po <= '1';
            else
                led_po <= '0';
            end if;      
        
        end if;
    end process;

end rtl;
