/* CSED273 lab1 experiment 2_ii */
/* lab1_2_ii.v */


/* Implement OR with {AND, NOT}
 * You are only allowed to wire modules together */
module lab1_2_ii(outOR, inA, inB);
    output wire outOR;
    input wire inA, inB;
    
    ////////////////////////
    /* Add your code here */
    not(A1, inA);
    not(B1, inB);
    and(z, A1, B1);
    not(outOR, z);
    ////////////////////////

endmodule