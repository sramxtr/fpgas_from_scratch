
module debouncer
    #(parameter NUM_COUNTER_BITS = 21)
    (input logic clk,
     input logic data_in,
     output logic data_out);
        
    logic data_ff1_postbuf_sig = 0;
    logic data_ff2_postbuf_sig = 0;
    logic dataout_prebuf_sig, dataout_postbuf_sig = 0;
    logic [NUM_COUNTER_BITS-1:0] counter_prebuf_sig, counter_postbuf_sig = 0;
    
    assign data_out = dataout_postbuf_sig;
    assign counter_prebuf_sig = (data_ff1_postbuf_sig == data_ff2_postbuf_sig) ? counter_postbuf_sig + 1 : 0;
    assign dataout_prebuf_sig = (counter_postbuf_sig == '1) ? data_ff2_postbuf_sig : dataout_postbuf_sig;

    always_ff @ (posedge clk) begin
        data_ff1_postbuf_sig <= data_in;
        data_ff2_postbuf_sig <= data_ff1_postbuf_sig;
        counter_postbuf_sig <= counter_prebuf_sig;
        dataout_postbuf_sig <= dataout_prebuf_sig;
    end // always_ff
    
endmodule
