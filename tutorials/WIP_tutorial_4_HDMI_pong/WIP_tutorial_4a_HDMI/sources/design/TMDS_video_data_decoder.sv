module TMDS_video_data_decoder
    (input logic [9:0] encoded_video_data_in,
     output logic [7:0] decoded_video_data_out);

    // See section 5.4.4.2 Video Data Decoding
    // on page 83 of the HDMI 1.3a spec available at https://hdmi.org/

    logic [7:0] step_1_sig, step_2_xor_sig, step_2_xnor_sig;

    assign decoded_video_data_out = (encoded_video_data_in[8]) ? step_2_xor_sig : step_2_xnor_sig;

    assign step_1_sig = (encoded_video_data_in[9]) ? ~encoded_video_data_in[7:0] : encoded_video_data_in;

    always_comb begin
        step_2_xor_sig[0] = step_1_sig[0];
        for (int ii=1; ii<=$size(step_2_xor_sig); ii++) begin
            step_2_xor_sig[ii] = step_1_sig[ii] ^ step_1_sig[ii-1];
        end
    end // always_comb
    
    always_comb begin
        step_2_xnor_sig[0] = step_1_sig[0];
        for (int ii=1; ii<=$size(step_2_xor_sig); ii++) begin
            step_2_xnor_sig[ii] = step_1_sig[ii] ~^ step_1_sig[ii-1];
        end
    end // always_comb

endmodule