`ifndef AXI_LITE_PKG_SVH
`define AXI_LITE_PKG_SVH

    package axi_lite_pkg;

        typedef     logic   [1:0]       resp_t          ;
        typedef     logic   [2:0]       prot_t          ;

        typedef     logic   [31:0]      axil_32_addr_t  ;
        typedef     logic   [63:0]      axil_64_addr_t  ;
        typedef     logic   [31:0]      axil_32_data_t  ;
        typedef     logic   [63:0]      axil_64_data_t  ;

        typedef struct packed {
            axil_32_addr_t   start_addr  ;
            axil_32_addr_t   end_addr    ;
            int              index       ;
        } axil_32_range_rule_t;

        typedef struct packed {
            axil_32_addr_t    start_addr  ;
            axil_32_addr_t    end_addr    ;
            int               index       ;
        } axil_32_napot_rule_t;

        typedef struct packed {
            // int unsigned addr_width     ;
            // int unsigned data_width     ;
            // int unsigned resp_width     ;
            // int unsigned strb_width     ;
            int unsigned master_num     ;
        } axil_demux_cfg_t;

        typedef struct packed {
            int unsigned addr_width     ;
            int unsigned data_width     ;
            int unsigned resp_width     ;
            int unsigned strb_width     ;
        } axil_cfg_t;

    endpackage

`endif

`ifndef AXI_STREAM_PKG_SVH
`define AXI_STREAM_PKG_SVH

    package axi_stream_pkg;

        typedef logic   [63:0]  axis_64_data_t  ;

    endpackage

`endif

`ifndef AXI_PKG_SVH
`define AXI_PKG_SVH

    package axi_pkg;

        typedef logic   [7:0]   len_t           ;
        typedef logic   [2:0]   size_t          ;
        typedef logic   [1:0]   burst_t         ;
        typedef logic   [2:0]   prot_t          ;
        typedef logic   [3:0]   cache_t         ;
        typedef logic   [1:0]   resp_t          ;

        typedef logic   [63:0]  axi4_64_addr_t  ;
        typedef logic   [127:0] axi4_128_addr_t ;
        typedef logic   [63:0]  axi4_64_data_t  ;
        typedef logic   [127:0] axi4_128_data_t ;

        typedef struct packed {
            axi4_64_addr_t  start_addr  ;
            axi4_64_addr_t  end_addr    ;
            int             index       ;
        } axi4_64_napot_rule_t;

        typedef struct packed {
            axi4_64_addr_t  start_addr  ;
            axi4_64_addr_t  end_addr    ;
            int             index       ;
        } axi4_64_range_rule_t;

        typedef struct packed {
            axi4_128_addr_t start_addr  ;
            axi4_128_addr_t end_addr    ;
            int             index       ;
        } axi4_128_napot_rule_t;

        typedef struct packed {
            axi4_128_addr_t start_addr  ;
            axi4_128_addr_t end_addr    ;
            int             index       ;
        } axi4_128_range_rule_t;

    endpackage

`endif

`ifndef SGBUS_PKG_SVH
`define SGBUS_PKG_SVH

    package sgbus_pkg;

        typedef enum logic [31:0] {
            axi_lite_rd         = 'h0,
            axi_lite_wr         = 'h1,
            id_init             = 'h2,
            trans_dir           = 'h3,
            reset               = 'h4,
            reset_query         = 'h5,
            data_align          = 'h6,
            data_align_query    = 'h7,
            frame_sync          = 'h8,
            frame_sync_query    = 'h9,
            data_send           = 'ha,
            data_read           = 'hb,
            delay_adjust        = 'hc,
            delay_adjust_query  = 'hd,
            prbs_send           = 'he,
            prbs_status_query   = 'hf,
            chnl_para           = 'h10,
            ber_query           = 'h11,
            pll_status_query    = 'h12,
            backdoor_axi_rd     = 'h13,
            backdoor_axi_wr     = 'h14
        } pkt_type_id_e;

        typedef     logic           [15:0]      htd_code_t  ;
        typedef     logic           [7:0]       fpga_id_t   ;
        typedef     logic           [7:0]       rs0_t       ;
        typedef     logic           [31:0]      rs1_t       ;
        typedef     logic           [31:0]      pkt_len_t   ;

        function automatic integer unsigned idx_width (
            input integer unsigned num_idx
        );
            return (num_idx > 32'd1) ? unsigned'($clog2(num_idx)) : 32'd1;
        endfunction
        
    endpackage

`endif