// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
// Date        : Tue Mar 11 17:55:26 2025
// Host        : pc-xiancaima running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c://16_sgbus_mgt/ibert_quad/01_test/gtwizard_ultrascale_0_example_top.v
// Design      : gtwizard_ultrascale_0_example_top
// Purpose     : Stub declaration of top-level module interface
// Device      : xcvu19p-fsva3824-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module gtwizard_ultrascale_0_example_top(mgtrefclk0_x0y1_p, mgtrefclk0_x0y1_n, 
  ch0_gtyrxn_in, ch0_gtyrxp_in, ch0_gtytxn_out, ch0_gtytxp_out, ch1_gtyrxn_in, ch1_gtyrxp_in, 
  ch1_gtytxn_out, ch1_gtytxp_out, ch2_gtyrxn_in, ch2_gtyrxp_in, ch2_gtytxn_out, 
  ch2_gtytxp_out, ch3_gtyrxn_in, ch3_gtyrxp_in, ch3_gtytxn_out, ch3_gtytxp_out, 
  hb_gtwiz_reset_clk_freerun_buf_int, hb_gtwiz_reset_all_in, txdiffctrl_int, 
  txmaincursor_int, txpostcursor_int, txprecursor_int, txprbssel_int, rxprbssel_int, 
  qpll0lock_out, drpaddr_int, drpwe_int, eyescanreset_int, drpen_int, drpdi_int, drpdo_int, 
  drprdy_int, link_status_out)
/* synthesis syn_black_box black_box_pad_pin="mgtrefclk0_x0y1_p,mgtrefclk0_x0y1_n,ch0_gtyrxn_in,ch0_gtyrxp_in,ch0_gtytxn_out,ch0_gtytxp_out,ch1_gtyrxn_in,ch1_gtyrxp_in,ch1_gtytxn_out,ch1_gtytxp_out,ch2_gtyrxn_in,ch2_gtyrxp_in,ch2_gtytxn_out,ch2_gtytxp_out,ch3_gtyrxn_in,ch3_gtyrxp_in,ch3_gtytxn_out,ch3_gtytxp_out,hb_gtwiz_reset_clk_freerun_buf_int,hb_gtwiz_reset_all_in[3:0],txdiffctrl_int[19:0],txmaincursor_int[27:0],txpostcursor_int[19:0],txprecursor_int[19:0],txprbssel_int[15:0],rxprbssel_int[15:0],qpll0lock_out[0:0],drpaddr_int[39:0],drpwe_int[3:0],eyescanreset_int[3:0],drpen_int[3:0],drpdi_int[63:0],drpdo_int[63:0],drprdy_int[3:0],link_status_out" */;
  input mgtrefclk0_x0y1_p;
  input mgtrefclk0_x0y1_n;
  input ch0_gtyrxn_in;
  input ch0_gtyrxp_in;
  output ch0_gtytxn_out;
  output ch0_gtytxp_out;
  input ch1_gtyrxn_in;
  input ch1_gtyrxp_in;
  output ch1_gtytxn_out;
  output ch1_gtytxp_out;
  input ch2_gtyrxn_in;
  input ch2_gtyrxp_in;
  output ch2_gtytxn_out;
  output ch2_gtytxp_out;
  input ch3_gtyrxn_in;
  input ch3_gtyrxp_in;
  output ch3_gtytxn_out;
  output ch3_gtytxp_out;
  input hb_gtwiz_reset_clk_freerun_buf_int;
  input [3:0]hb_gtwiz_reset_all_in;
  input [19:0]txdiffctrl_int;
  input [27:0]txmaincursor_int;
  input [19:0]txpostcursor_int;
  input [19:0]txprecursor_int;
  input [15:0]txprbssel_int;
  input [15:0]rxprbssel_int;
  output [0:0]qpll0lock_out;
  input [39:0]drpaddr_int;
  input [3:0]drpwe_int;
  input [3:0]eyescanreset_int;
  input [3:0]drpen_int;
  input [63:0]drpdi_int;
  output [63:0]drpdo_int;
  output [3:0]drprdy_int;
  output link_status_out;
endmodule
