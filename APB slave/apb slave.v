//apb slave //
module apb_slave( PCLK, PRESETn, PWRITE, PWDATA, PSEL, PADDR, PENABLE, PRDATA, PREADY) ;
  
  input PCLK, PRESETn , PWRITE,PENABLE,PSEL;
  input [31:0] PWDATA;
  input [2:0]PADDR; 
  
  output reg PREADY;
  output reg [31:0]PRDATA; 
  
  reg [31:0] memory [0:7];
  
  always@(posedge PCLK) begin
    PREADY <= 1'b0;
    if(!PRESETn) begin
      PREADY <= 0;
      PRDATA <= 32'd0;
    end
    
    else begin
      PREADY <= 1'b0;
      
      if( PSEL && PENABLE) begin
        
        PREADY <= 1'b1;
        
        if(PWRITE) begin
          memory[PADDR] <= PWDATA;
        end
        
        else begin 
          PRDATA <= memory[PADDR];
        end
      end
    end
  end

endmodule