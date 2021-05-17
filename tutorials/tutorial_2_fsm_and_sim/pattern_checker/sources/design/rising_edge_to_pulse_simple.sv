

module rising_edge_to_pulse_simple(
    input logic clk,
    input logic reset,
    input logic data_in,
    output logic data_out
    );
         
    logic data_in_postbuf_sig = 0;
    assign data_out = ~data_in_postbuf_sig & data_in;
    
    always_ff @ (posedge clk) begin
        data_in_postbuf_sig <= data_in;    
    end // always_ff     
      
endmodule