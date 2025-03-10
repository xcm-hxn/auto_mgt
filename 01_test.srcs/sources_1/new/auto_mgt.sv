`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/04 15:57:13
// Design Name: 
// Module Name: auto_mgt
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module auto_mgt #(
    parameter integer AXI_ADDR_WIDTH = 32,
    parameter integer AXI_DATA_WIDTH = 32

) (

    input  logic axil_aclk,
    input  logic axil_aresetn,

    // Differential reference clock inputs
    input  logic mgtrefclk0_x0y1_p,
    input  logic mgtrefclk0_x0y1_n,
    input  logic mgtrefclk0_x0y11_p,
    input  logic mgtrefclk0_x0y11_n,
    input  logic mgtrefclk0_x0y12_p,
    input  logic mgtrefclk0_x0y12_n,
    input  logic mgtrefclk0_x0y16_p,
    input  logic mgtrefclk0_x0y16_n,
    input  logic mgtrefclk0_x0y17_p,
    input  logic mgtrefclk0_x0y17_n,
    input  logic mgtrefclk0_x0y18_p,
    input  logic mgtrefclk0_x0y18_n,
    input  logic mgtrefclk0_x0y2_p,
    input  logic mgtrefclk0_x0y2_n,
    input  logic mgtrefclk0_x0y3_p,
    input  logic mgtrefclk0_x0y3_n,
    input  logic mgtrefclk0_x0y6_p,
    input  logic mgtrefclk0_x0y6_n,
    input  logic mgtrefclk0_x0y7_p,
    input  logic mgtrefclk0_x0y7_n,
    input  logic mgtrefclk0_x0y8_p,
    input  logic mgtrefclk0_x0y8_n,


    // Serial data ports for transceiver channel 0
    input  logic ch0_gtyrxn_in,
    input  logic ch0_gtyrxp_in,
    output logic ch0_gtytxn_out,
    output logic ch0_gtytxp_out,

    // Serial data ports for transceiver channel 1
    input  logic ch1_gtyrxn_in,
    input  logic ch1_gtyrxp_in,
    output logic ch1_gtytxn_out,
    output logic ch1_gtytxp_out,

    // Serial data ports for transceiver channel 2
    input  logic ch2_gtyrxn_in,
    input  logic ch2_gtyrxp_in,
    output logic ch2_gtytxn_out,
    output logic ch2_gtytxp_out,

    // Serial data ports for transceiver channel 3
    input  logic ch3_gtyrxn_in,
    input  logic ch3_gtyrxp_in,
    output logic ch3_gtytxn_out,
    output logic ch3_gtytxp_out,

    // Serial data ports for transceiver channel 4
    input  logic ch4_gtyrxn_in,
    input  logic ch4_gtyrxp_in,
    output logic ch4_gtytxn_out,
    output logic ch4_gtytxp_out,

    // Serial data ports for transceiver channel 5
    input  logic ch5_gtyrxn_in,
    input  logic ch5_gtyrxp_in,
    output logic ch5_gtytxn_out,
    output logic ch5_gtytxp_out,

    // Serial data ports for transceiver channel 6
    input  logic ch6_gtyrxn_in,
    input  logic ch6_gtyrxp_in,
    output logic ch6_gtytxn_out,
    output logic ch6_gtytxp_out,

    // Serial data ports for transceiver channel 7
    input  logic ch7_gtyrxn_in,
    input  logic ch7_gtyrxp_in,
    output logic ch7_gtytxn_out,
    output logic ch7_gtytxp_out,

    // Serial data ports for transceiver channel 8
    input  logic ch8_gtyrxn_in,
    input  logic ch8_gtyrxp_in,
    output logic ch8_gtytxn_out,
    output logic ch8_gtytxp_out,

    // Serial data ports for transceiver channel 9
    input  logic ch9_gtyrxn_in,
    input  logic ch9_gtyrxp_in,
    output logic ch9_gtytxn_out,
    output logic ch9_gtytxp_out,

    // Serial data ports for transceiver channel 10
    input  logic ch10_gtyrxn_in,
    input  logic ch10_gtyrxp_in,
    output logic ch10_gtytxn_out,
    output logic ch10_gtytxp_out,

    // Serial data ports for transceiver channel 11
    input  logic ch11_gtyrxn_in,
    input  logic ch11_gtyrxp_in,
    output logic ch11_gtytxn_out,
    output logic ch11_gtytxp_out,

    // Serial data ports for transceiver channel 12
    input  logic ch12_gtyrxn_in,
    input  logic ch12_gtyrxp_in,
    output logic ch12_gtytxn_out,
    output logic ch12_gtytxp_out,

    // Serial data ports for transceiver channel 13
    input  logic ch13_gtyrxn_in,
    input  logic ch13_gtyrxp_in,
    output logic ch13_gtytxn_out,
    output logic ch13_gtytxp_out,

    // Serial data ports for transceiver channel 14
    input  logic ch14_gtyrxn_in,
    input  logic ch14_gtyrxp_in,
    output logic ch14_gtytxn_out,
    output logic ch14_gtytxp_out,

    // Serial data ports for transceiver channel 15
    input  logic ch15_gtyrxn_in,
    input  logic ch15_gtyrxp_in,
    output logic ch15_gtytxn_out,
    output logic ch15_gtytxp_out,

    // Serial data ports for transceiver channel 16
    input  logic ch16_gtyrxn_in,
    input  logic ch16_gtyrxp_in,
    output logic ch16_gtytxn_out,
    output logic ch16_gtytxp_out,

    // Serial data ports for transceiver channel 17
    input  logic ch17_gtyrxn_in,
    input  logic ch17_gtyrxp_in,
    output logic ch17_gtytxn_out,
    output logic ch17_gtytxp_out,

    // Serial data ports for transceiver channel 18
    input  logic ch18_gtyrxn_in,
    input  logic ch18_gtyrxp_in,
    output logic ch18_gtytxn_out,
    output logic ch18_gtytxp_out,

    // Serial data ports for transceiver channel 19
    input  logic ch19_gtyrxn_in,
    input  logic ch19_gtyrxp_in,
    output logic ch19_gtytxn_out,
    output logic ch19_gtytxp_out,

    // Serial data ports for transceiver channel 20
    input  logic ch20_gtyrxn_in,
    input  logic ch20_gtyrxp_in,
    output logic ch20_gtytxn_out,
    output logic ch20_gtytxp_out,

    // Serial data ports for transceiver channel 21
    input  logic ch21_gtyrxn_in,
    input  logic ch21_gtyrxp_in,
    output logic ch21_gtytxn_out,
    output logic ch21_gtytxp_out,

    // Serial data ports for transceiver channel 22
    input  logic ch22_gtyrxn_in,
    input  logic ch22_gtyrxp_in,
    output logic ch22_gtytxn_out,
    output logic ch22_gtytxp_out,

    // Serial data ports for transceiver channel 23
    input  logic ch23_gtyrxn_in,
    input  logic ch23_gtyrxp_in,
    output logic ch23_gtytxn_out,
    output logic ch23_gtytxp_out,

    // Serial data ports for transceiver channel 24
    input  logic ch24_gtyrxn_in,
    input  logic ch24_gtyrxp_in,
    output logic ch24_gtytxn_out,
    output logic ch24_gtytxp_out,

    // Serial data ports for transceiver channel 25
    input  logic ch25_gtyrxn_in,
    input  logic ch25_gtyrxp_in,
    output logic ch25_gtytxn_out,
    output logic ch25_gtytxp_out,

    // Serial data ports for transceiver channel 26
    input  logic ch26_gtyrxn_in,
    input  logic ch26_gtyrxp_in,
    output logic ch26_gtytxn_out,
    output logic ch26_gtytxp_out,

    // Serial data ports for transceiver channel 27
    input  logic ch27_gtyrxn_in,
    input  logic ch27_gtyrxp_in,
    output logic ch27_gtytxn_out,
    output logic ch27_gtytxp_out,

    // Serial data ports for transceiver channel 28
    input  logic ch28_gtyrxn_in,
    input  logic ch28_gtyrxp_in,
    output logic ch28_gtytxn_out,
    output logic ch28_gtytxp_out,

    // Serial data ports for transceiver channel 29
    input  logic ch29_gtyrxn_in,
    input  logic ch29_gtyrxp_in,
    output logic ch29_gtytxn_out,
    output logic ch29_gtytxp_out,

    // Serial data ports for transceiver channel 30
    input  logic ch30_gtyrxn_in,
    input  logic ch30_gtyrxp_in,
    output logic ch30_gtytxn_out,
    output logic ch30_gtytxp_out,

    // Serial data ports for transceiver channel 31
    input  logic ch31_gtyrxn_in,
    input  logic ch31_gtyrxp_in,
    output logic ch31_gtytxn_out,
    output logic ch31_gtytxp_out,

    // Serial data ports for transceiver channel 32
    input  logic ch32_gtyrxn_in,
    input  logic ch32_gtyrxp_in,
    output logic ch32_gtytxn_out,
    output logic ch32_gtytxp_out,

    // Serial data ports for transceiver channel 33
    input  logic ch33_gtyrxn_in,
    input  logic ch33_gtyrxp_in,
    output logic ch33_gtytxn_out,
    output logic ch33_gtytxp_out,

    // Serial data ports for transceiver channel 34
    input  logic ch34_gtyrxn_in,
    input  logic ch34_gtyrxp_in,
    output logic ch34_gtytxn_out,
    output logic ch34_gtytxp_out,

    // Serial data ports for transceiver channel 35
    input  logic ch35_gtyrxn_in,
    input  logic ch35_gtyrxp_in,
    output logic ch35_gtytxn_out,
    output logic ch35_gtytxp_out,

    // Serial data ports for transceiver channel 36
    input  logic ch36_gtyrxn_in,
    input  logic ch36_gtyrxp_in,
    output logic ch36_gtytxn_out,
    output logic ch36_gtytxp_out,

    // Serial data ports for transceiver channel 37
    input  logic ch37_gtyrxn_in,
    input  logic ch37_gtyrxp_in,
    output logic ch37_gtytxn_out,
    output logic ch37_gtytxp_out,

    // Serial data ports for transceiver channel 38
    input  logic ch38_gtyrxn_in,
    input  logic ch38_gtyrxp_in,
    output logic ch38_gtytxn_out,
    output logic ch38_gtytxp_out,

    // Serial data ports for transceiver channel 39
    input  logic ch39_gtyrxn_in,
    input  logic ch39_gtyrxp_in,
    output logic ch39_gtytxn_out,
    output logic ch39_gtytxp_out,

    // Serial data ports for transceiver channel 40
    input  logic ch40_gtyrxn_in,
    input  logic ch40_gtyrxp_in,
    output logic ch40_gtytxn_out,
    output logic ch40_gtytxp_out,

    // Serial data ports for transceiver channel 41
    input  logic ch41_gtyrxn_in,
    input  logic ch41_gtyrxp_in,
    output logic ch41_gtytxn_out,
    output logic ch41_gtytxp_out,

    // Serial data ports for transceiver channel 42
    input  logic ch42_gtyrxn_in,
    input  logic ch42_gtyrxp_in,
    output logic ch42_gtytxn_out,
    output logic ch42_gtytxp_out,

    // Serial data ports for transceiver channel 43
    input  logic ch43_gtyrxn_in,
    input  logic ch43_gtyrxp_in,
    output logic ch43_gtytxn_out,
    output logic ch43_gtytxp_out,


    // User-provided ports for reset helper block(s)
    input  logic gtwiz_reset_clk_freerun_in_p,
    input  logic gtwiz_reset_clk_freerun_in_n,
    input  logic hb_gtwiz_resetn_all_in,


    //AXI-LITE_SLAVE
    //AW CH
    input  logic [AXI_ADDR_WIDTH-1:0] s_axil_aw_addr,
    input  logic                      s_axil_aw_valid,
    output logic                      s_axil_aw_ready,

    //W CH
    input  logic [AXI_DATA_WIDTH-1:0] s_axil_w_data,
    input  logic                      s_axil_w_strb,
    input  logic                      s_axil_w_valid,
    output logic                      s_axil_w_ready,

    //B CH
    output logic [ 1:0] s_axil_b_resp,
    output logic        s_axil_b_valid,
    input  logic        s_axil_b_ready,

    //AR CH
    input  logic [AXI_ADDR_WIDTH-1:0] s_axil_ar_addr,
    input  logic                      s_axil_ar_valid,
    output logic                      s_axil_ar_ready,

    //R CH
    output logic [AXI_DATA_WIDTH-1:0] s_axil_r_data,
    output logic                      s_axil_r_resp,
    output logic                      s_axil_r_valid,
    input  logic                      s_axil_r_ready

);


    //datapath control signals
    typedef struct packed {
        logic [31:0] pkg_addr;
        logic [31:0] pkg_data;
        logic [31:0] recv_data;
    } payload;

    payload payload_t;

    //ibert channel parameters
    typedef struct packed {
        logic [4:0]    txdiffctrl;
        logic [6:0]    txmaincursor;
        logic [4:0]    txpostcursor;
        logic [4:0]    txprecursor;
        logic [3:0]    txprbssel;
        logic [3:0]    rxprbssel;
        logic [7:0]    channel;
        logic [7:0]    cmd;
        logic [11:0]   quad; 
        logic [0:0]    reset;
        logic [0:0]    reset_status;
        logic [703:0]  es_error_count;
        logic [0:0]    pll_status;
    } ibertload;

    ibertload ibertload_t;

    typedef struct packed {
        logic query_pll_status;
        logic channel_parameter_setting;
        logic resetn;
        logic query_reset_status;
        logic query_ber_channel; 
        logic w_s_axil_complete;
        logic r_s_axil_complete;
        logic registers_read;
    } sgbus_status;

    sgbus_status sgbus_status_t;

    //ibert channel parameter
    logic [219:0] txdiffctrl;   //5'b11000
    logic [307:0] txmaincursor; //7'b1010000
    logic [219:0] txpostcursor;
    logic [175:0] txprbssel;
    logic [219:0] txprecursor;
    logic [175:0] rxprbssel;

    logic [ 43:0] resetn;
    logic [ 10:0] qpll0lock_int;

    //query the ber of a channel
    logic [ 43:0] trigger_int;

    //ibert link status
    logic [ 43:0] link_status_int;


    //datapath control to s_axi_lite_aw_w_ch    
    typedef enum bit [3:0] {
        IDLE,
        AWADDR,
        WDATA,
        WRESP,
        STORE,
        CHANNEL_SET,
        ARADDR,
        RDATA,
        RDATA_SELCET,
        RDATA_RECV,
        WAIT
    } S_AXIL_FSM_STATE;

    (* dont_touch = "true" *) S_AXIL_FSM_STATE s_axil_fsm_curr;


    always_ff@(posedge axil_aclk or negedge axil_aresetn) begin
        if(!axil_aresetn) begin
            s_axil_aw_ready <= 1'b0;
            s_axil_w_ready  <= 1'b0;
            s_axil_ar_ready <= 1'b0;
            s_axil_r_valid  <= 1'b0;
            s_axil_fsm_curr <= IDLE;
        end
        else begin
            case(s_axil_fsm_curr)
                IDLE: begin
                    if(s_axil_aw_valid) begin
                        s_axil_aw_ready <= 1'b1;
                        s_axil_fsm_curr <= AWADDR;
                    end
                    else if(s_axil_ar_valid) begin
                        s_axil_ar_ready <= 1'b1;
                        s_axil_fsm_curr <= ARADDR;
                    end
                    else begin
                        s_axil_aw_ready <= 1'b0;
                        s_axil_ar_ready <= 1'b0;
                        s_axil_fsm_curr <= IDLE;
                    end
                end
                AWADDR: begin
                    if(s_axil_aw_ready && s_axil_aw_valid) begin
                        ibertload_t.channel <= s_axil_aw_addr[15:8];
                        ibertload_t.cmd     <= s_axil_aw_addr[7:0];
                        s_axil_aw_ready     <= 1'b0;
                        s_axil_fsm_curr     <= WDATA;
                        if(s_axil_w_valid) begin
                            s_axil_w_ready  <= 1'b1;
                        end
                        else begin
                            s_axil_w_ready <= 1'b0;
                        end
                    end
                    else begin
                        s_axil_fsm_curr    <= AWADDR;
                    end
                end
                WDATA: begin
                    if(s_axil_w_ready && s_axil_w_valid) begin
                        payload_t.pkg_data <= s_axil_w_data;
                        s_axil_w_ready     <= 1'b0;
                        s_axil_fsm_curr    <= WRESP;
                        if(s_axil_b_ready) begin
                            s_axil_b_valid <= 1'b1;
                        end
                        else begin
                            s_axil_b_valid <= 1'b0;
                        end
                    end
                    else begin
                        s_axil_fsm_curr    <= WDATA;
                    end
                end
                WRESP: begin
                    if(s_axil_b_ready && s_axil_b_valid) begin
                        s_axil_b_resp      <= 2'b00;
                        s_axil_b_valid     <= 1'b1;
                        if(ibertload_t.cmd == 8'h04) begin
                            sgbus_status_t.resetn <= 1'b1;
                            s_axil_fsm_curr       <= STORE;
                        end
                        else if(ibertload_t.cmd == 8'h10) begin
                            sgbus_status_t.channel_parameter_setting <= 1'b1;
                            s_axil_fsm_curr                          <= STORE;
                        end
                        else begin
                            sgbus_status_t.resetn                    <= 1'b0;
                            sgbus_status_t.channel_parameter_setting <= 1'b0;
                            s_axil_fsm_curr                          <= IDLE;
                        end
                    end
                    else begin
                        s_axil_fsm_curr    <= WRESP;
                    end
                end
                STORE: begin
                    if(sgbus_status_t.resetn) begin
                        ibertload_t.reset <= payload_t.pkg_data[0];
                        s_axil_fsm_curr   <= CHANNEL_SET;
                    end
                    else if(sgbus_status_t.channel_parameter_setting) begin
                        ibertload_t.txdiffctrl   <= payload_t.pkg_data[29:25];
                        ibertload_t.txmaincursor <= payload_t.pkg_data[24:18];
                        ibertload_t.txpostcursor <= payload_t.pkg_data[17:13];
                        ibertload_t.txprecursor  <= payload_t.pkg_data[12:8];
                        ibertload_t.txprbssel    <= payload_t.pkg_data[7:4];
                        ibertload_t.rxprbssel    <= payload_t.pkg_data[3:0];
                        s_axil_fsm_curr          <= CHANNEL_SET;
                    end
                    else begin
                        s_axil_fsm_curr <= STORE;
                    end
                end
                CHANNEL_SET: begin
                    if(sgbus_status_t.resetn) begin
                        resetn[ibertload_t.channel] <= ibertload_t.reset;
                        sgbus_status_t.resetn       <= 1'b0;
                        s_axil_fsm_curr             <= WAIT;
                    end
                    else if(sgbus_status_t.channel_parameter_setting) begin
                        txdiffctrl[5*ibertload_t.channel+:5]   <= ibertload_t.txdiffctrl;
                        txmaincursor[7*ibertload_t.channel+:7] <= ibertload_t.txmaincursor;
                        txpostcursor[5*ibertload_t.channel+:5] <= ibertload_t.txpostcursor;
                        txprecursor[5*ibertload_t.channel+:5]  <= ibertload_t.txprecursor;
                        txprbssel[4*ibertload_t.channel+:4]    <= ibertload_t.txprbssel;
                        rxprbssel[4*ibertload_t.channel+:4]    <= ibertload_t.rxprbssel;
                        sgbus_status_t.channel_parameter_setting   <= 1'b0;
                        s_axil_fsm_curr                            <= WAIT;
                    end
                    else begin
                        s_axil_fsm_curr <= CHANNEL_SET;
                    end
                end
                ARADDR: begin
                    if(s_axil_ar_ready && s_axil_ar_valid) begin
                        payload_t.pkg_addr  <= s_axil_ar_addr;
                        ibertload_t.channel <= s_axil_aw_addr[15:8];
                        ibertload_t.cmd     <= s_axil_aw_addr[7:0];
                        s_axil_ar_ready     <= 1'b0;
                        s_axil_r_valid      <= 1'b0;
                        s_axil_fsm_curr     <= RDATA_SELCET;
                    end
                    else begin
                        s_axil_fsm_curr    <= ARADDR;
                    end
                end
                RDATA_SELCET: begin
                    if(ibertload_t.cmd == 8'h05) begin
                        sgbus_status_t.query_reset_status <= 1'b1;
                        s_axil_fsm_curr                   <= RDATA_RECV;
                    end
                    else if(ibertload_t.cmd == 8'h11) begin
                        sgbus_status_t.query_ber_channel <= 1'b1;
                        s_axil_fsm_curr                  <= RDATA_RECV;
                    end
                    else if(ibertload_t.cmd == 8'h12) begin
                        sgbus_status_t.query_pll_status  <= 1'b1;
                        //trigger_int[ibertload_t.channel] <= 1'b1;
                        s_axil_fsm_curr                  <= RDATA_RECV;
                    end
                    else begin
                        sgbus_status_t.query_reset_status <= 1'b0;
                        sgbus_status_t.query_ber_channel  <= 1'b0;
                        sgbus_status_t.query_pll_status   <= 1'b0;
                        s_axil_fsm_curr                   <= RDATA_RECV;
                    end
                end
                RDATA_RECV: begin
                    s_axil_r_valid <= 1'b1;
                    if(sgbus_status_t.query_reset_status) begin
                        payload_t.recv_data <= resetn[ibertload_t.channel];
                        s_axil_fsm_curr     <= RDATA;
                    end
                    else if(sgbus_status_t.query_ber_channel) begin
                        payload_t.recv_data <= ibertload_t.es_error_count[16*ibertload_t.channel+:16];
                        s_axil_fsm_curr     <= RDATA;
                    end
                    else if(sgbus_status_t.query_pll_status) begin
                        payload_t.recv_data <= qpll0lock_int[ibertload_t.channel >> 2];
                        s_axil_fsm_curr     <= RDATA;
                    end
                    else begin
                        payload_t.recv_data <= 32'hFFFF;
                        s_axil_fsm_curr     <= RDATA;
                    end
                end
                RDATA: begin
                    if(s_axil_r_ready && s_axil_r_valid) begin
                        s_axil_r_data      <= payload_t.recv_data;
                        s_axil_r_valid     <= 1'b1;
                        s_axil_fsm_curr    <= WAIT;
                    end
                    else begin
                        s_axil_fsm_curr    <= RDATA;
                    end
                end
                WAIT: begin
                    s_axil_aw_ready <= 1'b0;
                    s_axil_w_ready  <= 1'b0;
                    s_axil_ar_ready <= 1'b0;
                    s_axil_r_valid  <= 1'b0;
                    s_axil_fsm_curr <= IDLE;
                end
                default: begin
                    s_axil_aw_ready <= 1'b0;
                    s_axil_w_ready  <= 1'b0;
                    s_axil_ar_ready <= 1'b0;
                    s_axil_r_valid  <= 1'b0;
                    s_axil_fsm_curr <= IDLE;
                end
            endcase
        end
    end


    // drp interface
    logic [ 43:0] eyescanreset_int;

    logic [439:0] drpaddr_int;
    logic [ 43:0] drpclk_int;
    logic [703:0] drpdi_int;
    logic [703:0] drpdo_int;
    logic [ 43:0] drpen_int;
    logic [ 43:0] drpwe_int;
    logic [ 43:0] drprdy_int;

    genvar i;
    generate;
        for(i = 0; i < 43; i = i + 1) begin :drp
            drp_interface  drp_interface_inst (
                .drp_clk         (hb_gtwiz_reset_clk_freerun_buf_int),
                .drp_rst         (hb_gtwiz_reset_all_buf_int),
                .drp_do_i        (drpdo_int[16*i+:16]),
                .drp_rdy_i       (drprdy_int[i]),
                .drp_addr_o      (drpaddr_int[10*i+:10]),
                .drp_we_o        (drpwe_int[i]),
                .eyescanreset_o  (eyescanreset_int[i]),
                .drp_en_o        (drpen_int[i]),
                .drp_di_o        (drpdi_int[16*i+:16]),
                .trigger_go      (trigger_int[i]),
                .errors          (ibertload_t.es_error_count[16*i+:16])

            );
        end
    endgenerate


    eyescan     eyecan_quad220_ch0(
        .mgtrefclk0_p                   (mgtrefclk0_x0y1_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y1_n),
        .gtyrxn_in                      (ch0_gtyrxn_in),
        .gtyrxp_in                      (ch0_gtyrxp_in),
        .gtytxn_out                     (ch0_gtytxn_out),
        .gtytxp_out                     (ch0_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[0*4+:4]),
        .txmaincursor_int               (txmaincursor[0*6+:6]),
        .txpostcursor_int               (txpostcursor[0*4+:4]),
        .txprecursor_int                (txprbssel[0*3+:3]),
        .txprbssel_int                  (txprecursor[0*4+:4]),
        .rxprbssel_int                  (rxprbssel[0*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[0]),
        .link_status_out                (link_status_int[0])
    );

    eyescan     eyecan_quad220_ch1(
        .mgtrefclk0_p                   (mgtrefclk0_x0y1_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y1_n),
        .gtyrxn_in                      (ch1_gtyrxn_in),
        .gtyrxp_in                      (ch1_gtyrxp_in),
        .gtytxn_out                     (ch1_gtytxn_out),
        .gtytxp_out                     (ch1_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[1*4+:4]),
        .txmaincursor_int               (txmaincursor[1*6+:6]),
        .txpostcursor_int               (txpostcursor[1*4+:4]),
        .txprecursor_int                (txprbssel[1*3+:3]),
        .txprbssel_int                  (txprecursor[1*4+:4]),
        .rxprbssel_int                  (rxprbssel[1*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[1]),
        .link_status_out                (link_status_int[1])
    );

    eyescan     eyecan_quad220_ch2(
        .mgtrefclk0_p                   (mgtrefclk0_x0y1_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y1_n),
        .gtyrxn_in                      (ch2_gtyrxn_in),
        .gtyrxp_in                      (ch2_gtyrxp_in),
        .gtytxn_out                     (ch2_gtytxn_out),
        .gtytxp_out                     (ch2_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[2*4+:4]),
        .txmaincursor_int               (txmaincursor[2*3+:6]),
        .txpostcursor_int               (txpostcursor[2*4+:4]),
        .txprecursor_int                (txprbssel[2*3+:3]),
        .txprbssel_int                  (txprecursor[2*4+:4]),
        .rxprbssel_int                  (rxprbssel[2*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[2]),
        .link_status_out                (link_status_int[2])
    );

    eyescan     eyecan_quad220_ch3(
        .mgtrefclk0_p                   (mgtrefclk0_x0y1_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y1_n),
        .gtyrxn_in                      (ch3_gtyrxn_in),
        .gtyrxp_in                      (ch3_gtyrxp_in),
        .gtytxn_out                     (ch3_gtytxn_out),
        .gtytxp_out                     (ch3_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[3*4+:4]),
        .txmaincursor_int               (txmaincursor[3*6+:6]),
        .txpostcursor_int               (txpostcursor[3*4+:4]),
        .txprecursor_int                (txprbssel[3*3+:3]),
        .txprbssel_int                  (txprecursor[3*4+:4]),
        .rxprbssel_int                  (rxprbssel[3*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[3]),
        .link_status_out                (link_status_int[3])
    );

    eyescan     eyecan_quad221_ch0(
        .mgtrefclk0_p                   (mgtrefclk0_x0y2_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y2_n),
        .gtyrxn_in                      (ch4_gtyrxn_in),
        .gtyrxp_in                      (ch4_gtyrxp_in),
        .gtytxn_out                     (ch4_gtytxn_out),
        .gtytxp_out                     (ch4_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[4*4+:4]),
        .txmaincursor_int               (txmaincursor[4*6+:6]),
        .txpostcursor_int               (txpostcursor[4*4+:4]),
        .txprecursor_int                (txprbssel[4*3+:3]),
        .txprbssel_int                  (txprecursor[4*4+:4]),
        .rxprbssel_int                  (rxprbssel[4*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[4]),
        .link_status_out                (link_status_int[4])
    );

    eyescan     eyecan_quad221_ch1(
        .mgtrefclk0_p                   (mgtrefclk0_x0y2_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y2_n),
        .gtyrxn_in                      (ch5_gtyrxn_in),
        .gtyrxp_in                      (ch5_gtyrxp_in),
        .gtytxn_out                     (ch5_gtytxn_out),
        .gtytxp_out                     (ch5_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[5*4+:4]),
        .txmaincursor_int               (txmaincursor[5*6+:6]),
        .txpostcursor_int               (txpostcursor[5*4+:4]),
        .txprecursor_int                (txprbssel[5*3+:3]),
        .txprbssel_int                  (txprecursor[5*4+:4]),
        .rxprbssel_int                  (rxprbssel[5*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[5]),
        .link_status_out                (link_status_int[5])
    );

    eyescan     eyecan_quad221_ch2(
        .mgtrefclk0_p                   (mgtrefclk0_x0y2_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y2_n),
        .gtyrxn_in                      (ch6_gtyrxn_in),
        .gtyrxp_in                      (ch6_gtyrxp_in),
        .gtytxn_out                     (ch6_gtytxn_out),
        .gtytxp_out                     (ch6_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[6*4+:4]),
        .txmaincursor_int               (txmaincursor[6*6+:6]),
        .txpostcursor_int               (txpostcursor[6*4+:4]),
        .txprecursor_int                (txprbssel[6*3+:3]),
        .txprbssel_int                  (txprecursor[6*4+:4]),
        .rxprbssel_int                  (rxprbssel[6*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[6]),
        .link_status_out                (link_status_int[6])
    );

    eyescan     eyecan_quad221_ch3(
        .mgtrefclk0_p                   (mgtrefclk0_x0y2_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y2_n),
        .gtyrxn_in                      (ch7_gtyrxn_in),
        .gtyrxp_in                      (ch7_gtyrxp_in),
        .gtytxn_out                     (ch7_gtytxn_out),
        .gtytxp_out                     (ch7_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[7*4+:4]),
        .txmaincursor_int               (txmaincursor[7*6+:6]),
        .txpostcursor_int               (txpostcursor[7*4+:4]),
        .txprecursor_int                (txprbssel[7*3+:3]),
        .txprbssel_int                  (txprecursor[7*4+:4]),
        .rxprbssel_int                  (rxprbssel[7*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[7]),
        .link_status_out                (link_status_int[7])
    );

    eyescan     eyecan_quad222_ch0(
        .mgtrefclk0_p                   (mgtrefclk0_x0y3_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y3_n),
        .gtyrxn_in                      (ch8_gtyrxn_in),
        .gtyrxp_in                      (ch8_gtyrxp_in),
        .gtytxn_out                     (ch8_gtytxn_out),
        .gtytxp_out                     (ch8_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[8*4+:4]),
        .txmaincursor_int               (txmaincursor[8*6+:6]),
        .txpostcursor_int               (txpostcursor[8*4+:4]),
        .txprecursor_int                (txprbssel[8*3+:3]),
        .txprbssel_int                  (txprecursor[8*4+:4]),
        .rxprbssel_int                  (rxprbssel[8*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[8]),
        .link_status_out                (link_status_int[8])
    );

    eyescan     eyecan_quad222_ch1(
        .mgtrefclk0_p                   (mgtrefclk0_x0y3_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y3_n),
        .gtyrxn_in                      (ch9_gtyrxn_in),
        .gtyrxp_in                      (ch9_gtyrxp_in),
        .gtytxn_out                     (ch9_gtytxn_out),
        .gtytxp_out                     (ch9_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[9*4+:4]),
        .txmaincursor_int               (txmaincursor[9*6+:6]),
        .txpostcursor_int               (txpostcursor[9*4+:4]),
        .txprecursor_int                (txprbssel[9*3+:3]),
        .txprbssel_int                  (txprecursor[9*4+:4]),
        .rxprbssel_int                  (rxprbssel[9*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[9]),
        .link_status_out                (link_status_int[9])
    );

    eyescan     eyecan_quad222_ch2(
        .mgtrefclk0_p                   (mgtrefclk0_x0y3_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y3_n),
        .gtyrxn_in                      (ch10_gtyrxn_in),
        .gtyrxp_in                      (ch10_gtyrxp_in),
        .gtytxn_out                     (ch10_gtytxn_out),
        .gtytxp_out                     (ch10_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[10*4+:4]),
        .txmaincursor_int               (txmaincursor[10*6+:6]),
        .txpostcursor_int               (txpostcursor[10*4+:4]),
        .txprecursor_int                (txprbssel[10*3+:3]),
        .txprbssel_int                  (txprecursor[10*4+:4]),
        .rxprbssel_int                  (rxprbssel[10*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[10]),
        .link_status_out                (link_status_int[10])
    );

    eyescan     eyecan_quad222_ch3(
        .mgtrefclk0_p                   (mgtrefclk0_x0y3_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y3_n),
        .gtyrxn_in                      (ch11_gtyrxn_in),
        .gtyrxp_in                      (ch11_gtyrxp_in),
        .gtytxn_out                     (ch11_gtytxn_out),
        .gtytxp_out                     (ch11_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[11*4+:4]),
        .txmaincursor_int               (txmaincursor[11*6+:6]),
        .txpostcursor_int               (txpostcursor[11*4+:4]),
        .txprecursor_int                (txprbssel[11*3+:3]),
        .txprbssel_int                  (txprecursor[11*4+:4]),
        .rxprbssel_int                  (rxprbssel[11*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[11]),
        .link_status_out                (link_status_int[11])
    );

    eyescan     eyecan_quad225_ch0(
        .mgtrefclk0_p                   (mgtrefclk0_x0y6_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y6_n),
        .gtyrxn_in                      (ch12_gtyrxn_in),
        .gtyrxp_in                      (ch12_gtyrxp_in),
        .gtytxn_out                     (ch12_gtytxn_out),
        .gtytxp_out                     (ch12_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[12*4+:4]),
        .txmaincursor_int               (txmaincursor[12*6+:6]),
        .txpostcursor_int               (txpostcursor[12*4+:4]),
        .txprecursor_int                (txprbssel[12*3+:3]),
        .txprbssel_int                  (txprecursor[12*4+:4]),
        .rxprbssel_int                  (rxprbssel[12*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[12]),
        .link_status_out                (link_status_int[12])
    );

    eyescan     eyecan_quad225_ch1(
        .mgtrefclk0_p                   (mgtrefclk0_x0y6_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y6_n),
        .gtyrxn_in                      (ch13_gtyrxn_in),
        .gtyrxp_in                      (ch13_gtyrxp_in),
        .gtytxn_out                     (ch13_gtytxn_out),
        .gtytxp_out                     (ch13_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[13*4+:4]),
        .txmaincursor_int               (txmaincursor[13*6+:6]),
        .txpostcursor_int               (txpostcursor[13*4+:4]),
        .txprecursor_int                (txprbssel[13*3+:3]),
        .txprbssel_int                  (txprecursor[13*4+:4]),
        .rxprbssel_int                  (rxprbssel[13*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[13]),
        .link_status_out                (link_status_int[13])
    );

    eyescan     eyecan_quad225_ch2(
        .mgtrefclk0_p                   (mgtrefclk0_x0y6_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y6_n),
        .gtyrxn_in                      (ch14_gtyrxn_in),
        .gtyrxp_in                      (ch14_gtyrxp_in),
        .gtytxn_out                     (ch14_gtytxn_out),
        .gtytxp_out                     (ch14_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[14*4+:4]),
        .txmaincursor_int               (txmaincursor[14*6+:6]),
        .txpostcursor_int               (txpostcursor[14*4+:4]),
        .txprecursor_int                (txprbssel[14*3+:3]),
        .txprbssel_int                  (txprecursor[14*4+:4]),
        .rxprbssel_int                  (rxprbssel[14*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[14]),
        .link_status_out                (link_status_int[14])
    );

    eyescan     eyecan_quad225_ch3(
        .mgtrefclk0_p                   (mgtrefclk0_x0y6_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y6_n),
        .gtyrxn_in                      (ch15_gtyrxn_in),
        .gtyrxp_in                      (ch15_gtyrxp_in),
        .gtytxn_out                     (ch15_gtytxn_out),
        .gtytxp_out                     (ch15_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[15*4+:4]),
        .txmaincursor_int               (txmaincursor[15*6+:6]),
        .txpostcursor_int               (txpostcursor[15*4+:4]),
        .txprecursor_int                (txprbssel[15*3+:3]),
        .txprbssel_int                  (txprecursor[15*4+:4]),
        .rxprbssel_int                  (rxprbssel[15*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[15]),
        .link_status_out                (link_status_int[15])
    );

    eyescan     eyecan_quad226_ch0(
        .mgtrefclk0_p                   (mgtrefclk0_x0y7_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y7_n),
        .gtyrxn_in                      (ch16_gtyrxn_in),
        .gtyrxp_in                      (ch16_gtyrxp_in),
        .gtytxn_out                     (ch16_gtytxn_out),
        .gtytxp_out                     (ch16_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[16*4+:4]),
        .txmaincursor_int               (txmaincursor[16*6+:6]),
        .txpostcursor_int               (txpostcursor[16*4+:4]),
        .txprecursor_int                (txprbssel[16*3+:3]),
        .txprbssel_int                  (txprecursor[16*4+:4]),
        .rxprbssel_int                  (rxprbssel[16*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[16]),
        .link_status_out                (link_status_int[16])
    );

    eyescan     eyecan_quad226_ch1(
        .mgtrefclk0_p                   (mgtrefclk0_x0y7_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y7_n),
        .gtyrxn_in                      (ch17_gtyrxn_in),
        .gtyrxp_in                      (ch17_gtyrxp_in),
        .gtytxn_out                     (ch17_gtytxn_out),
        .gtytxp_out                     (ch17_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[17*4+:4]),
        .txmaincursor_int               (txmaincursor[17*6+:6]),
        .txpostcursor_int               (txpostcursor[17*4+:4]),
        .txprecursor_int                (txprbssel[17*3+:3]),
        .txprbssel_int                  (txprecursor[17*4+:4]),
        .rxprbssel_int                  (rxprbssel[17*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[17]),
        .link_status_out                (link_status_int[17])
    );

    eyescan     eyecan_quad226_ch2(
        .mgtrefclk0_p                   (mgtrefclk0_x0y7_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y7_n),
        .gtyrxn_in                      (ch18_gtyrxn_in),
        .gtyrxp_in                      (ch18_gtyrxp_in),
        .gtytxn_out                     (ch18_gtytxn_out),
        .gtytxp_out                     (ch18_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[18*4+:4]),
        .txmaincursor_int               (txmaincursor[18*6+:6]),
        .txpostcursor_int               (txpostcursor[18*4+:4]),
        .txprecursor_int                (txprbssel[18*3+:3]),
        .txprbssel_int                  (txprecursor[18*4+:4]),
        .rxprbssel_int                  (rxprbssel[18*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[18]),
        .link_status_out                (link_status_int[18])
    );

    eyescan     eyecan_quad226_ch3(
        .mgtrefclk0_p                   (mgtrefclk0_x0y7_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y7_n),
        .gtyrxn_in                      (ch19_gtyrxn_in),
        .gtyrxp_in                      (ch19_gtyrxp_in),
        .gtytxn_out                     (ch19_gtytxn_out),
        .gtytxp_out                     (ch19_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[19*4+:4]),
        .txmaincursor_int               (txmaincursor[19*6+:6]),
        .txpostcursor_int               (txpostcursor[19*4+:4]),
        .txprecursor_int                (txprbssel[19*3+:3]),
        .txprbssel_int                  (txprecursor[19*4+:4]),
        .rxprbssel_int                  (rxprbssel[19*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[19]),
        .link_status_out                (link_status_int[19])
    );

    eyescan     eyecan_quad227_ch0(
        .mgtrefclk0_p                   (mgtrefclk0_x0y8_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y8_n),
        .gtyrxn_in                      (ch20_gtyrxn_in),
        .gtyrxp_in                      (ch20_gtyrxp_in),
        .gtytxn_out                     (ch20_gtytxn_out),
        .gtytxp_out                     (ch20_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[20*4+:4]),
        .txmaincursor_int               (txmaincursor[20*6+:6]),
        .txpostcursor_int               (txpostcursor[20*4+:4]),
        .txprecursor_int                (txprbssel[20*3+:3]),
        .txprbssel_int                  (txprecursor[20*4+:4]),
        .rxprbssel_int                  (rxprbssel[20*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[20]),
        .link_status_out                (link_status_int[20])
    );

    eyescan     eyecan_quad227_ch1(
        .mgtrefclk0_p                   (mgtrefclk0_x0y8_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y8_n),
        .gtyrxn_in                      (ch21_gtyrxn_in),
        .gtyrxp_in                      (ch21_gtyrxp_in),
        .gtytxn_out                     (ch21_gtytxn_out),
        .gtytxp_out                     (ch21_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[21*4+:4]),
        .txmaincursor_int               (txmaincursor[21*6+:6]),
        .txpostcursor_int               (txpostcursor[21*4+:4]),
        .txprecursor_int                (txprbssel[21*3+:3]),
        .txprbssel_int                  (txprecursor[21*4+:4]),
        .rxprbssel_int                  (rxprbssel[21*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[21]),
        .link_status_out                (link_status_int[21])
    );

    eyescan     eyecan_quad227_ch2(
        .mgtrefclk0_p                   (mgtrefclk0_x0y8_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y8_n),
        .gtyrxn_in                      (ch22_gtyrxn_in),
        .gtyrxp_in                      (ch22_gtyrxp_in),
        .gtytxn_out                     (ch22_gtytxn_out),
        .gtytxp_out                     (ch22_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[22*4+:4]),
        .txmaincursor_int               (txmaincursor[22*6+:6]),
        .txpostcursor_int               (txpostcursor[22*4+:4]),
        .txprecursor_int                (txprbssel[22*3+:3]),
        .txprbssel_int                  (txprecursor[22*4+:4]),
        .rxprbssel_int                  (rxprbssel[22*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[22]),
        .link_status_out                (link_status_int[22])
    );

    eyescan     eyecan_quad227_ch3(
        .mgtrefclk0_p                   (mgtrefclk0_x0y8_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y8_n),
        .gtyrxn_in                      (ch23_gtyrxn_in),
        .gtyrxp_in                      (ch23_gtyrxp_in),
        .gtytxn_out                     (ch23_gtytxn_out),
        .gtytxp_out                     (ch23_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[23*4+:4]),
        .txmaincursor_int               (txmaincursor[23*6+:6]),
        .txpostcursor_int               (txpostcursor[23*4+:4]),
        .txprecursor_int                (txprbssel[23*3+:3]),
        .txprbssel_int                  (txprecursor[23*4+:4]),
        .rxprbssel_int                  (rxprbssel[23*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[23]),
        .link_status_out                (link_status_int[23])
    );

    eyescan     eyecan_quad230_ch0(
        .mgtrefclk0_p                   (mgtrefclk0_x0y11_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y11_n),
        .gtyrxn_in                      (ch24_gtyrxn_in),
        .gtyrxp_in                      (ch24_gtyrxp_in),
        .gtytxn_out                     (ch24_gtytxn_out),
        .gtytxp_out                     (ch24_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[24*4+:4]),
        .txmaincursor_int               (txmaincursor[24*6+:6]),
        .txpostcursor_int               (txpostcursor[24*4+:4]),
        .txprecursor_int                (txprbssel[24*3+:3]),
        .txprbssel_int                  (txprecursor[24*4+:4]),
        .rxprbssel_int                  (rxprbssel[24*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[24]),
        .link_status_out                (link_status_int[24])
    );

    eyescan     eyecan_quad230_ch1(
        .mgtrefclk0_p                   (mgtrefclk0_x0y11_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y11_n),
        .gtyrxn_in                      (ch25_gtyrxn_in),
        .gtyrxp_in                      (ch25_gtyrxp_in),
        .gtytxn_out                     (ch25_gtytxn_out),
        .gtytxp_out                     (ch25_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[25*4+:4]),
        .txmaincursor_int               (txmaincursor[25*6+:6]),
        .txpostcursor_int               (txpostcursor[25*4+:4]),
        .txprecursor_int                (txprbssel[25*3+:3]),
        .txprbssel_int                  (txprecursor[25*4+:4]),
        .rxprbssel_int                  (rxprbssel[25*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[25]),
        .link_status_out                (link_status_int[25])
    );

    eyescan     eyecan_quad230_ch2(
        .mgtrefclk0_p                   (mgtrefclk0_x0y11_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y11_n),
        .gtyrxn_in                      (ch26_gtyrxn_in),
        .gtyrxp_in                      (ch26_gtyrxp_in),
        .gtytxn_out                     (ch26_gtytxn_out),
        .gtytxp_out                     (ch26_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[26*4+:4]),
        .txmaincursor_int               (txmaincursor[26*6+:6]),
        .txpostcursor_int               (txpostcursor[26*4+:4]),
        .txprecursor_int                (txprbssel[26*3+:3]),
        .txprbssel_int                  (txprecursor[26*4+:4]),
        .rxprbssel_int                  (rxprbssel[26*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[26]),
        .link_status_out                (link_status_int[26])
    );

    eyescan     eyecan_quad230_ch3(
        .mgtrefclk0_p                   (mgtrefclk0_x0y11_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y11_n),
        .gtyrxn_in                      (ch27_gtyrxn_in),
        .gtyrxp_in                      (ch27_gtyrxp_in),
        .gtytxn_out                     (ch27_gtytxn_out),
        .gtytxp_out                     (ch27_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[27*4+:4]),
        .txmaincursor_int               (txmaincursor[27*6+:6]),
        .txpostcursor_int               (txpostcursor[27*4+:4]),
        .txprecursor_int                (txprbssel[27*3+:3]),
        .txprbssel_int                  (txprecursor[27*4+:4]),
        .rxprbssel_int                  (rxprbssel[27*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[27]),
        .link_status_out                (link_status_int[27])
    );

    eyescan     eyecan_quad231_ch0(
        .mgtrefclk0_p                   (mgtrefclk0_x0y12_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y12_n),
        .gtyrxn_in                      (ch28_gtyrxn_in),
        .gtyrxp_in                      (ch28_gtyrxp_in),
        .gtytxn_out                     (ch28_gtytxn_out),
        .gtytxp_out                     (ch28_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[28*4+:4]),
        .txmaincursor_int               (txmaincursor[28*6+:6]),
        .txpostcursor_int               (txpostcursor[28*4+:4]),
        .txprecursor_int                (txprbssel[28*3+:3]),
        .txprbssel_int                  (txprecursor[28*4+:4]),
        .rxprbssel_int                  (rxprbssel[28*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[28]),
        .link_status_out                (link_status_int[28])
    );

    eyescan     eyecan_quad231_ch1(
        .mgtrefclk0_p                   (mgtrefclk0_x0y12_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y12_n),
        .gtyrxn_in                      (ch29_gtyrxn_in),
        .gtyrxp_in                      (ch29_gtyrxp_in),
        .gtytxn_out                     (ch29_gtytxn_out),
        .gtytxp_out                     (ch29_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[29*4+:4]),
        .txmaincursor_int               (txmaincursor[29*6+:6]),
        .txpostcursor_int               (txpostcursor[29*4+:4]),
        .txprecursor_int                (txprbssel[29*3+:3]),
        .txprbssel_int                  (txprecursor[29*4+:4]),
        .rxprbssel_int                  (rxprbssel[29*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[29]),
        .link_status_out                (link_status_int[29])
    );

    eyescan     eyecan_quad231_ch2(
        .mgtrefclk0_p                   (mgtrefclk0_x0y12_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y12_n),
        .gtyrxn_in                      (ch30_gtyrxn_in),
        .gtyrxp_in                      (ch30_gtyrxp_in),
        .gtytxn_out                     (ch30_gtytxn_out),
        .gtytxp_out                     (ch30_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[30*4+:4]),
        .txmaincursor_int               (txmaincursor[30*6+:6]),
        .txpostcursor_int               (txpostcursor[30*4+:4]),
        .txprecursor_int                (txprbssel[30*3+:3]),
        .txprbssel_int                  (txprecursor[30*4+:4]),
        .rxprbssel_int                  (rxprbssel[30*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[30]),
        .link_status_out                (link_status_int[30])
    );

    eyescan     eyecan_quad231_ch3(
        .mgtrefclk0_p                   (mgtrefclk0_x0y12_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y12_n),
        .gtyrxn_in                      (ch31_gtyrxn_in),
        .gtyrxp_in                      (ch31_gtyrxp_in),
        .gtytxn_out                     (ch31_gtytxn_out),
        .gtytxp_out                     (ch31_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[31*4+:4]),
        .txmaincursor_int               (txmaincursor[31*6+:6]),
        .txpostcursor_int               (txpostcursor[31*4+:4]),
        .txprecursor_int                (txprbssel[31*3+:3]),
        .txprbssel_int                  (txprecursor[31*4+:4]),
        .rxprbssel_int                  (rxprbssel[31*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[31]),
        .link_status_out                (link_status_int[31])
    );

    eyescan     eyecan_quad235_ch0(
        .mgtrefclk0_p                   (mgtrefclk0_x0y16_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y16_n),
        .gtyrxn_in                      (ch32_gtyrxn_in),
        .gtyrxp_in                      (ch32_gtyrxp_in),
        .gtytxn_out                     (ch32_gtytxn_out),
        .gtytxp_out                     (ch32_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[32*4+:4]),
        .txmaincursor_int               (txmaincursor[32*6+:6]),
        .txpostcursor_int               (txpostcursor[32*4+:4]),
        .txprecursor_int                (txprbssel[32*3+:3]),
        .txprbssel_int                  (txprecursor[32*4+:4]),
        .rxprbssel_int                  (rxprbssel[32*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[32]),
        .link_status_out                (link_status_int[32])
    );

    eyescan     eyecan_quad235_ch1(
        .mgtrefclk0_p                   (mgtrefclk0_x0y16_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y16_n),
        .gtyrxn_in                      (ch33_gtyrxn_in),
        .gtyrxp_in                      (ch33_gtyrxp_in),
        .gtytxn_out                     (ch33_gtytxn_out),
        .gtytxp_out                     (ch33_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[33*4+:4]),
        .txmaincursor_int               (txmaincursor[33*6+:6]),
        .txpostcursor_int               (txpostcursor[33*4+:4]),
        .txprecursor_int                (txprbssel[33*3+:3]),
        .txprbssel_int                  (txprecursor[33*4+:4]),
        .rxprbssel_int                  (rxprbssel[33*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[33]),
        .link_status_out                (link_status_int[33])
    );

    eyescan     eyecan_quad235_ch2(
        .mgtrefclk0_p                   (mgtrefclk0_x0y16_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y16_n),
        .gtyrxn_in                      (ch34_gtyrxn_in),
        .gtyrxp_in                      (ch34_gtyrxp_in),
        .gtytxn_out                     (ch34_gtytxn_out),
        .gtytxp_out                     (ch34_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[34*4+:4]),
        .txmaincursor_int               (txmaincursor[34*6+:6]),
        .txpostcursor_int               (txpostcursor[34*4+:4]),
        .txprecursor_int                (txprbssel[34*3+:3]),
        .txprbssel_int                  (txprecursor[34*4+:4]),
        .rxprbssel_int                  (rxprbssel[34*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[34]),
        .link_status_out                (link_status_int[34])
    );

    eyescan     eyecan_quad235_ch3(
        .mgtrefclk0_p                   (mgtrefclk0_x0y16_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y16_n),
        .gtyrxn_in                      (ch35_gtyrxn_in),
        .gtyrxp_in                      (ch35_gtyrxp_in),
        .gtytxn_out                     (ch35_gtytxn_out),
        .gtytxp_out                     (ch35_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[35*4+:4]),
        .txmaincursor_int               (txmaincursor[35*6+:6]),
        .txpostcursor_int               (txpostcursor[35*4+:4]),
        .txprecursor_int                (txprbssel[35*3+:3]),
        .txprbssel_int                  (txprecursor[35*4+:4]),
        .rxprbssel_int                  (rxprbssel[35*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[35]),
        .link_status_out                (link_status_int[35])
    );

    eyescan     eyecan_quad236_ch0(
        .mgtrefclk0_p                   (mgtrefclk0_x0y17_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y17_n),
        .gtyrxn_in                      (ch36_gtyrxn_in),
        .gtyrxp_in                      (ch36_gtyrxp_in),
        .gtytxn_out                     (ch36_gtytxn_out),
        .gtytxp_out                     (ch36_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[36*4+:4]),
        .txmaincursor_int               (txmaincursor[36*6+:6]),
        .txpostcursor_int               (txpostcursor[36*4+:4]),
        .txprecursor_int                (txprbssel[36*3+:3]),
        .txprbssel_int                  (txprecursor[36*4+:4]),
        .rxprbssel_int                  (rxprbssel[36*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[36]),
        .link_status_out                (link_status_int[36])
    );

    eyescan     eyecan_quad236_ch1(
        .mgtrefclk0_p                   (mgtrefclk0_x0y17_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y17_n),
        .gtyrxn_in                      (ch37_gtyrxn_in),
        .gtyrxp_in                      (ch37_gtyrxp_in),
        .gtytxn_out                     (ch37_gtytxn_out),
        .gtytxp_out                     (ch37_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[37*4+:4]),
        .txmaincursor_int               (txmaincursor[37*6+:6]),
        .txpostcursor_int               (txpostcursor[37*4+:4]),
        .txprecursor_int                (txprbssel[37*3+:3]),
        .txprbssel_int                  (txprecursor[37*4+:4]),
        .rxprbssel_int                  (rxprbssel[37*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[37]),
        .link_status_out                (link_status_int[37])
    );

    eyescan     eyecan_quad236_ch2(
        .mgtrefclk0_p                   (mgtrefclk0_x0y17_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y17_n),
        .gtyrxn_in                      (ch38_gtyrxn_in),
        .gtyrxp_in                      (ch38_gtyrxp_in),
        .gtytxn_out                     (ch38_gtytxn_out),
        .gtytxp_out                     (ch38_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[38*4+:4]),
        .txmaincursor_int               (txmaincursor[38*6+:6]),
        .txpostcursor_int               (txpostcursor[38*4+:4]),
        .txprecursor_int                (txprbssel[38*3+:3]),
        .txprbssel_int                  (txprecursor[38*4+:4]),
        .rxprbssel_int                  (rxprbssel[38*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[38]),
        .link_status_out                (link_status_int[38])
    );

    eyescan     eyecan_quad236_ch3(
        .mgtrefclk0_p                   (mgtrefclk0_x0y17_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y17_n),
        .gtyrxn_in                      (ch39_gtyrxn_in),
        .gtyrxp_in                      (ch39_gtyrxp_in),
        .gtytxn_out                     (ch39_gtytxn_out),
        .gtytxp_out                     (ch39_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[39*4+:4]),
        .txmaincursor_int               (txmaincursor[39*6+:6]),
        .txpostcursor_int               (txpostcursor[39*4+:4]),
        .txprecursor_int                (txprbssel[39*3+:3]),
        .txprbssel_int                  (txprecursor[39*4+:4]),
        .rxprbssel_int                  (rxprbssel[39*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[39]),
        .link_status_out                (link_status_int[39])
    );

    eyescan     eyecan_quad237_ch0(
        .mgtrefclk0_p                   (mgtrefclk0_x0y18_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y18_n),
        .gtyrxn_in                      (ch40_gtyrxn_in),
        .gtyrxp_in                      (ch40_gtyrxp_in),
        .gtytxn_out                     (ch40_gtytxn_out),
        .gtytxp_out                     (ch40_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[40*4+:4]),
        .txmaincursor_int               (txmaincursor[40*6+:6]),
        .txpostcursor_int               (txpostcursor[40*4+:4]),
        .txprecursor_int                (txprbssel[40*3+:3]),
        .txprbssel_int                  (txprecursor[40*4+:4]),
        .rxprbssel_int                  (rxprbssel[40*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[40]),
        .link_status_out                (link_status_int[40])
    );

    eyescan     eyecan_quad237_ch1(
        .mgtrefclk0_p                   (mgtrefclk0_x0y18_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y18_n),
        .gtyrxn_in                      (ch41_gtyrxn_in),
        .gtyrxp_in                      (ch41_gtyrxp_in),
        .gtytxn_out                     (ch41_gtytxn_out),
        .gtytxp_out                     (ch41_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[41*4+:4]),
        .txmaincursor_int               (txmaincursor[41*6+:6]),
        .txpostcursor_int               (txpostcursor[41*4+:4]),
        .txprecursor_int                (txprbssel[41*3+:3]),
        .txprbssel_int                  (txprecursor[41*4+:4]),
        .rxprbssel_int                  (rxprbssel[41*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[41]),
        .link_status_out                (link_status_int[41])
    );

    eyescan     eyecan_quad237_ch2(
        .mgtrefclk0_p                   (mgtrefclk0_x0y18_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y18_n),
        .gtyrxn_in                      (ch42_gtyrxn_in),
        .gtyrxp_in                      (ch42_gtyrxp_in),
        .gtytxn_out                     (ch42_gtytxn_out),
        .gtytxp_out                     (ch42_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[42*4+:4]),
        .txmaincursor_int               (txmaincursor[42*6+:6]),
        .txpostcursor_int               (txpostcursor[42*4+:4]),
        .txprecursor_int                (txprbssel[42*3+:3]),
        .txprbssel_int                  (txprecursor[42*4+:4]),
        .rxprbssel_int                  (rxprbssel[42*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[42]),
        .link_status_out                (link_status_int[42])
    );

    eyescan     eyecan_quad237_ch3(
        .mgtrefclk0_p                   (mgtrefclk0_x0y18_p),
        .mgtrefclk0_n                   (mgtrefclk0_x0y18_n),
        .gtyrxn_in                      (ch43_gtyrxn_in),
        .gtyrxp_in                      (ch43_gtyrxp_in),
        .gtytxn_out                     (ch43_gtytxn_out),
        .gtytxp_out                     (ch43_gtytxp_out),
        .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
        .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
        .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
        .txdiffctrl_int                 (txdiffctrl[43*4+:4]),
        .txmaincursor_int               (txmaincursor[43*6+:6]),
        .txpostcursor_int               (txpostcursor[43*4+:4]),
        .txprecursor_int                (txprbssel[43*3+:3]),
        .txprbssel_int                  (txprecursor[43*4+:4]),
        .rxprbssel_int                  (rxprbssel[43*3+:3]),
        .qpll0lock_out                  (qpll0lock_int[43]),
        .link_status_out                (link_status_int[43])
    );


endmodule
