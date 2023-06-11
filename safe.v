/* CSED273 Final project */

`timescale 1ns / 1ps

module safe(
    input row1, row2, row3, row4, col1, col2, col3,
    input reset_password, initialize, clk,
    output [5:0] password_led,
    output [2:0] state,
    output pressed_
);
    integer counter1;
    integer counter2;
    reg is_on;
    reg [3:0] is_pressed;
    wire [3:0] bcd_;
    reg correct;
    reg correct1, correct2;
    wire _correct_;
    reg is_star_pressed;
    reg is_sharp_pressed;

    initial begin
        is_on <= 1'b0;
        correct <= 1'b0;
        is_pressed <= 4'b0000;
        is_star_pressed <= 1'b0;
        is_sharp_pressed <= 1'b0;
        correct <= 1'b0;
        correct1 <= 1'b0;
        correct2 <= 1'b0;
        counter1 <= 0;
        counter2 <= 0;
    end
    

    always @(posedge clk) begin
        counter1 <= counter1 + 1;
        if(counter1 === 500000) begin
            counter1 <= 0;
            if(row4 === 1'b1) begin
                if(col1 !== is_star_pressed) begin
                    is_star_pressed <= col1;
                end
                else if(col3 !== is_sharp_pressed) begin
                    is_sharp_pressed <= col3;
                end
            end
        end
    end
    
    wire col_pressed_;
    assign col_pressed_ = col1 | col2 | col3;

    // Detect Key press
    always @(negedge clk) begin
        counter2 <= counter2 + 1;
        if(counter2 === 500000) begin
            counter2 <= 0;
            if(row1 === 1'b1) begin
                if(is_pressed[0] !== col_pressed_) begin
                    is_pressed[0] <= col_pressed_;
                end
            end
            else if(row2 === 1'b1) begin
                if(is_pressed[1] !== col_pressed_) begin
                    is_pressed[1] <= col_pressed_;
                end
            end
            else if(row3 === 1'b1) begin
                if(is_pressed[2] !== col_pressed_) begin
                    is_pressed[2] <= col_pressed_;
                end
            end
            else if(row4 === 1'b1) begin
                if(is_pressed[3] !== col2) begin
                    is_pressed[3] <= col2;
                end
            end
        end
    end

    assign pressed_ = is_pressed[0] | is_pressed[1] | is_pressed[2] | is_pressed[3];

    // 
    always @(posedge (is_star_pressed | is_sharp_pressed)) begin    
        correct <= _correct_;
    end

    always @(posedge (is_sharp_pressed | initialize)) begin
        is_on <= ~initialize & ~is_on;
    end

    // Convert pressed keypad row column to 8421 BCD code
    KeypadToBcdEncoder keypad_to_bcd(row1, row2, row3, row4, col1, col2, col3, bcd_);

    // Compare input word and answer word
    Comparator comparator(bcd_, is_star_pressed, reset_password, initialize, is_on, pressed_, _correct_, password_led);
    
    // Determine current machines states
    StateManager state_manager(is_on, is_star_pressed, reset_password, correct, initialize, clk, state);

endmodule