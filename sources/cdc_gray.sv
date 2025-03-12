`include "sgbus_defines.svh"

    // The pointers are one bit wider than the actual address of the FIFO.
    // If all but the topmost bit of rd_ptr_gray and wr_ptr_gray agree, the FIFO  
    // is in a critical state. If the topmost bit is equal, the FIFO is
    // empty, otherwise it is full.

    // TODO : FIFO harzard?

module cdc_fifo_gray_src #(
     parameter  type                            data_type    = logic
    ,parameter  int                             AddrDepth    = 3            // Default 8 entries in the fifo.
    ,parameter  int                             SyncStage    = 2            // One bit synchronization stage number for gray code.
)(
     input      logic                           reset
    ,input      logic                           src_clk
    ,input      data_type                       src_data_i
    ,input      logic                           src_valid_i
    ,output     logic                           src_ready_o

    ,output     data_type [2**AddrDepth-1:0]    async_data_o
    ,output     logic [AddrDepth:0]             async_wr_ptr_o
    ,input      logic [AddrDepth:0]             async_rd_ptr_i
);

    localparam int                  PtrWidth    = AddrDepth+1       ;
    localparam logic [AddrDepth:0]  FIFOFull    = (1 << AddrDepth)  ;

    (* RAM_STYLE = "block" *)
    data_type [2**AddrDepth-1:0]    data_q                          ;
    logic [AddrDepth:0]             wr_ptr_gray                     ;
    logic [AddrDepth:0]             wr_ptr_gray_nxt                 ;
    logic [AddrDepth:0]             wr_ptr_bin                      ;
    logic [AddrDepth:0]             wr_ptr_bin_nxt                  ;
    logic [AddrDepth:0]             rd_ptr_gray                     ;
    logic [AddrDepth:0]             rd_ptr_bin                      ;

    for (genvar var_i = 0; var_i < 2**AddrDepth; var_i++) begin : gen_word
        `FFLDEN(src_clk, 0, '0, src_valid_i & src_ready_o & (wr_ptr_bin[AddrDepth-1:0] == var_i), src_data_i, data_q[var_i])
    end

    for (genvar var_i = 0; var_i < PtrWidth; var_i++) begin : gen_sync
        sync_pipe #(
             .SyncStage (SyncStage              )
            ,.ResetValue(0                      )
        ) rd_ptr_sync_pipe (
             .clk       (src_clk                )
            ,.reset     (reset                  )
            ,.din       (async_rd_ptr_i[var_i]  )
            ,.dout      (rd_ptr_gray[var_i]     )
        );
    end

    gray_to_binary #(
         .N (PtrWidth   )
    ) rd_ptr_gray_to_binary (
         .A (rd_ptr_gray)
        ,.Z (rd_ptr_bin )
    );

    gray_to_binary #(
         .N (PtrWidth   )
    ) wr_ptr_gray_to_binary (
         .A (wr_ptr_gray) 
        ,.Z (wr_ptr_bin )
    );

    binary_to_gray #(
         .N (PtrWidth       )
    ) wr_ptr_binary_to_gray (
         .A (wr_ptr_bin_nxt )
        ,.Z (wr_ptr_gray_nxt)
    );

    `FFLDEN(src_clk, reset, '0, src_valid_i & src_ready_o, wr_ptr_gray_nxt, wr_ptr_gray)
    
    assign wr_ptr_bin_nxt = wr_ptr_bin + 1                              ;
    assign async_wr_ptr_o = wr_ptr_gray                                 ;
    assign src_ready_o    = ((wr_ptr_bin ^ rd_ptr_bin) != FIFOFull)     ;
    assign async_data_o   = data_q                                      ;

endmodule


module cdc_fifo_gray_dst #(
     parameter  type                            data_type = logic
    ,parameter  int                             AddrDepth = 3
    ,parameter  int                             SyncStage = 2
)(
     input      logic                           reset
    ,input      logic                           dst_clk
    ,output     data_type                       dst_data_o
    ,output     logic                           dst_valid_o
    ,input      logic                           dst_ready_i

    ,input      data_type [2**AddrDepth-1:0]    async_data_i
    ,input      logic [AddrDepth:0]             async_wr_ptr_i
    ,output     logic [AddrDepth:0]             async_rd_ptr_o
);

    localparam int                  PtrWidth    = AddrDepth+1   ;
    localparam logic [AddrDepth:0]  FIFOEmpty   = '0            ;

    data_type                       dst_data                    ;
    logic [AddrDepth:0]             rd_ptr_gray                 ;
    logic [AddrDepth:0]             rd_ptr_gray_nxt             ;
    logic [AddrDepth:0]             rd_ptr_bin                  ;
    logic [AddrDepth:0]             rd_ptr_bin_nxt              ;
    logic [AddrDepth:0]             wr_ptr_gray                 ;
    logic [AddrDepth:0]             wr_ptr_bin                  ;

    logic   dst_valid;
    logic   dst_ready;

    for (genvar var_i = 0; var_i < PtrWidth; var_i++) begin : gen_sync
        sync_pipe #(
             .SyncStage (SyncStage              )
            ,.ResetValue(0                      )
        ) wr_ptr_sync_pipe (
             .clk       (dst_clk                )
            ,.reset     (reset                  )
            ,.din       (async_wr_ptr_i[var_i]  )
            ,.dout      (wr_ptr_gray[var_i]     )
        );
    end

    gray_to_binary #(
         .N (PtrWidth   )
    ) wr_ptr_gray_to_binary (
         .A (wr_ptr_gray)
        ,.Z (wr_ptr_bin )
    );

    gray_to_binary #(
         .N (PtrWidth       )
    ) rd_ptr_gray_to_binary (
         .A (rd_ptr_gray    )
        ,.Z (rd_ptr_bin     )
    );

    binary_to_gray #(
         .N (PtrWidth           )
    ) i_rd_ptr_gray_b2g (
         .A (rd_ptr_bin_nxt     )
        ,.Z (rd_ptr_gray_nxt    )
    );

    `FFLDEN(dst_clk, reset, '0, dst_valid & dst_ready, rd_ptr_gray_nxt, rd_ptr_gray)

    assign rd_ptr_bin_nxt  = rd_ptr_bin+1                               ;
    assign async_rd_ptr_o  = rd_ptr_gray                                ;
    assign dst_valid       = ((wr_ptr_bin ^ rd_ptr_bin) != FIFOEmpty)   ;
    assign dst_data        = async_data_i[rd_ptr_bin[AddrDepth-1:0]]    ;

    // Add a register.
    pipe_register #(
         .T         (data_type      )
        ,.Bypass    (0              )
    ) pipe_register_inst (
         .clk       (dst_clk        )
        ,.reset     (reset          )
        ,.valid_i   (dst_valid      )
        ,.ready_o   (dst_ready      )
        ,.data_i    (dst_data       )
        ,.valid_o   (dst_valid_o    )
        ,.ready_i   (dst_ready_i    )
        ,.data_o    (dst_data_o     )
    );

endmodule



module cdc_fifo #(
     parameter  type            data_type   = logic
    ,parameter  int             AddrDepth   = 3
    ,parameter  int             SyncStage   = 2
)(
     input      logic           src_reset
    ,input      logic           src_clk
    ,input      data_type       src_data_i
    ,input      logic           src_valid_i
    ,output     logic           src_ready_o

    ,input      logic           dst_reset
    ,input      logic           dst_clk
    ,output     data_type       dst_data_o
    ,output     logic           dst_valid_o
    ,input      logic           dst_ready_i
);
    (* RAM_STYLE = "block" *)
    data_type [2**AddrDepth-1:0]    async_data          ;
    logic [AddrDepth:0]             async_wr_ptr_gray   ;
    logic [AddrDepth:0]             async_rd_ptr_gray   ;

    cdc_fifo_gray_src #(
         .data_type         (data_type          )
        ,.AddrDepth         (AddrDepth          )
        ,.SyncStage         (SyncStage          )
    )cdc_fifo_gray_src_inst(
         .reset             (src_reset          )
        ,.src_clk           (src_clk            )
        ,.src_data_i        (src_data_i         )
        ,.src_valid_i       (src_valid_i        )
        ,.src_ready_o       (src_ready_o        )
        ,.async_data_o      (async_data         )
        ,.async_wr_ptr_o    (async_wr_ptr_gray  )
        ,.async_rd_ptr_i    (async_rd_ptr_gray  )
    );

    cdc_fifo_gray_dst #(
         .data_type         (data_type          )
        ,.AddrDepth         (AddrDepth          )
        ,.SyncStage         (SyncStage          )
    )cdc_fifo_gray_dst_inst(
         .reset             (dst_reset          )
        ,.dst_clk           (dst_clk            )
        ,.dst_data_o        (dst_data_o         )
        ,.dst_valid_o       (dst_valid_o        )
        ,.dst_ready_i       (dst_ready_i        )
        ,.async_data_i      (async_data         )
        ,.async_wr_ptr_i    (async_wr_ptr_gray  )
        ,.async_rd_ptr_o    (async_rd_ptr_gray  )
    );

endmodule
