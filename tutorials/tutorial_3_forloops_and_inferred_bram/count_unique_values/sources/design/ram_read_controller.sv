`timescale 1ns / 1ps

module ram_read_controller
       #(parameter NUM_RAM_WORDS = 1024)
       (input logic clk,
        input logic reset,
        output logic [$clog2(NUM_RAM_WORDS)-1:0] address_out,
        output logic valid_out);
        
    enum {INIT,
          READ_WORD,
          DONE} current_state_sig, next_state_sig = INIT;
          
    logic [$clog2(NUM_RAM_WORDS)-1:0] address_out_prebuf_sig, address_out_postbuf_sig = 0;
    logic valid_out_prebuf_sig, valid_out_postbuf_sig = 0;          
    
    assign valid_out = valid_out_postbuf_sig;
    assign address_out = address_out_postbuf_sig;
              
    always_comb begin
        next_state_sig = current_state_sig;
        address_out_prebuf_sig = address_out_postbuf_sig;
        valid_out_prebuf_sig = 0;
        
        unique case(current_state_sig)
            INIT: begin
                next_state_sig = READ_WORD;
                address_out_prebuf_sig = 0;
            end // INIT
            
            READ_WORD: begin
                address_out_prebuf_sig = address_out_postbuf_sig+1;
                valid_out_prebuf_sig = 1;
                if (address_out_postbuf_sig == NUM_RAM_WORDS-1) begin
                    address_out_prebuf_sig = 0;
                    next_state_sig = DONE;
                end
            end // READ_WORD
            
            DONE: begin                
            end // DONE
        endcase
            
    end // always_comb      
          
    always_ff @ (posedge clk) begin
        if (reset == 1) begin
            current_state_sig <= INIT;
            address_out_postbuf_sig <= 0;
            valid_out_postbuf_sig <= 0;
        end else begin
            current_state_sig <= next_state_sig;
            address_out_postbuf_sig <= address_out_prebuf_sig;
            valid_out_postbuf_sig <= valid_out_prebuf_sig;
        end     
    end // always_ff
    
endmodule
