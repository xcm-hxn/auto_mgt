//------------------------------------------------------------------------------
//  (c) Copyright 2013-2018 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES.
//------------------------------------------------------------------------------


`timescale 1ps/1ps

// =====================================================================================================================
// This example design wrapper module instantiates the core and any helper blocks which the user chose to exclude from
// the core, connects them as appropriate, and maps enabled ports
// =====================================================================================================================

module gtwizard_ultrascale_0_example_wrapper (
  input  wire [0:0] gtyrxn_in
 ,input  wire [0:0] gtyrxp_in
 ,output wire [0:0] gtytxn_out
 ,output wire [0:0] gtytxp_out
 ,input  wire [0:0] gtwiz_userclk_tx_reset_in
 ,output wire [0:0] gtwiz_userclk_tx_srcclk_out
 ,output wire [0:0] gtwiz_userclk_tx_usrclk_out
 ,output wire [0:0] gtwiz_userclk_tx_usrclk2_out
 ,output wire [0:0] gtwiz_userclk_tx_active_out
 ,input  wire [0:0] gtwiz_userclk_rx_reset_in
 ,output wire [0:0] gtwiz_userclk_rx_srcclk_out
 ,output wire [0:0] gtwiz_userclk_rx_usrclk_out
 ,output wire [0:0] gtwiz_userclk_rx_usrclk2_out
 ,output wire [0:0] gtwiz_userclk_rx_active_out
 ,input  wire [0:0] gtwiz_reset_clk_freerun_in
 ,input  wire [0:0] gtwiz_reset_all_in
 ,input  wire [0:0] gtwiz_reset_tx_pll_and_datapath_in
 ,input  wire [0:0] gtwiz_reset_tx_datapath_in
 ,input  wire [0:0] gtwiz_reset_rx_pll_and_datapath_in
 ,input  wire [0:0] gtwiz_reset_rx_datapath_in
 ,output wire [0:0] gtwiz_reset_rx_cdr_stable_out
 ,output wire [0:0] gtwiz_reset_tx_done_out
 ,output wire [0:0] gtwiz_reset_rx_done_out
 ,input  wire [31:0] gtwiz_userdata_tx_in
 ,output wire [31:0] gtwiz_userdata_rx_out
 ,input  wire [0:0] gtrefclk00_in
 ,output wire [0:0] qpll0lock_out
 ,output wire [0:0] qpll0outclk_out
 ,output wire [0:0] qpll0outrefclk_out
 ,input  wire [9:0] drpaddr_in
 ,input  wire [0:0] drpclk_in
 ,input  wire [15:0] drpdi_in
 ,input  wire [0:0] drpen_in
 ,input  wire [0:0] drpwe_in
 ,input  wire [0:0] eyescanreset_in
 ,input  wire [0:0] rx8b10ben_in
 ,input  wire [0:0] rxbufreset_in
 ,input  wire [0:0] rxcommadeten_in
 ,input  wire [0:0] rxlpmen_in
 ,input  wire [0:0] rxmcommaalignen_in
 ,input  wire [0:0] rxpcommaalignen_in
 ,input  wire [3:0] rxprbssel_in
 ,input  wire [2:0] rxrate_in
 ,input  wire [0:0] tx8b10ben_in
 ,input  wire [15:0] txctrl0_in
 ,input  wire [15:0] txctrl1_in
 ,input  wire [7:0] txctrl2_in
 ,input  wire [4:0] txdiffctrl_in
 ,input  wire [6:0] txmaincursor_in
 ,input  wire [4:0] txpostcursor_in
 ,input  wire [3:0] txprbssel_in
 ,input  wire [4:0] txprecursor_in
 ,output wire [15:0] drpdo_out
 ,output wire [0:0] drprdy_out
 ,output wire [0:0] gtpowergood_out
 ,output wire [2:0] rxbufstatus_out
 ,output wire [0:0] rxbyteisaligned_out
 ,output wire [0:0] rxbyterealign_out
 ,output wire [1:0] rxclkcorcnt_out
 ,output wire [0:0] rxcommadet_out
 ,output wire [15:0] rxctrl0_out
 ,output wire [15:0] rxctrl1_out
 ,output wire [7:0] rxctrl2_out
 ,output wire [7:0] rxctrl3_out
 ,output wire [0:0] rxpmaresetdone_out
 ,output wire [0:0] txpmaresetdone_out
);


  // ===================================================================================================================
  // PARAMETERS AND FUNCTIONS
  // ===================================================================================================================

  // Declare and initialize local parameters and functions used for HDL generation
  localparam [191:0] P_CHANNEL_ENABLE = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000;
  `include "gtwizard_ultrascale_0_example_wrapper_functions.v"
  localparam integer P_TX_MASTER_CH_PACKED_IDX = f_calc_pk_mc_idx(4);
  localparam integer P_RX_MASTER_CH_PACKED_IDX = f_calc_pk_mc_idx(4);


  // ===================================================================================================================
  // HELPER BLOCKS
  // ===================================================================================================================

  // Any helper blocks which the user chose to exclude from the core will appear below. In addition, some signal
  // assignments related to optionally-enabled ports may appear below.
  wire [0:0] gtpowergood_int;

  // Required assignment to expose the GTPOWERGOOD port per user request
  assign gtpowergood_out = gtpowergood_int;

  // ----------------------------------------------------------------------------------------------------------------
  // Assignments to expose data ports, or data control ports, per configuration requirement or user request
  // ----------------------------------------------------------------------------------------------------------------

  wire [15:0] txctrl0_int;

  // Required assignment to expose the TXCTRL0 port per configuration requirement or user request
  assign txctrl0_int = txctrl0_in;
  wire [15:0] txctrl1_int;

  // Required assignment to expose the TXCTRL1 port per configuration requirement or user request
  assign txctrl1_int = txctrl1_in;
  wire [15:0] rxctrl0_int;

  // Required assignment to expose the RXCTRL0 port per configuration requirement or user request
  assign rxctrl0_out = rxctrl0_int;
  wire [15:0] rxctrl1_int;

  // Required assignment to expose the RXCTRL1 port per configuration requirement or user request
  assign rxctrl1_out = rxctrl1_int;


  // ===================================================================================================================
  // CORE INSTANCE
  // ===================================================================================================================

  // Instantiate the core, mapping its enabled ports to example design ports and helper blocks as appropriate
  gtwizard_ultrascale_0 gtwizard_ultrascale_0_inst (
    .gtyrxn_in                               (gtyrxn_in)
   ,.gtyrxp_in                               (gtyrxp_in)
   ,.gtytxn_out                              (gtytxn_out)
   ,.gtytxp_out                              (gtytxp_out)
   ,.gtwiz_userclk_tx_reset_in               (gtwiz_userclk_tx_reset_in)
   ,.gtwiz_userclk_tx_srcclk_out             (gtwiz_userclk_tx_srcclk_out)
   ,.gtwiz_userclk_tx_usrclk_out             (gtwiz_userclk_tx_usrclk_out)
   ,.gtwiz_userclk_tx_usrclk2_out            (gtwiz_userclk_tx_usrclk2_out)
   ,.gtwiz_userclk_tx_active_out             (gtwiz_userclk_tx_active_out)
   ,.gtwiz_userclk_rx_reset_in               (gtwiz_userclk_rx_reset_in)
   ,.gtwiz_userclk_rx_srcclk_out             (gtwiz_userclk_rx_srcclk_out)
   ,.gtwiz_userclk_rx_usrclk_out             (gtwiz_userclk_rx_usrclk_out)
   ,.gtwiz_userclk_rx_usrclk2_out            (gtwiz_userclk_rx_usrclk2_out)
   ,.gtwiz_userclk_rx_active_out             (gtwiz_userclk_rx_active_out)
   ,.gtwiz_reset_clk_freerun_in              (gtwiz_reset_clk_freerun_in)
   ,.gtwiz_reset_all_in                      (gtwiz_reset_all_in)
   ,.gtwiz_reset_tx_pll_and_datapath_in      (gtwiz_reset_tx_pll_and_datapath_in)
   ,.gtwiz_reset_tx_datapath_in              (gtwiz_reset_tx_datapath_in)
   ,.gtwiz_reset_rx_pll_and_datapath_in      (gtwiz_reset_rx_pll_and_datapath_in)
   ,.gtwiz_reset_rx_datapath_in              (gtwiz_reset_rx_datapath_in)
   ,.gtwiz_reset_rx_cdr_stable_out           (gtwiz_reset_rx_cdr_stable_out)
   ,.gtwiz_reset_tx_done_out                 (gtwiz_reset_tx_done_out)
   ,.gtwiz_reset_rx_done_out                 (gtwiz_reset_rx_done_out)
   ,.gtwiz_userdata_tx_in                    (gtwiz_userdata_tx_in)
   ,.gtwiz_userdata_rx_out                   (gtwiz_userdata_rx_out)
   ,.gtrefclk00_in                           (gtrefclk00_in)
   ,.qpll0lock_out                           (qpll0lock_out)
   ,.qpll0outclk_out                         (qpll0outclk_out)
   ,.qpll0outrefclk_out                      (qpll0outrefclk_out)
   ,.drpaddr_in                              (drpaddr_in)
   ,.drpclk_in                               (drpclk_in)
   ,.drpdi_in                                (drpdi_in)
   ,.drpen_in                                (drpen_in)
   ,.drpwe_in                                (drpwe_in)
   ,.eyescanreset_in                         (eyescanreset_in)
   ,.rx8b10ben_in                            (rx8b10ben_in)
   ,.rxbufreset_in                           (rxbufreset_in)
   ,.rxcommadeten_in                         (rxcommadeten_in)
   ,.rxlpmen_in                              (rxlpmen_in)
   ,.rxmcommaalignen_in                      (rxmcommaalignen_in)
   ,.rxpcommaalignen_in                      (rxpcommaalignen_in)
   ,.rxprbssel_in                            (rxprbssel_in)
   ,.rxrate_in                               (rxrate_in)
   ,.tx8b10ben_in                            (tx8b10ben_in)
   ,.txctrl0_in                              (txctrl0_int)
   ,.txctrl1_in                              (txctrl1_int)
   ,.txctrl2_in                              (txctrl2_in)
   ,.txdiffctrl_in                           (txdiffctrl_in)
   ,.txmaincursor_in                         (txmaincursor_in)
   ,.txpostcursor_in                         (txpostcursor_in)
   ,.txprbssel_in                            (txprbssel_in)
   ,.txprecursor_in                          (txprecursor_in)
   ,.drpdo_out                               (drpdo_out)
   ,.drprdy_out                              (drprdy_out)
   ,.gtpowergood_out                         (gtpowergood_int)
   ,.rxbufstatus_out                         (rxbufstatus_out)
   ,.rxbyteisaligned_out                     (rxbyteisaligned_out)
   ,.rxbyterealign_out                       (rxbyterealign_out)
   ,.rxclkcorcnt_out                         (rxclkcorcnt_out)
   ,.rxcommadet_out                          (rxcommadet_out)
   ,.rxctrl0_out                             (rxctrl0_int)
   ,.rxctrl1_out                             (rxctrl1_int)
   ,.rxctrl2_out                             (rxctrl2_out)
   ,.rxctrl3_out                             (rxctrl3_out)
   ,.rxpmaresetdone_out                      (rxpmaresetdone_out)
   ,.txpmaresetdone_out                      (txpmaresetdone_out)
);

endmodule
