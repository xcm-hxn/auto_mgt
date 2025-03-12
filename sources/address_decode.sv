module address_decode #(
    parameter   int                         Napot       = 0     ,
    parameter   int                         AddrNum     = 4     ,
    parameter   type                        rule_t      = logic ,
    parameter   rule_t  [AddrNum - 1 : 0]   AddrMap     = '0    ,
    parameter   type                        addr_t      = logic ,
    parameter   type                        index_t     = logic 
    /* 
    typedef struct packed {
        addr_t  start_addr  ;
        addr_t  end_addr    ;
        int     index       ,
    } rule_t; 
    
    If Napot scheme is used, the end_addr is 
    a mask indicating bits need to be checked
    rather than an actual address. 
    */
)(
    input       addr_t                          slv_addr        ,
    output      index_t                         slv_sel         ,
    output      logic                           slv_sel_valid   ,
    output      logic                           slv_sel_error   
);

    generate

        always_comb begin
            slv_sel = '0;
            slv_sel_valid = 1'b0;
            slv_sel_error = 1'b1;

            for(int var_i = 0 ; var_i < AddrNum ; var_i = var_i + 1) begin
                // $display("var_i = %d", var_i);
                if(!Napot) begin
                    if(slv_addr >= AddrMap[var_i].start_addr && slv_addr < AddrMap[var_i].end_addr) begin
                        slv_sel = index_t'(AddrMap[var_i].index);
                        slv_sel_valid = 1;
                        slv_sel_error = 0;
                    end
                end
                else begin
                    if((slv_addr & AddrMap[var_i].end_addr) == (AddrMap[var_i].start_addr & AddrMap[var_i].end_addr)) begin
                        slv_sel = index_t'(AddrMap[var_i].index);
                        slv_sel_valid = 1;
                        slv_sel_error = 0;
                    end
                end
            end

        end

    endgenerate

endmodule
