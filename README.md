This is a AHB_to_APB Bridge Protocol Verification. The TestBench is build using UVM Methodlogies. The Testbench is independent of testcases as virtual sequence and virtual sequencer is used in the testbench architecture.
There are testcases for all the burst types and one testcase for IDLE sequence. The bridge is like a converter of AHB signal into APB signals and since it is not a full-fledged AHB Protocol verification, so the 
response coming from Bridge to AHB master are only OKAY/ERROR response. 
