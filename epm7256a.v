// mother board for EPM7256A (CQ-pub DesignWave 2003 Jan. appendix)
module epm7256a(RESET, TSW, LED);
   input RESET;
   input [1:0] TSW;
   output [3:0] LED;

   wire 	clk;
   wire [3:0] 	PortOut, PortIn;

   assign       LED[3:0] = PortOut;
   assign 	PortIn = 4'h0;

   rsff(TSW[0], TSW[1], clk);
   td4 td4(clk, RESET, PortIn, PortOut);
endmodule // epm7256a

// RS-FlipFlop
module rsff(a, b, out);
   input a, b;
   output out;

   wire   w0, w1;

   assign w0 = ~(a & w1);   
   assign w1 = ~(b & w0);
   assign out = w0;
endmodule // rsff
