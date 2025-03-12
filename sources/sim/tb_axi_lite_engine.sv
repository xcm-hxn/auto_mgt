`timescale 1ns/1ps
`include "sgbus_defines.svh"

module tb_axil_engine ();

    localparam  AXILDataWidth       = 32    ;
    localparam  AXILAddrWidth       = 32    ;
    localparam  SgbusPayloadWidth   = 128   ;
    localparam  TestTransactionNum  = 40    ;

    typedef     logic   [AXILDataWidth - 1 : 0]         axil_data_t     ;
    typedef     logic   [AXILAddrWidth - 1 : 0]         axil_addr_t     ;
    typedef     logic   [AXILDataWidth/8 - 1 : 0]       axil_strb_t     ;
    typedef     logic   [SgbusPayloadWidth - 1 : 0]     axis_data_t     ;

    typedef struct packed {
        logic   [127:0]     data    ;
        logic               valid   ;
    } sgbus_transaction_t;

    localparam  sgbus_transaction_t sgbus_transaction[TestTransactionNum] = '{
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h4859_0000_0000_0001_0000_0000_0000_0002, valid : 1},  // Write
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0005, valid : 1},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_C00A, valid : 1},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},

        '{data : 128'h4859_0000_0000_0001_0000_0000_0000_0002, valid : 1},  // Write
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0006, valid : 1},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_C00A, valid : 1},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},

        '{data : 128'h4859_0000_0000_0000_0000_0000_0000_0001, valid : 1},  // Read check
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0005, valid : 1},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0},
        '{data : 128'h0000_0000_0000_0000_0000_0000_0000_0000, valid : 0}
    };

    localparam  logic [127:0] sgbus_transaction_data[TestTransactionNum] = {
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h4859_0000_0000_0001_0000_0000_0000_0002,
        128'h0000_0000_0000_0000_0000_0000_0000_0005,
        128'h0000_0000_0000_0000_0000_0000_0000_C00A,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h4859_0000_0000_0000_0000_0000_0000_0001,
        128'h0000_0000_0000_0000_0000_0000_0000_0005,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000,
        128'h0000_0000_0000_0000_0000_0000_0000_0000
    };

    localparam  logic sgbus_transaction_valid[TestTransactionNum] = {
        1'b0,
        1'b1,
        1'b1,
        1'b1,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b1,
        1'b1,
        1'b0,
        1'b0,
        1'b0,
        1'b0,
        1'b0
    };



    `AXIL_TYPEDEF_ALL(test, test_axil_req_t, test_axil_resp_t, axil_data_t, axil_addr_t, axil_strb_t)
    `AXIS_TYPEDEF_ALL(test, test_axis_req_t, test_axis_resp_t, axis_data_t)

    logic               clk             ;
    logic               reset           ;
    logic               bram_reset      ;

    test_axis_req_t     s_axis_req      ;
    test_axis_resp_t    s_axis_resp     ;
    test_axis_req_t     m_axis_req      ;
    test_axis_resp_t    m_axis_resp     ;
    test_axil_req_t     m_axil_req      ;
    test_axil_resp_t    m_axil_resp     ;

    initial begin
        clk <= 1;
        forever begin
            #10
            clk <= ~clk;
        end
    end

    initial begin
        reset <= 1;
        bram_reset <= 1;
        #1000
        reset <= 0;
        #200
        bram_reset <= 0;
    end


    logic   [31:0]  sgbus_transaction_ptr   ;
    logic   [31:0]  test_times              ;

    always_ff@(posedge clk) begin
        if(reset) begin
            sgbus_transaction_ptr <= 0;
            test_times <= 0;
        end
        else
            if(sgbus_transaction_ptr != TestTransactionNum - 1) begin
                if(!sgbus_transaction_valid[sgbus_transaction_ptr])
                    sgbus_transaction_ptr <= sgbus_transaction_ptr + 1;
                else
                    //if(s_axis_resp.tready)
                        sgbus_transaction_ptr <= sgbus_transaction_ptr + 1;
            end
            else begin
                sgbus_transaction_ptr <= 0;
                test_times <= test_times + 1;
            end
    end

    assign s_axis_req.t.data = (sgbus_transaction_ptr == 2 || sgbus_transaction_ptr == 10) ?  // Address
                                sgbus_transaction_data[sgbus_transaction_ptr] + (test_times*'h1000):
                                sgbus_transaction_data[sgbus_transaction_ptr];
    
    assign s_axis_req.tvalid = sgbus_transaction_valid[sgbus_transaction_ptr];

    axi_lite_engine #(
         .axil_req_t        (test_axil_req_t    )
        ,.axil_resp_t       (test_axil_resp_t   )
        ,.axil_aw_chnl_t    (test_aw_chnl_t     )
        ,.axil_w_chnl_t     (test_w_chnl_t      )
        ,.axil_b_chnl_t     (test_b_chnl_t      )
        ,.axil_ar_chnl_t    (test_ar_chnl_t     )
        ,.axil_r_chnl_t     (test_r_chnl_t      )
        ,.axis_req_t        (test_axis_req_t    )
        ,.axis_resp_t       (test_axis_resp_t   )
        ,.axis_data_t       (axis_data_t        )
        ,.MaxPayload        (128                )
    )axi_lite_engine_inst(
         .clk               (clk                )
        ,.reset             (reset              )
        ,.s_axis_req        (s_axis_req         )
        ,.s_axis_resp       (s_axis_resp        )
        ,.m_axis_req        (m_axis_req         )
        ,.m_axis_resp       ('1                 )
        ,.m_axil_req        (m_axil_req         )
        ,.m_axil_resp       (m_axil_resp        )
    );
    


eyescan  #(
    .AXI_ADDR_WIDTH (32),
    .AXI_DATA_WIDTH (32),
    .QUAD           (11),
    .CHANNEL        (44)
) eyescan_inst (
  .axil_aclk(clk),                                   // input wire axil_aclk
  .axil_aresetn(~bram_reset),                                  // input wire axil_aresetn
  .quad220_clk_p(),                                // input wire quad220_clk_p
  .quad220_clk_n(),                                // input wire quad220_clk_n
  .quad221_clk_p(),                                // input wire quad221_clk_p
  .quad221_clk_n(),                                // input wire quad221_clk_n
  .quad222_clk_p(),                                // input wire quad222_clk_p
  .quad222_clk_n(),                                // input wire quad222_clk_n
  .quad225_clk_p(),                                // input wire quad225_clk_p
  .quad225_clk_n(),                                // input wire quad225_clk_n
  .quad226_clk_p(),                                // input wire quad226_clk_p
  .quad226_clk_n(),                                // input wire quad226_clk_n
  .quad227_clk_p(),                                // input wire quad227_clk_p
  .quad227_clk_n(),                                // input wire quad227_clk_n
  .quad230_clk_p(),                                // input wire quad230_clk_p
  .quad230_clk_n(),                                // input wire quad230_clk_n
  .quad231_clk_p(),                                // input wire quad231_clk_p
  .quad231_clk_n(),                                // input wire quad231_clk_n
  .quad235_clk_p(),                                // input wire quad235_clk_p
  .quad235_clk_n(),                                // input wire quad235_clk_n
  .quad236_clk_p(),                                // input wire quad236_clk_p
  .quad236_clk_n(),                                // input wire quad236_clk_n
  .quad237_clk_p(),                                // input wire quad237_clk_p
  .quad237_clk_n(),                                // input wire quad237_clk_n
  .quad220_ch0_gtyrxn_in(),                // input wire quad220_ch0_gtyrxn_in
  .quad220_ch0_gtyrxp_in(),                // input wire quad220_ch0_gtyrxp_in
  .quad220_ch0_gtytxn_out(),              // output wire quad220_ch0_gtytxn_out
  .quad220_ch0_gtytxp_out(),              // output wire quad220_ch0_gtytxp_out
  .quad220_ch1_gtyrxn_in(),                // input wire quad220_ch1_gtyrxn_in
  .quad220_ch1_gtyrxp_in(),                // input wire quad220_ch1_gtyrxp_in
  .quad220_ch1_gtytxn_out(),              // output wire quad220_ch1_gtytxn_out
  .quad220_ch1_gtytxp_out(),              // output wire quad220_ch1_gtytxp_out
  .quad220_ch2_gtyrxn_in(),                // input wire quad220_ch2_gtyrxn_in
  .quad220_ch2_gtyrxp_in(),                // input wire quad220_ch2_gtyrxp_in
  .quad220_ch2_gtytxn_out(),              // output wire quad220_ch2_gtytxn_out
  .quad220_ch2_gtytxp_out(),              // output wire quad220_ch2_gtytxp_out
  .quad220_ch3_gtyrxn_in(),                // input wire quad220_ch3_gtyrxn_in
  .quad220_ch3_gtyrxp_in(),                // input wire quad220_ch3_gtyrxp_in
  .quad220_ch3_gtytxn_out(),              // output wire quad220_ch3_gtytxn_out
  .quad220_ch3_gtytxp_out(),              // output wire quad220_ch3_gtytxp_out
  .quad221_ch0_gtyrxn_in(),                // input wire quad221_ch0_gtyrxn_in
  .quad221_ch0_gtyrxp_in(),                // input wire quad221_ch0_gtyrxp_in
  .quad221_ch0_gtytxn_out(),              // output wire quad221_ch0_gtytxn_out
  .quad221_ch0_gtytxp_out(),              // output wire quad221_ch0_gtytxp_out
  .quad221_ch1_gtyrxn_in(),                // input wire quad221_ch1_gtyrxn_in
  .quad221_ch1_gtyrxp_in(),                // input wire quad221_ch1_gtyrxp_in
  .quad221_ch1_gtytxn_out(),              // output wire quad221_ch1_gtytxn_out
  .quad221_ch1_gtytxp_out(),              // output wire quad221_ch1_gtytxp_out
  .quad221_ch2_gtyrxn_in(),                // input wire quad221_ch2_gtyrxn_in
  .quad221_ch2_gtyrxp_in(),                // input wire quad221_ch2_gtyrxp_in
  .quad221_ch2_gtytxn_out(),              // output wire quad221_ch2_gtytxn_out
  .quad221_ch2_gtytxp_out(),              // output wire quad221_ch2_gtytxp_out
  .quad221_ch3_gtyrxn_in(),                // input wire quad221_ch3_gtyrxn_in
  .quad221_ch3_gtyrxp_in(),                // input wire quad221_ch3_gtyrxp_in
  .quad221_ch3_gtytxn_out(),              // output wire quad221_ch3_gtytxn_out
  .quad221_ch3_gtytxp_out(),              // output wire quad221_ch3_gtytxp_out
  .quad222_ch0_gtyrxn_in(),                // input wire quad222_ch0_gtyrxn_in
  .quad222_ch0_gtyrxp_in(),                // input wire quad222_ch0_gtyrxp_in
  .quad222_ch0_gtytxn_out(),              // output wire quad222_ch0_gtytxn_out
  .quad222_ch0_gtytxp_out(),              // output wire quad222_ch0_gtytxp_out
  .quad222_ch1_gtyrxn_in(),                // input wire quad222_ch1_gtyrxn_in
  .quad222_ch1_gtyrxp_in(),                // input wire quad222_ch1_gtyrxp_in
  .quad222_ch1_gtytxn_out(),              // output wire quad222_ch1_gtytxn_out
  .quad222_ch1_gtytxp_out(),              // output wire quad222_ch1_gtytxp_out
  .quad222_ch2_gtyrxn_in(),                // input wire quad222_ch2_gtyrxn_in
  .quad222_ch2_gtyrxp_in(),                // input wire quad222_ch2_gtyrxp_in
  .quad222_ch2_gtytxn_out(),              // output wire quad222_ch2_gtytxn_out
  .quad222_ch2_gtytxp_out(),              // output wire quad222_ch2_gtytxp_out
  .quad222_ch3_gtyrxn_in(),                // input wire quad222_ch3_gtyrxn_in
  .quad222_ch3_gtyrxp_in(),                // input wire quad222_ch3_gtyrxp_in
  .quad222_ch3_gtytxn_out(),              // output wire quad222_ch3_gtytxn_out
  .quad222_ch3_gtytxp_out(),              // output wire quad222_ch3_gtytxp_out
  .quad225_ch0_gtyrxn_in(),                // input wire quad225_ch0_gtyrxn_in
  .quad225_ch0_gtyrxp_in(),                // input wire quad225_ch0_gtyrxp_in
  .quad225_ch0_gtytxn_out(),              // output wire quad225_ch0_gtytxn_out
  .quad225_ch0_gtytxp_out(),              // output wire quad225_ch0_gtytxp_out
  .quad225_ch1_gtyrxn_in(),                // input wire quad225_ch1_gtyrxn_in
  .quad225_ch1_gtyrxp_in(),                // input wire quad225_ch1_gtyrxp_in
  .quad225_ch1_gtytxn_out(),              // output wire quad225_ch1_gtytxn_out
  .quad225_ch1_gtytxp_out(),              // output wire quad225_ch1_gtytxp_out
  .quad225_ch2_gtyrxn_in(),                // input wire quad225_ch2_gtyrxn_in
  .quad225_ch2_gtyrxp_in(),                // input wire quad225_ch2_gtyrxp_in
  .quad225_ch2_gtytxn_out(),              // output wire quad225_ch2_gtytxn_out
  .quad225_ch2_gtytxp_out(),              // output wire quad225_ch2_gtytxp_out
  .quad225_ch3_gtyrxn_in(),                // input wire quad225_ch3_gtyrxn_in
  .quad225_ch3_gtyrxp_in(),                // input wire quad225_ch3_gtyrxp_in
  .quad225_ch3_gtytxn_out(),              // output wire quad225_ch3_gtytxn_out
  .quad225_ch3_gtytxp_out(),              // output wire quad225_ch3_gtytxp_out
  .quad226_ch0_gtyrxn_in(),                // input wire quad226_ch0_gtyrxn_in
  .quad226_ch0_gtyrxp_in(),                // input wire quad226_ch0_gtyrxp_in
  .quad226_ch0_gtytxn_out(),              // output wire quad226_ch0_gtytxn_out
  .quad226_ch0_gtytxp_out(),              // output wire quad226_ch0_gtytxp_out
  .quad226_ch1_gtyrxn_in(),                // input wire quad226_ch1_gtyrxn_in
  .quad226_ch1_gtyrxp_in(),                // input wire quad226_ch1_gtyrxp_in
  .quad226_ch1_gtytxn_out(),              // output wire quad226_ch1_gtytxn_out
  .quad226_ch1_gtytxp_out(),              // output wire quad226_ch1_gtytxp_out
  .quad226_ch2_gtyrxn_in(),                // input wire quad226_ch2_gtyrxn_in
  .quad226_ch2_gtyrxp_in(),                // input wire quad226_ch2_gtyrxp_in
  .quad226_ch2_gtytxn_out(),              // output wire quad226_ch2_gtytxn_out
  .quad226_ch2_gtytxp_out(),              // output wire quad226_ch2_gtytxp_out
  .quad226_ch3_gtyrxn_in(),                // input wire quad226_ch3_gtyrxn_in
  .quad226_ch3_gtyrxp_in(),                // input wire quad226_ch3_gtyrxp_in
  .quad226_ch3_gtytxn_out(),              // output wire quad226_ch3_gtytxn_out
  .quad226_ch3_gtytxp_out(),              // output wire quad226_ch3_gtytxp_out
  .quad227_ch0_gtyrxn_in(),                // input wire quad227_ch0_gtyrxn_in
  .quad227_ch0_gtyrxp_in(),                // input wire quad227_ch0_gtyrxp_in
  .quad227_ch0_gtytxn_out(),              // output wire quad227_ch0_gtytxn_out
  .quad227_ch0_gtytxp_out(),              // output wire quad227_ch0_gtytxp_out
  .quad227_ch1_gtyrxn_in(),                // input wire quad227_ch1_gtyrxn_in
  .quad227_ch1_gtyrxp_in(),                // input wire quad227_ch1_gtyrxp_in
  .quad227_ch1_gtytxn_out(),              // output wire quad227_ch1_gtytxn_out
  .quad227_ch1_gtytxp_out(),              // output wire quad227_ch1_gtytxp_out
  .quad227_ch2_gtyrxn_in(),                // input wire quad227_ch2_gtyrxn_in
  .quad227_ch2_gtyrxp_in(),                // input wire quad227_ch2_gtyrxp_in
  .quad227_ch2_gtytxn_out(),              // output wire quad227_ch2_gtytxn_out
  .quad227_ch2_gtytxp_out(),              // output wire quad227_ch2_gtytxp_out
  .quad227_ch3_gtyrxn_in(),                // input wire quad227_ch3_gtyrxn_in
  .quad227_ch3_gtyrxp_in(),                // input wire quad227_ch3_gtyrxp_in
  .quad227_ch3_gtytxn_out(),              // output wire quad227_ch3_gtytxn_out
  .quad227_ch3_gtytxp_out(),              // output wire quad227_ch3_gtytxp_out
  .quad230_ch0_gtyrxn_in(),                // input wire quad230_ch0_gtyrxn_in
  .quad230_ch0_gtyrxp_in(),                // input wire quad230_ch0_gtyrxp_in
  .quad230_ch0_gtytxn_out(),              // output wire quad230_ch0_gtytxn_out
  .quad230_ch0_gtytxp_out(),              // output wire quad230_ch0_gtytxp_out
  .quad230_ch1_gtyrxn_in(),                // input wire quad230_ch1_gtyrxn_in
  .quad230_ch1_gtyrxp_in(),                // input wire quad230_ch1_gtyrxp_in
  .quad230_ch1_gtytxn_out(),              // output wire quad230_ch1_gtytxn_out
  .quad230_ch1_gtytxp_out(),              // output wire quad230_ch1_gtytxp_out
  .quad230_ch2_gtyrxn_in(),                // input wire quad230_ch2_gtyrxn_in
  .quad230_ch2_gtyrxp_in(),                // input wire quad230_ch2_gtyrxp_in
  .quad230_ch2_gtytxn_out(),              // output wire quad230_ch2_gtytxn_out
  .quad230_ch2_gtytxp_out(),              // output wire quad230_ch2_gtytxp_out
  .quad230_ch3_gtyrxn_in(),                // input wire quad230_ch3_gtyrxn_in
  .quad230_ch3_gtyrxp_in(),                // input wire quad230_ch3_gtyrxp_in
  .quad230_ch3_gtytxn_out(),              // output wire quad230_ch3_gtytxn_out
  .quad230_ch3_gtytxp_out(),              // output wire quad230_ch3_gtytxp_out
  .quad231_ch0_gtyrxn_in(),                // input wire quad231_ch0_gtyrxn_in
  .quad231_ch0_gtyrxp_in(),                // input wire quad231_ch0_gtyrxp_in
  .quad231_ch0_gtytxn_out(),              // output wire quad231_ch0_gtytxn_out
  .quad231_ch0_gtytxp_out(),              // output wire quad231_ch0_gtytxp_out
  .quad231_ch1_gtyrxn_in(),                // input wire quad231_ch1_gtyrxn_in
  .quad231_ch1_gtyrxp_in(),                // input wire quad231_ch1_gtyrxp_in
  .quad231_ch1_gtytxn_out(),              // output wire quad231_ch1_gtytxn_out
  .quad231_ch1_gtytxp_out(),              // output wire quad231_ch1_gtytxp_out
  .quad231_ch2_gtyrxn_in(),                // input wire quad231_ch2_gtyrxn_in
  .quad231_ch2_gtyrxp_in(),                // input wire quad231_ch2_gtyrxp_in
  .quad231_ch2_gtytxn_out(),              // output wire quad231_ch2_gtytxn_out
  .quad231_ch2_gtytxp_out(),              // output wire quad231_ch2_gtytxp_out
  .quad231_ch3_gtyrxn_in(),                // input wire quad231_ch3_gtyrxn_in
  .quad231_ch3_gtyrxp_in(),                // input wire quad231_ch3_gtyrxp_in
  .quad231_ch3_gtytxn_out(),              // output wire quad231_ch3_gtytxn_out
  .quad231_ch3_gtytxp_out(),              // output wire quad231_ch3_gtytxp_out
  .quad235_ch0_gtyrxn_in(),                // input wire quad235_ch0_gtyrxn_in
  .quad235_ch0_gtyrxp_in(),                // input wire quad235_ch0_gtyrxp_in
  .quad235_ch0_gtytxn_out(),              // output wire quad235_ch0_gtytxn_out
  .quad235_ch0_gtytxp_out(),              // output wire quad235_ch0_gtytxp_out
  .quad235_ch1_gtyrxn_in(),                // input wire quad235_ch1_gtyrxn_in
  .quad235_ch1_gtyrxp_in(),                // input wire quad235_ch1_gtyrxp_in
  .quad235_ch1_gtytxn_out(),              // output wire quad235_ch1_gtytxn_out
  .quad235_ch1_gtytxp_out(),              // output wire quad235_ch1_gtytxp_out
  .quad235_ch2_gtyrxn_in(),                // input wire quad235_ch2_gtyrxn_in
  .quad235_ch2_gtyrxp_in(),                // input wire quad235_ch2_gtyrxp_in
  .quad235_ch2_gtytxn_out(),              // output wire quad235_ch2_gtytxn_out
  .quad235_ch2_gtytxp_out(),              // output wire quad235_ch2_gtytxp_out
  .quad235_ch3_gtyrxn_in(),                // input wire quad235_ch3_gtyrxn_in
  .quad235_ch3_gtyrxp_in(),                // input wire quad235_ch3_gtyrxp_in
  .quad235_ch3_gtytxn_out(),              // output wire quad235_ch3_gtytxn_out
  .quad235_ch3_gtytxp_out(),              // output wire quad235_ch3_gtytxp_out
  .quad236_ch0_gtyrxn_in(),                // input wire quad236_ch0_gtyrxn_in
  .quad236_ch0_gtyrxp_in(),                // input wire quad236_ch0_gtyrxp_in
  .quad236_ch0_gtytxn_out(),              // output wire quad236_ch0_gtytxn_out
  .quad236_ch0_gtytxp_out(),              // output wire quad236_ch0_gtytxp_out
  .quad236_ch1_gtyrxn_in(),                // input wire quad236_ch1_gtyrxn_in
  .quad236_ch1_gtyrxp_in(),                // input wire quad236_ch1_gtyrxp_in
  .quad236_ch1_gtytxn_out(),              // output wire quad236_ch1_gtytxn_out
  .quad236_ch1_gtytxp_out(),              // output wire quad236_ch1_gtytxp_out
  .quad236_ch2_gtyrxn_in(),                // input wire quad236_ch2_gtyrxn_in
  .quad236_ch2_gtyrxp_in(),                // input wire quad236_ch2_gtyrxp_in
  .quad236_ch2_gtytxn_out(),              // output wire quad236_ch2_gtytxn_out
  .quad236_ch2_gtytxp_out(),              // output wire quad236_ch2_gtytxp_out
  .quad236_ch3_gtyrxn_in(),                // input wire quad236_ch3_gtyrxn_in
  .quad236_ch3_gtyrxp_in(),                // input wire quad236_ch3_gtyrxp_in
  .quad236_ch3_gtytxn_out(),              // output wire quad236_ch3_gtytxn_out
  .quad236_ch3_gtytxp_out(),              // output wire quad236_ch3_gtytxp_out
  .quad237_ch0_gtyrxn_in(),                // input wire quad237_ch0_gtyrxn_in
  .quad237_ch0_gtyrxp_in(),                // input wire quad237_ch0_gtyrxp_in
  .quad237_ch0_gtytxn_out(),              // output wire quad237_ch0_gtytxn_out
  .quad237_ch0_gtytxp_out(),              // output wire quad237_ch0_gtytxp_out
  .quad237_ch1_gtyrxn_in(),                // input wire quad237_ch1_gtyrxn_in
  .quad237_ch1_gtyrxp_in(),                // input wire quad237_ch1_gtyrxp_in
  .quad237_ch1_gtytxn_out(),              // output wire quad237_ch1_gtytxn_out
  .quad237_ch1_gtytxp_out(),              // output wire quad237_ch1_gtytxp_out
  .quad237_ch2_gtyrxn_in(),                // input wire quad237_ch2_gtyrxn_in
  .quad237_ch2_gtyrxp_in(),                // input wire quad237_ch2_gtyrxp_in
  .quad237_ch2_gtytxn_out(),              // output wire quad237_ch2_gtytxn_out
  .quad237_ch2_gtytxp_out(),              // output wire quad237_ch2_gtytxp_out
  .quad237_ch3_gtyrxn_in(),                // input wire quad237_ch3_gtyrxn_in
  .quad237_ch3_gtyrxp_in(),                // input wire quad237_ch3_gtyrxp_in
  .quad237_ch3_gtytxn_out(),              // output wire quad237_ch3_gtytxn_out
  .quad237_ch3_gtytxp_out(),              // output wire quad237_ch3_gtytxp_out
  .gtwiz_reset_clk_freerun_in_p(),  // input wire gtwiz_reset_clk_freerun_in_p
  .gtwiz_reset_clk_freerun_in_n(),  // input wire gtwiz_reset_clk_freerun_in_n
  .s_axil_aw_addr(m_axil_req.aw.addr ),                              // input wire [31 : 0] s_axil_aw_addr
  .s_axil_aw_valid(m_axil_req.aw_valid ),                            // input wire s_axil_aw_valid
  .s_axil_aw_ready(m_axil_resp.aw_ready),                            // output wire s_axil_aw_ready
  .s_axil_w_data(m_axil_req.w.data ),                                // input wire [31 : 0] s_axil_w_data
  .s_axil_w_strb(m_axil_req.w.strb ),                                // input wire s_axil_w_strb
  .s_axil_w_valid(m_axil_req.w_valid ),                              // input wire s_axil_w_valid
  .s_axil_w_ready(m_axil_resp.w_ready),                              // output wire s_axil_w_ready
  .s_axil_b_resp(m_axil_resp.b.resp  ),                                // output wire [1 : 0] s_axil_b_resp
  .s_axil_b_valid(m_axil_resp.b_valid ),                              // output wire s_axil_b_valid
  .s_axil_b_ready(m_axil_req.b_ready ),                              // input wire s_axil_b_ready
  .s_axil_ar_addr(m_axil_req.ar.addr ),                              // input wire [31 : 0] s_axil_ar_addr
  .s_axil_ar_valid(m_axil_req.ar_valid ),                            // input wire s_axil_ar_valid
  .s_axil_ar_ready(m_axil_resp.ar_ready),                            // output wire s_axil_ar_ready
  .s_axil_r_data(m_axil_resp.r.data ),                                // output wire [31 : 0] s_axil_r_data
  .s_axil_r_resp(m_axil_resp.r.resp),                                // output wire s_axil_r_resp
  .s_axil_r_valid(m_axil_resp.r_valid),                              // output wire s_axil_r_valid
  .s_axil_r_ready(m_axil_req.r_ready)                              // input wire s_axil_r_ready
);

endmodule