module td4(clock, reset, PortIn, PortOut);
   input	clock, reset;
   input [3:0] 	PortIn;
   output [3:0] PortOut;

   wire [3:0] 	address;
   wire [7:0] 	data;
   wire  	loadA, loadB, loadOut, loadPC, flagC;
   wire [3:0] 	qA, qB;
   wire [1:0] 	MuxSel;
   wire [3:0] 	MuxOut, Result;
   
   decoder decoder(data[7:4], flagC, MuxSel, loadA, loadB, loadOut, loadPC);
   rom rom(address, data);
   mux mux(MuxSel, qA, qB, PortIn, 4'h0, MuxOut);
   alu alu(clock, reset, MuxOut, data[3:0], Result, flagC);

   register A(  clock, reset, loadA,   Result, qA);
   register B(  clock, reset, loadB,   Result, qB);
   register Out(clock, reset, loadOut, Result, PortOut);
   pc pc(       clock, reset, loadPC,  Result, address);
endmodule // td4
