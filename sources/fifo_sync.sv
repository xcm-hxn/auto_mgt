// TODO : Use gated clock?
// TODO : Behaviour when depth is 1 and pop push assert together.

module fifo_sync #(
    parameter   type    data_t      = logic                                 ,
    parameter   bit     FallThrough = 1                                     ,
    parameter   int     Depth       = 0                                     ,
    parameter   int     Threshold   = 0                                     ,
    // DO NOT overwrite these two parameters 
    parameter   int     Fifo_Depth  = (Depth > 1) ? Depth : 1               ,
    parameter   int     Addr_Depth  = (Depth > 1) ? $clog2(Depth) : 1
)(
    input   logic                       clk         ,
    input   logic                       reset       ,
    input   logic                       push        ,
    input   logic                       pop         ,
    input   data_t                      din         ,
    output  data_t                      dout        ,
    output  logic                       full        ,
    output  logic                       thre_full   ,
    output  logic                       empty       ,
    output  logic [Addr_Depth - 1 : 0]  status_cnt
);

    // localparam Fifo_Depth = (Depth > 1) ? Depth : 1;    
    // localparam Addr_Depth = (Depth > 1) ? $clog2(Depth) : 1;

    logic   [Addr_Depth - 1 : 0]    rd_ptr      ;
    logic   [Addr_Depth - 1 : 0]    rd_ptr_nxt  ;   
    logic   [Addr_Depth - 1 : 0]    wr_ptr      ;
    logic   [Addr_Depth - 1 : 0]    wr_ptr_nxt  ;
    logic   [Addr_Depth : 0]        cnt         ;
    logic   [Addr_Depth : 0]        cnt_nxt     ;
    data_t  [Depth - 1 : 0]         fifo        ;
    data_t  [Depth - 1 : 0]         fifo_nxt    ;

    generate
        if (Depth == 0) begin : pass_through
            assign empty     = !push;
            assign full      = !pop;
            assign thre_full = !pop;
        end else begin : gen_fifo
            assign empty      = (cnt == 0);
            assign full       = (cnt == Fifo_Depth[Addr_Depth:0]);  
            assign thre_full  = (cnt >= Threshold);
        end
    endgenerate

    always@(posedge clk) begin
        if(reset) begin
            fifo    <= '0;
            rd_ptr  <= '0;
            wr_ptr  <= '0;
            cnt     <= '0;
        end
        else begin
            fifo    <= fifo_nxt;
            rd_ptr  <= rd_ptr_nxt;
            wr_ptr  <= wr_ptr_nxt;
            cnt     <= cnt_nxt;
        end
    end

    always_comb begin
        rd_ptr_nxt  = rd_ptr;
        wr_ptr_nxt  = wr_ptr;
        fifo_nxt    = fifo;
        cnt_nxt     = cnt;
        dout        = (Depth == 0) ? din : fifo[rd_ptr];

        if(push && !full) begin
            fifo_nxt[wr_ptr] = din;
            cnt_nxt = cnt + 1;
            if(wr_ptr == Fifo_Depth[Addr_Depth - 1 : 0] - 1)
                wr_ptr_nxt = '0;
            else
                wr_ptr_nxt = wr_ptr + 1;
        end

        if(pop && !empty) begin
            cnt_nxt = cnt - 1;
            if(rd_ptr == Fifo_Depth[Addr_Depth - 1 : 0] - 1)
                rd_ptr_nxt = '0;
            else
                rd_ptr_nxt = rd_ptr + 1;
        end

        if(push && pop && !full && !empty)
            cnt_nxt = cnt;

        if (FallThrough && (cnt == 0) && push) begin
            dout = din;
            if (pop) begin
                cnt_nxt = cnt;
                rd_ptr_nxt = rd_ptr;
                wr_ptr_nxt = wr_ptr;
            end
        end
    end

    assign status_cnt = cnt;

    // fifo_sync_fallthrough #(
    //     .data_t     (),
    //     .Depth      (),
    //     .Threshold  ()
    // ) fifo_inst (
    //     .clk        (),
    //     .reset      (),
    //     .push       (),
    //     .pop        (),
    //     .din        (),
    //     .dout       (),
    //     .full       (),
    //     .thre_full  (),
    //     .empty      (),
    //     .status_cnt ()
    // );


endmodule