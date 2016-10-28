module ALU (aluin1, aluin2, alucontrol, aluout);

 input [15:0] aluin1;
 input [15:0] aluin2;
 input [1:0] alucontrol;
 output reg [15:0] aluout;

always@(aluin1,aluin2, alucontrol)
  case (alucontrol)
    2'b00 : aluout = aluin1 + aluin2 ;
    2'b01 : aluout = aluin1 - aluin2 ;
    2'b10 : aluout = aluin1 * aluin2 ;
    2'b11 : aluout = aluin1 & aluin2 ;
  endcase
endmodule
