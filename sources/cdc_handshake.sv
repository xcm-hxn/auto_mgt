`include "glue_logic_define.svh"

module cdc_handshake_src #(
    parameter   type    data_t      = logic     ,
    parameter   int     SyncStage   = 2         ,
    parameter   bit     RegOut      = 1   
)(  
    input       logic   src_clk                 ,
    input       logic   reset                   ,
    input       data_t  src_data_i              ,   
    input       logic   src_valid_i             ,   // From src
    output      data_t  src_hs_data_o           ,   
    output      logic   src_hs_valid_o          ,   // To dest
    output      logic   src_ready_o             ,   // To src
    input       logic   dest_hs_ready_i             // From dest
);

    //generate : gen_output
    //    if(RegOut) begin
    //        `FF(src_clk, src_data_i, src_hs_data_o)
    //    end
    //    else begin
            assign src_hs_data_o = src_data_i;
    //    end
    //endgenerate

    (* ASYNC_REG = "TRUE" *) 
    logic                               dest_ready_async    ;
    logic [$clog2(SyncStage) - 1 : 0]   dest_ready_cnt      ;

    logic                               src_hs_valid_o_nxt  ;

    logic                               dest_hs_lock = 0    ;
    logic                               dest_hs_lock_nxt    ;
    logic                               dest_hs_lock_load   ;

    logic                               src_hs_lock = 0     ;
    logic                               src_hs_lock_nxt     ;
    logic                               src_hs_lock_load    ;

    `FF(src_clk, dest_hs_ready_i, dest_ready_async)
    // FIX : registered output handshake signal.
    `FF(src_clk, src_hs_valid_o_nxt, src_hs_valid_o)

    always_ff@(posedge src_clk) begin
        if(dest_ready_async && !src_hs_lock && dest_hs_lock) begin
            if(dest_ready_cnt == SyncStage)
                dest_ready_cnt <= dest_ready_cnt;
            else
                dest_ready_cnt <= dest_ready_cnt + 1;
        end
        else
            dest_ready_cnt <= 'd0;
    end    

    always_comb begin
        dest_hs_lock_nxt    = dest_hs_lock;
        dest_hs_lock_load   = 0;
        src_hs_valid_o_nxt  = 0;

        if(dest_hs_lock) begin
            src_hs_valid_o_nxt = 1;
            if(dest_ready_cnt == SyncStage) begin
                dest_hs_lock_load   = 1;
                dest_hs_lock_nxt    = 0;
                src_hs_valid_o_nxt  = 0;
            end
        end
        else begin
            if(!src_hs_lock && src_valid_i) begin
                dest_hs_lock_load   = 1;
                dest_hs_lock_nxt    = 1;
            end
        end

    end

    // Use a source side ready-valid handshake lock to avoid 
    // potential problem caused by over-assert. So the source 
    // valid signal must de-assert for at least one cycle.
    always_comb begin
        src_hs_lock_nxt   = src_hs_lock;
        src_hs_lock_load  = 0;
        src_ready_o       = 0;

        if(src_hs_lock) begin
            if(!src_valid_i) begin
                src_hs_lock_nxt  = 0;
                src_hs_lock_load = 1;
            end
        end
        else begin
            if(dest_ready_cnt == SyncStage) begin
                src_ready_o       = 1;
                src_hs_lock_nxt   = 1;
                src_hs_lock_load  = 1;
            end
        end
    end

    `FFLDEN_AUTO(src_clk, reset, 0, dest_hs)
    `FFLDEN_AUTO(src_clk, reset, 0, src_hs)


endmodule


module cdc_handshake_dest #(
    parameter   type    data_t      = logic     ,
    parameter   int     SyncStage   = 2         ,
    parameter   bit     RegOut      = 1   
)(
    input       logic   dest_clk                ,
    input       logic   reset                   ,
    input       data_t  src_hs_data_i           ,   
    input       logic   src_hs_valid_i          ,   // From src
    output      logic   dest_hs_ready_o         ,   // To src
    input       logic   dest_ready_i            ,   // From dest
    output      data_t  dest_data_o             ,
    output      logic   dest_valid_o                // To dest
);

    //generate : gen_output
    //    if(RegOut) begin
    //        `FF(dest_clk, src_hs_data_i, dest_data_o)
    //    end
    //    else begin
            assign dest_data_o = src_hs_data_i;
    //    end
    //endgenerate

    (* ASYNC_REG = "TRUE" *) 
    reg                                 src_valid_async     ;
    logic [$clog2(SyncStage) - 1 : 0]   src_valid_cnt       ;

    logic                               dest_hs_ready_o_nxt ;

    logic                               dest_hs_lock = 0    ;
    logic                               dest_hs_lock_nxt    ;
    logic                               dest_hs_lock_load   ;

    logic                               src_hs_lock = 0     ;
    logic                               src_hs_lock_nxt     ;
    logic                               src_hs_lock_load    ;

    `FF(dest_clk, src_hs_valid_i, src_valid_async)
    // FIX : registered output handshake signal.
    `FF(dest_clk, dest_hs_ready_o_nxt, dest_hs_ready_o)

    always_ff@(posedge dest_clk) begin
        if(src_valid_async && !src_hs_lock && !dest_hs_lock)
            if(src_valid_cnt == SyncStage)
                src_valid_cnt <= src_valid_cnt;
            else
                src_valid_cnt <= src_valid_cnt + 1;
        else
            src_valid_cnt <= 0;
    end

    always_comb begin
        dest_hs_lock_nxt  = dest_hs_lock;
        dest_hs_lock_load = 0;
        dest_valid_o      = 0;

        if(dest_hs_lock) begin
            dest_valid_o = 1;
            if(dest_ready_i) begin
                dest_hs_lock_nxt  = 0;
                dest_hs_lock_load = 1;               
            end
        end
        else begin
            if(src_valid_cnt == SyncStage && !src_hs_lock) begin
                dest_valid_o = 1;
                if(!dest_ready_i) begin
                    dest_hs_lock_nxt  = 1;
                    dest_hs_lock_load = 1;
                end
            end
        end
    end

    always_comb begin
        src_hs_lock_nxt     = src_hs_lock;
        src_hs_lock_load    = 0;
        dest_hs_ready_o_nxt = 0;

        if(src_hs_lock) begin
            dest_hs_ready_o_nxt = 1;
            if(!src_valid_async) begin
                src_hs_lock_nxt   = 0;
                src_hs_lock_load  = 1;
            end
        end
        else begin
            if(dest_ready_i && dest_valid_o) begin
                // destination side handshake finishes, lock the
                // dest-src handshake process and assert ready.
                dest_hs_ready_o_nxt = 1;
                src_hs_lock_nxt     = 1;
                src_hs_lock_load    = 1;
            end
        end
    end

    `FFLDEN_AUTO(dest_clk, reset, 0, dest_hs)
    `FFLDEN_AUTO(dest_clk, reset, 0, src_hs)

endmodule

module cdc_handhshake #(
    parameter   type    data_t      = logic ,
    parameter   int     SyncStage   = 2
)(
    input       logic   src_clk             ,
    input       logic   dest_clk            ,

    input       data_t  src_data_i          ,
    output      data_t  dest_data_o         ,

    input       logic   src_valid_i         ,
    output      logic   src_ready_o         ,
    output      logic   dest_valid_o        ,
    input       logic   dest_ready_i 
);


    (* DONT_TOUCH = "TRUE" *)logic   internal_src_vaild  ;
    (* DONT_TOUCH = "TRUE" *)logic   internal_dest_ready ;
    (* DONT_TOUCH = "TRUE" *)data_t  internal_data       ;

    cdc_handshake_src #(
        .data_t         (data_t                 ),
        .SyncStage      (SyncStage              ),
        .RegOut         (1                      )   
    )cdc_handshake_src_inst(
        .src_clk        (src_clk                ),     
        .reset          (1'b0                   ),
        .src_data_i     (src_data_i             ),  
        .src_valid_i    (src_valid_i            ), 
        .src_hs_data_o  (internal_data          ),  
        .src_hs_valid_o (internal_src_vaild     ), 
        .src_ready_o    (src_ready_o            ), 
        .dest_hs_ready_i(internal_dest_ready    )
    );

    cdc_handshake_dest #(
        .data_t         (data_t                 ),
        .SyncStage      (SyncStage              ),
        .RegOut         (1                      )   
    )cdc_handshake_dest_inst(
        .dest_clk       (dest_clk               ),     
        .reset          (1'b0                   ),
        .src_hs_data_i  (internal_data          ),  
        .src_hs_valid_i (internal_src_vaild     ), 
        .dest_hs_ready_o(internal_dest_ready    ),  
        .dest_ready_i   (dest_ready_i           ), 
        .dest_data_o    (dest_data_o            ), 
        .dest_valid_o   (dest_valid_o           )
    );

endmodule