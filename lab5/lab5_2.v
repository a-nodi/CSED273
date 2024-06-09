/* CSED273 lab5 experiment 2 */
/* lab5_2.v */

`timescale 1ns / 1ps

/* Implement srLatch */
module srLatch(
    input s, r,
    output q, q_
    );
    
    ////////////////////////
    /* Add your code here */
    assign q = ~(q_ & s);
    assign q_ = ~(q & r);
    
    ////////////////////////

endmodule

/* Implement master-slave JK flip-flop with srLatch module */
module lab5_2(
    input reset_n, j, k, clk,
    output q, q_
    );

    ////////////////////////
    /* Add your code here */
    wire j_clk1, k_clk1;
    wire _q, _q_;
    wire j_clk2, k_clk2;
    
    assign j_clk1 = ~(j & clk & q_);
    assign k_clk1 = ~(k & clk & q);
    
    srLatch SRLatch1(j_clk1, k_clk1 & reset_n, _q, _q_);
    assign j_clk2 = ~(_q & ~clk);
    assign k_clk2 = ~(_q_ & ~clk);
    
    srLatch SRLatch2(j_clk2, k_clk2 & reset_n, q, q_);
    ////////////////////////
    
endmodule

module lab5_2_1(
    input reset_n, j, k, clk,
    output q, q_
    );

    ////////////////////////
    /* Add your code here */
    wire j_clk1, k_clk1;
    wire _q, _q_;
    wire j_clk2, k_clk2;
    
    assign j_clk1 = ~(j & clk);
    assign k_clk1 = ~(k & clk);
    
    srLatch SRLatch1(j_clk1, k_clk1  & reset_n, _q, _q_);
    assign j_clk2 = ~(_q & ~clk);
    assign k_clk2 = ~(_q_ & ~clk);
    
    srLatch SRLatch2(j_clk2, k_clk2 & reset_n, q, q_);
    ////////////////////////
    
endmodule