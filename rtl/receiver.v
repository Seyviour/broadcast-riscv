module receiver(
    input wire clk, reset, 
    input wire R,
    input wire i_valid,
    output wire o_valid,
    output reg[31:0] result
); 

// reg [31:0] received;
reg [4:0] count; 

always @(posedge clk) begin
    if (reset)
        count <= 0; 
    else if (i_valid) begin
        result <= {R, result[31:1]};
        count <= count + 1'b1; 
    end
end


assign o_valid = (count == 0); 







endmodule 