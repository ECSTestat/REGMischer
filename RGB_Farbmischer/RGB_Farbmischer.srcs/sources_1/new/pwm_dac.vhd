----------------------------------------------------------------------------------
-- Entity: dwm_dac
-- Company: HSLU
-- Engineer: J.Carlen, M. von Flüe
-- 
-------------------------------------------------------------------------------
-- Description: (ECS Testat 1)
-- Switches the specific LED On/OFF for "RGB Farbmischer"
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;

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
   constant c_psb     : natural := natural(ceil(log2(real(P))));
   signal pre_cnt     : unsigned(c_psb-1 downto 0);
   signal ref_cnt_enb : std_logic;
   signal ref_cnt     : unsigned(N downto 0);
      
begin
    LED_pwm: process (rst_pi,clk_pi)
    begin
        if (rst_pi = '1') then 
            pre_cnt <= (others => '0');
        elsif (rising_edge(clk_pi)) then
            if (pre_cnt < P-1) then
                pre_cnt <= pre_cnt + 1;
                ref_cnt_enb <= '0';
            else
                pre_cnt <= (others => '0');
                ref_cnt_enb <= '1';
            end if;            
        end if;
    end process;
    
    
    ref_cnt_e:process(rst_pi,clk_pi)
    begin
        if (rst_pi = '1') then 
            ref_cnt <= (others => '0');
        elsif (rising_edge(clk_pi)) then
            if ref_cnt_enb = '1' then
                if (ref_cnt < (2**N)-2)then
                    ref_cnt <= ref_cnt + 1;
                else
                    ref_cnt <= (others => '0');
                end if;
            end if; 
        end if;   
    end process;
    
    PWM_on:process(rst_pi,clk_pi)
    begin
        if (rst_pi = '1') then 
            led_po <= '0';
        elsif (rising_edge(clk_pi)) then
            if ref_cnt<unsigned(led_value_pi) then
                led_po <= '1';
            else
                led_po <= '0';
            end if; 
        end if; 
    end process;
end rtl;
