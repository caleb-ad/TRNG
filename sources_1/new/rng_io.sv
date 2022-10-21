`timescale 1ns / 1ps

module rng_io(
    input BTNC,
    input CLK,
    output [6:0] CATHODES,
    output [3:0] ANODES
    );
    
    parameter amount_rng_bits = 16;
    
    logic [amount_rng_bits - 1:0] rng_value;
    logic [amount_rng_bits - 1:0] rng_bit;
    logic enable, ack, rng_bit, bit_ready;
    
    generate
        for(genvar i=0; i<amount_rng_bits; i++) trng(.EN(enable), .RANDOM(rng_bit[i]), .BIT_READY(bit_ready), .ACK(ack));
    endgenerate
    
    always_ff @(posedge CLK) begin
        ack <= 0;
        
        if(BTNC) begin
            rng_value <= 0;
            enable <= 1;
        end else if(bit_ready) begin
            rng_value <= rng_bit;
            ack <= 1;
        end
        else if(bit_ready) enable <= 0;
    end
    
    sseg_des dec (
   .COUNT        (rng_value),
   .CLK          (CLK),
   .VALID        (1),
   .DISP_EN      (ANODES),
   .SEGMENTS     (CATHODES)
   ); 
    
endmodule
