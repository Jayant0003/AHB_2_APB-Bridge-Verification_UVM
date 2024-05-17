interface ahb_interface(input bit clock);
	logic HRESETn;
	logic HWRITE;
	logic[31:0] HWDATA;
	logic[31:0] HRDATA;
	logic[1:0] HTRANS;
	logic[1:0] HRESP;
	logic[31:0] HADDR;
	logic[2:0] HSIZE;
	logic[2:0] HBURST;
	logic HREADYout;
	logic HREADYin;
	logic HSELAPBif;
	
	
	clocking ahb_drv_cb @(posedge clock);
	default input #1 output #1;          
		output HRESETn;
		output HWRITE;
		output HWDATA;
		output HTRANS;
		output HBURST;
		output HSIZE;
		output HADDR;
		output HREADYin;
		output HSELAPBif;
		input HREADYout;
	endclocking

	clocking ahb_mon_cb @(posedge clock);
	default input #1 output #1;
		input HRESETn;
		input HWRITE;
		input HWDATA;
		input HTRANS;
		input HRESP;
		input HADDR;
		input HSIZE;
		input HBURST;
		input HREADYout;
		input HREADYin;
		input HSELAPBif;
		input HRDATA;
	endclocking

modport AHB_DRV_MP (clocking ahb_drv_cb);
modport AHB_MON_MP (clocking ahb_mon_cb);

endinterface
