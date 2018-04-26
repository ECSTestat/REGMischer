################################################################
# Project: ECS_RGB_Farbmischer
# Entity : RGB_Farbmischer.vhd
# Author : JC, MvF
################################################################
#Comment
################################################################
# Physical Constraints
################################################################

# Clock & Reset
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports clk_pi]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports rst_pi]        

# Inputs
set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33} [get_ports {enc_pi[0]}]  ## Encoder A  
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports {enc_pi[1]}]  ## Encoder B     
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports act_pi[0]] ## Switch 0
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports act_pi[1]] ## Switch 1 
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports act_pi[2]] ## Switch 2


# Outputs
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {led_po[0]}]  ## LED Blue
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {led_po[1]}]  ## LED Green
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports {led_po[2]}]  ## LED Red


################################################################
# Timing Constraints
################################################################

# Clock signal
create_clock -period 8.000 -name sys_clk -waveform {0.000 4.000} -add [get_ports clk_pi]

