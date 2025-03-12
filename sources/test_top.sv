module test_top #(

)(
     input      logic           sgbus_clkp
    ,input      logic           sgbus_clkn

    ,input      logic           ex_rst_n

    ,input      logic           aurora_rxp
    ,input      logic           aurora_rxn
    ,output     logic           aurora_txp
    ,output     logic           aurora_txn

    ,input      logic           aurora_refclkp
    ,input      logic           aurora_refclkn
);

    localparam  AuroraStreamWidth   = 64    ;
    localparam  AuroraNFCWidth      = 16    ;
    localparam  SgbusPayloadWidth   = 128   ;
    localparam  DivisionWidth       = 64    ;
    localparam  AXILiteDataWidth    = 128   ;
    localparam  AXILiteAddrWidth    = 128   ;
    localparam  AXIDataWidth        = 128   ;
    localparam  AXIAddrWidth        = 128   ;
    localparam  AXIIdWidth          = 4     ;

    typedef     logic   [AuroraStreamWidth - 1 : 0]     aurora_data_t   ;
    typedef     logic   [AuroraNFCWidth - 1 : 0]        aurora_nfc_t    ;
    typedef     logic   [SgbusPayloadWidth - 1 : 0]     sgbus_data_t    ;

    typedef     logic   [AXILiteDataWidth - 1 : 0]      axil_data_t     ;
    typedef     logic   [AXILiteAddrWidth - 1 : 0]      axil_addr_t     ;
    typedef     logic   [AXILiteAddrWidth/8- 1 : 0]     axil_strb_t     ;

    typedef     logic   [AXIDataWidth - 1 : 0]          axi_data_t      ;
    typedef     logic   [AXIAddrWidth - 1 : 0]          axi_addr_t      ;
    typedef     logic   [AXIDataWidth/8 - 1 : 0]        axi_strb_t      ;
    typedef     logic   [AXIIdWidth - 1 : 0]            axi_id_t        ;

    `AXIS_TYPEDEF_ALL(aurora, axis_aurora_req_t, axis_aurora_resp_t, aurora_data_t)
    `AXIS_TYPEDEF_ALL(nfc, axis_nfc_req_t, axis_nfc_resp_t, aurora_nfc_t)
    `AXIS_TYPEDEF_ALL(sgbus, axis_sgbus_req_t, axis_sgbus_resp_t, sgbus_data_t)

    `AXIL_TYPEDEF_ALL(test_axil, test_axil_req_t, test_axil_resp_t, axil_data_t, axil_addr_t, axil_strb_t)
    `AXI_TYPEDEF_ALL(test, test_axi_req_t, test_axi_resp_t, axi_data_t, axi_addr_t, axi_strb_t, axi_id_t)

    logic                   aurora_userclk          ;

    logic                   aurora_pma_init         ;
    logic                   aurora_reset_pb         ;
    logic                   aurora_init_clk         ;

    logic                   aurora_gt_pll_lock      ;
    logic                   aurora_channel_up       ;
    logic                   aurora_lane_up          ;

    logic                   peri_reset              ;

    axis_sgbus_req_t        axis_sgbus_rx_req       ;
    axis_sgbus_resp_t       axis_sgbus_rx_resp      ;
    axis_sgbus_req_t        axis_sgbus_tx_req       ;
    axis_sgbus_resp_t       axis_sgbus_tx_resp      ;
    axis_sgbus_resp_t       axis_sgbus_tx_hf_resp   ;

    test_axil_req_t         m_axil_req              ;
    test_axil_resp_t        m_axil_resp             ;
    (* MARK_DEBUG = "TRUE" *)test_axi_req_t          m_axi_req               ;
    (* MARK_DEBUG = "TRUE" *)test_axi_resp_t         m_axi_resp              ;

    clk_rst_gen #(
         .AuroraPMAInitTime         (150_0000                   )    // us
        ,.AuroraResetPBTime         (200_0000                   )    // us
        ,.RefClkFrequency           (20                         )    // MHz
    )clk_rst_gen_inst(  
         .sgbus_clkp                (sgbus_clkp                 )
        ,.sgbus_clkn                (sgbus_clkn                 )
        ,.ex_rst_n                  (ex_rst_n                   )

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
        ,.axis_nfc_req_t            (axis_nfc_req_t             )
        ,.axis_nfc_resp_t           (axis_nfc_resp_t            )
        ,.axis_sgbus_req_t          (axis_sgbus_req_t           )
        ,.axis_sgbus_resp_t         (axis_sgbus_resp_t          )
        ,.AuroraStreamWidth         (AuroraStreamWidth          )
        ,.AuroraNFCWidth            (AuroraNFCWidth             )
        ,.SgbusPayloadWidth         (SgbusPayloadWidth          )
        ,.DivisionWidth             (DivisionWidth              )
    )scaled_aurora_core_inst(
         .aurora_rxp                (aurora_rxp                 )
        ,.aurora_rxn                (aurora_rxn                 )
        ,.aurora_txp                (aurora_txp                 )
        ,.aurora_txn                (aurora_txn                 )
        ,.aurora_refclkp            (aurora_refclkp             )
        ,.aurora_refclkn            (aurora_refclkn             )

        ,.aurora_reset_pb           (aurora_reset_pb            )
        ,.aurora_pma_init           (aurora_pma_init            )
        ,.aurora_init_clk           (aurora_init_clk            )
        ,.peri_reset                (peri_reset                 )

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

    
    aurora_axi_map #(
         .axi_req_t                 (test_axi_req_t             )
        ,.axi_resp_t                (test_axi_resp_t            )
        ,.axis_req_t                (axis_sgbus_req_t           )
        ,.axis_resp_t               (axis_sgbus_resp_t          )
        ,.axis_data_t               (sgbus_data_t               )
        ,.MaxPayload                (128                        )
    )aurora_axi_map_inst(
         .clk                       (aurora_userclk             )
        ,.reset                     (peri_reset                 )
        ,.s_axis_req                (axis_sgbus_rx_req          )
        ,.s_axis_resp               (axis_sgbus_rx_resp         )
        ,.m_axis_req                (axis_sgbus_tx_req          )
        ,.m_axis_resp               (axis_sgbus_tx_resp         )
        ,.m_axi_req                 (m_axi_req                  )
        ,.m_axi_resp                (m_axi_resp                 )
    );
    
    axi_block_ram axi_block_ram_dut (
         .rsta_busy                 (                           )
        ,.rstb_busy                 (                           )
        ,.s_aclk                    (aurora_userclk             )
        ,.s_aresetn                 (!peri_reset                )
        ,.s_axi_awid                (m_axi_req.aw.id            )
        ,.s_axi_awaddr              (m_axi_req.aw.addr          )
        ,.s_axi_awlen               (m_axi_req.aw.len           )
        ,.s_axi_awsize              (m_axi_req.aw.size          )
        ,.s_axi_awburst             (m_axi_req.aw.burst         )
        ,.s_axi_awvalid             (m_axi_req.aw_valid         )
        ,.s_axi_awready             (m_axi_resp.aw_ready        )
        ,.s_axi_wdata               (m_axi_req.w.data           )
        ,.s_axi_wstrb               (m_axi_req.w.strb           )
        ,.s_axi_wlast               (m_axi_req.w.last           )
        ,.s_axi_wvalid              (m_axi_req.w_valid          )
        ,.s_axi_wready              (m_axi_resp.w_ready         )
        ,.s_axi_bid                 (m_axi_resp.b.id            )
        ,.s_axi_bresp               (m_axi_resp.b.resp          )
        ,.s_axi_bvalid              (m_axi_resp.b_valid         )
        ,.s_axi_bready              (m_axi_req.b_ready          )
        ,.s_axi_arid                (m_axi_req.ar.id            )
        ,.s_axi_araddr              (m_axi_req.ar.addr          )
        ,.s_axi_arlen               (m_axi_req.ar.len           )
        ,.s_axi_arsize              (m_axi_req.ar.size          )
        ,.s_axi_arburst             (m_axi_req.ar.burst         )
        ,.s_axi_arvalid             (m_axi_req.ar_valid         )
        ,.s_axi_arready             (m_axi_resp.ar_ready        )
        ,.s_axi_rid                 (m_axi_resp.r.id            )
        ,.s_axi_rdata               (m_axi_resp.r.data          )
        ,.s_axi_rresp               (m_axi_resp.r.resp          )
        ,.s_axi_rlast               (m_axi_resp.r.last          )
        ,.s_axi_rvalid              (m_axi_resp.r_valid         )
        ,.s_axi_rready              (m_axi_req.r_ready          ) 
    );



    // aurora_axil_map #(
    //      .axil_req_t                (test_axil_req_t            )
    //     ,.axil_resp_t               (test_axil_resp_t           )
    //     ,.axis_req_t                (axis_sgbus_req_t           )
    //     ,.axis_resp_t               (axis_sgbus_resp_t          )
    //     ,.axis_data_t               (sgbus_data_t               )
    //     ,.MaxPayload                (3                          )
    // )aurora_axil_map_inst(
    //      .clk                       (aurora_userclk             )
    //     ,.reset                     (peri_reset                 )
    //     ,.s_axis_req                (axis_sgbus_rx_req          )
    //     ,.s_axis_resp               (axis_sgbus_rx_resp         )
    //     ,.m_axis_req                (axis_sgbus_tx_req          )
    //     ,.m_axis_resp               (axis_sgbus_tx_resp         )
    //     ,.m_axil_req                (m_axil_req                 )
    //     ,.m_axil_resp               (m_axil_resp                )
    // );

    // axil_block_ram axil_dut (
    //      .rsta_busy                 (                       )
    //     ,.rstb_busy                 (                       )
    //     ,.s_aclk                    (aurora_userclk         )
    //     ,.s_aresetn                 (!peri_reset            )
    //     ,.s_axi_awaddr              (m_axil_req.aw.addr     )
    //     ,.s_axi_awvalid             (m_axil_req.aw_valid    )
    //     ,.s_axi_awready             (m_axil_resp.aw_ready   )
    //     ,.s_axi_wdata               (m_axil_req.w.data      )
    //     ,.s_axi_wstrb               ('1                     )
    //     ,.s_axi_wvalid              (m_axil_req.w_valid     )
    //     ,.s_axi_wready              (m_axil_resp.w_ready    )
    //     ,.s_axi_bresp               (m_axil_resp.b.resp     )
    //     ,.s_axi_bvalid              (m_axil_resp.b_valid    )
    //     ,.s_axi_bready              (m_axil_req.b_ready     )
    //     ,.s_axi_araddr              (m_axil_req.ar.addr     )
    //     ,.s_axi_arvalid             (m_axil_req.ar_valid    )
    //     ,.s_axi_arready             (m_axil_resp.ar_ready   )
    //     ,.s_axi_rdata               (m_axil_resp.r.data     )
    //     ,.s_axi_rresp               (m_axil_resp.r.resp     )
    //     ,.s_axi_rvalid              (m_axil_resp.r_valid    )
    //     ,.s_axi_rready              (m_axil_req.r_ready     )
    // );

endmodule