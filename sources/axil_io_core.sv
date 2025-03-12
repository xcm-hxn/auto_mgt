module io_core #(
    parameter bit WriteAccess       = 1     ,
    parameter bit ReadAccess        = 1     ,
    parameter bit PortInput         = 1     ,
    parameter bit PortOutput        = 1     ,
    parameter int GPIOWidth         = 32    ,
    parameter int DefaultValue      = 0     ,
    parameter bit DefaultTriState   = 1     
    
)(
    input  logic clk,
    input  logic reset,

    input  logic [GPIOWidth-1:0] io_i,
    output logic [GPIOWidth-1:0] io_o,
    output logic [GPIOWidth-1:0] io_t,

    input  logic rd_en,
    input  logic wr_en,
    
    input  logic [GPIOWidth-1:0] value_i,
    output logic [GPIOWidth-1:0] value_o
);

    logic [GPIOWidth-1:0] io_reg;


    // TODO : 1. finish bidirectional port 
    //        2. Opt the read process and clarify the write/read access.
    generate
        // if (PortInput && PortOutput) begin : BidirectionPort

        //     always_ff @(posedge clk) begin
        //         if (reset) begin
        //             io_reg <= DefaultValue;
        //         end else if (wr_en && WriteAccess) begin
        //             io_reg <= value_i;
        //         end
        //     end

        //     assign io_o = io_reg;  // Output the value from io_reg
        //     assign io_t = (wr_en && WriteAccess) ? '0 : '1; // Tri-state control
        //     assign value_o = (rd_en && ReadAccess) ? io_i : '0; // Read from io_i if enabled
        // end

        if (PortInput && !PortOutput) begin : InputPort
            assign io_t = '1; // Set to high impedance
            assign value_o =  io_i; // Read from io_i if enabled
        end

        else if (!PortInput && PortOutput) begin : OutputPort

            always_ff @(posedge clk) begin
                if (reset) begin
                    io_reg <= DefaultValue;
                end else if (wr_en && WriteAccess) begin
                    io_reg <= value_i;
                end
            end

            assign value_o = io_reg;
            assign io_o = io_reg; 
            assign io_t = '0; // Always drive the output
        end

        else begin : SimpleReg

            always_ff @(posedge clk) begin
                if (reset) begin
                    io_reg <= DefaultValue;
                end else if (wr_en && WriteAccess) begin
                    io_reg <= value_i;
                end
            end

            assign value_o = io_reg;
        end

    endgenerate

endmodule

module s_axi_gpio #(
    parameter type                              axil_req_t      = logic ,
    parameter type                              axil_resp_t     = logic ,

    parameter bit                               WriteAccess     = 0     ,
    parameter bit                               ReadAccess      = 0     ,
    parameter bit                               PortInput       = 0     ,
    parameter bit                               PortOutput      = 0     ,
    parameter int                               DefaultValue    = 0     ,
    parameter bit                               DefaultTriState = 0     ,
    parameter int                               GPIOWidth       = 1     
)(
    input   logic                               clk                     ,
    input   logic                               reset                   ,
    input   axil_req_t                          s_axil_req              ,
    output  axil_resp_t                         s_axil_resp             ,
    input   logic   [GPIOWidth-1:0]             io_i                    ,
    output  logic   [GPIOWidth-1:0]             io_o                    ,
    output  logic   [GPIOWidth-1:0]             io_t                    
);
    
    axil_resp_t                         s_axil_resp_nxt ;
    logic                               wr_en           ;
    logic                               wr_en_nxt       ;
    logic   [GPIOWidth-1:0]             value_i         ;
    logic   [GPIOWidth-1:0]             value_i_nxt     ;
    logic   [GPIOWidth-1:0]             value_o         ;

    `FF(clk, s_axil_resp_nxt, s_axil_resp)
    `FF(clk, wr_en_nxt, wr_en)
    `FF(clk, value_i_nxt, value_i)

    `PROC_LOCK_FF(axil_aw_req, clk, reset,)
    `PROC_LOCK_FF(axil_w_req, clk, reset,)
    `PROC_LOCK_FF(axil_ar_req, clk, reset,)
    `PROC_LOCK_FF(axil_wr_resp, clk, reset,)
    `PROC_LOCK_FF(axil_rd_resp, clk, reset,)

    always_comb begin
        s_axil_resp_nxt        = '0;

        wr_en_nxt              = 0;
        value_i_nxt            = 0;

        `PROC_INIT(axil_aw_req)
        `PROC_INIT(axil_w_req)
        `PROC_INIT(axil_ar_req)
        `PROC_INIT(axil_wr_resp)
        `PROC_INIT(axil_rd_resp)

        // The aw and ar channel are not actually participating in the io control.
        // Decoding mechanism is implemented in demux.

        // aw
        if(!axil_w_req_lock && !axil_ar_req_lock && !axil_wr_resp_lock) begin
            if(axil_aw_req_lock) begin
                if(!s_axil_req.aw_valid) begin
                    axil_aw_req_lock_nxt   = 0;
                    axil_aw_req_lock_load  = 1; // ready will de-assert automatically.

                    // axil_w event can only be activated at the de-assert of the aw_valid.
                    axil_w_req_lock_nxt    = 1;
                    axil_w_req_lock_load   = 1;
                end
            end
            else begin
                if(s_axil_req.aw_valid) begin
                    s_axil_resp_nxt.aw_ready= 1;
                    axil_aw_req_lock_nxt    = 1;
                    axil_aw_req_lock_load   = 1;
                end
            end
        end
        
        // ar
        if(!axil_w_req_lock && !axil_aw_req_lock && !axil_rd_resp_lock) begin
            if(axil_ar_req_lock) begin
                if(!s_axil_req.aw_valid) begin
                    axil_ar_req_lock_nxt   = 0;
                    axil_ar_req_lock_load  = 1;

                    axil_rd_resp_lock_nxt    = 1;
                    axil_rd_resp_lock_load   = 1;
                end
            end
            else begin
                // Only execute the ar when aw is not active simultaneously.
                if(s_axil_req.ar_valid && !s_axil_req.aw_valid) begin
                    s_axil_resp_nxt.ar_ready  = 1;
                    axil_ar_req_lock_nxt    = 1;
                    axil_ar_req_lock_load   = 1;
                end
            end
        end

        //w
        if(axil_w_req_lock) begin
            if(s_axil_req.w_valid) begin
                s_axil_resp_nxt.w_ready   = 1;
                
                axil_w_req_lock_nxt       = 0;
                axil_w_req_lock_load      = 1;

                axil_wr_resp_lock_nxt     = 1;
                axil_wr_resp_lock_load    = 1;

                wr_en_nxt = 1;
                value_i_nxt = s_axil_req.w.data[GPIOWidth - 1 : 0];
            end
        end

        // b
        if(axil_wr_resp_lock) begin
            s_axil_resp_nxt.b_valid = 1;
            s_axil_resp_nxt.b = 0;

            if(s_axil_req.b_ready) begin
                // s_axil_resp_nxt.b_valid  = 1;
                axil_wr_resp_lock_nxt  = 0;
                axil_wr_resp_lock_load = 1;
            end
        end

        // r
        if(axil_rd_resp_lock) begin
            s_axil_resp_nxt.r_valid = 1;
            s_axil_resp_nxt.r.resp = 0;
            // TODO : Width ?
            s_axil_resp_nxt.r.data = value_o;

            if(s_axil_req.r_ready) begin
                axil_rd_resp_lock_nxt     = 0;
                axil_rd_resp_lock_load    = 1;
            end
        end

    end


    io_core #(
        .WriteAccess    (WriteAccess    ),
        .ReadAccess     (ReadAccess     ),
        .PortInput      (PortInput      ),
        .PortOutput     (PortOutput     ),
        .DefaultValue   (DefaultValue   ),
        .DefaultTriState(DefaultTriState),
        .GPIOWidth      (GPIOWidth      )
    )io_core_inst(
        .clk            (clk            ),
        .reset          (reset          ),
        .io_i           (io_i           ),
        .io_o           (io_o           ),
        .io_t           (io_t           ),
        .rd_en          (               ),
        .wr_en          (wr_en          ),
        .value_i        (value_i        ),
        .value_o        (value_o        )
    );

endmodule