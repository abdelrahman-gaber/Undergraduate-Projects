`include "lc3_pkg.v"
module lc3_microcontroller (
    output rd,
    output [15:0] addr,
    output [15:0] din,

    input clock,
    input reset,
    input [15:0] dout,
    input complete

    );

wire F_Control,M_Control,rd_mem,rd_fetch;
wire [ 1:0] W_Control;
wire [ 3:0] state;
wire [ 5:0] C_Control, E_Control;
wire [15:0] npc,DR_in,memout,pcout,aluout,addr_mem,addr_fetch;
wire [47:0] D_Data;

assign rd = (state == `READ_MEM || state == `WRITE_MEM || state == `INDIRECT_ADDR_READ)?
       rd_mem:rd_fetch;

assign addr = (state == `READ_MEM || state == `WRITE_MEM || state == `INDIRECT_ADDR_READ)?
       addr_mem:addr_fetch;


Fetch fetch_unit (.clock(clock),
 .reset(reset),
 .state(state),
 .pc(addr_fetch),
 .npc(npc),
 .rd(rd_fetch),
 .taddr(pcout),
 .br_taken(F_Control));

decode decode_unit (.clock(clock),
    .state(state),
    .dout(dout),
    .C_Control(C_Control),
    .E_Control(E_Control),
    .M_Control(M_Control),
    .W_Control(W_Control),
    .F_Control(F_Control),
    .D_Data(D_Data),
    .DR_in(DR_in));

controller control_unit (
    .clock(clock),
    .reset(reset),
    .c_control(C_Control),
    .complete(complete),
    .state(state));

Mem_access mem_access_unit(
    .M_Data(D_Data[15:0]),
    .State(state),
    .M_Control(M_Control),
    .M_addr(pcout),
    .D_out(dout),
    .rd(rd_mem),
    .memout(memout),
    .D_in(din),
    .addr(addr_mem));

Execute exc_unit (
    .E_control(E_Control),
    .D_data(D_Data),
    .aluout(aluout),
    .pcout(pcout),
    .npc(npc));

writeback writeback_unit (
    .DR_in(DR_in),
    .aluout(aluout),
    .pcout(pcout),
    .npc(npc),
    .memout(memout),
    .W_Control(W_Control));



endmodule