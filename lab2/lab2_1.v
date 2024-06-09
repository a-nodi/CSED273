/* CSED273 lab2 experiment 1 */
/* lab2_1.v */

/* Unsimplifed equation
 * You are allowed to use keword "assign" and operator "&","|","~",
 * or just implement with gate-level-modeling (and, or, not) */
module lab2_1(
    output wire outGT, outEQ, outLT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    CAL_GT cal_gt(outGT, inA, inB);
    CAL_EQ cal_eq(outEQ, inA, inB);
    CAL_LT cal_lt(outLT, inA, inB);
    
endmodule

/* Implement output about "A>B" */
module CAL_GT(
    output wire outGT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    ////////////////////////
    /* Add your code here */
    
    // Minterm form : A1A0B1B0
    wire m4, m8, m9, m12, m13, m14;
    
    // Subwire to make minterm
    wire m4A, m4B;
    wire m8A, m8B;
    wire m9A, m9B;
    wire m12A, m12B;
    wire m13A, m13B;
    wire m14A, m14B;
    
    // Make m4 term
    assign m4A = ~inA[1] & inA[0];
    assign m4B = ~inB[1] & ~inB[0];
    assign m4 = m4A & m4B;
    
    // Make m8 term
    assign m8A = inA[1] & ~inA[0];
    assign m8B = ~inB[1] & ~inB[0];
    assign m8 = m8A & m8B;
    
    // Make m9 term
    assign m9A = inA[1] & ~inA[0];
    assign m9B = ~inB[1] & inB[0];
    assign m9 = m9A & m9B;
    
    // Make m12 term
    assign m12A = inA[1] & inA[0];
    assign m12B = ~inB[1] & ~inB[0];
    assign m12 = m12A & m12B;
    
    // Make m13 term
    assign m13A = inA[1] & inA[0];
    assign m13B = ~inB[1] & inB[0];
    assign m13 = m13A & m13B;
    
    // Make m14 term
    assign m14A = inA[1] & inA[0];
    assign m14B = inB[1] & ~inB[0];
    assign m14 = m14A & m14B;
    
    // Output
    assign outGT = m4 | m8 | m9 | m12 | m13 | m14;
    ////////////////////////

endmodule

/* Implement output about "A=B" */
module CAL_EQ(
    output wire outEQ,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    ////////////////////////
    /* Add your code here */
    
    // Minterm form : A1A0B1B0
    wire m0, m5, m10, m15;
    
    // Subwire to make minterm
    wire m0A, m0B;
    wire m5A, m5B;
    wire m10A, m10B;
    wire m15A, m15B;
    
    // Make m0 term
    assign m0A = ~inA[1] & ~inA[0];
    assign m0B = ~inB[1] & ~inB[0];
    assign m0 = m0A & m0B;
    
    // Make m5 term
    assign m5A = ~inA[1] & inA[0];
    assign m5B = ~inB[1] & inB[0];
    assign m5 = m5A & m5B;
    
    // Make m10 term
    assign m10A = inA[1] & inA[0];
    assign m10B = inB[1] & inB[0];
    assign m10 = m10A & m10B;
    
    // Make m15A
    assign m15A = inA[1] & ~inA[0];
    assign m15B = inB[1] & ~inB[0];
    assign m15 = m15A & m15B;
    
    // Output
    assign outEQ = m0 | m5 | m10 | m15;
    
    ////////////////////////

endmodule

/* Implement output about "A<B" */
module CAL_LT(
    output wire outLT,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    ////////////////////////
    /* Add your code here */
    
    // Minterm form : A1A0B1B0
    wire m1, m2, m3, m6, m7 ,m15;
    
    // Subwire to make minterm
    wire m1A, m1B;
    wire m2A, m2B;
    wire m3A, m3B;
    wire m6A, m6B;
    wire m7A, m7B;
    wire m15A, m15B;
    
    // Make m1 term
    assign m1A = ~inA[1] & ~inA[0];
    assign m1B = ~inB[1] & inB[0];
    assign m1 = m1A & m1B;
    
    assign m2A = ~inA[1] & ~inA[0];
    assign m2B = inB[1] & ~inB[0];
    assign m2 = m2A & m2B;
    
    assign m3A = ~inA[1] & ~inA[0];
    assign m3B = inB[1] & inB[0];
    assign m3 = m3A & m3B;
    
    assign m6A = ~inA[1] & inA[0];
    assign m6B = inB[1] & ~inB[0];
    assign m6 = m6A & m6B;
    
    assign m7A = ~inA[1] & inA[0];
    assign m7B = inB[1] & inB[0];
    assign m7 = m7A & m7B;
    
    assign m15A = inA[1] & ~inA[0];
    assign m15B = inB[1] & inB[0];
    assign m15 = m15A & m15B;
    
    assign outLT = m1 | m2 | m3 | m6 | m7 | m15;
    ////////////////////////

endmodule