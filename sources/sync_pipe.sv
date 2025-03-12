module sync_pipe #(
     parameter  int     SyncStage   = 2
    ,parameter  bit     ResetValue  = 1'b0
) (
     input      logic   clk
    ,input      logic   reset
    ,input      logic   din
    ,output     logic   dout
);

   (* dont_touch = "true", async_reg = "true" *)
   logic [SyncStage - 1 : 0] sync_pipe;

    always_ff @(posedge clk) begin
        if (reset) begin
            sync_pipe <= {SyncStage{ResetValue}};
        end else begin
            sync_pipe <= {sync_pipe[SyncStage - 2 : 0], din};
        end
    end

    assign dout = sync_pipe[SyncStage-1];

endmodule
