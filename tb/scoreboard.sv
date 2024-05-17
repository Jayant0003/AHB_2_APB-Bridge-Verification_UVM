class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)
uvm_tlm_analysis_fifo #(master_xtn) master_fifo;
uvm_tlm_analysis_fifo #(slave_xtn) slave_fifo;
master_xtn hxtn;
slave_xtn pxtn;
master_xtn ahb_data;
slave_xtn apb_data;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
	master_fifo=new("master_fifo",this);
	slave_fifo=new("slave_fifo",this);
	ahb_data=new();
	apb_data=new();
	cov1=new;
	cov2=new;
	endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
		master_fifo.get(hxtn);
		slave_fifo.get(pxtn);
		compare(hxtn,pxtn);
	end
endtask

covergroup cov1;
 	haddr: coverpoint ahb_data.HADDR{bins addr1={[32'h8000_0000:32'h8000_03FF]};
					bins addr2={[32'h8400_0000:32'h8400_03FF]};
					bins addr3={[32'h8800_0000:32'h8800_03FF]};	
					bins addr4={[32'h8c00_0000:32'h8c00_03FF]};}
	hwrite: coverpoint ahb_data.HWRITE{bins write={1}; bins read = {0};}
	hsize: coverpoint ahb_data.HSIZE{bins zero={0};bins one={1};bins two={2};}
	CROSS: cross haddr,hwrite,hsize;

endgroup


covergroup cov2;
	paddr: coverpoint apb_data.PADDR{bins addr1={[32'h8000_0000:32'h8000_03FF]};
					bins addr2={[32'h8400_0000:32'h8400_03FF]};
					bins addr3={[32'h8800_0000:32'h8800_03FF]};	
					bins addr4={[32'h8c00_0000:32'h8c00_03FF]};}
	pwrite:coverpoint apb_data.PWRITE{bins write={1};bins read={0};}
	pselx: coverpoint apb_data.PSELx{bins one={4'b0001};bins two={4'b0010};bins four={4'b0100};bins eight={4'b1000};}
	CROSS: cross paddr,pwrite;

endgroup

function void compare(master_xtn hxtn,slave_xtn pxtn);
	ahb_data=hxtn;
	apb_data=pxtn;
	if(hxtn.HWRITE==1) begin
		if(hxtn.HSIZE==0) begin
			if(hxtn.HADDR[1:0]==2'b00)
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HWDATA[7:0],pxtn.PWDATA[7:0]);
			else if(hxtn.HADDR[1:0]==2'b01)
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HWDATA[15:8],pxtn.PWDATA[7:0]);
			else if(hxtn.HADDR[1:0]==2'b10)
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HWDATA[23:16],pxtn.PWDATA[7:0]);
			else
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HWDATA[31:24],pxtn.PWDATA[7:0]);
				
		end
		if(hxtn.HSIZE==1) begin
			if(hxtn.HADDR[1:0]==2'b00)
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HWDATA[15:0],pxtn.PWDATA[15:0]);
			else if(hxtn.HADDR[1:0]==2'b10)
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HWDATA[31:16],pxtn.PWDATA[15:0]);

		end
		if(hxtn.HSIZE==2) begin
			if(hxtn.HADDR[1:0]==2'b00)
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HWDATA[31:0],pxtn.PWDATA[31:0]);
		end
			
	end

	else begin
	
		if(hxtn.HSIZE==0) begin
			if(hxtn.HADDR[1:0]==2'b00)
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HRDATA[7:0],pxtn.PRDATA[7:0]);
			else if(hxtn.HADDR[1:0]==2'b01) 
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HRDATA[7:0],pxtn.PRDATA[15:8]);
			else if(hxtn.HADDR[1:0]==2'b10)
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HRDATA[7:0],pxtn.PRDATA[23:16]);
			else
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HRDATA[7:0],pxtn.PRDATA[31:24]);
				
		end
		if(hxtn.HSIZE==1) begin
			if(hxtn.HADDR[1:0]==2'b00)
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HRDATA[15:0],pxtn.PRDATA[15:0]);
			else if(hxtn.HADDR[1:0]==2'b10)
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HRDATA[15:0],pxtn.PRDATA[31:16]);

		end
		if(hxtn.HSIZE==2) begin
			if(hxtn.HADDR[1:0]==2'b00)
				verify(hxtn.HADDR,pxtn.PADDR,hxtn.HRDATA[31:0],pxtn.PRDATA[31:0]);
		end

	end
endfunction

function void verify(int haddr,int paddr,int hdata,int pdata);
	if(haddr==paddr) begin
	$display("$$$$$$$$$$$$$ HADDR%0h  time=%0t",haddr,$time);
		if(hdata==pdata) begin
			`uvm_info(get_type_name,"item matched",UVM_LOW)
				cov1.sample();
				cov2.sample();
			end
		else
			`uvm_error(get_type_name,"data mismatched!!!!!")

	end
	else
		`uvm_error(get_type_name,"address mismatched!!!!!")

endfunction

endclass
