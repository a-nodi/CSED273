/* CSED273 lab6 experiment 1 */
/* lab6_1.v */

`timescale 1ps / 1fs

/* Implement synchronous BCD decade counter (0-9)
 * You must use JK flip-flop of lab6_ff.v */
module decade_counter(input reset_n, input clk, output [3:0] count);

    ////////////////////////
    /* Add your code here */
    
    wire j_a, j_b, j_c, j_d;
    wire k_a, k_b, k_c, k_d;
    assign j_a = count[2] & count[1] & count[0];
    assign k_a = count[0];
    edge_trigger_JKFF bit1(reset_n, j_d, k_d, clk, count[0]); // BCD counter (LSB)
    assign j_b = count[1] & count[0];
    assign k_b = count[1] & count[0];
    edge_trigger_JKFF bit2(reset_n, j_c, k_c, clk, count[1]); // BCD counter
    assign j_c = (~count[3]) & count[0];
    assign k_c = count[0];
    edge_trigger_JKFF bit3(reset_n, j_b, k_b, clk, count[2]); // BCD counter
    assign j_d = 1;
    assign k_d = 1;
    edge_trigger_JKFF bit4(reset_n, j_a, k_a, clk, count[3]); // BCD counter (MSB)
    ////////////////////////
	
endmodule