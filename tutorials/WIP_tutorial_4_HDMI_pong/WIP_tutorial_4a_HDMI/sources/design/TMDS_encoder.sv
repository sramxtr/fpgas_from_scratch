module TMDS_encoder
    (input logic clk,
     input logic [7:0] video_data_in,
     input logic [1:0] control_data_in,
     input logic control_or_video_in, // 0 => control, 1 => video
     output logic [9:0] encoded_data_out);

    logic [9:0] encoded_video_sig, encoded_control_sig;
    logic [9:0] encoded_data_prebuf_sig, encoded_data_postbuf_sig = 0;

    assign encoded_data_out = encoded_data_postbuf_sig;
    assign encoded_data_prebuf_sig = (control_or_video_in == 0 /*control*/) ? encoded_control_sig : encoded_video_sig;

    always_ff @ (posedge clk) begin
        encoded_data_postbuf_sig <= encoded_data_prebuf_sig;
    end // always_ff

    TMDS_video_data_encoder video_encoder_inst
        (.clk(clk),
         .video_data_in(video_data_in),
         .encoded_video_data_out(encoded_video_sig));

    TMDS_control_period_encoder control_encoder_inst
        (.control_data_in(control_data_in),
         .encoded_control_data_out(encoded_control_sig));

endmodule