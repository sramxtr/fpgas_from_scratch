
module pattern_checker(
    input logic clk,
    input logic reset,
    input logic action_in,
    input logic [3:0] code_in,
    output logic led_r_out,
    output logic led_g_out,
    output logic led_b_out
    );
    
    localparam [3:0] code_1_sig = 4'b0101;
    localparam [3:0] code_2_sig = 4'b1000;
    localparam [3:0] code_3_sig = 4'b0001;    
    
    enum {WAIT_FOR_START,
          WAIT_FOR_CODE_1,
          WAIT_FOR_CODE_2,
          WAIT_FOR_CODE_3,
          FAILURE,
          SUCCESS} current_state_sig, next_state_sig;
                   
    always_comb begin
        // Defaults
        next_state_sig = current_state_sig;
        led_r_out = 0;
        led_g_out = 0;
        led_b_out = 0;
        
        unique case (current_state_sig)
            WAIT_FOR_START:
                if (action_in == 1)
                    next_state_sig = WAIT_FOR_CODE_1;
            
            WAIT_FOR_CODE_1: begin
                led_b_out = 1; 
                if (action_in == 1)
                    if(code_in == code_1_sig)
                        next_state_sig = WAIT_FOR_CODE_2;
                    else
                        next_state_sig = FAILURE;
            end // WAIT_FOR_CODE_1
            
            WAIT_FOR_CODE_2: begin
                led_b_out = 1; 
                if (action_in == 1)
                    if (code_in == code_2_sig)
                        next_state_sig = WAIT_FOR_CODE_3;
                    else
                        next_state_sig = FAILURE;
            end // WAIT_FOR_CODE_2
            
            WAIT_FOR_CODE_3: begin
                led_b_out = 1; 
                if (action_in == 1)
                    if (code_in == code_3_sig)
                        next_state_sig = SUCCESS;
                    else
                        next_state_sig = FAILURE;           
            end // WAIT_FOR_CODE_3
            
            FAILURE: begin
                led_r_out = 1;
                if(action_in == 1)
                    next_state_sig = WAIT_FOR_START;
                end // FAILURE
            
            SUCCESS: begin
                led_g_out = 1;
                if(action_in == 1)
                    next_state_sig = WAIT_FOR_START;
            end // SUCCESS        
        endcase 
     end
    
    always_ff @ (posedge clk) begin
        if (reset == 1)
            current_state_sig = WAIT_FOR_START;
        else
            current_state_sig = next_state_sig;
    end // always_ff
endmodule