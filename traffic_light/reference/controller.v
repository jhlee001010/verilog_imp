// synthesis verilog_input_version verilog_2001
module traffic_light_controller (
    input clk,
    input reset,
    input [3:0] sensor,
    output reg [2:0] state
);
parameter RR = 3'b000; // Red
parameter GR = 3'b001; // Greens
parameter LR = 3'b010; // Left
parameter YR = 3'b011; // yellow
parameter RG = 3'b100; // 
parameter RL = 3'b101; // 
parameter RY = 3'b110; // 

wire [2:0] st1, st2, st3, st4, st5;
assign st1 = {~sensor[3] & ~sensor[2] & (sensor[1] | sensor[0]), ~sensor[3] & sensor[2], sensor[3] | ~sensor[2] & ~sensor[1] & sensor[0]};
assign st2 = {1'b0, ~sensor[3], 1'b1};
assign st3 = {1'b0, 1'b1, ~sensor[2] | sensor[3]};
assign st4 = {1'b1, sensor[3] | sensor[2] | ~sensor[1], 1'b0};
assign st5 = {1'b1, sensor[3] | sensor[2] | sensor[1] | ~sensor[0], ~sensor[3] & ~sensor[2] & ~sensor[1] & sensor[0]};

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= RR;
    end else begin
        case (state)
            RR : state <= st1;
            GR : state <= st2;
            LR : state <= st3;
            YR : state <= st1;
            RG : state <= st4;
            RL : state <= st5;
            RY : state <= st1;
        endcase
    end
end


endmodule