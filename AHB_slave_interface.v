
module ahb_slave_interface(hclk, hresetn, hwrite, hreadyin, htrans, haddr, hwdata, prdata, hrdata, valid, haddr1, haddr2, hwdata1, hwdata2, hwritereg, hwritereg1,,hresp tempselx);

input hclk, hresetn, hwrite, hreadyin;
input [1:0]htrans;
input [31:0] haddr, hwdata, prdata;
output reg valid;
output reg hwritereg, hwritereg1;
output reg [2:0]tempselx; 
output reg [31:0] haddr1, haddr2, hwdata1, hwdata2;
output [31:0]hrdata;
output [1:0]hresp;

//pipelining of haddress
always@(posedge hclk)
    begin
	    if(!hresetn)
		    begin
			haddr1<=0;
			haddr2<=0;
			end
		else
		    begin
			haddr1<=haddr;
			haddr2<=haddr1;
			end
	end
	
//pipelining of hdata
always@(posedge hclk)
    begin
	    if(!hresetn)
		    begin
			hwdata1<=0;
			hwdata2<=0;
			end
		else
		    begin
			hwdata1<=hwdata;
			hwdata2<=hwdata1;
			end
	end
	
//pipelining of hwrite
always@(posedge hclk)
    begin
	    if(!hresetn)
		    begin
			hwritereg<=0;
			hwritereg1<=0;
			end
		else
		    begin
			hwritereg<=hwrite;
			hwritereg1<=hwritereg;
			end
	end
	
always@(*)
    begin
	    if( hreadyin && haddr>=32'h8000_0000 && haddr<32'h8c00_0000 && (htrans==2'b10 || htrans==2'b11))
        valid <= 1;
        else	
        valid <= 0;
	end

always@(*)
    begin
	    if(haddr>=32'h8000_0000 && haddr<32'h8400_0000)
		tempselx <= 3'b001;
		else if (haddr>=32'h8400_0000 && haddr<32'h8800_0000)
		tempselx <= 3'b010;
		else if (haddr>=32'h8800_0000 && haddr<32'h8c00_0000)
		tempselx <= 3'b100;
		else
		tempselx <= 3'b000;
	end
	
assign hrdata = prdata;
assign hresp=2'b00;

endmodule
