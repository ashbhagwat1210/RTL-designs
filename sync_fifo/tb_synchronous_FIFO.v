//tb_synchronous_FIFO//

module tb;

  reg clk, reset, read, write;
  reg [7:0] write_data;
  wire [7:0] read_data;

 
  fifo f1( clk, reset, read, write, write_data, read_data );

  // Clock generation
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    // Initializing
    reset = 0;
    read = 0;
    write = 0;
    write_data = 8'd0;

    // Reset
    @(negedge clk);
    reset = 1;
    @(negedge clk);
    reset = 0;

    // ---------- WRITING 3 VALUES ----------

    // Write A
    @(negedge clk);
    write = 1;
    write_data = 8'b01010101;
    @(negedge clk);
    write = 0;

    // Write B
    @(negedge clk);
    write = 1;
    write_data = 8'b10101010;
    @(negedge clk);
    write = 0;

    // Write C
    @(negedge clk);
    write = 1;
    write_data = 8'b11110000;
    @(negedge clk);
    write = 0;

    // ---------- READING ONLY FIRST 2 ----------

    // Read A
    @(negedge clk);
    read = 1;
    @(negedge clk);
    read = 0;

    // Read B
    @(negedge clk);
    read = 1;
    @(negedge clk);
    read = 0;

    // ---------- READ + WRITE IN SAME CYCLE ----------

    // Read C, write D
    @(negedge clk);
    read = 1;
    write = 1;
    write_data = 8'b00001111;

    @(negedge clk);
    read = 0;
    write = 0;

    #20;
    $finish;
  end

endmodule
