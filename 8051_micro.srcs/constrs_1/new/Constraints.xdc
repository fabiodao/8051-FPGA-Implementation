set_property IOSTANDARD LVCMOS33 [get_ports reset]

set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports clock]
create_clock -period 20.000 -name sys_clk_pin -waveform {0.000 10.000} -add [get_ports clock]

set_property PACKAGE_PIN Y16 [get_ports reset]

set_property IOSTANDARD LVCMOS33 [get_ports {PORT1_o[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PORT1_o[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PORT1_o[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PORT1_o[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PORT1_o[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PORT1_o[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PORT1_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PORT1_o[0]}]
set_property PACKAGE_PIN M14 [get_ports {PORT1_o[0]}]
set_property PACKAGE_PIN M15 [get_ports {PORT1_o[1]}]
set_property PACKAGE_PIN G14 [get_ports {PORT1_o[2]}]
set_property PACKAGE_PIN D18 [get_ports {PORT1_o[3]}]
set_property PACKAGE_PIN H15 [get_ports {PORT1_o[4]}]
set_property PACKAGE_PIN J15 [get_ports {PORT1_o[5]}]
set_property PACKAGE_PIN W16 [get_ports {PORT1_o[6]}]
set_property PACKAGE_PIN V12 [get_ports {PORT1_o[7]}]
set_property PULLDOWN true [get_ports {PORT1_o[7]}]
set_property PULLDOWN true [get_ports {PORT1_o[6]}]
set_property PULLDOWN true [get_ports {PORT1_o[5]}]
set_property PULLDOWN true [get_ports {PORT1_o[4]}]





connect_debug_port u_ila_0/probe1 [get_nets [list EI0_i_IBUF]]

set_property PACKAGE_PIN K19 [get_ports pb_1]
set_property IOSTANDARD LVCMOS33 [get_ports pb_1]



