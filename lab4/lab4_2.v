/* CSED273 lab4 experiment 2 */
/* lab4_2.v */

/* Implement 5-Bit Ripple Adder
 * You must use fullAdder module in lab4_1.v
 * You may use keword "assign" and bitwise operator
 * or just implement with gate-level modeling*/
module lab4_2(
    input [4:0] in_a,
    input [4:0] in_b,
    input in_c,
    output [4:0] out_s,
    output out_c
    );

    ////////////////////////
    /* Add your code here */
    wire [4:0] inm_c; // Array of intermidiate c
    assign inm_c[0] = in_c;
    
    // Connect five full adder in series to make 5-bit ripple adder
    fullAdder fullAdder1(in_a[0], in_b[0], inm_c[0], out_s[0], inm_c[1]);
    fullAdder fullAdder2(in_a[1], in_b[1], inm_c[1], out_s[1], inm_c[2]);
    fullAdder fullAdder3(in_a[2], in_b[2], inm_c[2], out_s[2], inm_c[3]);
    fullAdder fullAdder4(in_a[3], in_b[3], inm_c[3], out_s[3], inm_c[4]);
    fullAdder fullAdder5(in_a[4], in_b[4], inm_c[4], out_s[4], out_c);
    ////////////////////////

endmodule