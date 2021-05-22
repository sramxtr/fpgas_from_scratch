# fpgas_from_scratch
Learn how to program FPGAs, starting from .. relatively scratch

This goal of this repo is to introduce FPGAs to anyone who's interested to learn about and program FPGAs.
We will slowly work our way up, and these tutorials assume no familiarity with FPGA programming, but basic software programming knowledge is recommended.

Available tutorials:
- [tutorial #1](https://github.com/sramxtr/fpgas_from_scratch/tree/main/tutorials/tutorial_1_intro_and_blink_led): Intro to FPGAs, program the FPGA using Vivado to blink an LED
- [tutorial #2](https://github.com/sramxtr/fpgas_from_scratch/tree/main/tutorials/tutorial_2_fsm_and_sim): Verilog/SystemVerilog tutorial, develop a debouncer and an FSM to implement a pattern checker
- [tutorial #3](https://github.com/sramxtr/fpgas_from_scratch/tree/main/tutorials/tutorial_3_forloops_and_inferred_bram): Acceleration example -- count unique values. Intro to For loops, and inferred Block RAMs (on-chip memory)

Future tutorials:
- HW/SW co-design using the Zynq: blink a LED from the ARM
- Using the HDMI port from hardware to display images/patterns on a monitor
  - This tutorial can be extended to implement the game of Pong (typical FPGA project)