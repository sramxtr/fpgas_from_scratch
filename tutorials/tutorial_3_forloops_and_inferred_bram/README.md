# Intro to For loops and inferred BRAMs

## Companion slide deck
TODO

## Circuit functionality
We will develop a parallel processing circuit that counts the number of unique values in an input stream
- The input data will be stored to and read from an on-chip Block RAM (BRAM).
- The unique value counter circuit will count up to a max number of unique values, as defined by a parameter.
- If the input stream has more unique values than the specified max number of unique values to track, the count of all values not taken into account will be tracked.
  - This count relfects the MAX of remaining unique values, since we won't be looking into the properties of the untracked values.
- The user will make use of one switch on the board to select whether to display the number of tracked unique values, or the number of remaining values.
- The unique value counter is implemented as a deep pipeline, where:
  - Each pipeline stage will track one unique value.
  - The pipeline stage does NOT know what unique value it will be tracking before the data is streamed in.

While we will not accelerate a full application, this tutorial aims to showcase how to potentially accelerate one kernel in a larger application.
Recall that FPGAs are really good at deep custom pipelines.

Similar to [tutorial #1](https://github.com/sramxtr/fpgas_from_scratch/tree/main/tutorials/tutorial_1_intro_and_blink_led) and [tutorial #2](https://github.com/sramxtr/fpgas_from_scratch/tree/main/tutorials/tutorial_2_fsm_and_sim), we will target the Zybo Z7-20 board.
That said, most of this tutorial can be completed in simulation, as described in [tutorial #2](https://github.com/sramxtr/fpgas_from_scratch/tree/main/tutorials/tutorial_2_fsm_and_sim).

## Concepts introduced
Some concepts introduced in this tutorial include:
- For loops in SystemVerilog. The provided source makes use of for loops in several places, namely:
  - To generate pipeline stages for the unique value trackers.
  - To implement a priority encoder that counts the number of unique values.
  - To generate simulation signals.
- On-chip BRAM.
  - Xilinx Vivado provides several mechanisms to instantiate on-chip BRAMS:
    - IP catalog: the user can configure the IP using a UI.
    - Language templates: Xilinx provides the names of the on-chip primitives, and we can instantitate these just as other Verilog/SV/VHDL modules can be instantiated.
    - Inferred BRAMs: we will showcase this approach. Here, we will write SV code that will translate into one or more BRAMs. This approach is often recommended since the code will be to a large extent platform independent.
  - We will also make use of a memory initialization file to set the contents of the BRAM.



