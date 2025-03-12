`include "sgbus_defines.svh"

module scaled_aurora_core #(
     parameter  type    axis_aurora_req_t   = logic
    ,parameter  type    axis_aurora_resp_t  = logic
    ,parameter  type    axis_aurora_data_t  = logic

    ,parameter  type    axis_nfc_req_t      = logic
    ,parameter  type    axis_nfc_resp_t     = logic
    ,parameter  type    axis_nfc_data_t     = logic

    ,parameter  type    axis_sgbus_req_t    = logic
    ,parameter  type    axis_sgbus_resp_t   = logic

    ,parameter  int     AuroraStreamWidth   = 64
    ,parameter  int     SgbusPayloadWidth   = 128
    ,parameter  int     DivisionWidth       = 64
)(
     input      logic               aurora_rxp
    ,input      logic               aurora_rxn
    ,output     logic               aurora_txp
    ,output     logic               aurora_txn
    ,input      logic               aurora_refclkp
    ,input      logic               aurora_refclkn

    ,input      logic               aurora_reset_pb
    ,input      logic               aurora_pma_init
    ,input      logic               aurora_init_clk
    ,input      logic               peri_reset

    ,output     logic               aurora_channel_up
    ,output     logic               aurora_lane_up
    ,output     logic               aurora_gt_pll_lock

    ,output     logic               aurora_userclk

    ,output     axis_sgbus_req_t    axis_sgbus_rx_req
    ,input      axis_sgbus_resp_t   axis_sgbus_rx_resp
    ,input      axis_sgbus_req_t    axis_sgbus_tx_req
    ,output     axis_sgbus_resp_t   axis_sgbus_tx_resp
    ,output     axis_sgbus_resp_t   axis_sgbus_tx_hf_resp

);

    (* MARK_DEBUG = "TRUE" *)axis_aurora_req_t   axis_aurora_rx_req          ;
    (* MARK_DEBUG = "TRUE" *)axis_aurora_resp_t  axis_aurora_rx_resp         ;
    (* MARK_DEBUG = "TRUE" *)axis_aurora_resp_t  axis_aurora_rx_hf_resp      ;
    (* MARK_DEBUG = "TRUE" *)axis_aurora_req_t   axis_aurora_tx_req          ;
    (* MARK_DEBUG = "TRUE" *)axis_aurora_resp_t  axis_aurora_tx_resp         ;
    (* MARK_DEBUG = "TRUE" *)axis_nfc_req_t      aurora_nfc_req              ;
    (* MARK_DEBUG = "TRUE" *)axis_nfc_resp_t     aurora_nfc_resp             ;

    axis_aurora_data_t  m_axis_aurora_tdata         ;
    logic               m_axis_aurora_tvalid        ;

    axis_aurora_data_t  s_axis_aurora_tdata         ;
    logic               s_axis_aurora_tvalid        ;
    logic               s_axis_aurora_tready        ;

    axis_nfc_data_t     s_axis_aurora_nfc_tdata     ;
    logic               s_axis_aurora_nfc_tvalid    ;
    logic               s_axis_aurora_nfc_tready    ;


    // Flat data to struct data.
    assign axis_aurora_rx_req.tvalid = m_axis_aurora_tvalid;
    assign axis_aurora_rx_req.t.data = m_axis_aurora_tdata;

    assign s_axis_aurora_tdata = axis_aurora_tx_req.t.data;
    assign s_axis_aurora_tvalid = axis_aurora_tx_req.tvalid;
    assign axis_aurora_tx_resp.tready = s_axis_aurora_tready;

    assign s_axis_aurora_nfc_tdata = aurora_nfc_req.t.data;
    assign s_axis_aurora_nfc_tvalid = aurora_nfc_req.tvalid;
    assign aurora_nfc_resp.tready = s_axis_aurora_nfc_tready;

    aurora_core aurora_core_inst(
         .aurora_rxp                (aurora_rxp                 )
        ,.aurora_rxn                (aurora_rxn                 )
        ,.aurora_txp                (aurora_txp                 )
        ,.aurora_txn                (aurora_txn                 )
        ,.aurora_refclkp            (aurora_refclkp             )
        ,.aurora_refclkn            (aurora_refclkn             )

        ,.aurora_reset_pb           (aurora_reset_pb            )
        ,.aurora_pma_init           (aurora_pma_init            )
        ,.aurora_init_clk           (aurora_init_clk            )

        ,.aurora_channel_up         (aurora_channel_up          )
        ,.aurora_lane_up            (aurora_lane_up             )
        ,.aurora_gt_pll_lock        (aurora_gt_pll_lock         )

        ,.aurora_userclk            (aurora_userclk             )

        ,.s_axis_aurora_tdata       (s_axis_aurora_tdata        )
        ,.s_axis_aurora_tvalid      (s_axis_aurora_tvalid       )
        ,.s_axis_aurora_tready      (s_axis_aurora_tready       )

        ,.m_axis_aurora_tdata       (m_axis_aurora_tdata        )
        ,.m_axis_aurora_tvalid      (m_axis_aurora_tvalid       )

        ,.s_axis_aurora_nfc_tvalid  (s_axis_aurora_nfc_tvalid   )
        ,.s_axis_aurora_nfc_tdata   (s_axis_aurora_nfc_tdata    )
        ,.s_axis_aurora_nfc_tready  (s_axis_aurora_nfc_tready   )
    );

    (* DONT_TOUCH = "TRUE" *)
    stream_data_scaling #(
         .SlvStreamWidth            (AuroraStreamWidth          )
        ,.MstStreamWidth            (SgbusPayloadWidth          )
        ,.DivisionWidth             (DivisionWidth              )
        ,.BufferSize                (16                         )
        ,.FIFOThreshold             (8                          )
        ,.s_axis_req_t              (axis_aurora_req_t          )
        ,.s_axis_resp_t             (axis_aurora_resp_t         )
        ,.m_axis_req_t              (axis_sgbus_req_t           )
        ,.m_axis_resp_t             (axis_sgbus_resp_t          )
    )aurora_rx_scaling(
         .clk                       (aurora_userclk             )
        ,.reset                     (peri_reset                 )
        ,.s_axis_req                (axis_aurora_rx_req         )
        ,.s_axis_resp               (axis_aurora_rx_resp        )
        ,.s_axis_hf_resp            (axis_aurora_rx_hf_resp     )
        ,.m_axis_req                (axis_sgbus_rx_req          )
        ,.m_axis_resp               (axis_sgbus_rx_resp         )
    );

    (* DONT_TOUCH = "TRUE" *)
    stream_data_scaling #(
         .SlvStreamWidth            (SgbusPayloadWidth          )
        ,.MstStreamWidth            (AuroraStreamWidth          )
        ,.DivisionWidth             (DivisionWidth              )
        ,.BufferSize                (16                         )
        ,.FIFOThreshold             (8                          )
        ,.s_axis_req_t              (axis_sgbus_req_t           )
        ,.s_axis_resp_t             (axis_sgbus_resp_t          )
        ,.m_axis_req_t              (axis_aurora_req_t          )
        ,.m_axis_resp_t             (axis_aurora_resp_t         )
    )aurora_tx_scaling(
         .clk                       (aurora_userclk             )
        ,.reset                     (peri_reset                 )
        ,.s_axis_req                (axis_sgbus_tx_req          )
        ,.s_axis_resp               (axis_sgbus_tx_resp         )
        ,.s_axis_hf_resp            (axis_sgbus_tx_hf_resp      )
        ,.m_axis_req                (axis_aurora_tx_req         )
        ,.m_axis_resp               (axis_aurora_tx_resp        )
    );

    `PROC_LOCK_FF(nfc_valid, aurora_userclk, peri_reset)
    `PROC_LOCK_FF(nfc_open, aurora_userclk, peri_reset)

    always_comb begin
        `PROC_INIT(nfc_valid)
        `PROC_INIT(nfc_open)
        
        // Aurora Flow control is openned.
        if(nfc_open_lock) begin
            // Downstream fifo available, close flow control.
            if(axis_aurora_rx_hf_resp.tready) begin
                if(nfc_valid_lock) begin
                    aurora_nfc_req.tvalid = 1;
                    aurora_nfc_req.t.data = 16'h0000;
                    if(aurora_nfc_resp.tready) begin
                        `PROC_UNLOCK(nfc_valid)
                        `PROC_UNLOCK(nfc_open)
                    end
                end
                else begin
                    aurora_nfc_req.tvalid = 1;
                    aurora_nfc_req.t.data = 16'h0000;
                    if(!aurora_nfc_resp.tready) begin
                        `PROC_LOCK(nfc_valid)
                    end
                    else begin
                        `PROC_UNLOCK(nfc_open)
                    end
                end
            end
            else begin
                aurora_nfc_req = '0;
            end
        end
        // Aurora Flow control is closed.
        else begin
            // Downstream fifo is half full, open flow control.
            if(!axis_aurora_rx_hf_resp.tready) begin
                if(nfc_valid_lock) begin
                    aurora_nfc_req.tvalid = 1;
                    aurora_nfc_req.t.data = 16'h0010;
                    if(aurora_nfc_resp.tready) begin
                        `PROC_UNLOCK(nfc_valid)
                        `PROC_LOCK(nfc_open)
                    end
                end
                else begin
                    aurora_nfc_req.tvalid = 1;
                    aurora_nfc_req.t.data = 16'h0010;
                    if(!aurora_nfc_resp.tready) begin
                        `PROC_LOCK(nfc_valid)
                    end
                    else begin
                        `PROC_UNLOCK(nfc_open)
                    end
                end
            end
            else begin
                aurora_nfc_req = '0;
            end
        end
    end



endmodule