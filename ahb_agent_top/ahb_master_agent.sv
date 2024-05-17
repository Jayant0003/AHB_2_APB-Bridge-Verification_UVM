class ahb_master_agent extends uvm_agent;
`uvm_component_utils(ahb_master_agent)


ahb_master_agent_config ahb_agent_cfg;
ahb_master_driver drvh;
ahb_master_monitor monh;
ahb_master_sequencer seqrh;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(ahb_master_agent_config)::get(this,"","ahb_master_agent_config",ahb_agent_cfg))
	`uvm_fatal(get_type_name,"error while getting agent_cfg");

	monh=ahb_master_monitor::type_id::create("monh",this);
	if(ahb_agent_cfg.is_active==UVM_ACTIVE) begin
	drvh=ahb_master_driver::type_id::create("drvh",this);
	seqrh=ahb_master_sequencer::type_id::create("seqrh",this);
	end
	
		
endfunction
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction

endclass

