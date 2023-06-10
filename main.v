`timescale 1ns / 1ps

module main (
    input clk,
    output reg [3:0] row,
    input [2:0] col,
    input ResetPW,                          //비밀번호 재설정 버튼 
    input init,                             //모두 초기화 버튼
    output [3:0] ssSel,                     //7-segment 4개를 각각 표현
    output [7:0] ssDisp,                    //7-segment (8개인 이유는 하나는 점. 표시)
    output reg [15:0] led            //버튼 한 개 누를때마다 led 하나씩 on
    //output reg [2:0] state_               //테스트벤치 디버깅용
);

    reg [31:0] counter;
    reg [31:0] counter2;
    reg [15:0] gbuf;                        //gbuf[3:0] 는 첫번째(가장 오른쪽) 7-segment의 숫자를 이진수로 저장, gbuf[7:4]은 두번째 ...
    wire [2:0] state_;                        //state : 000(off) 001(on) 010(wrong1) 011(wrong2) 100(open) 101(reset) 110(lock)
    wire [5:0] password_;                     //비밀번호는 최대 6자리
    wire [3:0] row_;
    reg [1:0] rowSel;

    initial begin
        counter <= 0;
        counter2 <= 0;
        gbuf <= 16'b1111111111111111;
        led <= 16'b0000000000000000;
        row <= 4'b0001;
        rowSel <= 2'b00;
    end
/*
    always @ (state) begin                  //테ㅡㅅ트벤치 디버깅용
        state_ = state;
    end
*/

    assign row_ = row;

    safe safe (
        .row1(row_[0]),
        .row2(row_[1]),
        .row3(row_[2]),
        .row4(row_[3]),
        .col1(col[0]),
        .col2(col[1]),
        .col3(col[2]),
        .reset_password(ResetPW),
        .initialize(init),
        .password_led(password_),
        .state(state_)
    );

    always @(negedge clk) begin
        counter2 <= counter2 + 1;
        if(counter2 === 1000000) begin
            counter2 <= 0;
            case (rowSel)
            2'b00:
            begin
                rowSel <= 2'b01;
            end
            2'b01:
            begin
                rowSel <= 2'b10;
            end
            2'b10:
            begin
                rowSel <= 2'b11;
            end
            2'b11:
            begin
                rowSel <= 2'b00;
            end
            endcase
        end
    end
    
    _1to4DeMUX demux(
        .sel(rowSel),
        .data(col[0] | col[1] | col[2]),
        .out(row)
    );

    always @(password_) begin
        led <= 16'b0000000000000000;
        led[15] <= password_[5];                         //가장 왼쪽 led를 비밀번호 중 가장 먼저 눌린 수(password[5])에 mapping
        led[14] <= password_[4];
        led[13] <= password_[3];
        led[12] <= password_[2];
        led[11] <= password_[1];
        led[10] <= password_[0];
    end

    
    always @(state_) begin
        case (state_)
            0:
            begin
                led[6:0] <= 7'b0000001;
            end
            1:
            begin
                led[6:0] <= 7'b0000010;                    //state 1은 남은기회 3이므로 3을 표현해야 함. (3은 0011과 match)
            end
            2:
            begin
                led[6:0] <= 7'b0000100;
            end
            3:
            begin
                led[6:0] <= 7'b0001000;
            end
            4:
            begin
                led[6:0] <= 7'b0010000;
            end
            5:
            begin
                led[6:0] <= 7'b0100000;
            end
            7:
            begin
                led[6:0] <= 7'b1000000;
            end
        endcase 
    end


    Seg7Renderer renderer (
        .gbuf(gbuf),
        .clk(clk),
        .segSel(ssSel),
        .seg(ssDisp)
    );

    always @(posedge clk) begin
        case (state_)
            0:
            begin
                gbuf[3:0]   <= 4'b1111;                     //state 0은 off이므로 아무것도 켜지면 안됨.(아래 코드표에서 off는 1111에 matched)
                gbuf[7:4]   <= 4'b1111;
                gbuf[11:8]  <= 4'b1111;
                gbuf[15:12] <= 4'b1111;
            end
            1:
            begin
                gbuf[3:0]   <= 4'b0011;                     //state 1은 남은기회 3이므로 3을 표현해야 함. (3은 0011과 match)
                gbuf[7:4]   <= 4'b1111;
                gbuf[11:8]  <= 4'b1111;
                gbuf[15:12] <= 4'b1111;
            end
            2:
            begin
                gbuf[3:0]   <= 4'b0010;
                gbuf[7:4]   <= 4'b1111;
                gbuf[11:8]  <= 4'b1111;
                gbuf[15:12] <= 4'b1111;
            end
            3:
            begin
                gbuf[3:0]   <= 4'b0001;
                gbuf[7:4]   <= 4'b1111;
                gbuf[11:8]  <= 4'b1111;
                gbuf[15:12] <= 4'b1111;
            end
            4:
            begin
                gbuf[3:0]   <= 4'b0110;
                gbuf[7:4]   <= 4'b0101;
                gbuf[11:8]  <= 4'b0100;
                gbuf[15:12] <= 4'b0000;
            end
            5:
            begin
                gbuf[3:0]   <= 4'b1011;
                gbuf[7:4]   <= 4'b0110;
                gbuf[11:8]  <= 4'b1101;
                gbuf[15:12] <= 4'b1100;
            end
            7:
            begin
                gbuf[3:0]   <= 4'b1010;
                gbuf[7:4]   <= 4'b1001;
                gbuf[11:8]  <= 4'b1000;
                gbuf[15:12] <= 4'b0111;
            end
        endcase
    end
endmodule

module Seg7Renderer (
    input [15:0] gbuf,
    input clk,
    output reg [3:0] segSel,
    output reg [7:0] seg
);
    integer counter;
    wire [7:0] res0_, res1_, res2_, res3_;

    initial begin
        counter <= 0;
        segSel <= 14;           // 1110, 첫번째(가장 오른쪽) segment를 의미
        seg <= 8'b11111111;
    end

    bcd_to_7seg pos0 (              // code(4bit) -> 7seg(8bit) 로 변환 후 seg에 저장
        .bcd(gbuf[3:0]),
        .seg(res0_)
    );
    bcd_to_7seg pos1 (
        .bcd(gbuf[7:4]),
        .seg(res1_)
    );
    bcd_to_7seg pos2 (
        .bcd(gbuf[11:8]),
        .seg(res2_)
    );
    bcd_to_7seg pos3 (
        .bcd(gbuf[15:12]),
        .seg(res3_)
    );

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == 1000000) begin                    //= 0.1초
            counter <= 0;
            case (segSel)
                4'b1110: begin                               // 1110
                    segSel <= 4'b1101;                       // 1101 (두번째 segment로 옮겨줌)
                    seg <= res1_;                        // 두번째 segment에 해당하는 res1을 seg에 저장         
                end
                4'b1101: begin
                    segSel <= 4'b1011;
                    seg <= res2_;
                end
                4'b1011: begin
                    segSel <= 4'b0111;
                    seg <= res3_;
                end
                4'b0111: begin
                    segSel <= 4'b1110;
                    seg <= res0_;
                end
            endcase
        end
    end
endmodule

module bcd_to_7seg (
    input [3:0] bcd,
    output reg [7:0] seg
);
    always @(bcd) begin
        // dot, center, tl, bl, b, br, tr, t
        case (bcd)
            4'b0000: seg <= 8'b11000000; // 0, O        
            4'b0001: seg <= 8'b11111001; // 1
            4'b0010: seg <= 8'b10100100; // 2
            4'b0011: seg <= 8'b10110000; // 3
            4'b0100: seg <= 8'b10001100; // 4 => P
            4'b0101: seg <= 8'b10000110; // 5 => E
            4'b0110: seg <= 8'b10101011; // 6 => n
            4'b0111: seg <= 8'b10001110; // 7 => F
            4'b1000: seg <= 8'b10001000; // 8 => A
            4'b1001: seg <= 8'b11001111; // 9 => I
            4'b1010: seg <= 8'b11000111; // 10 => L
            4'b1011: seg <= 8'b11000010; // 11 => g
            4'b1100: seg <= 8'b11000110; // 12 => C
            4'b1101: seg <= 8'b10001011; // 13 => h
            4'b1111: seg <= 8'b11111111; // 15 => off
            default: seg <= 8'b11111111;
        endcase
    end
endmodule

module _1to4DeMUX(
    input [1:0] sel,
    input data,
    output [3:0] out
);
    assign out[0] = data & ~sel[1] & ~sel[0];
    assign out[1] = data & ~sel[1] & sel[0];
    assign out[2] = data & sel[1] & ~sel[0];
    assign out[3] = data & sel[1] & sel[0];
endmodule 
