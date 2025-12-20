//synchronous_FIFO//

module fifo( clk, reset, read, write, write_data, read_data);
  
  input clk, reset, read, write;
  input [7:0]write_data;
  output reg [7:0]read_data;
  
  reg [7:0]memory[0:15];
  reg [3:0]read_count, write_count;
  
  always@(posedge clk) begin
    
    if(reset) begin
      read_count <= 4'd0;
      write_count <= 4'd0;
      read_data<=8'd0;
    end
    else begin
    
    case({read, write})
      2'b01 : begin memory[write_count] <= write_data; 
            write_count <=write_count + 1'b1;
      end 
      
      2'b10 : begin read_data <= memory[read_count];
              read_count <= read_count + 1'b1;

      end
      
      2'b11 : begin memory[write_count] <= write_data; 
     		  read_data <= memory[read_count];
      write_count <=write_count + 1'b1;
      read_count <= read_count + 1'b1;
      end
      
        default : begin   
        end
    endcase
    end
  end
endmodule