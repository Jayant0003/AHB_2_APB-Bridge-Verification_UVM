class apb_slave_agent_config extends uvm_object;
`uvm_object_utils(apb_slave_agent_config)
virtual apb_interface vif;
uvm_active_passive_enum is_active;

function new(string name=get_type_name());
	super.new(name);
endfunction

endclass
