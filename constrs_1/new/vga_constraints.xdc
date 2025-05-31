## RGB output: using 1 MSB bit per color
set_property PACKAGE_PIN V18 [get_ports {rgb[2]}] ; # R4 (Red MSB)
set_property PACKAGE_PIN AA21 [get_ports {rgb[1]}] ; # G4 (Green MSB)
set_property PACKAGE_PIN AB19 [get_ports {rgb[0]}] ; # B4 (Blue MSB)


set_property PACKAGE_PIN AA19 [get_ports {hsync}];  # "VGA-HS"

set_property PACKAGE_PIN Y19  [get_ports {vsync}];  # "VGA-VS"
set_property PACKAGE_PIN T22  [get_ports {led}]; # "LD0"
set_property PACKAGE_PIN Y9 [get_ports clk]; # Board Clock

## Pushbutton reset input (BTN0)
set_property PACKAGE_PIN T18 [get_ports reset];
# IOSTANDARDS
set_property IOSTANDARD LVCMOS33 [get_ports {reset}];
set_property IOSTANDARD LVCMOS33 [get_ports {clk}];
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[*]}];
set_property IOSTANDARD LVCMOS33 [get_ports {hsync}];
set_property IOSTANDARD LVCMOS33 [get_ports {vsync}];
set_property IOSTANDARD LVCMOS33 [get_ports reset];
set_property IOSTANDARD LVCMOS33 [get_ports led];