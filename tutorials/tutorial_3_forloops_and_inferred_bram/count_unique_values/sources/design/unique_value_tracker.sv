
module unique_value_tracker
       #(parameter NUM_DATA_BITS = 32,
         parameter NUM_MAX_TRACKED_VALUES = 8)
       (input logic clk,
        input logic reset_in,
        input logic valid_in,
        input logic [NUM_DATA_BITS-1:0] data_in,
        output logic valid_out,
        output logic [$clog2(NUM_MAX_TRACKED_VALUES):0] num_unique_values_out); 
        
       
    localparam NUM_STAGES = NUM_MAX_TRACKED_VALUES;    
    logic [NUM_DATA_BITS-1:0] data_staged_sig [NUM_STAGES:0];
    logic [NUM_STAGES:0] reset_staged_sig, valid_staged_sig;
    logic [NUM_STAGES-1:0] is_tracking_sig;
    
    assign reset_staged_sig[0] = reset_in; 
    assign data_staged_sig[0] = data_in;
    assign valid_staged_sig[0] = valid_in;  
    assign valid_out = valid_staged_sig[NUM_STAGES];     
    
    genvar ii;
    generate
        for (ii=1; ii <= NUM_STAGES; ii++) begin
            unique_value_tracker_stage #(.NUM_DATA_BITS(NUM_DATA_BITS)) tracker_stage_inst
                                       (.clk(clk),
                                        .reset_in(reset_staged_sig[ii-1]),
                                        .valid_in(valid_staged_sig[ii-1]),
                                        .data_in(data_staged_sig[ii-1]),
                                        .reset_out(reset_staged_sig[ii]),
                                        .valid_out(valid_staged_sig[ii]),
                                        .data_out(data_staged_sig[ii]),
                                        .is_tracking_unique_value_out(is_tracking_sig[ii-1]));  
        end // for
    endgenerate
    
    priority_encoder #(.NUM_DATA_BITS(NUM_STAGES)) encoder_inst
                     (.data_in(is_tracking_sig),
                      .data_out(num_unique_values_out));
               
endmodule
