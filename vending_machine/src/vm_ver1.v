module vending_machine_controller(
    input clk;
    input reset;
    
    input Ba;
    input Bb;
    input Bc;
    
    input Sc;
    input Sp;

    input change;

    output reg out_Ba;
    output reg out_Bb;
    output reg out_Bc;

    output reg change_1000;
    output reg change_500;
);

parameter s0 = 16'h0000;,
        s500 = 16'h1f4;,
        s1000 = 16'h3e8;,
        s1500 = 16'h5dc;,
        s2000 = 16'h7d0;,
        s2500 = 16'h9c4;,
        s3000 = 16'hbb8;,
        s3500 = 16'hdac;,
        s4000 = 16'hfa0;,
        s4500 = 16'h1194;,
        s5000 = 16'h1388;

reg [15:0] current_state, next_state;
reg [15:0] change;





endmodule

