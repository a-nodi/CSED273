/* CSED273 lab4 experiment 1 */
/* lab4_1.v */


/* Implement Half Adder
 * You may use keword "assign" and bitwise operator
 * or just implement with gate-level modeling*/
module halfAdder(
    input in_a,
    input in_b,
    output out_s,
    output out_c
    );

    ////////////////////////
    /* Add your code here */
    assign out_s = in_a ^ in_b; // 
    assign out_c = in_a & in_b;
    ////////////////////////

endmodule

/* Implement Full Adder
 * You must use halfAdder module
 * You may use keword "assign" and bitwise operator
 * or just implement with gate-level modeling*/
module fullAdder(
    input in_a,
    input in_b,
    input in_c,
    output out_s,
    output out_c
    );

    ////////////////////////
    /* Add your code here */
    wire inm1_s, inm1_c, inm2_c; // Intermidiate s and c
    
    // Connect two halfAdders in series
    halfAdder halfAdder1(in_a, in_b, inm1_s, inm1_c);
    halfAdder halfAdder2(inm1_s, in_c, out_s, inm2_c);
    assign out_c = inm1_c | inm2_c; // Calculate carry
    ////////////////////////

endmodule