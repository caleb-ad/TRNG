`timescale 1ns / 1ps

(* dont_touch = "true" *) module TRNG(
    output logic RANDOM,
    output logic BIT_READY,
    input ACK,
    input EN
    );
    
    parameter CHALLENGE = 13;
    parameter min_samples = 1;
    
    logic CLK1, CLK2;
    logic sample;
    logic count;
    //logic [3:0] sample_count = 4'b0000;
    //logic sample_count = 0;
    
    ring_oscillator ro1( .EN(EN), .CHALLENGE(CHALLENGE), .OUT(CLK1));
    ring_oscillator ro2( .EN(EN), .CHALLENGE(CHALLENGE), .OUT(CLK2));
    
    always_ff @(posedge CLK1) begin
        sample <= CLK2;
        count <= ~count;
//        if(!CLK2) begin 
//            sample_count <= sample_count + 1;
//        end
    end
    
    always_ff @(posedge sample, posedge ACK) begin
        if(sample) begin // && (sample_count >= min_samples)
            RANDOM <= count;
            count <= 0;
            BIT_READY <= 1;
        end
        else if(ACK) BIT_READY <= 0; //if the ACK is too fast BIT_READY will never be reset 
    end
    
    
endmodule
