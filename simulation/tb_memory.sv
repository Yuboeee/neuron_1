`timescale 1ns / 1ps

module tb_memory();

parameter numWeight = 3;
parameter addressWidth = 16; 
parameter dataWidth = 16;
parameter weightFile = "w_1_15.mem";

logic clk;
logic ren;
logic [addressWidth-1:0] wadd;
logic [addressWidth-1:0] radd;
logic [dataWidth-1:0] win;
logic [dataWidth-1:0] wout;

initial begin 
    clk = 0;
    ren = 1;
end

initial forever #5 clk = ~clk;

Weight_Memory #(.numWeight(numWeight), .addressWidth(addressWidth), .weightFile(weightFile), .dataWidth(dataWidth)) WM(
    .clk(clk),
    .ren(ren),
    .wadd(wadd),
    .radd(radd),
    .win(win),
    .wout(wout)
);

endmodule