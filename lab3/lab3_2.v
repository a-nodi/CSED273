/* CSED273 lab3 experiment 2 */
/* lab3_2.v */


/* Implement Prime Number Indicator & Multiplier Indicator
 * You may use keword "assign" and operator "&","|","~",
 * or just implement with gate-level-modeling (and, or, not) */
 
/* 11: out_mul[4], 7: out_mul[3], 5: out_mul[2],
 * 3: out_mul[1], 1: out_mul[0] */
module lab3_2(
    input wire [3:0] in,
    output wire out_prime,
    output wire [4:0] out_mul
    );

    ////////////////////////
    /* Add your code here */
    
    // Prime Number Indicator
    wire prime_term1, prime_term2, prime_term3, prime_term4; // EPI or PI
    assign prime_term1 = ~in[2] & in[1] & in[0]; // m3 + m11
    assign prime_term2 = ~in[3] & ~in[2] & in[1]; // m2 + m3
    assign prime_term3 = in[2] & ~in[1] & in[0]; // m5 + m13
    assign prime_term4 = ~ in[3] & in[2] & in[0]; // m5 + m7
    assign out_prime = prime_term1 | prime_term2 | prime_term3 | prime_term4; // m2 + m3 + m5 + m7 + m11 + m13
    
    // Multiplier Indicator of 11
    wire mul_of_11_term; // EPI
    assign mul_of_11_term = in[3] & ~in[2] & in[1] & in[0]; // m11
    assign out_mul[4] = mul_of_11_term; // m11
    
    // Multiplier Indicator of 7
    wire mul_of_7_term1, mul_of_7_term2; // EPI
    assign mul_of_7_term1 = ~in[3] & in[2] & in[1] & in[0]; // m7
    assign mul_of_7_term2 = in[3] & in[2] & in[1] & ~in[0]; // m14
    assign out_mul[3] = mul_of_7_term1 | mul_of_7_term2; // m7 + m14
    
    // Multiplier Indicator of 5
    wire mul_of_5_term1, mul_of_5_term2, mul_of_5_term3; // EPI
    assign mul_of_5_term1 = ~in[3] & in[2] & ~in[1] & in[0]; // m5
    assign mul_of_5_term2 = in[3] & ~in[2] & in[1] & ~in[0]; // m10
    assign mul_of_5_term3 = in[3] & in[2] & in[1] & in[0]; // m15
    assign out_mul[2] = mul_of_5_term1 | mul_of_5_term2 | mul_of_5_term3; // m5 + m10 + m15
    
    // Multiplier Indicator of 3
    wire mul_of_3_term1, mul_of_3_term2, mul_of_3_term3, mul_of_3_term4, mul_of_3_term5; // EPI
    assign mul_of_3_term1 = ~in[3] & ~in[2] & in[1] & in[0]; // m3
    assign mul_of_3_term2 = ~in[3] & in[2] & in[1] & ~in[0]; // m6
    assign mul_of_3_term3 = in[3] & ~in[2] & ~in[1] & in[0]; // m9
    assign mul_of_3_term4 = in[3] & in[2] & ~in[1] & ~in[0]; // m12
    assign mul_of_3_term5 = in[3] & in[2] & in[1] & in[0]; // m15
    assign out_mul[1] = mul_of_3_term1 | mul_of_3_term2 | mul_of_3_term3 | mul_of_3_term4 | mul_of_3_term5; // m3 + m6 + m9 + m12 + m15
    
    // Multiplier Indicator of 2
    wire mul_of_2_term1, mul_of_2_term2, mul_of_2_term3; // EPI
    assign mul_of_2_term1 = in[1] & ~in[0]; // m2 + m6 + m10 + m14
    assign mul_of_2_term2 = in[2] & ~in[0]; // m4 + m6 + m12 + m14
    assign mul_of_2_term3 = in[3] & ~in[0]; // m8 + m10 + m12 + m14
    assign out_mul[0] = mul_of_2_term1 | mul_of_2_term2 | mul_of_2_term3; // m2 + m4 + m6 + m8 + m10 + m12 + m14
    ////////////////////////

endmodule