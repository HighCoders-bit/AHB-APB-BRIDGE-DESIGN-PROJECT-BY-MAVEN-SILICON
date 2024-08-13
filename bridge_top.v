module bridge_top(input hclk, hresetn, hwrite, hreadyin, input [1:0]htrans, input [31:0] haddr, hwdata, prdata, output pwrite, penable, hreadyout, output [31:0] pwdata, paddr, hrdata, output [2:0]pselx, output [1:0]hresp);

wire [31:0] haddr1, haddr2, hwdata1, hwdata2;
wire [2:0]tempselx;
wire hwritereg, hwritereg1;
wire valid;

ahb_slave_interface A1(hclk, hresetn, hwrite, hreadyin, htrans, haddr, hwdata, prdata, hrdata, valid, haddr1, haddr2, hwdata1, hwdata2, hwritereg, hwritereg1, tempselx);

apb_controller A2(hclk, hresetn, valid, haddr, haddr1, haddr2, hwdata, hwdata1, hwdata2, hwrite, hwritereg, hwritereg1, tempselx, hreadyout, pwrite, penable, pselx, pwdata, paddr);

endmodule
