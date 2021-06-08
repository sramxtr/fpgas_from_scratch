`timescale 1ns / 1ps

module TMDS_video_data_encoder_tb();

    logic clk_sig = 0;
    logic [7:0] video_data_sig, decoded_video_data_sig;
    logic [9:0] encoded_video_data_sig;

    always #0.5 clk_sig <= ~clk_sig;

    initial begin
        video_data_sig = 8'b00000000; #1
        assert(video_data_sig == decoded_video_data_sig) else $error("Failed for 8'b00000000");
        video_data_sig = 8'b10001000; #1
        assert(video_data_sig == decoded_video_data_sig) else $error("Failed for 8'b10001000");
        video_data_sig = 8'b10111011; #1
        assert(video_data_sig == decoded_video_data_sig) else $error("Failed for 8'b10111011");
        video_data_sig = 8'b10010110; #1
        assert(video_data_sig == decoded_video_data_sig) else $error("Failed for 8'b10010110");
        
        for (int ii=0; ii<256; ii++) begin
            video_data_sig = ii; #1
            assert(video_data_sig == decoded_video_data_sig) else $error("Failed while count up for %d", ii);
        end
        
        for (int ii=255; ii>=0; ii--) begin
            video_data_sig = ii; #1
            assert(video_data_sig == decoded_video_data_sig) else $error("Failed while count down for %d", ii);
        end
        
        for (int ii=255; ii>=0; ii--) begin
            video_data_sig = $urandom_range(255,0); #1
            assert(video_data_sig == decoded_video_data_sig) else $error("Failed while random for %d", ii);
        end
        
        $finish;
    end // initial

    TMDS_encoder TMDS_encoder_inst
        (.clk(clk_sig),
         .video_data_in(video_data_sig),
         .control_data_in(0),
         .control_or_video_in(1),
         .encoded_data_out(encoded_video_data_sig));

    TMDS_video_data_decoder TMDS_decoder_inst
        (.encoded_video_data_in(encoded_video_data_sig),
         .decoded_video_data_out(decoded_video_data_sig));

endmodule
