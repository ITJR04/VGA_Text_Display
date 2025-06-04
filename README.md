VGA Text Terminal Character Display on ZedBoard (Zynq-7000)

This project implements a VGA-compatible text terminal on the ZedBoard Zynq-7000 FPGA platform. Text is rendered directly on a VGA monitor at 640x480 resolution using a custom pixel font and sync generator written in VHDL. The design is modular, reusable, and extensible.

---

# 🧠 Project Summary

Top-Level Design: VGA_Text_Top.vhd

Resolution: 640x480 @ 60 Hz

Clock: 25 MHz (generated from 100 MHz ZedBoard clock via Clocking Wizard)

Font: 8x16 pixel grid, supports ASCII 0–127

Platform: Digilent ZedBoard (Zynq-7000 SoC)

Tools: Vivado 2024.2 Webpack

---

📂 Directory Contents

File Description

CommonPackage.vhd

Package containing shared constants like font width/height and custom types like point_2d.

Font_ROM.vhd

8x16 font ROM for ASCII characters (0–127), returns 8-bit row bitmap per address.

Pixel_On_Text.vhd

Determines whether a VGA pixel is inside the shape of any displayed character.

Full_Wrapper.vhd

Instantiates multiple Pixel_On_Text modules to place multiple hardcoded text lines on screen.

vga_sync.vhd

Generates horizontal and vertical sync, video enable, and pixel coordinates for 640x480 VGA display.

VGA_Text_Top.vhd

Top-level VHDL file wiring together the clock, VGA sync, and text rendering modules.

clocking_wizard.xci

IP configuration for generating 25 MHz clock using Xilinx Clocking Wizard.

VGA_Text_constraints.xdc

XDC constraints for pin assignment (VGA signals, clock) for ZedBoard.

---

🖼️ Output Demo

![VGA_Text_Display_Output](https://github.com/user-attachments/assets/eb43e76b-afbb-4f68-a728-d3858fb026e5)



The monitor displays multiple strings placed at various positions on screen. Each string is rendered using the 8x16 ASCII font.

---

🔧 How It Works

1. Font Storage

Font_ROM stores the bitmap for each ASCII character.

Each character is 8 pixels wide by 16 pixels tall.

The address is calculated as: font_address = (char_ascii * 16) + row_offset

2. Pixel Detection

Pixel_On_Text accepts:

displayText: a fixed string to draw

position: top-left anchor of the string

horzCoord, vertCoord: current pixel from VGA sync

The module determines if the current pixel lies within the active character grid.

If so, it outputs pixel = '1'.

3. Text Composition

Full_Wrapper instantiates several Pixel_On_Text modules to place multiple text strings.

These outputs are ORed together.

4. Sync Generation

vga_sync generates:

Pixel position counters hcount, vcount

Horizontal and vertical sync pulses

video_on signal to mask drawing outside visible area

5. Top-Level System

VGA_Text_Top ties everything together:

Instantiates a Clock Wizard to downscale clock to 25 MHz

Generates sync signals

Sends sync + coordinates to wrapper

---

⏱️ Timing Details (VGA 640x480 @ 60 Hz)

Parameter

Value

Pixel Clock

25 MHz

Horizontal Pixels

800 (640 active + 160 blanking)

Vertical Pixels

525 (480 active + 45 blanking)

---

🚀 Getting Started

1. Clone and Open in Vivado

git clone https://github.com/YOUR_USERNAME/VGA_Text_Terminal_Display.git

Open the project or create a new one and add the following sources:

All .vhd files

clocking_wizard.xci

VGA_Text_constraints.xdc

2. Generate Clock IP

Use Vivado IP Integrator to generate a 25 MHz clock via Clocking Wizard.

3. Assign Pins in Constraints File

Make sure your VGA_Text_constraints.xdc matches your VGA PMOD or onboard VGA output.

4. Synthesize, Implement, and Program

After synthesis and implementation, program the bitstream to your ZedBoard. You should see the test strings appear on your connected VGA monitor.

---

📜 Credits

This project was inspired by Derek-X-Wang/VGA-Text-Generator. The idea of checking pixel positions against character bitmaps and rendering text via coordinate logic comes from that repository.

Special thanks to:

Derek Wang for the original font rendering concept.

MadLittleMods/FP-VGA-Text for the base ASCII font and rendering structure.

---

📘 License

This project is licensed under the MIT License.
See the LICENSE file for details.

---

📬 Contact

For questions, suggestions, or collaborations, contact:
Isai Torres – GitHub Profile
