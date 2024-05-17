class test_lib extends uvm_test;
`uvm_component_utils(test_lib)
env envh;

virtual_seqs v_seqs;
vseq_INCR v_seq1;
vseq_INCR4 v_seq2;
vseq_INCR8 v_seq3;
vseq_INCR16 v_seq4;
vseq_WRAP4 v_seq5;
vseq_WRAP8 v_seq6;
vseq_WRAP16 v_seq7;
vseq_IDLE v_seq8;

env_config env_cfg;
ahb_master_agent_config ahb_agent_cfg[];
apb_slave_agent_config apb_agent_cfg[];

bit has_scoreboard=1;
bit has_virtual_sequencer=1;
bit has_ahb_master_uvc=1;
bit has_apb_slave_uvc=1;
int no_of_ahb_agent=1;
int no_of_apb_agent=1;
int no_of_ahb_master_uvcs=1;
int no_of_apb_slave_uvcs=1;



function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	env_cfg=new;
	if(has_ahb_master_uvc) 
		ahb_agent_cfg=new[no_of_ahb_agent];
	if(has_apb_slave_uvc) 
		apb_agent_cfg=new[no_of_apb_agent];
	config_tb();
	uvm_config_db #(env_config)::set(this,"*","env_config",env_cfg);
	
	super.build_phase(phase);
	
	envh=env::type_id::create("envh",this);
	
	
endfunction
function void config_tb();
	if(has_ahb_master_uvc) begin
		env_cfg.ahb_agent_cfg=new[no_of_ahb_agent];
		foreach(ahb_agent_cfg[i]) begin
			ahb_agent_cfg[i]=new;
			if(!uvm_config_db #(virtual ahb_interface)::get(this,"","ahb_if",ahb_agent_cfg[i].vif))
				`uvm_fatal(get_type_name,"error while getting vif")
			ahb_agent_cfg[i].is_active=UVM_ACTIVE;
			env_cfg.ahb_agent_cfg[i]=ahb_agent_cfg[i];
		end
	end
	if(has_apb_slave_uvc) begin
		env_cfg.apb_agent_cfg=new[no_of_apb_agent];
		foreach(apb_agent_cfg[i]) begin
			apb_agent_cfg[i]=new;
			if(!uvm_config_db #(virtual apb_interface)::get(this,"","apb_if",apb_agent_cfg[i].vif))
				`uvm_fatal(get_type_name,"error while getting vif")
				
			apb_agent_cfg[i].is_active=UVM_ACTIVE;
			env_cfg.apb_agent_cfg[i]=apb_agent_cfg[i];
		end
	end
env_cfg.has_scoreboard=has_scoreboard;
env_cfg.has_virtual_sequencer=has_virtual_sequencer;
env_cfg.has_ahb_master_uvc=has_ahb_master_uvc;
env_cfg.has_apb_slave_uvc=has_apb_slave_uvc;

env_cfg.no_of_ahb_agent=no_of_ahb_agent;
env_cfg.no_of_apb_agent=no_of_apb_agent;
env_cfg.no_of_ahb_master_uvcs=no_of_ahb_master_uvcs;
env_cfg.no_of_apb_slave_uvcs=no_of_apb_slave_uvcs;

endfunction

function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction

endclass

class test1 extends test_lib;
`uvm_component_utils(test1)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	v_seq1=vseq_INCR::type_id::create("v_seq1");
	
	phase.raise_objection(this);
	repeat(3)
	v_seq1.start(envh.v_sequencer);
	#82;
	
	phase.drop_objection(this);
endtask

endclass

class test2 extends test_lib;
`uvm_component_utils(test2)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction
task run_phase(uvm_phase phase);
	$display("in TEST %0t",$time);

	super.run_phase(phase);
	v_seq2=vseq_INCR4::type_id::create("v_seq2");
	
	phase.raise_objection(this);
	repeat(1) 
	v_seq2.start(envh.v_sequencer);
	// 10+10+1+1
	#81;
	phase.drop_objection(this);
endtask

endclass

class test3 extends test_lib;
`uvm_component_utils(test3)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	v_seq3=vseq_INCR8::type_id::create("v_seq3");
	
	phase.raise_objection(this);
	repeat(3) 
	v_seq3.start(envh.v_sequencer);
	#81;
	
	phase.drop_objection(this);
endtask

endclass

class test4 extends test_lib;
`uvm_component_utils(test4)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	v_seq4=vseq_INCR16::type_id::create("v_seq4");
	
	phase.raise_objection(this);
	repeat(3) 
	v_seq4.start(envh.v_sequencer);
	#81;
	
	phase.drop_objection(this);
endtask
endclass

class test5 extends test_lib;
`uvm_component_utils(test5)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	v_seq5=vseq_WRAP4::type_id::create("v_seq5");
	
	phase.raise_objection(this);
	repeat(3) 
	v_seq5.start(envh.v_sequencer);
	#81;
	
	phase.drop_objection(this);
endtask
endclass

class test6 extends test_lib;
`uvm_component_utils(test6)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	v_seq6=vseq_WRAP8::type_id::create("v_seq6");
	
	phase.raise_objection(this);
	repeat(3) 
	v_seq6.start(envh.v_sequencer);
	#81;
	phase.drop_objection(this);
endtask
endclass

class test7 extends test_lib;
`uvm_component_utils(test7)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	v_seq7=vseq_WRAP16::type_id::create("v_seq7");
	
	phase.raise_objection(this);
	repeat(3)
	v_seq7.start(envh.v_sequencer);
	#81;
	phase.drop_objection(this);
endtask
endclass

class test8 extends test_lib;
`uvm_component_utils(test8)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	v_seq8=vseq_IDLE::type_id::create("v_seq8");
	
	phase.raise_objection(this);
	v_seq8.start(envh.v_sequencer);
	#81;
	phase.drop_objection(this);
endtask
endclass
