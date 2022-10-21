`timescale 1ns / 1ps

(* dont_touch = "true" *) module TRNG(
    output logic RANDOM,
    output logic BIT_READY,
    input ACK,
    input EN
    );
    
    parameter CHALLENGE = 13;
    
    logic CLK1, CLK2;
    logic sample;
    logic count;
    
    ring_oscillator ro1( .EN(EN), .CHALLENGE(CHALLENGE), .OUT(CLK1));
    ring_oscillator ro2( .EN(EN), .CHALLENGE(CHALLENGE), .OUT(CLK2));
    
    always_ff @(posedge CLK1) begin
        sample <= CLK2;
        count <= ~count;
    end
    
    always_ff @(posedge sample, posedge ACK) begin
        if(sample) begin
            RANDOM <= count;
            BIT_READY <= 1;
        end
        else if(ACK) BIT_READY <= 0; 
    end
    
    
endmodule
