module D_E(clk,en,Npc,E_Control,M_Control,W_Control,D_data,enP,NpcP,E_ControlP,M_ControlP,W_ControlP,D_dataP);

input clk,en,M_Control;
input [1:0] W_Control;
input [5:0] E_Control;
input [15:0] Npc;
input [47:0] D_data;
output reg  enP,M_ControlP;
output reg [1:0] W_ControlP;
output reg[5:0] E_ControlP;
output reg[15:0] NpcP;
output reg[47:0] D_dataP;

always @(posedge clk)
begin
enP=en;
M_ControlP=M_Control;
W_ControlP=W_Control;
E_ControlP=E_Control;
NpcP=Npc;
D_dataP=D_data;
end
endmodule
