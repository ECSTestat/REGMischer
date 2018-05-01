----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2018 14:00:19
-- Design Name: 
-- Module Name: pwm_led_top - Behavioral
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


library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity pwm_led_top is
  generic(
    CLK_FRQ : integer := 125_000_000; -- 125 MHz
    DAC_FRQ : integer := 20_000; -- 20 kHz
    N_RED   : integer := 5; -- DAC Res Red
    N_GREEN : integer := 4; -- DAC Res Green
    N_BLUE  : integer := 3 -- DAC Res Blue
  );
  port(
    rst_pi : in std_logic; -- BTN_0
    clk_pi : in std_logic;
    act_pi : in std_logic_vector(2 downto 0); -- SW(2:0)=R:G:B
    enc_pi : in std_logic_vector(1 downto 0); -- EncA:EncB
    led_po : out std_logic_vector(2 downto 0) -- R:G:B
  );
end pwm_led_top;



architecture struct of pwm_led_top is

-- component declarations
  component Rstsync
    generic(
      RPL : integer := 3
      );
    port (
      rst_pi : in  std_logic;
      clk_pi : in  std_logic;
      rst_po : out std_logic
      );
  end component;
  component Sync 
     port (
        rst_pi       : in  std_logic;
        clk_pi       : in  std_logic;
        enc_pi       : in  std_logic_vector(1 downto 0);                    
        deb_enc_po   : out std_logic_vector(1 downto 0);
        act_pi       : in  std_logic_vector(2 downto 0);
        act_sync_po  : out std_logic_vector(2 downto 0)
        );
    end component;
  component Ctrl
    port (
        rst_pi       : in  std_logic;
        clk_pi       : in  std_logic;
        deb_enc_pi   : in  std_logic_vector(1 downto 0);
        dim_down_po  : out std_logic;
        dim_up_po    : out std_logic
        ); 
  end component; 
  component dim_log
    port (
        rst_pi       : in  std_logic;
        clk_pi       : in  std_logic;
        act_sync_pi  : in  std_logic_vector(2 downto 0);
        dim_down_pi  : in  std_logic;
        dim_up_pi    : in  std_logic;
        led_value_r_po : out std_logic_vector(N_RED-1 downto 0);
        led_value_g_po : out std_logic_vector(N_GREEN-1 downto 0);
        led_value_b_po : out std_logic_vector(N_BLUE-1 downto 0)       
      );
   end component; 
   component pwm_dac
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
   end component;
 signal rst_loc                                 : std_logic;
 signal enc_sync                                : std_logic_vector(1 downto 0);
 signal act_sync                                : std_logic_vector(2 downto 0);  
 signal dim_down                                : std_logic;
 signal dim_up                                  : std_logic;
 signal led_value_r                             : std_logic_vector(N_RED-1 downto 0);
 signal led_value_g                             : std_logic_vector(N_GREEN-1 downto 0);
 signal led_value_b                             : std_logic_vector(N_BLUE-1 downto 0);   
begin
-- instance "Rstsync"
  u_Rstsync: Rstsync
    port map (
      rst_pi => rst_pi,
      clk_pi => clk_pi,
      rst_po => rst_loc
      );
  
  -- instance "Sync"
  u_sync: Sync
    port map (
      rst_pi       => rst_loc,
      clk_pi       => clk_pi ,
      enc_pi       => enc_pi ,
      act_pi       => act_pi ,
      deb_enc_po   => enc_sync,
      act_sync_po  => act_sync
      );
      
  -- instance "Ctrl"
  u_ctrl: Ctrl
    port map (
      rst_pi       => rst_loc,
      clk_pi       => clk_pi ,
      deb_enc_pi   => enc_sync,
      dim_down_po  => dim_down,
      dim_up_po    => dim_up
      );
      
    --instance "dim-log"
  u_dim_log: dim_log
   port map (
       rst_pi       => rst_loc,
       clk_pi       => clk_pi ,
       act_sync_pi  => act_sync ,
       dim_down_pi  => dim_down,
       dim_up_pi    => dim_up,
       led_value_r_po => led_value_r,
       led_value_g_po => led_value_g,
       led_value_b_po => led_value_b
       );
   --instance "pwm_dac-RED"    
  u_pwm_dac_r: pwm_dac
  generic map (
        N => N_RED,
        P => natural(round(real(CLK_FRQ)/real(DAC_FRQ*(2**N_RED-1))))
  )
  port map (     
         rst_pi       => rst_loc,
         clk_pi       => clk_pi ,
         led_value_pi => led_value_r,
         led_po       => led_po(2)
         );
  --instance "pwm_dac_GREEN"
  u_pwm_dac_g: pwm_dac
  generic map (
     N => N_GREEN,
     P => natural(round(real(CLK_FRQ)/real(DAC_FRQ*(2**N_GREEN-1))))
  )
  port map (     
     rst_pi       => rst_loc,
     clk_pi       => clk_pi ,
     led_value_pi => led_value_g,
     led_po       => led_po(1)
   );
   --instance "pwm_dac_BLUE"
 u_pwm_dac_b: pwm_dac
  generic map (
     N => N_BLUE,
     P => natural(round(real(CLK_FRQ)/real(DAC_FRQ*(2**N_BLUE-1))))
   )
  port map (     
     rst_pi       => rst_loc,
     clk_pi       => clk_pi ,
     led_value_pi => led_value_b,
     led_po       => led_po(0)
            );
end struct;
