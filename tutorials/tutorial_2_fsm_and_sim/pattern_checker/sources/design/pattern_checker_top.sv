
module pattern_checker_top
       #(parameter NUM_DEBOUNCER_COUNTER_BITS = 21)
       (input logic clk,
        input logic reset,
        input logic action_in,
        input logic [3:0] code_in,
        output logic led_r_out,
        output logic led_g_out,
        output logic led_b_out);
    
    logic debouncer_data_out_sig, pulse_data_out_sig;
    
    debouncer #(.NUM_COUNTER_BITS(NUM_DEBOUNCER_COUNTER_BITS)) debouncer_inst 
               (.clk(clk),
                .data_in(action_in),
                .data_out(debouncer_data_out_sig));
                               
    rising_edge_to_pulse rising_edge_to_pulse_inst
                         (.clk(clk),
                          .reset(reset),
                          .data_in(debouncer_data_out_sig),
                          .data_out(pulse_data_out_sig));                                                                                                
    
    pattern_checker pattern_checker_inst
                    (.clk(clk),
                     .reset(reset),
                     .action_in(pulse_data_out_sig),
                     .code_in(code_in),
                     .led_r_out(led_r_out),
                     .led_g_out(led_g_out),
                     .led_b_out(led_b_out));

endmodule
