module pipeline #(
     parameter  int     Stages = 2
    ,parameter  type    data_t = logic
)(
     input      logic   clk
    ,input      logic   reset
    ,input      logic   valid_i
    ,output     logic   ready_o
    ,input      data_t  din
    ,output     logic   valid_o
    ,input      logic   ready_i
    ,output     data_t  dout
);
    
    localparam PipeWidth = sgbus_pkg::idx_width(Stages);

    data_t  [Stages-1:0]    data_pipe       ;
    logic   [PipeWidth:0]   transaction_cnt ;

    assign pipe_in  = valid_i && ready_o    ;
    assign pipe_out = valid_o && ready_i    ;

    assign ready_o = (transaction_cnt == Stages && !ready_i) ? 0 : 1;
    assign valid_o = transaction_cnt == Stages;

    assign dout = data_pipe[Stages-1];

    // Valid transaction number in the pipeline.
    always_ff@(posedge clk) begin
        if(reset) begin
            transaction_cnt <= 0;
        end
        else begin
            if(pipe_in && pipe_out) begin
                transaction_cnt <= transaction_cnt;
            end
            else if(pipe_in && !pipe_out) begin
                transaction_cnt <= transaction_cnt + 1;
            end
            else if(!pipe_in && pipe_out) begin
                transaction_cnt <= transaction_cnt -1;
            end
            else begin
                transaction_cnt <= transaction_cnt;
            end
        end
    end

    always_ff@(posedge clk) begin
        if(reset) begin
            data_pipe <= '0;
        end
        else begin
            if(pipe_in) begin
                data_pipe <= {data_pipe[Stages-2:0], din};
            end
            else begin
                data_pipe <= data_pipe;
            end
        end
    end

endmodule