module apb_interface(input pwrite, penable, input [2:0] pselx, input [31:0] paddr, pwdata, output pwrite_out, penable_out, output [2:0] pselx_out, output [31:0] paddr_out, pwdata_out, output reg [31:0] prdata);

 assign pwrite_out=pwrite;
 assign paddr_out=paddr;
 assign pselx_out=pselx;
 assign pwdata_out=pwdata;
 assign penable_out=penable;
 
 always@(*)
     begin
	     if(!pwrite && penable)
	     prdata={$random}%256;
	     else
		  prdata=32'h0;
	  end

endmodule

