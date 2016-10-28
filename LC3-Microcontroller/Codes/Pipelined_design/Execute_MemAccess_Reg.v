module E_M(clk,en,Dout,Npc,PCout,ALUout,M_Control,W_Control,enP,DoutP,,NpcP,M_addr,ALUoutP,M_ControlP,W_ControlP);

input clk,en,M_Control;
input [1:0] W_Control;
input [15:0] Dout,Npc,ALUout,PCout;
output reg enP,M_ControlP;
output reg [1:0] W_ControlP;
output reg [15:0] DoutP,NpcP,ALUoutP,M_addr;


always @(posedge clk)
begin
enP=en;
W_ControlP=W_Control;
M_ControlP=M_Control;
DoutP=Dout;
NpcP=Npc;
ALUoutP=ALUout;
M_addr=PCout;
end
endmodule
