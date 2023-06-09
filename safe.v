/* CSED273 Final project */

`timescale 1ns / 1ps

module safe(
    input row1, row2, row3, row4, col1, col2, col3,
    input reset_password, initialize,
    output [5:0] password_led,
    output wire [2:0] state
);
    /*
    
    
    */
    reg is_on;
    wire is_pressed;
    wire [3:0] bcd;
    reg correct;
    reg correct1, correct2;
    wire _correct;
    wire is_star_pressed;
    wire is_sharp_pressed;

    initial begin
        is_on <= 1'b0;
        correct <= 1'b0;
    end

 // Detect Key press
    assign is_star_pressed = row4 & col1;
    assign is_sharp_pressed = row4 & col3;
    assign is_pressed = (col1 | col2 | col3) & ~(row4 & col1) & ~(row4 & col3);

    // 
    always @(posedge is_star_pressed or posedge is_sharp_pressed) begin    
        if(is_sharp_pressed) begin
            is_on <= ~is_on;
            correct <= _correct;
        end
        else begin
            correct <= _correct;
        end
    end

    // Convert pressed keypad row column to 8421 BCD code
    KeypadToBcdEncoder keypad_to_bcd(row1, row2, row3, row4, col1, col2, col3, bcd);

    // Compare input word and answer word
    Comparator comparator(bcd, is_star_pressed, reset_password, initialize, is_on, is_pressed, _correct, password_led);
    
    // Determine current machines states
    StateManager state_manager(is_on, is_star_pressed, reset_password, correct, initialize, state);

endmodule

