module TMDS_control_period_encoder
    (input logic [1:0] control_data_in,
     output logic [9:0] encoded_control_data_out);

    // See section 5.4.2 Control Period Coding
    // on page 79 of the HDMI 1.3a spec available at https://hdmi.org/

    always_comb begin
        unique case (control_data_in)
            2'b00:
                encoded_control_data_out = 10'b1101010100;
            2'b01:
                encoded_control_data_out = 10'b0010101011;
            2'b10:
                encoded_control_data_out = 10'b0101010100;
            2'b11:
                encoded_control_data_out = 10'b1010101011;
        endcase
    end // always_comb

endmodule