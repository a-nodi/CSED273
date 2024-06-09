/* CSED273 lab3 experiment 1 */
/* lab3_1.v */


/* Active Low 2-to-4 Decoder
 * You must use this module to implement Active Low 4-to-16 decoder */
module decoder(
    input wire en,
    input wire [1:0] in,
    output wire [3:0] out 
    );

    nand(out[0], ~in[0], ~in[1], ~en);
    nand(out[1],  in[0], ~in[1], ~en);
    nand(out[2], ~in[0],  in[1], ~en);
    nand(out[3],  in[0],  in[1], ~en);

endmodule


/* Implement Active Low 4-to-16 Decoder
 * You may use keword "assign" and operator "&","|","~",
 * or just implement with gate-level modeling (and, or, not) */
module lab3_1(
    input wire en,
    input wire [3:0] in,
    output wire [15:0] out
    );

    ////////////////////////
    /* Add your code here */
    wire [3:0] level1_out; // Output of level 1 decoder
    decoder level1_decoder(en, in[3:2], level1_out[3:0]); // Get output of level 1 decoder
    
    decoder level2_decoder1(level1_out[3], in[1:0], out[15:12]); // Get partial output(from 15 to 12)
    decoder level2_decoder2(level1_out[2], in[1:0], out[11:8]); // Get partial output(from 11 to 8)
    decoder level2_decoder3(level1_out[1], in[1:0], out[7:4]); // Get partial output(from 7 to 4)
    decoder level2_decoder4(level1_out[0], in[1:0], out[3:0]); // Get partial output(from 3 to 0)
   
    ////////////////////////

endmodule
