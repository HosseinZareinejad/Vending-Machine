
# Vending Machine Controller with User and Admin Modes

## Description

This repository contains the Verilog implementation of a Vending Machine Controller, supporting both user and admin modes. The design is built to manage user purchases and admin inventory adjustments efficiently, and it includes various hardware components such as seven-segment displays, LED indicators, debounce circuits, and frequency dividers.

## Features

- **User Mode**: Allows users to select and purchase items from the vending machine.
  - Displays user balance on the seven-segment display.
  - Updates item count and user balance after each purchase.
  - Provides feedback on purchase success or failure.

- **Admin Mode**: Enables administrators to manage the vending machine inventory.
  - Allows admin login with a password.
  - Supports adding or removing items from specific slots using push buttons.
  - Displays item count on LED indicators.

- **Debounce Circuit**: Ensures reliable button press detection.
- **Frequency Divider**: Generates lower frequency clocks from the main 40 MHz clock for various timing needs.
- **Buzzer Alert**: Sounds a buzzer when switching between user and admin modes.

## Modules

1. **Main Module (`main.v`)**
   - Manages the overall operation of the vending machine, switching between user and admin modes.
   - Includes buzzer control for mode switching alerts.
   
2. **User Mode (`user_mode.v`)**
   - Handles user interactions, including item selection and purchase processing.
   - Maintains user balances and updates them after transactions.

3. **Admin Mode (`admin_mode.v`)**
   - Provides functionalities for admin inventory management.
   - Allows item count adjustments and displays current item counts on LEDs.

4. **Debounce (`debounce.v`)**
   - Debounces button inputs to prevent erroneous detections.

5. **Frequency Divider (`freqDivider.v`)**
   - Generates 1 Hz and 2 Hz clocks from the main 40 MHz clock.

6. **BCD to Seven Segment Display (`BCD2SEVEN_SEGMENT.v`)**
   - Converts Binary Coded Decimal (BCD) to seven-segment display format.

7. **Seven Segment Multiplexer (`SEVEN_SEGMENT_MUX.v`)**
   - Manages multiplexing of multiple digits on a seven-segment display.

## File Structure

```
vending-machine-controller/
├── src/
│   ├── main.v
│   ├── user_mode.v
│   ├── admin_mode.v
│   ├── debounce.v
│   ├── freqDivider.v
│   ├── BCD2SEVEN_SEGMENT.v
│   ├── SEVEN_SEGMENT_MUX.v
├── testbench/
│   ├── main_tb.v
├── README.md
├── LICENSE
```

## How to Use

1. **Simulation**: Use your preferred Verilog simulator to test the design.
2. **Synthesis**: Synthesize the design for FPGA implementation using tools like Xilinx ISE or Vivado.
3. **Deployment**: Deploy the synthesized design to an FPGA board and connect the necessary peripherals (buttons, LEDs, seven-segment displays, etc.).

## Getting Started

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/vending-machine-controller.git
   ```
2. Navigate to the `src` directory and run simulations or synthesize the design using your preferred tools.

## Contributions

Contributions are welcome! Please feel free to submit issues, fork the repository, and send pull requests.

