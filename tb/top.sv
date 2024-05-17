module top;
	import uvm_pkg::*;
	import test_pkg::*;
	
	bit clock;
	always #10 clock=~clock;

	ahb_interface ahb_if(clock);
	apb_interface apb_if(clock);
	

	rtl_top DUT(clock,
			ahb_if.HRESETn,
			ahb_if.HTRANS,
			ahb_if.HSIZE,
			ahb_if.HREADYin,
			ahb_if.HWDATA,
			ahb_if.HADDR,
			ahb_if.HWRITE,
			apb_if.PRDATA,
			ahb_if.HRDATA,
			ahb_if.HRESP,
			ahb_if.HREADYout,
			apb_if.PSELx,
			apb_if.PWRITE,
			apb_if.PENABLE,
			apb_if.PADDR,
			apb_if.PWDATA);
			
	initial begin
		uvm_config_db #(virtual ahb_interface)::set(null,"*","ahb_if",ahb_if);
		uvm_config_db #(virtual apb_interface)::set(null,"*","apb_if",apb_if);
		run_test();
	end


endmodule
