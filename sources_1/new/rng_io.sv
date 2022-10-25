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
    logic [amount_rng_bits - 1:0] rng_bit_ready;
    logic enable, ack, bit_ready;
    
    generate
        for(genvar i=0; i<amount_rng_bits; i++) TRNG(.EN(enable & ~bit_ready), .RANDOM(rng_bit[i]), .BIT_READY(rng_bit_ready[i]), .ACK(ack));
    endgenerate
    
    always_comb begin
        if(&rng_bit_ready == 1) bit_ready <= 1;
        else bit_ready <= 0;
    end
    
    always_ff @(posedge CLK) begin
        ack <= 0;
        
        if(BTNC) begin
            rng_value <= 0;
            enable <= 1;
        end else if(bit_ready) begin
            rng_value <= rng_bit;
            ack <= 1;
            enable <= 0;
        end
    end
    
    sseg_des dec (
   .COUNT        (rng_value),
   .CLK          (CLK),
   .VALID        (1),
   .DISP_EN      (ANODES),
   .SEGMENTS     (CATHODES)
   ); 
    
endmodule
