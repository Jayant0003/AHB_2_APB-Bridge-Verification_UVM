class master_xtn extends uvm_sequence_item;
`uvm_object_utils(master_xtn)
rand bit[31:0] HADDR;
rand bit[1:0] HTRANS;
rand bit[2:0] HSIZE;
rand bit[2:0] HBURST;
rand bit HWRITE;
rand bit[31:0] HWDATA;
bit[31:0] HRDATA;
rand bit[9:0] HLIMIT;
function new(string name=get_type_name());
	super.new(name);
endfunction

constraint c1{ HADDR inside{[32'h8000_0000:32'h8000_03FF],[32'h8400_0000:32'h8400_03FF],[32'h8800_0000:32'h8800_03FF],[32'h8c00_0000:32'h8c00_03FF]};
	      		HSIZE inside{0,1,2};
		HSIZE==1->HADDR%2==0;HSIZE==2->HADDR%4==0;};


function void do_print(uvm_printer printer);
	super.do_print(printer);
printer.print_field("HADDR",HADDR,32,UVM_HEX);
printer.print_field("HTRANS",HTRANS,2,UVM_DEC);
printer.print_field("HSIZE",HSIZE,3,UVM_DEC);
printer.print_field("HWRITE",HWRITE,1,UVM_BIN);
printer.print_field("HWDATA",HWDATA,32,UVM_HEX);
printer.print_field("HRDATA",HRDATA,32,UVM_HEX);
printer.print_field("HBURST",HBURST,3,UVM_DEC);
printer.print_field("HLIMIT",HLIMIT,10,UVM_DEC);
endfunction
endclass
