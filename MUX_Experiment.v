//Add to Image_Classifier.v

reg [25:0] Image_Number_Arr [9:0];
wire [10*784-1:0] PIXELS;
wire [19*784-1:0] WEIGHTS_0;
wire [19*784-1:0] WEIGHTS_1;
wire [19*784-1:0] WEIGHTS_2;
wire [19*784-1:0] WEIGHTS_3;
wire [19*784-1:0] WEIGHTS_4;
wire [19*784-1:0] WEIGHTS_5;
wire [19*784-1:0] WEIGHTS_6;
wire [19*784-1:0] WEIGHTS_7;
wire [19*784-1:0] WEIGHTS_8;
wire [19*784-1:0] WEIGHTS_9;

reg [19*784-1:0] WEIGHTS;
reg [18:0] WEIGHT_BIAS;
wire [25:0] Image_out;
reg [3:0] sel;
reg [3:0] i;

always @ (sel) begin
      case (sel)
         4'b0000 : begin
         WEIGHTS <= WEIGHTS_0;
         WEIGHT_BIAS <= Wgt_0_784;
         Image_Number_Arr[0] = Image_out;
         end
        
         4'b0001 : begin
         WEIGHTS <= WEIGHTS_1;
         WEIGHT_BIAS <= Wgt_1_784;
         Image_Number_Arr[1] = Image_out;
         end
         
         4'b0010 : begin
         WEIGHTS <= WEIGHTS_2;
         WEIGHT_BIAS <= Wgt_2_784;
         Image_Number_Arr[2] = Image_out;
         end
         
         4'b0011 : begin
         WEIGHTS <= WEIGHTS_3;
         WEIGHT_BIAS <= Wgt_3_784;
         Image_Number_Arr[3] = Image_out;
         end
         
         4'b0100 : begin
         WEIGHTS <= WEIGHTS_4;
         WEIGHT_BIAS <= Wgt_4_784;
         Image_Number_Arr[4] = Image_out;
         end
         
         4'b0101 : begin
         WEIGHTS <= WEIGHTS_5;
         WEIGHT_BIAS <= Wgt_5_784;
         Image_Number_Arr[5] = Image_out;
         end
         
         4'b0110 : begin
         WEIGHTS <= WEIGHTS_6;
         WEIGHT_BIAS <= Wgt_6_784;
         Image_Number_Arr[6] = Image_out;
         end
         
         4'b0111 : begin
         WEIGHTS <= WEIGHTS_7;
         WEIGHT_BIAS <= Wgt_7_784;
         Image_Number_Arr[7] = Image_out;
         end
         
         4'b1000 : begin
         WEIGHTS <= WEIGHTS_8;
         WEIGHT_BIAS <= Wgt_8_784;
         Image_Number_Arr[8] = Image_out;
         end
         
         4'b1001 : begin
         WEIGHTS <= WEIGHTS_9;
         WEIGHT_BIAS <= Wgt_9_784;
         Image_Number_Arr[9] = Image_out;
         end
         
         default: begin
         WEIGHTS <= 0;
         WEIGHT_BIAS <= 0;
         end
         
      endcase
   end
   
always @ (i or sel or Output_Valid) begin
    if (! GlobalReset) begin
    	i <= 0;
      	sel <= 0;
    end 
    else begin
    	i <= i + 1;
      	sel <= sel + 1;
    end
  end


Neuron N(
 .IN_PIXELS(PIXELS),
 .IN_WEIGHTS(WEIGHTS),
 .BIAS(WEIGHT_BIAS),
 .OUT(Image_out),
 .done(Output_Valid),
 .clk(clk),
 .rst(GlobalReset));
 
