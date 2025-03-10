`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/20 17:37:46
// Design Name: 
// Module Name: eyescan
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// =====================================================================================================================
// This example design top module instantiates the example design wrapper; slices vectored ports for per-channel
// assignment; and instantiates example resources such as buffers, pattern generators, and pattern checkers for core
// demonstration purposes
// =====================================================================================================================

module eyescan (

  // Differential reference clock inputs
  input  logic mgtrefclk0_p,
  input  logic mgtrefclk0_n,

  // Serial data ports for transceiver channel 0
  input  logic gtyrxn_in,
  input  logic gtyrxp_in,
  output logic gtytxn_out,
  output logic gtytxp_out,

  // User-provided ports for reset helper block(s)
  input  logic gtwiz_reset_clk_freerun_in_p,
  input  logic gtwiz_reset_clk_freerun_in_n,
  input  logic hb_gtwiz_resetn_all_in,

  //ibert parameter 
  input  logic [ 4:0] txdiffctrl_int,
  input  logic [ 6:0] txmaincursor_int,
  input  logic [ 4:0] txpostcursor_int,
  input  logic [ 4:0] txprecursor_int,
  input  logic [ 3:0] txprbssel_int,
  input  logic [ 3:0] rxprbssel_int,

  output logic [ 0:0] qpll0lock_out,


  //drp interface
  input  logic [9:0] drpaddr_int,
  input  logic [0:0] drpwe_int,
  input  logic [0:0] eyescanreset_int,
  input  logic [0:0] drpen_int,
  input  logic [15:0] drpdi_int,
  output logic [15:0] drpdo_int,
  output logic [0:0] drprdy_int,

  // PRBS-based link status ports
  output logic link_status_out




);




  // ===================================================================================================================
  // PER-CHANNEL SIGNAL ASSIGNMENTS
  // ===================================================================================================================

  // The core and example design wrapper vectorize ports across all enabled transceiver channel and common instances for
  // simplicity and compactness. This example design top module assigns slices of each vector to individual, per-channel
  // signal vectors for use if desired. Signals which connect to helper blocks are prefixed "hb#", signals which connect
  // to transceiver common primitives are prefixed "cm#", and signals which connect to transceiver channel primitives
  // are prefixed "ch#", where "#" is the sequential resource number.

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtyrxn_int;
  assign gtyrxn_int[0:0] = gtyrxn_in;

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtyrxp_int;
  assign gtyrxp_int[0:0] = gtyrxp_in;

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtytxn_int;
  assign gtytxn_out = gtytxn_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtytxp_int;
  assign gtytxp_out = gtytxp_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_userclk_tx_reset_int;
  logic [0:0] hb0_gtwiz_userclk_tx_reset_int;
  assign gtwiz_userclk_tx_reset_int[0:0] = hb0_gtwiz_userclk_tx_reset_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_userclk_tx_srcclk_int;
  logic [0:0] hb0_gtwiz_userclk_tx_srcclk_int;
  assign hb0_gtwiz_userclk_tx_srcclk_int = gtwiz_userclk_tx_srcclk_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_userclk_tx_usrclk_int;
  logic [0:0] hb0_gtwiz_userclk_tx_usrclk_int;
  assign hb0_gtwiz_userclk_tx_usrclk_int = gtwiz_userclk_tx_usrclk_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_userclk_tx_usrclk2_int;
  logic [0:0] hb0_gtwiz_userclk_tx_usrclk2_int;
  assign hb0_gtwiz_userclk_tx_usrclk2_int = gtwiz_userclk_tx_usrclk2_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_userclk_tx_active_int;
  logic [0:0] hb0_gtwiz_userclk_tx_active_int;
  assign hb0_gtwiz_userclk_tx_active_int = gtwiz_userclk_tx_active_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_userclk_rx_reset_int;
  logic [0:0] hb0_gtwiz_userclk_rx_reset_int;
  assign gtwiz_userclk_rx_reset_int[0:0] = hb0_gtwiz_userclk_rx_reset_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_userclk_rx_srcclk_int;
  logic [0:0] hb0_gtwiz_userclk_rx_srcclk_int;
  assign hb0_gtwiz_userclk_rx_srcclk_int = gtwiz_userclk_rx_srcclk_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_userclk_rx_usrclk_int;
  logic [0:0] hb0_gtwiz_userclk_rx_usrclk_int;
  assign hb0_gtwiz_userclk_rx_usrclk_int = gtwiz_userclk_rx_usrclk_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_userclk_rx_usrclk2_int;
  logic [0:0] hb0_gtwiz_userclk_rx_usrclk2_int;
  assign hb0_gtwiz_userclk_rx_usrclk2_int = gtwiz_userclk_rx_usrclk2_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_userclk_rx_active_int;
  logic [0:0] hb0_gtwiz_userclk_rx_active_int;
  assign hb0_gtwiz_userclk_rx_active_int = gtwiz_userclk_rx_active_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_reset_clk_freerun_int;
  logic [0:0] hb0_gtwiz_reset_clk_freerun_int = 1'b0;
  assign gtwiz_reset_clk_freerun_int[0:0] = hb0_gtwiz_reset_clk_freerun_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_reset_all_int;
  logic [0:0] hb0_gtwiz_reset_all_int = 1'b0;
  assign gtwiz_reset_all_int[0:0] = hb0_gtwiz_reset_all_int;


  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_reset_rx_pll_and_datapath_int;
  logic [0:0] hb0_gtwiz_reset_rx_pll_and_datapath_int = 1'b0;
  assign gtwiz_reset_rx_pll_and_datapath_int[0:0] = hb0_gtwiz_reset_rx_pll_and_datapath_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_reset_rx_datapath_int;
  logic [0:0] hb0_gtwiz_reset_rx_datapath_int = 1'b0;
  assign gtwiz_reset_rx_datapath_int[0:0] = hb0_gtwiz_reset_rx_datapath_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_reset_rx_cdr_stable_int;
  logic [0:0] hb0_gtwiz_reset_rx_cdr_stable_int;
  assign hb0_gtwiz_reset_rx_cdr_stable_int = gtwiz_reset_rx_cdr_stable_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_reset_tx_done_int;
  logic [0:0] hb0_gtwiz_reset_tx_done_int;
  assign hb0_gtwiz_reset_tx_done_int = gtwiz_reset_tx_done_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtwiz_reset_rx_done_int;
  logic [0:0] hb0_gtwiz_reset_rx_done_int;
  assign hb0_gtwiz_reset_rx_done_int = gtwiz_reset_rx_done_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [31:0] gtwiz_userdata_tx_int;
  logic [31:0] hb0_gtwiz_userdata_tx_int;
  assign gtwiz_userdata_tx_int[31:0] = hb0_gtwiz_userdata_tx_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [31:0] gtwiz_userdata_rx_int;
  logic [31:0] hb0_gtwiz_userdata_rx_int;
  assign hb0_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int[31:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtrefclk00_int;
  logic [0:0] cm0_gtrefclk00_int;
  assign gtrefclk00_int[0:0] = cm0_gtrefclk00_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] qpll0outclk_int;
  logic [0:0] cm0_qpll0outclk_int;
  assign cm0_qpll0outclk_int = qpll0outclk_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] qpll0outrefclk_int;
  logic [0:0] cm0_qpll0outrefclk_int;
  assign cm0_qpll0outrefclk_int = qpll0outrefclk_int[0:0];


  logic [0:0] rx8b10ben_int;
  logic [0:0] ch0_rx8b10ben_int = 1'b1;
  assign rx8b10ben_int[0:0] = ch0_rx8b10ben_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] rxbufreset_int;
  logic [0:0] ch0_rxbufreset_int = 1'b0;
  assign rxbufreset_int[0:0] = ch0_rxbufreset_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] rxcommadeten_int;
  logic [0:0] ch0_rxcommadeten_int = 1'b1;
  assign rxcommadeten_int[0:0] = ch0_rxcommadeten_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] rxmcommaalignen_int;
  logic [0:0] ch0_rxmcommaalignen_int = 1'b1;
  assign rxmcommaalignen_int[0:0] = ch0_rxmcommaalignen_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] rxpcommaalignen_int;
  logic [0:0] ch0_rxpcommaalignen_int = 1'b1;
  assign rxpcommaalignen_int[0:0] = ch0_rxpcommaalignen_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] tx8b10ben_int;
  logic [0:0] ch0_tx8b10ben_int = 1'b1;
  assign tx8b10ben_int[0:0] = ch0_tx8b10ben_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [15:0] txctrl0_int;
  logic [15:0] ch0_txctrl0_int;
  assign txctrl0_int[15:0] = ch0_txctrl0_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [15:0] txctrl1_int;
  logic [15:0] ch0_txctrl1_int;
  assign txctrl1_int[15:0] = ch0_txctrl1_int;

  //--------------------------------------------------------------------------------------------------------------------
  logic [7:0] txctrl2_int;
  logic [7:0] ch0_txctrl2_int;
  assign txctrl2_int[7:0] = ch0_txctrl2_int;

  //--------------------------------------------------------------------------------------------------------------------



  //--------------------------------------------------------------------------------------------------------------------
  


  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] gtpowergood_int;
  logic [0:0] ch0_gtpowergood_int;
  assign ch0_gtpowergood_int = gtpowergood_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [2:0] rxbufstatus_int;
  logic [2:0] ch0_rxbufstatus_int;
  assign ch0_rxbufstatus_int = rxbufstatus_int[2:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] rxbyteisaligned_int;
  logic [0:0] ch0_rxbyteisaligned_int;
  assign ch0_rxbyteisaligned_int = rxbyteisaligned_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] rxbyterealign_int;
  logic [0:0] ch0_rxbyterealign_int;
  assign ch0_rxbyterealign_int = rxbyterealign_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [1:0] rxclkcorcnt_int;
  logic [1:0] ch0_rxclkcorcnt_int;
  assign ch0_rxclkcorcnt_int = rxclkcorcnt_int[1:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] rxcommadet_int;
  logic [0:0] ch0_rxcommadet_int;
  assign ch0_rxcommadet_int = rxcommadet_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [15:0] rxctrl0_int;
  logic [15:0] ch0_rxctrl0_int;
  assign ch0_rxctrl0_int = rxctrl0_int[15:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [15:0] rxctrl1_int;
  logic [15:0] ch0_rxctrl1_int;
  assign ch0_rxctrl1_int = rxctrl1_int[15:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [7:0] rxctrl2_int;
  logic [7:0] ch0_rxctrl2_int;
  assign ch0_rxctrl2_int = rxctrl2_int[7:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [7:0] rxctrl3_int;
  logic [7:0] ch0_rxctrl3_int;
  assign ch0_rxctrl3_int = rxctrl3_int[7:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] rxpmaresetdone_int;
  logic [0:0] ch0_rxpmaresetdone_int;
  assign ch0_rxpmaresetdone_int = rxpmaresetdone_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  logic [0:0] txpmaresetdone_int;
  logic [0:0] ch0_txpmaresetdone_int;
  assign ch0_txpmaresetdone_int = txpmaresetdone_int[0:0];


  // ===================================================================================================================
  // BUFFERS
  // ===================================================================================================================

  // Buffer the hb_gtwiz_reset_all_in input and logically combine it with the internal signal from the example
  // initialization block as well as the VIO-sourced reset
  logic hb_gtwiz_reset_all_buf_int;
  logic hb_gtwiz_reset_all_init_int;
  logic hb_gtwiz_reset_all_int;
  logic hb_gtwiz_reset_all_in;

  assign hb_gtwiz_reset_all_in = ~hb_gtwiz_resetn_all_in;
  
  IBUF ibuf_hb_gtwiz_reset_all_inst (
    .I (hb_gtwiz_reset_all_in),
    .O (hb_gtwiz_reset_all_buf_int)
  );

  assign hb_gtwiz_reset_all_int = hb_gtwiz_reset_all_buf_int || hb_gtwiz_reset_all_init_int ;

  // Globally buffer the free-running input clock
  logic hb_gtwiz_reset_clk_freerun_buf_int;
  logic hb_gtwiz_reset_clk_freerun_in;
  
  IBUFGDS clk_freerun_in_inst (
    .I  (gtwiz_reset_clk_freerun_in_p),
    .IB (gtwiz_reset_clk_freerun_in_n),
    .O  (hb_gtwiz_reset_clk_freerun_in)
  );

  BUFG bufg_clk_freerun_inst (
    .I (hb_gtwiz_reset_clk_freerun_in),
    .O (hb_gtwiz_reset_clk_freerun_buf_int)
  );

  // Instantiate a differential reference clock buffer for each reference clock differential pair in this configuration,
  // and assign the single-ended output of each differential reference clock buffer to the appropriate PLL input signal

  // Differential reference clock buffer for MGTREFCLK0_X0Y1
  logic mgtrefclk0_x0y1_int;

  IBUFDS_GTE4 #(
    .REFCLK_EN_TX_PATH  (1'b0),
    .REFCLK_HROW_CK_SEL (2'b00),
    .REFCLK_ICNTL_RX    (2'b00)
  ) IBUFDS_GTE4_MGTREFCLK0_X0Y1_INST (
    .I     (mgtrefclk0_p),
    .IB    (mgtrefclk0_n),
    .CEB   (1'b0),
    .O     (mgtrefclk0_x0y1_int),
    .ODIV2 ()
  );

  assign cm0_gtrefclk00_int = mgtrefclk0_x0y1_int;


  // ===================================================================================================================
  // USER CLOCKING RESETS
  // ===================================================================================================================

  // The TX user clocking helper block should be held in reset until the clock source of that block is known to be
  // stable. The following assignment is an example of how that stability can be determined, based on the selected TX
  // user clock source. Replace the assignment with the appropriate signal or logic to achieve that behavior as needed.
  assign hb0_gtwiz_userclk_tx_reset_int = ~(&txpmaresetdone_int);

  // The RX user clocking helper block should be held in reset until the clock source of that block is known to be
  // stable. The following assignment is an example of how that stability can be determined, based on the selected RX
  // user clock source. Replace the assignment with the appropriate signal or logic to achieve that behavior as needed.
  assign hb0_gtwiz_userclk_rx_reset_int = ~(&rxpmaresetdone_int);


  // ===================================================================================================================
  // PRBS STIMULUS, CHECKING, AND LINK MANAGEMENT
  // ===================================================================================================================

  // PRBS stimulus
  // -------------------------------------------------------------------------------------------------------------------

  // PRBS-based data stimulus module for transceiver channel 0
  (* DONT_TOUCH = "TRUE" *)
  gtwizard_ultrascale_0_example_stimulus_8b10b example_stimulus_inst0 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int || ~hb0_gtwiz_reset_rx_done_int ),
    .gtwiz_userclk_tx_usrclk2_in (hb0_gtwiz_userclk_tx_usrclk2_int),
    .gtwiz_userclk_tx_active_in  (hb0_gtwiz_userclk_tx_active_int),
    .txctrl0_out                 (ch0_txctrl0_int),
    .txctrl1_out                 (ch0_txctrl1_int),
    .txctrl2_out                 (ch0_txctrl2_int),
    .txdata_out                  (hb0_gtwiz_userdata_tx_int)
  );

  // PRBS checking
  // -------------------------------------------------------------------------------------------------------------------

  // Declare a signal vector of PRBS match indicators, with one indicator bit per transceiver channel
  logic [0:0] prbs_match_int;

  // PRBS-based data checking module for transceiver channel 0
  gtwizard_ultrascale_0_example_checking_8b10b example_checking_inst0 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int || ~hb0_gtwiz_reset_rx_done_int ),
    .gtwiz_userclk_rx_usrclk2_in (hb0_gtwiz_userclk_rx_usrclk2_int),
    .gtwiz_userclk_rx_active_in  (hb0_gtwiz_userclk_rx_active_int),
    .rxctrl0_in                  (ch0_rxctrl0_int),
    .rxctrl1_in                  (ch0_rxctrl1_int),
    .rxctrl2_in                  (ch0_rxctrl2_int),
    .rxctrl3_in                  (ch0_rxctrl3_int),
    .rxdata_in                   (hb0_gtwiz_userdata_rx_int),
    .prbs_match_out              (prbs_match_int[0])
  );

  // PRBS match and related link management
  // -------------------------------------------------------------------------------------------------------------------

  // Perform a bitwise NAND of all PRBS match indicators, creating a combinatorial indication of any PRBS mismatch
  // across all transceiver channels
  assign prbs_error_any_async = ~(&prbs_match_int);
  logic prbs_error_any_sync;

  // Synchronize the PRBS mismatch indicator the free-running clock domain, using a reset synchronizer with asynchronous
  // reset and synchronous removal
  (* DONT_TOUCH = "TRUE" *)
  gtwizard_ultrascale_0_example_reset_synchronizer reset_synchronizer_prbs_match_all_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .rst_in (prbs_error_any_async),
    .rst_out(prbs_error_any_sync)
  );

  // Implement an example link status state machine using a simple leaky bucket mechanism. The link status indicates
  // the continual PRBS match status to both the top-level observer and the initialization state machine, while being
  // tolerant of occasional bit errors. This is an example and can be modified as necessary.
  localparam ST_LINK_DOWN = 1'b0;
  localparam ST_LINK_UP   = 1'b1;
  reg        sm_link      = ST_LINK_DOWN;
  reg [6:0]  link_ctr     = 7'd0;

  always @(posedge hb_gtwiz_reset_clk_freerun_buf_int) begin
    case (sm_link)
      // The link is considered to be down when the link counter initially has a value less than 67. When the link is
      // down, the counter is incremented on each cycle where all PRBS bits match, but reset whenever any PRBS mismatch
      // occurs. When the link counter reaches 67, transition to the link up state.
      ST_LINK_DOWN: begin
        if (prbs_error_any_sync !== 1'b0) begin
          link_ctr <= 7'd0;
        end
        else begin
          if (link_ctr < 7'd67)
            link_ctr <= link_ctr + 7'd1;
          else
            sm_link <= ST_LINK_UP;
        end
      end

      // When the link is up, the link counter is decreased by 34 whenever any PRBS mismatch occurs, but is increased by
      // only 1 on each cycle where all PRBS bits match, up to its saturation point of 67. If the link counter reaches
      // 0 (including rollover protection), transition to the link down state.
      ST_LINK_UP: begin
        if (prbs_error_any_sync !== 1'b0) begin
          if (link_ctr > 7'd33) begin
            link_ctr <= link_ctr - 7'd34;
            if (link_ctr == 7'd34)
              sm_link  <= ST_LINK_DOWN;
          end
          else begin
            link_ctr <= 7'd0;
            sm_link  <= ST_LINK_DOWN;
          end
        end
        else begin
          if (link_ctr < 7'd67)
            link_ctr <= link_ctr + 7'd1;
        end
      end
    endcase
  end


  // Assign the link status indicator to the top-level two-state output for user reference
  assign link_status_out = sm_link;


  // ===================================================================================================================
  // INITIALIZATION
  // ===================================================================================================================

  // Declare the receiver reset signals that interface to the reset controller helper block. For this configuration,
  // which uses the same PLL type for transmitter and receiver, the "reset RX PLL and datapath" feature is not used.
  logic hb_gtwiz_reset_rx_pll_and_datapath_int = 1'b0;
  logic hb_gtwiz_reset_rx_datapath_int;

  // Declare signals which connect the VIO instance to the initialization module for debug purposes
  logic       init_done_int;
  logic [3:0] init_retry_ctr_int;

  // Combine the receiver reset signals form the initialization module and the VIO to drive the appropriate reset
  // controller helper block reset input

  logic hb_gtwiz_reset_rx_datapath_init_int;

  assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath_init_int ;

  // The example initialization module interacts with the reset controller helper block and other example design logic
  // to retry failed reset attempts in order to mitigate bring-up issues such as initially-unavilable reference clocks
  // or data connections. It also resets the receiver in the event of link loss in an attempt to regain link, so please
  // note the possibility that this behavior can have the effect of overriding or disturbing user-provided inputs that
  // destabilize the data stream. It is a demonstration only and can be modified to suit your system needs.
  gtwizard_ultrascale_0_example_init example_init_inst (
    .clk_freerun_in  (hb_gtwiz_reset_clk_freerun_buf_int),
    .reset_all_in    (hb_gtwiz_reset_all_int),
    .tx_init_done_in (gtwiz_reset_tx_done_int),
    .rx_init_done_in (gtwiz_reset_rx_done_int),
    .rx_data_good_in (sm_link),
    .reset_all_out   (hb_gtwiz_reset_all_init_int),
    .reset_rx_out    (hb_gtwiz_reset_rx_datapath_init_int),
    .init_done_out   (init_done_int),
    .retry_ctr_out   (init_retry_ctr_int)
  );




  //====================================================================================================================
  
  // ===================================================================================================================
  // EXAMPLE WRAPPER INSTANCE
  // ===================================================================================================================

  // Instantiate the example design wrapper, mapping its enabled ports to per-channel internal signals and example
  // resources as appropriate
  gtwizard_ultrascale_0_example_wrapper example_wrapper_inst (
    .gtyrxn_in                               (gtyrxn_int)
   ,.gtyrxp_in                               (gtyrxp_int)
   ,.gtytxn_out                              (gtytxn_int)
   ,.gtytxp_out                              (gtytxp_int)
   ,.gtwiz_userclk_tx_reset_in               (gtwiz_userclk_tx_reset_int)
   ,.gtwiz_userclk_tx_srcclk_out             (gtwiz_userclk_tx_srcclk_int)
   ,.gtwiz_userclk_tx_usrclk_out             (gtwiz_userclk_tx_usrclk_int)
   ,.gtwiz_userclk_tx_usrclk2_out            (gtwiz_userclk_tx_usrclk2_int)
   ,.gtwiz_userclk_tx_active_out             (gtwiz_userclk_tx_active_int)
   ,.gtwiz_userclk_rx_reset_in               (gtwiz_userclk_rx_reset_int)
   ,.gtwiz_userclk_rx_srcclk_out             (gtwiz_userclk_rx_srcclk_int)
   ,.gtwiz_userclk_rx_usrclk_out             (gtwiz_userclk_rx_usrclk_int)
   ,.gtwiz_userclk_rx_usrclk2_out            (gtwiz_userclk_rx_usrclk2_int)
   ,.gtwiz_userclk_rx_active_out             (gtwiz_userclk_rx_active_int)
   ,.gtwiz_reset_clk_freerun_in              ({1{hb_gtwiz_reset_clk_freerun_buf_int}})
   ,.gtwiz_reset_all_in                      ({1{hb_gtwiz_reset_all_int}})
   ,.gtwiz_reset_tx_pll_and_datapath_in      (1'b0)
   ,.gtwiz_reset_tx_datapath_in              (hb_gtwiz_reset_all_int)
   ,.gtwiz_reset_rx_pll_and_datapath_in      ({1{hb_gtwiz_reset_rx_pll_and_datapath_int}})
   ,.gtwiz_reset_rx_datapath_in              ({1{hb_gtwiz_reset_rx_datapath_int}})
   ,.gtwiz_reset_rx_cdr_stable_out           (gtwiz_reset_rx_cdr_stable_int)
   ,.gtwiz_reset_tx_done_out                 (gtwiz_reset_tx_done_int)
   ,.gtwiz_reset_rx_done_out                 (gtwiz_reset_rx_done_int)
   ,.gtwiz_userdata_tx_in                    (gtwiz_userdata_tx_int)
   ,.gtwiz_userdata_rx_out                   (gtwiz_userdata_rx_int)
   ,.gtrefclk00_in                           (gtrefclk00_int)
   ,.qpll0lock_out                           (qpll0lock_out)
   ,.qpll0outclk_out                         (qpll0outclk_int)
   ,.qpll0outrefclk_out                      (qpll0outrefclk_int)
   ,.drpaddr_in                              (drpaddr_int)
   ,.drpclk_in                               (hb_gtwiz_reset_clk_freerun_buf_int)
   ,.drpdi_in                                (drpdi_int)
   ,.drpen_in                                (drpen_int)
   ,.drpwe_in                                (drpwe_int)
   ,.eyescanreset_in                         (eyescanreset_int)
   ,.rx8b10ben_in                            (rx8b10ben_int)
   ,.rxbufreset_in                           (rxbufreset_int)
   ,.rxcommadeten_in                         (rxcommadeten_int)
   ,.rxlpmen_in                              (1'b1) 
   ,.rxmcommaalignen_in                      (rxmcommaalignen_int)
   ,.rxpcommaalignen_in                      (rxpcommaalignen_int)
   ,.rxprbssel_in                            (rxprbssel_int)
   ,.rxrate_in                               (3'b000) 
   ,.tx8b10ben_in                            (tx8b10ben_int)
   ,.txctrl0_in                              (txctrl0_int)
   ,.txctrl1_in                              (txctrl1_int)
   ,.txctrl2_in                              (txctrl2_int)
   ,.txdiffctrl_in                           (txdiffctrl_int)  
   ,.txmaincursor_in                         (txmaincursor_in)
   ,.txpostcursor_in                         (txpostcursor_int) 
   ,.txprbssel_in                            (txprbssel_int)
   ,.txprecursor_in                          (txprecursor_int) 
   ,.drpdo_out                               (drpdo_int)
   ,.drprdy_out                              (drprdy_int)
   ,.gtpowergood_out                         (gtpowergood_int)
   ,.rxbufstatus_out                         (rxbufstatus_int)
   ,.rxbyteisaligned_out                     (rxbyteisaligned_int)
   ,.rxbyterealign_out                       (rxbyterealign_int)
   ,.rxclkcorcnt_out                         (rxclkcorcnt_int)
   ,.rxcommadet_out                          (rxcommadet_int)
   ,.rxctrl0_out                             (rxctrl0_int)
   ,.rxctrl1_out                             (rxctrl1_int)
   ,.rxctrl2_out                             (rxctrl2_int)
   ,.rxctrl3_out                             (rxctrl3_int)
   ,.rxpmaresetdone_out                      (rxpmaresetdone_int)
   ,.txpmaresetdone_out                      (txpmaresetdone_int)
);


endmodule
