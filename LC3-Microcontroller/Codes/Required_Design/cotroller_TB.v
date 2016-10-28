`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        Mentor Graphics(contest).
// Engineer:       khalifa.
// Create Date:    02:10:36 06/24/2014 
// Module Name:    cotroller_TB. 
// Project Name:   LC3 controller.
// Description:    TestBensh for controller.

//////////////////////////////////////////////////////////////////////////////////
module cotroller_TB;
 reg clock,reset;   //global clock & reset.
 reg [5:0]c_control;//control instructions.
 reg complete;      //complete input signal.
 wire[3:0]state;    //system state(current state).
 
 integer i,j;
 
//instantiation
 controller controller_tb(clock, reset, c_control, complete, state);


//setup clock 
 always  #5  clock =  ! clock;
 
//Stimulus
 initial begin
  reset=1; 
  clock =0;
  #10 reset =0;
  #10 complete=0;
   for(i=0;i<64;i=i+1) begin
	  c_control = i;
	  #10;
	   for(j=0;j<2;j=j+1) begin
	      complete = j;
	        #100;
	   end//end for_loop
	  #10 complete=0; 
	end//end for_loop
 end//end stimulus initial
 
//Monitor
 initial begin
   $display("\t\t   Clock \t\t reset \t\t complete \t\t c_control \t\t state  \n");
   $monitor($time,   ,clock ,     ,reset,    ,complete,    ,c_control,       ,state,);
	end
 
 
//Testcases
//cornenr cases
endmodule
