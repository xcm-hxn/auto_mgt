// Specified for aurora sgbus stream.
`include "sgbus_pkgs.svh"
`include "sgbus_defines.svh"
import sgbus_pkg::*;

module stream_demux #(
     parameter  type            axis_req_t  = logic  
    ,parameter  type            axis_resp_t = logic
    ,parameter  type            payload_t   = logic
    ,parameter  type            sel_t       = logic
    ,parameter  int             MasterNum   = 3       
)(
     input      logic           clk
    ,input      logic           reset
    
    ,input      axis_req_t      s_axis_req
    ,output     axis_resp_t     s_axis_resp

    ,input      sel_t           mst_sel

    ,output     axis_req_t      m_axis_req[MasterNum]
    ,input      axis_resp_t     m_axis_resp[MasterNum]
);

    typedef struct packed {
        payload_t   t       ;
        sel_t       sel     ;
    } t_chnl_dat_t;
    
    t_chnl_dat_t                t_chnl_pipe_in      ;
    t_chnl_dat_t                t_chnl_pipe_out     ;
    logic                       demux_slv_tvalid    ;
    logic                       demux_slv_tready    ;
    logic   [MasterNum - 1 : 0] demux_mst_tvalid    ;
    logic   [MasterNum - 1 : 0] demux_mst_tready    ;

    assign t_chnl_pipe_in = '{s_axis_req.t, mst_sel};
    
    pipe_register #(
         .T          (t_chnl_dat_t          )
        ,.Bypass     (0                     )
    )pipe_register_slv_sel(
         .clk        (clk                   )
        ,.reset      (reset                 )
        ,.valid_i    (s_axis_req.tvalid     )
        ,.ready_o    (s_axis_resp.tready    )
        ,.data_i     (t_chnl_pipe_in        )
        ,.valid_o    (demux_slv_tvalid      )
        ,.ready_i    (demux_slv_tready      )
        ,.data_o     (t_chnl_pipe_out       )
    );

    `PROC_LOCK_FF(demux, clk, reset)

    always_comb begin
        `PROC_INIT(demux)

        demux_slv_tready = '0;
        demux_mst_tvalid = '0;

        if(demux_lock) begin
            demux_mst_tvalid[t_chnl_pipe_out.sel] = 1;
            if(demux_mst_tready[t_chnl_pipe_out.sel]) begin
                demux_slv_tready = 1;
                `PROC_UNLOCK(demux)
            end
        end
        else begin
            if(demux_slv_tvalid) begin
                demux_mst_tvalid[t_chnl_pipe_out.sel] = 1;
                if(demux_mst_tready[t_chnl_pipe_out.sel]) begin
                    demux_slv_tready = 1;
                end
                else begin
                    `PROC_LOCK(demux)
                end
            end
        end
        
    end

    generate
        for(genvar var_i = 0 ; var_i < MasterNum ; var_i = var_i + 1) begin
            assign m_axis_req[var_i].t      = t_chnl_pipe_out.t         ;
            assign m_axis_req[var_i].tvalid = demux_mst_tvalid[var_i]   ;
            assign demux_mst_tready[var_i]  = m_axis_resp[var_i].tready ;
        end
    endgenerate

endmodule