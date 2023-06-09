/* CSED273 Final project */

`timescale 1ns / 1ps

module PasswordLedManager(
    input [2:0] count,
    output [5:0] is_led_on
);
    assign is_led_on[0] = count[2] | count[1] | count[0];
    assign is_led_on[1] = count[2] | count[1];
    assign is_led_on[2] = count[2] | count[1] & count[0];
    assign is_led_on[3] = count[2];
    assign is_led_on[4] = count[2] & count[1] | count[2] & count[0];
    assign is_led_on[5] = count[2] & count[1];

endmodule