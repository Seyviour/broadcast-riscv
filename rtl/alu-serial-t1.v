`default_nettype none

module serv_alu
  (
    input wire clk, reset, 
    input wire A, // upstream must not change inputs till o_valid is asserteds
    input wire B,
    //State

    input wire [7:0] cycle, 
    input wire [5:0] inst,

    //Control
    //Data
    output wire o_valid, // output is valid, input sequencer may proceed to next bits
    output wire o_rd
  );

  // CONTRACT: I will not listen for an acknowledge. Downstream modules must always be ready to consume. 
    // nop -> inst = 000000
    // add -> inst = 100101
    // sub -> inst = x01010
    // xor -> inst = x00100
    // and -> inst = x00010
    // or  -> inst = x00001
    // LT  -> inst = x10000 *should be capable of early stopping*
    // EQ  -> inst = x01000

  // carry is an implementation detail
  reg carry_R;
  wire i_last;
  
  reg [3:0] cache;
  reg [3:0] valid; 

  /* 
    cache structure
    cache[x] = {valid, result [x]}
  */

  assign i_last = inst[5]; 

  wire [4:0] filter; 
  assign filter = carry_R? (inst << 1'b1): inst; 

  assign o_rd = |(cycle[4:0] & filter[4:0]); 

  assign o_valid = &({cycle[7:6]} ~^ {A,B}) & |(inst);

  always @(posedge clk)
    begin
        if (reset | !(inst[0] & inst[2])) carry_R <= 1'b0; 
        if (o_valid)
            carry_R <= filter[0]? cycle[1]: cycle[4]; 
        
        // carry should be 0 whenever we are not adding 
        // if (!(inst[0] & inst[2]))
        //     carry_R <= 0;

    end







endmodule
