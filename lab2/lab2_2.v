/* CSED273 lab experiment 2 */
/* lab2_2.v */

/* Simplifed equation by K-Map method
 * You are allowed to use keword "assign" and operator "&","|","~",
 * or just implement with gate-level-modeling (and, or, not) */
module lab2_2(
    output wire outGT, outEQ, outLT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    CAL_GT_2 cal_gt2(outGT, inA, inB);
    CAL_EQ_2 cal_eq2(outEQ, inA, inB);
    CAL_LT_2 cal_lt2(outLT, inA, inB);

endmodule

/* Implement output about "A>B" */
module CAL_GT_2(
    output wire outGT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    ////////////////////////
    /* Add your code here */
    wire epi, pi1, pi2;
    assign epi = inA[1] & ~inB[1]; // EPI
    assign pi1 = inA[0] & ~inB[1] & ~inB[0]; // PI
    assign pi2 = inA[1] & inA[0] & ~inB[0]; // PI
    
    assign outGT = epi | pi1 | pi2;
    ////////////////////////

endmodule

/* Implement output about "A=B" */
module CAL_EQ_2(
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
module CAL_LT_2(
    output wire outLT,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    ////////////////////////
    /* Add your code here */
    wire epi, pi1, pi2;
    assign epi = ~inA[1] & inB[1]; // EPI
    assign pi1 = ~inA[1] & ~inA[0] & inB[0]; // PI
    assign pi2 = ~inA[0] & inB[1] & inB[0]; // PI
    
    assign outLT = epi | pi1 | pi2;
    ////////////////////////

endmodule