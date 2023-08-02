module Cycler (
    input wire clk,
    input wire reset,
    
    output reg [7:0] vector
);

    /*
        This module cycles through vectors of valid {input,output} vectors
        for Boolean and arithmetic operations

    */


    reg [7:0] vectorROM [0: 7];

    reg [2:0] index; 

    initial begin
        // vector = A | B | carry_cin0 | sum | carry | and | or | xor
        vectorROM[0] = 8'b000_00_000;
        vectorROM[1] = 8'b010_10_011;
        vectorROM[2] = 8'b100_10_011; 
        vectorROM[3] = 8'b110_01_110;
        vectorROM[4] = 8'b001_10_000;
        vectorROM[5] = 8'b011_01_011;
        vectorROM[6] = 8'b101_01_011; 
        vectorROM[7] = 8'b111_11_110; 
    end

    always @(posedge clk) begin
        index <= (reset)? 3'b0: index+1'b1;
        vector <= vectorROM[index]; 
    end

    
endmodule