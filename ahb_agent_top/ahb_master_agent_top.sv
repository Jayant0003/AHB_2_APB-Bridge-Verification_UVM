class ahb_master_agent_top extends uvm_env;
`uvm_component_utils(ahb_master_agent_top)


ahb_master_agent ahb_agent[];
env_config env_cfg;
ahb_master_agent_config ahb_agent_cfg;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_type_name(),"error while getting env_cfg");
	ahb_agent=new[env_cfg.no_of_ahb_agent];
	foreach(ahb_agent[i]) begin
		uvm_config_db #(ahb_master_agent_config)::set(this,$sformatf("ahb_agent[%0d]*",i),"ahb_master_agent_config",env_cfg.ahb_agent_cfg[i]);
		ahb_agent[i]=ahb_master_agent::type_id::create($sformatf("ahb_agent[%0d]",i),this);
	end

endfunction
endclass
