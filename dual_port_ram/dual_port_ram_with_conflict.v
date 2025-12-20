//dual_port_ram_with_conflict//

module dualport_withconflict(clk,reset,addr_a, read_a, write_a, write_data_a, addr_b, read_b, write_b, write_data_b, read_data_a, read_data_b);
  
  input clk,reset, read_a, read_b, write_a, write_b;  
  input [7:0]write_data_a, write_data_b;
  input [3:0]addr_a, addr_b;
  output reg [7:0]read_data_a, read_data_b;
  
	reg [7:0] memory [0:15];
  	reg round_a; // round - robin condition toggler
  
  always@(posedge clk) begin
    if(reset) begin 
    read_data_a<=8'b0;
    read_data_b<=8'b0;
    round_a <= 1'b1; 
    	end
   
  else if((addr_a == addr_b) && (write_a == 1 || write_b == 1) ) begin 
    if(round_a) begin 
      case({read_a,write_a}) 
        
        2'b01 : memory[addr_a] <= write_data_a;
        2'b10 : read_data_a <= memory[addr_a];
      endcase
    end

    else begin
    case({read_b,write_b}) 
        2'b01 : memory[addr_b] <= write_data_b;
        2'b10 : read_data_b <= memory[addr_b];
      endcase
    end
    round_a <= ~round_a;
  end

    else begin
      case({read_a,write_a}) 
        
        2'b01 : memory[addr_a] <= write_data_a;
        2'b10 : read_data_a <= memory[addr_a];
      endcase
    	
        case({read_b,write_b}) 
        2'b01 : memory[addr_b] <= write_data_b;
        2'b10 : read_data_b <= memory[addr_b];
      endcase
    end
  end
endmodule