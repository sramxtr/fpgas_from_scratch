`timescale 1ns / 1ps

module wrapper_tb();

    localparam NUM_MAX_TRACKED_VALUES = 8;
    localparam NUM_RAM_WORDS = 19;

    logic clk_sig = 0;
    logic reset_sig;
    logic unique_or_untracked_select_sig;
    logic [$clog2(NUM_MAX_TRACKED_VALUES+1)-1:0] counter_out_sig;

    always #0.5 clk_sig <= ~clk_sig;
    
    initial begin
        unique_or_untracked_select_sig = 0; // Start by selecting the unique count for the ouput
        reset_sig = 0; #10
        reset_sig = 1; #20
        reset_sig = 0; #100
        unique_or_untracked_select_sig = 1; // display the number of ignored data words
        #100
        
        $finish;
    
    end //initial

    wrapper
        #(.NUM_DATA_BITS(32),
          .NUM_MAX_TRACKED_VALUES(NUM_MAX_TRACKED_VALUES),
          .NUM_RAM_WORDS(NUM_RAM_WORDS),
          .RAM_INIT_FILE("C:/roger/mem_init_files/hex_init_32x18.txt")) wrapper_inst
        (.clk(clk_sig),
         .reset(reset_sig),
         .unique_or_untracked_select_in(unique_or_untracked_select_sig),
         .counter_out(counter_out_sig));  

endmodule
