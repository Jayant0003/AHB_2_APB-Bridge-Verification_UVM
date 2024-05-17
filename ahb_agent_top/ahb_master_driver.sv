class ahb_master_driver extends uvm_driver#(master_xtn);
`uvm_component_utils(ahb_master_driver)

ahb_master_agent_config ahb_agent_cfg;
virtual ahb_interface.AHB_DRV_MP vif;

function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(ahb_master_agent_config)::get(this,"","ahb_master_agent_config",ahb_agent_cfg))
		`uvm_fatal(get_type_name,"error while getting agent_cfg")

endfunction
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=ahb_agent_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
	$display("in AHB DRIVER %0t",$time);

	super.run_phase(phase);
	@(vif.ahb_drv_cb);
	vif.ahb_drv_cb.HRESETn<=0;
	@(vif.ahb_drv_cb);
	vif.ahb_drv_cb.HRESETn<=1;
// if  in interface if HRESETn is bit then by default it's value is 0, and HREADYout will be 1 and monitor will start sampling at 0 sim time.
	@(vif.ahb_drv_cb);

	forever begin
	seq_item_port.get_next_item(req);
	drive(req);
	seq_item_port.item_done();

	end

endtask
task drive(master_xtn xtn);
		while(vif.ahb_drv_cb.HREADYout!==1)
		@(vif.ahb_drv_cb);
	$display("in AHB DRIVER %0t",$time);

	vif.ahb_drv_cb.HADDR<=xtn.HADDR;
	vif.ahb_drv_cb.HWRITE<=xtn.HWRITE;
	vif.ahb_drv_cb.HTRANS<=xtn.HTRANS;
	vif.ahb_drv_cb.HSIZE<=xtn.HSIZE;
	vif.ahb_drv_cb.HBURST<=xtn.HBURST;

	vif.ahb_drv_cb.HREADYin<=1;
	@(vif.ahb_drv_cb);
	while(vif.ahb_drv_cb.HREADYout!==1)
		@(vif.ahb_drv_cb);
	if(xtn.HWRITE===1)
	vif.ahb_drv_cb.HWDATA<=xtn.HWDATA;
	`uvm_info(get_type_name(),$sformatf("time =%t from master DRIVER %s",$time,xtn.sprint()),UVM_LOW)
	vif.ahb_drv_cb.HREADYin<=0;
	
//	@(vif.ahb_drv_cb);





endtask
endclass

