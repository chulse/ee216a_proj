`timescale 1ns/100ps

module Pipelined_tb;
wire [9:0] pixel_1,pixel_2,pixel_3,pixel_4;
wire [18:0] weight_1,weight_2,weight_3,weight_4;
wire [25:0] output_test;
reg clk,reset;

//////////////////////////////////////////////////////////////////////
assign	pixel_4 = 10'b00_0011_0010; //should be '50'
assign	pixel_3 = 10'b00_0011_0010; //100
assign	pixel_2 = 10'b00_0011_0010; //150
assign	pixel_1 = 10'b00_0011_0010; //200

assign	weight_4 = 19'b001_0000_0000_0000_0000; //should be 1/4 or 0.25
assign	weight_3 = 19'b001_0000_0000_0000_0000; //should be 1/8
assign	weight_2 = 19'b001_0000_0000_0000_0000; //should be 1/32
assign	weight_1 = 19'b001_0000_0000_0000_0000; //should be 1/16
//////////////////////////////////////////////////////////////////////
//NOTE: It runs through pixels in reverse orders cause of how they are inserted below

PipelinedMultAccumulate dut_0(
    .IN_PIXELS({pixel_1,pixel_2,pixel_3,pixel_4}),
    .IN_WEIGHTS({weight_1,weight_2,weight_3,weight_4}),
    .OUT(output_test),
    .clk(clk),
    .rst(reset)
    );
    
  defparam dut_0.NUM_INPUTS=4;

always #2 clk=~clk;  //cycle time is 4ns

initial begin
  // $fsdbDumpfile("dut.fsdb");
  // $fsdbDumpvars;
  $monitor("t=%3d OUT=%b,\n",$time,output_test);

  reset=1'b0;clk=1'b1;
  #10 reset=1'b1;                            // system reset
  #10 reset=1'b0;

  #1000;
  $display("CODE RAN %d\n",323);

  #10 $finish;

end

	//----------------------------------------------------------------
	//		VCD Dump
	//----------------------------------------------------------------
	// initial begin
		// $sdf_annotate("dut.sdf", dut_0);  
		// $dumpfile("dut.vcd"); 
		// $dumpvars;
	// end

endmodule
