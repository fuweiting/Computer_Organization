module Shifter (
    leftRight,
    shamt,
    sftSrc,
    result
);

  //I/O ports
  input leftRight;  //0:sll , 1:srl
  input [5-1:0] shamt;
  input [32-1:0] sftSrc;

  output [32-1:0] result;

  //Internal Signals
  reg [32-1:0] result;

  //Main function

always@(*) begin
    if (leftRight) // shift right
        result = sftSrc >>> shamt;
    else // shift left
        result = sftSrc <<< shamt;
end

endmodule
