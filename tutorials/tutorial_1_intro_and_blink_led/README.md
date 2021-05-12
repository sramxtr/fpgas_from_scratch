# Intro to FPGAs, and run the hello world of FPGAs

[Companion slide deck](https://docs.google.com/presentation/d/1lM-U3ZMaYtRzeUI60obD4WXKAqraGWCCLOH11imBH4k/edit?usp=sharing)

Learn about why FPGAs came to be, what they are internally, and what the dev flow looks like.
Then, develop, build and run your first FPGA program. The typical hello world of FPGAs is blinking an LED.

- Note that the constraints file targets the Zybo Z7-20 platform.
- Language used: SystemVerilog.

Three designs are available here:
- Button to LED: push a button, and see the LED light up.
- Counter to LED: display a counter using 4 LEDs.
- Controllable counter to LED: same as previous design, except that the counter can now be enabled/disabled using a switch, and can be reset using a button.