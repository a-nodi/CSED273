/* CSED273 Final project */

`timescale 1ns / 1ps

module StateManager(
    input is_on, is_star_pressed, reset, correct, initialize,
    input clk,
    output reg [2:0] state
);
    integer counter;

    reg [4:0] _input;
    reg [4:0] befo_input;
    reg star_prev;
    reg star;

    initial begin
        counter = 0;
        state = 3'b000;
        befo_input = 5'b00000;
        star_prev=1'b0;
        star=1'b0;
    end
    
    always @(posedge clk) begin
        star_prev <= is_star_pressed;
        if(is_star_pressed & (~star_prev)) begin
            star<=1'b1;
        end
    end
            

    always @(negedge clk) begin
        counter = counter + 1;
        if(counter === 50000) begin
            counter = 0;
            _input[4] = is_on;                                             //#이 눌릴때가 1, 안눌릴때가 0이 아니라, 한번 눌렀다 떼면 1, 다시 눌렀다 뗴면 0 (reg)
            _input[3] = star;                                   //* 이 눌린상태가 1 안눌리면 0 (wire)
            _input[2] = reset;                                             //재설정 버튼이 눌린상태가 1, 안눌리면 0 (wire)
            _input[1] = correct;                                           //correct인 상태는 1, 아니면 0 (reg)
            _input[0] = initialize;                                        //초기화 버튼이 눌린상태가 1, 안눌리면 0 (wire)
            if(_input !== befo_input) begin
                befo_input = _input;
                // State = 000
                if (_input[0] === 1'b1) begin                                  //언제든지 초기화가 눌리면 off(000)으로
                    state = 3'b000; end 
                else if (state === 3'b000 && _input[4] == 1'b1) begin         //off일때 is_on이 1이 되면-> on(001) 으로 
                    state = 3'b001; end
                else if (state === 3'b001 && _input[4] == 1'b0) begin         //on일때 is_on이 0이되면-> 다시 off(000) 으로
                    state = 3'b000; end
                else if (state === 3'b001 && _input == 5'b11010) begin         //on일때 재설정, 초기화가 0이고, correct가 1인 상태에서 *이 눌리면 -> answer(100)으로
                    state = 3'b100; 
                    star = 1'b0; end
                else if (state === 3'b001 && _input == 5'b11000) begin         //on일때 재설정, 초기화가 0이고, correct도 0인 상태에서 *이 눌리면 -> wrong1(010)으로
                    state = 3'b010;
                    star = 1'b0; end
                else if (state === 3'b010 && _input == 5'b11010) begin         //wrong1일때 재설정, 초기화가 0이고, correct가 1인 상태에서 *이 눌리면 -> answer(100)으로
                    state = 3'b100;
                    star = 1'b0; end
                else if (state === 3'b010 && _input == 5'b11000) begin        //wrong1일때 재설정, 초기화가 0이고, correct도 0인 상태에서 *이 눌리면 -> wrong2(011)으로
                    state = 3'b011;
                    star = 1'b0; end
                else if (state === 3'b011 && _input == 5'b11010) begin        //wrong2일때 재설정, 초기화가 0이고, correct가 1인 상태에서 *이 눌리면 -> answer(100) 으로
                    state = 3'b100;
                    star = 1'b0; end
                else if (state === 3'b011 && _input == 5'b11000) begin         //wrong2일때 재설정, 초기화가 0이고, correct도 0인 상태에서 *이 눌리면 -> lock(111) 으로
                    state = 3'b111;
                    star = 1'b0; end
                else if (state ===3'b100 && _input == 5'b101x0) begin          //open 일때 reset이 눌리면 -> reset(101)으로
                    state = 3'b101; end
                else if (state === 3'b101 && _input == 5'b11010) begin         //reset 일때 correct가 1인 상태(reset 상태일때 correct는 새로운 번호가 4개 이상 입력되었는지를 의미한다.)에서 *이 눌리면 -> off(000) 으로
                    state = 3'b000;
                    star = 1'b0; end
            end
        end
        
        // 000-off  001-on  010-wrong1  011-wrong2  100-answer  101-reset   111-lock

    end



endmodule