module tb();
  
  wire [7:0]read_data;
  
  reg  clk, reset;
  reg  read, write;
  reg [7:0] write_data;
  reg [3:0] address;
  
  singleportram spr( clk, reset, read, write, write_data, address, read_data);
  
  initial begin
    clk = 0;
    forever #5 clk= ~clk; end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    @(posedge clk)
    write=0; read= 0; write_data = 8'b0; address = 4'b0;
     reset = 1;
    
    @(posedge clk) reset =0;
    
    
    @(posedge clk) write_data = 8'b01010101; write = 1; read =0;  address = 4'd4;
    @(posedge clk) write_data = 8'b10101010; write = 0; read = 1;  address = 4'd5; @(posedge clk)
    @(posedge clk) write_data = 8'b11111111; write = 1; read = 1;  address = 4'd6;  
    @(posedge clk)
    $finish;
  end
endmodule
