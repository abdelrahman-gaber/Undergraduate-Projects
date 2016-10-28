`include "lc3_pkg.v"

//////////////////////////////////////////////////////////////////////////////////
// Company:     Mentor Graphics.
// Engineer:    Khalifa.
// Create Date: 23:27:05 06/22/2014
// Module Name: controller.
// Project Name:LC3 Controller

//////////////////////////////////////////////////////////////////////////////////
//states

module controller(clock, reset, c_control, complete, state);

	 input  clock, reset;    // system clock and reset
	 input  complete;        // complete from Memory
	 input  [5:0] c_control; // input and control from Decode
	 output [3:0] state; // system state



	 wire [1:0]type,memory_access_mode;  //instructions from c_control.
	 wire store_pc,load;                 //instructions from c_control.
	 reg  [3:0]current_state,next_state; //registers.

	 //register:
	 always@(posedge clock) begin
	  if(~reset)
		 current_state <= `FETCH_INSTRUCTION ;
	  else
		 current_state <= next_state;
	 end//end always

	 //next_state_logic and output logic

	  always@(*)begin

		case(current_state)
		 `FETCH_INSTRUCTION : begin
			if(complete)
			 next_state=`DECODE;
			else
			 next_state = `FETCH_INSTRUCTION;
		 end//end case1

		 `DECODE: begin
		  if(type==2'b00)
			next_state= `EXECUTE_ALU;
		  else if(type==2'b01)
			next_state= `COMPUTE_TPC;
		  else if(type==2'b10)
			next_state= `COMPUTE_MEM_ADRR;
		  else
		  	next_state = `INVALID_STATE;
		 end//end case2

		 `EXECUTE_ALU:begin
			next_state= `UPDATE_REG_FILE;
		 end//end case3

		 `COMPUTE_TPC :begin
		  if(store_pc)
			next_state=`UPDATE_REG_FILE;
		  else
		  next_state=`UPDATE_PC;
		 end//end case4

		 `COMPUTE_MEM_ADRR: begin
		  if(memory_access_mode==2'b00)
			 next_state=`INDIRECT_ADDR_READ;
		  else if(memory_access_mode==2'b01)
			 next_state=`READ_MEM;
		  else if(memory_access_mode==2'b10)
			 next_state=`WRITE_MEM;
		  else
			 next_state=`UPDATE_REG_FILE;
		 end//end case5

		 `READ_MEM:begin
		  if (complete)
			next_state=`UPDATE_REG_FILE;
		  else
			next_state=`READ_MEM;
		  end//end case6

		 `INDIRECT_ADDR_READ:begin
		  if (!complete)
		 	next_state = `INDIRECT_ADDR_READ;
		  else if(load)
			next_state=`READ_MEM;
		  else
			next_state=`WRITE_MEM;
		 end//end case7

		 `WRITE_MEM:begin
		  if(complete)
			next_state=`UPDATE_PC;
		  else
			next_state=`WRITE_MEM;
		 end//end case8

		 `UPDATE_REG_FILE:begin
		  next_state=`UPDATE_PC;
		 end//end case9

		 `UPDATE_PC:begin
			next_state=`FETCH_INSTRUCTION;
		 end// end case10

		 default:
			next_state=`INVALID_STATE;

	  endcase //end case
	 end //end always

	assign{type,store_pc,memory_access_mode,load} = c_control;//control instructions
	assign state = current_state;                            //current state of the system
endmodule
