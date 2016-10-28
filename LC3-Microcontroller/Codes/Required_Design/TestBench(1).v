`timescale 1ns/1ps
module TB();

reg [15:0] Data,M_addr,Dout;
wire [15:0] addr,Din,Memout;
wire rd;
reg Control;
reg[3:0] state;
integer i,j;

 Mem_access M0(Data,state,Control,M_addr,Dout,rd,Memout,Din,addr);

initial 
begin
Data=16'hAB10;
Dout=16'hABCD;
M_addr=16'h0056;
$monitor("State=%b Dout=%b  M_addr=%b",state,Dout,M_addr);
for (j=0;j<16;j=j+1)
begin
state=j;
#10;
for(i=0;i<=3;i=i+1)
begin
#10;
Control=0;
#10
Dout=Dout+15;
M_addr=M_addr+12;
Control=1;
#20;
end
end
end

endmodule
