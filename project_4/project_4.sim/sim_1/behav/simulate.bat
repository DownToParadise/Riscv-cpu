@echo off
set xv_path=D:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim tb_riscv_behav -key {Behavioral:sim_1:Functional:tb_riscv} -tclbatch tb_riscv.tcl -view E:/Pool_Birds/Project_of_vivado/project_4/tb_riscv_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
