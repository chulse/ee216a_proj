`timescale 1ns/100ps

module Max_selector_tb();

// Inputs (made all 5 bit for easier test)
reg [4:0] image_number_0;
reg [4:0] image_number_1;
reg [4:0] image_number_2;
reg [4:0] image_number_3;
reg [4:0] image_number_4;
reg [4:0] image_number_5;
reg [4:0] image_number_6;
reg [4:0] image_number_7;
reg [4:0] image_number_8;
reg [4:0] image_number_9;
reg clk;
reg rst;

// Output 
wire [4:0] max;

Max_selector test(  image_number_0,
					image_number_1,
					image_number_2,
					image_number_3,
					image_number_4,
					image_number_5,
					image_number_6,
					image_number_7,
					image_number_8,
					image_number_9,
					clk,
					rst,
					max);
					

initial begin
  clk = 0;
    forever begin
    #4 clk = ~clk;
 	end
 end
 
initial  
	begin
      $dumpfile("dump.vcd");
      $dumpvars(1);
    end

initial 
	begin
		$monitor("Max = %d",max);
		
		assign rst = 0;
		assign image_number_0 = 1;
		assign image_number_1 = 2;
		assign image_number_2 = 3;
		assign image_number_3 = 4;
		assign image_number_4 = 5;
		assign image_number_5 = 6;
		assign image_number_6 = 7;
		assign image_number_7 = 8;
		assign image_number_8 = 9;
		assign image_number_9 = 10; //Max
		
		#4
		
		assign image_number_0 = 1;
		assign image_number_1 = 2;
		assign image_number_2 = 3;
		assign image_number_3 = 4;
		assign image_number_4 = 5;
		assign image_number_5 = 14; //Max
		assign image_number_6 = 7;
		assign image_number_7 = 8;
		assign image_number_8 = 9;
		assign image_number_9 = 10;
		
		#4
		
		assign image_number_0 = 1;
		assign image_number_1 = 13; //Max
		assign image_number_2 = 3;
		assign image_number_3 = 4;
		assign image_number_4 = 5;
		assign image_number_5 = 6; 
		assign image_number_6 = 7;
		assign image_number_7 = 8;
		assign image_number_8 = 9;
		assign image_number_9 = 0;
		
		#4
		assign rst = 1;
  		#16 $finish;
	end
endmodule