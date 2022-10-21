`timescale 1ns / 1ps

`define INVERTING_SLICE 64'h00f000f00000f0f0 \
`define NONINVERTING_SLICE 64'hf000f000f0f00000 \

`define RO_SLICE_NETS(PREV, CURR) \
    `ifndef OUT_DECLARED``CURR \
        (* dont_touch = "true", allow_combinatorial_loops = "true" *) logic [1:0] OUT``CURR; \
    `endif \
    (* dount_touch = "true", allow_combinatorial_loops = "true" *) logic [1:0] OUTA``PREV; \
    (* dont_touch = "true", allow_combinatorial_loops = "true" *) logic [1:0] BX``CURR;

`define RO_SLICE_ASSIGNS(PREV, CURR, SEL, BX_SEL, EN, LUT_CODE)\
    assign OUTA``PREV = OUT``PREV; \
    assign OUTA``PREV = OUT``PREV; \
    // O = I5&~I3 | ~I5&~I4 => 0x53 => 0x00ff00ff0000ffff (inverting) \
    // O = I5&I3 | ~I5&I4 => 0xac => 0xff00ff00ffff0000 (non-inverting) \
    // I5: SEL \
    // I4: ~OUT \
    // I3: ~OUT (latched) \
    // I2: enable, 0x00ff00ff0000ffff & 0xf0f0f0f0f0f0f0f0 = 0x00f000f00000f0f0 \
    // I2: enable, 0xff00ff00ffff0000 & 0xf0f0f0f0f0f0f0f0 = 0xf000f000f0f00000 \
    LUT6_L #( \
       .INIT(LUT_CODE)  // Specify LUT Contents \
    ) LUT6``CURR ( \
       .LO(BX``CURR[0]),   // LUT general output \
       .I0(0), // LUT input \
       .I1(0), // LUT input \
       .I2(EN), // LUT input \
       .I3(OUT``PREV[0]), // LUT input \
       .I4(OUT``PREV[1]), // LUT input \
       .I5(SEL)  // LUT input \
    ); \
    LUT6_L #( \
       .INIT(LUT_CODE)  // Specify LUT Contents \
    ) LUT6A``CURR ( \
       .LO(BX``CURR[1]),   // LUT general output \
       .I0(0), // LUT input \
       .I1(0), // LUT input \
       .I2(EN), // LUT input \
       .I3(OUTA``PREV[0]), // LUT input \
       .I4(OUTA``PREV[1]), // LUT input \
       .I5(SEL)  // LUT input \
    ); \
    MUXF7 MUXF7``CURR ( \
       .O(OUT``CURR[0]),    // Output of MUX to general routing \
       .I0(BX``CURR[1]),  // Input (tie to LUT6 O6 pin) \
       .I1(BX``CURR[0]),  // Input (tie to LUT6 O6 pin) \
       .S(BX_SEL)     // Input select to MUX \
    ); \
    always_latch if (EN) OUT``CURR[1] <= OUT``CURR[0];

`define RO_SLICE_FIRST(PREV, CURR, SEL, BX_SEL, EN) \
    (* dont_touch = "true", allow_combinatorial_loops = "true" *) logic [1:0] OUT``PREV; \
    `define OUT_DECLARED``PREV \
    `RO_SLICE(PREV, CURR, SEL, BX_SEL, EN)

`define RO_SLICE(PREV, CURR, SEL, BX_SEL, EN) \
    `RO_SLICE_NETS(PREV, CURR); \
    `RO_SLICE_ASSIGNS(PREV, CURR, SEL, BX_SEL, EN, `INVERTING_SLICE);

`define RO_SLICE_NOINVERT(PREV, CURR, SEL, BX_SEL, EN)\
    `RO_SLICE_NETS(PREV, CURR); \
    `RO_SLICE_ASSIGNS(PREV, CURR, SEL, BX_SEL, EN, `NONINVERTING_SLICE);


(* dont_touch = "true" *) module ring_oscillator(
    input EN,
    input [7:0] CHALLENGE,
    output logic OUT
    );

    `RO_SLICE_FIRST(7, 0, CHALLENGE[4], CHALLENGE[0], EN);
    `RO_SLICE(0, 1, CHALLENGE[5], CHALLENGE[1], EN);
    `RO_SLICE(1, 2, CHALLENGE[6], CHALLENGE[2], EN);
    `RO_SLICE(2, 3, CHALLENGE[7], CHALLENGE[3], EN);
    `RO_SLICE(3, 4, CHALLENGE[4], CHALLENGE[0], EN);
    `RO_SLICE(4, 5, CHALLENGE[5], CHALLENGE[1], EN);
    `RO_SLICE(5, 6, CHALLENGE[6], CHALLENGE[2], EN);
    `RO_SLICE_NOINVERT(6, 7, CHALLENGE[7], CHALLENGE[3], EN);

    assign OUT = OUT2[0];

endmodule
