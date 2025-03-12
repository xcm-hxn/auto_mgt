/*

              |- m_axi_req.aw
s_axis.req -> |- m_axi_req.w
              |- m_axi_req.ar

m_axi_resp.b -|
m_axi_resp.r -| -> m_axis.req

*/
`timescale 1ns/1ps
`include "sgbus_defines.svh"
`include "sgbus_pkgs.svh"
import sgbus_pkg::*;


module axi_engine #(
     parameter  type        axi_req_t       = logic
    ,parameter  type        axi_resp_t      = logic

    ,parameter  type        axi_aw_chnl_t   = logic
    ,parameter  type        axi_w_chnl_t    = logic
    ,parameter  type        axi_b_chnl_t    = logic
    ,parameter  type        axi_ar_chnl_t   = logic
    ,parameter  type        axi_r_chnl_t    = logic

    ,parameter  type        axis_req_t      = logic
    ,parameter  type        axis_resp_t     = logic
    ,parameter  type        axis_data_t     = logic

    ,parameter  int         MaxPayload      = 128
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

    localparam PktPtrWidth = sgbus_pkg::idx_width(MaxPayload);

    typedef logic [PktPtrWidth:0] pkt_ptr_t         ;

    pkt_ptr_t               rx_pkt_ptr              ;
    sgbus_pkg::pkt_len_t    rx_pkt_len              ;
    pkt_ptr_t               tx_pkt_ptr              ;
    sgbus_pkg::pkt_len_t    tx_pkt_len              ;

    pkt_ptr_t               rx_pkt_ptr_nxt          ;
    sgbus_pkg::pkt_len_t    rx_pkt_len_nxt          ;
    pkt_ptr_t               tx_pkt_ptr_nxt          ;
    sgbus_pkg::pkt_len_t    tx_pkt_len_nxt          ;

    sgbus_header_t          parsed_frame            ;
    sgbus_header_t          parsed_frame_reg        ;       // HACK : Used to save header data.
    logic                   axi_rd                  ;
    logic                   axi_rd_nxt              ;
    logic                   axi_wr                  ;
    logic                   axi_wr_nxt              ;
    
    logic                   aw_valid_pipe_in        ;
    logic                   aw_ready_pipe_out       ;
    axi_aw_chnl_t           aw_dat_pipe_in          ;
    logic                   aw_valid_pipe_out       ;
    logic                   aw_ready_pipe_in        ;
    axi_aw_chnl_t           aw_dat_pipe_out         ;

    logic                   w_valid_pipe_in         ;
    logic                   w_ready_pipe_out        ;
    axi_w_chnl_t            w_dat_pipe_in           ;
    logic                   w_valid_pipe_out        ;
    logic                   w_ready_pipe_in         ;
    axi_w_chnl_t            w_dat_pipe_out          ;

    logic                   b_valid_pipe_in         ;
    logic                   b_ready_pipe_out        ;
    axi_b_chnl_t            b_dat_pipe_in           ;
    logic                   b_valid_pipe_out        ;
    logic                   b_ready_pipe_in         ;
    axi_b_chnl_t            b_dat_pipe_out          ;

    logic                   ar_valid_pipe_in        ;
    logic                   ar_ready_pipe_out       ;
    // The ar channel data is splitted into two beats in sgbus stream. Use prv to save the address
    // at the first beat and assert the ar_valid_pipe_in when receiving burst_len at the second beat.
    axi_ar_chnl_t           ar_dat_pipe_in_prv      ;
    axi_ar_chnl_t           ar_dat_pipe_in          ;
    logic                   ar_valid_pipe_out       ;
    logic                   ar_ready_pipe_in        ;
    axi_ar_chnl_t           ar_dat_pipe_out         ;

    logic                   r_valid_pipe_in         ;
    logic                   r_ready_pipe_out        ;
    axi_r_chnl_t            r_dat_pipe_in           ;
    logic                   r_valid_pipe_out        ;
    logic                   r_ready_pipe_in         ;
    axi_r_chnl_t            r_dat_pipe_out          ;

    logic                   s_axis_valid_pipe_in    ;
    logic                   s_axis_ready_pipe_out   ;
    axis_data_t             s_axis_dat_pipe_in      ;
    logic                   s_axis_valid_pipe_out   ;
    logic                   s_axis_ready_pipe_in    ;
    axis_data_t             s_axis_dat_pipe_out     ;

    logic                   m_axis_valid_pipe_in    ;
    logic                   m_axis_ready_pipe_out   ;
    axis_data_t             m_axis_dat_pipe_in      ;
    logic                   m_axis_valid_pipe_out   ;
    logic                   m_axis_ready_pipe_in    ;
    axis_data_t             m_axis_dat_pipe_out     ;

    `SGBUS_HEADER_VEC_TO_STURCT(s_axis_dat_pipe_out, parsed_frame, assign)

    // TODO : The piped data needs to be flattened in VCS simulation.

    pipe_register #(
         .T         (axi_aw_chnl_t          )
        ,.Bypass    (0                      )
    )aw_pipe(
         .clk       (clk                    )
        ,.reset     (reset                  )
        ,.valid_i   (aw_valid_pipe_in       )
        ,.ready_o   (aw_ready_pipe_out      )
        ,.data_i    (aw_dat_pipe_in         )
        ,.valid_o   (aw_valid_pipe_out      )
        ,.ready_i   (aw_ready_pipe_in       )
        ,.data_o    (aw_dat_pipe_out        )
    );

    pipe_register #(
         .T         (axi_w_chnl_t           )
        ,.Bypass    (0                      )
    )w_pipe(
         .clk       (clk                    )
        ,.reset     (reset                  )
        ,.valid_i   (w_valid_pipe_in        )
        ,.ready_o   (w_ready_pipe_out       )
        ,.data_i    (w_dat_pipe_in          )
        ,.valid_o   (w_valid_pipe_out       )
        ,.ready_i   (w_ready_pipe_in        )
        ,.data_o    (w_dat_pipe_out         )
    );

    pipe_register #(
         .T         (axi_b_chnl_t           )
        ,.Bypass    (0                      )
    )b_pipe(
         .clk       (clk                    )
        ,.reset     (reset                  )
        ,.valid_i   (b_valid_pipe_in        )
        ,.ready_o   (b_ready_pipe_out       )
        ,.data_i    (b_dat_pipe_in          )
        ,.valid_o   (b_valid_pipe_out       )
        ,.ready_i   (b_ready_pipe_in        )
        ,.data_o    (b_dat_pipe_out         )
    );

    pipe_register #(
         .T         (axi_ar_chnl_t          )
        ,.Bypass    (0                      )
    )ar_pipe(
         .clk       (clk                    )
        ,.reset     (reset                  )
        ,.valid_i   (ar_valid_pipe_in       )
        ,.ready_o   (ar_ready_pipe_out      )
        ,.data_i    (ar_dat_pipe_in         )
        ,.valid_o   (ar_valid_pipe_out      )
        ,.ready_i   (ar_ready_pipe_in       )
        ,.data_o    (ar_dat_pipe_out        )
    );

    pipe_register #(
         .T         (axi_r_chnl_t           )
        ,.Bypass    (0                      )
    )r_pipe(
         .clk       (clk                    )
        ,.reset     (reset                  )
        ,.valid_i   (r_valid_pipe_in        )
        ,.ready_o   (r_ready_pipe_out       )
        ,.data_i    (r_dat_pipe_in          )
        ,.valid_o   (r_valid_pipe_out       )
        ,.ready_i   (r_ready_pipe_in        )
        ,.data_o    (r_dat_pipe_out         )
    );

    pipe_register #(
         .T         (axis_data_t            )
        ,.Bypass    (0                      )
    )s_axis_pipe(
         .clk       (clk                    )
        ,.reset     (reset                  )
        ,.valid_i   (s_axis_valid_pipe_in   )
        ,.ready_o   (s_axis_ready_pipe_out  )
        ,.data_i    (s_axis_dat_pipe_in     )
        ,.valid_o   (s_axis_valid_pipe_out  )
        ,.ready_i   (s_axis_ready_pipe_in   )
        ,.data_o    (s_axis_dat_pipe_out    )
    );

    pipe_register #(
         .T         (axis_data_t            )
        ,.Bypass    (0                      )
    )m_axis_pipe(
         .clk       (clk                    )
        ,.reset     (reset                  )
        ,.valid_i   (m_axis_valid_pipe_in   )
        ,.ready_o   (m_axis_ready_pipe_out  )
        ,.data_i    (m_axis_dat_pipe_in     )
        ,.valid_o   (m_axis_valid_pipe_out  )
        ,.ready_i   (m_axis_ready_pipe_in   )
        ,.data_o    (m_axis_dat_pipe_out    )
    );

    
    assign aw_valid_pipe_in     = axi_wr && s_axis_valid_pipe_out && (rx_pkt_ptr == rx_pkt_len) ;
    assign aw_dat_pipe_in.id    = 2'b00                                                         ;
    assign aw_dat_pipe_in.addr  = s_axis_dat_pipe_out                                           ;
    assign aw_dat_pipe_in.len   = rx_pkt_len - 2                                                ;
    assign aw_dat_pipe_in.size  = 3'b100                                                        ;
    assign aw_dat_pipe_in.burst = 2'b01                                                         ;
    assign aw_dat_pipe_in.cache = 4'b0011                                                       ;
    assign aw_dat_pipe_in.prot  = 3'b010                                                        ;
    assign aw_ready_pipe_in     = m_axi_resp.aw_ready                                           ;
    assign m_axi_req.aw_valid   = aw_valid_pipe_out                                             ;
    assign m_axi_req.aw         = aw_dat_pipe_out                                               ;

    assign w_valid_pipe_in      = axi_wr && s_axis_valid_pipe_out && rx_pkt_ptr != rx_pkt_len   ;
    assign w_dat_pipe_in.data   = s_axis_dat_pipe_out                                           ;
    assign w_dat_pipe_in.strb   = '1                                                            ;
    assign w_dat_pipe_in.last   = axi_wr && (rx_pkt_ptr == 1) && s_axis_valid_pipe_out          ;
    assign w_ready_pipe_in      = m_axi_resp.w_ready                                            ;
    assign m_axi_req.w_valid    = w_valid_pipe_out                                              ;
    assign m_axi_req.w          = w_dat_pipe_out                                                ;

    assign b_valid_pipe_in      = m_axi_resp.b_valid                                            ;
    assign b_dat_pipe_in        = m_axi_resp.b                                                  ;
    assign b_ready_pipe_in      = axi_wr && m_axis_ready_pipe_out && (tx_pkt_ptr == 1)          ;
    assign m_axi_req.b_ready    = b_ready_pipe_out                                              ;

    assign ar_valid_pipe_in     = axi_rd && s_axis_valid_pipe_out && (rx_pkt_ptr == 1)          ;
    always_ff@(posedge clk) begin
        if(axi_rd && s_axis_valid_pipe_out && (rx_pkt_ptr == 2))
            ar_dat_pipe_in_prv.addr <= s_axis_dat_pipe_out;
    end
    assign ar_dat_pipe_in.id    = 2'b00                                                         ;
    assign ar_dat_pipe_in.addr  = ar_dat_pipe_in_prv.addr                                       ;
    assign ar_dat_pipe_in.len   = s_axis_dat_pipe_out - 1                                       ;
    assign ar_dat_pipe_in.size  = 3'b100                                                        ;
    assign ar_dat_pipe_in.burst = 2'b01                                                         ;
    assign ar_dat_pipe_in.cache = 4'b0011                                                       ;
    assign ar_dat_pipe_in.prot  = 3'b010                                                        ;
    assign ar_ready_pipe_in     = m_axi_resp.ar_ready                                           ;
    assign m_axi_req.ar_valid   = ar_valid_pipe_out                                             ;
    assign m_axi_req.ar         = ar_dat_pipe_out                                               ;

    assign r_valid_pipe_in      = m_axi_resp.r_valid                                            ;
    assign r_dat_pipe_in        = m_axi_resp.r                                                  ;
    assign r_ready_pipe_in      = axi_rd && m_axis_ready_pipe_out && tx_pkt_ptr != tx_pkt_len   ;
    assign m_axi_req.r_ready    = r_ready_pipe_out                                              ;


    assign s_axis_valid_pipe_in = s_axis_req.tvalid                                             ;
    assign s_axis_dat_pipe_in   = s_axis_req.t.data                                             ;
    assign s_axis_resp.tready   = s_axis_ready_pipe_out                                         ;
    always_comb begin
        s_axis_ready_pipe_in = 1;
        // Block incoming stream if there is onging transmitting stream.
        if(tx_pkt_ptr != 0) begin
            s_axis_ready_pipe_in = 0;
        end
        else begin
            if(rx_pkt_ptr != 0) begin
                if(axi_wr) begin
                    if(rx_pkt_ptr == rx_pkt_len)
                        s_axis_ready_pipe_in = aw_ready_pipe_out;
                    else
                        s_axis_ready_pipe_in = w_ready_pipe_out;
                end
                
                if(axi_rd) begin
                    // Always receive the first beat.
                    if(rx_pkt_ptr == rx_pkt_len)
                        s_axis_ready_pipe_in = 1;
                    if(rx_pkt_ptr == rx_pkt_len - 1)
                        s_axis_ready_pipe_in = ar_ready_pipe_out;
                end
            end
        end
    end

    assign m_axis_ready_pipe_in = m_axis_resp.tready                                            ;
    assign m_axis_req.tvalid    = m_axis_valid_pipe_out                                         ;
    assign m_axis_req.t.data    = m_axis_dat_pipe_out                                           ;
    always_comb begin
        m_axis_valid_pipe_in = 0;
        m_axis_dat_pipe_in   = '0;

        if(tx_pkt_ptr != 0) begin
            if(axi_wr) begin
                if(tx_pkt_ptr == tx_pkt_len) begin
                    m_axis_valid_pipe_in = 1;
                    m_axis_dat_pipe_in   = {parsed_frame_reg[127:32], tx_pkt_len - 1};
                end
                else if(tx_pkt_ptr == 1) begin
                    m_axis_valid_pipe_in = b_valid_pipe_out;
                    m_axis_dat_pipe_in   = b_dat_pipe_out;
                end
            end
        
            if(axi_rd) begin
                if(tx_pkt_ptr == tx_pkt_len) begin
                    m_axis_valid_pipe_in = 1;
                    m_axis_dat_pipe_in   = {parsed_frame_reg[127:32], tx_pkt_len - 1};
                end
                else begin
                    m_axis_valid_pipe_in = r_valid_pipe_out;
                    m_axis_dat_pipe_in   = r_dat_pipe_out.data;
                end
            end
        end
    end
    
    // Packet data pointer.
    always_ff@(posedge clk) begin
        if(reset) begin
            rx_pkt_ptr       <= '0;
            tx_pkt_ptr       <= '0;
            rx_pkt_len       <= '0;
            tx_pkt_len       <= '0;
            axi_rd           <= 0;
            axi_wr           <= 0;
            parsed_frame_reg <= '0;
        end
        else begin
            rx_pkt_ptr  <= rx_pkt_ptr_nxt;
            tx_pkt_ptr  <= tx_pkt_ptr_nxt;
            rx_pkt_len  <= rx_pkt_len_nxt;
            tx_pkt_len  <= tx_pkt_len_nxt;
            axi_rd      <= axi_rd_nxt;
            axi_wr      <= axi_wr_nxt;
            if(s_axis_valid_pipe_out && s_axis_ready_pipe_in && rx_pkt_ptr == 0)
                parsed_frame_reg <= parsed_frame;
        end
    end

    always_comb begin
        rx_pkt_ptr_nxt = rx_pkt_ptr ;
        tx_pkt_ptr_nxt = tx_pkt_ptr ;
        rx_pkt_len_nxt = rx_pkt_len ;
        tx_pkt_len_nxt = tx_pkt_len ;
        axi_rd_nxt     = axi_rd     ;
        axi_wr_nxt     = axi_wr     ;

        if(s_axis_valid_pipe_out && s_axis_ready_pipe_in) begin
            // A new packet reveiving, initializing the receiving pointer and length.
            if(rx_pkt_ptr == 0) begin
                rx_pkt_len_nxt = parsed_frame.pkt_len[PktPtrWidth - 1 : 0];
                rx_pkt_ptr_nxt = parsed_frame.pkt_len[PktPtrWidth - 1 : 0];
                axi_rd_nxt     = parsed_frame.pkg_type_id == backdoor_axi_rd ? 1 : 0;
                axi_wr_nxt     = parsed_frame.pkg_type_id == backdoor_axi_wr ? 1 : 0;
            end
            // Consuming the receiving pointer.
            else begin
                rx_pkt_ptr_nxt = rx_pkt_ptr - 1;
            end
        end

        // Initializing the transmitting pointer and length.
        if(s_axis_valid_pipe_out && rx_pkt_ptr == 1) begin
            if(axi_wr) begin
                tx_pkt_len_nxt = 2;
                tx_pkt_ptr_nxt = 2;
            end
            else if(axi_rd) begin
                tx_pkt_len_nxt = parsed_frame.pkt_len[PktPtrWidth - 1 : 0] + 1;
                tx_pkt_ptr_nxt = parsed_frame.pkt_len[PktPtrWidth - 1 : 0] + 1;
            end
        end

        // Consuming the transmitting pointer.
        if(m_axis_valid_pipe_in && m_axis_ready_pipe_out) begin
            tx_pkt_ptr_nxt = tx_pkt_ptr - 1;
            if(tx_pkt_ptr == 1) begin
                axi_rd_nxt = 0;
                axi_wr_nxt = 0;
            end
        end

    end


endmodule