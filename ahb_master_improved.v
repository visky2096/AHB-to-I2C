/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.._._._._._._._._._._._._._._._._._._._._._*

* File Name : ahb_master_improved.v

* Purpose : Verilog HDL Project 

* Creation Date : 20-02-2019

* Last Modified : 

* Created By : VISHAL KUMAR
                      
_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.*/
module ahb_master_improved
(
input Hclk,
input Hreset,
input hready,
input hresp,
input  [31:0] addr,
input  [0:31] data,
input  [2:0] size,
input  [1:0] trans,
input  [2:0] burst,
output reg [31:0] haddr,
output reg [2:0] hsize,
output reg [2:0] hburst, 
output reg [1:0] htrans ,
output reg [0:31] hwdata,
output reg hwrite
);
reg [31:0]previous_haddr;
reg [31:0]temp_addr;
reg [2:0]previous_hsize;
reg [2:0]previous_hburst;
reg [1:0]previous_htrans;
reg [31:0]previous_hwdata;
reg previous_hwrite;
integer i,len;
reg [0:31]r;
reg [0:31]temp_data;
initial begin 
i=0;
//l=31;
//k=24;
temp_data=32'hxxxxxxxx;
previous_haddr=32'bxxxxxxxx;
previous_hsize=3'bxxx;
previous_hburst=3'bxxx;
previous_htrans=2'bxx;
previous_hwdata=32'bxxxxxxxx;
previous_hwrite=1'bx;
end
always @(posedge Hclk,negedge Hreset)
begin
if(!Hreset) 
begin 
htrans=2'b00;
haddr=32'h00000000;
hwdata=32'h00000000;
hsize=3'b000;
hburst=3'b000;
hwrite=1'bx;
end 
if(hresp==1)
begin
 	htrans=trans; 
	haddr=addr;
	hwdata=32'hxxxxxxxx; 
	hsize=size;
	hburst=burst;
	hwrite=1'b1; 
	previous_htrans=htrans ;
	previous_haddr=haddr;
	previous_hwdata=hwdata;
	previous_hsize=hsize;
	previous_hburst=hburst;
	previous_hwrite=hwrite;

end 
if(Hreset==1 && hready==0 && hresp==0) // for sending the control signals and data 
begin 
case (trans) 
2'b00 :                                         //IDLE STATE
begin 
	htrans=trans; 
	haddr=previous_haddr;
	hwdata=32'hxxxxxxxx; 
	hsize=size;
	hburst=burst;
	hwrite=1'b1; 
	previous_htrans=htrans ;
	previous_haddr=haddr;
	previous_hwdata=hwdata;
	previous_hsize=hsize;
	previous_hburst=hburst;
	previous_hwrite=hwrite;
end 
2'b01 :                                      //BUSY STATE 
begin 	
	htrans=previous_htrans;
	haddr=previous_haddr;
	hwdata<=previous_hwdata;
	hsize=previous_hsize;
	hburst=previous_hburst;
	hwrite=previous_hwrite; 
end 
2'b10 :                                     //NON SEQUENTIAL STATE 
begin 	htrans=trans;
	haddr=addr;
	temp_data<=data;
	hwdata<=temp_data;
	hsize=size;
	hburst=burst;
	hwrite=1'b1;
	previous_htrans=htrans ;
	previous_haddr=haddr;
	previous_hwdata=temp_data;
	previous_hsize=hsize;
	previous_hburst=hburst;
	previous_hwrite=hwrite;
end 
2'b11 : 				   //SEQUENTIAL 
begin 	
	case (burst)
    
		3'b000: 			//SINGLE BURST 
			begin 	htrans=trans;
				haddr=addr;
				temp_data<=data;
				hwdata<=temp_data;
				hsize=size;
				hburst=burst;
				hwrite=1'b1;
				previous_htrans=htrans;
				previous_haddr=haddr;
				previous_hwdata=temp_data;
				previous_hsize=hsize;
				previous_hburst=hburst;
				previous_hwrite=hwrite;
			end 
		3'b001:                // Increment Burst of 4 beats 
			begin 	
				r=32'h00000000;
				htrans=trans; 
				temp_addr=addr;
				r=r^data;
				for(i=0;i<4;i=i+1)
				begin 
				haddr=temp_addr;
				#3;
				temp_addr=temp_addr+4;
				temp_data<=r[0:7];
				hwdata<=temp_data;
				r=r>>8;
				end 
				hburst=burst;
				hsize=size;
				hwrite=1'b1;
				previous_htrans=htrans ;
				previous_haddr=haddr;
				previous_hwdata=temp_data;
				previous_hsize=hsize;
				previous_hburst=hburst;
				previous_hwrite=hwrite;

					
			end 
		3'b101: 		    // Wraping Burst of 4 beats 
			
			begin 	
				r=32'h00000000;
				htrans=trans;
				temp_addr=addr;
				r=r^data;
				len=0;
				for(i=0;i<4;i=i+1) // Number of bursts = 4 
				begin 
				if(len==16)begin len=0;haddr=temp_addr; end 
				else 
				begin
				haddr=temp_addr; 
				#3;
				temp_addr=temp_addr+4;
				temp_data<=r[0:7];
				hwdata<=temp_data;
				r=r>>8;
				len=len+4;
				end  
				end 	
				hburst=burst;
				hsize=size;
				hwrite=1'b1;
				previous_htrans=htrans ;
				previous_haddr=haddr;
				previous_hwdata=temp_data;
				previous_hsize=hsize;
				previous_hburst=hburst;
				previous_hwrite=hwrite;

			end 

			3'b001:                // Increment Burst of 8 beats 
			begin 	
				r=32'h00000000;
				htrans=trans; 
				temp_addr=addr;
				r=r^data;
				for(i=0;i<8;i=i+1)
				begin 
				haddr=temp_addr;
				#3;
				temp_addr=temp_addr+4;
				temp_data<=r[0:3];
				hwdata<=temp_data;
				r=r>>4;
				end 
				hburst=burst;
				hsize=size;
				hwrite=1'b1;
				previous_htrans=htrans ;
				previous_haddr=haddr;
				previous_hwdata=temp_data;
				previous_hsize=hsize;
				previous_hburst=hburst;
				previous_hwrite=hwrite;

					
			end 
		       
			3'b101: 		    // Wraping Burst of 8 beats 
			
			begin 	
				r=32'h00000000;
				htrans=trans;
				temp_addr=addr;
				r=r^data;
				len=0;
				for(i=0;i<8;i=i+1) // Number of bursts = 8 
				begin 
				if(len==32)begin len=0;haddr=temp_addr; end 
				else 
				begin
				haddr=temp_addr; 
				#3;
				temp_addr=temp_addr+4;
				temp_data<=r[0:3];
				hwdata<=temp_data;
				r=r>>4;
				len=len+4;
				end  
				end 	
				hburst=burst;
				hsize=size;
				hwrite=1'b1;
				previous_htrans=htrans ;
				previous_haddr=haddr;
				previous_hwdata=temp_data;
				previous_hsize=hsize;
				previous_hburst=hburst;
				previous_hwrite=hwrite;

			end 	
/*			3'b001:                // Increment Burst of 16 beats 
			begin 	
				r=32'h00000000;
				htrans=trans; 
				temp_addr=addr;
				r=r^data;
				for(i=0;i<4;i=i+1)
				begin 
				haddr=temp_addr;
				#3;
				temp_addr=temp_addr+16;
				temp_data<=r[0:7];
				hwdata<=temp_data;
				r=r>>8;
				end 
				hburst=burst;
				hsize=size;
				hwrite=1'b1;
				previous_htrans=htrans ;
				previous_haddr=haddr;
				previous_hwdata=temp_data;
				previous_hsize=hsize;
				previous_hburst=hburst;
				previous_hwrite=hwrite;

					
			end 
			3'b101: 		    // Wraping Burst of 16 beats 
			
			begin 	
				r=32'h00000000;
				htrans=trans;
				temp_addr=addr;
				r=r^data;
				len=0;
				for(i=0;i<4;i=i+1) // Number of bursts = 4 
				begin 
				if(len==64)begin len=0;haddr=temp_addr; end 
				else 
				begin
				haddr=temp_addr; 
				#3;
				temp_addr=temp_addr+16;
				temp_data<=r[0:7];
				hwdata<=temp_data;
				r=r>>8;
				len=len+16;
				end  
				end 	
				hburst=burst;
				hsize=size;
				hwrite=1'b1;
				previous_htrans=htrans ;
				previous_haddr=haddr;
				previous_hwdata=temp_data;
				previous_hsize=hsize;
				previous_hburst=hburst;
				previous_hwrite=hwrite;

			end 	
*/
	
	endcase
end 		
		

endcase 
end
if(Hreset==1 && hready==1 && hresp==0)
begin
htrans=previous_htrans;
haddr=previous_haddr;
hsize=previous_hsize;
hburst=previous_hburst;
hwrite=1'b0; 
hwdata=32'hxxxxxxxx;
end 

end 
endmodule  
