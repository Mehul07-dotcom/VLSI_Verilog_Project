// Code your design here
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.06.2025 18:06:36
// Design Name: 
// Module Name: fifo_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
       
  
  
  always@(posedge clk or posedge rst_n)begin 
    if (!rst_n)
             begin 
               overflow = 1'b0;
               underflow = 1'b0;
               empty = 1'b0;
               full = 1'b0;
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
