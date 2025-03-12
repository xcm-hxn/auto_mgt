`timescale 1ns/1ps
`include "sgbus_pkgs.svh"
`include "sgbus_defines.svh"
import sgbus_pkg::*;

// Stream upsizer design

module stream_upsizer #(
     parameter  int             SlvStreamWidth  = 64
    ,parameter  int             MstStreamWidth  = 256
    ,parameter  int             BufferSize      = 16       // scaled in source data type
    ,parameter  type            s_axis_req_t    = logic     
    ,parameter  type            s_axis_resp_t   = logic
    ,parameter  type            s_axis_data_t   = logic 
    ,parameter  type            m_axis_req_t    = logic
    ,parameter  type            m_axis_resp_t   = logic
)(
     input      logic           clk     
    ,input      logic           reset
    ,input      s_axis_req_t    s_axis_req
    ,output     s_axis_resp_t   s_axis_resp
    ,output     m_axis_req_t    m_axis_req
    ,input      m_axis_resp_t   m_axis_resp
     
);

    localparam  int FIFONum     = MstStreamWidth / SlvStreamWidth  ;
    localparam  int FIFODep     = BufferSize;
    localparam  int SelWidth    = sgbus_pkg::idx_width(FIFONum);

    typedef logic   [SelWidth - 1 : 0]  sel_t   ; 

    s_axis_data_t   [FIFONum-1:0]     fifo_din      ;
    s_axis_data_t   [FIFONum-1:0]     fifo_dout     ;
    logic           [FIFONum-1:0]     fifo_valid_i  ;
    logic           [FIFONum-1:0]     fifo_ready_o  ;
    logic           [FIFONum-1:0]     fifo_valid_o  ;
    logic           [FIFONum-1:0]     fifo_ready_i  ;

    s_axis_req_t    demux_axis_req[FIFONum]         ;
    s_axis_resp_t   demux_axis_resp[FIFONum]        ;
    sel_t           fifo_sel_nxt                    ;
    sel_t           fifo_sel                        ;

    stream_demux #(
         .axis_req_t (s_axis_req_t      )
        ,.axis_resp_t(s_axis_resp_t     )
        ,.payload_t  (s_axis_data_t     )
        ,.sel_t      (sel_t             )
        ,.MasterNum  (FIFONum           )
    )stream_demux_inst(
         .clk        (clk               )
        ,.reset      (reset             )
        ,.s_axis_req (s_axis_req        )
        ,.s_axis_resp(s_axis_resp       )
        ,.mst_sel    (fifo_sel          )
        ,.m_axis_req (demux_axis_req    )
        ,.m_axis_resp(demux_axis_resp   )
    );

    always_ff@(posedge clk) begin
        if(reset) begin
            fifo_sel <= '0;
        end
        else begin
            if(s_axis_req.tvalid && s_axis_resp.tready)
                if(fifo_sel == FIFONum - 1)
                    fifo_sel <= 0;
                else
                    fifo_sel <= fifo_sel + 1;
            else
                fifo_sel <= fifo_sel;
        end
    end

    generate

        for(genvar var_i = 0 ; var_i < FIFONum ; var_i = var_i + 1) begin : fifo_gen

            stream_fifo #(
                 .Depth     (FIFODep            )
                ,.data_t    (s_axis_data_t      )
            )stream_fifo_inst(
                 .clk       (clk                )
                ,.reset     (reset              )
                ,.din       (fifo_din[var_i]    )
                ,.dout      (fifo_dout[var_i]   )
                ,.valid_i   (fifo_valid_i[var_i])
                ,.ready_o   (fifo_ready_o[var_i])
                ,.valid_o   (fifo_valid_o[var_i])
                ,.ready_i   (fifo_ready_i[var_i])
            );

            assign fifo_din[var_i] = demux_axis_req[var_i].t.data;
            assign fifo_valid_i[var_i] = demux_axis_req[var_i].tvalid;
            assign fifo_ready_i[var_i] = m_axis_resp.tready && m_axis_req.tvalid;

            assign m_axis_req.t.data[var_i*SlvStreamWidth+:SlvStreamWidth] = fifo_dout[(FIFONum - var_i - 1)];
            
            assign demux_axis_resp[var_i] = fifo_ready_o[var_i];
        end

    endgenerate

    assign m_axis_req.tvalid = &fifo_valid_o;

    // initial begin
    //     DivisionCheck: assert ((SlvStreamWidth != 0) && (MstStreamWidth % SlvStreamWidth == 0)) else 
    //         $fatal("MstStreamWidth MUST be division of SlvStreamWidth!")
    // end

endmodule