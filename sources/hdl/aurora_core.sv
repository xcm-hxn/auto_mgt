module aurora_core #(

)(
     input      logic           aurora_rxp
    ,input      logic           aurora_rxn
    ,output     logic           aurora_txp
    ,output     logic           aurora_txn
    ,input      logic           aurora_refclkp
    ,input      logic           aurora_refclkn

    ,input      logic           aurora_reset_pb
    ,input      logic           aurora_pma_init
    ,input      logic           aurora_init_clk

    ,output     logic           aurora_channel_up
    ,output     logic           aurora_lane_up
    ,output     logic           aurora_gt_pll_lock

    ,output     logic           aurora_userclk

    ,input      logic   [63:0]  s_axis_aurora_tdata
    ,input      logic           s_axis_aurora_tvalid
    ,output     logic           s_axis_aurora_tready

    ,output     logic   [63:0]  m_axis_aurora_tdata
    ,output     logic           m_axis_aurora_tvalid

    ,input      logic           s_axis_aurora_nfc_tvalid
    ,input      logic   [15:0]  s_axis_aurora_nfc_tdata
    ,output     logic           s_axis_aurora_nfc_tready

    
);

    logic           aurora_gt_rxcdrovrden_in    ;
    logic   [2:0]   aurora_loopback             ;
    logic           aurora_power_down           ;
    logic           aurora_hard_err             ;
    logic           aurora_soft_err             ;
    logic           aurora_mmcm_not_locked_out  ;
    logic           aurora_gt_powergood         ;
    logic           aurora_tx_out_clk           ;
    logic           aurora_user_clk_out         ;
    logic           aurora_sync_clk_out         ;
    logic           aurora_gt_refclk1_out       ;
    logic           aurora_link_reset_out       ;
    logic           aurora_sys_reset_out        ;
    logic           aurora_gt_reset_out         ;

    assign aurora_gt_rxcdrovrden_in = 0;
    assign aurora_loopback          = 0;
    assign aurora_power_down        = 0;
    assign aurora_userclk           = aurora_user_clk_out;


    aurora_link aurora_link_inst (
        // PHY layer
         .gt_refclk1_p              (aurora_refclkp             )
        ,.gt_refclk1_n              (aurora_refclkn             )
        ,.rxp                       (aurora_rxp                 )
        ,.rxn                       (aurora_rxn                 )
        ,.txp                       (aurora_txp                 )
        ,.txn                       (aurora_txn                 )
        // Initialization and reset
        ,.init_clk                  (aurora_init_clk            )  // input wire init_clk
        ,.reset_pb                  (aurora_reset_pb            )  // input wire reset_pb
        ,.pma_init                  (aurora_pma_init            )  // Resets PMA and PCS layer.
        // Core control
        ,.gt_rxcdrovrden_in         (aurora_gt_rxcdrovrden_in   )  // input wire gt_rxcdrovrden_in
        ,.loopback                  (aurora_loopback            )  // input wire [2 : 0] loopback
        ,.power_down                (aurora_power_down          )  // input wire power_down
        // Core status
        ,.hard_err                  (aurora_hard_err            )  // output wire hard_err
        ,.soft_err                  (aurora_soft_err            )  // output wire soft_err
        ,.channel_up                (aurora_channel_up          )  // output wire channel_up
        ,.lane_up                   (aurora_lane_up             )  // output wire [0 : 0] lane_up
        ,.gt_pll_lock               (aurora_gt_pll_lock         )  // output wire gt_pll_lock
        ,.mmcm_not_locked_out       (aurora_mmcm_not_locked_out )  // output wire mmcm_not_locked_out
        ,.gt_powergood              (aurora_gt_powergood        )  // output wire [0 : 0] gt_powergood
        // Clock and reset ouput
        ,.tx_out_clk                (aurora_tx_out_clk          )  // txoutclk
        ,.user_clk_out              (aurora_user_clk_out        )  // txusrclk2
        ,.sync_clk_out              (aurora_sync_clk_out        )  // txusrclk
        ,.gt_refclk1_out            (aurora_gt_refclk1_out      )  // reference clock
        ,.link_reset_out            (aurora_link_reset_out      )  // Driven High if hot-plug count expires.
        ,.sys_reset_out             (aurora_sys_reset_out       )  // Running at user_clk_out domain.
        ,.gt_reset_out              (aurora_gt_reset_out        )  // Output of de-bouncer for gt_reset.
        // AXI stream data IO
        ,.s_axi_tx_tdata            (s_axis_aurora_tdata        )  // input wire [0 : 63] s_axi_tx_tdata
        ,.s_axi_tx_tvalid           (s_axis_aurora_tvalid       )  // input wire s_axi_tx_tvalid
        ,.s_axi_tx_tready           (s_axis_aurora_tready       )  // output wire s_axi_tx_tready

        ,.m_axi_rx_tdata            (m_axis_aurora_tdata        )  // output wire [0 : 63] m_axi_rx_tdata
        ,.m_axi_rx_tvalid           (m_axis_aurora_tvalid       )  // output wire m_axi_rx_tvalid
        // AXI stream NFC
        ,.s_axi_nfc_tvalid          (s_axis_aurora_nfc_tvalid   )  // input wire s_axi_nfc_tvalid
        ,.s_axi_nfc_tdata           (s_axis_aurora_nfc_tdata    )  // input wire [0 : 15] s_axi_nfc_tdata
        ,.s_axi_nfc_tready          (s_axis_aurora_nfc_tready   )  // output wire s_axi_nfc_tready
    );


endmodule