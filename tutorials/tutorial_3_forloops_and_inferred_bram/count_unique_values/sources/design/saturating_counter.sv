`timescale 1ns / 1ps

module saturating_counter
    #(parameter MAX_VALUE = 32)
    (input logic clk,
     input logic reset,
     input logic enable_in,
     output logic [$clog2(MAX_VALUE):0] count_out);
     
     logic [$clog2(MAX_VALUE):0] count_prebuf_sig, count_postbuf_sig = 0;
     
     assign count_out = count_postbuf_sig;
     
     always_comb begin
        count_prebuf_sig = count_postbuf_sig;
        if (enable_in == 1)
            if (count_postbuf_sig < MAX_VALUE)
                count_prebuf_sig = count_postbuf_sig + 1;                
     end // always_comb
     
     always_ff @ (posedge clk) begin
        if (reset == 1)
            count_postbuf_sig <= 0;
        else
            count_postbuf_sig <= count_prebuf_sig;
     end // always_ff
endmodule
