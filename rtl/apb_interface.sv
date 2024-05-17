interface apb_interface(input bit clock);
	logic PWRITE;
	logic[31:0] PWDATA;
	logic[31:0] PRDATA;
	logic PENABLE;
	logic[31:0] PADDR;
	logic[3:0] PSELx;
	
	clocking apb_drv_cb @(posedge clock);
	default input #1 output #1;
		output PRDATA;
		input PSELx;
		input PWRITE;
	endclocking

	clocking apb_mon_cb @(posedge clock);
	default input #1 output #1;
		input PWRITE;
		input PWDATA;
		input PRDATA;
		input PADDR;
		input PSELx;
		input PENABLE;
	endclocking
modport APB_DRV_MP (clocking apb_drv_cb);
modport APB_MON_MP (clocking apb_mon_cb);

endinterface
