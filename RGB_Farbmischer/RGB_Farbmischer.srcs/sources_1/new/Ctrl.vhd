----------------------------------------------------------------------------------
-- Entity: Ctrl
-- Company: HSLU
-- Engineer: J.Carlen, M. von Flüe
-- 
-------------------------------------------------------------------------------
-- Description: (ECS Testat 1)
-- FSM(Mealy) for the Encoder for "RGB Farbmischer"
-------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ctrl is

 port (
  rst_pi       : in  std_logic;
  clk_pi       : in  std_logic;
  deb_enc_pi   : in std_logic_vector(1 downto 0);
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
-- Outputs: dim_up, dim_down
-----------------------------------------------------------------------------
-- memoryless process
P_fsm_com : process (c_st, deb_enc_pi)
begin
  -- default assignments
  n_st        <= c_st;      -- remain in current state
  dim_down_po <= '0';
  dim_up_po   <= '0';
  -- specific assignments
  case c_st is
    when s_start =>
      case deb_enc_pi is
        when "00"   => n_st <= s_0;
        when "01"   => n_st <= s_3;
        when "10"   => n_st <= s_1;
        when others => n_st <= s_2;
      end case;
    when s_0 =>
      case deb_enc_pi is
        when "01"   => n_st <= s_3; 
        when "10"   => n_st <= s_1; 
        when others => null;
      end case;
    when s_1 =>
      case deb_enc_pi is
        when "00"   => n_st <= s_0; dim_down_po <= '1';
        when "11"   => n_st <= s_2; 
        when others => null;
      end case;
    when s_2 =>
      case deb_enc_pi is
        when "10"   => n_st <= s_1; 
        when "01"   => n_st <= s_3; 
        when others => null;    
      end case;
    when s_3 =>
      case deb_enc_pi is
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
