class apb_slave_monitor extends uvm_monitor;
`uvm_component_utils(apb_slave_monitor)

apb_slave_agent_config apb_agent_cfg;
virtual apb_interface.APB_MON_MP vif;
slave_xtn xtn;
uvm_analysis_port #(slave_xtn) ap;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
	ap=new("ap",this);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(apb_slave_agent_config)::get(this,"","apb_slave_agent_config",apb_agent_cfg))
		`uvm_fatal(get_type_name,"error while getting agent_cfg")

endfunction
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=apb_agent_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
	forever
		collect_data();

endtask
task collect_data();
	
	xtn=slave_xtn::type_id::create("xtn");
	while(vif.apb_mon_cb.PENABLE!==1)
		@(vif.apb_mon_cb);
	$display("in APB DRIVER %0t",$time);

	xtn.PADDR=vif.apb_mon_cb.PADDR;
	xtn.PWRITE=vif.apb_mon_cb.PWRITE;
	xtn.PSELx=vif.apb_mon_cb.PSELx;
	if(vif.apb_mon_cb.PWRITE===0)
		xtn.PRDATA=vif.apb_mon_cb.PRDATA;
	else
		xtn.PWDATA=vif.apb_mon_cb.PWDATA;
	`uvm_info(get_type_name,$sformatf("from APB Monitor %s",xtn.sprint()),UVM_LOW)
	ap.write(xtn);

	@(vif.apb_mon_cb);
	
endtask

endclass

