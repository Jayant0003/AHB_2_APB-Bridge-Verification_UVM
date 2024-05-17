class env_config extends uvm_object;
`uvm_object_utils(env_config)
apb_slave_agent_config apb_agent_cfg[];
ahb_master_agent_config ahb_agent_cfg[];

bit has_scoreboard;
bit has_virtual_sequencer;
bit has_ahb_master_uvc;
bit has_apb_slave_uvc;

int no_of_ahb_master_uvcs;
int no_of_apb_slave_uvcs;
int no_of_ahb_agent;
int no_of_apb_agent;

function new(string name=get_type_name());
	super.new(name);
endfunction

endclass
