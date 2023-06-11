/* CSED273 Final project */

`timescale 1ns / 1ps

module Counter(
    input is_pressed,
    input reset,
    input clk,
    output reg [2:0] q
    );
    /*
    The counter that counts length of input word

    :input clk: clock, 1 when keypad button(except star button) pressed, 0 when not   
    :input reset: 
    :input is_star_pressed: 1 when star button pressed, 0 when not
    :output reg [2:0] q: binary number count
    
    Initialize itself at start
    Initialized when is_star_pressed is 1
    Initialized when positive edge of reset

    Synchronous module
    */
    
    integer counter;
    reg press;
    reg is_pressed_prev;
    
    // Initialize when FPGA turned on
    initial begin
        q[2:0] = 3'b000;
        counter = 0;
        press = 1'b0;
        is_pressed_prev = 1'b0;
    end
    
    always @(posedge clk) begin
        is_pressed_prev <= is_pressed;
        if(is_pressed & (~is_pressed_prev)) begin
            press<=1'b1;
        end
    end
    
    always @(negedge clk or posedge reset) begin // When keypad 
        if(reset) begin
            q[2:0] = 3'b000;
        end
        else begin
            counter = counter + 1;
            if(counter === 60000) begin
                counter = 0;
                if(press === 1'b1) begin
                    q[0] = ~q[0] | q[2] & q[1] & q[0];
                    q[1] = q[1] ^ q[0] | q[2] & q[1] & q[0];
                    q[2] = q[2] | q[1] & q[0];
                    press = 1'b0;
                end
            end
        end
    end
endmodule