`include "define.h"

`define log_floor(n)   ((n) <= (1<<0) ? 0 : (n) <= (1<<1) ? 1 :\
						(n) <= (1<<2) ? 2 : (n) <= (1<<3) ? 3 :\
						(n) <= (1<<4) ? 4 : (n) <= (1<<5) ? 5 :\
						(n) <= (1<<6) ? 6 : (n) <= (1<<7) ? 7 :\
						(n) <= (1<<8) ? 8 : (n) <= (1<<9) ? 9 :\
						(n) <= (1<<10) ? 10 : (n) <= (1<<11) ? 11 :\
						(n) <= (1<<12) ? 12 : (n) <= (1<<13) ? 13 :\
						(n) <= (1<<14) ? 14 : (n) <= (1<<15) ? 15 :\
						(n) <= (1<<16) ? 16 : (n) <= (1<<17) ? 17 :\
						(n) <= (1<<18) ? 18 : (n) <= (1<<19) ? 19 :\
						(n) <= (1<<20) ? 20 : (n) <= (1<<21) ? 21 :\
						(n) <= (1<<22) ? 22 : (n) <= (1<<23) ? 23 :\
						(n) <= (1<<24) ? 24 : (n) <= (1<<25) ? 25 :\
						(n) <= (1<<26) ? 26 : (n) <= (1<<27) ? 27 :\
						(n) <= (1<<28) ? 28 : (n) <= (1<<29) ? 29 :\
						(n) <= (1<<30) ? 30 : (n) <= (1<<31) ? 31 : 32) 

module singleDelayWithEnableGeneric_new #(parameter bitwidth=16)(clk, grst, rst, en, inp,outp);
   input  clk, grst, rst, en;
   input [bitwidth-1:0] inp;
   output [bitwidth-1:0] outp;
   reg [bitwidth-1:0] 	 outreg;

   always @(`proclineg)
     begin
        if (grst==`activehigh)
          outreg <= {bitwidth{1'b0}};
        else if (rst==1)
          outreg <= {bitwidth{1'b0}};
        else if (en)
          outreg <= inp;
     end
   assign outp = outreg;
   
endmodule //singleDelayWithEnableGeneric

module synDelayWithEnable_new #(parameter bitwidth = 16, parameter delaylength=100, parameter preferRAMImpl=1)(clk, grst, rst, en, inp,outp);

   input clk, grst, rst, en;
   input [bitwidth-1:0] inp;
   output [bitwidth-1:0] outp;

   generate
      begin: GenBlock
		 if (delaylength == 0)
		   assign outp = inp;
		 else if (delaylength == 1)
		   singleDelayWithEnableGeneric_new #( .bitwidth(bitwidth)) theDelay ( .clk(clk), .en(en), .grst(grst), .rst(rst), .inp(inp), .outp(outp) );
		 else
		   synDelayWithEnableGeneric_new #( .bitwidth(bitwidth), .delaylength(delaylength), .preferRAMImpl(preferRAMImpl) ) theDelay ( .clk(clk), .en(en), .grst(grst), .rst(rst), .inp(inp), .outp(outp) );
      end // GenBlock
   endgenerate

endmodule


module synDelayWithEnableGeneric_new #(parameter bitwidth = 16, parameter delaylength=100, parameter preferRAMImpl=1)(clk, grst, rst, en, inp,outp);


   parameter decompRegs = 2;
   parameter decompThresholdMin = 9;
   parameter ramThreshold = 68;
   parameter forceRAMThreshold = 4000;
   
   parameter cntWidth = `log_floor(delaylength);
   parameter decompThresholdBW = (64 / bitwidth) + 2*decompRegs;
   parameter delayNRLen = delaylength-2*decompRegs > 0 ? delaylength-2*decompRegs : 0;
   
   parameter resetType = `grsttype;
   
   input  clk, grst, rst, en;
   input [bitwidth-1:0] inp;
   output [bitwidth-1:0] outp;

   reg [bitwidth-1:0] 	 delayline [0:delaylength-1];
   reg [bitwidth-1:0] 	 delayLineClip [0:delayNRLen-1];
   reg [bitwidth-1:0] 	 regsL [0:decompRegs-1];
   reg [bitwidth-1:0] 	 regsR [0:decompRegs-1];
   reg [cntWidth-1:0] 	 cnt;
   reg 					 resetExpired;
   reg 					 cntDone;

   generate
	  begin: GenBlock
		 if ( resetType == "asynch" )
		   begin : asynch_implementation
			  if ((preferRAMImpl == 1 && delaylength > ramThreshold) || (delaylength > forceRAMThreshold && preferRAMImpl != 2 ) )
				begin: implementRAM
				   integer i;
				   always @ (`proclineg)
					 begin
						if (grst==`activehigh)
						  begin
							 resetExpired <= 1'b0;
							 cnt <= {cntWidth{1'b0}};
							 for (i=0; i < decompRegs; i=i+1)
							   begin
								  regsL[i] <= {bitwidth{1'b0}};
								  regsR[i] <= {bitwidth{1'b0}};
							   end
						  end
						else if (rst==1)
						  begin
							 resetExpired <= 1'b0;
							 cnt <= {cntWidth{1'b0}};
							 for (i=0; i < decompRegs; i=i+1)
							   begin
								  regsL[i] <= {bitwidth{1'b0}};
								  regsR[i] <= {bitwidth{1'b0}};
							   end
						  end
						else if (en)
						  begin
							 if (cnt == delayNRLen - 1) 
							   begin
								  resetExpired <= 1'b1;
								  cnt <= {cntWidth{1'b0}};
							   end
							 else
							   cnt <= cnt + 1;
							 regsL[0] <= inp;
							 for (i=1; i < decompRegs; i=i+1)
							   begin
								  regsL[i] <= regsL[i-1];
								  regsR[i] <= regsR[i-1];
							   end
							 regsR[0] <= resetExpired ? delayLineClip[cnt] : 0;
						  end
					 end // process
				   always @ (`proclineg)
					 begin     
						if(grst==`activehigh)
						  begin
							// synthesis loop_limit 8000	
							 for (i=0; i < delayNRLen; i=i+1)
							   delayLineClip[i] <= 0;
						  end
						else if (en)
      					  delayLineClip[cnt] <= regsL[decompRegs-1];   
					 end 
				   assign outp = regsR[decompRegs-1];
				end
			  else if(preferRAMImpl == 0 && delaylength >= decompThresholdMin && delaylength >= decompThresholdBW)
				begin : norstshift
				   integer i;
				   always @ (`proclineg)
					 begin
						if(grst==`activehigh)
						  begin
							 cnt <= $unsigned(0);
							 cntDone <= 1'b0;
							 for (i=0; i < decompRegs; i=i+1)
							   begin
								  regsL[i] <= {bitwidth{1'b0}};
								  regsR[i] <= {bitwidth{1'b0}};
							   end
						  end
						else if(rst==1)
						  begin
							 cnt <= $unsigned(0);
							 cntDone <= 1'b0;
							 for (i=0; i < decompRegs; i=i+1)
							   begin
								  regsL[i] <= {bitwidth{1'b0}};
								  regsR[i] <= {bitwidth{1'b0}};
							   end
						  end
						else if(en)
						  begin
							 if(cnt == $unsigned(delayNRLen-1))
							   cntDone <= 1'b1;
							 if(!cntDone)
							   cnt <= cnt + 1;
							 regsL[0] <= inp;
							 // synthesis loop_limit 8000            
							 for (i=1; i < decompRegs; i=i+1)
							   begin
								  regsL[i] <= regsL[i-1];
								  regsR[i] <= regsR[i-1];
							   end
							 regsR[0] <= (cntDone) ? delayLineClip[delayNRLen-1] : {bitwidth{1'b0}};
						  end
					 end // process
				   always @ (`proclineg)
					 begin     
						if(grst==`activehigh)
						  begin
							 // synthesis loop_limit 8000	
							 for (i=0; i < delayNRLen; i=i+1)
							   delayLineClip[i] <= 0;
						  end
						else if (en) 
						  begin
							 // synthesis loop_limit 8000
							 for (i=1; i < delayNRLen; i=i+1)
							   delayLineClip[i] <= delayLineClip[i-1];
							 delayLineClip[0] <= regsL[decompRegs-1];
						  end
					 end
				   assign outp = regsR[decompRegs-1];
				end //norstshift
			  
			  else if(delaylength > 0 || preferRAMImpl == 2)
				begin : RegisterStyle
				   integer i;
				   // Implement as registers 
				   always @(`proclineg)
					 begin
						// synthesis loop_limit 65536
						if (grst==`activehigh)
						  for (i = 0; i < delaylength; i = i + 1)
							delayline[i] <= {bitwidth{1'b0}};
						// synthesis loop_limit 65536
						else if (rst==1)
						  for (i = 0; i < delaylength; i = i + 1)
							delayline[i] <= {bitwidth{1'b0}};
						else if (en)
						  begin
							 // synthesis loop_limit 65536
							 for(i = delaylength-1; i>=1; i=i-1)
							   delayline[i] <= delayline[i-1];
							 delayline[0] <= inp;
						  end 
					 end
				   assign outp = delayline[delaylength-1];
				end // RegisterStyle
			  
			  else
				begin : nodelay
				   assign outp = inp;
				end
		   end // asynch_implementation
		 if ( resetType == "synch" )
		   begin : synch_implementation
			  if ((preferRAMImpl == 1 && delaylength > ramThreshold) || (delaylength > forceRAMThreshold && preferRAMImpl != 2 ) )
				begin: implementRAM
				   integer i;
				   always @ (`proclineg)
					 begin
						if (grst==`activehigh || rst==1)
						  begin
							 resetExpired <= 1'b0;
							 cnt <= {cntWidth{1'b0}};
							 for (i=0; i < decompRegs; i=i+1)
							   begin
								  regsL[i] <= {bitwidth{1'b0}};
								  regsR[i] <= {bitwidth{1'b0}};
							   end
						  end
						else if (en)
						  begin
							 if (cnt == delayNRLen - 1) 
							   begin
								  resetExpired <= 1'b1;
								  cnt <= {cntWidth{1'b0}};
							   end
							 else
							   cnt <= cnt + 1;
							 regsL[0] <= inp;
							 for (i=1; i < decompRegs; i=i+1)
							   begin
								  regsL[i] <= regsL[i-1];
								  regsR[i] <= regsR[i-1];
							   end
							 regsR[0] <= resetExpired ? delayLineClip[cnt] : 0;
						  end
					 end // process
				   always @ (`proclineg)
					 begin
						// synthesis loop_limit 8000
						if (grst==`activehigh)
						  for (i=0; i < delayNRLen; i=i+1)
							delayLineClip[i] <= 0;
						else if (en)
      					  delayLineClip[cnt] <= regsL[decompRegs-1];             
					 end 
				   assign outp = regsR[decompRegs-1];
				end
			  else if(preferRAMImpl == 0 && delaylength >= decompThresholdMin && delaylength >= decompThresholdBW)
				begin : norstshift
				   integer i;
				   always @ (`proclineg)
					 begin
						if(grst==`activehigh || rst==1)
						  begin
							 cnt <= $unsigned(0);
							 cntDone <= 1'b0;
							 for (i=0; i < decompRegs; i=i+1)
							   begin
								  regsL[i] <= {bitwidth{1'b0}};
								  regsR[i] <= {bitwidth{1'b0}};
							   end
						  end
						else if(en)
						  begin
							 if(cnt == $unsigned(delayNRLen-1))
							   cntDone <= 1'b1;
							 if(!cntDone)
							   cnt <= cnt + 1;
							 regsL[0] <= inp;
							 // synthesis loop_limit 8000            
							 for (i=1; i < decompRegs; i=i+1)
							   begin
								  regsL[i] <= regsL[i-1];
								  regsR[i] <= regsR[i-1];
							   end
							 regsR[0] <= (cntDone) ? delayLineClip[delayNRLen-1] : {bitwidth{1'b0}};
						  end
					 end // process
				   always @ (`proclineg)
					 begin
						if (grst==`activehigh)
						  // synthesis loop_limit 8000	
						  for (i=0; i < delayNRLen; i=i+1)
							delayLineClip[i] <= 0;
						else if (en) 
						  begin
							 // synthesis loop_limit 8000
							 for (i=1; i < delayNRLen; i=i+1)
							   delayLineClip[i] <= delayLineClip[i-1];
							 delayLineClip[0] <= regsL[decompRegs-1];
						  end
					 end
				   assign outp = regsR[decompRegs-1];
				end //norstshift
			  
			  else if(delaylength > 0 || preferRAMImpl == 2)
				begin : RegisterStyle
				   integer i;
				   // Implement as registers 
				   always @(`proclineg)
					 begin
						// synthesis loop_limit 65536
						if (grst==`activehigh || rst==1)
						  for (i = 0; i < delaylength; i = i + 1)
							delayline[i] <= {bitwidth{1'b0}};
						else if (en)
						  begin
							 // synthesis loop_limit 65536
							 for(i = delaylength-1; i>=1; i=i-1)
							   delayline[i] <= delayline[i-1];
							 delayline[0] <= inp;
						  end 
					 end
				   assign outp = delayline[delaylength-1];
				end // RegisterStyle
			  
			  else
				begin : nodelay
				   assign outp = inp;
				end
		   end // synch_implementation    
	  end // GenBlock
	  
   endgenerate

endmodule
