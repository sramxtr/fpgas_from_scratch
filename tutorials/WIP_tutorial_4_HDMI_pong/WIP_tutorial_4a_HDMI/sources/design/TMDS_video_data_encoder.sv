module TMDS_video_data_encoder
    (input logic clk,
     input logic [7:0] video_data_in,
     output logic [9:0] encoded_video_data_out);

    // See section 5.4.4.1 Video Data Encoding 
    // on page 80 of the HDMI 1.3a spec available at https://hdmi.org/

    logic [3:0] video_data_in_num_ones_sig;
    logic [3:0] q_m_num_ones_sig, q_m_num_zeros_sig;
    logic [8:0] q_m_xor_sig, q_m_xnor_sig, q_m_sig;
    logic use_xnor_sig;
    logic is_equal_ones_and_zeros_sig;
    logic is_imbalanced_sig;
    logic [3:0] cnt_prebuf_sig, cnt_postbuf_sig = 0;
    logic [9:0] q_out_sig;

    assign encoded_video_data_out = q_out_sig;

    assign video_data_in_num_ones_sig = video_data_in[7] + video_data_in[6] + video_data_in[5] + video_data_in[4]
                                        + video_data_in[3] + video_data_in[2] + video_data_in[1] + video_data_in[0];                                                                        
    assign q_m_num_ones_sig = q_m_sig[8] + q_m_sig[7] + q_m_sig[6] + q_m_sig[5] + q_m_sig[4]
                              + q_m_sig[3] + q_m_sig[2] + q_m_sig[1] + q_m_sig[0];
    assign q_m_num_zeros_sig = ~q_m_sig[8] + ~q_m_sig[7] + ~q_m_sig[6] + ~q_m_sig[5] + ~q_m_sig[4]
                               + ~q_m_sig[3] + ~q_m_sig[2] + ~q_m_sig[1] + ~q_m_sig[0];

    assign use_xnor_sig = (video_data_in_num_ones_sig > 4) || (video_data_in_num_ones_sig == 4 && video_data_in[0] == 0);

    // Construct q_m_xor_sig
    always_comb begin
        q_m_xor_sig[0] = video_data_in[0];
        q_m_xor_sig[8] = 1;
        for (int ii=1; ii<8; ii++) begin
            q_m_xor_sig[ii] = video_data_in[ii] ^ q_m_xor_sig[ii-1];
        end // for
    end // always_comb

    // Construct q_m_xnor_sig
    always_comb begin
        q_m_xnor_sig[0] = video_data_in[0];
        q_m_xnor_sig[8] = 0;
        for (int ii=1; ii<8; ii++) begin
            q_m_xnor_sig[ii] = video_data_in[ii] ~^ q_m_xnor_sig[ii-1];
        end // for
    end // always_comb

    assign q_m_sig = (use_xnor_sig) ? q_m_xnor_sig : q_m_xor_sig;

    assign is_equal_ones_and_zeros_sig = (cnt_postbuf_sig == 0) && (q_m_num_ones_sig == q_m_num_zeros_sig);
    assign is_imbalanced_sig = (cnt_postbuf_sig > 0 && q_m_num_ones_sig > q_m_num_zeros_sig)
                               || (cnt_postbuf_sig < 0 && q_m_num_zeros_sig > q_m_num_ones_sig);

    // Construct q_out
    assign q_out_sig[8] = q_m_sig[8];
    always_comb begin
        if (is_equal_ones_and_zeros_sig) begin
            q_out_sig[9] = ~q_m_sig[8];
            q_out_sig[7:0] = (q_m_sig[8]) ? q_out_sig[7:0] : ~q_out_sig[7:0];
        end else begin // ones and zeros are NOT equal
            if (is_imbalanced_sig) begin
                q_out_sig[9] = 1;
                q_out_sig[7:0] = ~q_m_sig[7:0];
            end else begin // Not imbalanced
                q_out_sig[9] = 0;
                q_out_sig[7:0] = q_m_sig[7:0];
            end
        end // else
    end // always_comb

    always_ff @ (posedge clk) begin
        cnt_postbuf_sig <= cnt_prebuf_sig;
    end // always_ff

endmodule