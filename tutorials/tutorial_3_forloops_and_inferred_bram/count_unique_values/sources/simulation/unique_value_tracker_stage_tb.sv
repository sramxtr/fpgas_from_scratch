`timescale 1ns / 1ps

module unique_value_tracker_stage_tb();

    localparam NUM_DATA_BITS = 8;
    logic clk_sig = 0;
    logic reset_in_sig = 0, reset_out_sig, valid_in_sig = 0;
    logic [NUM_DATA_BITS-1:0] data_in_sig = 0, data_out_sig;
    logic valid_out_sig;
    logic is_tracking_sig;
    
    always #0.5 clk_sig <= ~clk_sig;
    
    initial begin
    
        valid_in_sig = 0; data_in_sig = 8'hAA;
        reset_in_sig = 0; #10
        reset_in_sig = 1; #5
        reset_in_sig = 0; #10
        
        // Pass valid data in, and we expect the tracker to claim this data
        valid_in_sig = 1; data_in_sig = 8'hBB; #1
        assert(is_tracking_sig == 1) else $error("Error is_tracking after first valid input");
        assert(valid_out_sig == 0) else $error("Error valid_out after first valid input");
        
        // Pass valid data in, and we expect the tracker to NOT claim this data
        // since the tracker is already tracking the first data
        valid_in_sig = 1; data_in_sig = 8'hCC; #1
        assert(is_tracking_sig == 1) else $error("Error is_tracking after second valid input");
        assert(valid_out_sig == 1) else $error("Error valid_out after second valid input");
        
        // Pass the first data in again
        // Since the tracker is already tracking this data, we expect the tracker to clear valid_out
        valid_in_sig = 1; data_in_sig = 8'hBB; #1
        assert(valid_out_sig == 0) else $error("Error valid_out after third valid input, which is a repeat of the tracked value");
        
        // Pass valid data in, and we expect the tracker to NOT claim this data
        // since the tracker is already tracking the first data
        valid_in_sig = 1; data_in_sig = 8'hDD; #1
        assert(is_tracking_sig == 1) else $error("Error is_tracking after fourth valid input");
        assert(valid_out_sig == 1) else $error("Error valid_out after fourth valid input");
        
        valid_in_sig = 0; reset_in_sig = 1; #1
        
        assert(is_tracking_sig == 0) else $error("Error is_tracking after reset");
        
        #10
        
        $finish;
    end // initial

    unique_value_tracker_stage #(.NUM_DATA_BITS(NUM_DATA_BITS)) tracker_stage_inst
                               (.clk(clk_sig),
                                .reset_in(reset_in_sig),
                                .valid_in(valid_in_sig),
                                .data_in(data_in_sig),
                                .reset_out(reset_out_sig),
                                .valid_out(valid_out_sig),
                                .data_out(data_out_sig),
                                .is_tracking_unique_value_out(is_tracking_sig));  

endmodule
