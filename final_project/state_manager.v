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
    reg star_r;

    initial begin
        counter = 0;
        state = 3'b000;
        befo_input = 5'b00000;
        star_prev=1'b0;
        star=1'b0;
        star_r=1'b1;
    end
    
    always @(posedge clk) begin
        if(star_r === 1'b0) begin
            star <= 1'b0;
        end
        else begin
            star_prev <= is_star_pressed;
            if(is_star_pressed & (~star_prev)) begin
                star<=1'b1;
            end
        end
    end
            

    always @(negedge clk) begin
        counter = counter + 1;
        if(counter === 50000) begin
            star_r = 1'b1;
            counter = 0;
            _input[4] = is_on;                                             //#�� �������� 1, �ȴ������� 0�� �ƴ϶�, �ѹ� ������ ���� 1, �ٽ� ������ ��� 0 (reg)
            _input[3] = star;                                   //* �� �������°� 1 �ȴ����� 0 (wire)
            _input[2] = reset;                                             //�缳�� ��ư�� �������°� 1, �ȴ����� 0 (wire)
            _input[1] = correct;                                           //correct�� ���´� 1, �ƴϸ� 0 (reg)
            _input[0] = initialize;                                        //�ʱ�ȭ ��ư�� �������°� 1, �ȴ����� 0 (wire)
            if(_input !== befo_input) begin
                befo_input = _input;
                // State = 000
                if (_input[0] === 1'b1) begin                                  //�������� �ʱ�ȭ�� ������ off(000)����
                    state = 3'b000; 
                    star_r = 1'b0; end
                else if (state === 3'b000 && _input[4] == 1'b1) begin         //off�϶� is_on�� 1�� �Ǹ�-> on(001) ���� 
                    state = 3'b001;
                    star_r = 1'b0; end
                else if (state === 3'b001 && _input[4] == 1'b0) begin         //on�϶� is_on�� 0�̵Ǹ�-> �ٽ� off(000) ����
                    state = 3'b000; 
                    star_r = 1'b0; end
                else if (state === 3'b001 && _input == 5'b11010) begin         //on�϶� �缳��, �ʱ�ȭ�� 0�̰�, correct�� 1�� ���¿��� *�� ������ -> answer(100)����
                    state = 3'b100; 
                    star_r = 1'b0; end
                else if (state === 3'b001 && _input == 5'b11000) begin         //on�϶� �缳��, �ʱ�ȭ�� 0�̰�, correct�� 0�� ���¿��� *�� ������ -> wrong1(010)����
                    state = 3'b010;
                    star_r = 1'b0; end
                else if (state === 3'b010 && _input == 5'b11010) begin         //wrong1�϶� �缳��, �ʱ�ȭ�� 0�̰�, correct�� 1�� ���¿��� *�� ������ -> answer(100)����
                    state = 3'b100;
                    star_r = 1'b0; end
                else if (state === 3'b010 && _input == 5'b11000) begin        //wrong1�϶� �缳��, �ʱ�ȭ�� 0�̰�, correct�� 0�� ���¿��� *�� ������ -> wrong2(011)����
                    state = 3'b011;
                    star_r = 1'b0; end
                else if (state === 3'b011 && _input == 5'b11010) begin        //wrong2�϶� �缳��, �ʱ�ȭ�� 0�̰�, correct�� 1�� ���¿��� *�� ������ -> answer(100) ����
                    state = 3'b100;
                    star_r = 1'b0; end
                else if (state === 3'b011 && _input == 5'b11000) begin         //wrong2�϶� �缳��, �ʱ�ȭ�� 0�̰�, correct�� 0�� ���¿��� *�� ������ -> lock(111) ����
                    state = 3'b111;
                    star_r = 1'b0; end
                else if (state ===3'b100 && _input[4] == 1'b0) begin          //open �϶� is_on�� 0�� �Ǹ� -> off(000)����
                    state = 3'b000; 
                    star_r = 1'b0; end
                else if (state ===3'b100 && (_input == 5'b10110 || _input == 5'b10100)) begin          //open �϶� reset�� ������ -> reset(101)����
                    state = 3'b101; 
                    star_r = 1'b0; end
                else if (state === 3'b101 && _input == 5'b11010) begin         //reset �϶� correct�� 1�� ����(reset �����϶� correct�� ���ο� ��ȣ�� 4�� �̻� �ԷµǾ������� �ǹ��Ѵ�.)���� *�� ������ -> off(000) ����
                    state = 3'b001;
                    star_r = 1'b0; end
            end
        end
        
        // 000-off  001-on  010-wrong1  011-wrong2  100-answer  101-reset   111-lock

    end



endmodule