`include "opcode.v"

module rom(address, data);
   input [3:0]  address;
   output [7:0] data;

   assign 	data = ROM(address);
   function [7:0] ROM;
      input [3:0] address;

      case (address)
	0:  ROM = {`OUT_Im, 4'h0};
	1:  ROM = {`OUT_Im, 4'h1};
	2:  ROM = {`OUT_Im, 4'h2};
	3:  ROM = {`OUT_Im, 4'h3};
	4:  ROM = {`OUT_Im, 4'h4};
	5:  ROM = {`OUT_Im, 4'h5};
	6:  ROM = {`OUT_Im, 4'h6};
	7:  ROM = {`OUT_Im, 4'h7};
	8:  ROM = {`OUT_Im, 4'h8};
	9:  ROM = {`OUT_Im, 4'h9};
	10: ROM = {`OUT_Im, 4'hA};
	11: ROM = {`OUT_Im, 4'hB};
	12: ROM = {`OUT_Im, 4'hC};
	13: ROM = {`OUT_Im, 4'hD};
	14: ROM = {`OUT_Im, 4'hE};
	15: ROM = {`JMP_Im, 4'h0};
// 	default:
      endcase // case(address)
   endfunction // ROM
endmodule // rom
