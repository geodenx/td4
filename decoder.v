//    decoder decoder(data[7:4], MuxSel, loadA, loadB, loadOut, loadPC);
`include "opcode.v"

module decoder (opcode, flagC, MuxSel, loadA, loadB, loadOut, loadPC);
   input [3:0]  opcode;
   input 	flagC;
   output [1:0] MuxSel;
   output 	loadA, loadB, loadOut, loadPC;

   assign 	{MuxSel, loadA, loadB, loadOut, loadPC} = funcDec(opcode, flagC);
   function [5:0] funcDec;
      input [3:0] opcode;
      input flagC;
      
      case (opcode)
	`ADD_A_Im:	funcDec = 6'h07;
	`MOV_A_B:	funcDec = 6'h17;
	`IN_A:		funcDec = 6'h27;
	`MOV_A_Im:	funcDec = 6'h37;
	`MOV_B_A:	funcDec = 6'h0B;
	`ADD_B_Im:	funcDec = 6'h1B;
	`IN_B:		funcDec = 6'h2B;
	`MOV_B_Im:	funcDec = 6'h3B;
	`OUT_B:		funcDec = 6'h1D;
	`OUT_Im:	funcDec = 6'h3D;
	`JNC_Im: 
	  if (flagC)
	    funcDec = 6'h0F;	// 6'hXF (selector is "don't care")
	  else
	    funcDec = 6'h3E;
	`JMP_Im:	funcDec = 6'h3E;
// 	default:
      endcase
   endfunction // funcDec
endmodule // decoder
