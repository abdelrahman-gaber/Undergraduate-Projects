

`include "lc3_pkg.v"

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    18:33:22 06/24/2014
// Design Name:
// Module Name:    try_fetch
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module Fetch(clock,reset, state, pc, npc, rd, taddr, br_taken);
input clock; // system clock
input reset; // system reset
input br_taken; // signal from decoder, 1 means branch taken
input [15:0] taddr; // target address of control instructions
input [3:0] state; // system state from controller
output [15:0] pc, npc; // current PC and next PC, i.e., pc+1
output rd; // memory read control signal

wire [15:0] npc_wire;

wire [15:0] taddr_mult_out;
wire [15:0] old_pc;
wire [15:0] new_pc;
reg  [15:0] new_pc_reg; //not in schematic
wire buffer_control;

assign taddr_mult_out= br_taken? taddr : npc_wire;

assign old_pc = !reset ? 16'h0 : taddr_mult_out;//Remeber return to 16'h3000

always @(posedge clock)
begin
	new_pc_reg <= old_pc;
end
	assign new_pc=new_pc_reg;
	assign npc_wire=new_pc+1;
	assign npc=npc_wire;

	
	assign buffer_control= 1'b1;


	assign pc=new_pc;
	assign rd=1'b1;


endmodule
