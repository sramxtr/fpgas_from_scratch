# Intro to FSMs and basics of RTL simulation

[Companion slide deck](https://docs.google.com/presentation/d/1BR3s1PMvBg1lSsxFMwqayO-h7mzPWLEm22N1g04FZgM/edit?usp=sharing)

We will develop a circuit that verifies an pattern input by the user.
- The pattern consists of three 4-bit codes, hard-coded in the logic.
- The user will employ four switches on the board and a push button to interact with the pattern checker.
- Similar to [tutorial #1](https://github.com/sramxtr/fpgas_from_scratch/tree/main/tutorials/tutorial_1_intro_and_blink_led), we will target the Zybo Z7-20 board.

The user will initiate the pattern checking by pressing a button.
- While accepting user input, the blue LED will be on.
- The user will change the position of the 4 switches on the board to match the first code. The user will then press a button to ask the pattern checker to verify the first code.
- If the code is correct, the checker will wait for the next code.
- If the code is incorrect, the red LED will be turned on, and pattern checking starts all over again.
    - Repeat step 3 for codes 2 and 3.
- In case of success, the green LED will be turned on, indicating that the input pattern matches the stored pattern/codes.

Some things we will learn in this tutorial:
- Exposure to debouncing, why and how.
    - Also, leverage learnings from tutorial 1 to build a more involved circuit.
- FSM implementation and best practices.
- Simulation basics.
- Module instantiation, aka port mapping.
