`timescale 1ns / 1ps


module pattern_checker_tb();

    logic clk_sig = 0;
    logic reset_sig = 0, action_in_sig = 0, led_r_out_sig, led_g_out_sig, led_b_out_sig;
    logic [3:0] code_in_sig = 0;
    logic [2:0] state_out_sig;
    
    // Note that codes are localparam inside the pattern checker
    // As such, they are not exposed outside of the pattern checker
    localparam [3:0] code_1_sig = 4'b0101;
    localparam [3:0] code_2_sig = 4'b1000;
    localparam [3:0] code_3_sig = 4'b0001;
    localparam [3:0] wrong_code_sig = 4'b1110; // Random code that doesn't match any of the other codes   

    always #0.5 clk_sig = ~clk_sig;
    
    initial begin

        // Reset cycle
        reset_sig = 0; #5
        reset_sig = 1; #10
        reset_sig = 0; #3
        
        // First code is wrong    
        action_in_sig = 1; #1 // go to the state that accepts the first code
        assert(led_b_out_sig == 1) else $error("We should be accpeting codes at this point");
        code_in_sig = wrong_code_sig;
        action_in_sig = 1; #1 // check the input code against code_1
        assert(led_r_out_sig == 1) else $error("red led not on though first code is wrong");
        
        // Second code is wrong
        action_in_sig = 1; #1 // go back to the first state
        action_in_sig = 1; #1 // go to the state that accepts the first code
        code_in_sig = code_1_sig;
        action_in_sig = 1; #1 // check the input code against code_1
        assert(led_r_out_sig == 0) else $error("code_1 was correct, but the red led is on");
        code_in_sig = wrong_code_sig;
        action_in_sig = 1; #1 // check the input code against code_2
        assert(led_r_out_sig == 1) else $error("code_2 was incorrect, yet the red led is off");
                                     
        // All codes are correct
        action_in_sig = 1; #1 // go back to the first state
        action_in_sig = 1; #1 // go to the state that accepts the first code
        code_in_sig = code_1_sig;
        action_in_sig = 1; #1 // check the input code against code_1
        code_in_sig = code_2_sig;
        action_in_sig = 1; #1 // check the input code against code_2
        code_in_sig = code_3_sig;
        action_in_sig = 1; #1 // check the input code against code_3
        assert(led_g_out_sig == 1) else $error("All input codes were correct.. not sure why the green led is off");
    
        $finish;
    end // initial

    pattern_checker UUT
                    (.clk(clk_sig),
                     .reset(reset_sig),
                     .action_in(action_in_sig),
                     .code_in(code_in_sig),
                     .led_r_out(led_r_out_sig),
                     .led_g_out(led_g_out_sig),
                     .led_b_out(led_b_out_sig),
                     .state_out(state_out_sig));

endmodule
