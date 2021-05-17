`timescale 1ns / 1ps

module rising_edge_to_pulse_tb();

    logic clk_sig = 0;
    logic reset_sig = 0;
    logic data_in_sig = 0, data_out_sig;

    always #0.5 clk_sig = ~clk_sig;
    
    initial begin
        reset_sig = 0; #3
        reset_sig = 1; #5
        reset_sig = 0; #5
        data_in_sig = 1; #10
        data_in_sig = 0; #10
        data_in_sig = 1; #1
        data_in_sig = 0; #10        
        $finish;
    end // initial 

    rising_edge_to_pulse UUT (.clk(clk_sig),
                              .reset(reset_sig),
                              .data_in(data_in_sig),
                              .data_out(data_out_sig));
endmodule
