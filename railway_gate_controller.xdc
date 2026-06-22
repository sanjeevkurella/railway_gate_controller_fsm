# Clock
set_property PACKAGE_PIN N11 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

create_clock -period 10.000 -name sys_clk [get_ports clk]

# Reset Button
set_property PACKAGE_PIN K13 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# Inputs
set_property PACKAGE_PIN L5 [get_ports train_detected]
set_property IOSTANDARD LVCMOS33 [get_ports train_detected]

set_property PACKAGE_PIN L4 [get_ports train_passed]
set_property IOSTANDARD LVCMOS33 [get_ports train_passed]

set_property PACKAGE_PIN M4 [get_ports obstruction]
set_property IOSTANDARD LVCMOS33 [get_ports obstruction]

# Outputs
set_property PACKAGE_PIN P6 [get_ports gate_down]
set_property IOSTANDARD LVCMOS33 [get_ports gate_down]

set_property PACKAGE_PIN T5 [get_ports warning_light]
set_property IOSTANDARD LVCMOS33 [get_ports warning_light]

set_property PACKAGE_PIN T9 [get_ports buzzer]
set_property IOSTANDARD LVCMOS33 [get_ports buzzer]

# Digit enables
set_property -dict { PACKAGE_PIN F2 IOSTANDARD LVCMOS33 } [get_ports {digit[0]}]
set_property -dict { PACKAGE_PIN E1 IOSTANDARD LVCMOS33 } [get_ports {digit[1]}]
set_property -dict { PACKAGE_PIN G5 IOSTANDARD LVCMOS33 } [get_ports {digit[2]}]
set_property -dict { PACKAGE_PIN G4 IOSTANDARD LVCMOS33 } [get_ports {digit[3]}]

# Seven segment outputs
set_property -dict { PACKAGE_PIN G2 IOSTANDARD LVCMOS33 } [get_ports {Seven_Seg[0]}]
set_property -dict { PACKAGE_PIN G1 IOSTANDARD LVCMOS33 } [get_ports {Seven_Seg[1]}]
set_property -dict { PACKAGE_PIN H5 IOSTANDARD LVCMOS33 } [get_ports {Seven_Seg[2]}]
set_property -dict { PACKAGE_PIN H4 IOSTANDARD LVCMOS33 } [get_ports {Seven_Seg[3]}]
set_property -dict { PACKAGE_PIN J5 IOSTANDARD LVCMOS33 } [get_ports {Seven_Seg[4]}]
set_property -dict { PACKAGE_PIN J4 IOSTANDARD LVCMOS33 } [get_ports {Seven_Seg[5]}]
set_property -dict { PACKAGE_PIN H2 IOSTANDARD LVCMOS33 } [get_ports {Seven_Seg[6]}]
set_property -dict { PACKAGE_PIN H1 IOSTANDARD LVCMOS33 } [get_ports {Seven_Seg[7]}]
