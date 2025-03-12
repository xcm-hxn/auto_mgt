`include "sgbus_defines.svh"

module sgbus_stream_route #(
     parameter  type        axis_req_t      = logic
    ,parameter  type        axis_resp_t     = logic
    ,parameter  type        axis_data_t     = logic

    ,parameter  int         MaxPayload      = 128
)(
     input      logic       stream_clk
    ,input      logic       reset

    ,input      axis_req_t  s_axis_req
    ,output     axis_resp_t s_axis_resp

    ,output     axis_req_t  m_axis_req
    ,input      axis_resp_t m_axis_resp

    ,(* KEEP = "TRUE" *)output     axis_req_t  m_axil_eng_axis_req
    ,(* KEEP = "TRUE" *)input      axis_resp_t m_axil_eng_axis_resp
    ,(* KEEP = "TRUE" *)output     axis_req_t  m_byp_axis_req
    ,(* KEEP = "TRUE" *)input      axis_resp_t m_byp_axis_resp

    ,(* KEEP = "TRUE" *)input      axis_req_t  s_axil_eng_axis_req
    ,(* KEEP = "TRUE" *)output     axis_resp_t s_axil_eng_axis_resp
    ,(* KEEP = "TRUE" *)input      axis_req_t  s_byp_axis_req
    ,(* KEEP = "TRUE" *)output     axis_resp_t s_byp_axis_resp
);

    localparam  int PktPtrWidth = sgbus_pkg::idx_width(MaxPayload)  ;
    localparam  int SelWidth    = sgbus_pkg::idx_width(2)           ;
    typedef logic   [SelWidth - 1 : 0]      sel_t                   ;
    typedef logic   [PktPtrWidth:0]         pkt_ptr_t               ;

    pkt_ptr_t           rx_pkt_ptr      ;
    pkt_ptr_t           rx_pkt_len      ;
    pkt_ptr_t           tx_pkt_ptr      ;
    pkt_ptr_t           tx_pkt_len      ;
    pkt_ptr_t           rx_pkt_ptr_nxt  ;
    pkt_ptr_t           rx_pkt_len_nxt  ;
    pkt_ptr_t           tx_pkt_ptr_nxt  ;
    pkt_ptr_t           tx_pkt_len_nxt  ;
    sgbus_header_t      parsed_frame    ;

    sel_t               eng_sel         ;
    sel_t               eng_sel_prv     ;

    `SGBUS_HEADER_VEC_TO_STURCT(demux_s_axis_req.t.data, parsed_frame, assign)

    axis_req_t  demux_s_axis_req        ;
    axis_resp_t demux_s_axis_resp       ;
    axis_req_t  demux_m_axis_req[2]     ;
    axis_resp_t demux_m_axis_resp[2]    ;


    stream_demux #(
         .axis_req_t (axis_req_t        )
        ,.axis_resp_t(axis_resp_t       )
        ,.payload_t  (axis_data_t       )
        ,.sel_t      (sel_t             )
        ,.MasterNum  (2                 )
    )stream_demux_inst(
         .clk        (stream_clk        )
        ,.reset      (reset             )
        ,.s_axis_req (demux_s_axis_req  )
        ,.s_axis_resp(demux_s_axis_resp )
        ,.mst_sel    (eng_sel           )
        ,.m_axis_req (demux_m_axis_req  )
        ,.m_axis_resp(demux_m_axis_resp )
    );

    assign demux_s_axis_req     = s_axis_req            ;
    assign demux_m_axis_resp[0] = m_axil_eng_axis_resp  ;
    assign demux_m_axis_resp[1] = m_byp_axis_resp       ;
    assign s_axis_resp          = demux_s_axis_resp     ;
    assign m_axil_eng_axis_req  = demux_m_axis_req[0]   ;
    assign m_byp_axis_req       = demux_m_axis_req[1]   ;
    
    always_comb begin
        eng_sel         = eng_sel_prv;
        rx_pkt_ptr_nxt  = rx_pkt_ptr;
        rx_pkt_len_nxt  = rx_pkt_len;

        if(demux_s_axis_req.tvalid && demux_s_axis_resp.tready) begin
            if(rx_pkt_ptr == 0) begin
                rx_pkt_ptr_nxt = parsed_frame.pkt_len;
                rx_pkt_len_nxt = parsed_frame.pkt_len;
                case(parsed_frame.pkg_type_id)
                    axi_lite_rd     :   eng_sel = 0;
                    axi_lite_wr     :   eng_sel = 0;
                    default         :   eng_sel = 1;
                endcase
            end
            else begin
                rx_pkt_ptr_nxt = rx_pkt_ptr - 1;
            end
        end
    end

    always_ff@(posedge stream_clk) begin
        if(reset) begin
            rx_pkt_ptr  <= '0;
            rx_pkt_len  <= '0;
            eng_sel_prv <= '0;
        end
        else begin
            rx_pkt_ptr  <= rx_pkt_ptr_nxt;
            rx_pkt_len  <= rx_pkt_len_nxt;
            eng_sel_prv <= eng_sel;
        end
    end

    axis_req_t  mux_s_axis_req[2]       ;
    axis_resp_t mux_s_axis_resp[2]      ;
    axis_req_t  mux_m_axis_req          ;
    axis_resp_t mux_m_axis_resp         ;
    
    stream_mux #(
         .axis_req_t (axis_req_t        )
        ,.axis_resp_t(axis_resp_t       )
        ,.payload_t  (axis_data_t       )
        ,.sel_t      (sel_t             )
        ,.SlaveNum   (2                 )
    )stream_mux_inst(
         .clk        (stream_clk        )
        ,.reset      (reset             )
        ,.s_axis_req (mux_s_axis_req    )
        ,.s_axis_resp(mux_s_axis_resp   )
        ,.slv_sel    (eng_sel           )
        ,.m_axis_req (mux_m_axis_req    )
        ,.m_axis_resp(mux_m_axis_resp   )
    );

    assign m_axis_req           = mux_m_axis_req        ;
    assign s_axil_eng_axis_resp = mux_s_axis_resp[0]    ;
    assign s_byp_axis_resp      = mux_s_axis_resp[1]    ;
    assign mux_m_axis_resp      = m_axis_resp           ;
    assign mux_s_axis_req[0]    = s_axil_eng_axis_req   ;
    assign mux_s_axis_req[1]    = s_byp_axis_req        ;

endmodule
