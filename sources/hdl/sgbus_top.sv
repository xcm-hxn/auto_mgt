`include "sgbus_defines.svh"

module sgbus_top #(
     parameter  int     AuroraStreamWidth   = 64     
    ,parameter  int     AuroraNFCWidth      = 16     
    ,parameter  int     SgbusPayloadWidth   = 128    
    ,parameter  int     StreamScaleWidth    = 64        // This parameter is used for stream scaling.
    ,parameter  int     AXILiteDataWidth    = 128    
    ,parameter  int     AXILiteAddrWidth    = 128      
)(
     input      logic   sgbus_clkp
    ,input      logic   sgbus_clkn
    ,input      logic   sgbus_rst_n                     // TODO : Remove this reset and related function in future release.

    ,input      logic   aurora_refclkp
    ,input      logic   aurora_refclkn
    ,input      logic   aurora_rxp
    ,input      logic   aurora_rxn
    ,output     logic   aurora_txp
    ,output     logic   aurora_txn,


    // Differential reference clock inputs
    input  logic quad220_clk_p,
    input  logic quad220_clk_n,
    input  logic quad221_clk_p,
    input  logic quad221_clk_n,
    input  logic quad222_clk_p,
    input  logic quad222_clk_n,
    input  logic quad225_clk_p,
    input  logic quad225_clk_n,
    input  logic quad226_clk_p,
    input  logic quad226_clk_n,
    input  logic quad227_clk_p,
    input  logic quad227_clk_n,
    input  logic quad230_clk_p,
    input  logic quad230_clk_n,
    input  logic quad231_clk_p,
    input  logic quad231_clk_n,
    input  logic quad235_clk_p,
    input  logic quad235_clk_n,
    input  logic quad236_clk_p,
    input  logic quad236_clk_n,
    input  logic quad237_clk_p,
    input  logic quad237_clk_n,



    // Serial data ports for transceiver channel 0
    input  logic quad220_ch0_gtyrxn_in,
    input  logic quad220_ch0_gtyrxp_in,
    output logic quad220_ch0_gtytxn_out,
    output logic quad220_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 1
    input  logic quad220_ch1_gtyrxn_in,
    input  logic quad220_ch1_gtyrxp_in,
    output logic quad220_ch1_gtytxn_out,
    output logic quad220_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 2
    input  logic quad220_ch2_gtyrxn_in,
    input  logic quad220_ch2_gtyrxp_in,
    output logic quad220_ch2_gtytxn_out,
    output logic quad220_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 3
    input  logic quad220_ch3_gtyrxn_in,
    input  logic quad220_ch3_gtyrxp_in,
    output logic quad220_ch3_gtytxn_out,
    output logic quad220_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 4
    input  logic quad221_ch0_gtyrxn_in,
    input  logic quad221_ch0_gtyrxp_in,
    output logic quad221_ch0_gtytxn_out,
    output logic quad221_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 5
    input  logic quad221_ch1_gtyrxn_in,
    input  logic quad221_ch1_gtyrxp_in,
    output logic quad221_ch1_gtytxn_out,
    output logic quad221_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 6
    input  logic quad221_ch2_gtyrxn_in,
    input  logic quad221_ch2_gtyrxp_in,
    output logic quad221_ch2_gtytxn_out,
    output logic quad221_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 7
    input  logic quad221_ch3_gtyrxn_in,
    input  logic quad221_ch3_gtyrxp_in,
    output logic quad221_ch3_gtytxn_out,
    output logic quad221_ch3_gtytxp_out,


    // Serial data ports for transceiver channel 8
    input  logic quad222_ch0_gtyrxn_in,
    input  logic quad222_ch0_gtyrxp_in,
    output logic quad222_ch0_gtytxn_out,
    output logic quad222_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 9
    input  logic quad222_ch1_gtyrxn_in,
    input  logic quad222_ch1_gtyrxp_in,
    output logic quad222_ch1_gtytxn_out,
    output logic quad222_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 10
    input  logic quad222_ch2_gtyrxn_in,
    input  logic quad222_ch2_gtyrxp_in,
    output logic quad222_ch2_gtytxn_out,
    output logic quad222_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 11
    input  logic quad222_ch3_gtyrxn_in,
    input  logic quad222_ch3_gtyrxp_in,
    output logic quad222_ch3_gtytxn_out,
    output logic quad222_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 12
    input  logic quad225_ch0_gtyrxn_in,
    input  logic quad225_ch0_gtyrxp_in,
    output logic quad225_ch0_gtytxn_out,
    output logic quad225_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 13
    input  logic quad225_ch1_gtyrxn_in,
    input  logic quad225_ch1_gtyrxp_in,
    output logic quad225_ch1_gtytxn_out,
    output logic quad225_ch1_gtytxp_out,


    // Serial data ports for transceiver channel 14
    input  logic quad225_ch2_gtyrxn_in,
    input  logic quad225_ch2_gtyrxp_in,
    output logic quad225_ch2_gtytxn_out,
    output logic quad225_ch2_gtytxp_out,


    // Serial data ports for transceiver channel 15
    input  logic quad225_ch3_gtyrxn_in,
    input  logic quad225_ch3_gtyrxp_in,
    output logic quad225_ch3_gtytxn_out,
    output logic quad225_ch3_gtytxp_out,


    // Serial data ports for transceiver channel 16
    input  logic quad226_ch0_gtyrxn_in,
    input  logic quad226_ch0_gtyrxp_in,
    output logic quad226_ch0_gtytxn_out,
    output logic quad226_ch0_gtytxp_out,


    // Serial data ports for transceiver channel 17
    input  logic quad226_ch1_gtyrxn_in,
    input  logic quad226_ch1_gtyrxp_in,
    output logic quad226_ch1_gtytxn_out,
    output logic quad226_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 18
    input  logic quad226_ch2_gtyrxn_in,
    input  logic quad226_ch2_gtyrxp_in,
    output logic quad226_ch2_gtytxn_out,
    output logic quad226_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 19
    input  logic quad226_ch3_gtyrxn_in,
    input  logic quad226_ch3_gtyrxp_in,
    output logic quad226_ch3_gtytxn_out,
    output logic quad226_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 20
    input  logic quad227_ch0_gtyrxn_in,
    input  logic quad227_ch0_gtyrxp_in,
    output logic quad227_ch0_gtytxn_out,
    output logic quad227_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 21
    input  logic quad227_ch1_gtyrxn_in,
    input  logic quad227_ch1_gtyrxp_in,
    output logic quad227_ch1_gtytxn_out,
    output logic quad227_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 22
    input  logic quad227_ch2_gtyrxn_in,
    input  logic quad227_ch2_gtyrxp_in,
    output logic quad227_ch2_gtytxn_out,
    output logic quad227_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 23
    input  logic quad227_ch3_gtyrxn_in,
    input  logic quad227_ch3_gtyrxp_in,
    output logic quad227_ch3_gtytxn_out,
    output logic quad227_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 24
    input  logic quad230_ch0_gtyrxn_in,
    input  logic quad230_ch0_gtyrxp_in,
    output logic quad230_ch0_gtytxn_out,
    output logic quad230_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 25
    input  logic quad230_ch1_gtyrxn_in,
    input  logic quad230_ch1_gtyrxp_in,
    output logic quad230_ch1_gtytxn_out,
    output logic quad230_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 26
    input  logic quad230_ch2_gtyrxn_in,
    input  logic quad230_ch2_gtyrxp_in,
    output logic quad230_ch2_gtytxn_out,
    output logic quad230_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 27
    input  logic quad230_ch3_gtyrxn_in,
    input  logic quad230_ch3_gtyrxp_in,
    output logic quad230_ch3_gtytxn_out,
    output logic quad230_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 28
    input  logic quad231_ch0_gtyrxn_in,
    input  logic quad231_ch0_gtyrxp_in,
    output logic quad231_ch0_gtytxn_out,
    output logic quad231_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 29
    input  logic quad231_ch1_gtyrxn_in,
    input  logic quad231_ch1_gtyrxp_in,
    output logic quad231_ch1_gtytxn_out,
    output logic quad231_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 30
    input  logic quad231_ch2_gtyrxn_in,
    input  logic quad231_ch2_gtyrxp_in,
    output logic quad231_ch2_gtytxn_out,
    output logic quad231_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 31
    input  logic quad231_ch3_gtyrxn_in,
    input  logic quad231_ch3_gtyrxp_in,
    output logic quad231_ch3_gtytxn_out,
    output logic quad231_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 32
    input  logic quad235_ch0_gtyrxn_in,
    input  logic quad235_ch0_gtyrxp_in,
    output logic quad235_ch0_gtytxn_out,
    output logic quad235_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 33
    input  logic quad235_ch1_gtyrxn_in,
    input  logic quad235_ch1_gtyrxp_in,
    output logic quad235_ch1_gtytxn_out,
    output logic quad235_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 34
    input  logic quad235_ch2_gtyrxn_in,
    input  logic quad235_ch2_gtyrxp_in,
    output logic quad235_ch2_gtytxn_out,
    output logic quad235_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 35
    input  logic quad235_ch3_gtyrxn_in,
    input  logic quad235_ch3_gtyrxp_in,
    output logic quad235_ch3_gtytxn_out,
    output logic quad235_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 36
    input  logic quad236_ch0_gtyrxn_in,
    input  logic quad236_ch0_gtyrxp_in,
    output logic quad236_ch0_gtytxn_out,
    output logic quad236_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 37
    input  logic quad236_ch1_gtyrxn_in,
    input  logic quad236_ch1_gtyrxp_in,
    output logic quad236_ch1_gtytxn_out,
    output logic quad236_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 38
    input  logic quad236_ch2_gtyrxn_in,
    input  logic quad236_ch2_gtyrxp_in,
    output logic quad236_ch2_gtytxn_out,
    output logic quad236_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 39
    input  logic quad236_ch3_gtyrxn_in,
    input  logic quad236_ch3_gtyrxp_in,
    output logic quad236_ch3_gtytxn_out,
    output logic quad236_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 40
    input  logic quad237_ch0_gtyrxn_in,
    input  logic quad237_ch0_gtyrxp_in,
    output logic quad237_ch0_gtytxn_out,
    output logic quad237_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 41
    input  logic quad237_ch1_gtyrxn_in,
    input  logic quad237_ch1_gtyrxp_in,
    output logic quad237_ch1_gtytxn_out,
    output logic quad237_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 42
    input  logic quad237_ch2_gtyrxn_in,
    input  logic quad237_ch2_gtyrxp_in,
    output logic quad237_ch2_gtytxn_out,
    output logic quad237_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 43
    input  logic quad237_ch3_gtyrxn_in,
    input  logic quad237_ch3_gtyrxp_in,
    output logic quad237_ch3_gtytxn_out,
    output logic quad237_ch3_gtytxp_out,


    // User-provided ports for reset helper block(s)
    input  logic gtwiz_reset_clk_freerun_in_p,
    input  logic gtwiz_reset_clk_freerun_in_n
);

    // Flattened master axi lite interface with Xilinx IP interface definition.
    logic [AXILiteAddrWidth-1:0]    m_axil_aw_addr    ;
    logic                           m_axil_aw_valid   ;
    logic                           m_axil_aw_ready   ;


    logic [AXILiteDataWidth-1:0]    m_axil_w_data     ;
    logic [AXILiteDataWidth/8-1:0]  m_axil_w_strb     ;
    logic                           m_axil_w_valid    ;
    logic                           m_axil_w_ready    ;

    logic [1:0]                     m_axil_b_resp     ;
    logic                           m_axil_b_valid    ;
    logic                           m_axil_b_ready    ;

    logic [AXILiteAddrWidth-1:0]    m_axil_ar_addr    ;
    logic                           m_axil_ar_valid   ;
    logic                           m_axil_ar_ready   ;


    logic [AXILiteDataWidth-1:0]    m_axil_r_data     ;
    logic [1:0]                     m_axil_r_resp     ;
    logic                           m_axil_r_valid    ;
    logic                           m_axil_r_ready    ;

    // Basic data structure(s) for native aurora link.
    typedef     logic   [AuroraStreamWidth - 1 : 0]     aurora_data_t   ;
    typedef     logic   [AuroraNFCWidth - 1 : 0]        aurora_nfc_t    ;

    // Basic data structure(s) for sgbus payload.
    typedef     logic   [SgbusPayloadWidth - 1 : 0]     sgbus_data_t    ;

    // Basic data structure(s) for axi lite.
    typedef     logic   [AXILiteDataWidth - 1 : 0]      axil_data_t     ;
    typedef     logic   [AXILiteAddrWidth - 1 : 0]      axil_addr_t     ;
    typedef     logic   [AXILiteAddrWidth/8- 1 : 0]     axil_strb_t     ;
    
    // AXI-Stream-oriented data structure(s).
    `AXIS_TYPEDEF_ALL(aurora, axis_aurora_req_t, axis_aurora_resp_t, aurora_data_t)
    `AXIS_TYPEDEF_ALL(nfc, axis_nfc_req_t, axis_nfc_resp_t, aurora_nfc_t)
    `AXIS_TYPEDEF_ALL(sgbus, axis_sgbus_req_t, axis_sgbus_resp_t, sgbus_data_t)

    // AXI-Lite-oriented data structure(s).
    `AXIL_TYPEDEF_ALL(cfg, cfg_axil_req_t, cfg_axil_resp_t, axil_data_t, axil_addr_t, axil_strb_t)

    logic                   peri_reset              ;
    // Aurora clock and status signal(s).
    logic                   aurora_userclk          ;
    logic                   aurora_pma_init         ;
    logic                   aurora_reset_pb         ;
    logic                   aurora_init_clk         ;
    logic                   aurora_gt_pll_lock      ;
    logic                   aurora_channel_up       ;
    logic                   aurora_lane_up          ;

    // Scaled sgbus stream data.
    axis_sgbus_req_t        axis_sgbus_rx_req       ;
    axis_sgbus_resp_t       axis_sgbus_rx_resp      ;
    axis_sgbus_req_t        axis_sgbus_tx_req       ;
    axis_sgbus_resp_t       axis_sgbus_tx_resp      ;
    axis_sgbus_resp_t       axis_sgbus_tx_hf_resp   ;   // TODO : Remove.

    // Streams for different engines.
    axis_sgbus_req_t        axil_eng_tx_axis_req    ;
    axis_sgbus_resp_t       axil_eng_tx_axis_resp   ;
    axis_sgbus_req_t        byp_tx_axis_req         ;
    axis_sgbus_resp_t       byp_tx_axis_resp        ;

    axis_sgbus_req_t        axil_eng_rx_axis_req    ;
    axis_sgbus_resp_t       axil_eng_rx_axis_resp   ;
    axis_sgbus_req_t        byp_rx_axis_req         ;
    axis_sgbus_resp_t       byp_rx_axis_resp        ;
    // Engine transaction(s).
    cfg_axil_req_t          m_axil_req              ;
    cfg_axil_resp_t         m_axil_resp             ;

    logic [2:0]                     m_axil_aw_prot  ;
    logic [2:0]                     m_axil_ar_prot  ;

    assign m_axil_aw_addr       = m_axil_req.aw.addr    ;
    assign m_axil_aw_valid      = m_axil_req.aw_valid   ;
    assign m_axil_resp.aw_ready = m_axil_aw_ready       ;
    assign m_axil_aw_prot       = m_axil_req.aw.prot    ;
    assign m_axil_w_data        = m_axil_req.w.data     ;
    assign m_axil_w_strb        = m_axil_req.w.strb     ;
    assign m_axil_w_valid       = m_axil_req.w_valid    ;
    assign m_axil_resp.w_ready  = m_axil_w_ready        ;
    assign m_axil_resp.b.resp   = m_axil_b_resp         ;
    assign m_axil_resp.b_valid  = m_axil_b_valid        ;
    assign m_axil_b_ready       = m_axil_req.b_ready    ;
    assign m_axil_ar_addr       = m_axil_req.ar.addr    ;
    assign m_axil_ar_valid      = m_axil_req.ar_valid   ;
    assign m_axil_resp.ar_ready = m_axil_ar_ready       ;
    assign m_axil_ar_prot       = m_axil_req.ar.prot    ;
    assign m_axil_resp.r.data   = m_axil_r_data         ;
    assign m_axil_resp.r.resp   = m_axil_r_resp         ;
    assign m_axil_resp.r_valid  = m_axil_r_valid        ;
    assign m_axil_r_ready       = m_axil_req.r_ready    ;

    clk_rst_gen #( 
         .AuroraPMAInitTime         (150_0000                   )
        ,.AuroraResetPBTime         (200_0000                   )
        ,.RefClkFrequency           (20                         )
    )clk_rst_gen_inst(  
         .sgbus_clkp                (sgbus_clkp                 )
        ,.sgbus_clkn                (sgbus_clkn                 )
        ,.ex_rst_n                  (sgbus_rst_n                )

        ,.aurora_pma_init           (aurora_pma_init            )
        ,.aurora_reset_pb           (aurora_reset_pb            )
        ,.aurora_init_clk           (aurora_init_clk            )
        ,.aurora_gt_pll_lock        (aurora_gt_pll_lock         )
        ,.aurora_channel_up         (aurora_channel_up          )
        ,.aurora_lane_up            (aurora_lane_up             )

        ,.peri_reset                (peri_reset                 )
    );

    scaled_aurora_core #(
         .axis_aurora_req_t         (axis_aurora_req_t          )
        ,.axis_aurora_resp_t        (axis_aurora_resp_t         )
        ,.axis_aurora_data_t        (aurora_data_t              )

        ,.axis_nfc_req_t            (axis_nfc_req_t             )
        ,.axis_nfc_resp_t           (axis_nfc_resp_t            )
        ,.axis_nfc_data_t           (aurora_nfc_t               )

        ,.axis_sgbus_req_t          (axis_sgbus_req_t           )
        ,.axis_sgbus_resp_t         (axis_sgbus_resp_t          )

        ,.AuroraStreamWidth         (AuroraStreamWidth          )
        ,.SgbusPayloadWidth         (SgbusPayloadWidth          )
        ,.DivisionWidth             (StreamScaleWidth           )
    )scaled_aurora_core_inst(
         .aurora_rxp                (aurora_rxp                 )
        ,.aurora_rxn                (aurora_rxn                 )
        ,.aurora_txp                (aurora_txp                 )
        ,.aurora_txn                (aurora_txn                 )
        ,.aurora_refclkp            (aurora_refclkp             )
        ,.aurora_refclkn            (aurora_refclkn             )

        ,.peri_reset                (peri_reset                 )

        ,.aurora_reset_pb           (aurora_reset_pb            )
        ,.aurora_pma_init           (aurora_pma_init            )
        ,.aurora_init_clk           (aurora_init_clk            )
        ,.aurora_channel_up         (aurora_channel_up          )
        ,.aurora_lane_up            (aurora_lane_up             )
        ,.aurora_gt_pll_lock        (aurora_gt_pll_lock         )
        ,.aurora_userclk            (aurora_userclk             )
        
        ,.axis_sgbus_rx_req         (axis_sgbus_rx_req          )
        ,.axis_sgbus_rx_resp        (axis_sgbus_rx_resp         )
        ,.axis_sgbus_tx_req         (axis_sgbus_tx_req          )
        ,.axis_sgbus_tx_resp        (axis_sgbus_tx_resp         )
        ,.axis_sgbus_tx_hf_resp     (axis_sgbus_tx_hf_resp      )
    );

    sgbus_stream_route #(
         .axis_req_t                (axis_sgbus_req_t           )
        ,.axis_resp_t               (axis_sgbus_resp_t          )
        ,.axis_data_t               (sgbus_data_t               )
        ,.MaxPayload                (4                          )
    )sgbus_stream_route_inst(
         .stream_clk                (aurora_userclk             )
        ,.reset                     (peri_reset                 )

        ,.s_axis_req                (axis_sgbus_rx_req          )
        ,.s_axis_resp               (axis_sgbus_rx_resp         )

        ,.m_axis_req                (axis_sgbus_tx_req          )
        ,.m_axis_resp               (axis_sgbus_tx_resp         )

        ,.m_axil_eng_axis_req       (axil_eng_rx_axis_req       )
        ,.m_axil_eng_axis_resp      (axil_eng_rx_axis_resp      )
        ,.m_byp_axis_req            (byp_rx_axis_req            )
        ,.m_byp_axis_resp           (byp_rx_axis_resp           )

        ,.s_axil_eng_axis_req       (axil_eng_tx_axis_req       )
        ,.s_axil_eng_axis_resp      (axil_eng_tx_axis_resp      )
        ,.s_byp_axis_req            (byp_tx_axis_req            )
        ,.s_byp_axis_resp           (byp_tx_axis_resp           )
    );

    
    axi_lite_engine #(
         .axil_req_t                (cfg_axil_req_t             )
        ,.axil_resp_t               (cfg_axil_resp_t            )

        ,.axil_aw_chnl_t            (cfg_aw_chnl_t              )
        ,.axil_w_chnl_t             (cfg_w_chnl_t               )
        ,.axil_b_chnl_t             (cfg_b_chnl_t               )
        ,.axil_ar_chnl_t            (cfg_ar_chnl_t              )
        ,.axil_r_chnl_t             (cfg_r_chnl_t               )

        ,.axis_req_t                (axis_sgbus_req_t           )
        ,.axis_resp_t               (axis_sgbus_resp_t          )
        ,.axis_data_t               (sgbus_data_t               )

        ,.MaxPayload                (4                          )
    )axi_lite_engine_inst(
         .clk                       (aurora_userclk             )
        ,.reset                     (peri_reset                 )

        ,.s_axis_req                (axil_eng_rx_axis_req       )
        ,.s_axis_resp               (axil_eng_rx_axis_resp      )
        ,.m_axis_req                (axil_eng_tx_axis_req       )
        ,.m_axis_resp               (axil_eng_tx_axis_resp      )

        ,.m_axil_req                (m_axil_req                 )
        ,.m_axil_resp               (m_axil_resp                )
    );

    stream_echo #(
         .axis_req_t                (axis_sgbus_req_t           )
        ,.axis_resp_t               (axis_sgbus_resp_t          )
        ,.axis_data_t               (sgbus_data_t               )

        ,.MaxPayload                (4                          )
    )bypass_stream_engine_inst(
         .clk                       (aurora_userclk             )
        ,.reset                     (peri_reset                 )

        ,.s_axis_req                (byp_rx_axis_req            )
        ,.s_axis_resp               (byp_rx_axis_resp           )

        ,.m_axis_req                (byp_tx_axis_req            )
        ,.m_axis_resp               (byp_tx_axis_resp           )
    );


eyescan  #(
    .AXI_ADDR_WIDTH (32),
    .AXI_DATA_WIDTH (32),
    .QUAD           (11),
    .CHANNEL        (44)
) eyescan_inst (
  .axil_aclk(aurora_userclk),                                   // input wire axil_aclk
  .axil_aresetn(~peri_reset),                                  // input wire axil_aresetn
  .quad220_clk_p(quad220_clk_p),                                // input wire quad220_clk_p
  .quad220_clk_n(quad220_clk_n),                                // input wire quad220_clk_n
  .quad221_clk_p(quad221_clk_p),                                // input wire quad221_clk_p
  .quad221_clk_n(quad221_clk_n),                                // input wire quad221_clk_n
  .quad222_clk_p(quad222_clk_p),                                // input wire quad222_clk_p
  .quad222_clk_n(quad222_clk_n),                                // input wire quad222_clk_n
  .quad225_clk_p(quad225_clk_p),                                // input wire quad225_clk_p
  .quad225_clk_n(quad225_clk_n),                                // input wire quad225_clk_n
  .quad226_clk_p(quad226_clk_p),                                // input wire quad226_clk_p
  .quad226_clk_n(quad226_clk_n),                                // input wire quad226_clk_n
  .quad227_clk_p(quad227_clk_p),                                // input wire quad227_clk_p
  .quad227_clk_n(quad227_clk_n),                                // input wire quad227_clk_n
  .quad230_clk_p(quad230_clk_p),                                // input wire quad230_clk_p
  .quad230_clk_n(quad230_clk_n),                                // input wire quad230_clk_n
  .quad231_clk_p(quad231_clk_p),                                // input wire quad231_clk_p
  .quad231_clk_n(quad231_clk_n),                                // input wire quad231_clk_n
  .quad235_clk_p(quad235_clk_p),                                // input wire quad235_clk_p
  .quad235_clk_n(quad235_clk_n),                                // input wire quad235_clk_n
  .quad236_clk_p(quad236_clk_p),                                // input wire quad236_clk_p
  .quad236_clk_n(quad236_clk_n),                                // input wire quad236_clk_n
  .quad237_clk_p(quad237_clk_p),                                // input wire quad237_clk_p
  .quad237_clk_n(quad237_clk_n),                                // input wire quad237_clk_n
  .quad220_ch0_gtyrxn_in(quad220_ch0_gtyrxn_in),                // input wire quad220_ch0_gtyrxn_in
  .quad220_ch0_gtyrxp_in(quad220_ch0_gtyrxp_in),                // input wire quad220_ch0_gtyrxp_in
  .quad220_ch0_gtytxn_out(quad220_ch0_gtytxn_out),              // output wire quad220_ch0_gtytxn_out
  .quad220_ch0_gtytxp_out(quad220_ch0_gtytxp_out),              // output wire quad220_ch0_gtytxp_out
  .quad220_ch1_gtyrxn_in(quad220_ch1_gtyrxn_in),                // input wire quad220_ch1_gtyrxn_in
  .quad220_ch1_gtyrxp_in(quad220_ch1_gtyrxp_in),                // input wire quad220_ch1_gtyrxp_in
  .quad220_ch1_gtytxn_out(quad220_ch1_gtytxn_out),              // output wire quad220_ch1_gtytxn_out
  .quad220_ch1_gtytxp_out(quad220_ch1_gtytxp_out),              // output wire quad220_ch1_gtytxp_out
  .quad220_ch2_gtyrxn_in(quad220_ch2_gtyrxn_in),                // input wire quad220_ch2_gtyrxn_in
  .quad220_ch2_gtyrxp_in(quad220_ch2_gtyrxp_in),                // input wire quad220_ch2_gtyrxp_in
  .quad220_ch2_gtytxn_out(quad220_ch2_gtytxn_out),              // output wire quad220_ch2_gtytxn_out
  .quad220_ch2_gtytxp_out(quad220_ch2_gtytxp_out),              // output wire quad220_ch2_gtytxp_out
  .quad220_ch3_gtyrxn_in(quad220_ch3_gtyrxn_in),                // input wire quad220_ch3_gtyrxn_in
  .quad220_ch3_gtyrxp_in(quad220_ch3_gtyrxp_in),                // input wire quad220_ch3_gtyrxp_in
  .quad220_ch3_gtytxn_out(quad220_ch3_gtytxn_out),              // output wire quad220_ch3_gtytxn_out
  .quad220_ch3_gtytxp_out(quad220_ch3_gtytxp_out),              // output wire quad220_ch3_gtytxp_out
  .quad221_ch0_gtyrxn_in(quad221_ch0_gtyrxn_in),                // input wire quad221_ch0_gtyrxn_in
  .quad221_ch0_gtyrxp_in(quad221_ch0_gtyrxp_in),                // input wire quad221_ch0_gtyrxp_in
  .quad221_ch0_gtytxn_out(quad221_ch0_gtytxn_out),              // output wire quad221_ch0_gtytxn_out
  .quad221_ch0_gtytxp_out(quad221_ch0_gtytxp_out),              // output wire quad221_ch0_gtytxp_out
  .quad221_ch1_gtyrxn_in(quad221_ch1_gtyrxn_in),                // input wire quad221_ch1_gtyrxn_in
  .quad221_ch1_gtyrxp_in(quad221_ch1_gtyrxp_in),                // input wire quad221_ch1_gtyrxp_in
  .quad221_ch1_gtytxn_out(quad221_ch1_gtytxn_out),              // output wire quad221_ch1_gtytxn_out
  .quad221_ch1_gtytxp_out(quad221_ch1_gtytxp_out),              // output wire quad221_ch1_gtytxp_out
  .quad221_ch2_gtyrxn_in(quad221_ch2_gtyrxn_in),                // input wire quad221_ch2_gtyrxn_in
  .quad221_ch2_gtyrxp_in(quad221_ch2_gtyrxp_in),                // input wire quad221_ch2_gtyrxp_in
  .quad221_ch2_gtytxn_out(quad221_ch2_gtytxn_out),              // output wire quad221_ch2_gtytxn_out
  .quad221_ch2_gtytxp_out(quad221_ch2_gtytxp_out),              // output wire quad221_ch2_gtytxp_out
  .quad221_ch3_gtyrxn_in(quad221_ch3_gtyrxn_in),                // input wire quad221_ch3_gtyrxn_in
  .quad221_ch3_gtyrxp_in(quad221_ch3_gtyrxp_in),                // input wire quad221_ch3_gtyrxp_in
  .quad221_ch3_gtytxn_out(quad221_ch3_gtytxn_out),              // output wire quad221_ch3_gtytxn_out
  .quad221_ch3_gtytxp_out(quad221_ch3_gtytxp_out),              // output wire quad221_ch3_gtytxp_out
  .quad222_ch0_gtyrxn_in(quad222_ch0_gtyrxn_in),                // input wire quad222_ch0_gtyrxn_in
  .quad222_ch0_gtyrxp_in(quad222_ch0_gtyrxp_in),                // input wire quad222_ch0_gtyrxp_in
  .quad222_ch0_gtytxn_out(quad222_ch0_gtytxn_out),              // output wire quad222_ch0_gtytxn_out
  .quad222_ch0_gtytxp_out(quad222_ch0_gtytxp_out),              // output wire quad222_ch0_gtytxp_out
  .quad222_ch1_gtyrxn_in(quad222_ch1_gtyrxn_in),                // input wire quad222_ch1_gtyrxn_in
  .quad222_ch1_gtyrxp_in(quad222_ch1_gtyrxp_in),                // input wire quad222_ch1_gtyrxp_in
  .quad222_ch1_gtytxn_out(quad222_ch1_gtytxn_out),              // output wire quad222_ch1_gtytxn_out
  .quad222_ch1_gtytxp_out(quad222_ch1_gtytxp_out),              // output wire quad222_ch1_gtytxp_out
  .quad222_ch2_gtyrxn_in(quad222_ch2_gtyrxn_in),                // input wire quad222_ch2_gtyrxn_in
  .quad222_ch2_gtyrxp_in(quad222_ch2_gtyrxp_in),                // input wire quad222_ch2_gtyrxp_in
  .quad222_ch2_gtytxn_out(quad222_ch2_gtytxn_out),              // output wire quad222_ch2_gtytxn_out
  .quad222_ch2_gtytxp_out(quad222_ch2_gtytxp_out),              // output wire quad222_ch2_gtytxp_out
  .quad222_ch3_gtyrxn_in(quad222_ch3_gtyrxn_in),                // input wire quad222_ch3_gtyrxn_in
  .quad222_ch3_gtyrxp_in(quad222_ch3_gtyrxp_in),                // input wire quad222_ch3_gtyrxp_in
  .quad222_ch3_gtytxn_out(quad222_ch3_gtytxn_out),              // output wire quad222_ch3_gtytxn_out
  .quad222_ch3_gtytxp_out(quad222_ch3_gtytxp_out),              // output wire quad222_ch3_gtytxp_out
  .quad225_ch0_gtyrxn_in(quad225_ch0_gtyrxn_in),                // input wire quad225_ch0_gtyrxn_in
  .quad225_ch0_gtyrxp_in(quad225_ch0_gtyrxp_in),                // input wire quad225_ch0_gtyrxp_in
  .quad225_ch0_gtytxn_out(quad225_ch0_gtytxn_out),              // output wire quad225_ch0_gtytxn_out
  .quad225_ch0_gtytxp_out(quad225_ch0_gtytxp_out),              // output wire quad225_ch0_gtytxp_out
  .quad225_ch1_gtyrxn_in(quad225_ch1_gtyrxn_in),                // input wire quad225_ch1_gtyrxn_in
  .quad225_ch1_gtyrxp_in(quad225_ch1_gtyrxp_in),                // input wire quad225_ch1_gtyrxp_in
  .quad225_ch1_gtytxn_out(quad225_ch1_gtytxn_out),              // output wire quad225_ch1_gtytxn_out
  .quad225_ch1_gtytxp_out(quad225_ch1_gtytxp_out),              // output wire quad225_ch1_gtytxp_out
  .quad225_ch2_gtyrxn_in(quad225_ch2_gtyrxn_in),                // input wire quad225_ch2_gtyrxn_in
  .quad225_ch2_gtyrxp_in(quad225_ch2_gtyrxp_in),                // input wire quad225_ch2_gtyrxp_in
  .quad225_ch2_gtytxn_out(quad225_ch2_gtytxn_out),              // output wire quad225_ch2_gtytxn_out
  .quad225_ch2_gtytxp_out(quad225_ch2_gtytxp_out),              // output wire quad225_ch2_gtytxp_out
  .quad225_ch3_gtyrxn_in(quad225_ch3_gtyrxn_in),                // input wire quad225_ch3_gtyrxn_in
  .quad225_ch3_gtyrxp_in(quad225_ch3_gtyrxp_in),                // input wire quad225_ch3_gtyrxp_in
  .quad225_ch3_gtytxn_out(quad225_ch3_gtytxn_out),              // output wire quad225_ch3_gtytxn_out
  .quad225_ch3_gtytxp_out(quad225_ch3_gtytxp_out),              // output wire quad225_ch3_gtytxp_out
  .quad226_ch0_gtyrxn_in(quad226_ch0_gtyrxn_in),                // input wire quad226_ch0_gtyrxn_in
  .quad226_ch0_gtyrxp_in(quad226_ch0_gtyrxp_in),                // input wire quad226_ch0_gtyrxp_in
  .quad226_ch0_gtytxn_out(quad226_ch0_gtytxn_out),              // output wire quad226_ch0_gtytxn_out
  .quad226_ch0_gtytxp_out(quad226_ch0_gtytxp_out),              // output wire quad226_ch0_gtytxp_out
  .quad226_ch1_gtyrxn_in(quad226_ch1_gtyrxn_in),                // input wire quad226_ch1_gtyrxn_in
  .quad226_ch1_gtyrxp_in(quad226_ch1_gtyrxp_in),                // input wire quad226_ch1_gtyrxp_in
  .quad226_ch1_gtytxn_out(quad226_ch1_gtytxn_out),              // output wire quad226_ch1_gtytxn_out
  .quad226_ch1_gtytxp_out(quad226_ch1_gtytxp_out),              // output wire quad226_ch1_gtytxp_out
  .quad226_ch2_gtyrxn_in(quad226_ch2_gtyrxn_in),                // input wire quad226_ch2_gtyrxn_in
  .quad226_ch2_gtyrxp_in(quad226_ch2_gtyrxp_in),                // input wire quad226_ch2_gtyrxp_in
  .quad226_ch2_gtytxn_out(quad226_ch2_gtytxn_out),              // output wire quad226_ch2_gtytxn_out
  .quad226_ch2_gtytxp_out(quad226_ch2_gtytxp_out),              // output wire quad226_ch2_gtytxp_out
  .quad226_ch3_gtyrxn_in(quad226_ch3_gtyrxn_in),                // input wire quad226_ch3_gtyrxn_in
  .quad226_ch3_gtyrxp_in(quad226_ch3_gtyrxp_in),                // input wire quad226_ch3_gtyrxp_in
  .quad226_ch3_gtytxn_out(quad226_ch3_gtytxn_out),              // output wire quad226_ch3_gtytxn_out
  .quad226_ch3_gtytxp_out(quad226_ch3_gtytxp_out),              // output wire quad226_ch3_gtytxp_out
  .quad227_ch0_gtyrxn_in(quad227_ch0_gtyrxn_in),                // input wire quad227_ch0_gtyrxn_in
  .quad227_ch0_gtyrxp_in(quad227_ch0_gtyrxp_in),                // input wire quad227_ch0_gtyrxp_in
  .quad227_ch0_gtytxn_out(quad227_ch0_gtytxn_out),              // output wire quad227_ch0_gtytxn_out
  .quad227_ch0_gtytxp_out(quad227_ch0_gtytxp_out),              // output wire quad227_ch0_gtytxp_out
  .quad227_ch1_gtyrxn_in(quad227_ch1_gtyrxn_in),                // input wire quad227_ch1_gtyrxn_in
  .quad227_ch1_gtyrxp_in(quad227_ch1_gtyrxp_in),                // input wire quad227_ch1_gtyrxp_in
  .quad227_ch1_gtytxn_out(quad227_ch1_gtytxn_out),              // output wire quad227_ch1_gtytxn_out
  .quad227_ch1_gtytxp_out(quad227_ch1_gtytxp_out),              // output wire quad227_ch1_gtytxp_out
  .quad227_ch2_gtyrxn_in(quad227_ch2_gtyrxn_in),                // input wire quad227_ch2_gtyrxn_in
  .quad227_ch2_gtyrxp_in(quad227_ch2_gtyrxp_in),                // input wire quad227_ch2_gtyrxp_in
  .quad227_ch2_gtytxn_out(quad227_ch2_gtytxn_out),              // output wire quad227_ch2_gtytxn_out
  .quad227_ch2_gtytxp_out(quad227_ch2_gtytxp_out),              // output wire quad227_ch2_gtytxp_out
  .quad227_ch3_gtyrxn_in(quad227_ch3_gtyrxn_in),                // input wire quad227_ch3_gtyrxn_in
  .quad227_ch3_gtyrxp_in(quad227_ch3_gtyrxp_in),                // input wire quad227_ch3_gtyrxp_in
  .quad227_ch3_gtytxn_out(quad227_ch3_gtytxn_out),              // output wire quad227_ch3_gtytxn_out
  .quad227_ch3_gtytxp_out(quad227_ch3_gtytxp_out),              // output wire quad227_ch3_gtytxp_out
  .quad230_ch0_gtyrxn_in(quad230_ch0_gtyrxn_in),                // input wire quad230_ch0_gtyrxn_in
  .quad230_ch0_gtyrxp_in(quad230_ch0_gtyrxp_in),                // input wire quad230_ch0_gtyrxp_in
  .quad230_ch0_gtytxn_out(quad230_ch0_gtytxn_out),              // output wire quad230_ch0_gtytxn_out
  .quad230_ch0_gtytxp_out(quad230_ch0_gtytxp_out),              // output wire quad230_ch0_gtytxp_out
  .quad230_ch1_gtyrxn_in(quad230_ch1_gtyrxn_in),                // input wire quad230_ch1_gtyrxn_in
  .quad230_ch1_gtyrxp_in(quad230_ch1_gtyrxp_in),                // input wire quad230_ch1_gtyrxp_in
  .quad230_ch1_gtytxn_out(quad230_ch1_gtytxn_out),              // output wire quad230_ch1_gtytxn_out
  .quad230_ch1_gtytxp_out(quad230_ch1_gtytxp_out),              // output wire quad230_ch1_gtytxp_out
  .quad230_ch2_gtyrxn_in(quad230_ch2_gtyrxn_in),                // input wire quad230_ch2_gtyrxn_in
  .quad230_ch2_gtyrxp_in(quad230_ch2_gtyrxp_in),                // input wire quad230_ch2_gtyrxp_in
  .quad230_ch2_gtytxn_out(quad230_ch2_gtytxn_out),              // output wire quad230_ch2_gtytxn_out
  .quad230_ch2_gtytxp_out(quad230_ch2_gtytxp_out),              // output wire quad230_ch2_gtytxp_out
  .quad230_ch3_gtyrxn_in(quad230_ch3_gtyrxn_in),                // input wire quad230_ch3_gtyrxn_in
  .quad230_ch3_gtyrxp_in(quad230_ch3_gtyrxp_in),                // input wire quad230_ch3_gtyrxp_in
  .quad230_ch3_gtytxn_out(quad230_ch3_gtytxn_out),              // output wire quad230_ch3_gtytxn_out
  .quad230_ch3_gtytxp_out(quad230_ch3_gtytxp_out),              // output wire quad230_ch3_gtytxp_out
  .quad231_ch0_gtyrxn_in(quad231_ch0_gtyrxn_in),                // input wire quad231_ch0_gtyrxn_in
  .quad231_ch0_gtyrxp_in(quad231_ch0_gtyrxp_in),                // input wire quad231_ch0_gtyrxp_in
  .quad231_ch0_gtytxn_out(quad231_ch0_gtytxn_out),              // output wire quad231_ch0_gtytxn_out
  .quad231_ch0_gtytxp_out(quad231_ch0_gtytxp_out),              // output wire quad231_ch0_gtytxp_out
  .quad231_ch1_gtyrxn_in(quad231_ch1_gtyrxn_in),                // input wire quad231_ch1_gtyrxn_in
  .quad231_ch1_gtyrxp_in(quad231_ch1_gtyrxp_in),                // input wire quad231_ch1_gtyrxp_in
  .quad231_ch1_gtytxn_out(quad231_ch1_gtytxn_out),              // output wire quad231_ch1_gtytxn_out
  .quad231_ch1_gtytxp_out(quad231_ch1_gtytxp_out),              // output wire quad231_ch1_gtytxp_out
  .quad231_ch2_gtyrxn_in(quad231_ch2_gtyrxn_in),                // input wire quad231_ch2_gtyrxn_in
  .quad231_ch2_gtyrxp_in(quad231_ch2_gtyrxp_in),                // input wire quad231_ch2_gtyrxp_in
  .quad231_ch2_gtytxn_out(quad231_ch2_gtytxn_out),              // output wire quad231_ch2_gtytxn_out
  .quad231_ch2_gtytxp_out(quad231_ch2_gtytxp_out),              // output wire quad231_ch2_gtytxp_out
  .quad231_ch3_gtyrxn_in(quad231_ch3_gtyrxn_in),                // input wire quad231_ch3_gtyrxn_in
  .quad231_ch3_gtyrxp_in(quad231_ch3_gtyrxp_in),                // input wire quad231_ch3_gtyrxp_in
  .quad231_ch3_gtytxn_out(quad231_ch3_gtytxn_out),              // output wire quad231_ch3_gtytxn_out
  .quad231_ch3_gtytxp_out(quad231_ch3_gtytxp_out),              // output wire quad231_ch3_gtytxp_out
  .quad235_ch0_gtyrxn_in(quad235_ch0_gtyrxn_in),                // input wire quad235_ch0_gtyrxn_in
  .quad235_ch0_gtyrxp_in(quad235_ch0_gtyrxp_in),                // input wire quad235_ch0_gtyrxp_in
  .quad235_ch0_gtytxn_out(quad235_ch0_gtytxn_out),              // output wire quad235_ch0_gtytxn_out
  .quad235_ch0_gtytxp_out(quad235_ch0_gtytxp_out),              // output wire quad235_ch0_gtytxp_out
  .quad235_ch1_gtyrxn_in(quad235_ch1_gtyrxn_in),                // input wire quad235_ch1_gtyrxn_in
  .quad235_ch1_gtyrxp_in(quad235_ch1_gtyrxp_in),                // input wire quad235_ch1_gtyrxp_in
  .quad235_ch1_gtytxn_out(quad235_ch1_gtytxn_out),              // output wire quad235_ch1_gtytxn_out
  .quad235_ch1_gtytxp_out(quad235_ch1_gtytxp_out),              // output wire quad235_ch1_gtytxp_out
  .quad235_ch2_gtyrxn_in(quad235_ch2_gtyrxn_in),                // input wire quad235_ch2_gtyrxn_in
  .quad235_ch2_gtyrxp_in(quad235_ch2_gtyrxp_in),                // input wire quad235_ch2_gtyrxp_in
  .quad235_ch2_gtytxn_out(quad235_ch2_gtytxn_out),              // output wire quad235_ch2_gtytxn_out
  .quad235_ch2_gtytxp_out(quad235_ch2_gtytxp_out),              // output wire quad235_ch2_gtytxp_out
  .quad235_ch3_gtyrxn_in(quad235_ch3_gtyrxn_in),                // input wire quad235_ch3_gtyrxn_in
  .quad235_ch3_gtyrxp_in(quad235_ch3_gtyrxp_in),                // input wire quad235_ch3_gtyrxp_in
  .quad235_ch3_gtytxn_out(quad235_ch3_gtytxn_out),              // output wire quad235_ch3_gtytxn_out
  .quad235_ch3_gtytxp_out(quad235_ch3_gtytxp_out),              // output wire quad235_ch3_gtytxp_out
  .quad236_ch0_gtyrxn_in(quad236_ch0_gtyrxn_in),                // input wire quad236_ch0_gtyrxn_in
  .quad236_ch0_gtyrxp_in(quad236_ch0_gtyrxp_in),                // input wire quad236_ch0_gtyrxp_in
  .quad236_ch0_gtytxn_out(quad236_ch0_gtytxn_out),              // output wire quad236_ch0_gtytxn_out
  .quad236_ch0_gtytxp_out(quad236_ch0_gtytxp_out),              // output wire quad236_ch0_gtytxp_out
  .quad236_ch1_gtyrxn_in(quad236_ch1_gtyrxn_in),                // input wire quad236_ch1_gtyrxn_in
  .quad236_ch1_gtyrxp_in(quad236_ch1_gtyrxp_in),                // input wire quad236_ch1_gtyrxp_in
  .quad236_ch1_gtytxn_out(quad236_ch1_gtytxn_out),              // output wire quad236_ch1_gtytxn_out
  .quad236_ch1_gtytxp_out(quad236_ch1_gtytxp_out),              // output wire quad236_ch1_gtytxp_out
  .quad236_ch2_gtyrxn_in(quad236_ch2_gtyrxn_in),                // input wire quad236_ch2_gtyrxn_in
  .quad236_ch2_gtyrxp_in(quad236_ch2_gtyrxp_in),                // input wire quad236_ch2_gtyrxp_in
  .quad236_ch2_gtytxn_out(quad236_ch2_gtytxn_out),              // output wire quad236_ch2_gtytxn_out
  .quad236_ch2_gtytxp_out(quad236_ch2_gtytxp_out),              // output wire quad236_ch2_gtytxp_out
  .quad236_ch3_gtyrxn_in(quad236_ch3_gtyrxn_in),                // input wire quad236_ch3_gtyrxn_in
  .quad236_ch3_gtyrxp_in(quad236_ch3_gtyrxp_in),                // input wire quad236_ch3_gtyrxp_in
  .quad236_ch3_gtytxn_out(quad236_ch3_gtytxn_out),              // output wire quad236_ch3_gtytxn_out
  .quad236_ch3_gtytxp_out(quad236_ch3_gtytxp_out),              // output wire quad236_ch3_gtytxp_out
  .quad237_ch0_gtyrxn_in(quad237_ch0_gtyrxn_in),                // input wire quad237_ch0_gtyrxn_in
  .quad237_ch0_gtyrxp_in(quad237_ch0_gtyrxp_in),                // input wire quad237_ch0_gtyrxp_in
  .quad237_ch0_gtytxn_out(quad237_ch0_gtytxn_out),              // output wire quad237_ch0_gtytxn_out
  .quad237_ch0_gtytxp_out(quad237_ch0_gtytxp_out),              // output wire quad237_ch0_gtytxp_out
  .quad237_ch1_gtyrxn_in(quad237_ch1_gtyrxn_in),                // input wire quad237_ch1_gtyrxn_in
  .quad237_ch1_gtyrxp_in(quad237_ch1_gtyrxp_in),                // input wire quad237_ch1_gtyrxp_in
  .quad237_ch1_gtytxn_out(quad237_ch1_gtytxn_out),              // output wire quad237_ch1_gtytxn_out
  .quad237_ch1_gtytxp_out(quad237_ch1_gtytxp_out),              // output wire quad237_ch1_gtytxp_out
  .quad237_ch2_gtyrxn_in(quad237_ch2_gtyrxn_in),                // input wire quad237_ch2_gtyrxn_in
  .quad237_ch2_gtyrxp_in(quad237_ch2_gtyrxp_in),                // input wire quad237_ch2_gtyrxp_in
  .quad237_ch2_gtytxn_out(quad237_ch2_gtytxn_out),              // output wire quad237_ch2_gtytxn_out
  .quad237_ch2_gtytxp_out(quad237_ch2_gtytxp_out),              // output wire quad237_ch2_gtytxp_out
  .quad237_ch3_gtyrxn_in(quad237_ch3_gtyrxn_in),                // input wire quad237_ch3_gtyrxn_in
  .quad237_ch3_gtyrxp_in(quad237_ch3_gtyrxp_in),                // input wire quad237_ch3_gtyrxp_in
  .quad237_ch3_gtytxn_out(quad237_ch3_gtytxn_out),              // output wire quad237_ch3_gtytxn_out
  .quad237_ch3_gtytxp_out(quad237_ch3_gtytxp_out),              // output wire quad237_ch3_gtytxp_out
  .gtwiz_reset_clk_freerun_in_p(gtwiz_reset_clk_freerun_in_p),  // input wire gtwiz_reset_clk_freerun_in_p
  .gtwiz_reset_clk_freerun_in_n(gtwiz_reset_clk_freerun_in_n),  // input wire gtwiz_reset_clk_freerun_in_n
  .s_axil_aw_addr(m_axil_aw_addr),                              // input wire [31 : 0] s_axil_aw_addr
  .s_axil_aw_valid(m_axil_aw_valid),                            // input wire s_axil_aw_valid
  .s_axil_aw_ready(m_axil_aw_ready),                            // output wire s_axil_aw_ready
  .s_axil_w_data(m_axil_w_data),                                // input wire [31 : 0] s_axil_w_data
  .s_axil_w_strb(m_axil_w_strb),                                // input wire s_axil_w_strb
  .s_axil_w_valid(m_axil_w_valid),                              // input wire s_axil_w_valid
  .s_axil_w_ready(m_axil_w_ready),                              // output wire s_axil_w_ready
  .s_axil_b_resp(m_axil_b_resp),                                // output wire [1 : 0] s_axil_b_resp
  .s_axil_b_valid(m_axil_b_valid),                              // output wire s_axil_b_valid
  .s_axil_b_ready(m_axil_b_ready),                              // input wire s_axil_b_ready
  .s_axil_ar_addr(m_axil_ar_addr),                              // input wire [31 : 0] s_axil_ar_addr
  .s_axil_ar_valid(m_axil_ar_valid),                            // input wire s_axil_ar_valid
  .s_axil_ar_ready(m_axil_ar_ready),                            // output wire s_axil_ar_ready
  .s_axil_r_data(m_axil_r_data),                                // output wire [31 : 0] s_axil_r_data
  .s_axil_r_resp(m_axil_r_resp),                                // output wire s_axil_r_resp
  .s_axil_r_valid(m_axil_r_valid),                              // output wire s_axil_r_valid
  .s_axil_r_ready(m_axil_r_ready)                              // input wire s_axil_r_ready
);
    
endmodule
