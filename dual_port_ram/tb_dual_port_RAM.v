//tb_dual_port_RAM//

module tb();

  reg clk, reset;
  reg read_a, write_a, read_b, write_b;
  reg [7:0] write_data_a, write_data_b;
  reg [3:0] addr_a, addr_b;

  wire [7:0] read_data_a, read_data_b;

  dualport_withconflict dut (
    clk, reset,
    addr_a, read_a, write_a, write_data_a,
    addr_b, read_b, write_b, write_data_b,
    read_data_a, read_data_b
  );

  // clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("rr_dualport.vcd");
    $dumpvars(0, tb);

    // RESET
    reset = 1;
    read_a = 0; write_a = 0;
    read_b = 0; write_b = 0;
    addr_a = 4'd0; addr_b = 4'd0;
    write_data_a = 8'b10100101;
    write_data_b = 8'b01011010;

    @(negedge clk);
    reset = 0;

    // ------------------------------------------------
    // Case 1: different address, write/write
    @(negedge clk);
    write_a = 1; write_b = 1;
    addr_a = 4'd1; addr_b = 4'd2;
    write_data_a = 8'b11001010;
    write_data_b = 8'b00110101;

    // read back
    @(negedge clk);
    write_a = 0; write_b = 0;
    read_a  = 1; read_b  = 1;

    // ------------------------------------------------
    // Case 2: same address, read/read
    @(negedge clk);
    addr_a = 4'd3; addr_b = 4'd3;
    read_a = 1; read_b = 1;

    // ------------------------------------------------
    // Case 3: same address, write/write → first winner
    @(negedge clk);
    read_a = 0; read_b = 0;
    write_a = 1; write_b = 1;
    addr_a = 4'd4; addr_b = 4'd4;
    write_data_a = 8'b10111100;
    write_data_b = 8'b01000011;

    // read back
    @(negedge clk);
    write_a = 0; write_b = 0;
    read_a  = 1; read_b  = 1;

    // ------------------------------------------------
    // Case 4: same address, write/write → round-robin flip
    @(negedge clk);
    read_a = 0; read_b = 0;
    write_a = 1; write_b = 1;
    addr_a = 4'd4; addr_b = 4'd4;
    write_data_a = 8'b01101001;
    write_data_b = 8'b10010110;

    // read back
    @(negedge clk);
    write_a = 0; write_b = 0;
    read_a  = 1; read_b  = 1;

    // ------------------------------------------------
    // Case 5: same address, write A + read B
    @(negedge clk);
    write_a = 1; read_a = 0;
    read_b = 1; write_b = 0;
    addr_a = 4'd5; addr_b = 4'd5;
    write_data_a = 8'b11010011;

    // ------------------------------------------------
    // Case 6: same address, write B + read A
    @(negedge clk);
    read_a = 1; write_a = 0;
    write_b = 1; read_b = 0;
    addr_a = 4'd6; addr_b = 4'd6;
    write_data_b = 8'b00101101;

    // ------------------------------------------------
    // Case 7: final readback
    @(negedge clk);
    read_a = 1; write_a = 0;
    read_b = 1; write_b = 0;
    addr_a = 4'd5;
    addr_b = 4'd6;

    @(negedge clk);
    $finish;
  end

endmodule
