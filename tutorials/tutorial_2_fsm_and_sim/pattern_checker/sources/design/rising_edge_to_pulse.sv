
module rising_edge_to_pulse(
    input logic clk,
    input logic reset,
    input logic data_in,
    output logic data_out
    );
           
    enum {WAIT_FOR_1,
          EMIT_1,
          WAIT_FOR_0} current_state_sig, next_state_sig;
            
    always_comb begin
        // Defaults
        data_out = 0;
        next_state_sig = current_state_sig;
        
        unique case (current_state_sig)
            WAIT_FOR_1:
                if (data_in == 1)
                    next_state_sig = EMIT_1;            
            
            EMIT_1: begin
                data_out = 1;
                next_state_sig = WAIT_FOR_0;
            end // EMIT_1
            
            WAIT_FOR_0:
                if (data_in == 0)
                    next_state_sig = WAIT_FOR_1;                                            
        endcase
    end // always_comb
                        
    always_ff @ (posedge clk) begin
        if (reset == 1)
            current_state_sig <= WAIT_FOR_1;
        else
            current_state_sig <= next_state_sig;
    end // always_ff
    
endmodule
