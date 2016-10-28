`timescale 1ns/1ps
module Check(clk,rw,data_out,data_in,Data,addr,addr_ideal);
input clk,rw;
input [15:0] addr,addr_ideal,data_out,data_in,Data;

always @(data_out)  //Checking for stored value 
begin
if(data_out[15:12]==4'b0001)
begin

$display("Instruction ADD complete");
end
else if(data_out[15:12]==4'b1001)
begin
#50
$display("Instruction NOT complete");
end
else if(data_out[15:12]==4'b0101)
begin
#50
$display("Instruction AND complete");
end
else if(data_out[15:12]==4'b0011) //Checking for ST instruction
begin

#21
if(addr==addr_ideal) //Checking for address to memory
begin
#10
if(Data==data_in) //Checking data to be saved to memory
$display("Instruction ST correct");
else
$display("Instruction ST incorrect data");
#19;
end
else
$display("Instruction ST incorrect at addr");
end

else if(data_out[15:12]==4'b1011) //Check for STI
begin
#22
if(addr==addr_ideal)
begin
#12
if(addr==addr_ideal)
begin
if(data_in==Data)
$display("Instruction STI correct"); //Correct STI
else
$display("Instruction STI incorrect @ data_in=%d   and Data= %d",data_in,Data); //Incorrect STI
end
else
$display("Instruction STI incorrect @ addr=%d and addr_ideal=%d",addr,addr_ideal);//Incorrect STI
end
else
$display("Instruction STI indirect mem address @ addr=%d and addr_ideal=%d",addr,addr_ideal);//Incorrect STI
#36;
end

else if(data_out[15:12]==4'b0111) //Checking for STR instruction
begin
#22
if(addr==addr_ideal)
begin
#12
if(data_in==Data)
$display("Instruction STR correct"); //Complete STR
else
$display("Instruction STR incorrect @ data_in=%d and Data=%d",data_in,Data); //Incorrect STR
end
else
$display("Instruction STR incorrect at mem address calculation @ addr=%d  and addr_ideal=%d",addr,addr_ideal);
#16;
end


else if(data_out[15:12]==4'b1100) //Checking for Jump or RET instruction
begin
#32
if (data_out[8:6]==3'b111) //Checking for RET instruction
begin
if(addr==addr_ideal)
$display("instruction RET correct"); //Correct RET
else
$display("instruction RET incorrect @ addr=%d  and  addr_ideal=%d",addr,addr_ideal); //Incorrect RET
end
else //Jump instruction confirmed
begin
if(addr==addr_ideal)
$display("instruction JMP correct"); //Correct JMP
else
$display("instruction JMP incorrect @addr=%d  and addr_ideal=%d",addr,addr_ideal); //Incorrect JMP
end
#8;
end
else if(data_out[15:12]==4'b0100) //Checking for JSR or JSSR
begin
#42
if (data_out[11]) //Checking for JSR instruction
begin
if(addr==addr_ideal)
$display("instruction JSR correct"); //Correct JSR
else
$display("instruction JSR incorrect @ addr=%d  and  addr_ideal=%d",addr,addr_ideal); //Incorrect JSR
end
else //JSSR instruction confirmed
begin
if(addr==addr_ideal)
$display("instruction JSSR correct"); //Correct JSSR
else
$display("instruction JSSR incorrect @addr=%d  and addr_ideal=%d",addr,addr_ideal); //Incorrect JSSR
end
#8;
end
else if(data_out[15:12]==4'b0010) //checking for LOAD instruction
begin
#22
if(addr==addr_ideal)
$display("Instruction LD complete"); //Correct LD
else
$display("Instruction LD incorrect @ addr=%d and addr_ideal=%d",addr,addr_ideal); //Incorrect LD
#38;
end
else if(data_out[15:12]==4'b0110)//Checking for LDR instruction
begin
#22
if(addr==addr_ideal)
$display("Instruction LDR complete"); //Complete LDR
else
$display("Instruction LDR incorrect @ addr=%d and addr_ideal=%d",addr,addr_ideal); //Incorrect LDR
#38;
end
else if(data_out[15:12]==4'b1010)
begin
#22
if(addr==addr_ideal)
begin
#12
if(addr==addr_ideal)
$display("Instruction LDI complete");
else
$display("Instruction LDI incorrect @ addr=%d and addr_ideal=%d",addr,addr_ideal);
end
else
$display("Instruction LDI indirect mem address @ addr=%d and addr_ideal=%d",addr,addr_ideal);
#36;
end

else if(data_out[15:12]==4'b1110) //Checking for LEA instruction
begin
$display("Instruction LEA correct"); //LEA Complete
#50;
end
else if(data_out[15:12]==4'b0000)
begin
#40
$display("Instruction BR complete");
end

else
$display("invalid instruction");
end
endmodule

