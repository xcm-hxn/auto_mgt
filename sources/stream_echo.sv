`include "sgbus_defines.svh"

module stream_echo #(
     parameter  type        axis_req_t      = logic
    ,parameter  type        axis_resp_t     = logic
    ,parameter  type        axis_data_t     = logic

    ,parameter  int         MaxPayload      = 4
)(
     input      logic       clk
    ,input      logic       reset

    ,input      axis_req_t  s_axis_req
    ,output     axis_resp_t s_axis_resp

    ,output     axis_req_t  m_axis_req
    ,input      axis_resp_t m_axis_resp
);


    localparam PktPtrWidth = sgbus_pkg::idx_width(MaxPayload);

    typedef logic [PktPtrWidth:0] pkt_ptr_t     ;

    pkt_ptr_t           rx_pkt_ptr              ;
    pkt_ptr_t           rx_pkt_len              ;
    pkt_ptr_t           tx_pkt_ptr              ;
    pkt_ptr_t           tx_pkt_len              ;

    pkt_ptr_t           rx_pkt_ptr_nxt          ;
    pkt_ptr_t           rx_pkt_len_nxt          ;
    pkt_ptr_t           tx_pkt_ptr_nxt          ;
    pkt_ptr_t           tx_pkt_len_nxt          ;

    sgbus_header_t      parsed_frame            ;
    
    axis_data_t         fifo_din                ;
    axis_data_t         fifo_dout               ;
    logic               fifo_valid_i            ;
    logic               fifo_ready_o            ;
    logic               fifo_valid_o            ;
    logic               fifo_ready_i            ;
   
    logic               s_axis_valid_pipe_in    ;
    logic               s_axis_ready_pipe_out   ;
    axis_data_t         s_axis_dat_pipe_in      ;
    logic               s_axis_valid_pipe_out   ;
    logic               s_axis_ready_pipe_in    ;
    axis_data_t         s_axis_dat_pipe_out     ;

    logic               m_axis_valid_pipe_in    ;
    logic               m_axis_ready_pipe_out   ;
    axis_data_t         m_axis_dat_pipe_in      ;
    logic               m_axis_valid_pipe_out   ;
    logic               m_axis_ready_pipe_in    ;
    axis_data_t         m_axis_dat_pipe_out     ;

    `SGBUS_HEADER_VEC_TO_STURCT(s_axis_dat_pipe_out, parsed_frame, assign)

    stream_fifo #(
         .Depth     (MaxPayload             )
        ,.data_t    (axis_data_t            )
    )stream_fifo_inst(
         .clk       (clk                    )
        ,.reset     (reset                  )
        ,.din       (fifo_din               )
        ,.dout      (fifo_dout              )
        ,.valid_i   (fifo_valid_i           )
        ,.ready_o   (fifo_ready_o           )
        ,.valid_o   (fifo_valid_o           )
        ,.ready_i   (fifo_ready_i           )
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

    assign fifo_din                     = s_axis_dat_pipe_out               ;
    assign fifo_valid_i                 = s_axis_valid_pipe_out             ;
    assign fifo_ready_i                 = m_axis_ready_pipe_out && 
                                          tx_pkt_ptr != 0                   ;
    
    assign s_axis_ready_pipe_in         = fifo_ready_o && 
                                          tx_pkt_ptr == 0                   ;
    assign s_axis_valid_pipe_in         = s_axis_req.tvalid                 ;
    assign s_axis_dat_pipe_in           = s_axis_req.t.data                 ;

    assign m_axis_valid_pipe_in         = fifo_valid_o && 
                                          tx_pkt_ptr != 0                   ;
    assign m_axis_dat_pipe_in           = fifo_dout                         ;
    assign m_axis_ready_pipe_in         = m_axis_resp.tready && 
                                          rx_pkt_ptr == 0                   ;

    assign s_axis_resp.tready           = s_axis_ready_pipe_out             ;
    assign m_axis_req.tvalid            = m_axis_valid_pipe_out             ;
    assign m_axis_req.t.data            = m_axis_dat_pipe_out               ;

    // Packet data pointer
    always_ff@(posedge clk) begin
        if(reset) begin
            rx_pkt_ptr  <= '0;
            tx_pkt_ptr  <= '0;
            rx_pkt_len  <= '0;
            tx_pkt_len  <= '0;
        end
        else begin
            rx_pkt_ptr  <= rx_pkt_ptr_nxt;
            tx_pkt_ptr  <= tx_pkt_ptr_nxt;
            rx_pkt_len  <= rx_pkt_len_nxt;
            tx_pkt_len  <= tx_pkt_len_nxt;
        end
    end

    always_comb begin
        rx_pkt_ptr_nxt = rx_pkt_ptr ;
        tx_pkt_ptr_nxt = tx_pkt_ptr ;
        rx_pkt_len_nxt = rx_pkt_len ;
        tx_pkt_len_nxt = tx_pkt_len ;

        if(s_axis_valid_pipe_out && s_axis_ready_pipe_in) begin
            // A new packet reveiving, initializing the receiving pointer and length.
            if(rx_pkt_ptr == 0) begin
                rx_pkt_len_nxt = parsed_frame.pkt_len[PktPtrWidth - 1 : 0];
                rx_pkt_ptr_nxt = parsed_frame.pkt_len[PktPtrWidth - 1 : 0];
            end
            // Consuming the receiving pointer.
            else begin
                rx_pkt_ptr_nxt = rx_pkt_ptr - 1;
            end
        end

        // Initializing the transmitting pointer and length.
        if(s_axis_valid_pipe_out && rx_pkt_ptr == 1) begin
            tx_pkt_len_nxt = rx_pkt_len + 1;
            tx_pkt_ptr_nxt = rx_pkt_len + 1;
        end

        // Consuming the transmitting pointer.
        if(m_axis_valid_pipe_in && m_axis_ready_pipe_out) begin
            tx_pkt_ptr_nxt = tx_pkt_ptr - 1;
        end
        
    end

endmodule