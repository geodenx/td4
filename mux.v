module mux (sel, a, b, c, d, out);
   input [1:0]  sel;
   input [3:0] 	a, b, c, d;
   output [3:0] out;

   assign 	out = funcMux(sel, a, b, c, d);
   function [3:0] funcMux;
      input [1:0]  sel;
      input [3:0]  a, b, c, d;

      case (sel) 
	2'h0: funcMux = a;
	2'h1: funcMux = b;
	2'h2: funcMux = c;
	2'h3: funcMux = d;
      endcase
   endfunction // funcMux
endmodule // mux
