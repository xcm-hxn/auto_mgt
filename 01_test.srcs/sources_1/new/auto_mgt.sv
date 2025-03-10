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


module auto_mgt(

    input  logic axil_aclk,
    input  logic axil_aresetn,

    // Differential reference clock inputs
    input  logic mgtrefclk0_x0y1_p,
    input  logic mgtrefclk0_x0y1_n,

    // Serial data ports for transceiver channel 0
    input  logic ch0_gtyrxn_in,
    input  logic ch0_gtyrxp_in,
    output logic ch0_gtytxn_out,
    output logic ch0_gtytxp_out,

    // User-provided ports for reset helper block(s)
    input  logic gtwiz_reset_clk_freerun_in_p,
    input  logic gtwiz_reset_clk_freerun_in_n,
    input  logic hb_gtwiz_resetn_all_in,

    // Serial data ports for transceiver channel 1
    // input  logic ch1_gtyrxn_in,
    // input  logic ch1_gtyrxp_in,
    // output logic ch1_gtytxn_out,
    // output logic ch1_gtytxp_out,

    //AXI-LITE_SLAVE
    //AW CH
    input  logic [31:0] s_axil_aw_addr,
    input  logic        s_axil_aw_valid,
    output logic        s_axil_aw_ready,

    //W CH
    input  logic [31:0] s_axil_w_data,
    input  logic        s_axil_w_strb,
    input  logic        s_axil_w_valid,
    output logic        s_axil_w_ready,

    //B CH
    output logic [ 1:0] s_axil_b_resp,
    output logic        s_axil_b_valid,
    input  logic        s_axil_b_ready,

    //AR CH
    input  logic [31:0] s_axil_ar_addr,
    input  logic        s_axil_ar_valid,
    output logic        s_axil_ar_ready,

    //R CH
    output logic [31:0] s_axil_r_data,
    output logic        s_axil_r_resp,
    output logic        s_axil_r_valid,
    input  logic        s_axil_r_ready

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
        .txdiffctrl_int                 (txdiffctrl[0+:4]),
        .txmaincursor_int               (txmaincursor[0+:6]),
        .txpostcursor_int               (txpostcursor[0+:4]),
        .txprecursor_int                (txprbssel[0+:3]),
        .txprbssel_int                  (txprecursor[0+:4]),
        .rxprbssel_int                  (rxprbssel[0+:3]),
        .qpll0lock_out                  (qpll0lock_int[0]),
        .link_status_out                (link_status_int[0])
    );

    // eyescan     eyecan_quad220_ch1(
    //     .mgtrefclk0_p                   (mgtrefclk0_x0y1_p),
    //     .mgtrefclk0_n                   (mgtrefclk0_x0y1_n),
    //     .gtyrxn_in                      (ch1_gtyrxn_in),
    //     .gtyrxp_in                      (ch1_gtyrxp_in),
    //     .gtytxn_out                     (ch1_gtytxn_out),
    //     .gtytxp_out                     (ch1_gtytxp_out),
    //     .gtwiz_reset_clk_freerun_in_p   (gtwiz_reset_clk_freerun_in_p),
    //     .gtwiz_reset_clk_freerun_in_n   (gtwiz_reset_clk_freerun_in_n),
    //     .hb_gtwiz_resetn_all_in         (hb_gtwiz_resetn_all_in),
    //     .txdiffctrl_int                 (txdiffctrl[4+:4]),
    //     .txmaincursor_int               (txmaincursor[6+:6]),
    //     .txpostcursor_int               (txpostcursor[4+:4]),
    //     .txprecursor_int                (txprbssel[3+:3]),
    //     .txprbssel_int                  (txprecursor[4+:4]),
    //     .rxprbssel_int                  (rxprbssel[3+:3]),
    //     .qpll0lock_out                  (qpll0lock_int[1]),
    //     .es_error_count                 (),
    //     .link_status_out                (),
    //     .trigger_int                    ()
    // );



endmodule
