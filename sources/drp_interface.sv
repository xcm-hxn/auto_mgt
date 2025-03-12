`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/21 15:18:06
// Design Name: 
// Module Name: drp_interface
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 'd0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


 module drp_interface (
    (* keep = "true" *)  input  logic        drp_clk,
    (* keep = "true" *)  input  logic        drp_rst,
    (* keep = "true" *)  input  logic [15:0] drp_do_i,
    (* keep = "true" *)  input  logic        drp_rdy_i,
    (* keep = "true" *)  output logic [ 9:0] drp_addr_o,
    (* keep = "true" *)  output logic        drp_we_o,
    (* keep = "true" *)  output logic        eyescanreset_o,
    (* keep = "true" *)  output logic        drp_en_o,
    (* keep = "true" *)  output logic [15:0] drp_di_o,
    (* keep = "true" *)  input  logic        trigger_go,
    (* keep = "true" *)  output logic [15:0] errors,
    (* keep = "true" *)  output logic [15:0] samples
);  

    typedef struct packed {
        logic [15:0]  errors;
        logic [ 8:0]  hsteps;
        logic [ 8:0]  vsteps;
        logic [11:0]  hstepSize;
        logic [ 5:0]  cycles;
        logic [11:0]  vstepSize;
        logic [ 5:0]  cnt;
        logic [11:0]  horz;
        logic [ 9:0]  vert;
        logic [15:0]  samples;
        logic [ 9:0]  drp_addr;
        logic         drp_we;
        logic         drp_en;
        logic [15:0]  drp_di;
        logic         drp_done;
        logic [ 2:0]  error_cnt;
    } drp_reg;

    (* keep = "true" *) drp_reg drp_reg_t;

    typedef enum bit [6:0] {
        waitGoCmd,
        waitStart,
        waitComplete,
        getErrors,
        storeErrors,
        getSamples,
        storeSamples,
        rstCmd,
        waitRstCmd,
        eyeIdle,
        waitIdle,
        updateHorzOffset,
        waitHorzOffset,
        waitVertical,
        run,
        waitRun,
        sdataMask0,
        waitSdataMask0,
        sdataMask1,
        waitSdataMask1,
        sdataMask2,
        waitSdataMask2,
        sdataMask3,
        waitSdataMask3,
        sdataMask4,
        waitSdataMask4,
        sdataMask5,
        waitSdataMask5,
        sdataMask6,
        waitSdataMask6,
        sdataMask7,
        waitSdataMask7,
        sdataMask8,
        waitSdataMask8,
        sdataMask9,
        waitSdataMask9,
        qualMask0,
        waitQualMask0,
        qualMask1,
        waitQualMask1,
        qualMask2,
        waitQualMask2,
        qualMask3,
        waitQualMask3,
        qualMask4,
        waitQualMask4,
        qualMask5,
        waitQualMask5,
        qualMask6,
        waitQualMask6,
        qualMask7,
        waitQualMask7,
        qualMask8,
        waitQualMask8,
        qualMask9,
        waitQualMask9,
        rxEyescanVs,
        waitRxEyescanVs,
        checkErrors,
        esHorzOffset0,
        waitEsHorzOffset0,
        esHorzOffset1,
        waitEsHorzOffset1,
        testStart,
        waitTestStart,
        testComplete,
        storeData
    } DRP_FSM_STATE;
    
    (* keep = "true" *) DRP_FSM_STATE drp_fsm_curr;
    
    always_ff @ (posedge drp_clk) begin
        if(drp_rst)
	        drp_fsm_curr <= waitGoCmd;
    else begin
        case(drp_fsm_curr)
            waitGoCmd: begin
                drp_reg_t.drp_we   <= 'd0;
                drp_reg_t.drp_en   <= 'd0;
                drp_reg_t.drp_addr <= 'd0;
                drp_reg_t.drp_di   <= 'd0;
                drp_reg_t.hsteps   <= 'd0;
                drp_reg_t.vsteps   <= 'd0;
                drp_reg_t.horz     <= 12'b100000111111;
                drp_reg_t.vert     <= 9'b001111111;
                if(trigger_go)
                    drp_fsm_curr   <= sdataMask0;
                else 
                    drp_fsm_curr   <= waitGoCmd;
            end
            sdataMask0: begin
                drp_fsm_curr       <= waitSdataMask0;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'h49;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitSdataMask0: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= sdataMask1;
                else
                    drp_fsm_curr <= waitSdataMask0;  
            end
            sdataMask1: begin
                drp_fsm_curr       <= waitSdataMask1;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'h4A;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitSdataMask1: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= sdataMask2;
                else
                    drp_fsm_curr <= waitSdataMask1;  
            end
            sdataMask2: begin
                drp_fsm_curr       <= waitSdataMask2;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'h4B;  
                drp_reg_t.drp_di   <= 16'h00ff;
            end
            waitSdataMask2: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= sdataMask3;
                else
                    drp_fsm_curr <= waitSdataMask2;  
            end
            sdataMask3: begin
                drp_fsm_curr       <= waitSdataMask3;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'h4C;  
                drp_reg_t.drp_di   <= 16'h0000;
            end
            waitSdataMask3: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= sdataMask4;
                else
                    drp_fsm_curr <= waitSdataMask3;  
            end
            sdataMask4: begin
                drp_fsm_curr       <= waitSdataMask4;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'h4D;  
                drp_reg_t.drp_di   <= 16'h0000;
            end
            waitSdataMask4: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= sdataMask5;
                else
                    drp_fsm_curr <= waitSdataMask4;  
            end
            sdataMask5: begin
                drp_fsm_curr       <= waitSdataMask5;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'hF1;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitSdataMask5: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= sdataMask6;
                else
                    drp_fsm_curr <= waitSdataMask5;  
            end
            sdataMask6: begin
                drp_fsm_curr       <= waitSdataMask6;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'hF2;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitSdataMask6: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= sdataMask7;
                else
                    drp_fsm_curr <= waitSdataMask6;  
            end
            sdataMask7: begin
                drp_fsm_curr       <= waitSdataMask7;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'hF3;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitSdataMask7: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= sdataMask8;
                else
                    drp_fsm_curr <= waitSdataMask7;  
            end
            sdataMask8: begin
                drp_fsm_curr       <= waitSdataMask8;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'hF4;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitSdataMask8: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= sdataMask9;
                else
                    drp_fsm_curr <= waitSdataMask8;  
            end
            sdataMask9: begin
                drp_fsm_curr       <= waitSdataMask9;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'hF5;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitSdataMask9: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= qualMask0;
                else
                    drp_fsm_curr <= waitSdataMask9;  
            end
            qualMask0: begin
                drp_fsm_curr       <= waitQualMask0;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'h44;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitQualMask0: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= qualMask1;
                else
                    drp_fsm_curr <= waitQualMask0;  
            end
            qualMask1: begin
                drp_fsm_curr       <= waitQualMask1;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'h45;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitQualMask1: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= qualMask2;
                else
                    drp_fsm_curr <= waitQualMask1;  
            end
            qualMask2: begin
                drp_fsm_curr       <= waitQualMask2;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'h46;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitQualMask2: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= qualMask3;
                else
                    drp_fsm_curr <= waitQualMask2;  
            end
            qualMask3: begin
                drp_fsm_curr       <= waitQualMask3;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'h47;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitQualMask3: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= qualMask4;
                else
                    drp_fsm_curr <= waitQualMask3;  
            end
            qualMask4: begin
                drp_fsm_curr       <= waitQualMask4;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'h48;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitQualMask4: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= qualMask5;
                else
                    drp_fsm_curr <= waitQualMask4;  
            end
            qualMask5: begin
                drp_fsm_curr       <= waitQualMask5;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'hec;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitQualMask5: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= qualMask6;
                else
                    drp_fsm_curr <= waitQualMask5;  
            end
            qualMask6: begin
                drp_fsm_curr       <= waitQualMask6;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'hed;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitQualMask6: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= qualMask7;
                else
                    drp_fsm_curr <= waitQualMask6;  
            end
            qualMask7: begin
                drp_fsm_curr       <= waitQualMask7;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'hee;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitQualMask7: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= qualMask8;
                else
                    drp_fsm_curr <= waitQualMask7;  
            end
            qualMask8: begin
                drp_fsm_curr       <= waitQualMask8;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'hef;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitQualMask8: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= qualMask9;
                else
                    drp_fsm_curr <= waitQualMask8;  
            end
            qualMask9: begin
                drp_fsm_curr       <= waitQualMask9;
                drp_reg_t.drp_we   <= 'd1;
                drp_reg_t.drp_en   <= 'd0;        
                drp_reg_t.cnt      <= 'd0;
                drp_reg_t.drp_addr <= 10'hf0;  
                drp_reg_t.drp_di   <= 16'hffff;
            end
            waitQualMask9: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= eyeIdle;
                else
                    drp_fsm_curr <= waitQualMask9;  
            end
            eyeIdle: begin
                drp_reg_t.cnt         <= 'd0;
                drp_reg_t.drp_en      <= 'd0;
                drp_reg_t.drp_we      <= 'd1;
                drp_reg_t.drp_addr    <= 10'h03C;
                drp_reg_t.drp_di      <= 16'h0300;
                drp_fsm_curr          <= waitIdle;
            end
            waitIdle:begin
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.drp_we <= 'd0;
                if(drp_rdy_i || drp_reg_t.cnt[5]) begin
                    drp_fsm_curr <= updateHorzOffset;
                end
                else
                    drp_fsm_curr <= waitIdle;
            end
            updateHorzOffset: begin
                drp_reg_t.cnt        <= 'd0;
                drp_reg_t.drp_en     <= 'd0;
                drp_reg_t.drp_we     <= 'd1;
                drp_reg_t.drp_addr   <= 10'h4F;
                drp_reg_t.drp_di     <= 16'h100f;
                drp_fsm_curr         <= waitHorzOffset;
            end
            waitHorzOffset:begin
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5])
                    drp_fsm_curr <= run;
                else
                    drp_fsm_curr <= waitHorzOffset;
            end
            run: begin
                drp_reg_t.cnt             <= 'd0;
                drp_fsm_curr              <= waitRun;
                drp_reg_t.drp_we          <= 'd1;
                drp_reg_t.drp_en          <= 'd0;
                drp_reg_t.drp_addr        <= 10'h97;  
                drp_reg_t.drp_di          <= 16'h0000;  
            end
            waitRun:begin
                drp_reg_t.cnt      <= drp_reg_t.cnt + 1'b1;
                drp_reg_t.drp_we   <= 'd0;
                drp_reg_t.drp_en   <='d0;
                if(drp_rdy_i  || drp_reg_t.cnt[5])
                    drp_fsm_curr   <= rxEyescanVs;
                else
                    drp_fsm_curr   <= waitRun;
            end
            rxEyescanVs: begin
                drp_fsm_curr           <= waitRxEyescanVs;
                drp_reg_t.drp_we       <= 'd1;
                drp_reg_t.drp_en       <= 'd0;        
                drp_reg_t.cnt          <= 'd0;
                drp_reg_t.drp_addr     <= 10'h3C;  
                drp_reg_t.drp_di       <= 16'h0700;
            end
            waitRxEyescanVs: begin
                drp_reg_t.drp_en <='d0;
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt +1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) 
                    drp_fsm_curr <= testComplete;
                else 
                    drp_fsm_curr <=waitRxEyescanVs;
            end
            testComplete: begin
                drp_reg_t.drp_addr       <= 10'h253;
                drp_reg_t.drp_we         <= 1'b0;
                drp_reg_t.drp_en         <= 1'b1;
                drp_fsm_curr             <= waitComplete;
                drp_reg_t.cnt            <= 'd0;
            end
            waitComplete: begin
                drp_reg_t.drp_we   <= 1'b0;
                drp_reg_t.drp_en   <= 'd0;
                drp_reg_t.cnt      <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5])	
                    if(drp_do_i[3:1] == 2 && drp_do_i[0] == 1)   
                        drp_fsm_curr <= rstCmd;
                    else
                        drp_fsm_curr <= testComplete;
                else 
                    drp_fsm_curr <= waitComplete;	 
            end
            rstCmd: begin
                drp_reg_t.drp_addr       <= 10'h3C;
                drp_reg_t.drp_we         <= 1'b1;
                drp_reg_t.drp_en         <= 'd0;
                drp_reg_t.drp_di         <= 16'h0300;
                drp_fsm_curr             <= waitRstCmd;
                drp_reg_t.cnt            <= 'd0;
            end
            waitRstCmd: begin
                drp_reg_t.drp_we   <= 1'b0;
                drp_reg_t.drp_en   <= 'd0;
                drp_reg_t.cnt      <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5])	
                    drp_fsm_curr <= getSamples;
                else 
                    drp_fsm_curr <= waitRstCmd;	 
            end
            getSamples: begin
                drp_reg_t.drp_addr <= 10'h252;
                drp_reg_t.drp_en   <= 1;
                drp_reg_t.drp_we   <= 'd0;
                drp_fsm_curr       <= storeSamples;
                drp_reg_t.cnt      <= 'd0;
            end
            storeSamples: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) begin
                    drp_fsm_curr      <= getErrors;
                    samples           <= drp_do_i;
                end
                else 
                    drp_fsm_curr      <= storeSamples;
            end
            getErrors: begin
                drp_reg_t.drp_addr <= 10'h251;
                drp_reg_t.drp_en   <= 1'b1;
                drp_fsm_curr       <= storeErrors;
                drp_reg_t.cnt      <= 'd0;
            end
            storeErrors: begin
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) begin
                    drp_fsm_curr     <= checkErrors;
                    drp_reg_t.errors <= drp_do_i;
                end
                else 
                    drp_fsm_curr     <= storeErrors;
            end
            checkErrors: begin
                if(drp_reg_t.errors > 0) begin
                    drp_fsm_curr        <= esHorzOffset0;
                    drp_reg_t.error_cnt <= drp_reg_t.error_cnt + 1'b1;
                    if(drp_reg_t.error_cnt > 3'd3) begin
                        errors <= drp_reg_t.errors;
                    end
                    else
                        errors <= 0;
                end
                else begin
                    drp_fsm_curr        <= waitGoCmd;
                    errors              <= drp_reg_t.errors;
                    drp_reg_t.error_cnt <= 3'd0;
                end
            end
            esHorzOffset0: begin
                drp_reg_t.cnt        <= 'd0;
                drp_reg_t.drp_en     <= 'd0;
                drp_reg_t.drp_we     <= 'd1;
                drp_reg_t.drp_addr   <= 10'h4F;
                drp_reg_t.drp_di     <= 16'h880f;
                drp_fsm_curr         <= waitEsHorzOffset0;  
            end
            waitEsHorzOffset0: begin
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) begin
                    drp_fsm_curr   <= esHorzOffset1;
                    eyescanreset_o <= 1'b1;
                end
                else
                    drp_fsm_curr <= waitEsHorzOffset0;
            end
            esHorzOffset1: begin
                drp_reg_t.cnt        <= 'd0;
                drp_reg_t.drp_en     <= 'd0;
                drp_reg_t.drp_we     <= 'd1;
                drp_reg_t.drp_addr   <= 10'h4F;
                drp_reg_t.drp_di     <= 16'h800f;
                drp_fsm_curr         <= waitEsHorzOffset1;  
            end
            waitEsHorzOffset1: begin
                drp_reg_t.drp_we <= 'd0;
                drp_reg_t.drp_en <= 'd0;
                drp_reg_t.cnt    <= drp_reg_t.cnt + 1'b1;
                if(drp_rdy_i || drp_reg_t.cnt[5]) begin
                    drp_fsm_curr   <= rxEyescanVs;
                    eyescanreset_o <= 1'b0;
                end
                else
                    drp_fsm_curr <= waitEsHorzOffset1;
            end
            default:
                drp_fsm_curr <= waitGoCmd;  // Wait for start command
            endcase
        end
    end


    always_ff @(posedge drp_clk ) begin    
        if(drp_rst) begin
            drp_reg_t.drp_done <= 1'b1;
        end
        if(drp_reg_t.drp_done) begin
            drp_en_o   <= 1'b0;
            drp_addr_o <= 9'b0;
            drp_di_o   <= 16'b0;
            drp_we_o   <= 1'b0;
        end
        if(!drp_reg_t.drp_we && !drp_reg_t.drp_en) begin
            drp_reg_t.drp_done <= 1'b0;
            drp_en_o           <= 1'b0;
            drp_addr_o         <= 9'b0;
            drp_di_o           <= 16'b0;
            drp_we_o           <= 1'b0;
        end 
        if(drp_reg_t.drp_we && !drp_reg_t.drp_done) begin
            drp_we_o           <= 1'b1;
            drp_addr_o         <= drp_reg_t.drp_addr;
            drp_di_o           <= drp_reg_t.drp_di;
            drp_en_o           <= 1'b1;
            drp_reg_t.drp_done <= 1'b1;
        end
        if(drp_reg_t.drp_en && !drp_reg_t.drp_done) begin
            drp_en_o           <= 1'b1;
            drp_we_o           <= 1'b0;
            drp_addr_o         <= drp_reg_t.drp_addr;
            drp_di_o           <= drp_reg_t.drp_di;
            drp_reg_t.drp_done <= 1'b1; 
        end 
    end


endmodule
