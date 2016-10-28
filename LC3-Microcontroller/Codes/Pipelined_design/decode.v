`include "lc3_pkg.v"


module decode(clock, dout, C_Control, E_Control,
    M_Control, W_Control, F_Control,EN,ENR, D_Data, DR_in);
    input clock,ENR;       // Global system clock
    
    input [15:0] dout; // Data-out lines from Memory
    input [15:0] DR_in;// Data to be written to Register-File
    output reg M_Control;  // MemAccess control line
    output reg [1:0] W_Control; // Writeback control lines
    output reg [5:0] C_Control; // Controller control lines
    output reg [5:0] E_Control; // Execute control lines
    output reg F_Control;       // Fetch control line
    output reg EN;
    output [47:0] D_Data;   // Data for Execute and MemAccess blocks
    


integer i;

reg [15:0] IR;
reg [2:0] dr;
wire [2:0] Dr,DrPPP,Sr1,Sr2,Sr1P,Sr2P,Sr1PP,Sr2PP,DrP,DrPP;
reg [15:0] sr1;
reg [15:0] sr2;
reg [ 2:0] PSR;
reg [15:0] reg_file[0:7];

reg [15:0] VSR1;
reg [15:0] VSR2;
reg N,Z,P;




DP_R D0(clock,Sr1,Sr2,Dr,Sr1P,Sr2PP,DrP);
DP_R D1(clock,Sr1P,Sr2P,DrP,Sr1PP,Sr2PP,DrPP);
DP_R D2(clock,,,DrPP,,,DrPPP);
//Hazard H0(DrP,DrPP,sr1,sr2,A_Control0,A_Control1);
assign Dr=dr;
assign Sr1=sr1;
assign Sr2=sr2;



always @(posedge clock) begin : proc_IR_reg
    
        IR = dout;
    
end
initial
begin

reg_file[0]=16'b0;
reg_file[1]=16'b0;
reg_file[2]=16'b0;
reg_file[3]=16'b0;
reg_file[4]=16'b0;
reg_file[5]=16'b0;
reg_file[6]=16'b0;
reg_file[7]=16'b0;
end

always @(posedge clock) begin : proc_PSR_reg
    if(ENR) begin
        PSR = {N,Z,P};
    end
end

always @(posedge clock) begin : proc_reg_file
    if(ENR) begin
        reg_file[DrPPP] = DR_in;
    end
end

always @(negedge clock)
begin
VSR1 = reg_file[sr1];
VSR2 = reg_file[sr2];
end

assign D_Data = {IR, VSR1, VSR2};

always @(*) begin : proc_decode
    case (IR[15:12])
        `ADD : begin
                M_Control = 1'b0;
                E_Control = {5'b000000, IR[5]};
                W_Control = 2'b00;
                F_Control = 1'b0;
                EN=1'b1;
                dr        = IR[11:9];
                sr1       = IR[ 8:6];
                sr2       = IR[ 2:0];

N =  DR_in[15];
P = ~DR_in[15];
Z = (DR_in == 16'b0);
            end
        `AND : begin
                M_Control = 1'b0;
                E_Control = 6'b100000;
                W_Control = 2'b00;
                F_Control = 1'b0;
                EN=1'b1;
                dr        = IR[11:9];
                sr1       = IR[ 8:6];
                sr2       = IR[ 2:0];
N =  DR_in[15];
P = ~DR_in[15];
Z = (DR_in == 16'b0);
            end
        `NOT : begin
                M_Control = 1'b0;
                E_Control = 6'b110000;
                W_Control = 2'b00;
                F_Control = 1'b0;
                EN=1'b1;
                dr        = IR[11:9];
                sr1       = IR[ 8:6];
                sr2       = IR[ 2:0];
N =  DR_in[15];
P = ~DR_in[15];
Z = (DR_in == 16'b0);
            end
        `BR  : begin
                M_Control = 1'b0;
if((PSR[2]&IR[11])||(PSR[1]&IR[10])||(PSR[0]&IR[9]))
                E_Control = 6'b000100;
else
E_Control=6'b001100;
                W_Control = 2'b00;
                F_Control = 1'b1;
                dr        = IR[11:9];
                sr1       = IR[ 8:6];
                sr2       = IR[ 2:0];
            end
        `JMP : begin
                M_Control = 1'b0;
                E_Control = 6'b001110;
                W_Control = 2'b00;
                F_Control = 1'b1;
                dr        = IR[11:9];
                sr1       = IR[ 8:6];
                sr2       = IR[ 2:0];
            end
        `JSR : begin
            if(IR[11]) begin
                M_Control = 1'b0;
                E_Control = 6'b001000;
                W_Control = 2'b10;
                F_Control = 1'b1;
                dr        = 3'b111;
                sr1       = IR[ 8:6];
                sr2       = IR[ 2:0];
            end else begin
                M_Control = 1'b0;
                E_Control = 6'b001110;
                W_Control = 2'b10;
                F_Control = 1'b1;
                dr        = 3'b111;
                sr1       = IR[ 8:6];
                sr2       = IR[ 2:0];
            end

            end
        `LD  : begin
                M_Control = 1'b0;
                E_Control = 6'b000100; //Changed from 6'b001000
                W_Control = 2'b11;
                F_Control = 1'b0;
                EN=1'b1;
                dr        = IR[11:9];
                sr1       = IR[ 8:6];
                sr2       = IR[ 2:0];

N =  DR_in[15];
P = ~DR_in[15];
Z = (DR_in == 16'b0);
            end
        `LDR : begin
                M_Control = 1'b0;
                E_Control = 6'b000110;
                W_Control = 2'b11;
                F_Control = 1'b0;
                dr        = IR[11:9];
                sr1       = IR[ 8:6];
                sr2       = IR[ 2:0];
N =  DR_in[15];
P = ~DR_in[15];
Z = (DR_in == 16'b0);
            end
        `LDI : begin
                M_Control = 1'b1;
                E_Control = 6'b000100; //Changed from 6'b001000
                W_Control = 2'b11;
                F_Control = 1'b0;
                dr        = IR[11:9];
                sr1       = IR[ 8:6];
                sr2       = IR[ 2:0];
N =  DR_in[15];
P = ~DR_in[15];
Z = (DR_in == 16'b0);
            end
        `LEA : begin
                M_Control = 1'b0;
                E_Control = 6'b001000;
                W_Control = 2'b01;
                F_Control = 1'b0;
                dr        = IR[11:9];
                sr1       = IR[ 8:6];
                sr2       = IR[ 2:0];
N =  DR_in[15];
P = ~DR_in[15];
Z = (DR_in == 16'b0);
            end
        `ST  : begin
                M_Control = 1'b0;
                E_Control = 6'b000100;
                W_Control = 2'b00;
                F_Control = 1'b0;
                EN=1'b1;
                dr        = IR[11:9];
                sr1       = IR[11:9]; //Field needs to be revised for which source register
                sr2       = IR[11:9];
            end
        `STR : begin
                M_Control = 1'b0;
                E_Control = 6'b000110;
                W_Control = 2'b00;
                F_Control = 1'b0;
                dr        = IR[11:9];
                sr1       = IR[11:9];
                sr2       = IR[11:9]; //Field needs to be revised
            end
        `STI : begin
                M_Control = 1'b1;
                E_Control = 6'b000100;//changed from 6'b001000
                W_Control = 2'b00;
                F_Control = 1'b0;
                dr        = IR[11:9];
                sr1       = IR[11:9];
                sr2       = IR[11:9]; //Field needs to be revised
            end
        default : begin
            M_Control = 1'b0;
            E_Control = 6'b000000;
            W_Control = 2'b00;
            F_Control = 1'b0;
            dr        = IR[11:9];
            sr1       = IR[ 8:6];
            sr2       = IR[ 2:0];
            //$display("error!, Undefinde instruction= %h", dout);
        end
    endcase

    case (dout[15:12])
        `ADD : C_Control = 6'b000000;
        `AND : C_Control = 6'b000000;
        `NOT : C_Control = 6'b000000;
        `BR  : C_Control = 6'b010000;
        `JMP : C_Control = 6'b010000;
        `JSR : C_Control = 6'b011000;
        `LD  : C_Control = 6'b100010;
        `LDR : C_Control = 6'b100010;
        `LDI : C_Control = 6'b100001;
        `LEA : C_Control = 6'b100110;
        `ST  : C_Control = 6'b100100;
        `STR : C_Control = 6'b100100;
        `STI : C_Control = 6'b100000;
        default : begin
            C_Control = 6'b000000;
            //$display("error!, Undefinde instruction= %h", dout);
        end
    endcase
end





endmodule
