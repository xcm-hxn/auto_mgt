`include "glue_logic_define.svh"
`include "axi_lite_pkg.svh"
import axi_lite_pkg::*;

module axil_demux_core #(
    // parameter   axi_lite_pkg::axil_bridge_cfg_t    Cfg = '0    ,
    parameter   type        aw_chnl_t   = logic   ,
    parameter   type        w_chnl_t    = logic   ,
    parameter   type        b_chnl_t    = logic   ,
    parameter   type        ar_chnl_t   = logic   ,
    parameter   type        r_chnl_t    = logic   ,
    
    parameter   type        axil_req_t  = logic   ,
    parameter   type        axil_resp_t = logic   ,
    parameter   int         Outstanding = 16      ,
    parameter   int         MasterNum   = 1       ,
    parameter   type        sel_t       = logic 
    // parameter   type        sel_t       = logic [$clog2(MasterNum) - 1 : 0]
)(

    input   logic                           clk             ,
    input   logic                           reset           ,

    input   axil_req_t                      s_axil_req      ,
    output  axil_resp_t                     s_axil_resp     ,
    input   sel_t                           aw_sel          ,
    input   sel_t                           ar_sel          ,

    output  axil_req_t  [MasterNum - 1 : 0]  m_axil_req     ,
    input   axil_resp_t [MasterNum - 1 : 0]  m_axil_resp 

);

    generate 
        if(MasterNum == 'd1) begin : gen_simple_drain
            pipe_register #(
                .T      (aw_chnl_t              ),
                .Bypass (0                      )
            ) aw_pipe_inst (    
                .clk    (clk                    ),
                .reset  (reset                  ),
                .valid_i(s_axil_req.aw_valid    ),
                .ready_o(s_axil_resp.aw_ready   ),
                .data_i (s_axil_req.aw          ),
                .valid_o(m_axil_req[0].aw_valid    ),
                .ready_i(m_axil_resp[0].aw_ready   ),
                .data_o (m_axil_req[0].aw          )
            );

            // Insert latency to the w channel.
            pipe_register #(
                .T      (w_chnl_t                ),
                .Bypass (0                       )
            ) w_pipe_inst (     
                .clk    (clk                     ),
                .reset  (reset                   ),
                .valid_i(s_axil_req.w_valid      ),
                .ready_o(s_axil_resp.w_ready     ),
                .data_i (s_axil_req.w            ),
                .valid_o(m_axil_req[0].w_valid   ),
                .ready_i(m_axil_resp[0].w_ready  ),
                .data_o (m_axil_req[0].w         )
            );

            pipe_register #(
                .T      (b_chnl_t                ),
                .Bypass (0                       )
            ) b_pipe_inst (    
                .clk    (clk                     ),
                .reset  (reset                   ),
                .valid_i(m_axil_resp[0].b_valid  ),
                .ready_o(m_axil_req[0].b_ready   ),
                .data_i (m_axil_resp[0].b        ),
                .valid_o(s_axil_resp.b_valid     ),
                .ready_i(s_axil_req.b_ready      ),
                .data_o (s_axil_resp.b           )
            );

            pipe_register #(
                .T      (ar_chnl_t              ),
                .Bypass (0                      )
            ) ar_pipe_inst (    
                .clk    (clk                    ),
                .reset  (reset                  ),
                .valid_i(s_axil_req.ar_valid    ),
                .ready_o(s_axil_resp.ar_ready   ),
                .data_i (s_axil_req.ar          ),
                .valid_o(m_axil_req[0].ar_valid ),
                .ready_i(m_axil_resp[0].ar_ready),
                .data_o (m_axil_req[0].ar       )
            );

            pipe_register #(
                .T      (r_chnl_t                ),
                .Bypass (0                       )
            ) r_pipe_inst (    
                .clk    (clk                     ),
                .reset  (reset                   ),
                .valid_i(m_axil_resp[0].r_valid  ),
                .ready_o(m_axil_req[0].r_ready   ),
                .data_i (m_axil_resp[0].r        ),
                .valid_o(s_axil_resp.r_valid     ),
                .ready_i(s_axil_req.r_ready      ),
                .data_o (s_axil_resp.r           )
            );

        end
        else begin : gen_demux

            // Write transaction handling including aw/w/b channel.
            typedef struct packed {
                aw_chnl_t   aw      ;
                sel_t       sel     ;
            } aw_chnl_dat_t;

            aw_chnl_dat_t               aw_chnl_dat_pipe_in     ;
            aw_chnl_dat_t               aw_chnl_dat_pipe_out    ;   // channel data needs to be piped.

            // combinaional logic participating in inner-core transaction.
            logic                       demux_slv_aw_valid      ;
            logic                       demux_slv_aw_ready      ;
            logic   [MasterNum - 1 : 0] demux_mst_aw_valid      ;
            logic   [MasterNum - 1 : 0] demux_mst_aw_ready      ;

            logic                       demux_aw_lock_load      ;
            logic                       demux_aw_lock           ;
            logic                       demux_aw_lock_nxt       ;

            w_chnl_t                    w_chnl_dat_pipe_in      ;   
            w_chnl_t                    w_chnl_dat_pipe_out     ;   // channel data needs to be piped.

            logic                       w_fifo_push             ;
            logic                       w_fifo_pop              ;
            logic                       w_fifo_full             ;
            logic                       w_fifo_empty            ;
            sel_t                       w_sel                   ;

            logic                       demux_slv_w_valid       ;
            logic                       demux_slv_w_ready       ;

            b_chnl_t                    b_chnl_dat_pipe_in      ;
            b_chnl_t                    b_chnl_dat_pipe_out     ;   // channel data needs to be piped.

            logic                       b_fifo_push             ;
            logic                       b_fifo_pop              ;
            logic                       b_fifo_full             ;
            logic                       b_fifo_empty            ;
            sel_t                       b_sel                   ;

            logic                       demux_slv_b_valid       ;
            logic                       demux_slv_b_ready       ;

            // The decode is handled outside the demux core. However the aw_chnl_t is needed here. 
            assign  aw_chnl_dat_pipe_in = '{s_axil_req.aw, aw_sel};    

            pipe_register #(
                .T      (aw_chnl_dat_t          ),
                .Bypass (0                      )
            ) aw_pipe_inst (    
                .clk    (clk                    ),
                .reset  (reset                  ),
                .valid_i(s_axil_req.aw_valid    ),
                .ready_o(s_axil_resp.aw_ready   ),
                .data_i (aw_chnl_dat_pipe_in    ),
                .valid_o(demux_slv_aw_valid     ),
                .ready_i(demux_slv_aw_ready     ),
                .data_o (aw_chnl_dat_pipe_out   )
            );

            for(genvar var_i = 0 ; var_i < MasterNum ; var_i = var_i + 1) begin
                assign m_axil_req[var_i].aw       = aw_chnl_dat_pipe_out.aw     ;   // aw_chnl_t is shared among all the channels.
                assign m_axil_req[var_i].aw_valid = demux_mst_aw_valid[var_i]   ;
                assign demux_mst_aw_ready[var_i]  = m_axil_resp[var_i].aw_ready ;
            end

            always_comb begin
                demux_aw_lock_nxt  = demux_aw_lock   ;
                demux_aw_lock_load = 1'b0;
                demux_slv_aw_ready = 1'b0;
                demux_mst_aw_valid = 'b0;
                w_fifo_push        = 1'b0;
                // Has a pending aw handshake.
                if(demux_aw_lock) begin
                    // Continuously assert the aw_valid signal.
                    demux_mst_aw_valid[aw_chnl_dat_pipe_out.sel] = 1;
                    // Pending aw handshake closes.
                    if(demux_mst_aw_ready[aw_chnl_dat_pipe_out.sel] == 1) begin
                        demux_slv_aw_ready  = 1;        // Drain the pipe as the handshake confirmed.
                        demux_aw_lock_load  = 1;        
                        demux_aw_lock_nxt   = 0;        // Unlock the pending aw handshake and load.
                    end
                end
                // No pending.
                else begin
                    if(!w_fifo_full && demux_slv_aw_valid) begin
                        w_fifo_push = 1;
                        demux_mst_aw_valid[aw_chnl_dat_pipe_out.sel] = 1;
                        // Handshake finishes within the cycle.
                        if(demux_mst_aw_ready[aw_chnl_dat_pipe_out.sel] == 1)
                            demux_slv_aw_ready  = 1;
                        // Pend an aw handshake.
                        else begin
                            demux_aw_lock_load  = 1;
                            demux_aw_lock_nxt   = 1;
                        end
                    end
                end
            end

            `FFLDEN(clk, reset, '0, demux_aw_lock_load, demux_aw_lock_nxt, demux_aw_lock)

            // The aw channel can be seen here as the upper-stream channel of w channel,
            // thus the aw pipe output valid signal is used to push a aw selection to
            // the w channel fifo. The fifo_full signal is used for back pressure, when
            // fifo_full asserts, which means maximum outstanding transactions, block the 
            // upper-stream pipe to hold incoming aw transactions. When the w channel 
            // handshake confirms, pop the entry.
            

            fifo_sync_fallthrough #(
                .data_t     (sel_t                      ),
                .Depth      (Outstanding                ),
                .Threshold  (1                          )
            ) w_transaction_fifo (
                .clk        (clk                        ),  
                .reset      (reset                      ),
                .push       (w_fifo_push                ), 
                .pop        (w_fifo_pop                 ),  
                .din        (aw_chnl_dat_pipe_out.sel   ),  
                .dout       (w_sel                      ), 
                .full       (w_fifo_full                ), 
                .thre_full  (                           ),
                .empty      (w_fifo_empty               ),
                .status_cnt (                           )
            );

            assign w_chnl_dat_pipe_in = s_axil_req.w;   // This statement is for unified style purpose.
            
            pipe_register #(
                .T          (w_chnl_t                   ),
                .Bypass     (0                          )
            ) w_pipe_inst (     
                .clk        (clk                        ),
                .reset      (reset                      ),
                .valid_i    (s_axil_req.w_valid         ),
                .ready_o    (s_axil_resp.w_ready        ),
                .data_i     (w_chnl_dat_pipe_in         ),
                .valid_o    (demux_slv_w_valid          ),
                .ready_i    (demux_slv_w_ready          ),
                .data_o     (w_chnl_dat_pipe_out        )
            );

            for(genvar var_i = 0 ; var_i < MasterNum ; var_i = var_i + 1) begin
                assign m_axil_req[var_i].w       = w_chnl_dat_pipe_out;         // Still, the w_chnl_t is shared among all the channels.
                assign m_axil_req[var_i].w_valid = (w_sel == sel_t'(var_i)) &&  // address decode result.
                                                   demux_slv_w_valid        &&  // pipe output valid.
                                                   ~w_fifo_empty            &&  // w channel does not exceed aw channel.
                                                   ~b_fifo_full;                // pending responce at b channel does not overflow.
            end

            assign demux_slv_w_ready = m_axil_resp[w_sel].w_ready && ~w_fifo_empty && ~b_fifo_full;
            assign w_fifo_pop        = demux_slv_w_valid && demux_slv_w_ready;  // Pop an entry as the handshake confirms.

            assign b_fifo_push       = w_fifo_pop   ;

            fifo_sync_fallthrough #(
                .data_t     (sel_t              ),
                .Depth      (Outstanding        ),
                .Threshold  (1                  )
            ) b_transaction_fifo (
                .clk        (clk                ),
                .reset      (reset              ),
                .push       (b_fifo_push        ),
                .pop        (b_fifo_pop         ),
                .din        (w_sel              ),
                .dout       (b_sel              ),
                .full       (b_fifo_full        ),
                .thre_full  (                   ),
                .empty      (b_fifo_empty       ),
                .status_cnt (                   )
            );

            pipe_register #(
                .T          (b_chnl_t            ),
                .Bypass     (0                   )
            ) b_pipe_inst (    
                .clk        (clk                 ),
                .reset      (reset               ),
                .valid_i    (demux_slv_b_valid   ),
                .ready_o    (demux_slv_b_ready   ),
                .data_i     (b_chnl_dat_pipe_in  ),
                .valid_o    (s_axil_resp.b_valid ),
                .ready_i    (s_axil_req.b_ready  ),
                .data_o     (b_chnl_dat_pipe_out )
            );

            assign b_chnl_dat_pipe_in = !b_fifo_empty ? m_axil_resp[b_sel].b : b_chnl_t'(0);
            assign demux_slv_b_valid  = !b_fifo_empty ? m_axil_resp[b_sel].b_valid : 1'b0;
            for(genvar var_i = 0 ; var_i < MasterNum ; var_i = var_i + 1) begin
                assign m_axil_req[var_i].b_ready = !b_fifo_empty && demux_slv_b_ready && (b_sel == sel_t'(var_i));
            end
            assign b_fifo_pop = demux_slv_b_valid && demux_slv_b_ready;
            assign s_axil_resp.b = b_chnl_dat_pipe_out;

            // Read transaction handling including ar/r channel.
            typedef struct packed {
                ar_chnl_t   ar      ;
                sel_t       sel     ;
            } ar_chnl_dat_t;

            ar_chnl_dat_t               ar_chnl_dat_pipe_in     ;
            ar_chnl_dat_t               ar_chnl_dat_pipe_out    ;

            logic                       demux_slv_ar_valid      ;
            logic                       demux_slv_ar_ready      ;
            logic   [MasterNum - 1 : 0] demux_mst_ar_valid      ;
            logic   [MasterNum - 1 : 0] demux_mst_ar_ready      ;

            logic                       demux_ar_lock_load      ;
            logic                       demux_ar_lock           ;
            logic                       demux_ar_lock_nxt       ;       

            r_chnl_t                    r_chnl_dat_pipe_in      ;
            r_chnl_t                    r_chnl_dat_pipe_out     ;

            logic                       demux_slv_r_valid       ;
            logic                       demux_slv_r_ready       ;
            logic                       r_fifo_push             ;
            logic                       r_fifo_pop              ;
            logic                       r_fifo_full             ;
            logic                       r_fifo_empty            ;
            sel_t                       r_sel                   ;

            assign ar_chnl_dat_pipe_in = '{s_axil_req.ar, ar_sel};

            // ar channel is similar to aw channel.
            pipe_register #(
                .T      (ar_chnl_dat_t          ),
                .Bypass (0                      )
            ) ar_pipe_inst (    
                .clk    (clk                    ),
                .reset  (reset                  ),
                .valid_i(s_axil_req.ar_valid    ),
                .ready_o(s_axil_resp.ar_ready   ),
                .data_i (ar_chnl_dat_pipe_in    ),
                .valid_o(demux_slv_ar_valid     ),
                .ready_i(demux_slv_ar_ready     ),
                .data_o (ar_chnl_dat_pipe_out   )
            );

            for(genvar var_i = 0 ; var_i < MasterNum ; var_i = var_i + 1) begin
                assign m_axil_req[var_i].ar       = ar_chnl_dat_pipe_out.ar     ;   // ar_chnl_t is shared among all the channels.
                assign m_axil_req[var_i].ar_valid = demux_mst_ar_valid[var_i]  ;
                assign demux_mst_ar_ready[var_i]  = m_axil_resp[var_i].ar_ready ;
            end

            always_comb begin
                demux_ar_lock_nxt  = demux_ar_lock;
                demux_ar_lock_load = 1'b0;
                demux_slv_ar_ready = 1'b0;
                demux_mst_ar_valid = 'b0;
                // Has a pending ar handshake.
                if(demux_ar_lock) begin
                    // Continuously assert the ar_valid signal.
                    demux_mst_ar_valid[ar_chnl_dat_pipe_out.sel] = 1'b1;    
                    // Pending handshake closes.
                    if(demux_mst_ar_ready[ar_chnl_dat_pipe_out.sel] == 1'b1) begin
                        demux_ar_lock_nxt  = 1'b0;
                        demux_ar_lock_load = 1'b1;  // Unlock and load.
                        demux_slv_ar_ready = 1'b1;  // Drain the pipe.
                    end 
                end
                else begin
                    // r_fifo could take in more outstanding transactions and new transaction incoming.
                    if(!r_fifo_full && demux_slv_ar_valid) begin
                        demux_mst_ar_valid[ar_chnl_dat_pipe_out.sel] = 1'b1;
                        if(demux_mst_ar_ready[ar_chnl_dat_pipe_out.sel] == 1'b1) 
                            demux_slv_ar_ready = 1'b1;
                        else begin
                            demux_ar_lock_nxt  = 1'b0;
                            demux_ar_lock_load = 1'b1;
                        end
                    end
                end
            end

            `FFLDEN(clk, reset, 'b0, demux_ar_lock_load, demux_ar_lock_nxt, demux_ar_lock)

            fifo_sync_fallthrough #(
                .data_t     (sel_t                      ),
                .Depth      (Outstanding                ),
                .Threshold  (1                          )
            ) r_transaction_fifo (
                .clk        (clk                        ),  
                .reset      (reset                      ),
                .push       (r_fifo_push                ), 
                .pop        (r_fifo_pop                 ),  
                .din        (ar_chnl_dat_pipe_out.sel   ),  
                .dout       (r_sel                      ), 
                .full       (r_fifo_full                ), 
                .thre_full  (                           ),
                .empty      (r_fifo_empty               ),
                .status_cnt (                           )
            );

            pipe_register #(
                .T          (r_chnl_t                   ),
                .Bypass     (0                          )
            ) r_pipe_inst (    
                .clk        (clk                        ),
                .reset      (reset                      ),
                .valid_i    (demux_slv_r_valid          ),
                .ready_o    (demux_slv_r_ready          ),
                .data_i     (r_chnl_dat_pipe_in         ),
                .valid_o    (s_axil_resp.r_valid        ),
                .ready_i    (s_axil_req.r_ready         ),
                .data_o     (r_chnl_dat_pipe_out        )
            );

            assign demux_slv_r_valid  = !r_fifo_empty ? m_axil_resp[r_sel].r_valid : 1'b0;
            assign r_chnl_dat_pipe_in = !r_fifo_empty ? m_axil_resp[r_sel].r : r_chnl_t'(0);
            for(genvar var_i = 0 ; var_i < MasterNum ; var_i = var_i + 1) begin
                assign m_axil_req[var_i].r_ready = !r_fifo_empty && demux_slv_r_ready && (r_sel == sel_t'(var_i));
            end
            assign r_fifo_push = demux_slv_ar_valid && demux_slv_ar_ready;     // Push a transaction to the r_fifo.
            assign r_fifo_pop = demux_slv_r_valid && demux_slv_r_ready;
            assign s_axil_resp.r = r_chnl_dat_pipe_out;

        end // End of gen_demux

    endgenerate



endmodule 

`include "glue_logic_define.svh"
`include "axi_lite_pkg.svh"
import axi_lite_pkg::*;

module axil_demux_intf #(
    parameter   axi_lite_pkg::axil_demux_cfg_t      Cfg         = '0    ,
    parameter   type                                rule_t      = logic ,
    parameter   rule_t  [Cfg.master_num - 1 : 0]    AddrMap     = '0    ,
    parameter   int                                 Outstanding =  0    ,
    parameter   type                                axil_addr_t = logic ,
    parameter   type                                axil_data_t = logic ,
    parameter   type                                axil_strb_t = logic 
)(
    input       logic                               clk             ,
    input       logic                               reset           ,
    axi_lite_intf.s                                 s_axil          ,
    axi_lite_intf.m                                 m_axil [Cfg.master_num - 1 : 0]   
);

    function automatic integer unsigned idx_width (input integer unsigned num_idx);
        return (num_idx > 32'd1) ? unsigned'($clog2(num_idx)) : 32'd1;
    endfunction

    // typedef logic [Cfg.addr_width - 1 : 0]             addr_t  ;
    // typedef logic [Cfg.data_width - 1 : 0]             data_t  ;
    // typedef logic [Cfg.data_width/8 - 1  : 0]          strb_t  ;

    typedef logic [idx_width(Cfg.master_num) - 1 : 0]  index_t ;

    `AXIL_TYPEDEF_AW_CHNL_T(aw_chnl_t, axil_addr_t)
    `AXIL_TYPEDEF_W_CHNL_T(w_chnl_t, axil_data_t, axil_strb_t)
    `AXIL_TYPEDEF_B_CHNL_T(b_chnl_t)
    `AXIL_TYPEDEF_AR_CHNL_T(ar_chnl_t, axil_addr_t)
    `AXIL_TYPEDEF_R_CHNL_T(r_chnl_t, axil_data_t)

    `AXIL_TYPEDEF_REQ_T(axil_req_t, aw_chnl_t, w_chnl_t, ar_chnl_t)
    `AXIL_TYPEDEF_RESP_T(axil_resp_t, b_chnl_t, r_chnl_t)

    axil_req_t   [Cfg.master_num - 1 : 0]       m_axil_req  ;
    axil_resp_t  [Cfg.master_num - 1 : 0]       m_axil_resp ;
    axil_req_t                                  s_axil_req  ;
    axil_resp_t                                 s_axil_resp ;

    index_t                                     aw_sel      ;
    (* KEEP = "TRUE" *)
    logic                                       aw_sel_valid; 
    index_t                                     ar_sel      ;
    (* KEEP = "TRUE" *)
    logic                                       ar_sel_valid;   // TODO : Does the address decode result need to be checked?

    `AXIL_ASSIGN_REQ_INTF_TO_STRUCT(s_axil_req, s_axil)
    `AXIL_ASSIGN_RESP_STRUCT_TO_INTF(s_axil, s_axil_resp)

    for(genvar var_i = 0 ; var_i < Cfg.master_num ; var_i = var_i + 1) begin
        `AXIL_ASSIGN_REQ_STRUCT_TO_INTF(m_axil[var_i], m_axil_req[var_i])
        `AXIL_ASSIGN_RESP_INTF_TO_STRUCT(m_axil_resp[var_i], m_axil[var_i])
    end

    `ifndef SIM
    (* DONT_TOUCH = "TRUE" *)
    address_decode #(
        .Napot              (1                  ),
        .AddrNum            (Cfg.master_num     ),
        .rule_t             (rule_t             ),
        .AddrMap            (AddrMap            ),
        .addr_t             (axil_addr_t        ),
        .index_t            (index_t            )
    ) axil_aw_decode_inst (
        .slv_addr           (s_axil_req.aw.addr ),
        .slv_sel            (aw_sel             ),
        .slv_sel_valid      (aw_sel_valid       ),
        .slv_sel_error      (                   )
    );

    (* DONT_TOUCH = "TRUE" *)
    address_decode #(
        .Napot              (1                  ),
        .AddrNum            (Cfg.master_num     ),
        .rule_t             (rule_t             ),
        .AddrMap            (AddrMap            ),
        .addr_t             (axil_addr_t        ),
        .index_t            (index_t            )
    ) axil_ar_decode_inst (
        .slv_addr           (s_axil_req.ar.addr ),
        .slv_sel            (ar_sel             ),
        .slv_sel_valid      (ar_sel_valid       ),
        .slv_sel_error      (                   )
    );
    `else
    assign aw_sel = 1;
    assign ar_sel = 1;
    `endif

    (* DONT_TOUCH = "TRUE" *)
    axil_demux_core #(
        .aw_chnl_t      (aw_chnl_t      ),  
        .w_chnl_t       (w_chnl_t       ),   
        .b_chnl_t       (b_chnl_t       ),   
        .ar_chnl_t      (ar_chnl_t      ),  
        .r_chnl_t       (r_chnl_t       ),   
        .axil_req_t     (axil_req_t     ), 
        .axil_resp_t    (axil_resp_t    ),
        .Outstanding    (Outstanding    ),
        .MasterNum      (Cfg.master_num ),
        .sel_t          (index_t        )
    ) axil_demux_core_inst (
        .clk            (clk            ),
        .reset          (reset          ),
        .s_axil_req     (s_axil_req     ),
        .s_axil_resp    (s_axil_resp    ),
        .aw_sel         (aw_sel         ),
        .ar_sel         (ar_sel         ),
        .m_axil_req     (m_axil_req     ),
        .m_axil_resp    (m_axil_resp    )
    );


endmodule
