🖥️ VGA Text Display on ZedBoard Zynq-7000

This project implements a simple VGA text terminal in VHDL on the ZedBoard Zynq-7000. It displays the static message "HELLO FPGA" centered on a VGA monitor using 640×480 resolution at 60 Hz. The design consists of a VGA sync generator, font ROM, character buffer, and a text renderer module. A 25 MHz pixel clock is derived from the ZedBoard's 100 MHz system clock using a Clocking Wizard IP.

---

📦 Project Details

Top Module: vga_text_top

Clock Input: 100 MHz onboard oscillator

Pixel Clock: 25 MHz from Clock Wizard (MMCM IP)

Text Output: "HELLO FPGA" (white text on black background)

Video Output: VGA (RGB + HSYNC, VSYNC)

Reset Pin: SW5 (H18)

Design Goal: Demonstrate text rendering using ROMs, VGA sync timing, and VHDL modules

---

🛠️ Tools Used

Vivado Design Suite (Vivado 2024.2)

Clocking Wizard IP (MMCM for VGA pixel clock)

VHDL for all logic components

VGA monitor and cable (tested on AOC C27G1 @ 640x480 VGA input)

Optional: Simulation with Vivado Simulator or GTKWave

---

🧠 Design Overview

The system is composed of:

Clocking Wizard

Converts 100 MHz to 25 MHz for VGA timing

"Locked" output connects to LED for debug

VGA Sync Generator (VGA_sync_gen)

Generates HSYNC, VSYNC, hcount, vcount, and video_on signal

Strictly follows 640×480 @ 60 Hz VGA timing

Font ROM (font_rom)

Outputs 8-bit wide font glyphs for each ASCII row

Contains predefined pixel map for common characters

Character ROM (char_rom)

80×60 buffer filled with the message "HELLO FPGA"

Static content for display (not writable)

Text Renderer (text_renderer)

Takes character position, accesses font ROM and char ROM

Outputs 3-bit RGB video signal

White-on-black color scheme

---

⚠️ Known Issues and Troubleshooting

Black Screen or No Signal

Ensure clock wizard is generating 25 MHz

Check if LD0 is ON (locked signal)

Verify monitor is set to VGA input, 640x480 @ 60Hz

Cut-off or Misaligned Text

This was observed with some VGA monitors

You can vertically offset the row address in char_rom to better center the message

Text Fuzzy or Scaled

Use monitor settings to enable 1:1 or original scale (not full-screen stretched)

---

🔌 Build and Program Steps in Vivado

1. Open the Project

Launch Vivado

Create a new RTL project

Add all provided .vhd source files and vga_constraints.xdc

2. Add IP

Add a Clocking Wizard IP to generate a 25 MHz clock from 100 MHz input

Enable locked output for debug

3. Run Synthesis and Implementation

Click Run Synthesis

Click Run Implementation

Verify timing report passes for 25 MHz pixel clock

4. Generate Bitstream

Click Generate Bitstream

5. Program the FPGA

Connect ZedBoard via JTAG

Go to Open Hardware Manager > Open Target > Auto Connect

Click Program Device and select the .bit file

6. Observe Output

Connect a VGA monitor

Set to VGA input (640×480)

You should see the message HELLO FPGA in the center

LD0 LED should be ON (clock lock confirmed)

---

✅ Outcome

This project reinforces:

VGA signal generation

Use of ROMs and rendering logic in hardware

Clock domain handling via MMCM

Hands-on FPGA timing and design flow
