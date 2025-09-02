/**
 * Logisim으로 설계된 신호등 제어 회로의 Verilog 코드
 *
 * 입력:
 * - clk: 시스템 클럭
 * - TA, TaL: A 도로의 차량 감지 및 타이머 관련 신호
 * - TB, TbL: B 도로의 차량 감지 및 타이머 관련 신호
 *
 * 출력:
 * - led_A_red, led_A_yellow, led_A_green, led_A_blue: A 신호등 LED
 * - led_B_red, led_B_yellow, led_B_green, led_B_blue: B 신호등 LED
 */
module traffic_light (
    input wire clk,
    input wire TA,
    input wire TaL,
    input wire TB,
    input wire TbL,

    output wire led_A_red,
    output wire led_A_yellow,
    output wire led_A_green,
    output wire led_A_blue,

    output wire led_B_red,
    output wire led_B_yellow,
    output wire led_B_green,
    output wire led_B_blue
);

    // 상태 정의 (파라미터)
    parameter S0 = 3'b000; // A: Green, B: Red
    parameter S1 = 3'b001; // A: Green, B: Red (Wait for A long)
    parameter S2 = 3'b010; // A: Yellow, B: Red
    parameter S3 = 3'b011; // A: Red,   B: Green
    parameter S4 = 3'b100; // A: Red,   B: Green (Wait for B long)
    parameter S5 = 3'b101; // A: Red,   B: Yellow
    parameter S6 = 3'b110; // All Red (Transition wait)

    // 상태 레지스터
    reg [2:0] current_state;
    reg [2:0] next_state;

    // 순차 회로: 클럭에 따라 현재 상태를 다음 상태로 업데이트
    always @(posedge clk) begin
        current_state <= next_state;
    end

    // 조합 회로: 다음 상태 결정 로직
    always @(*) begin
        case (current_state)
            S0: begin // A: Green, B: Red
                if (TaL)
                    next_state = S1;
                else if (!TaL && TB)
                    next_state = S6;
                else
                    next_state = S0;
            end
            S1: begin // A: Green, B: Red (Wait for A long)
                if (TA)
                    next_state = S0;
                else
                    next_state = S2;
            end
            S2: begin // A: Yellow, B: Red
                next_state = S3;
            end
            S3: begin // A: Red, B: Green
                if (TbL)
                    next_state = S4;
                else if (!TbL && TA)
                    next_state = S6;
                else
                    next_state = S3;
            end
            S4: begin // A: Red, B: Green (Wait for B long)
                if (TB)
                    next_state = S3;
                else
                    next_state = S5;
            end
            S5: begin // A: Red, B: Yellow
                next_state = S0;
            end
            S6: begin // All Red (Transition wait)
                if (TA)
                    next_state = S0;
                else
                    next_state = S3;
            end
            default: begin
                next_state = S0; // 예외 처리: 알 수 없는 상태일 경우 초기 상태로
            end
        endcase
    end

    // 조합 회로: 출력 결정 로직 (Moore FSM)
    assign led_A_red    = (current_state == S2) || (current_state == S3) || (current_state == S4) || (current_state == S5) || (current_state == S6);
    assign led_A_yellow = (current_state == S2);
    assign led_A_green  = (current_state == S0) || (current_state == S1);
    assign led_A_blue   = (current_state == S2); // 회로상 Yellow와 Blue가 같이 켜짐

    assign led_B_red    = (current_state == S0) || (current_state == S1) || (current_state == S2) || (current_state == S5) || (current_state == S6);
    assign led_B_yellow = (current_state == S5);
    assign led_B_green  = (current_state == S3) || (current_state == S4);
    assign led_B_blue   = (current_state == S5); // 회로상 Yellow와 Blue가 같이 켜짐

endmodule