
module unique_value_tracker_stage
       #(parameter NUM_DATA_BITS = 32)
       (input logic clk,
        input logic reset_in,
        input logic valid_in,
        input logic [NUM_DATA_BITS-1:0] data_in,
        output logic reset_out,
        output logic valid_out,
        output logic [NUM_DATA_BITS-1:0] data_out,
        output logic is_tracking_unique_value_out);        
        
    logic [NUM_DATA_BITS-1:0] tracked_value_prebuf_sig, tracked_value_postbuf_sig = 0;
    logic is_tracking_unique_value_prebuf_sig, is_tracking_unique_value_postbuf_sig = 0;
    logic [NUM_DATA_BITS-1:0] data_out_postbuf_sig = 0;
    logic will_track_incoming_data_sig;
    logic valid_out_prebuf_sig, valid_out_postbuf_sig = 0;
    
    assign is_tracking_unique_value_out = is_tracking_unique_value_postbuf_sig;
    assign data_out = data_out_postbuf_sig;
    assign valid_out = valid_out_postbuf_sig;
    
    always_comb begin
        // If we will be tracking the incoming data
        if (will_track_incoming_data_sig == 1)
            // Then clear the valid bit
            valid_out_prebuf_sig = 0;
        else
            // Else, if we are already tracking a value, and the value tracked matches the incoming data
            if (is_tracking_unique_value_postbuf_sig && (tracked_value_postbuf_sig == data_in) )
                // Then clear the valid bit
                valid_out_prebuf_sig = 0;
            else
                // Else, this stage does not necessarily care about the incoming data
                // so just let the valid through as is
                valid_out_prebuf_sig = valid_in;
    end // always_comb
    
    assign will_track_incoming_data_sig = valid_in & ~is_tracking_unique_value_postbuf_sig;
    assign tracked_value_prebuf_sig = (will_track_incoming_data_sig) ? data_in : tracked_value_postbuf_sig;
    assign is_tracking_unique_value_prebuf_sig = will_track_incoming_data_sig | is_tracking_unique_value_postbuf_sig;
    
    always_ff @ (posedge clk) begin
        reset_out <= reset_in;
        if (reset_in == 1) begin
            data_out_postbuf_sig <= 0;
            is_tracking_unique_value_postbuf_sig <= 0;
            tracked_value_postbuf_sig <= 0;
            valid_out_postbuf_sig <= 0;
        end else begin
            data_out_postbuf_sig <= data_in;
            is_tracking_unique_value_postbuf_sig <= is_tracking_unique_value_prebuf_sig;
            tracked_value_postbuf_sig <= tracked_value_prebuf_sig;
            valid_out_postbuf_sig <= valid_out_prebuf_sig; 
        end
    end // always_ff    
    
endmodule
