class ahb_master_monitor extends uvm_monitor;
`uvm_component_utils(ahb_master_monitor)
uvm_analysis_port #(master_xtn) ap;
ahb_master_agent_config ahb_agent_cfg;
virtual ahb_interface.AHB_MON_MP vif;
master_xtn xtn;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
	ap=new("ap",this);
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
	$display("in AHB MONITOR %0t",$time);

	super.run_phase(phase);
	@(vif.ahb_mon_cb);

	forever
			collect_data();
endtask
// monitor should sample valid data...upon reset Hready=1 but data is not valid..data is valid when HTRANS is 1 or 2
task collect_data();
	xtn=master_xtn::type_id::create("xtn");

	while(vif.ahb_mon_cb.HREADYin !==1 || vif.ahb_mon_cb.HREADYout !==1 || vif.ahb_mon_cb.HTRANS===0 || vif.ahb_mon_cb.HTRANS===1)
		@(vif.ahb_mon_cb);
	$display("in AHB MONITOR %0t",$time);

	// while(vif.ahb_mon_cb.HTRANS===0 || vif.ahb_mon_cb.HTRANS===1)
	//	@(vif.ahb_mon_cb);

	xtn.HADDR=vif.ahb_mon_cb.HADDR;
	xtn.HTRANS=vif.ahb_mon_cb.HTRANS;
	xtn.HWRITE=vif.ahb_mon_cb.HWRITE;
	xtn.HSIZE=vif.ahb_mon_cb.HSIZE;
	xtn.HBURST=vif.ahb_mon_cb.HBURST; 

	@(vif.ahb_mon_cb);
	while(vif.ahb_mon_cb.HREADYout!==1  || (vif.ahb_mon_cb.HTRANS===0 || vif.ahb_mon_cb.HTRANS===1))
		@(vif.ahb_mon_cb);
	
	if(vif.ahb_mon_cb.HWRITE===0) begin
		$display("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%0d",vif.ahb_mon_cb.HRDATA);
		xtn.HRDATA=vif.ahb_mon_cb.HRDATA;
	end
	else
		xtn.HWDATA=vif.ahb_mon_cb.HWDATA;
	`uvm_info(get_type_name(),$sformatf("time=%t from master MONITOR %s",$time,xtn.sprint()),UVM_LOW)
	ap.write(xtn);
	
//	@(vif.ahb_mon_cb);

endtask
endclass

