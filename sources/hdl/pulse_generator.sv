`include "sgbus_defines.svh"
/*  
           ___     ___
    ______|   |___|   |_______      This counts as 2 pulses.
    ______     ___     ___
          |___|   |___|   |____     This counts as 2 pulses.
           ___     ___     ____
    ______|   |___|   |___|         This counts as 2 pulses.
    ______     ___     ________
          |___|   |___|             This counts as 2 pulses.

    PulseWidth is the single horizontal line in the figure above.
*/
module pulse_generator #(
     parameter  int         ClockPeriod     = 50    // ns
    ,parameter  int         PulseCnt        = 2     // Count
    ,parameter  int         PulseWidth      = 100   // ns
    ,parameter  bit         SPolarity       = 0     // Polarity at the start of the pulse
    ,parameter  bit         EPolarity       = 1     // Polarity at the end of the pulse
)(
     input      logic       clk
    ,input      logic       reset
    ,input      logic       pulse_en
    ,output     logic       pulse_o
);


    localparam FlipCnt = PulseCnt * 2 + SPolarity ^ EPolarity;
    localparam FlipDivCnt = PulseWidth / ClockPeriod; // clock cycle count for half of a pulse(flip).

    logic   [$clog2(FlipDivCnt) : 0]        cycle_cnt       ;
    logic   [$clog2(FlipCnt) : 0]           flip_cnt        ;
    logic                                   pulse_en_prev   ;
    
    `PROC_LOCK_FF(pulse_gen, clk, reset)

    // Rising edge detect.
    always_ff@(posedge clk) begin
        if(reset) begin
            pulse_en_prev <= 0;
        end
        else begin
            pulse_en_prev <= pulse_en;  // Edge detector.
        end
    end

    always_comb begin
        `PROC_INIT(pulse_gen)

        if(~pulse_en_prev && pulse_en) begin
            `PROC_LOCK(pulse_gen)
        end

        if(flip_cnt == FlipCnt) begin
            `PROC_UNLOCK(pulse_gen)
        end
    end

    always_ff@(posedge clk) begin
        if(!pulse_en || reset) begin
            cycle_cnt <= 0;
            flip_cnt <= 0;
            pulse_o <= SPolarity;
        end
        else begin
            if(pulse_gen_lock) begin
                if(cycle_cnt != FlipDivCnt) 
                    cycle_cnt <= cycle_cnt + 1;
                else begin
                    cycle_cnt <= 0;
                    flip_cnt <= flip_cnt + 1;
                    pulse_o <= !pulse_o;
                end
            end
            else begin
                cycle_cnt <= 0;
                flip_cnt <= 0;
                pulse_o <= pulse_o;
            end
        end
    end

endmodule