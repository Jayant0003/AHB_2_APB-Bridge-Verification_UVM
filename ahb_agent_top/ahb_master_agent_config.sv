class ahb_master_agent_config extends uvm_object;
`uvm_object_utils(ahb_master_agent_config)
virtual ahb_interface vif;
uvm_active_passive_enum is_active;

function new(string name=get_type_name());
	super.new(name);
endfunction

endclass
