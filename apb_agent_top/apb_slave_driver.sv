class apb_slave_driver extends uvm_driver#(slave_xtn);
`uvm_component_utils(apb_slave_driver)

apb_slave_agent_config apb_agent_cfg;
virtual apb_interface.APB_DRV_MP vif;

function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
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
	super.run_phase(phase);
	forever
		drive();
endtask
task drive();
//	$display("in APB DRIVER %t",$time);

	  while(vif.apb_drv_cb.PSELx===0)
		@(vif.apb_drv_cb);
	$display("in APB DRIVER %0t",$time);

	if(vif.apb_drv_cb.PWRITE===0)
		vif.apb_drv_cb.PRDATA<=$urandom;
	repeat(2)
		@(vif.apb_drv_cb);
		
endtask

endclass

