
module counter_to_led_top(
    input logic clk,
    output logic [3:0] led_out
    );
    
    logic [28:0] counter = 0;
    
    assign led_out = counter[27:24];
    
    always_ff @ (posedge clk) begin
        counter <= counter + 1;
    end
    
endmodule
