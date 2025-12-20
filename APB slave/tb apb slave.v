// tb apb slave//

module tb;

  reg         PCLK;
  reg         PRESETn;
  reg         PWRITE;
  reg [31:0]  PWDATA;
  reg         PSEL;
  reg [2:0]   PADDR;
  reg         PENABLE;

  wire [31:0] PRDATA;
  wire        PREADY;

  // DUT instantiation
  apb_slave dut (
    PCLK,
    PRESETn,
    PWRITE,
    PWDATA,
    PSEL,
    PADDR,
    PENABLE,
    PRDATA,
    PREADY
  );

  // Clock generation (10ns period)
  initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
  end

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);

    // RESET
    PSEL    = 0;
    PENABLE = 0;
    PWRITE  = 0;
    PWDATA  = 0;
    PADDR   = 0;

    PRESETn = 0;
    @(posedge PCLK);
    PRESETn = 1;
    @(posedge PCLK);

    // WRITE TRANSACTION
    
    // SETUP - step 1
    @(negedge PCLK);
    PSEL    = 1;
    PWRITE  = 1;
    PADDR   = 3'd2;
    PWDATA  = 32'hDEADBEEF;
    PENABLE = 0;

    // ACCESS - step 2
    @(negedge PCLK);
    PENABLE = 1;

    // Let ACCESS complete - READY =1
    @(posedge PCLK);

    // End transfer - step 3
    @(negedge PCLK);
    PSEL    = 0;
    PENABLE = 0;
    PWRITE  = 0;

    // READ TRANSACTION
    
    // SETUP
    @(negedge PCLK);
    PSEL    = 1;
    PWRITE  = 0;
    PADDR   = 3'd2;
    PENABLE = 0;

    // ACCESS
    @(negedge PCLK);
    PENABLE = 1;

    @(posedge PCLK);

    // End transfer
    @(negedge PCLK);
    PSEL    = 0;
    PENABLE = 0;

    #20;
    $finish;
  end

endmodule
