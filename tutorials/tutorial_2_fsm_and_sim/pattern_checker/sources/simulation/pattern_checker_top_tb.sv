`timescale 1ns / 1ps

module patter_checker_top_tb();


logic clk_sig = 0;
logic reset_sig = 0, action_in_sig = 0;
logic [3:0] code_in_sig = 0;
logic led_r_out_sig, led_g_out_sig, led_b_out_sig;

always #0.5 clk_sig <= ~clk_sig;

initial begin
    reset_sig = 0; #10
    reset_sig = 1; #10
    reset_sig = 0; #100
    action_in_sig = 1; #50
    action_in_sig = 0; #100
    $finish;

end // initial


pattern_checker_top 
    #(.NUM_DEBOUNCER_COUNTER_BITS(3)) UUT
    (.clk(clk_sig),
    .reset(reset_sig),
    .action_in(action_in_sig),
    .code_in(code_in_sig),
    .led_r_out(led_r_out_sig),
    .led_g_out(led_g_out_sig),
    .led_b_out(led_b_out_sig)
    );
endmodule
