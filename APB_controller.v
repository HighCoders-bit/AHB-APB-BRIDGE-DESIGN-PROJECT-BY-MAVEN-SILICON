
module apb_controller(hclk, hresetn, valid, haddr, haddr1, haddr2, hwdata, hwdata1, hwdata2, hwrite, hwritereg, hwritereg1, tempselx, hreadyout, pwrite, penable, pselx, pwdata, paddr);

input hclk, hresetn, valid, hwrite, hwritereg, hwritereg1;
input [31:0] haddr, haddr1, haddr2, hwdata, hwdata1, hwdata2;
input [2:0]tempselx;
output reg pwrite, penable, hreadyout;
output reg [31:0] pwdata, paddr; 
output reg [2:0]pselx;

reg [2:0]present_state, next_state;

parameter ST_IDLE = 3'b000, ST_WWAIT = 3'b001, ST_READ = 3'b010, ST_RENABLE = 3'b011, ST_WRITE = 3'b100, ST_WRITEP = 3'b101, ST_WENABLE = 3'b110, ST_WENABLEP = 3'b111;

reg penable_temp, pwrite_temp, hreadyout_temp;
reg [2:0]pselx_temp;
reg [31:0]paddr_temp,pwdata_temp;

//present state logic
always@(posedge hclk)
    begin
	if(!hresetn)
	    present_state<=ST_IDLE;
	else
	    present_state<=next_state;
	end
	
//next state logic
always@(*)
    begin
	next_state=ST_IDLE;
	case(present_state)
	ST_IDLE: if(valid==1 && hwrite==1)
	             next_state=ST_WWAIT;
			 else if (valid==1 && hwrite==0)
			     next_state=ST_READ;
			 else
			     next_state=ST_IDLE;
				 
    ST_READ: next_state=ST_RENABLE;

    ST_WWAIT: if(valid==1)
                 next_state=ST_WRITEP;
              else 
                 next_state=ST_WRITE;
    
    ST_WRITEP: next_state=ST_WENABLEP;

    ST_WRITE: if(valid==1)
                 next_state=ST_WENABLEP;
              else 
                 next_state=ST_WENABLE;

    ST_WENABLEP: if(valid==1 && hwritereg==1)
	                 next_state=ST_WRITEP;
			     else if (valid==0 && hwritereg==1)
			         next_state=ST_WRITE;
			     else
			         next_state=ST_READ;
					 
    ST_WENABLE: if(valid==1 && hwrite==1)
	                 next_state=ST_WWAIT;
			     else if (valid==1 && hwrite==0)
			         next_state=ST_READ;
			     else
			         next_state=ST_IDLE;
					 
	ST_RENABLE: if(valid==1 && hwrite==1)
	                 next_state=ST_WWAIT;
			     else if (valid==1 && hwrite==0)
			         next_state=ST_READ;
			     else
			         next_state=ST_IDLE;
	endcase
	end
	
//temporary output logic
always@(*)
    begin
	case(present_state)
	ST_IDLE: if(valid==1 && hwrite==0)
	             begin
				 paddr_temp=haddr;
				 pwrite_temp=hwrite;
				 pselx_temp=tempselx;
				 penable_temp=0;
				 hreadyout_temp=0;
				 end
			 else if(valid==1 && hwrite==1)
			     begin
				 pselx_temp=0;
				 penable_temp=0;
				 hreadyout_temp=1;
				 end
			 else
			     begin
			     pselx_temp=0;
				 penable_temp=0;
				 hreadyout_temp=1;
				 end
				 
	ST_READ: begin
	         penable_temp=1;
			 hreadyout_temp=1;
			 end
			 
	ST_RENABLE: if(valid==1 && hwrite==0)
	                begin
				    paddr_temp=haddr;
				    pwrite_temp=hwrite;
				    pselx_temp=tempselx;
				    penable_temp=0;
				    hreadyout_temp=0;
				    end
				else if(valid==1 && hwrite==1)
			        begin
				    pselx_temp=0;
				    penable_temp=0;
				    hreadyout_temp=1;
				    end
			    else
			        begin
			        pselx_temp=0;
				    penable_temp=0;
				    hreadyout_temp=1;
				    end
					
	ST_WWAIT: begin
	          paddr_temp=haddr1;
			  pwdata_temp=hwdata;
			  pwrite_temp=hwrite;
			  pselx_temp=tempselx;
			  penable_temp=0;
			  hreadyout_temp=0;
			  end
			  
	ST_WRITE: begin 
	          penable_temp=1;
			  hreadyout_temp=1;
			  end
			  
	ST_WRITEP: begin 
	           penable_temp=1;
			   hreadyout_temp=1;
			   end
				 
	ST_WENABLEP: begin
	             paddr_temp=haddr2;
			     pwdata_temp=hwdata1;
			     pwrite_temp=hwritereg;
			     pselx_temp=tempselx;
			     penable_temp=0;
			     hreadyout_temp=0;
			     end
				 
	ST_WENABLE: if(valid==1 && hwrite==0)
	                begin
				    paddr_temp=haddr2;
				    pwrite_temp=hwrite;
				    pselx_temp=tempselx;
				    penable_temp=0;
				    hreadyout_temp=0;
				    end
				else if(valid==1 && hwrite==1)
			        begin
				    pselx_temp=0;
				    penable_temp=0;
				    hreadyout_temp=1;
				    end
				else
			        begin
			        pselx_temp=0;
				    penable_temp=0;
				    hreadyout_temp=1;
				    end
	endcase
	end

//actual output logic
always@(posedge hclk)
    begin
	if(!hresetn)
	    begin
		paddr<=0;
		pwdata<=0;
		pwrite<=0;
		pselx<=0;
		penable<=0;
		hreadyout<=1;
		end
	else
	    begin
		paddr<=paddr_temp;
		pwdata<=pwdata_temp;
		pwrite<=pwrite_temp;
		pselx<=pselx_temp;
		penable<=penable_temp;
		hreadyout<=hreadyout_temp;
		end
	end
	
endmodule
  
