// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
// Date        : Thu Feb 20 11:05:52 2025
// Host        : pc-xiancaima running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ vio_0_stub.v
// Design      : vio_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xcvu19p-fsva3824-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2021.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk, probe_in0, probe_out0, probe_out1, 
  probe_out2, probe_out3)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[0:0],probe_out0[4:0],probe_out1[4:0],probe_out2[4:0],probe_out3[0:0]" */;
  input clk;
  input [0:0]probe_in0;
  output [4:0]probe_out0;
  output [4:0]probe_out1;
  output [4:0]probe_out2;
  output [0:0]probe_out3;
endmodule
