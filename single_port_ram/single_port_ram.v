//single_port_RAM//
module dualport_noconflict(clk,reset,addr_a, read_a, write_a, write_data_a, addr_b, read_b, write_b, write_data_b, read_data_a, read_data_b);
  
  input clk,reset, read_a, read_b, write_a, write_b;  
  input [7:0]write_data_a, write_data_b;
  input [3:0]addr_a, addr_b;
  output reg [7:0]read_data_a, read_data_b;
  
	reg [7:0] memory [0:15];
  
  always@(posedge clk) begin
    if(reset) begin 
    read_data_a<=8'b0;
    read_data_b<=8'b0;
    	end
    
  else if((addr_a == addr_b) && (write_a == 1 || write_b == 1) ) begin // collision check//
      // here, readA + readB is not a collision because both should read the same address //
      
    case({read_a,write_a}) //giving priority to A at all times//
        
        2'b01 : memory[addr_a] <= write_data_a;
        2'b10 : read_data_a <= memory[addr_a];
        2'b11 : begin
        end;
        default: begin 
        end;
      endcase
    end
    else begin
      case({read_a,write_a}) 
        
        2'b01 : memory[addr_a] <= write_data_a;
        2'b10 : read_data_a <= memory[addr_a];
        2'b11 : begin
        end;
        default: begin 
        end;
      endcase
    	
        case({read_b,write_b}) 
        2'b01 : memory[addr_b] <= write_data_b;
        2'b10 : read_data_b <= memory[addr_b];
        2'b11 : begin end;
        default : begin end;
      endcase
    end
  end
endmodule