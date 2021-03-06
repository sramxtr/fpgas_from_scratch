
module controllable_counter_to_led_top(
    input logic clk,
    input logic reset,
    input logic enable_in,
    output logic [3:0] led_out
    );
    
    logic [27:0] counter = 0;
    
    assign led_out = counter[27:24];
    
    always_ff @ (posedge clk) begin
        if (reset == 1) begin
            counter <= '0;
        end else begin
            if (enable_in == 1) begin
                counter <= counter + 1;
            end
        end
    end // always_ff
    
endmodule
