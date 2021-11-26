`timescale 1ns/100ps

module Neuron(IN_PIXELS, IN_WEIGHTS, BIAS, OUT, done, clk, rst);
parameter NUM_INPUTS = 784;
parameter PIXEL_WIDTH = 10; //10-0 (int-deci)
parameter WEIGHT_WIDTH = 19; //1-18
parameter OUTPUT_WIDTH = 26; //8-18
input [NUM_INPUTS*PIXEL_WIDTH-1:0] IN_PIXELS;
input [NUM_INPUTS*WEIGHT_WIDTH-1:0] IN_WEIGHTS;
input clk;
input rst;
output [OUTPUT_WIDTH-1:0] OUT;
output done;

parameter NUM_OF_ACCUMULATORS = 16; //need 49x16 steps (was going to be 28x28 but 10 neurons is 280 multipliers, too many)
parameter BATCH_SIZE = 49; //each accumulator handles 49 pixels
//Now each Neuron will do 49 batches of 16 multipliers each.

wire [OUTPUT_WIDTH*NUM_OF_ACCUMULATORS-1:0] temp_outputs;
wire [NUM_OF_ACCUMULATORS-1:0] done_signals;
reg [OUTPUT_WIDTH-1:0] out_buf; //total sum


genvar i;
generate
    for (i = 0; i < NUM_OF_ACCUMULATORS; i=i+1) begin
        PipelinedMultAccumulate mult_0(
            .IN_PIXELS(IN_PIXELS[i*PIXEL_WIDTH*BATCH_SIZE +: PIXEL_WIDTH*BATCH_SIZE]),
            .IN_WEIGHTS(IN_WEIGHTS[i*WEIGHT_WIDTH*BATCH_SIZE +: WEIGHT_WIDTH*BATCH_SIZE]),
            .OUT(temp_outputs[i*OUTPUT_WIDTH +: OUTPUT_WIDTH]),
            .clk(clk),
            .rst(rst),
            .done(done_signals[i])
            );
        defparam mult_0.NUM_INPUTS=BATCH_SIZE;
    end
endgenerate



integer k;
always @(temp_outputs) begin
  out_buf = 0;
  for (k=0; k<NUM_OF_ACCUMULATORS; k=k+1)
    out_buf = out_buf + temp_outputs[k*OUTPUT_WIDTH +: OUTPUT_WIDTH];
end
assign OUT = out_buf + BIAS;
assign done = 0;//done_signals!=0;

endmodule
