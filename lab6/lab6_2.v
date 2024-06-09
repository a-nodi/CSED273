/* CSED273 lab6 experiment 2 */
/* lab6_2.v */

`timescale 1ps / 1fs

/* Implement 2-decade BCD counter (0-99)
 * You must use decade BCD counter of lab6_1.v */
module decade_counter_2digits(input reset_n, input clk, output [7:0] count);

    ////////////////////////
    /* Add your code here */
    wire cp;
    decade_counter DecadeCounter1(reset_n, clk, count[3:0]); // 
    assign cp = count[3] | ~reset_n & clk; // To reset Decade counter2, the negative edge of clk have to be occured(the part ~reset_n & clk)
    decade_counter DecadeCounter2(reset_n, cp, count[7:4]);
    ////////////////////////
	
endmodule
