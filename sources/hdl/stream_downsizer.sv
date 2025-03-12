`timescale 1ns/1ps
`include "sgbus_pkgs.svh"
`include "sgbus_defines.svh"
import sgbus_pkg::*;

// Stream downsizer design
// The s_axis_resp.tready is asserted until fifo is completely full.
// The half full signal is used for an early back pressure.

module stream_downsizer #(
     parameter  int             SlvStreamWidth  = 256
    ,parameter  int             MstStreamWidth  = 64
    ,parameter  int             BufferSize      = 16       // scaled in source data type
    ,parameter  int             FIFOThreshold   = 8
    ,parameter  type            s_axis_req_t    = logic     
    ,parameter  type            s_axis_resp_t   = logic
    ,parameter  type            m_axis_req_t    = logic
    ,parameter  type            m_axis_resp_t   = logic
    ,parameter  type            m_axis_data_t   = logic
)(
     input      logic           clk     
    ,input      logic           reset
    ,input      s_axis_req_t    s_axis_req
    ,output     s_axis_resp_t   s_axis_resp
    ,output     s_axis_resp_t   s_axis_hf_resp
    ,output     m_axis_req_t    m_axis_req
    ,input      m_axis_resp_t   m_axis_resp
     
);

    localparam  int FIFONum     = SlvStreamWidth / MstStreamWidth  ;
    localparam  int FIFODep     = BufferSize;
    localparam  int SelWidth    = sgbus_pkg::idx_width(FIFONum);

    typedef logic   [SelWidth - 1 : 0]      sel_t           ; 

    m_axis_data_t   [FIFONum - 1 : 0]       fifo_din        ;
    m_axis_data_t   [FIFONum - 1 : 0]       fifo_dout       ;
    logic           [FIFONum - 1 : 0]       fifo_valid_i    ;
    logic           [FIFONum - 1 : 0]       fifo_ready_o    ;
    logic           [FIFONum - 1 : 0]       fifo_hf_ready_o ;
    logic           [FIFONum - 1 : 0]       fifo_valid_o    ;
    logic           [FIFONum - 1 : 0]       fifo_ready_i    ;

    m_axis_req_t    mux_axis_req[FIFONum]           ;
    m_axis_resp_t   mux_axis_resp[FIFONum]          ;
    sel_t           fifo_sel_nxt                    ;
    sel_t           fifo_sel                        ;

    generate

        for(genvar var_i = 0 ; var_i < FIFONum ; var_i = var_i + 1) begin : fifo_gen

            // stream_fifo #(
            //      .Depth     (FIFODep                )
            //     ,.Threshold (FIFOThreshold          )
            //     ,.data_t    (m_axis_data_t          )
            // )stream_fifo_inst(
            //      .clk       (clk                    )
            //     ,.reset     (reset                  )
            //     ,.din       (fifo_din[var_i]        )
            //     ,.dout      (fifo_dout[var_i]       )
            //     ,.valid_i   (fifo_valid_i[var_i]    )
            //     ,.ready_o   (fifo_ready_o[var_i]    )
            //     ,.hf_ready_o(fifo_hf_ready_o[var_i] )
            //     ,.valid_o   (fifo_valid_o[var_i]    )
            //     ,.ready_i   (fifo_ready_i[var_i]    )
            // );

            fifo_64b_sync_intf fifo_64b_sync_intf_inst(
                 .reset         (reset                  )
                ,.clk           (clk                    )
                ,.din           (fifo_din[var_i]        )
                ,.valid_i       (fifo_valid_i[var_i]    )
                ,.ready_o       (fifo_ready_o[var_i]    )
                ,.hf_ready_o    (fifo_hf_ready_o[var_i] )
                ,.dout          (fifo_dout[var_i]       )
                ,.valid_o       (fifo_valid_o[var_i]    )
                ,.ready_i       (fifo_ready_i[var_i]    )
            );

            assign fifo_din[var_i] = s_axis_req[(FIFONum - var_i - 1)*MstStreamWidth+:MstStreamWidth];
            assign fifo_valid_i[var_i] = s_axis_req.tvalid;
            assign fifo_ready_i[var_i] = mux_axis_resp[var_i].tready;

            assign mux_axis_req[var_i].t.data = fifo_dout[var_i];
            assign mux_axis_req[var_i].tvalid = fifo_valid_o[var_i];

        end

    endgenerate

    assign s_axis_resp.tready = &fifo_ready_o;
    assign s_axis_hf_resp.tready = &fifo_hf_ready_o;

    stream_mux #(
         .axis_req_t (m_axis_req_t  )
        ,.axis_resp_t(m_axis_resp_t )
        ,.payload_t  (m_axis_data_t )
        ,.sel_t      (sel_t         )
        ,.SlaveNum   (FIFONum       )
    )stream_mux_inst(
         .clk        (clk           )
        ,.reset      (reset         )
        ,.s_axis_req (mux_axis_req  )
        ,.s_axis_resp(mux_axis_resp )
        ,.slv_sel    (fifo_sel      )
        ,.m_axis_req (m_axis_req    )
        ,.m_axis_resp(m_axis_resp   )
    );

    always_ff@(posedge clk) begin
        if(reset) begin
            fifo_sel <= '0;
        end
        else begin
            if(mux_axis_req[fifo_sel].tvalid && mux_axis_resp[fifo_sel].tready)
                if(fifo_sel == FIFONum - 1)
                    fifo_sel <= 0;
                else
                    fifo_sel <= fifo_sel + 1;
            else
                fifo_sel <= fifo_sel;
        end
    end

    // initial begin
    //     DivisionCheck: assert ((MstStreamWidth != 0) && (SlvStreamWidth % MstStreamWidth == 0)) else 
    //         $fatal("MstStreamWidth MUST be division of SlvStreamWidth!")
    // end

endmodule