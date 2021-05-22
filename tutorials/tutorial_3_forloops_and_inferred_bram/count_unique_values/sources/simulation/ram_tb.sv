`timescale 1ns / 1ps

module ram_tb();

    localparam NUM_WORD_BITS = 32;
    localparam NUM_WORDS = 1024;

    logic clk_sig = 0;
    logic write_enable_in_sig = 0;
    logic [$clog2(NUM_WORDS)-1:0] address_in_sig = 0;
    logic [NUM_WORD_BITS-1:0] data_in_sig = 0, data_out_sig;
    
    always #0.5 clk_sig <= ~clk_sig;
    
    initial begin
        address_in_sig = 0; #5
        for (int ii=0; ii<17; ii++) begin
            #1 address_in_sig = ii;
        end // for
        
        #50    
        
        $finish;   
    end // initial

    ram_single_ported_inferred 
       #(.NUM_WORD_BITS(NUM_WORD_BITS),
         .NUM_WORDS(NUM_WORDS),
         .INIT_FILE("C:/roger/mem_init_files/hex_init_32x18.txt")) ram_inst
       (.clk(clk_sig),
        .write_enable_in(write_enable_in_sig),
        .address_in(address_in_sig),
        .data_in(data_in_sig),
        .data_out(data_out_sig));

endmodule
