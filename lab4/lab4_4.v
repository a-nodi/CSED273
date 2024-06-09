/* CSED273 lab4 experiment 4 */
/* lab4_4.v */

/* Implement 5x3 Binary Mutliplier
 * You must use lab4_2 module in lab4_2.v
 * You cannot use fullAdder or halfAdder module directly
 * You may use keword "assign" and bitwise operator
 * or just implement with gate-level modeling*/
module lab4_4(
    input [4:0]in_a,
    input [2:0]in_b,
    output [7:0]out_m
    );

    ////////////////////////
    /* Add your code here */
    wire [4:0] shifted_input1;
    wire [4:0] partial_sum1;
    wire [4:0] shifted_input2;
    wire [4:0] partial_sum2;
    wire [4:0] partial_multiplicant1;
    wire [4:0] partial_multiplicant2;
    wire inm_c;
    
    // Shift 0th partial sum
    assign shifted_input1[4] = 0;
    assign shifted_input1[3] = in_a[4] & in_b[0];
    assign shifted_input1[2] = in_a[3] & in_b[0];
    assign shifted_input1[1] = in_a[2] & in_b[0];
    assign shifted_input1[0] = in_a[1] & in_b[0];
    assign out_m[0] = in_a[0] & in_b[0]; // Assign output
    
    // Assign multiplicant
    assign partial_multiplicant1[4] = in_a[4] & in_b[1];
    assign partial_multiplicant1[3] = in_a[3] & in_b[1];
    assign partial_multiplicant1[2] = in_a[2] & in_b[1];                                              
    assign partial_multiplicant1[1] = in_a[1] & in_b[1];
    assign partial_multiplicant1[0] = in_a[0] & in_b[1];
    
    lab4_2 rippleAdder1(partial_multiplicant1, shifted_input1, 0, partial_sum1, inm_c); // Add partial sum
   
   // Shift partial sum
    assign shifted_input2[4] = inm_c;
    assign shifted_input2[3] = partial_sum1[4];
    assign shifted_input2[2] = partial_sum1[3];
    assign shifted_input2[1] = partial_sum1[2];
    assign shifted_input2[0] = partial_sum1[1];
    assign out_m[1] = partial_sum1[0]; // Assign output
    
    // Assign multiplicant
    assign partial_multiplicant2[4] = in_a[4] & in_b[2];
    assign partial_multiplicant2[3] = in_a[3] & in_b[2];
    assign partial_multiplicant2[2] = in_a[2] & in_b[2];
    assign partial_multiplicant2[1] = in_a[1] & in_b[2];
    assign partial_multiplicant2[0] = in_a[0] & in_b[2];
    
    lab4_2 rippleAdder2(partial_multiplicant2, shifted_input2, 0, partial_sum2, out_m[7]); // Add partial sum
    
    // Assign outputs
    assign out_m[6] = partial_sum2[4];
    assign out_m[5] = partial_sum2[3];
    assign out_m[4] = partial_sum2[2];
    assign out_m[3] = partial_sum2[1];
    assign out_m[2] = partial_sum2[0];
    ////////////////////////
    
endmodule