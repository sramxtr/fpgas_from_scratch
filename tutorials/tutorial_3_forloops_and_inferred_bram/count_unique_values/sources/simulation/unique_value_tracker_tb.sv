`timescale 1ns / 1ps

module unique_value_tracker_tb();

    localparam NUM_DATA_BITS = 8;
    localparam NUM_MAX_TRACKED_VALUES = 4;
    
    function int min(input int a,b);
        return (a < b) ? a : b;
    endfunction
    
    logic clk_sig = 0;
    logic reset_in_sig = 0;
    logic valid_in_sig = 0;
    logic valid_out_sig;
    logic [NUM_DATA_BITS-1:0] data_in_sig = 0;
    logic [$clog2(NUM_MAX_TRACKED_VALUES):0] num_unique_values_out_sig;
    
    always #0.5 clk_sig <= ~clk_sig;

    initial begin
        
        valid_in_sig = 0; reset_in_sig = 0; data_in_sig = 0; #10
        reset_in_sig = 1; #(NUM_MAX_TRACKED_VALUES*2)
        reset_in_sig = 0; #3
        
        // Send 3 new values
        valid_in_sig = 1; data_in_sig = 8'hAA; #1
        valid_in_sig = 1; data_in_sig = 8'hBB; #1
        valid_in_sig = 1; data_in_sig = 8'hCC; #1      
        
        // Send the same values again, in a different order
        valid_in_sig = 1; data_in_sig = 8'hBB; #1
        valid_in_sig = 1; data_in_sig = 8'hCC; #1
        valid_in_sig = 1; data_in_sig = 8'hAA; #1
        
        // Pause for a bit
        valid_in_sig = 0; #(NUM_MAX_TRACKED_VALUES+2)
        assert(num_unique_values_out_sig == 3) else $error("Expected to have 3 unique values tracked by now");
        
        // Send two new values
        valid_in_sig = 1; data_in_sig = 8'hDD; #1
        valid_in_sig = 1; data_in_sig = 8'hEE; #1

        // Pause again
        valid_in_sig = 0; #(NUM_MAX_TRACKED_VALUES+2)        
        assert(num_unique_values_out_sig == min(NUM_MAX_TRACKED_VALUES, 5)) else $error("Error after passing in data 4 and 5");
        
        $finish; 
    
    end // initial

    unique_value_tracker #(.NUM_DATA_BITS(NUM_DATA_BITS),
                           .NUM_MAX_TRACKED_VALUES(NUM_MAX_TRACKED_VALUES)) unique_value_tracker_inst
                           (.clk(clk_sig),
                            .reset_in(reset_in_sig),
                            .valid_in(valid_in_sig),        
                            .data_in(data_in_sig),   
                            .valid_out(valid_out_sig),               
                            .num_unique_values_out(num_unique_values_out_sig));  
    
    
    endmodule
