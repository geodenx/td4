// 4bit D-FF
module register(clock, reset, load, d, q);
   input        clock, reset, load;
   input [3:0] 	d;
   output [3:0] q;

   reg [3:0] 	regQ;
   assign 	q = regQ;

   always @ (posedge clock or negedge reset) begin
      if (!reset)
	regQ <= 4'h0;
      else if (~load)
	regQ <= d;
//    else
// 	regQ <= regQ;
   end
endmodule // register
