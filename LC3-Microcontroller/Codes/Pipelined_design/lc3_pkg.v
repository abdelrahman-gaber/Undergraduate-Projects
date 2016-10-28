
`define FETCH_INSTRUCTION   4'b0000
`define DECODE              4'b0001
`define EXECUTE_ALU         4'b0010
`define COMPUTE_TPC         4'b0011
`define COMPUTE_MEM_ADRR    4'b0100
`define READ_MEM            4'b0101
`define INDIRECT_ADDR_READ  4'b0110
`define WRITE_MEM           4'b0111
`define UPDATE_REG_FILE     4'b1000
`define UPDATE_PC           4'b1001
`define INVALID_STATE       4'b1010

`define ADD  4'b0001
`define AND  4'b0101
`define BR   4'b0000
`define JMP  4'b1100
`define RET  4'b1100
`define JSR  4'b0100
`define JSRR 4'b0100
`define LD   4'b0010
`define LDI  4'b1010
`define LDR  4'b0110
`define LEA  4'b1110
`define NOT  4'b1001
`define ST   4'b0011
`define STI  4'b1011
`define STR  4'b0111


