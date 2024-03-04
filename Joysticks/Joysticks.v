module JoystickController (
    input wire clk,      // 클럭 신호
    input wire rst,      // 리셋 신호
    input wire joy_x,    // 조이스틱 X 축의 아날로그 값
    input wire joy_y,    // 조이스틱 Y 축의 아날로그 값
    input wire joy_sw,   // 조이스틱 스위치 신호
    output reg [9:0] digital_x,  // 변환된 디지털 값 (X 축)
    output reg [9:0] digital_y,  // 변환된 디지털 값 (Y 축)
    output reg joy_button  // 스위치 신호
);

// 상태 정의
typedef enum logic [1:0] {
    IDLE,
    CONVERT
} state_t;

// 상태 레지스터 및 현재 상태 변수
reg state_reg, next_state;

// 10비트 ADC 레지스터
reg [9:0] x_result, y_result;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        // 리셋 시 초기화
        state_reg <= IDLE;
        x_result <= 10'b0;
        y_result <= 10'b0;
        joy_button <= 1'b0;
    end else begin
        // 상태 전이
        state_reg <= next_state;
        
        // 다음 상태 계산
        case (state_reg)
            IDLE: next_state = CONVERT;
            CONVERT: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
end

// ADC 값 처리 블록
always_ff @(posedge clk) begin
    case (state_reg)
        IDLE: begin
            // IDLE 상태에서는 아무 일도 하지 않음
        end
        CONVERT: begin
            // CONVERT 상태에서는 아날로그 값을 디지털로 변환
            x_result <= joy_x;
            y_result <= joy_y;
            joy_button <= joy_sw;
        end
    endcase
end

// 디지털 값 출력
always_comb begin
    digital_x = x_result;
    digital_y = y_result;
end

endmodule
