// Code your design here
`timescale 1ns / 1ps



module FIFO_SYNC(
input clk,wr_en,rd_en,rst_n,
input [7:0] d_in,
output reg [7:0] d_out,
output reg  full,empty,
output reg overflow,underflow);

 // define parameters 
    parameter FIFO_WIDTH = 8;
    parameter FIFO_DEPTH = 8;
 // get which bit  of ponter we should use 
 localparam FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH);
 // define memory block 
 reg [FIFO_WIDTH-1:0]mem[0:FIFO_DEPTH-1];
 //define poiinters
 reg [FIFO_DEPTH_LOG:0] wrt_ptr;
 reg [FIFO_DEPTH_LOG:0] rd_ptr;
 // write logic 
 
 always@(posedge clk or negedge rst_n)
 begin 
 if (!rst_n)begin
 
     wrt_ptr <= 1'b0;
    
    end
    
     else if (wr_en&&~full)begin
     mem [wrt_ptr[FIFO_DEPTH_LOG-1:0]] <= d_in;
     wrt_ptr <= wrt_ptr+1'b1;
     
     end
     
     
     
     end 
    
  // read logic
 always@ (posedge clk or negedge rst_n)
  begin
     if (!rst_n)begin

       rd_ptr <= 1'b0;
       d_out <= 0;
       
       
      end
       else if (!empty && rd_en)
       begin
       d_out <= mem[rd_ptr[FIFO_DEPTH_LOG-1:0]];
       rd_ptr <= rd_ptr +1'b1;
       
       end 
      
      end 
       
  
  // flag declaration :~ empty , full,overflow, underflow:
  always@(posedge clk or posedge rst_n)begin 
    if (!rst_n)
             begin 
               overflow = 0;
               underflow = 0;
               empty = 0;
               full = 0;
             end 
   else begin
           overflow = (full && wr_en);
           underflow = (empty && rd_en);
            empty = (wrt_ptr == rd_ptr);
            full  = ((wrt_ptr[FIFO_DEPTH_LOG] != rd_ptr[FIFO_DEPTH_LOG]) &&
                (wrt_ptr[FIFO_DEPTH_LOG-1:0] == rd_ptr[FIFO_DEPTH_LOG-1:0]));
    
   end
  end
  
     endmodule
