module Execute(E_control, D_data, aluout, pcout, npc);

 input [5:0] E_control;     // control signals from Decode
 input [47:0] D_data;       // data from Decode
 output  [15:0] aluout;      // output of ALU
 output  [15:0] pcout;       // output of the address computation adder
 input   [15:0] npc;          // next PC from Fetch
 wire [15:0] aluin2 ;
 wire [15:0] VSR1,VSR2,IR;
 wire [1:0] alu_operation_select, pc_sel1;
 wire pc_sel2 , op2_sel;
 wire [15:0] imm5, offset9, offset6, offset11, opr2_pc, opr1_pc;

 assign IR = D_data[47:32];
 assign VSR1 = D_data [31:16];
 assign VSR2 = D_data [15:0];
 assign alu_operation_select = E_control[5:4];
 assign pc_sel1 = E_control[3:2];
 assign pc_sel2 = E_control[1];
 assign op2_sel = E_control[0];

ALU A1 (VSR1, aluin2, alu_operation_select, aluout);

assign aluin2 = (op2_sel)? imm5:VSR2;

assign imm5     = {{11{IR[ 4]}}, IR[ 4:0]};
assign offset6  = {{10{IR[ 5]}}, IR[ 5:0]};
assign offset9  = {{ 7{IR[ 8]}}, IR[ 8:0]};
assign offset11 = {{ 5{IR[10]}}, IR[10:0]};

assign opr1_pc = (pc_sel1[1])? ((pc_sel1[0])? 16'b0:offset11 ):((pc_sel1[0])? offset9:offset6);

assign opr2_pc = (pc_sel2)? VSR1:npc;

assign pcout   = opr1_pc + opr2_pc;

endmodule
