module clk_rst_gen #(
     parameter  int         AuroraPMAInitTime = 150_0000    // us, 1.5s
    ,parameter  int         AuroraResetPBTime = 200_0000    // us, 2.0s
    ,parameter  int         PeriResetTime     = 100_0000    // us, 1.0s
    ,parameter  int         RefClkFrequency   = 20          // MHz
)(  
     input      logic       sgbus_clkp
    ,input      logic       sgbus_clkn
    ,input      logic       ex_rst_n

    ,output     logic       aurora_pma_init
    ,output     logic       aurora_reset_pb
    ,output     logic       aurora_init_clk

    ,input      logic       aurora_gt_pll_lock
    ,input      logic       aurora_channel_up
    ,input      logic       aurora_lane_up

    ,output     logic       peri_reset

);

    localparam  RefClkPeriod        = 50;   // ns

    logic           sgbus_clk               ;
    logic           mmcm_clkin              ;
    logic           mmcm_fb_clk             ;
    logic           mmcm_locked             ;
    logic   [6:0]   mmcm_clkout             ;
    logic   [6:0]   mmcm_clkout_gc          ;

    logic           aurora_stable           ;


    IBUFDS IBUFDS_sgbus_clk (
         .I (sgbus_clkp )
        ,.IB(sgbus_clkn )
        ,.O (sgbus_clk  )
    );

    `ifndef SGBUS_CLK_DEDICATED

    logic sgbus_clk_gc;

    BUFGCE BUFGCE_sgbus_clk (
         .I (sgbus_clk      )
        ,.O (sgbus_clk_gc   )
        ,.CE(1              )
    );

    assign mmcm_clkin = sgbus_clk_gc;
    `else
    assign mmcm_clkin = sgbus_clk;
    `endif

    generate
        for(genvar var_i = 0 ; var_i < 7 ; var_i = var_i + 1) begin : mmcm_clkout_global_route
            BUFGCE BUFGCE_mmcm_clkout (
                 .I (mmcm_clkout[var_i]     )
                ,.O (mmcm_clkout_gc[var_i]  )
                ,.CE(1                      )
            );
        end
    endgenerate

    assign aurora_init_clk = mmcm_clkout_gc[0];
    assign aurora_stable   = aurora_gt_pll_lock && aurora_channel_up && aurora_lane_up;
    
    // `ifdef ULTRASCALE_PLUS
        
    MMCME4_ADV #(
         .BANDWIDTH                 ("OPTIMIZED"    )
        ,.CLKFBOUT_MULT_F           (60.0           )   // Set VCO at 1200MHz
        ,.CLKFBOUT_PHASE            (0.0            )
        ,.CLKFBOUT_USE_FINE_PS      ("FALSE"        )
        ,.CLKIN1_PERIOD             (50.0           )   // sgbus_clk @ 20MHz
        ,.CLKIN2_PERIOD             (               )
        ,.CLKOUT0_DIVIDE_F          (24.0           )   // clkout0 @ 50MHz
        ,.CLKOUT0_DUTY_CYCLE        (0.5            )
        ,.CLKOUT0_PHASE             (0.0            )
        ,.CLKOUT0_USE_FINE_PS       ("FALSE"        )
        ,.CLKOUT1_DIVIDE            (6              )
        ,.CLKOUT1_DUTY_CYCLE        (0.5            )
        ,.CLKOUT1_PHASE             (0.0            )
        ,.CLKOUT1_USE_FINE_PS       ("FALSE"        )
        ,.CLKOUT2_DIVIDE            (60             )
        ,.CLKOUT2_DUTY_CYCLE        (0.5            )
        ,.CLKOUT2_PHASE             (0.0            )
        ,.CLKOUT2_USE_FINE_PS       ("FALSE"        )
        ,.CLKOUT3_DIVIDE            (24             )
        ,.CLKOUT3_DUTY_CYCLE        (0.5            )
        ,.CLKOUT3_PHASE             (0.0            )
        ,.CLKOUT3_USE_FINE_PS       ("FALSE"        )
        ,.CLKOUT4_CASCADE           ("FALSE"        )
        ,.CLKOUT4_DIVIDE            (24             )
        ,.CLKOUT4_DUTY_CYCLE        (0.5            )
        ,.CLKOUT4_PHASE             (0.0            )
        ,.CLKOUT4_USE_FINE_PS       ("FALSE"        )
        ,.CLKOUT5_DIVIDE            (3              )
        ,.CLKOUT5_DUTY_CYCLE        (0.5            )
        ,.CLKOUT5_PHASE             (0.0            )
        ,.CLKOUT5_USE_FINE_PS       ("FALSE"        )
        ,.CLKOUT6_DIVIDE            (1              )
        ,.CLKOUT6_DUTY_CYCLE        (0.5            )
        ,.CLKOUT6_PHASE             (0.0            )
        ,.CLKOUT6_USE_FINE_PS       ("FALSE"        )
        ,.COMPENSATION              ("AUTO"         ) // Compensation will be set to "internal" automatically.
        ,.DIVCLK_DIVIDE             (1              )
        ,.IS_CLKFBIN_INVERTED       (1'b0           )
        ,.IS_CLKIN1_INVERTED        (1'b0           )
        ,.IS_CLKIN2_INVERTED        (1'b0           )
        ,.IS_CLKINSEL_INVERTED      (1'b0           )
        ,.IS_PSEN_INVERTED          (1'b0           )
        ,.IS_PSINCDEC_INVERTED      (1'b0           )
        ,.IS_PWRDWN_INVERTED        (1'b0           )
        ,.IS_RST_INVERTED           (1'b0           )
        ,.REF_JITTER1               (0.01           )
        ,.REF_JITTER2               (0.01           )
        ,.SS_EN                     ("FALSE"        )
        ,.SS_MODE                   ("CENTER_HIGH"  )
        ,.SS_MOD_PERIOD             (10000          )
        ,.STARTUP_WAIT              ("FALSE"        ) 
    ) glue_logic_mmcm (
         .CDDCDONE                  (               ) 
        ,.CLKFBOUT                  (mmcm_fb_clk    ) 
        ,.CLKFBOUTB                 (               ) 
        ,.CLKFBSTOPPED              (               ) 
        ,.CLKINSTOPPED              (               ) 
        ,.CLKOUT0                   (mmcm_clkout[0] )
        ,.CLKOUT0B                  (               ) 
        ,.CLKOUT1                   (mmcm_clkout[1] ) 
        ,.CLKOUT1B                  (               ) 
        ,.CLKOUT2                   (mmcm_clkout[2] ) 
        ,.CLKOUT2B                  (               ) 
        ,.CLKOUT3                   (mmcm_clkout[3] ) 
        ,.CLKOUT3B                  (               ) 
        ,.CLKOUT4                   (mmcm_clkout[4] ) 
        ,.CLKOUT5                   (mmcm_clkout[5] ) 
        ,.CLKOUT6                   (mmcm_clkout[6] ) 
        ,.DO                        (               ) 
        ,.DRDY                      (               ) 
        ,.LOCKED                    (mmcm_locked    ) 
        ,.PSDONE                    (               ) 
        ,.CDDCREQ                   (1'b0           ) 
        ,.CLKFBIN                   (mmcm_fb_clk    )
        ,.CLKIN1                    (mmcm_clkin     ) 
        ,.CLKIN2                    (1'b0           ) 
        ,.CLKINSEL                  (1'b1           )   // Select clkin1.
        ,.DADDR                     ('0             ) 
        ,.DCLK                      (1'b0           ) 
        ,.DEN                       (1'b0           ) 
        ,.DI                        (1'b0           ) 
        ,.DWE                       (1'b0           ) 
        ,.PSCLK                     (1'b0           ) 
        ,.PSEN                      (1'b0           ) 
        ,.PSINCDEC                  (1'b0           ) 
        ,.PWRDWN                    (1'b0           )   // Tie all the irrelevant pins to ground.
        ,.RST                       (!ex_rst_n      )   // TODO : Reset should be tied to ground in future release.
    );

    pulse_generator #(
         .ClockPeriod    (20                    )   // ns
        ,.PulseCnt       (0                     )   // Count
        ,.PulseWidth     (AuroraPMAInitTime*1000)   // ns
        ,.SPolarity      (1                     )   // Polarity at the start of the pulse
        ,.EPolarity      (0                     )   // Polarity at the end of the pulse
    )aurora_pma_init_pulse(
         .clk            (aurora_init_clk       )
        ,.reset          (!mmcm_locked          )
        ,.pulse_en       (1                     )
        ,.pulse_o        (aurora_pma_init       )
    );

    pulse_generator #(
         .ClockPeriod    (20                    )   // ns
        ,.PulseCnt       (0                     )   // Count
        ,.PulseWidth     (AuroraResetPBTime*1000)   // ns
        ,.SPolarity      (1                     )   // Polarity at the start of the pulse
        ,.EPolarity      (0                     )   // Polarity at the end of the pulse
    )aurora_reset_pb_pulse(
         .clk            (aurora_init_clk       )
        ,.reset          (!mmcm_locked          )
        ,.pulse_en       (1                     )
        ,.pulse_o        (aurora_reset_pb       )
    );

    pulse_generator #(
         .ClockPeriod    (20                    )   // ns
        ,.PulseCnt       (0                     )   // Count
        ,.PulseWidth     (PeriResetTime*1000    )   // ns
        ,.SPolarity      (1                     )   // Polarity at the start of the pulse
        ,.EPolarity      (0                     )   // Polarity at the end of the pulse
    )peri_reset_pulse(
         .clk            (aurora_init_clk       )
        ,.reset          (!mmcm_locked          )
        ,.pulse_en       (aurora_stable         )
        ,.pulse_o        (peri_reset            )
    );


endmodule