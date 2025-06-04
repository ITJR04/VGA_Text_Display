## Clock
set_property PACKAGE_PIN Y9 [get_ports clk_100MHz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100MHz]

## Reset
set_property PACKAGE_PIN P16 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
## VGA Red (4 bits)
set_property PACKAGE_PIN V20 [get_ports {red[0]}]
set_property PACKAGE_PIN U20 [get_ports {red[1]}]
set_property PACKAGE_PIN V19 [get_ports {red[2]}]
set_property PACKAGE_PIN V18 [get_ports {red[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red[*]}]

## VGA Green (4 bits)
set_property PACKAGE_PIN AB22 [get_ports {green[0]}]
set_property PACKAGE_PIN AA22 [get_ports {green[1]}]
set_property PACKAGE_PIN AB21 [get_ports {green[2]}]
set_property PACKAGE_PIN AA21 [get_ports {green[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green[*]}]

## VGA Blue (4 bits)
set_property PACKAGE_PIN Y21 [get_ports {blue[0]}]
set_property PACKAGE_PIN Y20 [get_ports {blue[1]}]
set_property PACKAGE_PIN AB20 [get_ports {blue[2]}]
set_property PACKAGE_PIN AB19 [get_ports {blue[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue[*]}]

## VGA HSync
set_property PACKAGE_PIN AA19 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]

## VGA VSync
set_property PACKAGE_PIN Y19 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]