`timescale 1ns / 1ps

module Weight_Memory #(parameter numWeight = 3, addressWidth=10,dataWidth=16,weightFile="w_1_15.mem") 
    ( 
    input clk,
    input ren,
    input [addressWidth-1:0] wadd,
    input [addressWidth-1:0] radd,
    input [dataWidth-1:0] win,
    output reg [dataWidth-1:0] wout);

    reg [dataWidth-1:0] mem [numWeight-1:0];

    initial
        begin
            $readmemb(weightFile, mem);
        end

    always @(posedge clk)
    begin
        if (ren)
        begin
            wout <= mem[radd];
        end
    end 
    
endmodule