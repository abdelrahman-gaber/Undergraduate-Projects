module M_W(clk,en,Memout,Npc,ALUout,PCout,W_Control,enP,MemoutP,NpcP,ALUoutP,PCoutP,W_ControlP);


input clk,en;
input [1:0] W_Control;
input [15:0] Memout,Npc,ALUout,PCout;
output reg enP;
output reg [1:0] W_ControlP;
output reg [15:0] MemoutP,NpcP,ALUoutP,PCoutP;


always @(posedge clk)
begin
enP=en;
W_ControlP=W_Control;
MemoutP=Memout;
NpcP=Npc;
ALUoutP=ALUout;
PCoutP=PCout;
end
endmodule