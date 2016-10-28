
`timescale 1ns/1ps
module cpu_tb;
parameter HLF_C=5;
reg [15:0] mem [(2**16)-1:0];
reg clk;
wire complete,rw;
reg  reset;
wire [15:0] addr;
reg [15:0] data_out;
wire [15:0] data_in,Data,addr_ideal;
assign complete=1;
initial begin //Loading instruction to memory from .txt file and waiting for global reset
    $readmemh("D:\\Top_Secret\\Science\\Electronics\\Digital design\\LC3 Microcontroller\\final\\Ex3.txt",mem);
   clk=1'b0;
   reset=1'b0;
#10 reset=1'b1;

end

always #HLF_C clk = ~ clk; //Global clock

always @(posedge clk) begin : proc_  //reading from or writing into memory
    if(rw) begin
        data_out=mem[addr];

    end
    else
    begin
        mem[addr]=data_in;
end
end
lc3_microcontroller LC3(rw,addr,data_in,clk,reset,data_out,complete); //DUT
LC3_ideal           LC4(data_out,data_out,Data,addr_ideal); //Reference core
Check               CH0(clk,rw,data_out,data_in,Data,addr,addr_ideal); //Compare and Check instruction


endmodule