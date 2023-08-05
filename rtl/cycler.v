module Cycler (
    input wire clk,
    input wire reset,
    
    output reg [7:0] vector
);

    /*
        This module cycles through vectors of valid {input,output} vectors
        for Boolean and arithmetic operations

    */


    reg [7:0] vectorROM [0: 3];

    reg [1:0] index; 

    initial begin

        //vector = A | B | X | carry1/OR | sum1/EQ | sum0/XOR | carry0/AND | LT |
        vectorROM[0] = 8'b00_0_0_1_0_0_0; 
        vectorROM[1] = 8'b01_0_1_0_1_0_1; 
        vectorROM[2] = 8'b10_0_1_0_1_0_0; 
        vectorROM[3] = 8'b11_0_1_1_0_1_0; 

    end

    always @(posedge clk) begin
        index <= (reset)? 2'b0: index+1'b1;
        vector <= vectorROM[index]; 
    end

    
endmodule