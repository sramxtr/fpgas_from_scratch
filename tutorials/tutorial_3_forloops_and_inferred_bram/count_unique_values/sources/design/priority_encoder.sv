`timescale 1ns / 1ps

module priority_encoder
    #(parameter NUM_DATA_BITS = 32)
    (input logic [NUM_DATA_BITS-1:0] data_in,
     output logic [$clog2(NUM_DATA_BITS):0] data_out);
     
    always_comb begin
        data_out = 0;

        for (int ii = 0; ii < NUM_DATA_BITS; ii++) begin
            if (data_in[ii] == 1)
                data_out = ii+1;
        end
    end // always_comb
endmodule
