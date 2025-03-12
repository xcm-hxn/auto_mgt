`timescale 1ns/1ps
`include "sgbus_defines.svh"

module aurora_axi_map#(
     parameter  type        axi_req_t   = logic
    ,parameter  type        axi_resp_t  = logic
    ,parameter  type        axis_req_t  = logic
    ,parameter  type        axis_resp_t = logic
    ,parameter  type        axis_data_t = logic
    ,parameter  int         MaxPayload  = 128
)(
     input      logic       clk
    ,input      logic       reset
    
    ,input      axis_req_t  s_axis_req
    ,output     axis_resp_t s_axis_resp

    ,output     axis_req_t  m_axis_req
    ,input      axis_resp_t m_axis_resp

    ,output     axi_req_t   m_axi_req
    ,input      axi_resp_t  m_axi_resp
);

    // DO NOT support outstanding transactions.
    localparam PktPtrWidth = sgbus_pkg::idx_width(MaxPayload);

    typedef logic [PktPtrWidth - 1 : 0] pkt_ptr_t   ;

    pkt_ptr_t           rx_pkt_ptr      ;
    pkt_ptr_t           rx_pkt_ptr_nxt  ;
    logic       [31:0]  rx_pkt_len      ;
    logic       [31:0]  rx_pkt_len_nxt  ;
    pkt_ptr_t           tx_pkt_ptr      ;
    pkt_ptr_t           tx_pkt_ptr_nxt  ;
    logic       [31:0]  tx_pkt_len      ;
    logic       [31:0]  tx_pkt_len_nxt  ;

    sgbus_header_t      parsed_frame    ;

    axis_resp_t         s_axis_resp_nxt ;
    axi_req_t           m_axi_req_nxt   ;
    axis_req_t          m_axis_req_nxt  ;

    `SGBUS_HEADER_VEC_TO_STURCT(s_axis_req.t.data, parsed_frame, assign)
    `PROC_LOCK_FF(axi_wr, clk, reset)
    `PROC_LOCK_FF(axi_rd, clk, reset)

    // Comb logic for sgbus stream parsing and pointer handling.
    always_comb begin
        `PROC_INIT(axi_wr)
        `PROC_INIT(axi_rd)

        rx_pkt_ptr_nxt  = rx_pkt_ptr;
        rx_pkt_len_nxt  = rx_pkt_len;

        tx_pkt_ptr_nxt  = tx_pkt_ptr;
        tx_pkt_len_nxt  = tx_pkt_len;

        // Ongoing write operaion.
        if(axi_wr_lock) begin
            if(s_axis_req.tvalid && s_axis_resp.tready) begin
                rx_pkt_ptr_nxt = rx_pkt_ptr + 1;
                // Last data beat has been transferred, wait for write operation responce.
                if(rx_pkt_ptr == rx_pkt_len - 1) begin
                    tx_pkt_len_nxt = 1;
                    tx_pkt_ptr_nxt = 0;
                end
            end

            if(m_axis_req_nxt.tvalid && m_axis_resp.tready) begin
                tx_pkt_ptr_nxt = tx_pkt_ptr + 1;
                if(tx_pkt_ptr == tx_pkt_len) begin
                    `PROC_UNLOCK(axi_wr)
                end
            end
        end
        // Ongoing read operation.
        else if(axi_rd_lock) begin
            if(s_axis_req.tvalid && s_axis_resp.tready) begin
                rx_pkt_ptr_nxt = rx_pkt_ptr + 1;
                if(rx_pkt_ptr == rx_pkt_len - 1) begin
                    tx_pkt_len_nxt = parsed_frame.pkt_len[PktPtrWidth - 1 : 0];
                    tx_pkt_ptr_nxt = 0;
                end
            end

            if(m_axis_req_nxt.tvalid && m_axis_resp.tready) begin
                tx_pkt_ptr_nxt = tx_pkt_ptr + 1;
                if(tx_pkt_ptr == tx_pkt_len) begin
                    `PROC_UNLOCK(axi_rd)
                end
            end
        end
        // AXI master is idle.
        else begin
            if(s_axis_req.tvalid && s_axis_resp.tready) begin
                rx_pkt_len_nxt = parsed_frame.pkt_len[PktPtrWidth - 1 : 0];
                rx_pkt_ptr_nxt = 0;
                case(parsed_frame.pkg_type_id)
                    backdoor_axi_rd: begin
                        `PROC_LOCK(axi_rd)
                    end
                    backdoor_axi_wr: begin
                        `PROC_LOCK(axi_wr)
                    end 
                endcase
            end
        end

    end

    `PROC_LOCK_FF(axi_aw, clk, reset)
    `PROC_LOCK_FF(axi_ar, clk, reset)
    `PROC_LOCK_FF(axi_w, clk, reset)

    // Comb logic for AXI operations.
    always_comb begin
        `PROC_INIT(axi_aw)
        `PROC_INIT(axi_w)
        `PROC_INIT(axi_ar)
        s_axis_resp_nxt = s_axis_resp;
        m_axi_req_nxt = '0;

        // HACK : These signals have fixed values.
        m_axi_req_nxt.aw.prot = 3'b010;
        m_axi_req_nxt.ar.prot = 3'b010;
        m_axi_req_nxt.aw.cache = 4'b0011;
        m_axi_req_nxt.ar.cache = 4'b0011;
        m_axi_req_nxt.aw.burst = 2'b01;
        m_axi_req_nxt.ar.burst = 2'b01;
        m_axi_req_nxt.aw.id = '0;
        m_axi_req_nxt.ar.id = '0;
        m_axi_req_nxt.aw.size = 3'b100;
        m_axi_req_nxt.ar.size = 3'b100;
        m_axi_req_nxt.w.strb = '1;

        if(axi_wr_lock) begin
            if(axi_aw_lock) begin
                m_axi_req_nxt.aw_valid = 1;
                m_axi_req_nxt.aw.addr = m_axi_req.aw.addr;
                m_axi_req_nxt.aw.len = rx_pkt_len;
                if(m_axi_resp.aw_ready) begin
                    `PROC_UNLOCK(axi_aw)
                end
            end
            else begin
                // The first sgbus data frame of backdoor axi write indicates the address.
                if(s_axis_req.tvalid && s_axis_resp.tready) begin
                    if(rx_pkt_ptr == 0) begin
                        m_axi_req_nxt.aw_valid = 1;
                        m_axi_req_nxt.aw.addr = s_axis_req.t.data;
                        // aw_len is sgbus pkt_len minus 2.
                        m_axi_req_nxt.aw.len = rx_pkt_len - 2;
                        if(!m_axi_resp.aw_ready) begin
                            `PROC_LOCK(axi_aw)
                        end
                    end
                end
            end

            if(axi_w_lock) begin
                m_axi_req_nxt.w_valid = 1;
                m_axi_req_nxt.w.data = m_axi_req.w.data;

                if(rx_pkt_ptr == rx_pkt_len - 1)
                    m_axi_req_nxt.w.last = 1;
                else
                    m_axi_req_nxt.w.last = 0;

                if(m_axi_resp.w_ready) begin
                    s_axis_resp_nxt = 1;
                    `PROC_UNLOCK(axi_w)
                end
                
            end
            else begin
                if(s_axis_req.tvalid && s_axis_resp.tready) begin
                    if(rx_pkt_ptr != 0) begin
                        m_axi_req_nxt.w_valid = 1;
                        m_axi_req_nxt.w.data = s_axis_req.t.data;

                        if(rx_pkt_ptr == rx_pkt_len - 1)
                            m_axi_req_nxt.w.last = 1;
                        else
                            m_axi_req_nxt.w.last = 0;

                        if(!m_axi_resp.w_ready) begin
                            s_axis_resp_nxt = 0;
                            `PROC_LOCK(axi_w)
                        end
                    end
                end
            end

            if(m_axi_resp.b_valid) begin
                if(m_axis_resp.tready && m_axis_req.tvalid && tx_pkt_ptr != 0)
                    m_axi_req_nxt.b_ready = 1;
            end
        end

        if(axi_rd_lock) begin

            if(axi_ar_lock) begin
                m_axi_req_nxt.ar.len = m_axi_req.ar.len;
                m_axi_req_nxt.ar.addr = m_axi_req.ar.addr;
                m_axi_req_nxt.ar_valid = 1;
                if(m_axi_resp.ar_ready) begin
                    `PROC_UNLOCK(axi_ar)
                end
            end
            else begin
                // The first sgbus data frame of backdoor axi write contains the address.
                if(s_axis_req.tvalid && s_axis_resp.tready) begin
                    if(rx_pkt_ptr == 0) begin
                        m_axi_req_nxt.ar.addr = s_axis_req.t.data;
                    end
                    if(rx_pkt_ptr == 1) begin
                        m_axi_req_nxt.ar.len = parsed_frame.pkt_len[PktPtrWidth - 1 : 0] - 1;
                        // Keep the address value.
                        m_axi_req_nxt.ar.addr = s_axis_req.t.data;
                        m_axi_req_nxt.ar_valid = 1;
                        if(!m_axi_resp.ar_ready) begin
                            `PROC_LOCK(axi_ar)
                        end
                    end
                end
            end

            if(m_axi_resp.r_valid) begin
                if(m_axis_resp.tready && m_axis_req.tvalid && tx_pkt_ptr != 0)
                    m_axi_req_nxt.r_ready = 1;
            end

        end
    end

    `PROC_LOCK_FF(m_axis_valid, clk, reset)

    // Comb logic for m_axis
    always_comb begin
        `PROC_INIT(m_axis_valid)
        m_axis_req_nxt = '0;

        if(axi_wr_lock) begin
            if(m_axis_valid_lock) begin
                m_axis_req_nxt.tvalid = 1;
                m_axis_req_nxt.t.data = m_axis_req.t.data;
                if(m_axis_resp.tready) begin
                    `PROC_UNLOCK(m_axis_valid)
                end
            end
            else begin
                if(m_axi_resp.b_valid) begin

                    if(tx_pkt_ptr == 0) begin
                        m_axis_req_nxt.t.data = {96'h4859_0000_0000_0014_0000_0000, tx_pkt_len};
                        m_axis_req_nxt.tvalid = 1;
                    end
                    else if(tx_pkt_ptr == 1)begin
                        m_axis_req_nxt.t.data = '0;
                        m_axis_req_nxt.tvalid = 1;
                    end
                    
                    if(!m_axis_resp.tready) begin
                        `PROC_LOCK(m_axis_valid)
                    end
                end
            end
        end

        if(axi_rd_lock) begin
            if(m_axis_valid_lock) begin
                m_axis_req_nxt.tvalid = 1;
                m_axis_req_nxt.t.data = m_axis_req.t.data;
                if(m_axis_resp.tready) begin
                    `PROC_UNLOCK(m_axis_valid)
                end
            end
            else begin
                if(m_axi_resp.r_valid) begin
                    
                    if(tx_pkt_ptr == 0) begin
                        m_axis_req_nxt.t.data = {96'h4859_0000_0000_0013_0000_0000, tx_pkt_len};
                        m_axis_req_nxt.tvalid = 1;
                    end
                    else begin
                        m_axis_req_nxt.t.data = m_axi_resp.r.data;
                        m_axis_req_nxt.tvalid = 1;
                    end

                    if(!m_axis_resp.tready) begin
                        `PROC_LOCK(m_axis_valid)
                    end
                end
            end
        end

    end



    always_ff@(posedge clk) begin
        if(reset) begin
            rx_pkt_ptr   <= '0;
            tx_pkt_ptr   <= '0;
            rx_pkt_len   <= '0;
            tx_pkt_len   <= '0;
            s_axis_resp  <= '1;
            m_axi_req    <= '0;
            m_axis_req   <= '0;
        end
        else begin
            rx_pkt_ptr   <= rx_pkt_ptr_nxt   ;
            tx_pkt_ptr   <= tx_pkt_ptr_nxt   ;
            rx_pkt_len   <= rx_pkt_len_nxt   ;
            tx_pkt_len   <= tx_pkt_len_nxt   ;
            s_axis_resp  <= s_axis_resp_nxt  ;
            m_axi_req    <= m_axi_req_nxt    ;
            m_axis_req   <= m_axis_req_nxt   ;
        end
    end

endmodule