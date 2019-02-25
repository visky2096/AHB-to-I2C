/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : ahb_tb.v

* Purpose :

* Creation Date : 21-02-2019

* Last Modified : 

* Created By : Vishal Kumar 

_._._._._._._._._._._._._._._._._._._._._.*/
module ahb_tb; 
reg Hclk;
reg Hreset;
reg hready;
reg hresp;
reg [31:0] addr;
reg [0:31] data;
reg [2:0] size;
reg [1:0] trans;
reg [2:0] burst;
wire [31:0]haddr;
wire [2:0]hsize;
wire [2:0]hburst;
wire [1:0]htrans;
wire [0:31]hwdata;
wire hwrite;
integer i; 
//module instantiation
 
ahb_master_improved callmaster(Hclk,Hreset,hready,hresp,addr,data,size,trans,burst,haddr,hsize,hburst,htrans,hwdata,hwrite);
//defining initial sequence 
initial begin
$dumpfile("ahb.vcd");
$dumpvars;
Hreset=1;
Hclk=0;
hready=1;
hresp=0;
addr=32'h00000000;
size=3'b010;
trans=2'b00;
data=0;
#100 $finish;
end 
//defining data sequence 
initial begin 
data=32'b10101110101010101010101010101100;
#3;
data=32'b11100000101010101010101010101100;
#3;
data=32'b00011110101010101010101010101100;
#6;
data=32'b11110010100010001010101010101100;
#20;
data=32'b10110110101010101010101010101100;
#40;
data=32'b10101110101010101010101010101100;
#31;
end 
//defining clock sequence 
always begin 
Hclk=0;
#3;
Hclk=1;
#3;
end
//defining data sequence 
always #40 Hreset=~Hreset;
//definiing trans sequence 
always begin
trans=2'b00;
#5;
trans=2'b01;
#5;
trans=2'b11;
#5;
trans=2'b10;
#5;
end
//defining burst sequence 
always begin
burst=3'b000;
#6;
burst=3'b001;
#6;
burst=3'b101;
#6; 
end  
endmodule  
