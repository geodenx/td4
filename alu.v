module alu(clock, reset, a, b, result, flagC);
   input clock, reset;
   input [3:0]  a, b;
   output [3:0] result;
   output 	flagC;

   wire [4:0] 	sum;
   reg 		regflagC;

   // this ALU only support addition operation
   assign 	sum[4:0] = a[3:0] + b[3:0];
   assign 	result = sum[3:0];

   // control flagC
   assign 	flagC = regflagC;
   always @(posedge clock or negedge reset) begin
      if (!reset)
	regflagC <= 0;
      else
	regflagC <= sum[4];
   end   
endmodule // alu
