/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : basic_trans.v

* Purpose :

* Creation Date : 23-02-2019

* Last Modified : 

* Created By :  

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
trans=2'b11;
data=32'b10101110101010101010101010101100;
burst=3'b001;
#200 $finish;
end 
//defining data sequence 
always #2 data=~data;
//always #2 addr=~addr;
//defining clock sequence 
always begin 
Hclk=0;
#3;
Hclk=1;
#3;
end
//defining data sequence 
//definiing trans sequence  
endmodule  
