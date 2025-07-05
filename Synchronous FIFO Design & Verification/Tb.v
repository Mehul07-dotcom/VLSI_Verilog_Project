// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module FIFO_SYNC_TB();
    reg clk = 0;
    reg wr_en, rd_en, rst_n;
    reg [7:0] d_in;
    wire [7:0] d_out;
    wire full, empty;
    wire overflow,underflow;

    parameter FIFO_DEPTH = 8;
    parameter FIFO_WIDTH = 8;
integer i;
    

    // DUT instantiation
    FIFO_SYNC #( 
        .FIFO_WIDTH(FIFO_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .d_in(d_in),
        .d_out(d_out),
        .full(full),
        .empty(empty),
        .overflow(overflow),
        .underflow(underflow)
    );
     
     
    // Clock generation
    always #5 clk = ~clk;

  

    // Write task
    task wrt_data(input [FIFO_WIDTH-1:0] data_in);
    begin
        @(posedge clk);
        wr_en = 1;
        d_in = data_in;
        $display($time, " Writing data = %0d", d_in);
        @(posedge clk);
        wr_en = 0;
       
    end
    endtask

    // Read task
    task rd_data();
    begin
        @(posedge clk);
        rd_en = 1;
        @(posedge clk);
        $display($time, " Reading data = %0d", d_out);
        rd_en = 0;
    end
    endtask
  task wr_rd_data(input [FIFO_WIDTH-1:0] data_in);
    begin
      @(posedge clk);
      wr_en = 1;
      rd_en = 1;
      d_in = data_in;
      $display($time," wrting and readding data = %d", d_in,d_out);
      @(posedge clk);
      wr_en = 0;
      rd_en = 0;
    end 
  endtask

    // Stimulus
    initial begin
        // Reset
        #10;
        rst_n = 0; wr_en = 0; rd_en = 0; d_in = 0;
        
        

        // Case 1: Write 3 then read 3
        @(posedge clk)
        rst_n = 1;
        wrt_data(1);
        wrt_data(2);
        wrt_data(3);

        rd_data();
        rd_data();
        rd_data();
 
        // Case 2: Write and read sequentially
        
       
       
        for (i = 0; i <= 10; i = i + 1) begin
            wrt_data(i);
            rd_data();
          
        end

        // Case 3: Full FIFO to full
        
        
        for (i = 0; i < 10; i = i + 1) begin
             wrt_data(i);
        end
        for (i=0; i < 10; i=i+1)begin
        rd_data();
        end
       // case 4: wrting and reading simultaniously
        @(posedge clk);
         rst_n = 1;
      wr_rd_data(5);
      wr_rd_data(7);
      // mid oprattion reset 
      wrt_data(2);
      wrt_data(5);
      $display ($time ,"   aPLYING reset  ");
      
      @(posedge clk);
      rst_n = 0;
      @(posedge clk);
      rst_n = 1;
      $display ($time ,"   RELEAS reset  ");
      rd_data();
      
      
     $display("------ WRAP-AROUND TEST START ------");

// Write 8 values 
for (i = 0; i < 8; i = i + 1) begin
    wrt_data(i );  
end

//  Read 4 values
for (i = 0; i < 4; i = i + 1) begin
    rd_data();         
end

// Write 4 more values 
for (i = 0; i < 4; i = i + 1) begin
    wrt_data(i );  
end

// Read remaining 8 values
for (i = 0; i < 8; i = i + 1) begin
    rd_data();         
end
     
$display("------ WRAP-AROUND TEST END ------");

$monitor($time, " wr_en=%b rd_en=%b empty=%b underflow=%b full=%b overflow=%b", wr_en, rd_en, empty, underflow, full, overflow);
     
    
      #40 $finish;
      
        end
initial begin
$dumpfile("dump.vcd"); $dumpvars;
  
end
endmodule
       
       
    


