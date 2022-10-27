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
    logic bias_correct, reset_count;
    
    ring_oscillator ro1( .EN(EN), .CHALLENGE(CHALLENGE), .OUT(CLK1));
    ring_oscillator ro2( .EN(EN), .CHALLENGE(CHALLENGE), .OUT(CLK2));
    
    always_ff @(posedge CLK1) begin
        sample <= CLK2;
        count <= ~count;
        if(reset_count) begin
            sample_count <= 0;
            sample_count_done <= 0;
            count <= 0;
        end else begin
            if(sample_count == min_samples) sample_count_done <= 1;
            else begin 
                if(!CLK2) sample_count <= sample_count + 1;
                else sample_count <= 0;
            end 
        end
    end
    
    always_ff @(posedge sample, posedge ACK) begin
        reset_count <= 0;
        if(ACK) BIT_READY <= 0;
        else if(sample && sample_count_done && ~BIT_READY) begin
            reset_count <= 1;
            if(~bias_correct) begin
                RANDOM <= count;
                bias_correct <= 1;
            end else begin
                RANDOM <= RANDOM ^ count;
                BIT_READY <= 1;
                bias_correct <= 0;
            end
        end
    end
    
endmodule
