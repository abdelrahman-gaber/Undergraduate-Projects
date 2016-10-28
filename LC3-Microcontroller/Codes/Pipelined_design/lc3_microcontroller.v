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

wire F_Control,M_Control,M_ControlP,M_ControlPP,rd_mem,rd_fetch,EN,ENP,ENPP,ENPPP,Stall;
wire [ 1:0] W_Control,W_ControlP,W_ControlPP,W_ControlPPP,A_Control0,A_Control1;
wire [ 3:0] state;
wire [ 5:0] C_Control,C_ControlP, E_Control,E_ControlP;
wire [15:0] pc,npc,NpcP,NpcPP,NpcPPP,NpcPPPP,DoutP,DR_in,memout,memoutP,pcout,pcoutP,pcoutPP,aluout,aluoutP,aluoutPP,addr_mem,addr_fetch,D_DataPP,aluin0,aluin1;
wire [47:0] D_Data,D_DataP,aluin;



assign addr = pc;
//assign aluin={D_DataP[47:32],aluin0,aluin1};
//Mux   M0 (D_DataP[31:16],aluoutP,aluoutPP,A_Control0,aluin0);
//Mux   M1 (D_DataP[15:0],aluoutP,aluoutPP,A_Control1,aluin1);
Fetch  F0(clock,reset, state, pc, npc, rd, taddr,1'b0);
F_D    FD0(clock,dout,npc,DoutP,NpcP);
decode D0(clock,DoutP, C_Control, E_Control,M_Control, W_Control, F_Control,EN,ENPPP, D_Data, DR_in);
D_E    DE0(clock,EN,NpcP,E_Control,M_Control,W_Control,D_Data,ENP,NpcPP,E_ControlP,M_ControlP,W_ControlP,D_DataP);
Execute Ex0(E_ControlP,D_DataP, aluout, pcout, NpcPP);
E_M    EM0(clock,ENP,D_DataP[15:0],NpcPP,pcout,aluout,M_ControlP,W_ControlP,ENPP,D_DataPP,,NpcPPP,pcoutP,aluoutP,M_ControlPP,W_ControlPP);
Mem_access MA0(D_DataPP,M_ControlPP,memout);
M_W    MW0(clock,ENPP,memout,NpcPPP,aluoutP,pcoutP,W_ControlPP,ENPPP,memoutP,NpcPPPP,aluoutPP,pcoutPP,W_ControlPPP);
writeback W0(DR_in,aluoutPP, pcoutPP,NpcPPPP,memoutP,W_ControlPPP);




endmodule