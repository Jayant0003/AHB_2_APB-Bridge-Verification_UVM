class virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
`uvm_component_utils(virtual_sequencer)
ahb_master_sequencer ahb_seqrh[];
apb_slave_sequencer apb_seqrh[];
env_config env_cfg;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_type_name,"error while getting env_cfg")
	if(env_cfg.has_ahb_master_uvc)
	ahb_seqrh=new[env_cfg.no_of_ahb_agent];
	if(env_cfg.has_apb_slave_uvc)
	apb_seqrh=new[env_cfg.no_of_apb_agent];
endfunction

endclass
