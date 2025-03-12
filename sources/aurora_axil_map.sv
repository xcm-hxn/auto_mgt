`timescale 1ns/1ps
`include "sgbus_pkgs.svh"
`include "sgbus_defines.svh"
import sgbus_pkg::*;

module aurora_axil_map#(
     parameter  type        axil_req_t  = logic
    ,parameter  type        axil_resp_t = logic
    ,parameter  type        axis_req_t  = logic
    ,parameter  type        axis_resp_t = logic
    ,parameter  type        axis_data_t = logic
    ,parameter  int         MaxPayload  = 3
)(
     input      logic       clk
    ,input      logic       reset
    
    ,input      axis_req_t  s_axis_req
    ,output     axis_resp_t s_axis_resp

    ,output     axis_req_t  m_axis_req
    ,input      axis_resp_t m_axis_resp

    ,output     axil_req_t  m_axil_req
    ,input      axil_resp_t m_axil_resp
);

    // DO NOT support outstanding transactions.
    localparam PktPtrWidth = sgbus_pkg::idx_width(MaxPayload);

    typedef logic [PktPtrWidth - 1 : 0] pkt_ptr_t   ;

    pkt_ptr_t           rx_pkt_ptr      ;
    pkt_ptr_t           rx_pkt_ptr_nxt  ;
    pkt_ptr_t           tx_pkt_ptr      ;
    pkt_ptr_t           tx_pkt_ptr_nxt  ;
    sgbus_header_t      sgbus_header    ;

    axis_resp_t         s_axis_resp_nxt ;
    axil_req_t          m_axil_req_nxt  ;

    `SGBUS_HEADER_VEC_TO_STURCT(s_axis_req.t.data, sgbus_header, assign)
    `PROC_LOCK_FF(axil_aw, clk, reset)
    `PROC_LOCK_FF(axil_ar, clk, reset)
    `PROC_LOCK_FF(axil_w, clk, reset)

    `PROC_LOCK_FF(axil_wr, clk, reset)
    `PROC_LOCK_FF(axil_rd, clk, reset)

    // TODO : Need to post wr/rd status, i.e., b_resp/r_resp data to aurora stream.
    // TODO : Need to handle timeout.
    // TODO : Need to handle corrupted data by rejecting the packet and clearing upstream fifo.
    always_comb begin
        `PROC_INIT(axil_aw)
        `PROC_INIT(axil_ar)
        `PROC_INIT(axil_w)

        `PROC_INIT(axil_wr)
        `PROC_INIT(axil_rd)
        
        rx_pkt_ptr_nxt  = rx_pkt_ptr;
        tx_pkt_ptr_nxt  = tx_pkt_ptr;   

        s_axis_resp_nxt = s_axis_resp; 
        m_axil_req_nxt  = '0;
        m_axis_req      = '0;

        // Previous rx packet handled, incoming new packet.
        if(s_axis_req.tvalid && s_axis_resp.tready) begin
            if(rx_pkt_ptr == 0) begin
                rx_pkt_ptr_nxt = sgbus_header.pkt_len[PktPtrWidth - 1 : 0];
                case(sgbus_header.pkg_type_id)
                    axi_lite_rd: begin
                        `PROC_LOCK(axil_rd)
                    end
                    axi_lite_wr: begin
                        `PROC_LOCK(axil_wr)
                    end 
                endcase
            end
            else begin
                rx_pkt_ptr_nxt = rx_pkt_ptr - 1;
                // Block upstream
                if(rx_pkt_ptr == 1) begin
                    s_axis_resp_nxt.tready = 0;
                end
            end
        end

        if(axil_wr_lock) begin
            // HACK : Hold aw.addr and w.data for readback check.
            m_axil_req_nxt.aw.addr = m_axil_req.aw.addr;
            m_axil_req_nxt.w.data = m_axil_req.w.data;
            // Handling axi lite aw transaction.
            if(axil_aw_lock) begin
                m_axil_req_nxt.aw_valid = 1;
                m_axil_req_nxt.aw.addr = m_axil_req.aw.addr;
                if(m_axil_resp.aw_ready) begin
                    `PROC_UNLOCK(axil_aw)
                    m_axil_req_nxt.aw_valid = 0;
                end
            end
            else begin
                if(rx_pkt_ptr == 2) begin
                    if(s_axis_req.tvalid) begin
                        m_axil_req_nxt.aw_valid = 1;
                        m_axil_req_nxt.aw.addr = s_axis_req.t.data;
                        if(!m_axil_resp.aw_ready) begin
                            `PROC_LOCK(axil_aw)
                        end
                    end
                end
            end
            // Handling axi lite w transaction.
            // TODO : Need to check aw channel vld-rdy status?
            if(axil_w_lock) begin
                m_axil_req_nxt.w_valid = 1;
                m_axil_req_nxt.w.data = m_axil_req.w.data;
                if(m_axil_resp.w_ready) begin
                    `PROC_UNLOCK(axil_w)
                    m_axil_req_nxt.w_valid = 0;
                    tx_pkt_ptr_nxt = 3;
                end
            end
            else begin
                if(rx_pkt_ptr == 1) begin
                    if(s_axis_req.tvalid) begin
                        m_axil_req_nxt.w_valid = 1;
                        m_axil_req_nxt.w.data = s_axis_req.t.data;
                        if(!m_axil_resp.w_ready) begin
                            `PROC_LOCK(axil_w)
                        end
                        else begin
                            tx_pkt_ptr_nxt = 3;
                        end
                    end
                end
            end
            // Handling axi lite b channel and aurora readback.
            // Make sure upstream packet has been cleared.
            if(m_axil_resp.b_valid && rx_pkt_ptr == 0) begin
                m_axis_req.tvalid = 1;
                if(m_axis_resp.tready && m_axis_req.tvalid) begin
                    tx_pkt_ptr_nxt = tx_pkt_ptr - 1;
                    if(tx_pkt_ptr == 0) begin
                        `PROC_UNLOCK(axil_wr)
                        m_axil_req_nxt.b_ready = 1;
                        m_axis_req.tvalid = 0;
                        // Open upstream channel.
                        s_axis_resp_nxt.tready = 1;
                    end
                end
            end

            case(tx_pkt_ptr)
                3:  m_axis_req.t.data = 'h4859_0000_0000_0001_0000_0000_0000_0002;
                2:  m_axis_req.t.data = m_axil_req.aw.addr;
                1:  m_axis_req.t.data = m_axil_req.w.data;
            endcase

        end

        if(axil_rd_lock) begin
            // Handling axi lite ar transaction.
            if(axil_ar_lock) begin
                m_axil_req_nxt.ar_valid = 1;
                m_axil_req_nxt.ar.addr = m_axil_req.ar.addr;
                if(m_axil_resp.ar_ready) begin
                    `PROC_UNLOCK(axil_ar)
                    m_axil_req_nxt.ar_valid = 0;
                    tx_pkt_ptr_nxt = 2;
                end
            end
            else begin
                if(rx_pkt_ptr == 1) begin
                    if(s_axis_req.tvalid) begin
                        m_axil_req_nxt.ar_valid = 1;
                        m_axil_req_nxt.ar.addr = s_axis_req.t.data;
                        if(!m_axil_resp.ar_ready) begin
                            `PROC_LOCK(axil_ar)
                        end
                        else begin
                            tx_pkt_ptr_nxt = 2;
                        end
                    end
                end
            end

            // Handling axi lite r channel transaction.
            if(m_axil_resp.r_valid && rx_pkt_ptr == 0) begin
                m_axis_req.tvalid = 1;
                if(m_axis_resp.tready && m_axis_req.tvalid) begin
                    tx_pkt_ptr_nxt = tx_pkt_ptr - 1;
                    if(tx_pkt_ptr == 0) begin
                        `PROC_UNLOCK(axil_rd)
                        m_axil_req_nxt.r_ready = 1;
                        m_axis_req.tvalid = 0;
                        // Open upstream channel.
                        s_axis_resp_nxt.tready = 1;
                    end
                end
            end

            case(tx_pkt_ptr)
                2:  m_axis_req.t.data = 'h4859_0000_0000_0000_0000_0000_0000_0001;
                1:  m_axis_req.t.data = m_axil_resp.r.data;
            endcase

        end
    end

    always_ff@(posedge clk) begin
        if(reset) begin
            rx_pkt_ptr   <= '0;
            tx_pkt_ptr   <= '0;
            s_axis_resp  <= '1;
            m_axil_req   <= '0;
        end
        else begin
            rx_pkt_ptr   <= rx_pkt_ptr_nxt   ;
            tx_pkt_ptr   <= tx_pkt_ptr_nxt   ;
            s_axis_resp  <= s_axis_resp_nxt  ;
            m_axil_req   <= m_axil_req_nxt   ;
        end
    end

endmodule