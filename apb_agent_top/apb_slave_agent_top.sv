class apb_slave_agent_top extends uvm_env;
`uvm_component_utils(apb_slave_agent_top)


apb_slave_agent apb_agent[];
env_config env_cfg;
apb_slave_agent_config apb_agent_cfg;

function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_type_name(),"error while getting env_cfg");
	apb_agent=new[env_cfg.no_of_apb_agent];
	foreach(apb_agent[i]) begin
		uvm_config_db #(apb_slave_agent_config)::set(this,$sformatf("apb_agent[%0d]*",i),"apb_slave_agent_config",env_cfg.apb_agent_cfg[i]);
		apb_agent[i]=apb_slave_agent::type_id::create($sformatf("apb_agent[%0d]",i),this);
	end
endfunction

endclass
