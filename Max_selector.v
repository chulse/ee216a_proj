module Max_selector(
    input [25:0] image_number_0,
    input [25:0] image_number_1,
    input [25:0] image_number_2,
    input [25:0] image_number_3,
	input [25:0] image_number_4,
	input [25:0] image_number_5,
	input [25:0] image_number_6,
	input [25:0] image_number_7,
	input [25:0] image_number_8,
	input [25:0] image_number_9,
	input clk,
	input rst,
	output reg [3:0] max
    );

always @(posedge clk) begin
	if(rst)
				max = 15; // made 4'b1111 to know rst is HI

	else if(	image_number_0 >= image_number_1 && 
				image_number_0 >= image_number_2 && 
				image_number_0 >= image_number_3 && 
				image_number_0 >= image_number_4 && 
				image_number_0 >= image_number_5 && 
				image_number_0 >= image_number_6 && 
				image_number_0 >= image_number_7 && 
				image_number_0 >= image_number_8 && 
				image_number_0 >= image_number_9 )
			
				max = 0;

	else if( 	image_number_1 >= image_number_0 && 
				image_number_1 >= image_number_2 && 
				image_number_1 >= image_number_3 && 
				image_number_1 >= image_number_4 && 
				image_number_1 >= image_number_5 && 
				image_number_1 >= image_number_6 && 
				image_number_1 >= image_number_7 && 
				image_number_1 >= image_number_8 && 
				image_number_1 >= image_number_9 )
			
				max = 1;

	else if( 	image_number_2 >= image_number_1 && 
				image_number_2 >= image_number_0 && 
				image_number_2 >= image_number_3 && 
				image_number_2 >= image_number_4 && 
				image_number_2 >= image_number_5 && 
				image_number_2 >= image_number_6 && 
				image_number_2 >= image_number_7 && 
				image_number_2 >= image_number_8 && 
				image_number_2 >= image_number_9 )
			
				max = 2;

	else if(	image_number_3 >= image_number_1 && 
				image_number_3 >= image_number_2 && 
				image_number_3 >= image_number_0 && 
				image_number_3 >= image_number_4 && 
				image_number_3 >= image_number_5 && 
				image_number_3 >= image_number_6 && 
				image_number_3 >= image_number_7 && 
				image_number_3 >= image_number_8 && 
				image_number_3 >= image_number_9 )
			
				max = 3;

	else if(	image_number_4 >= image_number_1 && 
				image_number_4 >= image_number_2 && 
				image_number_4 >= image_number_3 && 
				image_number_4 >= image_number_0 && 
				image_number_4 >= image_number_5 && 
				image_number_4 >= image_number_6 && 
				image_number_4 >= image_number_7 && 
				image_number_0 >= image_number_8 && 
				image_number_4 >= image_number_9 )
			
				max = 4;

	else if(	image_number_5 >= image_number_1 && 
				image_number_5 >= image_number_2 && 
				image_number_5 >= image_number_3 && 
				image_number_5 >= image_number_4 && 
				image_number_5 >= image_number_0 && 
				image_number_5 >= image_number_6 && 
				image_number_5 >= image_number_7 && 
				image_number_5 >= image_number_8 && 
				image_number_5 >= image_number_9 )
			
				max = 5;

	else if(	image_number_6 >= image_number_1 && 
				image_number_6 >= image_number_2 && 
				image_number_6 >= image_number_3 && 
				image_number_6 >= image_number_4 && 
				image_number_6 >= image_number_5 && 
				image_number_6 >= image_number_0 && 
				image_number_6 >= image_number_7 && 
				image_number_6 >= image_number_8 && 
				image_number_6 >= image_number_9 )

				max = 6;

	else if(	image_number_7 >= image_number_1 && 
				image_number_7 >= image_number_2 && 
				image_number_7 >= image_number_3 && 
				image_number_7 >= image_number_4 && 
				image_number_7 >= image_number_5 && 
				image_number_7 >= image_number_6 && 
				image_number_7 >= image_number_0 && 
				image_number_7 >= image_number_8 && 
				image_number_7 >= image_number_9 )
			
				max = 7;

	else if(	image_number_8 >= image_number_1 && 
				image_number_8 >= image_number_2 && 
				image_number_8 >= image_number_3 && 
				image_number_8 >= image_number_4 && 
				image_number_8 >= image_number_5 && 
				image_number_8 >= image_number_6 && 
				image_number_8 >= image_number_7 && 
				image_number_8 >= image_number_0 && 
				image_number_8 >= image_number_9 )
			
				max = 8;

	else if(	image_number_9 >= image_number_1 && 
				image_number_9 >= image_number_2 && 
				image_number_9 >= image_number_3 && 
				image_number_9 >= image_number_4 && 
				image_number_9 >= image_number_5 && 
				image_number_9 >= image_number_6 && 
				image_number_9 >= image_number_7 && 
				image_number_9 >= image_number_8 && 
				image_number_9 >= image_number_0 )
			
				max = 9;
			
	else
				max = 14; // rst LOW but error occurred
	end
endmodule
