 `include "lc3_pkg.v"
`timescale 1ns/1ps
module LC3_ideal(Data_in,IR,Data,addr);

input [15:0] Data_in,IR;

output reg [15:0] Data;
output reg [15:0] addr;
reg [15:0] reg_file [0:7];
reg [15:0] pc=16'h3000,Ireg;
reg N,P,Z;
wire [15:0] npc;
assign npc=pc+1;




always @(IR)
begin
case(IR[15:12])
`LEA : begin
reg_file[IR[11:9]]=npc+ {{7{IR[8]}},IR[8:0]};
#1
N =  reg_file[IR[11:9]];
P = ~reg_file[IR[11:9]];
Z = (reg_file[IR[11:9]] == 16'b0);
pc=pc+1;
end

`ADD : begin
if(IR[5]==1'b0)
begin
             
reg_file[IR[11:9]]=reg_file[IR[8:6]] + reg_file[IR[2:0]];
#1
N =  reg_file[IR[11:9]];
P = ~reg_file[IR[11:9]];
Z = (reg_file[IR[11:9]] == 16'b0);
pc=pc+1;
end
else
begin

reg_file[IR[11:9]]=reg_file[IR[8:6]]+{{11{IR[4]}},IR[4:0]};
#1
N =  reg_file[IR[11:9]];
P = ~reg_file[IR[11:9]];
Z = (reg_file[IR[11:9]] == 16'b0);
pc=pc+1;
end
end

                
              
            
        `AND : begin
               if(IR[5]==1'b0)
begin

reg_file[IR[11:9]]=reg_file[IR[8:6]]&reg_file[IR[2:0]];
#1
N =  reg_file[IR[11:9]];
P = ~reg_file[IR[11:9]];
Z = (reg_file[IR[11:9]] == 16'b0);
pc=pc+1;
end
else
begin

reg_file[IR[11:9]]=reg_file[IR[8:6]]&{{11{IR[4]}},IR[4:0]};
#1
N =  reg_file[IR[11:9]];
P = ~reg_file[IR[11:9]];
Z = (reg_file[IR[11:9]] == 16'b0);
pc=pc+1;
end
end


`NOT : begin


reg_file[IR[11:9]]=~reg_file[IR[8:6]];
#1
N =  reg_file[IR[11:9]];
P = ~reg_file[IR[11:9]];
Z = (reg_file[IR[11:9]] == 16'b0);
pc=pc+1;
end
  `ST  : begin
Ireg=IR;
Data=reg_file[Ireg[11:9]];
#20
addr=npc+{{7{IR[8]}},IR[8:0]};
#30
pc=pc+1;
end

`STI : begin
Ireg=IR;
#20
addr=npc+{{7{IR[8]}},IR[8:0]};
#11
addr=Data_in;
Data=reg_file[Ireg[11:9]];
#29
pc=pc+1;
end

`STR : begin
Ireg=IR;
#20
addr=reg_file[IR[8:6]]+ {{9{IR[5]}},IR[5:0]};
#11
Data=reg_file[Ireg[11:9]];
#19;
pc=pc+1;
end

`LD : begin
Ireg=IR;
#20
addr=npc+ {{7{IR[8]}},IR[8:0]};
#11
reg_file[Ireg[11:9]]=Data_in;
N =  Data_in[15];
P = ~Data_in[15];
Z = (Data_in == 16'b0);
#29
pc=pc+1;
end
`LDI : begin
Ireg=Data_in;
#20
addr=npc+ {{7{IR[8]}},IR[8:0]};
#11
addr=Data_in;
#11
reg_file[Ireg[11:9]]=Data_in;
N =  Data_in[15];
P = ~Data_in[15];
Z = (Data_in == 16'b0);
#28;
pc=pc+1;
end
`LDR : begin
Ireg=IR;
#20
addr=reg_file[IR[8:6]]+ {{9{IR[5]}},IR[5:0]};
#11
reg_file[Ireg[11:9]]=Data_in;
N =  Data_in[15];
P = ~Data_in[15];
Z = (Data_in == 16'b0);
#29;
pc=pc+1;
end
`JMP : begin
#30
addr=reg_file[IR[8:6]];
pc=reg_file[IR[8:6]];
#10;
end
`JSR : begin
if(IR[11])
begin
#30
reg_file[7]=npc;
pc=npc+{{5{IR[10]}},IR[10:0]};
addr=npc+{{5{IR[10]}},IR[10:0]};
#10;
end
else
begin
#40
reg_file[7]=npc;
pc=reg_file[IR[8:6]];
addr=reg_file[IR[8:6]];
#10;
end
end

`BR : begin
if((IR[11]&N)||(IR[10]&Z)||(IR[10]&P))
begin
pc=npc+{{6{IR[8]}},IR[8:0]};
pc=npc+{{6{IR[8]}},IR[8:0]};
end
end

4'b0000 : begin
pc=pc+1;
end
endcase


end
endmodule
