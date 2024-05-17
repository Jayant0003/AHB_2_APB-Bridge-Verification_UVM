class apb_slave_sequencer extends uvm_sequencer#(slave_xtn);
`uvm_component_utils(apb_slave_sequencer)

function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction

endclass

