/* CSED273 lab6 experiment 3 */
/* lab6_3.v */

`timescale 1ps / 1fs

/* Implement 369 game counter (0, 3, 6, 9, 13, 6, 9, 13, 6 ...)
 * You must first implement D flip-flop in lab6_ff.v
 * then you use D flip-flop of lab6_ff.v */
module counter_369(input reset_n, input clk, output [3:0] count);

    ////////////////////////
    /* Add your code here */
    wire d_a, d_b, d_c, d_d;
    assign d_a = count[3] & (~count[2]) | count[1] & (~count[0]); 
    edge_trigger_D_FF D(reset_n, d_d, clk, count[0]);
    assign d_b = count[0];
    edge_trigger_D_FF C(reset_n, d_c, clk, count[1]);
    assign d_c = count[3] & count[2] | (~count[3]) & (~count[2]);
    edge_trigger_D_FF B(reset_n, d_b, clk, count[2]);
    assign d_d = ~count[0] | count[3] & (~count[2]);
    edge_trigger_D_FF A(reset_n, d_a, clk, count[3]);
    ////////////////////////
	
endmodule
