`timescale 1ns / 1ps

(* dont_touch = "true" *) module TRNG(
    output logic RANDOM,
    output logic BIT_READY,
    input ACK,
    input EN
    );
    
    parameter CHALLENGE = 13;
    parameter min_samples = 4;
    
    logic CLK1, CLK2;
    logic sample;
    logic count;
    logic [2:0] sample_count = 0;
    logic sample_count_done;
    
    ring_oscillator ro1( .EN(EN), .CHALLENGE(CHALLENGE), .OUT(CLK1));
    ring_oscillator ro2( .EN(EN), .CHALLENGE(CHALLENGE), .OUT(CLK2));
    
    always_ff @(posedge CLK1) begin
        sample <= CLK2;
        count <= ~count;
        if(BIT_READY) begin
            sample_count <= 0;
            count <= 0;
        end else begin
            if(sample_count < min_samples) begin 
                if(!CLK2) sample_count <= sample_count + 1;
                else sample_count <= 0;
            end 
        end
    end
    
    always_ff @(posedge sample, posedge ACK) begin
        if(ACK) BIT_READY <= 0;
        else if(sample && ~BIT_READY && (sample_count == min_samples)) begin
            RANDOM <= count;
            BIT_READY <= 1;
        end
    end
    
endmodule
