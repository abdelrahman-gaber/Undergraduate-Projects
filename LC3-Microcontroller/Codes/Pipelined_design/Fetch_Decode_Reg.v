module F_D(clk,Dout,Npc,DoutP,NpcP);

input clk;
input [15:0] Dout,Npc;
output reg [15:0] DoutP,NpcP;

always @(posedge clk)
begin
DoutP=Dout;
NpcP=Npc;
end
endmodule


