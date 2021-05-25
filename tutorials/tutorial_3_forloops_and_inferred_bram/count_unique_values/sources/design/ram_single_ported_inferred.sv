`timescale 1ns / 1ps

module ram_single_ported_inferred
       #(parameter NUM_WORD_BITS = 32,
         parameter NUM_WORDS = 1024,
         parameter INIT_FILE = "")
       (input logic clk,
        input logic write_enable_in,
        input logic [$clog2(NUM_WORDS)-1:0] address_in,
        input logic [NUM_WORD_BITS-1:0] data_in,
        output logic [NUM_WORD_BITS-1:0] data_out);
        
    logic [NUM_WORD_BITS-1:0] memory_sig [NUM_WORDS-1:0];
    
    initial begin
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, memory_sig);
    end // initial
    
    always_ff @ (posedge clk) begin
        if (write_enable_in)
            memory_sig[address_in] <= data_in;
        data_out <= memory_sig[address_in];
    end // always
        
endmodule
