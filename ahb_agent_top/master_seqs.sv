class master_seqs extends uvm_sequence#(master_xtn);
`uvm_object_utils(master_seqs)
bit[31:0] addr;
bit[2:0] size;
bit[9:0] hlimit;
bit[2:0] hburst;
bit hwrite;
function new(string name=get_type_name());
	super.new(name);
endfunction
endclass


class seq_INCR extends master_seqs;
`uvm_object_utils(seq_INCR)
function new(string name=get_type_name());
	super.new(name);
endfunction

task body();
	req=master_xtn::type_id::create("req");
	start_item(req);
	assert (req.randomize with {HTRANS==2;HBURST==1;HLIMIT inside {[15:30]};HADDR%1024 + (HLIMIT*(1<<HSIZE))<1024;})

	addr=req.HADDR;
	size=req.HSIZE;
	hlimit=req.HLIMIT;
	hburst=req.HBURST;
	hwrite=req.HWRITE;
	finish_item(req);
//
	for(int i=0;i<hlimit-1;i++) begin
	req=master_xtn::type_id::create("req");
	start_item(req);
	req.HBURST.rand_mode(0);
	req.HLIMIT.rand_mode(0);
	req.HBURST=hburst;
	req.HLIMIT=hlimit;

//	if(addr+(1<<size)>32'h8000_03FF) begin
//		`uvm_error(get_type_name,"address size exceeded")
//		break;
//	end  
	assert (req.randomize with {HTRANS==3;HADDR==(addr+(1<<size));HSIZE==size;HWRITE==hwrite;})

	addr=req.HADDR;
	finish_item(req);
	end
endtask
endclass


class seq_INCR4 extends master_seqs;
`uvm_object_utils(seq_INCR4)
function new(string name=get_type_name());
	super.new(name);
endfunction

task body();
	req=master_xtn::type_id::create("req");
	start_item(req);
	assert (req.randomize with {HTRANS==2;HBURST==3;HADDR%1024 + 4*(1<<HSIZE)<=1024;})
//	if(!(req.HADDR%1024 + 4*1<<req.HSIZE<1024)) begin
//		`uvm_error(get_type_name,"address exceeded")
//		return;
//	end
	addr=req.HADDR;
	size=req.HSIZE;
	hburst=req.HBURST;
	hwrite=req.HWRITE;
	finish_item(req);

	for(int i=0;i<3;i++) begin
	req=master_xtn::type_id::create("req");
	start_item(req);
	req.HBURST.rand_mode(0);
	req.HBURST=hburst;
//	if(addr+(1<<size)>32'h8000_03FF) begin
//		`uvm_error(get_type_name,"address size exceeded")
//		break;
//	end
	assert (req.randomize with {HTRANS==3; HWRITE==hwrite;HADDR==addr+(1<<size);HSIZE==size;})
	
	addr=req.HADDR;
	finish_item(req);
	
	end
endtask
endclass


class seq_INCR8 extends master_seqs;
`uvm_object_utils(seq_INCR8)
function new(string name=get_type_name());
	super.new(name);
endfunction

task body();
	req=master_xtn::type_id::create("req");
	start_item(req);
	assert (req.randomize with {HTRANS==2;HBURST==5;HADDR%1024 + 8*(1<<HSIZE)<=1024;})
	addr=req.HADDR;
	size=req.HSIZE;
	hwrite=req.HWRITE;
	hburst=req.HBURST;
	finish_item(req);
	
	for(int i=0;i<7;i++) begin
	req=master_xtn::type_id::create("req");
	start_item(req);
	req.HBURST.rand_mode(0);
	req.HBURST=hburst;
//	if(addr+(1<<size)>32'h8000_03FF) begin
//		`uvm_error(get_type_name,"address size exceeded")
//		break;
//	end
	assert (req.randomize with {HTRANS==3;HADDR==addr+(1<<size);HSIZE==size;HWRITE==hwrite;})
	
	addr=req.HADDR;
	finish_item(req);
	
	end
endtask
endclass


class seq_INCR16 extends master_seqs;
`uvm_object_utils(seq_INCR16)
function new(string name=get_type_name());
	super.new(name);
endfunction

task body();
	req=master_xtn::type_id::create("req");
	start_item(req);
	assert (req.randomize with {HTRANS==2;HBURST==7;HADDR%1024 + 16*(1<<HSIZE)<=1024;})
	addr=req.HADDR;
	size=req.HSIZE;
	hburst=req.HBURST;
	hwrite=req.HWRITE;
	finish_item(req);

	for(int i=0;i<15;i++) begin
	req=master_xtn::type_id::create("req");
	start_item(req);
	req.HBURST.rand_mode(0);
	req.HBURST=hburst;
	hwrite=req.HWRITE;
//	if(addr+(1<<size)>32'h8000_03FF) begin
//		`uvm_error(get_type_name,"address size exceeded")
//		break;
//	end
	assert (req.randomize with {HTRANS==3;HADDR==addr+(1 <<size);HSIZE==size;HWRITE==hwrite;})
	
	addr=req.HADDR;
	finish_item(req);
	
	end
endtask
endclass

class seq_WRAP4 extends master_seqs;
`uvm_object_utils(seq_WRAP4)
function new(string name=get_type_name());
	super.new(name);
endfunction
task body();
	req=master_xtn::type_id::create("req");
	start_item(req);
	req.HLIMIT.rand_mode(0);
	assert (req.randomize with {HTRANS==2;HBURST==2;HSIZE==2;})

	addr=req.HADDR;
	size=req.HSIZE;
	hburst=req.HBURST;
	hwrite=req.HWRITE;
	finish_item(req);

	for(int i=0;i<3;i++) begin
	req=master_xtn::type_id::create("req");
	start_item(req);
	req.HLIMIT.rand_mode(0);
	req.HBURST.rand_mode(0);
	req.HBURST=hburst;
	assert (req.randomize with {HTRANS==3;HWRITE==hwrite;HSIZE==size;if(size==0) HADDR=={addr[31:2],(addr[1:0]+1'b1)};else if(size==1) HADDR=={addr[31:3],addr[2:1]+1'b1,addr[0]};else if(size==2) HADDR=={addr[31:4],addr[3:2]+1'b1,addr[1:0]};
});
	addr=req.HADDR;
	finish_item(req);
	end
endtask
endclass

class seq_WRAP8 extends master_seqs;
`uvm_object_utils(seq_WRAP8)
function new(string name=get_type_name());
	super.new(name);
endfunction
task body();
	req=master_xtn::type_id::create("req");
	start_item(req);
	req.HLIMIT.rand_mode(0);
	assert (req.randomize with {HTRANS==2;HBURST==4;})

	addr=req.HADDR;
	size=req.HSIZE;
	hburst=req.HBURST;
	hwrite=req.HWRITE;
	finish_item(req);

	for(int i=0;i<3;i++) begin
	req=master_xtn::type_id::create("req");
	start_item(req);
	req.HLIMIT.rand_mode(0);
	req.HBURST.rand_mode(0);
	req.HBURST=hburst;
	assert (req.randomize with {HTRANS==3;HWRITE==hwrite;HSIZE==size;if(size==0) HADDR=={addr[31:2],(addr[1:0]+1'b1)};else if(size==1) HADDR=={addr[31:3],addr[2:1]+1'b1,addr[0]};else if(size==2) HADDR=={addr[31:4],addr[3:2]+1'b1,addr[1:0]};
});
	addr=req.HADDR;
	finish_item(req);
	end
endtask
endclass

class seq_WRAP16 extends master_seqs;
`uvm_object_utils(seq_WRAP16)
function new(string name=get_type_name());
	super.new(name);
endfunction
task body();
	req=master_xtn::type_id::create("req");
	start_item(req);
	req.HLIMIT.rand_mode(0);
	assert (req.randomize with {HTRANS==2;HBURST==6;})

	addr=req.HADDR;
	size=req.HSIZE;
	hburst=req.HBURST;
	hwrite=req.HWRITE;
	finish_item(req);

	for(int i=0;i<3;i++) begin
	req=master_xtn::type_id::create("req");
	start_item(req);
	req.HLIMIT.rand_mode(0);
	req.HBURST.rand_mode(0);
	req.HBURST=hburst;
	assert (req.randomize with {HTRANS==3;HWRITE==hwrite;HSIZE==size;if(size==0) HADDR=={addr[31:2],(addr[1:0]+1'b1)};else if(size==1) HADDR=={addr[31:3],addr[2:1]+1'b1,addr[0]};else if(size==2) HADDR=={addr[31:4],addr[3:2]+1'b1,addr[1:0]};
})
	addr=req.HADDR;
	finish_item(req);
	end
endtask
endclass


class seq_IDLE extends master_seqs;
`uvm_object_utils(seq_IDLE)
function new(string name=get_type_name());
	super.new(name);
endfunction

task body();
	req=master_xtn::type_id::create("req");
	start_item(req);
	assert (req.randomize with {HTRANS==0;HBURST==0;})
	finish_item(req);

endtask
endclass

