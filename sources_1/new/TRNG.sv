`timescale 1ns / 1ps

(* dont_touch = "true" *) module TRNG(
    output logic RANDOM,
    output logic BIT_READY,
    input ACK,
    input EN
    );
    
    parameter CHALLENGE = 13;
    parameter min_samples = 6;
    
    logic CLK1, CLK2;
    logic sample;
    logic count;
    logic [3:0] sample_count;
    logic prev_rand_bit;
    
    ring_oscillator ro1( .EN(EN), .CHALLENGE(CHALLENGE), .OUT(CLK1));
    ring_oscillator ro2( .EN(EN), .CHALLENGE(CHALLENGE), .OUT(CLK2));
    
    always_ff @(posedge CLK1) begin
        sample <= CLK2;
        count <= ~count;
        if (BIT_READY) begin
            count <= 0;
            sample_count = 0;
        end
        else if(sample_count == min_samples / 2) count <= 0;
//        if(~CLK2) begin 
//            sample_count <= sample_count + 1;
//        end
        sample_count <= sample_count + 1;
    end
    
    always_ff @(posedge sample, posedge ACK) begin
        if(ACK) BIT_READY <= 0;
        else if ((sample & ~BIT_READY) && (sample_count == (min_samples / 2))) begin
            prev_rand_bit <= count;
        end
        else if((sample & ~BIT_READY) && (sample_count > min_samples)) begin // && prev_rand_bit_flag
            RANDOM <= count ^ prev_rand_bit; 
            BIT_READY <= 1;
        end
    end
      
endmodule
