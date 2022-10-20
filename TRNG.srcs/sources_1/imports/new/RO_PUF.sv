`timescale 1ns / 1ps

`define NUM_RO 9

module RO_PUF(
    input [7:0] CHALLENGE,
    input CLK,
    input RESET,
    output logic [7:0] RESPONSE,
    output logic DONE
    );
    
    logic enable;
    logic reset;
    logic count_clk;
    logic [31:0] time_count;
    logic [31:0] ro_count;
    logic [31:0] compare_result [0:`NUM_RO-1];
    logic [3:0] current_ro;
    logic [`NUM_RO-1:0] ro_out;
    

    generate
        for (genvar i=0; i<`NUM_RO - 1; i = i + 1) assign RESPONSE[i] = compare_result[i] > compare_result[i + 1];
        for (genvar i=0; i<`NUM_RO; i = i + 1) ring_oscillator  RO(.EN((current_ro == i) && enable), .CHALLENGE(CHALLENGE), .OUT(ro_out[i]));
    endgenerate
    
    assign DONE = ~enable;
    assign count_clk = ro_out[current_ro];
    
    always_ff @(posedge count_clk, posedge reset) begin
        if(reset) ro_count <= 0;
        else if(enable) ro_count <= ro_count + 1;
    end
    
    logic old_challenge_xor;
    always_ff @(posedge CLK) begin
        reset <= 0;
        compare_result[current_ro] <= ro_count;
    
        if(old_challenge_xor != ^{RESET, CHALLENGE}) begin
            enable <= 1;
            time_count <= 0;
            current_ro <= 0;
        end
        old_challenge_xor <= ^{RESET, CHALLENGE};
        
        if(enable) begin
            if (time_count == 'hffffff) begin
                if(current_ro == `NUM_RO - 1) enable <=0;
                else current_ro <= current_ro + 1;
                time_count <= 0;
                reset <= 1;
            end else time_count <= time_count + 1;
        end
    end
    
endmodule
