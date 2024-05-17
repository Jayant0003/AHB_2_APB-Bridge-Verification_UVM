class virtual_seqs extends uvm_sequence#(uvm_sequence_item);
`uvm_object_utils(virtual_seqs)
virtual_sequencer v_sequencer;
ahb_master_sequencer ahb_seqrh[];
apb_slave_sequencer apb_seqrh[];
env_config env_cfg;

seq_INCR m_seq1;
seq_INCR4 m_seq2;
seq_INCR8 m_seq3;
seq_INCR16 m_seq4;
seq_WRAP4 m_seq5;
seq_WRAP8 m_seq6;
seq_WRAP16 m_seq7;
seq_IDLE m_seq8;
	function new(string name=get_type_name);
		super.new(name);
	endfunction

task body();
	if(!uvm_config_db #(env_config)::get(null,get_full_name,"env_config",env_cfg))
	`uvm_fatal(get_type_name,"error while getting env_Cfg")
	if(!$cast(v_sequencer,m_sequencer))
		`uvm_error(get_type_name,"error while casting")

	ahb_seqrh=new[env_cfg.no_of_ahb_agent];
	apb_seqrh=new[env_cfg.no_of_apb_agent];
	foreach(ahb_seqrh[i])
	ahb_seqrh[i]=v_sequencer.ahb_seqrh[i];
	foreach(apb_seqrh[i])
	apb_seqrh[i]=v_sequencer.apb_seqrh[i];
	
endtask
endclass

class vseq_INCR extends virtual_seqs;
`uvm_object_utils(vseq_INCR)

function new(string name=get_type_name());
	super.new(name);
endfunction

task body();
	super.body();	
	m_seq1=seq_INCR::type_id::create("m_seq1");
	m_seq1.start(ahb_seqrh[0]);

endtask
endclass


class vseq_INCR4 extends virtual_seqs;
`uvm_object_utils(vseq_INCR4)

function new(string name=get_type_name());
	super.new(name);
endfunction

task body();
	super.body();
	
	m_seq2=seq_INCR4::type_id::create("m_seq1");
m_seq2.start(ahb_seqrh[0]);

endtask

endclass


class vseq_INCR8 extends virtual_seqs;
`uvm_object_utils(vseq_INCR8)

function new(string name=get_type_name());
	super.new(name);
endfunction

task body();
	super.body();
	
	m_seq3=seq_INCR8::type_id::create("m_seq1");
m_seq3.start(ahb_seqrh[0]);

endtask

endclass

class vseq_INCR16 extends virtual_seqs;
`uvm_object_utils(vseq_INCR16)

function new(string name=get_type_name());
	super.new(name);
endfunction

task body();
	super.body();
	m_seq4=seq_INCR16::type_id::create("m_seq1");
	m_seq4.start(ahb_seqrh[0]);

endtask
endclass


class vseq_WRAP4 extends virtual_seqs;
`uvm_object_utils(vseq_WRAP4)
function new(string name=get_type_name());
	super.new(name);
endfunction
task body();
	super.body();
	m_seq5=seq_WRAP4::type_id::create("m_seq5");
	m_seq5.start(ahb_seqrh[0]);

endtask
endclass

class vseq_WRAP8 extends virtual_seqs;
`uvm_object_utils(vseq_WRAP8)
function new(string name=get_type_name());
	super.new(name);
endfunction
task body();
	super.body();
	m_seq6=seq_WRAP8::type_id::create("m_seq6");
	m_seq6.start(ahb_seqrh[0]);

endtask
endclass

class vseq_WRAP16 extends virtual_seqs;
`uvm_object_utils(vseq_WRAP16)
function new(string name=get_type_name());
	super.new(name);
endfunction
task body();
	super.body();
	m_seq7=seq_WRAP16::type_id::create("m_seq7");
	m_seq7.start(ahb_seqrh[0]);

endtask
endclass

class vseq_IDLE extends virtual_seqs;
`uvm_object_utils(vseq_IDLE)
function new(string name=get_type_name());
	super.new(name);
endfunction
task body();
	super.body();
	m_seq8=seq_IDLE::type_id::create("m_seq8");
	m_seq8.start(ahb_seqrh[0]);

endtask
endclass

