class env extends uvm_env;
`uvm_component_utils(env)
env_config env_cfg;

apb_slave_agent_top apb_agent_top[];
ahb_master_agent_top ahb_agent_top[];

scoreboard sb;
virtual_sequencer v_sequencer;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	uvm_config_db #(env_config)::get(this,"","env_config",env_cfg);
if(env_cfg.has_apb_slave_uvc)
	apb_agent_top=new[env_cfg.no_of_apb_slave_uvcs];
	foreach(apb_agent_top[i])
		apb_agent_top[i]=apb_slave_agent_top::type_id::create($sformatf("apb_agent_top[%0d]",i),this);

	
	if(env_cfg.has_ahb_master_uvc)
	ahb_agent_top=new[env_cfg.no_of_ahb_master_uvcs];
	foreach(ahb_agent_top[i])
		ahb_agent_top[i]=ahb_master_agent_top::type_id::create($sformatf("ahb_agent_top[%0d]",i),this);
		
	if(env_cfg.has_virtual_sequencer)
		v_sequencer=virtual_sequencer::type_id::create("v_sequencer",this);
	if(env_cfg.has_scoreboard)
		sb=scoreboard::type_id::create("sb",this);	
	super.build_phase(phase);

endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	foreach(v_sequencer.ahb_seqrh[i])
	v_sequencer.ahb_seqrh[i]=ahb_agent_top[i].ahb_agent[i].seqrh;
	foreach(v_sequencer.apb_seqrh[i])
	v_sequencer.apb_seqrh[i]=apb_agent_top[i].apb_agent[i].seqrh;

	if(env_cfg.has_scoreboard) begin
		foreach(ahb_agent_top[i]) begin
			foreach(ahb_agent_top[i].ahb_agent[j])
				ahb_agent_top[i].ahb_agent[j].monh.ap.connect(sb.master_fifo.analysis_export);
		end
		foreach(apb_agent_top[i]) begin
			foreach(apb_agent_top[i].apb_agent[j])
				apb_agent_top[i].apb_agent[j].monh.ap.connect(sb.slave_fifo.analysis_export);
		end
	end
endfunction
endclass
