module writeback (
    output [15:0] DR_in,
    input  [15:0] aluout, pcout, npc, memout,
    input  [ 1:0] W_Control
    );

assign DR_in = (W_Control[1])? ((W_Control[0])? memout:npc )
              :((W_Control[0])? pcout:aluout);

endmodule