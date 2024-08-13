module ahb_master_interface(input hclk, hresetn, hreadyout, input [31:0]hrdata, input [1:0]hresp ,output reg [31:0] haddr, hwdata, output reg hwrite, hreadyin, output reg [1:0] htrans);

reg [2:0]hburst; //single,4,8,16,.....
reg [2:0]hsize; //size,8,16,32bit,....
integer i=0;

task single_write();
    begin
    @(posedge hclk)
    #1;
        begin
        hwrite=1;
        htrans=2'b10;
        hsize=3'b000;
        hburst=3'b000;
        hreadyin=1;
        haddr=32'h8000_0000;
        end
    @(posedge hclk)
    #1;
        begin
        hwdata=32'h32;
        htrans=2'b00;
        end
    end
endtask	

task single_read();
    begin
	@(posedge hclk)
    #1;
        begin
        hwrite=0;
        htrans=2'b10;
        hsize=0;
        hburst=0;
        hreadyin=1;
        haddr=32'h8000_0000;
        end
    @(posedge hclk)
    #1;
        begin
        htrans=2'b00;
        end
    end
endtask

task burst_incr_write();
    begin
	@(posedge hclk)
    #1;
        begin
        hwrite=1;
        htrans=2'b10;
        hsize=0;
        hburst=3'b001;
        hreadyin=1;
        haddr=32'h8000_0000;
        end
    @(posedge hclk)
    #1;
        begin
		haddr=haddr+1;
		hwdata={$random}%256;
        htrans=2'b11;
        end
	for(i=0;i<2;i=i+1)
	    begin
		@(posedge hclk)
		#1;
		    begin
			haddr=haddr+1;
			hwdata={$random}%256;
			htrans=2'b11;
			end
		@(posedge hclk)
		#1;
	    end
    @(posedge hclk)
	#1;
	    begin
		hwdata={$random}%256;
		htrans=2'b00;
		end
    end
endtask   

task burst_incr_read();
    begin
	@(posedge hclk)
    #1;
        begin
        hwrite=0;
        htrans=2'b10;
        hsize=0;
        hburst=3'b001;
        hreadyin=1;
        haddr=32'h8000_0000;
        end
	for(i=0;i<3;i=i+1)
	    begin
		@(posedge hclk)
		#1;
		    begin
			haddr=haddr+1;
			htrans=2'b11;
			end
		@(posedge hclk)
		#1;
		end
    @(posedge hclk)
	#1;
		htrans=2'b00;
    end
endtask
  
