module stream_fifo #(
     parameter  int         Depth     = 16
    ,parameter  int         Threshold = 8
    ,parameter  type        data_t    = logic    
)(
     input      logic       clk 
    ,input      logic       reset 

    ,input      data_t      din
    ,input      logic       valid_i
    ,output     logic       ready_o
    ,output     logic       hf_ready_o
    ,output     data_t      dout 
    ,output     logic       valid_o
    ,input      logic       ready_i
);

    logic push, pop;
    logic empty, full, thre_full;

    assign ready_o    = ~full;
    assign hf_ready_o = ~thre_full;
    assign valid_o    = ~empty;

    assign push    = valid_i & ready_o;
    assign pop     = ready_i & valid_o;

    (* DONT_TOUCH = "TRUE" *)
    fifo_sync #(
         .data_t        (data_t     )
        ,.Depth         (Depth      )
        ,.Threshold     (Threshold  )
    ) fifo_inst (
         .clk           (clk        )
        ,.reset         (reset      )
        ,.push          (push       )
        ,.pop           (pop        )
        ,.din           (din        )
        ,.dout          (dout       )
        ,.full          (full       )
        ,.thre_full     (thre_full  )
        ,.empty         (empty      )
        ,.status_cnt    (           )
    );

endmodule
