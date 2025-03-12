module fifo_64b_async_prim #(

)(
     input      logic           wr_clk
    ,input      logic           push
    ,input      logic   [63:0]  din
    ,output     logic           full
    ,output     logic           prog_full

    ,input      logic           rd_clk
    ,input      logic           pop
    ,output     logic   [63:0]  dout
    ,output     logic           empty
    ,output     logic           prog_empty

    ,input      logic           reset   // TODO : drain all the transactions?
);
    
    logic                   RST                 ;
    logic                   WRCLK               ;
    logic                   WREN                ;
    logic   [63:0]          DIN                 ;
    logic   [7:0]           DINP                ;
    logic                   FULL                ;
    logic                   PROGFULL            ;

    logic                   RDCLK               ;
    logic                   RDEN                ;
    logic                   REGCE               ;
    logic   [63:0]          DOUT                ;
    logic   [7:0]           DOUTP               ;
    logic                   EMPTY               ;
    logic                   PROGEMPTY           ;

    assign RST        = reset       ;
    assign RSTREG     = reset       ;
    assign WRCLK      = wr_clk      ;
    assign WREN       = push        ;
    assign DIN        = din         ;
    assign DINP       = '0          ;
    assign full       = FULL        ;
    assign prog_full  = PROGFULL    ;

    assign RDCLK      = rd_clk      ;
    assign RDEN       = pop         ;
    assign dout       = DOUT        ;
    assign empty      = EMPTY       ;
    assign prog_empty = PROGEMPTY   ;
    assign REGCE      = pop         ;

    // Actual depth is 511 in unregistered mode.
    FIFO36E2 #(
         .CASCADE_ORDER             ("NONE"                 ) // FIRST, LAST, MIDDLE, NONE, PARALLEL
        ,.CLOCK_DOMAINS             ("INDEPENDENT"          ) // COMMON, INDEPENDENT
        ,.EN_ECC_PIPE               ("FALSE"                ) // ECC pipeline register, (FALSE, TRUE)
        ,.EN_ECC_READ               ("FALSE"                ) // Enable ECC decoder, (FALSE, TRUE)
        ,.EN_ECC_WRITE              ("FALSE"                ) // Enable ECC encoder, (FALSE, TRUE)
        ,.FIRST_WORD_FALL_THROUGH   ("TRUE"                 ) // FALSE, TRUE
        ,.INIT                      (72'h000000000000000000 ) // Initial values on output port
        ,.PROG_EMPTY_THRESH         (256                    ) // Programmable Empty Threshold
        ,.PROG_FULL_THRESH          (256                    ) // Programmable Full Threshold
        ,.IS_RDCLK_INVERTED         (1'b0                   ) // Optional inversion for RDCLK
        ,.IS_RDEN_INVERTED          (1'b0                   ) // Optional inversion for RDEN
        ,.IS_RSTREG_INVERTED        (1'b0                   ) // Optional inversion for RSTREG
        ,.IS_RST_INVERTED           (1'b0                   ) // Optional inversion for RST
        ,.IS_WRCLK_INVERTED         (1'b0                   ) // Optional inversion for WRCLK
        ,.IS_WREN_INVERTED          (1'b0                   ) // Optional inversion for WREN
        ,.RDCOUNT_TYPE              ("EXTENDED_DATACOUNT"   ) // EXTENDED_DATACOUNT, RAW_PNTR, SIMPLE_DATACOUNT, SYNC_PNTR
        ,.READ_WIDTH                (72                     )
        ,.REGISTER_MODE             ("REGISTERED"           ) // DO_PIPELINED, REGISTERED, UNREGISTERED
        ,.RSTREG_PRIORITY           ("REGCE"                ) // REGCE, RSTREG
        ,.SLEEP_ASYNC               ("FALSE"                ) // FALSE, TRUE
        ,.SRVAL                     (72'h000000000000000000 ) // SET/reset value of the FIFO outputs
        ,.WRCOUNT_TYPE              ("EXTENDED_DATACOUNT"   ) // EXTENDED_DATACOUNT, RAW_PNTR, SIMPLE_DATACOUNT, SYNC_PNTR
        ,.WRITE_WIDTH               (72                     )
    )FIFO36E2_inst (
        // Cascade Signals.
         .CASDIN                    (0                      ) // 64-bit input   : Data cascade input bus
        ,.CASDINP                   (0                      ) // 8-bit  input   : Parity data cascade input bus
        ,.CASDOMUX                  (0                      ) // 1-bit  input   : Cascade MUX select input
        ,.CASDOMUXEN                (1                      ) // 1-bit  input   : Enable for cascade MUX select
        ,.CASNXTRDEN                (0                      ) // 1-bit  input   : Cascade next read enable
        ,.CASOREGIMUX               (0                      ) // 1-bit  input   : Cascade output MUX select
        ,.CASOREGIMUXEN             (1                      ) // 1-bit  input   : Cascade output MUX select enable
        ,.CASPRVEMPTY               (0                      ) // 1-bit  input   : Cascade previous empty
        ,.CASDOUT                   (                       ) // 64-bit output  : Data cascade output bus
        ,.CASDOUTP                  (                       ) // 8-bit  output  : Parity data cascade output bus
        ,.CASNXTEMPTY               (                       ) // 1-bit  output  : Cascade next empty
        ,.CASPRVRDEN                (                       ) // 1-bit  output  : Cascade previous read enable
        // Write port.
        ,.RST                       (RST                    ) // 1-bit  input   : Reset
        ,.WRCLK                     (WRCLK                  ) // 1-bit  input   : Write clock
        ,.WREN                      (WREN                   ) // 1-bit  input   : Write enable
        ,.DIN                       (DIN                    ) // 64-bit input   : FIFO data input bus
        ,.DINP                      (DINP                   ) // 8-bit  input   : FIFO parity input bus
        // Read port.
        ,.RDCLK                     (RDCLK                  ) // 1-bit  input   : Read clock
        ,.RDEN                      (RDEN                   ) // 1-bit  input   : Read enable
        ,.REGCE                     (REGCE                  ) // 1-bit  input   : Output register clock enable
        ,.RSTREG                    (RSTREG                 ) // 1-bit  input   : Output register reset
        ,.DOUT                      (DOUT                   ) // 64-bit output  : FIFO data output bus
        ,.DOUTP                     (DOUTP                  ) // 8-bit  output  : FIFO parity output bus.
        // Status outputs: Flags and other FIFO status outputs
        ,.EMPTY                     (EMPTY                  ) // 1-bit  output  : Empty
        ,.FULL                      (FULL                   ) // 1-bit  output  : Full
        ,.PROGEMPTY                 (PROGEMPTY              ) // 1-bit  output  : Programmable empty
        ,.PROGFULL                  (PROGFULL               ) // 1-bit  output  : Programmable full
        ,.RDCOUNT                   (                       ) // 14-bit output  : Read count
        ,.RDERR                     (                       ) // 1-bit  output  : Read error
        ,.RDRSTBUSY                 (                       ) // 1-bit  output  : Reset busy(sync to RDCLK)
        ,.WRCOUNT                   (                       ) // 14-bit output  : Write count
        ,.WRERR                     (                       ) // 1-bit  output  : Write Error
        ,.WRRSTBUSY                 (                       ) // 1-bit  output  : Reset busy(sync to WRCLK)
        // ECC Signals outputs: Error Correction Circuitry ports
        ,.DBITERR                   (                       ) // 1-bit  output  : Double bit error status
        ,.ECCPARITY                 (                       ) // 8-bit  output  : Generated error correction parity
        ,.SBITERR                   (                       ) // 1-bit  output  : Single bit error status
        ,.INJECTDBITERR             (0                      ) // 1-bit  input   : Inject a double-bit error
        ,.INJECTSBITERR             (0                      ) // 1-bit  input   : Inject a single bit error
        ,.SLEEP                     (0                      ) // 1-bit  input   : Sleep Mode
    );

endmodule

module fifo_64b_async_intf #(
     parameter  int             ReadLatency = 2
)(
     input      logic           reset
    ,input      logic           wr_clk
    ,input      logic   [63:0]  din
    ,input      logic           valid_i
    ,output     logic           ready_o
    ,output     logic           hf_ready_o
    
    ,input      logic           rd_clk
    ,output     logic   [63:0]  dout
    ,output     logic           valid_o
    ,input      logic           ready_i
);
    typedef logic   [63:0]  data_t  ;

    logic   fifo_prim_push          ;
    data_t  fifo_prim_din           ;
    logic   fifo_prim_pop           ;
    data_t  fifo_prim_dout          ;
    logic   fifo_prim_full          ;
    logic   fifo_prim_empty         ;
    logic   fifo_prim_prog_full     ;
    logic   fifo_prim_prog_empty    ;

    // Write operation.
    assign fifo_prim_din    = din                   ;
    assign fifo_prim_push   = valid_i               ;
    assign ready_o          = !fifo_prim_full       ;
    assign hf_ready_o       = !fifo_prim_prog_full  ;
    // Read operation.

    assign fifo_prim_pop    = valid_o && ready_i    ;
    assign valid_o          = !fifo_prim_empty      ;
    assign dout             = fifo_prim_dout        ;

    fifo_64b_async_prim fifo_64b_async_prim_inst(
         .reset         (reset                  )
        ,.wr_clk        (wr_clk                 )
        ,.push          (fifo_prim_push         )
        ,.din           (fifo_prim_din          )
        ,.full          (fifo_prim_full         )
        ,.prog_full     (fifo_prim_prog_full    )
        ,.rd_clk        (rd_clk                 )
        ,.pop           (fifo_prim_pop          )
        ,.dout          (fifo_prim_dout         )
        ,.empty         (fifo_prim_empty        )
        ,.prog_empty    (fifo_prim_prog_empty   )
    );

endmodule

module fifo_64b_sync_prim #(

)(
     input      logic           clk
    ,input      logic           reset   // TODO : drain all the transactions?

    ,input      logic           push
    ,input      logic   [63:0]  din
    ,output     logic           full
    ,output     logic           prog_full

    ,input      logic           pop
    ,output     logic   [63:0]  dout
    ,output     logic           empty
    ,output     logic           prog_empty

    
);
    
    logic                   RST                 ;
    logic                   WRCLK               ;
    logic                   WREN                ;
    logic   [63:0]          DIN                 ;
    logic   [7:0]           DINP                ;
    logic                   FULL                ;
    logic                   PROGFULL            ;

    logic                   RDCLK               ;
    logic                   RDEN                ;
    logic                   REGCE               ;
    logic   [63:0]          DOUT                ;
    logic   [7:0]           DOUTP               ;
    logic                   EMPTY               ;
    logic                   PROGEMPTY           ;

    assign RST        = reset       ;
    assign RSTREG     = reset       ;
    assign WRCLK      = clk         ;
    assign WREN       = push        ;
    assign DIN        = din         ;
    assign DINP       = '0          ;
    assign full       = FULL        ;
    assign prog_full  = PROGFULL    ;

    assign RDCLK      = clk         ;
    assign RDEN       = pop         ;
    assign dout       = DOUT        ;
    assign empty      = EMPTY       ;
    assign prog_empty = PROGEMPTY   ;
    assign REGCE      = pop         ;

    // Actual depth is 511 in unregistered mode.
    FIFO36E2 #(
         .CASCADE_ORDER             ("NONE"                 ) // FIRST, LAST, MIDDLE, NONE, PARALLEL
        ,.CLOCK_DOMAINS             ("COMMON"               ) // COMMON, INDEPENDENT
        ,.EN_ECC_PIPE               ("FALSE"                ) // ECC pipeline register, (FALSE, TRUE)
        ,.EN_ECC_READ               ("FALSE"                ) // Enable ECC decoder, (FALSE, TRUE)
        ,.EN_ECC_WRITE              ("FALSE"                ) // Enable ECC encoder, (FALSE, TRUE)
        ,.FIRST_WORD_FALL_THROUGH   ("TRUE"                 ) // FALSE, TRUE
        ,.INIT                      (72'h000000000000000000 ) // Initial values on output port
        ,.PROG_EMPTY_THRESH         (256                    ) // Programmable Empty Threshold
        ,.PROG_FULL_THRESH          (256                    ) // Programmable Full Threshold
        ,.IS_RDCLK_INVERTED         (1'b0                   ) // Optional inversion for RDCLK
        ,.IS_RDEN_INVERTED          (1'b0                   ) // Optional inversion for RDEN
        ,.IS_RSTREG_INVERTED        (1'b0                   ) // Optional inversion for RSTREG
        ,.IS_RST_INVERTED           (1'b0                   ) // Optional inversion for RST
        ,.IS_WRCLK_INVERTED         (1'b0                   ) // Optional inversion for WRCLK
        ,.IS_WREN_INVERTED          (1'b0                   ) // Optional inversion for WREN
        ,.RDCOUNT_TYPE              ("EXTENDED_DATACOUNT"   ) // EXTENDED_DATACOUNT, RAW_PNTR, SIMPLE_DATACOUNT, SYNC_PNTR
        ,.READ_WIDTH                (72                     )
        ,.REGISTER_MODE             ("REGISTERED"           ) // DO_PIPELINED, REGISTERED, UNREGISTERED
        ,.RSTREG_PRIORITY           ("REGCE"                ) // REGCE, RSTREG
        ,.SLEEP_ASYNC               ("FALSE"                ) // FALSE, TRUE
        ,.SRVAL                     (72'h000000000000000000 ) // SET/reset value of the FIFO outputs
        ,.WRCOUNT_TYPE              ("EXTENDED_DATACOUNT"   ) // EXTENDED_DATACOUNT, RAW_PNTR, SIMPLE_DATACOUNT, SYNC_PNTR
        ,.WRITE_WIDTH               (72                     )
    )FIFO36E2_inst (
        // Cascade Signals.
         .CASDIN                    (0                      ) // 64-bit input   : Data cascade input bus
        ,.CASDINP                   (0                      ) // 8-bit  input   : Parity data cascade input bus
        ,.CASDOMUX                  (0                      ) // 1-bit  input   : Cascade MUX select input
        ,.CASDOMUXEN                (1                      ) // 1-bit  input   : Enable for cascade MUX select
        ,.CASNXTRDEN                (0                      ) // 1-bit  input   : Cascade next read enable
        ,.CASOREGIMUX               (0                      ) // 1-bit  input   : Cascade output MUX select
        ,.CASOREGIMUXEN             (1                      ) // 1-bit  input   : Cascade output MUX select enable
        ,.CASPRVEMPTY               (0                      ) // 1-bit  input   : Cascade previous empty
        ,.CASDOUT                   (                       ) // 64-bit output  : Data cascade output bus
        ,.CASDOUTP                  (                       ) // 8-bit  output  : Parity data cascade output bus
        ,.CASNXTEMPTY               (                       ) // 1-bit  output  : Cascade next empty
        ,.CASPRVRDEN                (                       ) // 1-bit  output  : Cascade previous read enable
        // Write port.
        ,.RST                       (RST                    ) // 1-bit  input   : Reset
        ,.WRCLK                     (WRCLK                  ) // 1-bit  input   : Write clock
        ,.WREN                      (WREN                   ) // 1-bit  input   : Write enable
        ,.DIN                       (DIN                    ) // 64-bit input   : FIFO data input bus
        ,.DINP                      (DINP                   ) // 8-bit  input   : FIFO parity input bus
        // Read port.
        ,.RDCLK                     (RDCLK                  ) // 1-bit  input   : Read clock
        ,.RDEN                      (RDEN                   ) // 1-bit  input   : Read enable
        ,.REGCE                     (REGCE                  ) // 1-bit  input   : Output register clock enable
        ,.RSTREG                    (RSTREG                 ) // 1-bit  input   : Output register reset
        ,.DOUT                      (DOUT                   ) // 64-bit output  : FIFO data output bus
        ,.DOUTP                     (DOUTP                  ) // 8-bit  output  : FIFO parity output bus.
        // Status outputs: Flags and other FIFO status outputs
        ,.EMPTY                     (EMPTY                  ) // 1-bit  output  : Empty
        ,.FULL                      (FULL                   ) // 1-bit  output  : Full
        ,.PROGEMPTY                 (PROGEMPTY              ) // 1-bit  output  : Programmable empty
        ,.PROGFULL                  (PROGFULL               ) // 1-bit  output  : Programmable full
        ,.RDCOUNT                   (                       ) // 14-bit output  : Read count
        ,.RDERR                     (                       ) // 1-bit  output  : Read error
        ,.RDRSTBUSY                 (                       ) // 1-bit  output  : Reset busy(sync to RDCLK)
        ,.WRCOUNT                   (                       ) // 14-bit output  : Write count
        ,.WRERR                     (                       ) // 1-bit  output  : Write Error
        ,.WRRSTBUSY                 (                       ) // 1-bit  output  : Reset busy(sync to WRCLK)
        // ECC Signals outputs: Error Correction Circuitry ports
        ,.DBITERR                   (                       ) // 1-bit  output  : Double bit error status
        ,.ECCPARITY                 (                       ) // 8-bit  output  : Generated error correction parity
        ,.SBITERR                   (                       ) // 1-bit  output  : Single bit error status
        ,.INJECTDBITERR             (0                      ) // 1-bit  input   : Inject a double-bit error
        ,.INJECTSBITERR             (0                      ) // 1-bit  input   : Inject a single bit error
        ,.SLEEP                     (0                      ) // 1-bit  input   : Sleep Mode
    );

endmodule

module fifo_64b_sync_intf #(
     parameter  int             ReadLatency = 2
)(
     input      logic           reset
    ,input      logic           clk

    ,input      logic   [63:0]  din
    ,input      logic           valid_i
    ,output     logic           ready_o
    ,output     logic           hf_ready_o

    ,output     logic   [63:0]  dout
    ,output     logic           valid_o
    ,input      logic           ready_i
);
    typedef logic   [63:0]  data_t  ;

    logic   fifo_prim_push          ;
    data_t  fifo_prim_din           ;
    logic   fifo_prim_pop           ;
    data_t  fifo_prim_dout          ;
    logic   fifo_prim_full          ;
    logic   fifo_prim_empty         ;
    logic   fifo_prim_prog_full     ;
    logic   fifo_prim_prog_empty    ;

    // Write operation.
    assign fifo_prim_din    = din                   ;
    assign fifo_prim_push   = valid_i               ;
    assign ready_o          = !fifo_prim_full       ;
    assign hf_ready_o       = !fifo_prim_prog_full  ;
    // Read operation.

    assign fifo_prim_pop    = valid_o && ready_i    ;
    assign valid_o          = !fifo_prim_empty      ;
    assign dout             = fifo_prim_dout        ;

    fifo_64b_sync_prim fifo_64b_sync_prim_inst(
         .reset         (reset                  )
        ,.clk           (clk                    )
        ,.push          (fifo_prim_push         )
        ,.din           (fifo_prim_din          )
        ,.full          (fifo_prim_full         )
        ,.prog_full     (fifo_prim_prog_full    )
        ,.pop           (fifo_prim_pop          )
        ,.dout          (fifo_prim_dout         )
        ,.empty         (fifo_prim_empty        )
        ,.prog_empty    (fifo_prim_prog_empty   )
    );

endmodule