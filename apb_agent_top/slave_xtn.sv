class slave_xtn extends uvm_sequence_item;
`uvm_object_utils(slave_xtn)

logic[31:0] PADDR;
logic PWRITE;
logic[3:0] PSELx;
logic[31:0] PWDATA;
logic[31:0] PRDATA;

function new(string name=get_type_name());
	super.new(name);
endfunction

function void do_print(uvm_printer printer);
	super.do_print(printer);
printer.print_field("PADDR",PADDR,32,UVM_HEX);
printer.print_field("PWRITE",PWRITE,1,UVM_BIN);
printer.print_field("PSEx",PSELx,4,UVM_DEC);
printer.print_field("PWDATA",PWDATA,32,UVM_HEX);
printer.print_field("PRDATA",PRDATA,32,UVM_HEX);
endfunction

endclass
