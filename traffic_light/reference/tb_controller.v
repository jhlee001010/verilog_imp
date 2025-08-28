module tb_controller();
    reg clk;
    reg reset;
    reg [3:0] sensor;
    wire [2:0] state;
    reg [2*8-1:0] state_name; 

    traffic_light_controller uut (
        .clk(clk),
        .reset(reset),
        .sensor(sensor),
        .state(state)
    );


    always @(*) begin
        state_name = state_translation(state);
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // test start
    initial begin
        reset = 1; sensor = 4'b0000; 
        #10; 
        reset_state(reset, sensor);
        $monitor("Time: %0t, Sensor: %b, State: %s", $time, sensor, state_name);
        
        $display("=== Comprehensive State Transition Test ===");
        
        $display("state transition test");
        set_sensor(sensor, 4'b0000); //RR
        set_sensor(sensor, 4'b1xxx); //GR
        set_sensor(sensor, 4'b01xx); //LR
        set_sensor(sensor, 4'b0000); //RR
        set_sensor(sensor, 4'b01xx); //LR
        set_sensor(sensor, 4'b001x); //RG
        set_sensor(sensor, 4'b0001); //RL
        set_sensor(sensor, 4'b0000); //RR
        set_sensor(sensor, 4'b001x); //RG
        set_sensor(sensor, 4'b0000); //RR
        set_sensor(sensor, 4'b0001); //RL
        set_sensor(sensor, 4'b1xxx); //GR
        set_sensor(sensor, 4'b0001); //RL
        set_sensor(sensor, 4'b01xx); //LR
        set_sensor(sensor, 4'b0000); //RR
        
        #20; 
        $display("=== Test completed ===");
        $finish();
    end

    initial begin
        $dumpfile("traffic_light_controller.vcd");
        $dumpvars(0, tb_controller);
    end

    function [1:2*8] state_translation (input [2:0] state);
        begin
            case (state)
                3'b000: state_translation = "RR"; // Red
                3'b001: state_translation = "GR"; // Red to Green
                3'b010: state_translation = "LR"; // Red to Yellow
                3'b011: state_translation = "YR"; // Green to Red
                3'b100: state_translation = "RG"; // Green
                3'b101: state_translation = "RL"; // Yellow to Red
                3'b110: state_translation = "RY"; // Yellow to Green
                3'b111: state_translation = "UN"; // Unexpected state
                default: state_translation = "IN";
            endcase
        end
    endfunction

    task reset_state (output reset, output[3:0] sensor);
        begin
        reset = 1; #10; reset = 0; sensor = 4'b0000;
        end
    endtask

    task set_sensor (output [3:0] sensor,input [3:0] i);
        begin
            sensor = i; #20;
        end
    endtask

endmodule