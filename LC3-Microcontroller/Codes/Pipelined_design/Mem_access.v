module Mem_access(M_Data,M_Control,M_addr,D_out,rd,memout,D_in,addr);
input [15:0] M_addr,M_Data,D_out;
input M_Control;
output rd;
output [15:0] D_in,memout,addr;
input [15:0] M_addr,M_Data,D_out;

input M_Control;
output rd;
output [15:0] D_in,memout,addr;
wire [15:0] addr0;
wire D1,D0,C,TC,rd0;




assign addr=16'bz;

assign rd=1'bz;

assign memout=D_out;

endmodule


