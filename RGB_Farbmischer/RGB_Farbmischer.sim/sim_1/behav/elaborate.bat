@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.3\\bin
call %xv_path%/xelab  -wto 92f0c4fb33dd4f879a89c6bdcab35cf7 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot tb_pwm_led_top_behav xil_defaultlib.tb_pwm_led_top -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
