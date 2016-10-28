module DP_R(clock,Sr1,Sr2,Dr,Sr1P,Sr2P,DrP);
input clock;
input [2:0] Dr,Sr1,Sr2;
output reg [2:0] DrP,Sr1P,Sr2P;

always @(posedge clock)
begin
DrP=Dr;
Sr1P=Sr1;
Sr2P=Sr2;
end

endmodule
