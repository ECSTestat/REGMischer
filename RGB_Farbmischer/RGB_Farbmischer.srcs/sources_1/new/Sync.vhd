-------------------------------------------------------------------------------
-- Entity: Sync
-- Author: von Flüe
-------------------------------------------------------------------------------
-- Description: (ECS Testat 1)
-- Synchronization and Debouncing for "RGB Farbmischer"
-------------------------------------------------------------------------------
-- Total # of FFs: 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Sync is
  generic(
    CLK_FRQ : integer := 125_000_000 -- 125 MHz
    );
  port(
  rst_pi       : in  std_logic;
  clk_pi       : in  std_logic;
  enc_pi       : in  std_logic_vector(1 downto 0);                    
  deb_enc_po   : out std_logic_vector(1 downto 0);
  act_pi       : in  std_logic_vector(2 downto 0);
  act_sync_po  : out std_logic_vector(2 downto 0)
    );
end Sync;

architecture rtl of Sync is
  --Consants
  constant c_blank_time_10  : unsigned(20 downto 0) := to_unsigned(CLK_FRQ/100-1, 21);

  -- synchronization signals
  signal enca_reg : std_logic_vector(1 downto 0); 
  signal encb_reg : std_logic_vector(1 downto 0); 
  signal enc_synca  : std_logic;   
  signal enc_syncb  : std_logic;   
  signal actsw0_reg  : std_logic_vector(1 downto 0); 
  signal actsw1_reg  : std_logic_vector(1 downto 0);
  signal actsw2_reg  : std_logic_vector(1 downto 0);  
  signal enca_cnt, encb_cnt       : unsigned(20 downto 0);
  signal debncd_enca, debncd_encb : std_logic; 

begin

  -- output assignments
  enc_synca   <= enca_reg(1);
  enc_syncb   <= encb_reg(1);
  act_sync_po(0)   <= actsw0_reg(1);  
  act_sync_po(1)   <= actsw1_reg(1); 
  act_sync_po(2)   <= actsw2_reg(1);       
  
  ----------------------------------------------------------------------------- 
  -- sequential process: synchronization
  -- All switch inputs and encoder are synchronized. The SW input is assumed to be a
  -- constant (vector) input.
  -- # of FF: 
  ----------------------------------------------------------------------------- 
  P_syn: process(rst_pi, clk_pi)
  begin
    if rst_pi = '1' then
      enca_reg <= (others => '0');
      encb_reg  <= (others => '0');
      actsw0_reg <= (others => '0');
      actsw1_reg <= (others => '0');
      actsw2_reg <= (others => '0');
    elsif rising_edge(clk_pi) then
      -- synchronization of the encoder A
      enca_reg(0) <= enc_pi(0);
      enca_reg(1) <= enca_reg(0);
      -- synchronization of the encoder B
      encb_reg(0) <= enc_pi(1);
      encb_reg(1) <= encb_reg(0);
      -- synchronization of switch 0
      actsw0_reg(0) <= act_pi(0);
      actsw0_reg(1) <= actsw0_reg(0);
      -- synchronization of switch 1
      actsw1_reg(0) <= act_pi(1);
      actsw1_reg(1) <= actsw1_reg(0);
      -- synchronization of switch 2
      actsw2_reg(0) <= act_pi(2);
      actsw2_reg(1) <= actsw2_reg(0);
    end if;
  end process;
  
P_deb_enc : process(rst_pi, clk_pi)
  begin
        if rst_pi = '1' then
        enca_cnt <= (others => '0');
        encb_cnt <= (others => '0');
        debncd_enca <= '0';
        debncd_encb <= '0';
        deb_enc_po  <= (others => '0');
        
        elsif rising_edge(clk_pi) then
        --Debounce ENC_A (blanking)----------------------
        if enca_cnt = 0 and enc_synca /=  debncd_enca then
        --input changed_ start blank time counter-------------
            enca_cnt <= enca_cnt + 1;
            debncd_enca <= enc_synca;
        elsif enca_cnt > 0 and enca_cnt < c_blank_time_10 then
        --blank time counter active--------------------
            enca_cnt <= enca_cnt +1;
        else
        --end of blank time: reset counter----------
            enca_cnt <= (others => '0');
        end if;
       --Debounce ENC_B (blanking)----------------------
        if encb_cnt = 0 and enc_syncb /=  debncd_encb then
            encb_cnt <= encb_cnt + 1;
            debncd_encb <= enc_syncb;
        elsif encb_cnt > 0 and encb_cnt < c_blank_time_10 then
            encb_cnt <= encb_cnt +1;
        else
            encb_cnt <= (others => '0');
        end if;
        deb_enc_po <= debncd_enca & debncd_encb;
     end if;   
  end process;
  
end rtl;