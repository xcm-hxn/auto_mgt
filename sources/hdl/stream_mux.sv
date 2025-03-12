`include "sgbus_pkgs.svh"
`include "sgbus_defines.svh"
import sgbus_pkg::*;

module stream_mux #(
     parameter  type            axis_req_t  = logic  
    ,parameter  type            axis_resp_t = logic
    ,parameter  type            payload_t   = logic
    ,parameter  type            sel_t       = logic
    ,parameter  int             SlaveNum    = 3    
)(
     input      logic           clk
    ,input      logic           reset

    ,input      axis_req_t      s_axis_req[SlaveNum]
    ,output     axis_resp_t     s_axis_resp[SlaveNum]

    ,input      sel_t           slv_sel

    ,output     axis_req_t      m_axis_req
    ,input      axis_resp_t     m_axis_resp
);

    logic   [SlaveNum-1:0]      mux_slv_ready   ;

    logic                       valid_pipe_in   ;
    logic                       ready_pipe_out  ;
    payload_t                   dat_pipe_in     ;
    logic                       valid_pipe_out  ;
    logic                       ready_pipe_in   ;
    payload_t                   dat_pipe_out    ;

    pipe_register #(
         .T          (payload_t         )
        ,.Bypass     (0                 )
    )pipe_register_slv_sel(
         .clk        (clk               )
        ,.reset      (reset             )
        ,.valid_i    (valid_pipe_in     )
        ,.ready_o    (ready_pipe_out    )
        ,.data_i     (dat_pipe_in       )
        ,.valid_o    (valid_pipe_out    )
        ,.ready_i    (ready_pipe_in     )
        ,.data_o     (dat_pipe_out      )
    );

    assign valid_pipe_in                = s_axis_req[slv_sel].tvalid    ;
    assign dat_pipe_in                  = s_axis_req[slv_sel].t.data    ;
    assign m_axis_req.tvalid            = valid_pipe_out                ;
    assign ready_pipe_in                = m_axis_resp.tready            ;
    assign m_axis_req.t.data            = dat_pipe_out                  ;
    always_comb begin
        mux_slv_ready = '0;
        if(ready_pipe_out) begin
            mux_slv_ready[slv_sel] = 1;
        end
    end
    for(genvar var_i = 0 ; var_i < SlaveNum ; var_i++) begin
        assign s_axis_resp[var_i].tready = mux_slv_ready[var_i];
    end

endmodule