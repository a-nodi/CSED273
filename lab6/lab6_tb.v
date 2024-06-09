/* CSED273 lab6 experiments */
/* lab6_tb.v */

`timescale 1ps / 1fs

module lab6_tb();

    integer Passed;
    integer Failed;

    /* Define input, output and instantiate module */
    ////////////////////////
    /* Add your code here */
    
    // define i/o
    integer i;
    reg [3:0] expected_count;
    reg [7:0] expected_count_2digit;
    reg [3:0] expected_count_369;
    reg reset_n;
    reg clk;
    wire [3:0] count;
    wire [7:0] count_2digit;
    wire [3:0] count_369;
    
    // instatiate module
    decade_counter DecadeCounter(
        .reset_n(reset_n),
        .clk(clk),
        .count(count)
    );
    
    decade_counter_2digits DecadeCounter2Digits(
        .reset_n(reset_n),
        .clk(clk),
        .count(count_2digit)
    );
    
    counter_369 Counter369(
        .reset_n(reset_n),
        .clk(clk),
        .count(count_369)
    );
    ////////////////////////

    initial begin
        Passed = 0;
        Failed = 0;

        lab6_1_test;
        lab6_2_test;
        lab6_3_test;

        $display("Lab6 Passed = %0d, Failed = %0d", Passed, Failed);
        $finish;
    end

    /* Implement test task for lab6_1 */
    task lab6_1_test;
        ////////////////////////
        /* Add your code here */
        begin
            // init
            expected_count = 4'b0000;
            clk = 0;
            reset_n = 0;
            $display("lab6_1test");
            $display("reset");
            #5 reset_n = 1;
            
            for (i = 0; i < 22; i = i + 1) begin
                #5 clk = ~clk; // count pulse
                if (clk === 0) begin // count at negative edge
                    if(count === expected_count) begin // If correct
                        Passed = Passed + 1;
                    end
                    else begin // If not correct
                        $display("Error) count:%0b (Ans: %0b)", count, expected_count);
                        Failed = Failed + 1;
                    end
                    expected_count = (expected_count + 4'b0001) % 4'b1010; // count up
                end
            end 
        end
        ////////////////////////
    endtask

    /* Implement test task for lab6_2 */
    task lab6_2_test;
        ////////////////////////
        /* Add your code here */
        begin
            //init
            expected_count_2digit = 8'b00000000;
            clk = 0;
            reset_n = 0;
            $display("lab6_2test");
            $display("reset");
            // Reset
            #5 clk = ~clk;
            #5 clk = ~clk;
            #5 reset_n = 1;
            for (i = 0; i < 202; i = i + 1) begin
                #5 clk = ~clk; // count pulse
                if (clk === 0) begin // count at negative edge
                    if(count_2digit === expected_count_2digit) begin // If correct
                        Passed = Passed + 1;
                    end
                    else begin // If not correct
                        $display("Error) count_2digit:%0b (Ans: %0b)", count_2digit, expected_count_2digit);
                        Failed = Failed + 1;
                    end
                    expected_count_2digit = (expected_count_2digit + 8'b00000001) % 8'b10011010; // count up
                    if (expected_count_2digit[3:0] == 4'b1010)  expected_count_2digit = (expected_count_2digit + 8'b00000110) % 8'b10011010; // count up (case last digit 9)
                end
            end 
        end
        ////////////////////////
    endtask

    /* Implement test task for lab6_3 */
    task lab6_3_test;
        ////////////////////////
        /* Add your code here */
        begin
            // init
            expected_count_369 = 4'b0000;
            clk = 0;
            reset_n = 0;
            $display("lab6_3test");
            $display("reset");
            #5 reset_n = 1;
            for (i = 0; i < 19; i = i + 1) begin
                #5 clk = ~clk; // count pulse
                if (clk === 0) begin // count at negative edge
                    if(count_369 === expected_count_369) begin // If correct
                        Passed = Passed + 1;
                    end
                    else begin // If not correct
                        $display("Error) count_2digit:%0b (Ans: %0b)", count_369, expected_count_369);
                        Failed = Failed + 1;
                    end
                    // 369 Counter state transition
                    if(expected_count_369 == 4'b0000) expected_count_369 = 4'b0011;
                    else if(expected_count_369 == 4'b0011) expected_count_369 = 4'b0110;
                    else if(expected_count_369 == 4'b0110) expected_count_369 = 4'b1001;
                    else if(expected_count_369 == 4'b1001) expected_count_369 = 4'b1101;
                    else if(expected_count_369 == 4'b1101) expected_count_369 = 4'b0110;
                end
            end 
        end
        ////////////////////////
    endtask

endmodule