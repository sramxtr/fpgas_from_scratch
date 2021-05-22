`timescale 1ns / 1ps

module wrapper
    #(parameter NUM_DATA_BITS = 32,
      parameter NUM_MAX_TRACKED_VALUES = 8,
      parameter NUM_RAM_WORDS = 19,
      parameter RAM_INIT_FILE = "C:/roger/mem_init_files/hex_init_32x18.txt")
    (input clk,
     input reset,
     input unique_or_untracked_select_in,
     output [$clog2(NUM_MAX_TRACKED_VALUES):0] counter_out);
     
    logic read_valid_sig; 
    logic [NUM_DATA_BITS-1:0] read_data_sig;
    logic [$clog2(NUM_RAM_WORDS)-1:0] read_address_sig;
    logic tracker_valid_out_sig;
    logic [$clog2(NUM_MAX_TRACKED_VALUES):0] num_unique_values_sig, num_nontracked_data_sig; 
    
    assign counter_out = (unique_or_untracked_select_in == 0) ? num_unique_values_sig : num_nontracked_data_sig; 
    
    unique_value_tracker 
       #(.NUM_DATA_BITS(NUM_DATA_BITS),
         .NUM_MAX_TRACKED_VALUES(NUM_MAX_TRACKED_VALUES)) unique_value_tracker_inst
       (.clk(clk),
        .reset_in(reset),
        .valid_in(read_valid_sig),
        .data_in(read_data_sig),
        .valid_out(tracker_valid_out_sig),
        .num_unique_values_out(num_unique_values_sig));
        
    saturating_counter
        #(.MAX_VALUE(NUM_MAX_TRACKED_VALUES)) saturating_counter_inst
        (.clk(clk),
         .reset(reset),
         .enable_in(tracker_valid_out_sig),
         .count_out(num_nontracked_data_sig));
                
    ram_read_controller
       #(.NUM_RAM_WORDS(NUM_RAM_WORDS)) ram_read_controller_inst
       (.clk(clk),
        .reset(reset),
        .address_out(read_address_sig),
        .valid_out(read_valid_sig));
        
        
    ram_single_ported_inferred 
        #(.NUM_WORD_BITS(NUM_DATA_BITS),
         .NUM_WORDS(NUM_RAM_WORDS),
         .INIT_FILE(RAM_INIT_FILE)) ram_inst
       (.clk(clk),
        .write_enable_in(0),
        .address_in(read_address_sig),
        .data_in(0),
        .data_out(read_data_sig));
    
endmodule
