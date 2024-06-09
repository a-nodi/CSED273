/* CSED273 lab5 experiment 1 */
/* lab5_1.v */

`timescale 1ps / 1fs

/* Implement adder 
 * You must not use Verilog arithmetic operators */
module adder(
    input [3:0] x,
    input [3:0] y,
    input c_in,             // Carry in
    output [3:0] out,
    output c_out            // Carry out
); 

    ////////////////////////
    /* Add your code here */
    /* Implementing Carry Lookahead Adder*/
    wire p0, p1, p2, p3;
    wire g0, g1, g2, g3;
    wire c1, c2, c3;
    
    // Calculate 0th bit
    assign p0 = x[0] ^ y[0];
    assign g0 = x[0] & y[0];
    assign out[0] = p0 ^ c_in;
    assign c1 = g0 | p0 & c_in;
    
    // Calculate 1st bit
    assign p1 = x[1] ^ y[1];
    assign g1 = x[1] & y[1];
    assign out[1] = p1 ^ c1;
    assign c2 = g1 | p1 & c1;
    
    // Calculate 2nd bit
    assign p2 = x[2] ^ y[2];
    assign g2 = x[2] & y[2];    
    assign out[2] = p2 ^ c2;
    assign c3 = g2 | p2 & c2;
    
    // Calculate 3rd bit
    assign p3 = x[3] ^ y[3];
    assign g3 = x[3] & y[3];
    assign out[3] = p3 ^ c3;
    assign c_out = g3 | p3 & c3;
    
    ////////////////////////

endmodule

/* Implement arithmeticUnit with adder module
 * You must use one adder module.
 * You must not use Verilog arithmetic operators */
module arithmeticUnit(
    input [3:0] x,
    input [3:0] y,
    input [2:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    ////////////////////////
    /* Add your code here */
    wire [3:0] a;
    wire [3:0] adder_wire;
    wire [3:0] adder_not_wire;
    
    // Implement A3 input of adder
    assign adder_wire[3] = y[3] & select[1];
    assign adder_not_wire[3] = (~y[3]) & select[2]; 
    assign a[3] = adder_wire[3] | adder_not_wire[3];
    
    // Implement A2 input of adder
    assign adder_wire[2] = y[2] & select[1];
    assign adder_not_wire[2] = (~y[2]) & select[2]; 
    assign a[2] = adder_wire[2] | adder_not_wire[2];
    
    // Implement A1 input of adder
    assign adder_wire[1] = y[1] & select[1];
    assign adder_not_wire[1] = (~y[1]) & select[2]; 
    assign a[1] = adder_wire[1] | adder_not_wire[1];
    
    // Implement A0 input of adder
    assign adder_wire[0] = y[0] & select[1];
    assign adder_not_wire[0] = (~y[0]) & select[2]; 
    assign a[0] = adder_wire[0] | adder_not_wire[0];
    
    adder Adder(x, a, select[0], out, c_out); // Operate Addition to do arithmetic operation
    ////////////////////////

endmodule

/* Implement 4:1 mux */
module mux4to1(
    input [3:0] in,
    input [1:0] select,
    output out
);

    ////////////////////////
    /* Add your code here */
    wire [3:0] out_wire; // Wires that will be inputs of OR gate in mux's last level
    
    // Selection
    assign out_wire[3] = in[3] & select[1] & select[0];
    assign out_wire[2] = in[2] & select[1] & (~select[0]);
    assign out_wire[1] = in[1] & (~select[1]) & select[0];
    assign out_wire[0] = in[0] & (~select[1]) & (~select[0]);
    
    // Concatenate wires
    assign out = out_wire[3] | out_wire[2] | out_wire[1] | out_wire[0];
    ////////////////////////

endmodule

/* Implement logicUnit with mux4to1 */
module logicUnit(
    input [3:0] x,
    input [3:0] y,
    input [1:0] select,
    output [3:0] out
);

    ////////////////////////
    /* Add your code here */
    wire [3:0] in3;
    wire [3:0] in2;
    wire [3:0] in1;
    wire [3:0] in0;
    
    assign in3[3] = ~x[3];
    assign in3[2] = x[3] ^ y[3];
    assign in3[1] = x[3] | y[3];
    assign in3[0] = x[3] & y[3];
    
    assign in2[3] = ~x[2];
    assign in2[2] = x[2] ^ y[2];
    assign in2[1] = x[2] | y[2];
    assign in2[0] = x[2] & y[2];
    
    assign in1[3] = ~x[1];
    assign in1[2] = x[1] ^ y[1];
    assign in1[1] = x[1] | y[1];
    assign in1[0] = x[1] & y[1];
    
    assign in0[3] = ~x[0];
    assign in0[2] = x[0] ^ y[0];
    assign in0[1] = x[0] | y[0];
    assign in0[0] = x[0] & y[0];
    
    mux4to1 Mux4to1_3(in3, select[1:0], out[3]);
    mux4to1 Mux4to1_2(in2, select[1:0], out[2]);
    mux4to1 Mux4to1_1(in1, select[1:0], out[1]);
    mux4to1 Mux4to1_0(in0, select[1:0], out[0]);
    
    ////////////////////////

endmodule

/* Implement 2:1 mux */
module mux2to1(
    input [1:0] in,
    input  select,
    output out
);

    ////////////////////////
    /* Add your code here */
    
    assign out = select & in[1] | (~select) & in[0];
    ////////////////////////

endmodule

/* Implement ALU with mux2to1 */
module lab5_1(
    input [3:0] x,
    input [3:0] y,
    input [3:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    ////////////////////////
    /* Add your code here */
    
    // Arithmetic unit and logic unit output
    wire [3:0] arithmetic;
    wire [3:0] logic;
    
    // operate arithmetic
    arithmeticUnit ArithmeticUnit(x, y, select[2:0], arithmetic, c_out);
    logicUnit LogicUnit(x, y, select[1:0], logic);
    
    // Mux inputs
    wire [1:0] mux_input3;
    wire [1:0] mux_input2;
    wire [1:0] mux_input1;
    wire [1:0] mux_input0;
    
    // Re-concanate wires to mux
    assign mux_input3[1] = logic[3];
    assign mux_input3[0] = arithmetic[3];
    
    assign mux_input2[1] = logic[2];
    assign mux_input2[0] = arithmetic[2];
    
    assign mux_input1[1] = logic[1];
    assign mux_input1[0] = arithmetic[1];
    
    assign mux_input0[1] = logic[0];
    assign mux_input0[0] = arithmetic[0];
    
    // Select output
    mux2to1 Mux2to1_3(mux_input3, select[3], out[3]);
    mux2to1 Mux2to1_2(mux_input2, select[3], out[2]);
    mux2to1 Mux2to1_1(mux_input1, select[3], out[1]);
    mux2to1 Mux2to1_0(mux_input0, select[3], out[0]);
    
    ////////////////////////

endmodule
