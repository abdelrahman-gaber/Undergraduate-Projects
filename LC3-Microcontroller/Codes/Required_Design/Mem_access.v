module Mem_access(M_Data,State,M_Control,M_addr,D_out,rd,memout,D_in,addr);
input [15:0] M_addr,M_Data,D_out;
input [3:0] State;
input M_Control;
output rd;
output [15:0] D_in,memout,addr;
wire [15:0] addr0;
wire D1,D0,C,TC,rd0;

assign TC=!D1&!D0;
assign C=M_Control&D1;
assign D1=!State[3]&State[2]&State[0];
assign D0=!State[3]&State[2]&State[1];

assign addr0=C?D_out:M_addr;
assign addr=TC?16'bz:addr0;
assign rd0=!(D1&D0);
assign rd=TC?16'bz:rd0;

assign memout=D_out;
assign D_in=M_Data;
endmodule

