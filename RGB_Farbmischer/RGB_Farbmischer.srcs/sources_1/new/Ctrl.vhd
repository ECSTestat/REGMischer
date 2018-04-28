----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2018 14:37:46
-- Design Name: 
-- Module Name: Ctrl - Behavioral
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

entity Ctrl is

 port (
  rst_pi       : in  std_logic;
  clk_pi       : in  std_logic;
  enc_sync_pi  : in std_logic_vector(1 downto 0);
  dim_down_po  : out std_logic;
  dim_up_po    : out std_logic
  );
end Ctrl;

architecture rtl of Ctrl is
--FSM state
  type   state is (s_0, s_1, s_2, s_3, s_start);
  signal c_st, n_st : state;
begin

  -----------------------------------------------------------------------------
-- FSM: Mealy-type
-- Inputs : deb_enc
-- Outputs: enc_rot
-----------------------------------------------------------------------------
-- memoryless process
P_fsm_com : process (c_st, enc_sync_pi)
begin
  -- default assignments
  n_st    <= c_st;      -- remain in current state
  dim_down_po <= '0';
  dim_up_po <= '0';
  -- specific assignments
  case c_st is
    when s_start =>
      case enc_sync_pi is
        when "00"   => n_st <= s_0;
        when "01"   => n_st <= s_3;
        when "10"   => n_st <= s_1;
        when others => n_st <= s_2;
      end case;
    when s_0 =>
      case enc_sync_pi is
        when "01"   => n_st <= s_3; 
        when "10"   => n_st <= s_1; 
        when others => null;
      end case;
    when s_1 =>
      case enc_sync_pi is
        when "00"   => n_st <= s_0; dim_down_po <= '1';
        when "11"   => n_st <= s_2; 
        when others => null;
      end case;
    when s_2 =>
      case enc_sync_pi is
        when "10"   => n_st <= s_1; 
        when "01"   => n_st <= s_3; 
        when others => null;
      end case;
    when s_3 =>
      case enc_sync_pi is
        when "11"   => n_st <= s_2; 
        when "00"   => n_st <= s_0; dim_up_po <= '1';
        when others => null;
      end case;        
    when others =>
      n_st <= s_start; -- handle parasitic states
  end case;
end process;
----------------------------------------------------------------------------- 
-- FSM memorizing process
-- # of FFs: 3 (assuming binary state encoding)
-----------------------------------------------------------------------------
P_fsm_seq : process(rst_pi, clk_pi)
begin
  if rst_pi = '1' then
    c_st <= s_start;
  elsif rising_edge(clk_pi) then
    c_st <= n_st;
  end if;
end process;

end rtl;
