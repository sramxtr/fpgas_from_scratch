
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
    
    typedef enum {WAIT_FOR_START,
                  WAIT_FOR_CODE_1,
                  WAIT_FOR_CODE_2,
                  WAIT_FOR_CODE_3,
                  FAILURE,
                  SUCCESS} state_t;
                  
    state_t current_state_sig, next_state_sig;
    
    task check_code_and_proceed(input logic [3:0] target_code,
                                input logic [3:0] code_in,
                                input logic action_in,
                                input state_t next_success_state,
                                output state_t next_state);                                
        if (action_in == 1)
            if(code_in == target_code)
                next_state = next_success_state;
            else
                next_state = FAILURE;
    endtask
                   
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
                check_code_and_proceed(code_1_sig, code_in, action_in, WAIT_FOR_CODE_2, next_state_sig);
            end // WAIT_FOR_CODE_1
            
            WAIT_FOR_CODE_2: begin
                led_b_out = 1; 
                check_code_and_proceed(code_2_sig, code_in, action_in, WAIT_FOR_CODE_3, next_state_sig);
            end // WAIT_FOR_CODE_2
            
            WAIT_FOR_CODE_3: begin
                led_b_out = 1; 
                check_code_and_proceed(code_3_sig, code_in, action_in, SUCCESS, next_state_sig);           
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