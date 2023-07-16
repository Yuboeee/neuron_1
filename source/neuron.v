`timescale 1ns/1ps

module neuron #(
    //sigmoidSize=5,actType="relu",biasFile=""
    parameter layerNo = 0, neuronNo = 0, numWeight = 10, dataWidth = 16, weightIntWidth = 1, weightFile = ""
) (
    input clk,
    input rst,
    input [dataWidth-1:0] myInput,
    input myinputValid,
//    input weightValid,
//    input biasValid,
    input [31:0] weightValue,
//    input [31:0] biasValue,
//    input [31:0] config_layer_num,
//    input [31:0] config_neuron_num,
    output[dataWidth-1:0] out,
    output reg outvalid   
);

    parameter addressWidth = $clog2(numWeight);

    reg wen;
    wire        ren;
    reg [addressWidth-1:0] w_addr;
    reg [addressWidth:0]   r_addr;//read address has to reach until numWeight hence width is 1 bit more
    reg [dataWidth-1:0]  w_in;
    wire [dataWidth-1:0] w_out;
    reg [2*dataWidth-1:0]  mul; 
    reg [2*dataWidth-1:0]  sum;
    reg [2*dataWidth-1:0]  bias;
    reg [31:0]    biasReg[0:0];
    reg weight_valid;
    reg mult_valid;
    wire mux_valid;
//    reg         sigValid; 
    wire [2*dataWidth:0] comboAdd;
//    wire [2*dataWidth:0] BiasAdd;
    reg  [dataWidth-1:0] myinputd;
    reg muxValid_d;
    reg muxValid_f;
    reg addr=0;
    
   //Loading weight values into the memory
    always @(posedge clk)
    begin
        if(rst)
        begin
            w_addr <= {addressWidth{1'b1}};
            wen <=0;
        end
        //else if(weightValid & (config_layer_num==layerNo) & (config_neuron_num==neuronNo))
        else if((config_layer_num == layerNo) & (config_neuron_num == neuronNo))
        begin
            w_in <= weightValue;
            w_addr <= w_addr + 1;
            wen <= 1;
        end
        else
            wen <= 0;
    end

    assign mux_valid = mult_valid;
    assign comboAdd = mul + sum;
//    assign BiasAdd = bias + sum;
    assign ren = myinputValid;

    always @(posedge clk)
    begin
        if(rst|outvalid)
            r_addr <= 0;
        else if(myinputValid)
            r_addr <= r_addr + 1;
    end

    always @(posedge clk)
    begin
        mul  <= $signed(myinputd) * $signed(w_out);
    end

    always @(posedge clk)
    begin
        myinputd <= myinput;
        weight_valid <= myinputValid;
        mult_valid <= weight_valid;
        sigValid <= ((r_addr == numWeight) & muxValid_f) ? 1'b1 : 1'b0;
        outvalid <= sigValid;
        muxValid_d <= mux_valid;
        muxValid_f <= !mux_valid & muxValid_d;
    end
    
    //Instantiation of Memory of Weights
    Weight_Memory #(.numWeight(numWeight),.addressWidth(addressWidth),.dataWidth(dataWidth),.weightFile(weightFile)) WM(
        .clk(clk),
    //    .wen(wen),
        .ren(ren),
        .wadd(w_addr),
        .radd(r_addr),
        .win(w_in),
        .wout(w_out)
    );



endmodule