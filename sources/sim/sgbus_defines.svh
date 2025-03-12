`include "sgbus_pkgs.svh"
import axi_lite_pkg::*;
import axi_pkg::*;
import sgbus_pkg::*;

/************************************************************************************************
Macros used to construct SGBUS packets and payloads
************************************************************************************************/
`ifndef SGBUS_PKT_DEF
`define SGBUS_PKT_DEF
    // typedef enum logic [31:0] {
    //     axi_lite_rd         = 'h0,
    //     axi_lite_wr         = 'h1,
    //     id_init             = 'h2,
    //     trans_dir           = 'h3,
    //     reset               = 'h4,
    //     reset_query         = 'h5,
    //     data_align          = 'h6,
    //     data_align_query    = 'h7,
    //     frame_sync          = 'h8,
    //     frame_sync_query    = 'h9,
    //     data_send           = 'ha,
    //     data_read           = 'hb,
    //     delay_adjust        = 'hc,
    //     delay_adjust_query  = 'hd,
    //     prbs_send           = 'he,
    //     prbs_status_query   = 'hf,
    //     chnl_para           = 'h10,
    //     ber_query           = 'h11,
    //     pll_status_query    = 'h12,
    //     backdoor_axi_rd     = 'h13,
    //     backdoor_axi_wr     = 'h14
    // } pkt_type_id_e;

    // idcode          -> dont care
    // selectmap       -> dont care
    // cable_scan      -> id_init -> reset -> reset_query -> delay_align -> delay_adjust_query -> data_read
    // gio_diag        -> id_init -> trans_dir -> reset -> reset_query -> delay_adjust -> delay_adjust_query -> data_align -> data_align_query
    // mgt_diag        -> id_init -> trans_dir -> reset -> reset_query -> data_align -> data_align_query -> prbs_send -> prbs_status_query
    // tdm_reg         -> {axi_lite_rd -> axi_lite_wr} // NOT sequencial events.
    // clock_db        -> reset -> reset_query -> {axi_lite_rd -> axi_lite_wr} -> data_read
    // gio_autotest    -> reset -> reset_query -> data_send -> data_read
    // mgt_autotest    -> pll_status_query -> chnl_para -> reset -> reset_query -> ber_query
    // qsfp_autotest   -> pll_status_query -> chnl_para -> reset -> reset_query -> ber_query
    // qth_autotest    -> refer to gio_autotest/mgt_autotest
    // ddr4_autotest   -> reset -> reset_query -> pll_status_query -> data_read
    // ddr4_eep        -> reset -> reset_query -> axi_lite_rd
    // led_autotest    -> data_send -> data_read
    // backdoor        -> {backdoor_axi_rd -> bakcdoor_axi_wr} // NOT sequencial events.

    // typedef struct packed {
    //     logic           [15:0]      htd_code    ;
    //     logic           [7:0]       fpga_id     ;
    //     logic           [7:0]       rs0         ;   // reserved field 0
    //     pkt_type_id_e               pkg_type_id ;
    //     logic           [31:0]      rs1         ;   // reserved field 1
    //     logic           [31:0]      pkt_len     ;
    // } sgbus_header_t;

    typedef struct packed {
        sgbus_pkg::htd_code_t      htd_code    ;
        sgbus_pkg::fpga_id_t       fpga_id     ;
        sgbus_pkg::rs0_t           rs0         ;   // reserved field 0
        sgbus_pkg::pkt_type_id_e   pkg_type_id ;
        sgbus_pkg::rs1_t           rs1         ;   // reserved field 1
        sgbus_pkg::pkt_len_t       pkt_len     ;
    } sgbus_header_t;

    `define SGBUS_HEADER_VEC_TO_STURCT(__raw_data, __sgbus_header, __opt_as)                \
        __opt_as __sgbus_header.htd_code    = sgbus_pkg::htd_code_t'(__raw_data[127:112]) ; \
        __opt_as __sgbus_header.fpga_id     = sgbus_pkg::fpga_id_t'(__raw_data[111:104])  ; \
        __opt_as __sgbus_header.rs0         = sgbus_pkg::rs0_t'(__raw_data[103:96])       ; \
        __opt_as __sgbus_header.pkg_type_id = sgbus_pkg::pkt_type_id_e'(__raw_data[95:64]); \
        __opt_as __sgbus_header.rs1         = sgbus_pkg::rs1_t'(__raw_data[63:32])        ; \
        __opt_as __sgbus_header.pkt_len     = sgbus_pkg::pkt_len_t'(__raw_data[31:0])     ;

    `define SGBUS_HEADER_STRUCT_TO_VEC(__raw_data, __sgbus_header, __opt_as)    \
        __opt_as __raw_data[127:112] = __sgbus_header.htd_code    ;             \
        __opt_as __raw_data[111:104] = __sgbus_header.fpga_id     ;             \
        __opt_as __raw_data[103:96]  = __sgbus_header.rs0         ;             \
        __opt_as __raw_data[95:64]   = __sgbus_header.pkg_type_id ;             \
        __opt_as __raw_data[63:32]   = __sgbus_header.rs1         ;             \
        __opt_as __raw_data[31:0]    = __sgbus_header.pkt_len     ;

`endif

/************************************************************************************************
Macros used to construct axi lite.
************************************************************************************************/
`ifndef AXIL_DEF
`define AXIL_DEF

    `define AXIL_TYPEDEF_AW_CHNL_T(aw_chnl_t, addr_t) \
        typedef struct packed {                       \
            addr_t                  addr;             \
            axi_lite_pkg::prot_t    prot;             \
        } aw_chnl_t;                                            

    `define AXIL_TYPEDEF_W_CHNL_T(w_chnl_t, data_t, strb_t) \
        typedef struct packed {                             \
            data_t data ;                                   \
            strb_t strb ;                                   \
        } w_chnl_t;                                             

    `define AXIL_TYPEDEF_B_CHNL_T(b_chnl_t) \
        typedef struct packed {             \
            axi_lite_pkg::resp_t resp ;     \
        } b_chnl_t;                                             

    `define AXIL_TYPEDEF_AR_CHNL_T(ar_chnl_t, addr_t) \
        typedef struct packed {                       \
            addr_t                  addr;             \
            axi_lite_pkg::prot_t    prot;             \
        } ar_chnl_t;                                            

    `define AXIL_TYPEDEF_R_CHNL_T(r_chnl_t, data_t) \
        typedef struct packed {                     \
            data_t data ;                           \
            axi_lite_pkg::resp_t resp ;             \
        } r_chnl_t;                                             

    `define AXIL_TYPEDEF_REQ_T(axil_req_t, aw_chnl_t, w_chnl_t, ar_chnl_t) \
        typedef struct packed {                                            \
            aw_chnl_t   aw          ;                                      \
            logic       aw_valid    ;                                      \
            w_chnl_t    w           ;                                      \
            logic       w_valid     ;                                      \
            logic       b_ready     ;                                      \
            ar_chnl_t   ar          ;                                      \
            logic       ar_valid    ;                                      \
            logic       r_ready     ;                                      \
        } axil_req_t;                                                           

    `define AXIL_TYPEDEF_RESP_T(axil_resp_t, b_chnl_t, r_chnl_t) \
        typedef struct packed {                                  \
            logic       aw_ready    ;                            \
            logic       w_ready     ;                            \
            logic       b_valid     ;                            \
            b_chnl_t    b           ;                            \
            logic       ar_ready    ;                            \
            r_chnl_t    r           ;                            \
            logic       r_valid     ;                            \
        } axil_resp_t;                                                          

    `define AXIL_TYPEDEF_ALL(__name, __req, __rsp, __addr_t, __data_t, __strb_t)              \
        `AXIL_TYPEDEF_AW_CHNL_T(__name``_aw_chnl_t, __addr_t)                                 \
        `AXIL_TYPEDEF_W_CHNL_T(__name``_w_chnl_t, __data_t, __strb_t)                         \
        `AXIL_TYPEDEF_B_CHNL_T(__name``_b_chnl_t)                                             \
        `AXIL_TYPEDEF_AR_CHNL_T(__name``_ar_chnl_t, __addr_t)                                 \
        `AXIL_TYPEDEF_R_CHNL_T(__name``_r_chnl_t, __data_t)                                   \
        `AXIL_TYPEDEF_REQ_T(__req, __name``_aw_chnl_t, __name``_w_chnl_t, __name``_ar_chnl_t) \
        `AXIL_TYPEDEF_RESP_T(__rsp, __name``_b_chnl_t, __name``_r_chnl_t)

    interface axi_lite_intf #(
        parameter int AddrWidth = 32    ,
        parameter int DataWidth = 32    ,
        parameter int StrbWidth = DataWidth / 8
    );

        typedef     logic   [AddrWidth - 1 : 0]     addr_t  ;
        typedef     logic   [DataWidth - 1 : 0]     data_t  ;
        typedef     logic   [StrbWidth - 1 : 0]     strb_t  ;

        //*prot is no defined for reduction.
        addr_t                  aw_addr;
        logic                   aw_valid;
        logic                   aw_ready;
        axi_lite_pkg::prot_t    aw_prot;

        data_t                  w_data;
        strb_t                  w_strb;
        logic                   w_valid;
        logic                   w_ready;

        axi_lite_pkg::resp_t    b_resp;
        logic                   b_valid;
        logic                   b_ready;

        addr_t                  ar_addr;
        logic                   ar_valid;
        logic                   ar_ready;
        axi_lite_pkg::prot_t    ar_prot;

        data_t                  r_data;
        axi_lite_pkg::resp_t    r_resp;
        logic                   r_valid;
        logic                   r_ready;

        modport m (
            output  aw_addr, aw_valid, input aw_ready,    
            output  w_data, w_strb, w_valid, input w_ready,
            input   b_resp, b_valid, output b_ready,
            output  ar_addr, ar_valid, input ar_ready,
            input   r_data, r_resp, r_valid, output r_ready 
        );

        modport s (
            input aw_addr, aw_valid, output aw_ready,
            input w_data, w_strb, w_valid, output w_ready,
            output b_resp, b_valid, input b_ready,
            input ar_addr, ar_valid, output ar_ready,
            output r_data, r_resp, r_valid, input r_ready
        );
    endinterface

    `define __AXIL_ASSIGN_AW(__lhs, __lhs_sep, __rhs, __rhs_sep)  \
        assign __lhs``__lhs_sep``addr = __rhs``__rhs_sep``addr;     
    `define __AXIL_ASSIGN_W(__lhs, __lhs_sep, __rhs, __rhs_sep)   \
        assign __lhs``__lhs_sep``data = __rhs``__rhs_sep``data;   \
        assign __lhs``__lhs_sep``strb = __rhs``__rhs_sep``strb;
    `define __AXIL_ASSIGN_B(__lhs, __lhs_sep, __rhs, __rhs_sep)   \
        assign __lhs``__lhs_sep``resp = __rhs``__rhs_sep``resp;
    `define __AXIL_ASSIGN_AR(__lhs, __lhs_sep, __rhs, __rhs_sep)  \
        assign __lhs``__lhs_sep``addr = __rhs``__rhs_sep``addr;   
    `define __AXIL_ASSIGN_R(__lhs, __lhs_sep, __rhs, __rhs_sep)   \
        assign __lhs``__lhs_sep``data = __rhs``__rhs_sep``data;   \
        assign __lhs``__lhs_sep``resp = __rhs``__rhs_sep``resp;

    `define __AXIL_ASSIGN_REQ(__lhs, __lhs_sep, __rhs, __rhs_sep)   \
        `__AXIL_ASSIGN_AW(__lhs.aw, __lhs_sep, __rhs.aw, __rhs_sep) \
        assign __lhs.aw_valid = __rhs.aw_valid;                     \
        `__AXIL_ASSIGN_W(__lhs.w, __lhs_sep, __rhs.w, __rhs_sep)    \
        assign __lhs.w_valid = __rhs.w_valid;                       \
        assign __lhs.b_ready = __rhs.b_ready;                       \
        `__AXIL_ASSIGN_AR(__lhs.ar, __lhs_sep, __rhs.ar, __rhs_sep) \
        assign __lhs.ar_valid = __rhs.ar_valid;                     \
        assign __lhs.r_ready = __rhs.r_ready;         

    `define __AXIL_ASSIGN_RESP(__lhs, __lhs_sep, __rhs, __rhs_sep) \
        assign __lhs.aw_ready = __rhs.aw_ready;                    \
        assign __lhs.ar_ready = __rhs.ar_ready;                    \
        assign __lhs.w_ready = __rhs.w_ready;                      \
        assign __lhs.b_valid = __rhs.b_valid;                      \
        `__AXIL_ASSIGN_B(__lhs.b, __lhs_sep, __rhs.b, __rhs_sep)   \
        assign __lhs.r_valid = __rhs.r_valid;                      \
        `__AXIL_ASSIGN_R(__lhs.r, __lhs_sep, __rhs.r, __rhs_sep)               


    `define AXIL_ASSIGN_REQ_INTF_TO_STRUCT(req_t, intf)    `__AXIL_ASSIGN_REQ(req_t, ., intf, _)
    `define AXIL_ASSIGN_REQ_STRUCT_TO_INTF(intf, req_t)    `__AXIL_ASSIGN_REQ(intf, _, req_t, .)
    `define AXIL_ASSIGN_RESP_INTF_TO_STRUCT(resp_t, intf)  `__AXIL_ASSIGN_RESP(resp_t, ., intf, _)
    `define AXIL_ASSIGN_RESP_STRUCT_TO_INTF(intf, resp_t)  `__AXIL_ASSIGN_RESP(intf, _, resp_t, .)

`endif

/***********************************************************************************************
Macros used to construct axi.
************************************************************************************************/

`ifndef AXI_DEF
`define AXI_DEF

    `define AXI_TYPEDEF_AW_CHNL_T(aw_chnl_t, addr_t, id_t) \
        typedef struct packed {                            \
            id_t              id;                          \
            addr_t            addr;                        \
            axi_pkg::len_t    len;                         \
            axi_pkg::size_t   size;                        \
            axi_pkg::burst_t  burst;                       \
            axi_pkg::cache_t  cache;                       \
            axi_pkg::prot_t   prot;                        \
        } aw_chnl_t;

    `define AXI_TYPEDEF_W_CHNL_T(w_chnl_t, data_t, strb_t) \
        typedef struct packed {                            \
            data_t data;                                   \
            strb_t strb;                                   \
            logic  last;                                   \
        } w_chnl_t;

    `define AXI_TYPEDEF_B_CHNL_T(b_chnl_t, id_t) \
        typedef struct packed {                  \
            id_t            id;                  \
            axi_pkg::resp_t resp;                \
        } b_chnl_t;

    `define AXI_TYPEDEF_AR_CHNL_T(ar_chnl_t, addr_t, id_t) \
        typedef struct packed {                            \
            id_t              id;                          \
            addr_t            addr;                        \
            axi_pkg::len_t    len;                         \
            axi_pkg::size_t   size;                        \
            axi_pkg::burst_t  burst;                       \
            axi_pkg::cache_t  cache;                       \
            axi_pkg::prot_t   prot;                        \
        } ar_chnl_t;

    `define AXI_TYPEDEF_R_CHNL_T(r_chnl_t, data_t, id_t) \
        typedef struct packed {                          \
            id_t            id;                          \
            data_t          data;                        \
            axi_pkg::resp_t resp;                        \
            logic           last;                        \
        } r_chnl_t;

    `define AXI_TYPEDEF_REQ_T(axi_req_t, aw_chnl_t, w_chnl_t, ar_chnl_t) \
        typedef struct packed {                                          \
            aw_chnl_t aw;                                                \
            logic     aw_valid;                                          \
            w_chnl_t  w;                                                 \
            logic     w_valid;                                           \
            logic     b_ready;                                           \
            ar_chnl_t ar;                                                \
            logic     ar_valid;                                          \
            logic     r_ready;                                           \
        } axi_req_t;

    `define AXI_TYPEDEF_RESP_T(axi_resp_t, b_chnl_t, r_chnl_t) \
        typedef struct packed {                                \
            logic     aw_ready;                                \
            logic     ar_ready;                                \
            logic     w_ready;                                 \
            logic     b_valid;                                 \
            b_chnl_t  b;                                       \
            logic     r_valid;                                 \
            r_chnl_t  r;                                       \
        } axi_resp_t;

    `define AXI_TYPEDEF_ALL(__name, __req, __rsp, __data_t, __addr_t, __strb_t, __id_t)      \
        `AXI_TYPEDEF_AW_CHNL_T(__name``_aw_chnl_t, __addr_t, __id_t)                         \
        `AXI_TYPEDEF_W_CHNL_T(__name``_w_chnl_t, __data_t, __strb_t)                         \
        `AXI_TYPEDEF_B_CHNL_T(__name``_b_chnl_t, __id_t)                                     \
        `AXI_TYPEDEF_AR_CHNL_T(__name``_ar_chnl_t, __addr_t, __id_t)                         \
        `AXI_TYPEDEF_R_CHNL_T(__name``_r_chnl_t, __data_t, __id_t)                           \
        `AXI_TYPEDEF_REQ_T(__req, __name``_aw_chnl_t, __name``_w_chnl_t, __name``_ar_chnl_t) \
        `AXI_TYPEDEF_RESP_T(__rsp, __name``_b_chnl_t, __name``_r_chnl_t)

    interface axi_intf #(
        parameter int unsigned AddrWidth = 0,
        parameter int unsigned DataWidth = 0,
        parameter int unsigned IdWidth   = 0,
        parameter int unsigned UserWidth = 0
    );

        localparam int unsigned StrbWidth = DataWidth / 8;

        typedef logic [IdWidth-1:0]     id_t        ;
        typedef logic [AddrWidth-1:0]   addr_t      ;
        typedef logic [DataWidth-1:0]   data_t      ;
        typedef logic [StrbWidth-1:0]   strb_t      ;
        typedef logic [7:0]             len_t       ;
        typedef logic [2:0]             size_t      ;
        typedef logic [1:0]             burst_t     ;
        typedef logic [2:0]             prot_t      ;
        typedef logic [3:0]             cache_t     ;
        typedef logic [1:0]             resp_t      ;

        id_t                aw_id       ;
        addr_t              aw_addr     ;
        axi_pkg::len_t      aw_len      ;
        axi_pkg::size_t     aw_size     ;
        axi_pkg::burst_t    aw_burst    ;
        axi_pkg::cache_t    aw_cache    ;
        axi_pkg::prot_t     aw_prot     ;
        logic               aw_valid    ;
        logic               aw_ready    ;

        data_t              w_data      ;
        strb_t              w_strb      ;
        logic               w_last      ;
        logic               w_valid     ;
        logic               w_ready     ;

        id_t                b_id        ;
        axi_pkg::resp_t     b_resp      ;
        logic               b_valid     ;
        logic               b_ready     ;

        id_t                ar_id       ;
        addr_t              ar_addr     ;
        axi_pkg::len_t      ar_len      ;
        axi_pkg::size_t     ar_size     ;
        axi_pkg::burst_t    ar_burst    ;
        axi_pkg::cache_t    ar_cache    ;
        axi_pkg::prot_t     ar_prot     ;
        logic               ar_valid    ;
        logic               ar_ready    ;

        id_t                r_id        ;
        data_t              r_data      ;
        axi_pkg::resp_t     r_resp      ;
        logic               r_last      ;
        logic               r_valid     ;
        logic               r_ready     ;

        modport m (
            output aw_id, aw_addr, aw_len, aw_size, aw_burst, aw_cache, aw_prot, aw_valid, input aw_ready,
            output w_data, w_strb, w_last, w_valid, input w_ready,
            input b_id, b_resp, b_valid, output b_ready,
            output ar_id, ar_addr, ar_len, ar_size, ar_burst, ar_cache, ar_prot, ar_valid, input ar_ready,
            input r_id, r_data, r_resp, r_last, r_valid, output r_ready
        );

        modport s (
            input aw_id, aw_addr, aw_len, aw_size, aw_burst, aw_cache, aw_prot, aw_valid, output aw_ready,
            input w_data, w_strb, w_last, w_valid, output w_ready,
            output b_id, b_resp, b_valid, input b_ready,
            input ar_id, ar_addr, ar_len, ar_size, ar_burst, ar_cache, ar_prot, ar_valid, output ar_ready,
            output r_id, r_data, r_resp, r_last, r_valid, input r_ready
        );

    endinterface

`endif

/************************************************************************************************
Macros used to construct axi stream.
************************************************************************************************/
`ifndef AXIS_DEF
`define AXIS_DEF

    `define AXIS_TYPEDEF_D_CHNL(t_chnl_t, data_t) \
        typedef struct packed {                   \
            data_t data;                          \
        } t_chnl_t;

    `define AXIS_TYPEDEF_REQ_T(axis_req_t, t_chnl_t) \
        typedef struct packed {                      \
            logic tvalid;                            \
            t_chnl_t t;                              \
        } axis_req_t;

    `define AXIS_TYPEDEF_RESP_T(axis_resp_t) \
        typedef struct packed {              \
            logic tready;                    \
        } axis_resp_t;

    `define AXIS_TYPEDEF_ALL(__name, __req, __resp, __data_t) \
        `AXIS_TYPEDEF_D_CHNL(__name``_t_chnl_t, __data_t)     \
        `AXIS_TYPEDEF_REQ_T(__req, __name``_t_chnl_t)         \
        `AXIS_TYPEDEF_RESP_T(__resp)

`endif

/************************************************************************************************
Macros used to construct common cells/logics.
************************************************************************************************/
`ifndef COMMON_CELL_DEF
`define COMMON_CELL_DEF


    `define DEFAULT_CLK clk 
    `define DEFAULT_RST reset

    `ifndef FFLDEN
    `define FFLDEN(__clk = `DEFAULT_CLK, __reset = `DEFAULT_RST, __reset_value, __set, __d, __q) \
        always_ff@(posedge (__clk)) begin                           \
            if (__reset)                                            \
                __q <= (__reset_value);                             \
            else if (__set)                                         \
                __q <= (__d);                                       \
        end                      
    `endif

    `ifndef FFLDEN_AUTO
    `define FFLDEN_AUTO(__clk = `DEFAULT_CLK, __reset = `DEFAULT_RST, __reset_value, __name) \
        `FFLDEN(__clk, __reset, __reset_value, __name``_lock_load, __name``_lock_nxt, __name``_lock)
    `endif

    `ifndef FF 
    `define FF(__clk = `DEFAULT_CLK, __d, __q) \
        `FFLDEN(__clk, 0, 1, 1,__d, __q)     
    `endif

    // Simple fifo instance signal define
    `define FIFO_TYPEDEF_SIMPLE(__type_name, __data_t) \
        typedef struct packed {                        \
            __data_t    din         ;                  \
            __data_t    dout        ;                  \
            logic       push        ;                  \
            logic       pop         ;                  \
            logic       empty       ;                  \
            logic       full        ;                  \
            logic       thre_full   ;                  \
        } __type_name;

    `ifndef PROC
    `define PROC_LOCK_FF(__event, __clk, __reset)   \
        logic   __event``_lock      ;               \
        logic   __event``_lock_nxt  ;               \
        logic   __event``_lock_load ;               \
        `FFLDEN(__clk, __reset, 0, 1, __event``_lock_nxt, __event``_lock)

    // __opt_as can be set as 'assign'.
    `define PROC_INIT(__event, __opt_as = )             \
        __opt_as __event``_lock_nxt  = __event``_lock;  \
        __opt_as __event``_lock_load = 0;

    `define PROC_LOCK(__event, __opt_as = )             \
        __opt_as __event``_lock_nxt  = 1;               \
        __opt_as __event``_lock_load = 1;

    `define PROC_UNLOCK(__event, __opt_as = )           \
        __opt_as __event``_lock_nxt  = 0;               \
        __opt_as __event``_lock_load = 1;
    `endif


`endif