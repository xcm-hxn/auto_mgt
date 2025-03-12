`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/11 14:03:46
// Design Name: 
// Module Name: eyescan
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


module eyescan #(
    parameter integer AXI_ADDR_WIDTH = 32,
    parameter integer AXI_DATA_WIDTH = 32,
    parameter integer QUAD           = 11,
    parameter integer CHANNEL        = 44
) (
    input  logic axil_aclk,
    input  logic axil_aresetn,

    // Differential reference clock inputs
    input  logic quad220_clk_p,
    input  logic quad220_clk_n,
    input  logic quad221_clk_p,
    input  logic quad221_clk_n,
    input  logic quad222_clk_p,
    input  logic quad222_clk_n,
    input  logic quad225_clk_p,
    input  logic quad225_clk_n,
    input  logic quad226_clk_p,
    input  logic quad226_clk_n,
    input  logic quad227_clk_p,
    input  logic quad227_clk_n,
    input  logic quad230_clk_p,
    input  logic quad230_clk_n,
    input  logic quad231_clk_p,
    input  logic quad231_clk_n,
    input  logic quad235_clk_p,
    input  logic quad235_clk_n,
    input  logic quad236_clk_p,
    input  logic quad236_clk_n,
    input  logic quad237_clk_p,
    input  logic quad237_clk_n,





    // Serial data ports for transceiver channel 0
    input  logic quad220_ch0_gtyrxn_in,
    input  logic quad220_ch0_gtyrxp_in,
    output logic quad220_ch0_gtytxn_out,
    output logic quad220_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 1
    input  logic quad220_ch1_gtyrxn_in,
    input  logic quad220_ch1_gtyrxp_in,
    output logic quad220_ch1_gtytxn_out,
    output logic quad220_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 2
    input  logic quad220_ch2_gtyrxn_in,
    input  logic quad220_ch2_gtyrxp_in,
    output logic quad220_ch2_gtytxn_out,
    output logic quad220_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 3
    input  logic quad220_ch3_gtyrxn_in,
    input  logic quad220_ch3_gtyrxp_in,
    output logic quad220_ch3_gtytxn_out,
    output logic quad220_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 4
    input  logic quad221_ch0_gtyrxn_in,
    input  logic quad221_ch0_gtyrxp_in,
    output logic quad221_ch0_gtytxn_out,
    output logic quad221_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 5
    input  logic quad221_ch1_gtyrxn_in,
    input  logic quad221_ch1_gtyrxp_in,
    output logic quad221_ch1_gtytxn_out,
    output logic quad221_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 6
    input  logic quad221_ch2_gtyrxn_in,
    input  logic quad221_ch2_gtyrxp_in,
    output logic quad221_ch2_gtytxn_out,
    output logic quad221_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 7
    input  logic quad221_ch3_gtyrxn_in,
    input  logic quad221_ch3_gtyrxp_in,
    output logic quad221_ch3_gtytxn_out,
    output logic quad221_ch3_gtytxp_out,


    // Serial data ports for transceiver channel 8
    input  logic quad222_ch0_gtyrxn_in,
    input  logic quad222_ch0_gtyrxp_in,
    output logic quad222_ch0_gtytxn_out,
    output logic quad222_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 9
    input  logic quad222_ch1_gtyrxn_in,
    input  logic quad222_ch1_gtyrxp_in,
    output logic quad222_ch1_gtytxn_out,
    output logic quad222_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 10
    input  logic quad222_ch2_gtyrxn_in,
    input  logic quad222_ch2_gtyrxp_in,
    output logic quad222_ch2_gtytxn_out,
    output logic quad222_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 11
    input  logic quad222_ch3_gtyrxn_in,
    input  logic quad222_ch3_gtyrxp_in,
    output logic quad222_ch3_gtytxn_out,
    output logic quad222_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 12
    input  logic quad225_ch0_gtyrxn_in,
    input  logic quad225_ch0_gtyrxp_in,
    output logic quad225_ch0_gtytxn_out,
    output logic quad225_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 13
    input  logic quad225_ch1_gtyrxn_in,
    input  logic quad225_ch1_gtyrxp_in,
    output logic quad225_ch1_gtytxn_out,
    output logic quad225_ch1_gtytxp_out,


    // Serial data ports for transceiver channel 14
    input  logic quad225_ch2_gtyrxn_in,
    input  logic quad225_ch2_gtyrxp_in,
    output logic quad225_ch2_gtytxn_out,
    output logic quad225_ch2_gtytxp_out,


    // Serial data ports for transceiver channel 15
    input  logic quad225_ch3_gtyrxn_in,
    input  logic quad225_ch3_gtyrxp_in,
    output logic quad225_ch3_gtytxn_out,
    output logic quad225_ch3_gtytxp_out,


    // Serial data ports for transceiver channel 16
    input  logic quad226_ch0_gtyrxn_in,
    input  logic quad226_ch0_gtyrxp_in,
    output logic quad226_ch0_gtytxn_out,
    output logic quad226_ch0_gtytxp_out,


    // Serial data ports for transceiver channel 17
    input  logic quad226_ch1_gtyrxn_in,
    input  logic quad226_ch1_gtyrxp_in,
    output logic quad226_ch1_gtytxn_out,
    output logic quad226_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 18
    input  logic quad226_ch2_gtyrxn_in,
    input  logic quad226_ch2_gtyrxp_in,
    output logic quad226_ch2_gtytxn_out,
    output logic quad226_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 19
    input  logic quad226_ch3_gtyrxn_in,
    input  logic quad226_ch3_gtyrxp_in,
    output logic quad226_ch3_gtytxn_out,
    output logic quad226_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 20
    input  logic quad227_ch0_gtyrxn_in,
    input  logic quad227_ch0_gtyrxp_in,
    output logic quad227_ch0_gtytxn_out,
    output logic quad227_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 21
    input  logic quad227_ch1_gtyrxn_in,
    input  logic quad227_ch1_gtyrxp_in,
    output logic quad227_ch1_gtytxn_out,
    output logic quad227_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 22
    input  logic quad227_ch2_gtyrxn_in,
    input  logic quad227_ch2_gtyrxp_in,
    output logic quad227_ch2_gtytxn_out,
    output logic quad227_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 23
    input  logic quad227_ch3_gtyrxn_in,
    input  logic quad227_ch3_gtyrxp_in,
    output logic quad227_ch3_gtytxn_out,
    output logic quad227_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 24
    input  logic quad230_ch0_gtyrxn_in,
    input  logic quad230_ch0_gtyrxp_in,
    output logic quad230_ch0_gtytxn_out,
    output logic quad230_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 25
    input  logic quad230_ch1_gtyrxn_in,
    input  logic quad230_ch1_gtyrxp_in,
    output logic quad230_ch1_gtytxn_out,
    output logic quad230_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 26
    input  logic quad230_ch2_gtyrxn_in,
    input  logic quad230_ch2_gtyrxp_in,
    output logic quad230_ch2_gtytxn_out,
    output logic quad230_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 27
    input  logic quad230_ch3_gtyrxn_in,
    input  logic quad230_ch3_gtyrxp_in,
    output logic quad230_ch3_gtytxn_out,
    output logic quad230_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 28
    input  logic quad231_ch0_gtyrxn_in,
    input  logic quad231_ch0_gtyrxp_in,
    output logic quad231_ch0_gtytxn_out,
    output logic quad231_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 29
    input  logic quad231_ch1_gtyrxn_in,
    input  logic quad231_ch1_gtyrxp_in,
    output logic quad231_ch1_gtytxn_out,
    output logic quad231_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 30
    input  logic quad231_ch2_gtyrxn_in,
    input  logic quad231_ch2_gtyrxp_in,
    output logic quad231_ch2_gtytxn_out,
    output logic quad231_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 31
    input  logic quad231_ch3_gtyrxn_in,
    input  logic quad231_ch3_gtyrxp_in,
    output logic quad231_ch3_gtytxn_out,
    output logic quad231_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 32
    input  logic quad235_ch0_gtyrxn_in,
    input  logic quad235_ch0_gtyrxp_in,
    output logic quad235_ch0_gtytxn_out,
    output logic quad235_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 33
    input  logic quad235_ch1_gtyrxn_in,
    input  logic quad235_ch1_gtyrxp_in,
    output logic quad235_ch1_gtytxn_out,
    output logic quad235_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 34
    input  logic quad235_ch2_gtyrxn_in,
    input  logic quad235_ch2_gtyrxp_in,
    output logic quad235_ch2_gtytxn_out,
    output logic quad235_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 35
    input  logic quad235_ch3_gtyrxn_in,
    input  logic quad235_ch3_gtyrxp_in,
    output logic quad235_ch3_gtytxn_out,
    output logic quad235_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 36
    input  logic quad236_ch0_gtyrxn_in,
    input  logic quad236_ch0_gtyrxp_in,
    output logic quad236_ch0_gtytxn_out,
    output logic quad236_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 37
    input  logic quad236_ch1_gtyrxn_in,
    input  logic quad236_ch1_gtyrxp_in,
    output logic quad236_ch1_gtytxn_out,
    output logic quad236_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 38
    input  logic quad236_ch2_gtyrxn_in,
    input  logic quad236_ch2_gtyrxp_in,
    output logic quad236_ch2_gtytxn_out,
    output logic quad236_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 39
    input  logic quad236_ch3_gtyrxn_in,
    input  logic quad236_ch3_gtyrxp_in,
    output logic quad236_ch3_gtytxn_out,
    output logic quad236_ch3_gtytxp_out,

    // Serial data ports for transceiver channel 40
    input  logic quad237_ch0_gtyrxn_in,
    input  logic quad237_ch0_gtyrxp_in,
    output logic quad237_ch0_gtytxn_out,
    output logic quad237_ch0_gtytxp_out,

    // Serial data ports for transceiver channel 41
    input  logic quad237_ch1_gtyrxn_in,
    input  logic quad237_ch1_gtyrxp_in,
    output logic quad237_ch1_gtytxn_out,
    output logic quad237_ch1_gtytxp_out,

    // Serial data ports for transceiver channel 42
    input  logic quad237_ch2_gtyrxn_in,
    input  logic quad237_ch2_gtyrxp_in,
    output logic quad237_ch2_gtytxn_out,
    output logic quad237_ch2_gtytxp_out,

    // Serial data ports for transceiver channel 43
    input  logic quad237_ch3_gtyrxn_in,
    input  logic quad237_ch3_gtyrxp_in,
    output logic quad237_ch3_gtytxn_out,
    output logic quad237_ch3_gtytxp_out,


    // User-provided ports for reset helper block(s)
    input  logic gtwiz_reset_clk_freerun_in_p,
    input  logic gtwiz_reset_clk_freerun_in_n,



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
    output logic [ 1:0]               s_axil_r_resp,
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

    assign s_axil_r_resp = 2'b00;

    (* dont_touch = "true" *) S_AXIL_FSM_STATE s_axil_fsm_curr;


    always_ff@(posedge axil_aclk or negedge axil_aresetn) begin
        if(!axil_aresetn) begin
            s_axil_aw_ready   <= 1'b0;
            s_axil_w_ready    <= 1'b0;
            s_axil_ar_ready   <= 1'b0;
            s_axil_r_valid    <= 1'b0;
            s_axil_b_valid    <= 1'b0;
            resetn            <= 0;
            ibertload_t.reset <= 0;
            s_axil_fsm_curr   <= IDLE;
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
                        s_axil_w_ready      <= 1'b1;
                        s_axil_fsm_curr     <= WDATA;
                    end
                    else begin
                        s_axil_fsm_curr    <= AWADDR;
                    end
                end
                WDATA: begin
                    if(s_axil_w_ready && s_axil_w_valid) begin
                        payload_t.pkg_data <= s_axil_w_data;
                        s_axil_w_ready     <= 1'b0;
                        s_axil_b_valid     <= 1'b1;
                        s_axil_fsm_curr    <= WRESP;
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
                            s_axil_b_valid        <= 1'b0;
                            s_axil_fsm_curr       <= STORE;
                        end
                        else if(ibertload_t.cmd == 8'h10) begin
                            sgbus_status_t.channel_parameter_setting <= 1'b1;
                            s_axil_b_valid                           <= 1'b0;
                            s_axil_fsm_curr                          <= STORE;
                        end
                        else begin
                            s_axil_b_valid                           <= 1'b0;
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
                        if(ibertload_t.channel > 'd43)begin
                            payload_t.recv_data <= 32'hFFFFFFFF;
                            s_axil_fsm_curr     <= RDATA;
                        end
                        else begin
                            payload_t.recv_data <= resetn[ibertload_t.channel];
                            s_axil_fsm_curr     <= RDATA;
                        end
                    end
                    else if(sgbus_status_t.query_ber_channel) begin
                        if(ibertload_t.channel > 'd43)begin
                            payload_t.recv_data <= 32'hFFFFFFFF;
                            s_axil_fsm_curr     <= RDATA;
                        end
                        else begin
                            payload_t.recv_data <= ibertload_t.es_error_count[16*ibertload_t.channel+:16];
                            s_axil_fsm_curr     <= RDATA;
                        end
                    end
                    else if(sgbus_status_t.query_pll_status) begin
                        if(ibertload_t.channel > 'd43)begin
                            payload_t.recv_data <= 32'hFFFFFFFF;
                            s_axil_fsm_curr     <= RDATA;
                        end
                        else begin
                            payload_t.recv_data <= qpll0lock_int[ibertload_t.channel >> 2];
                            s_axil_fsm_curr     <= RDATA;
                        end
                    end
                    else begin
                        payload_t.recv_data <= 32'hFFFFFFFF;
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
                    s_axil_b_valid  <= 1'b0;
                    resetn          <= 0;
                    s_axil_fsm_curr <= IDLE;
                end
                default: begin
                    s_axil_aw_ready <= 1'b0;
                    s_axil_w_ready  <= 1'b0;
                    s_axil_ar_ready <= 1'b0;
                    s_axil_r_valid  <= 1'b0;
                    s_axil_b_valid  <= 1'b0;
                    resetn          <= 0;
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
    
    logic hb_gtwiz_reset_clk_freerun_in;
    logic hb_gtwiz_reset_clk_freerun_buf_int;
    IBUFGDS clk_freerun_in_inst (
        .I  (gtwiz_reset_clk_freerun_in_p),
        .IB (gtwiz_reset_clk_freerun_in_n),
        .O  (hb_gtwiz_reset_clk_freerun_in)
    );

    BUFG bufg_clk_freerun_inst (
        .I (hb_gtwiz_reset_clk_freerun_in),
        .O (hb_gtwiz_reset_clk_freerun_buf_int)
    );

    genvar i;
    generate;
        for(i = 0; i < CHANNEL; i = i + 1) begin :drp
            drp_interface  drp_interface_inst (
                .drp_clk         (hb_gtwiz_reset_clk_freerun_buf_int),
                .drp_rst         (resetn[i]),
                .drp_do_i        (drpdo_int[16*i+:16]),
                .drp_rdy_i       (drprdy_int[i]),
                .drp_addr_o      (drpaddr_int[10*i+:10]),
                .drp_we_o        (drpwe_int[i]),
                .eyescanreset_o  (eyescanreset_int[i]),
                .drp_en_o        (drpen_int[i]),
                .drp_di_o        (drpdi_int[16*i+:16]),
                .trigger_go      (trigger_int[i]),
                .errors          (ibertload_t.es_error_count[16*i+:16]),
                .samples         ()

            );
        end
    endgenerate

    logic [0:0] mgtrefclk_p[11];
    logic [0:0] mgtrefclk_n[11];
    logic [0:0] gtyrxp_in[44];
    logic [0:0] gtyrxn_in[44];
    logic [0:0] gtytxp_out[44];
    logic [0:0] gtytxn_out[44];  

    always_comb begin
        mgtrefclk_p[0]  = quad220_clk_p;
        mgtrefclk_p[1]  = quad221_clk_p;
        mgtrefclk_p[2]  = quad222_clk_p;
        mgtrefclk_p[3]  = quad225_clk_p;
        mgtrefclk_p[4]  = quad226_clk_p;
        mgtrefclk_p[5]  = quad227_clk_p;
        mgtrefclk_p[6]  = quad230_clk_p;
        mgtrefclk_p[7]  = quad231_clk_p;
        mgtrefclk_p[8]  = quad235_clk_p;
        mgtrefclk_p[9]  = quad236_clk_p;
        mgtrefclk_p[10] = quad237_clk_p;
    end

    always_comb begin
        mgtrefclk_n[0]  = quad220_clk_n;
        mgtrefclk_n[1]  = quad221_clk_n;
        mgtrefclk_n[2]  = quad222_clk_n;
        mgtrefclk_n[3]  = quad225_clk_n;
        mgtrefclk_n[4]  = quad226_clk_n;
        mgtrefclk_n[5]  = quad227_clk_n;
        mgtrefclk_n[6]  = quad230_clk_n;
        mgtrefclk_n[7]  = quad231_clk_n;
        mgtrefclk_n[8]  = quad235_clk_n;
        mgtrefclk_n[9]  = quad236_clk_n;
        mgtrefclk_n[10] = quad237_clk_n;
    end

    always_comb begin
        gtyrxp_in[0]  = quad220_ch0_gtyrxp_in;
        gtyrxp_in[1]  = quad220_ch1_gtyrxp_in;
        gtyrxp_in[2]  = quad220_ch2_gtyrxp_in;
        gtyrxp_in[3]  = quad220_ch3_gtyrxp_in;
        gtyrxp_in[4]  = quad221_ch0_gtyrxp_in;
        gtyrxp_in[5]  = quad221_ch1_gtyrxp_in;
        gtyrxp_in[6]  = quad221_ch2_gtyrxp_in;
        gtyrxp_in[7]  = quad221_ch3_gtyrxp_in;
        gtyrxp_in[8]  = quad222_ch0_gtyrxp_in;
        gtyrxp_in[9]  = quad222_ch1_gtyrxp_in;
        gtyrxp_in[10] = quad222_ch2_gtyrxp_in;
        gtyrxp_in[11] = quad222_ch3_gtyrxp_in;
        gtyrxp_in[12] = quad225_ch0_gtyrxp_in;
        gtyrxp_in[13] = quad225_ch1_gtyrxp_in;
        gtyrxp_in[14] = quad225_ch2_gtyrxp_in;
        gtyrxp_in[15] = quad225_ch3_gtyrxp_in;
        gtyrxp_in[16] = quad226_ch0_gtyrxp_in;
        gtyrxp_in[17] = quad226_ch1_gtyrxp_in;
        gtyrxp_in[18] = quad226_ch2_gtyrxp_in;
        gtyrxp_in[19] = quad226_ch3_gtyrxp_in;
        gtyrxp_in[20] = quad227_ch0_gtyrxp_in;
        gtyrxp_in[21] = quad227_ch1_gtyrxp_in;
        gtyrxp_in[22] = quad227_ch2_gtyrxp_in;
        gtyrxp_in[23] = quad227_ch3_gtyrxp_in;
        gtyrxp_in[24] = quad230_ch0_gtyrxp_in;
        gtyrxp_in[25] = quad230_ch1_gtyrxp_in;
        gtyrxp_in[26] = quad230_ch2_gtyrxp_in;
        gtyrxp_in[27] = quad230_ch3_gtyrxp_in;
        gtyrxp_in[28] = quad231_ch0_gtyrxp_in;
        gtyrxp_in[29] = quad231_ch1_gtyrxp_in;
        gtyrxp_in[30] = quad231_ch2_gtyrxp_in;
        gtyrxp_in[31] = quad231_ch3_gtyrxp_in;
        gtyrxp_in[32] = quad235_ch0_gtyrxp_in;
        gtyrxp_in[33] = quad235_ch1_gtyrxp_in;
        gtyrxp_in[34] = quad235_ch2_gtyrxp_in;
        gtyrxp_in[35] = quad235_ch3_gtyrxp_in;
        gtyrxp_in[36] = quad236_ch0_gtyrxp_in;
        gtyrxp_in[37] = quad236_ch1_gtyrxp_in;
        gtyrxp_in[38] = quad236_ch2_gtyrxp_in;
        gtyrxp_in[39] = quad236_ch3_gtyrxp_in;
        gtyrxp_in[40] = quad237_ch0_gtyrxp_in;
        gtyrxp_in[41] = quad237_ch1_gtyrxp_in;
        gtyrxp_in[42] = quad237_ch2_gtyrxp_in;
        gtyrxp_in[43] = quad237_ch3_gtyrxp_in;
    end

    always_comb begin
        gtyrxn_in[0]  = quad220_ch0_gtyrxn_in;
        gtyrxn_in[1]  = quad220_ch1_gtyrxn_in;
        gtyrxn_in[2]  = quad220_ch2_gtyrxn_in;
        gtyrxn_in[3]  = quad220_ch3_gtyrxn_in;
        gtyrxn_in[4]  = quad221_ch0_gtyrxn_in;
        gtyrxn_in[5]  = quad221_ch1_gtyrxn_in;
        gtyrxn_in[6]  = quad221_ch2_gtyrxn_in;
        gtyrxn_in[7]  = quad221_ch3_gtyrxn_in;
        gtyrxn_in[8]  = quad222_ch0_gtyrxn_in;
        gtyrxn_in[9]  = quad222_ch1_gtyrxn_in;
        gtyrxn_in[10] = quad222_ch2_gtyrxn_in;
        gtyrxn_in[11] = quad222_ch3_gtyrxn_in;
        gtyrxn_in[12] = quad225_ch0_gtyrxn_in;
        gtyrxn_in[13] = quad225_ch1_gtyrxn_in;
        gtyrxn_in[14] = quad225_ch2_gtyrxn_in;
        gtyrxn_in[15] = quad225_ch3_gtyrxn_in;
        gtyrxn_in[16] = quad226_ch0_gtyrxn_in;
        gtyrxn_in[17] = quad226_ch1_gtyrxn_in;
        gtyrxn_in[18] = quad226_ch2_gtyrxn_in;
        gtyrxn_in[19] = quad226_ch3_gtyrxn_in;
        gtyrxn_in[20] = quad227_ch0_gtyrxn_in;
        gtyrxn_in[21] = quad227_ch1_gtyrxn_in;
        gtyrxn_in[22] = quad227_ch2_gtyrxn_in;
        gtyrxn_in[23] = quad227_ch3_gtyrxn_in;
        gtyrxn_in[24] = quad230_ch0_gtyrxn_in;
        gtyrxn_in[25] = quad230_ch1_gtyrxn_in;
        gtyrxn_in[26] = quad230_ch2_gtyrxn_in;
        gtyrxn_in[27] = quad230_ch3_gtyrxn_in;
        gtyrxn_in[28] = quad231_ch0_gtyrxn_in;
        gtyrxn_in[29] = quad231_ch1_gtyrxn_in;
        gtyrxn_in[30] = quad231_ch2_gtyrxn_in;
        gtyrxn_in[31] = quad231_ch3_gtyrxn_in;
        gtyrxn_in[32] = quad235_ch0_gtyrxn_in;
        gtyrxn_in[33] = quad235_ch1_gtyrxn_in;
        gtyrxn_in[34] = quad235_ch2_gtyrxn_in;
        gtyrxn_in[35] = quad235_ch3_gtyrxn_in;
        gtyrxn_in[36] = quad236_ch0_gtyrxn_in;
        gtyrxn_in[37] = quad236_ch1_gtyrxn_in;
        gtyrxn_in[38] = quad236_ch2_gtyrxn_in;
        gtyrxn_in[39] = quad236_ch3_gtyrxn_in;
        gtyrxn_in[40] = quad237_ch0_gtyrxn_in;
        gtyrxn_in[41] = quad237_ch1_gtyrxn_in;
        gtyrxn_in[42] = quad237_ch2_gtyrxn_in;
        gtyrxn_in[43] = quad237_ch3_gtyrxn_in;
    end

    always_comb begin
         quad220_ch0_gtytxp_out = gtytxp_out[0]  ;
         quad220_ch1_gtytxp_out = gtytxp_out[1]  ;
         quad220_ch2_gtytxp_out = gtytxp_out[2]  ;
         quad220_ch3_gtytxp_out = gtytxp_out[3]  ;
         quad221_ch0_gtytxp_out = gtytxp_out[4]  ;
         quad221_ch1_gtytxp_out = gtytxp_out[5]  ;
         quad221_ch2_gtytxp_out = gtytxp_out[6]  ;
         quad221_ch3_gtytxp_out = gtytxp_out[7]  ;
         quad222_ch0_gtytxp_out = gtytxp_out[8]  ;
         quad222_ch1_gtytxp_out = gtytxp_out[9]  ;
         quad222_ch2_gtytxp_out = gtytxp_out[10] ;
         quad222_ch3_gtytxp_out = gtytxp_out[11] ;
         quad225_ch0_gtytxp_out = gtytxp_out[12] ;
         quad225_ch1_gtytxp_out = gtytxp_out[13] ;
         quad225_ch2_gtytxp_out = gtytxp_out[14] ;
         quad225_ch3_gtytxp_out = gtytxp_out[15] ;
         quad226_ch0_gtytxp_out = gtytxp_out[16] ;
         quad226_ch1_gtytxp_out = gtytxp_out[17] ;
         quad226_ch2_gtytxp_out = gtytxp_out[18] ;
         quad226_ch3_gtytxp_out = gtytxp_out[19] ;
         quad227_ch0_gtytxp_out = gtytxp_out[20] ;
         quad227_ch1_gtytxp_out = gtytxp_out[21] ;
         quad227_ch2_gtytxp_out = gtytxp_out[22] ;
         quad227_ch3_gtytxp_out = gtytxp_out[23] ;
         quad230_ch0_gtytxp_out = gtytxp_out[24] ;
         quad230_ch1_gtytxp_out = gtytxp_out[25] ;
         quad230_ch2_gtytxp_out = gtytxp_out[26] ;
         quad230_ch3_gtytxp_out = gtytxp_out[27] ;
         quad231_ch0_gtytxp_out = gtytxp_out[28] ;
         quad231_ch1_gtytxp_out = gtytxp_out[29] ;
         quad231_ch2_gtytxp_out = gtytxp_out[30] ;
         quad231_ch3_gtytxp_out = gtytxp_out[31] ;
         quad235_ch0_gtytxp_out = gtytxp_out[32] ;
         quad235_ch1_gtytxp_out = gtytxp_out[33] ;
         quad235_ch2_gtytxp_out = gtytxp_out[34] ;
         quad235_ch3_gtytxp_out = gtytxp_out[35] ;
         quad236_ch0_gtytxp_out = gtytxp_out[36] ;
         quad236_ch1_gtytxp_out = gtytxp_out[37] ;
         quad236_ch2_gtytxp_out = gtytxp_out[38] ;
         quad236_ch3_gtytxp_out = gtytxp_out[39] ;
         quad237_ch0_gtytxp_out = gtytxp_out[40] ;
         quad237_ch1_gtytxp_out = gtytxp_out[41] ;
         quad237_ch2_gtytxp_out = gtytxp_out[42] ;
         quad237_ch3_gtytxp_out = gtytxp_out[43] ;
    end

    always_comb begin
        quad220_ch0_gtytxn_out = gtytxn_out[0] ;
        quad220_ch1_gtytxn_out = gtytxn_out[1] ;
        quad220_ch2_gtytxn_out = gtytxn_out[2] ;
        quad220_ch3_gtytxn_out = gtytxn_out[3] ;
        quad221_ch0_gtytxn_out = gtytxn_out[4] ;
        quad221_ch1_gtytxn_out = gtytxn_out[5] ;
        quad221_ch2_gtytxn_out = gtytxn_out[6] ;
        quad221_ch3_gtytxn_out = gtytxn_out[7] ;
        quad222_ch0_gtytxn_out = gtytxn_out[8] ;
        quad222_ch1_gtytxn_out = gtytxn_out[9] ;
        quad222_ch2_gtytxn_out = gtytxn_out[10];
        quad222_ch3_gtytxn_out = gtytxn_out[11];
        quad225_ch0_gtytxn_out = gtytxn_out[12];
        quad225_ch1_gtytxn_out = gtytxn_out[13];
        quad225_ch2_gtytxn_out = gtytxn_out[14];
        quad225_ch3_gtytxn_out = gtytxn_out[15];
        quad226_ch0_gtytxn_out = gtytxn_out[16];
        quad226_ch1_gtytxn_out = gtytxn_out[17];
        quad226_ch2_gtytxn_out = gtytxn_out[18];
        quad226_ch3_gtytxn_out = gtytxn_out[19];
        quad227_ch0_gtytxn_out = gtytxn_out[20];
        quad227_ch1_gtytxn_out = gtytxn_out[21];
        quad227_ch2_gtytxn_out = gtytxn_out[22];
        quad227_ch3_gtytxn_out = gtytxn_out[23];
        quad230_ch0_gtytxn_out = gtytxn_out[24];
        quad230_ch1_gtytxn_out = gtytxn_out[25];
        quad230_ch2_gtytxn_out = gtytxn_out[26];
        quad230_ch3_gtytxn_out = gtytxn_out[27];
        quad231_ch0_gtytxn_out = gtytxn_out[28];
        quad231_ch1_gtytxn_out = gtytxn_out[29];
        quad231_ch2_gtytxn_out = gtytxn_out[30];
        quad231_ch3_gtytxn_out = gtytxn_out[31];
        quad235_ch0_gtytxn_out = gtytxn_out[32];
        quad235_ch1_gtytxn_out = gtytxn_out[33];
        quad235_ch2_gtytxn_out = gtytxn_out[34];
        quad235_ch3_gtytxn_out = gtytxn_out[35];
        quad236_ch0_gtytxn_out = gtytxn_out[36];
        quad236_ch1_gtytxn_out = gtytxn_out[37];
        quad236_ch2_gtytxn_out = gtytxn_out[38];
        quad236_ch3_gtytxn_out = gtytxn_out[39];
        quad237_ch0_gtytxn_out = gtytxn_out[40];
        quad237_ch1_gtytxn_out = gtytxn_out[41];
        quad237_ch2_gtytxn_out = gtytxn_out[42];
        quad237_ch3_gtytxn_out = gtytxn_out[43];
    end   

    genvar k;
    generate;
        for(k = 0; k < QUAD; k = k + 1) begin : ibert 
            gtwizard_ultrascale_0_example_top     gtwizard_ultrascale_0_example_top_inst(
                .mgtrefclk0_x0y1_p                    (mgtrefclk_p[k]),
                .mgtrefclk0_x0y1_n                    (mgtrefclk_n[k]),
                .ch0_gtyrxn_in                        (gtyrxn_in[4*k]),
                .ch0_gtyrxp_in                        (gtyrxp_in[4*k]),
                .ch0_gtytxn_out                       (gtytxn_out[4*k]),
                .ch0_gtytxp_out                       (gtytxp_out[4*k]),
                .ch1_gtyrxn_in                        (gtyrxn_in[4*k+1]),
                .ch1_gtyrxp_in                        (gtyrxp_in[4*k+1]),
                .ch1_gtytxn_out                       (gtytxn_out[4*k+1]),
                .ch1_gtytxp_out                       (gtytxp_out[4*k+1]),
                .ch2_gtyrxn_in                        (gtyrxn_in[4*k+2]),
                .ch2_gtyrxp_in                        (gtyrxp_in[4*k+2]),
                .ch2_gtytxn_out                       (gtytxn_out[4*k+2]),
                .ch2_gtytxp_out                       (gtytxp_out[4*k+2]),
                .ch3_gtyrxn_in                        (gtyrxn_in[4*k+3]),
                .ch3_gtyrxp_in                        (gtyrxp_in[4*k+3]),
                .ch3_gtytxn_out                       (gtytxn_out[4*k+3]),
                .ch3_gtytxp_out                       (gtytxp_out[4*k+3]),
                .hb_gtwiz_reset_clk_freerun_buf_int   (hb_gtwiz_reset_clk_freerun_buf_int),
                .hb_gtwiz_reset_all_in                (resetn[4*k+:4]),
                .txdiffctrl_int                       (txdiffctrl[k*20+:20]),
                .txmaincursor_int                     (txmaincursor[28*k+:28]),
                .txpostcursor_int                     (txpostcursor[20*k+:20]),
                .txprecursor_int                      (txprecursor[20*k+:20]),
                .txprbssel_int                        (txprbssel[16*k+:16]),
                .rxprbssel_int                        (rxprbssel[16*k+:16]),
                .qpll0lock_out                        (qpll0lock_int[k]),
                .drpaddr_int                          (drpaddr_int[40*k+:40]),
                .drpwe_int                            (drpwe_int[4*k+:4]),
                .eyescanreset_int                     (eyescanreset_int[4*k+:4]),
                .drpen_int                            (drpen_int[4*k+:4]),
                .drpdi_int                            (drpdi_int[64*k+:64]),
                .drpdo_int                            (drpdo_int[64*k+:64]),
                .drprdy_int                           (drprdy_int[4*k+:4]),
                .link_status_out                      (link_status_int[4*k+:4])
            );           
        end 
    endgenerate  


endmodule
