`timescale 1ns / 1ps

module debouncer_tb(
    );
    
    logic clk_sig = 0;
    logic data_in_sig, data_out_sig;
    
    always begin
        #0.5 clk_sig <= ~clk_sig;
    end
    
    initial begin
        data_in_sig = 0; #10
        assert(data_out_sig == 0) else $error("Hmm.. why is data_out not 0??");
        
        // Fluctuate then stabilize at 1
        // Each fluctuation lasts less than 2^COUNTER_BITS cycles
        data_in_sig = 1; #2
        assert(data_out_sig == 1);
        data_in_sig = 0; #3
        data_in_sig = 1; #1
        assert(data_out_sig == 0);
        data_in_sig = 0; #6
        // Stabilize at 1
        data_in_sig = 1; #10
        assert(data_out_sig == 1) else $error("Expected data_out to be 1 by now");
        
        // Fluctuate then stabilize at 0
        data_in_sig = 0; #1
        assert(data_out_sig == 1);
        data_in_sig = 1; #3
        data_in_sig = 0; #5
        assert(data_out_sig == 1);
        data_in_sig = 1; #3
        // Stabilize at 0
        data_in_sig = 0; #9
        assert(data_out_sig == 0) else $error("Expected data_out to be 0 by now");
        
        $finish;
        
    end // initial
    
    // Instantiate the debouncer module
    debouncer #(.NUM_COUNTER_BITS(3)) UUT
              (.clk(clk_sig),
               .data_in(data_in_sig),
               .data_out(data_out_sig));

endmodule
