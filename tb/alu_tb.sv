
module serv_alu_tb;

// Parameters

//Ports


reg  clk = 0;
wire A;
wire B;
wire [7:0] cycle;
reg [5:0] inst;
wire o_valid;
wire o_rd;
reg reset; 



always #5  clk = ! clk ;

reg [31:0] op1, op2; 
wire [7:0] vector; 

serv_alu  serv_alu_inst (
  .clk(clk),
  .reset(reset), 
  .A(A),
  .B(B),
  .cycle(vector),
  .inst(inst),
  .o_valid(o_valid),
  .o_rd(o_rd)
);

Cycler  Cycler_inst (
    .clk(clk),
    .reset(reset),
    .vector(vector)
  );

    // nop -> inst = 000000
    // add -> inst = 100101
    // sub -> inst = x01010
    // xor -> inst = x00100
    // and -> inst = x00010
    // or  -> inst = x00001
    // LT  -> inst = x10000 *should be capable of early stopping*
    // EQ  -> inst = x01000

  reg [5:0] insts [6:0];

  initial begin
    insts[0] = 6'b000000;
    insts[1] = 6'b100101;
    insts[2] = 6'b000100;
    insts[3] = 6'b000010;
    insts[4] = 6'b000001;
    insts[5] = 6'b010000;
    insts[6] = 6'b001000; 
  end

  wire [31:0] result; 
  wire receiver_done; 

  receiver  receiver_inst (
    .clk(clk),
    .reset(reset),
    .R(o_rd),
    .i_valid(o_valid),
    .o_valid(receiver_done), 
    .result(result)
  );



// event 
// reg [31:0] op1, op2; 

integer op_pos; 
task drive_operands (input reg [31:0] a, b);
op1 = a;
op2 = b; 
begin
  op_pos = 0;
  while (op_pos <= 31) begin
    @(posedge clk)
        if (o_valid) begin
            op1 <= op1 >> 1'b1; 
            op2 <= op2 >> 1'b1; 
            op_pos <= op_pos + 1'b1; 
        end
  end
end
endtask 

assign A = op1[0];
assign B = op2[0]; 

integer i,j,k;
task drive_inputs;
  for (i = 1; i <=6; i = i + 1) begin
    inst = insts[i]; 
    for (j = 0; j < 256; j = j + 1) begin
        for (k = 0; k < 256; k = k + 1) begin 
            drive_operands(j,k); 
        end
    end
  end
endtask

initial begin
  $dumpfile("test.vcd"); 
  $dumpvars(0, serv_alu_tb);
end

initial begin 
  reset = 1;
  #100;
  reset = 0; 
  drive_inputs;
end

endmodule