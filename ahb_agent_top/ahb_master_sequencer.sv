class ahb_master_sequencer extends uvm_sequencer#(master_xtn);
`uvm_component_utils(ahb_master_sequencer)

function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


endclass
