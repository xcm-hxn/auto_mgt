/*
    *Built-in ecc error correction is not used.

    (Quoted from UG573)
    The block RAM in UltraScale architecture-based devices stores up to 36 Kbits of data and 
    can be configured as either two independent 18 Kb RAMs, or one 36 Kb RAM. Each 
    block RAM has two write and two read ports. A 36 Kb block RAM can be configured with 
    independent port widths for each of those ports as 32K x 1, 16K x 2, 8K x 4, 4K x 9, 2K x 18 
    or 1K x 36 (when used as true dual-port (TDP) memory). If only one write and one read port 
    are used, a 36 Kb block RAM can additionally be configured with a port width of 512 x 72 
    bits (when used as simple dual-port (SDP) memory). An 18 Kb block RAM can be configured 
    with independent port widths for each of those ports as 16K x 1, 8K x 2, 4K x 4, 2K x 9 or 
    1K x 18 (when used as TDP memory). If only one write and one read port are used, an 18 Kb 
    block RAM can additionally be configured with a port width of 512 x 36 bits (when used as 
    SDP memory).

    TODO : Reset scheme needs to be optimized.

    In latch mode, the RSTRAM pin synchronously forces the data output latches to contain the 
    value SRVAL. When the optional output registers are enabled (DO_REG = 1), the RSTREG 
    signal synchronously forces the data output registers containing the SRVAL value. The 
    priority of RSTREG over REGCE is determined using the RSTREG_PRIORITY attribute. The 
    data output latches or output registers are synchronously asserted to 0 or 1, including the 
    parity bit. Each port has an independent SRVAL[A|B] attribute of 36 bits. This operation does 
    not affect RAM memory cells and does not disturb write operations on the other port. The 
    polarity for both signals is configurable (active-High by default). When used as SDP 
    memory, the RSTREGA port is the RSTREG, and the RSTRAMA port is the RSTRAM.

    In latch mode, the read operation uses one clock edge. The read address is registered on 
    the read port, and the stored data is loaded into the output latches after the RAM access 
    time. When using the output register, the read operation takes one extra latency cycle.

    A write operation is a single clock-edge operation. The write address is registered on the 
    write port, and the data input is stored in memory.
*/

// Maximum depth : 1K.

`include "sgbus_pkgs.svh"

module ram_sdp_32b_async #(
     parameter  int                         AddrWidth = 9
)(
     input      logic                       clk_rd
    ,input      logic                       clk_wr

    ,input      logic                       reset

    ,input      logic   [AddrWidth-1:0]     wr_addr
    ,input      logic   [31:0]              wr_data
    ,input      logic                       wr_valid
    ,output     logic                       wr_ready

    ,input      logic   [AddrWidth-1:0]     rd_addr
    ,output     logic   [31:0]              rd_data
    ,input      logic                       rd_valid
    ,output     logic                       rd_ready
);

    localparam  WriteLatency = 0;
    localparam  ReadLatency  = 2;
    localparam  WrLtncCnt    = sgbus_pkg::idx_width(WriteLatency);
    localparam  RdLtncCnt    = sgbus_pkg::idx_width(ReadLatency);
    localparam  FillWidth    = 15-AddrWidth-5;

    // Port A
    logic   [15-1:0]        ADDRARDADDR     ;
    logic   [1-1:0]         ADDRENA         ;
    logic   [1-1:0]         CLKARDCLK       ;
    logic   [1-1:0]         ENARDEN         ;
    logic   [1-1:0]         REGCEAREGCE     ;
    logic   [1-1:0]         RSTRAMARSTRAM   ;
    logic   [1-1:0]         RSTREGARSTREG   ;
    logic   [4-1:0]         WEA             ;
    logic   [32-1:0]        DINADIN         ;
    logic   [32-1:0]        DOUTADOUT       ;
    //Port B
    logic   [15-1:0]        ADDRBWRADDR     ;
    logic   [1-1:0]         ADDRENB         ;
    logic   [1-1:0]         CLKBWRCLK       ;
    logic   [1-1:0]         ENBWREN         ;
    logic   [8-1:0]         WEBWE           ;
    logic   [32-1:0]        DINBDIN         ;
    logic   [32-1:0]        DOUTBDOUT       ;

    logic   [WrLtncCnt:0]   wr_vld_cnt      ;
    logic   [RdLtncCnt:0]   rd_vld_cnt      ;
    logic   [WrLtncCnt:0]   wr_vld_cnt_nxt  ;
    logic   [RdLtncCnt:0]   rd_vld_cnt_nxt  ;

    // Use explicit assignment to avoid simulation mis-function.
    assign CLKARDCLK     = clk_rd   ;
    assign RSTRAMARSTRAM = 0        ;
    assign RSTREGARSTREG = 0        ;
    assign ADDRENA       = '0       ;
    assign WEA           = '0       ;
    assign rd_data       = DOUTADOUT;
    assign CLKBWRCLK     = clk_wr   ;
    assign ADDRENB       = '0       ;
    assign WEBWE         = '1       ;

    // Write operation.
    always_comb begin
        ADDRBWRADDR     = '0;
        DINBDIN         = '0;
        ENBWREN         = '0;
        wr_vld_cnt_nxt  = '0;
        wr_ready         = 0;
        if(wr_valid) begin
            if(wr_vld_cnt != WriteLatency)
                wr_vld_cnt_nxt = wr_vld_cnt + 1;

            if(wr_vld_cnt == 0) begin
                ADDRBWRADDR = {{FillWidth{1'b0}}, wr_addr, 5'b0};
                DINBDIN     = wr_data;
                ENBWREN     = 1;
            end

            if(wr_vld_cnt == WriteLatency) begin
                wr_ready     = 1;
                wr_vld_cnt_nxt = 0;
            end
        end
    end

    always_ff@(posedge clk_wr) begin
        if(reset) begin
            wr_vld_cnt <= '0;
        end
        else begin
            wr_vld_cnt <= wr_vld_cnt_nxt;
        end
    end

    // Read operation.
    always_comb begin
        ADDRARDADDR     = '0;
        ENARDEN         = 0;
        REGCEAREGCE     = 0;
        rd_vld_cnt_nxt  = '0;
        rd_ready         = 0;
        if(rd_valid) begin
            ENARDEN     = 1;
            REGCEAREGCE = 1;
            if(rd_vld_cnt != ReadLatency)
                rd_vld_cnt_nxt = rd_vld_cnt + 1;

            if(rd_vld_cnt == 0) begin
                ADDRARDADDR = {{FillWidth{1'b0}}, rd_addr, 5'b0};
            end

            if(rd_vld_cnt == ReadLatency) begin
                rd_ready     = 1;
                rd_vld_cnt_nxt = 0;
            end
        end
    end

    always_ff@(posedge clk_rd) begin
        if(reset) begin
            rd_vld_cnt <= '0;
        end
        else begin
            rd_vld_cnt <= rd_vld_cnt_nxt;
        end
    end


    // Arbitor
    /*
    always_comb begin

    end
    */

    RAMB36E2 #(
         .CLOCK_DOMAINS             ("INDEPENDENT"      )
        ,.DOA_REG                   (1                  ) // Set the read latency at 1 cycle.
        ,.DOB_REG                   (1                  ) // Set the read latency at 1 cycle.
        ,.ENADDRENA                 ("FALSE"            )
        ,.ENADDRENB                 ("FALSE"            )
        ,.EN_ECC_PIPE               ("FALSE"            )
        ,.EN_ECC_READ               ("FALSE"            )
        ,.EN_ECC_WRITE              ("FALSE"            )
        ,.INIT_FILE                 ("NONE"             )
        ,.IS_CLKARDCLK_INVERTED     (1'b0               )
        ,.IS_CLKBWRCLK_INVERTED     (1'b0               )
        ,.IS_ENARDEN_INVERTED       (1'b0               )
        ,.IS_ENBWREN_INVERTED       (1'b0               )
        ,.IS_RSTRAMARSTRAM_INVERTED (1'b0               )
        ,.IS_RSTRAMB_INVERTED       (1'b0               )
        ,.IS_RSTREGARSTREG_INVERTED (1'b0               )
        ,.IS_RSTREGB_INVERTED       (1'b0               )
        ,.RDADDRCHANGEA             ("FALSE"            )
        ,.RDADDRCHANGEB             ("FALSE"            )
        ,.READ_WIDTH_A              (36                 )
        ,.READ_WIDTH_B              (0                  )
        ,.WRITE_WIDTH_A             (0                  )
        ,.WRITE_WIDTH_B             (36                 )
        ,.RSTREG_PRIORITY_A         ("REGCE"            )
        ,.RSTREG_PRIORITY_B         ("REGCE"            ) // Priority of REGCE exceeds RSTREG.
        ,.SRVAL_A                   ('0                 )
        ,.SRVAL_B                   ('0                 )
        ,.SLEEP_ASYNC               ("FALSE"            )
        ,.WRITE_MODE_A              ("NO_CHANGE"        )
        ,.WRITE_MODE_B              ("NO_CHANGE"        )
    )RAMB36E2_inst(
        // Cascade Signals
         .CASDOUTA                  (                   ) // 32-bit output  :   Port A cascade output data
        ,.CASDOUTB                  (                   ) // 32-bit output  :   Port B cascade output data
        ,.CASDOUTPA                 (                   ) // 4-bit  output  :   Port A cascade output parity data
        ,.CASDOUTPB                 (                   ) // 4-bit  output  :   Port B cascade output parity data
        ,.CASOUTDBITERR             (                   ) // 1-bit  output  :   DBITERR cascade output
        ,.CASOUTSBITERR             (                   ) // 1-bit  output  :   SBITERR cascade output
        ,.CASDIMUXA                 (0                  ) // 1-bit  input   :   Port A input data (0=DINA, 1=CASDINA), set to DINA.
        ,.CASDIMUXB                 (0                  ) // 1-bit  input   :   Port B input data (0=DINB, 1=CASDINB), set to DINB.
        ,.CASDINA                   (0                  ) // 32-bit input   :   Port A cascade input data
        ,.CASDINB                   (0                  ) // 32-bit input   :   Port B cascade input data
        ,.CASDINPA                  (0                  ) // 4-bit  input   :   Port A cascade input parity data
        ,.CASDINPB                  (0                  ) // 4-bit  input   :   Port B cascade input parity data
        ,.CASDOMUXA                 (0                  ) // 1-bit  input   :   Port A unregistered data (0=BRAM data, 1=CASDINA)
        ,.CASDOMUXB                 (0                  ) // 1-bit  input   :   Port B unregistered data (0=BRAM data, 1=CASDINB)
        ,.CASDOMUXEN_A              (0                  ) // 1-bit  input   :   Port A unregistered output data enable
        ,.CASDOMUXEN_B              (0                  ) // 1-bit  input   :   Port B unregistered output data enable
        ,.CASINDBITERR              (0                  ) // 1-bit  input   :   DBITERR cascade input
        ,.CASINSBITERR              (0                  ) // 1-bit  input   :   SBITERR cascade input
        ,.CASOREGIMUXA              (0                  ) // 1-bit  input   :   Port A registered data (0=BRAM data, 1=CASDINA)
        ,.CASOREGIMUXB              (0                  ) // 1-bit  input   :   Port B registered data (0=BRAM data, 1=CASDINB)
        ,.CASOREGIMUXEN_A           (0                  ) // 1-bit  input   :   Port A registered output data enable
        ,.CASOREGIMUXEN_B           (0                  ) // 1-bit  input   :   Port B registered output data enable
        // Port A, read port.
        ,.ADDRARDADDR               (ADDRARDADDR        ) // 15-bit input   :   A/Read port address
        ,.ADDRENA                   (ADDRENA            ) // 1-bit  input   :   Active-High A/Read port address enable
        ,.CLKARDCLK                 (CLKARDCLK          ) // 1-bit  input   :   A/Read port clock
        ,.ENARDEN                   (ENARDEN            ) // 1-bit  input   :   Port A enable/Read enable
        ,.REGCEAREGCE               (REGCEAREGCE        ) // 1-bit  input   :   Port A register enable/Register enable, set to 0 cause DOA is disabled.
        ,.RSTRAMARSTRAM             (RSTRAMARSTRAM      ) // 1-bit  input   :   Port A set/reset, implemented as the RSTRAM in SDP mode.
        ,.RSTREGARSTREG             (RSTREGARSTREG      ) // 1-bit  input   :   Port A register set/reset, implemented as the RSTREG in SDP mode.
        ,.WEA                       (WEA                ) // 4-bit  input   :   Port A write enable
        ,.DINADIN                   (DINADIN            ) // 32-bit input   :   Port A data/LSB data
        ,.DINPADINP                 (4'b0               ) // 4-bit  input   :   Port A parity/LSB parity
        ,.DOUTADOUT                 (DOUTADOUT          ) // 32-bit output  :   Port A Data/LSB data
        ,.DOUTPADOUTP               (                   ) // 4-bit  output  :   Port A parity/LSB parity
        // Port B, write port.
        ,.ADDRBWRADDR               (ADDRBWRADDR        ) // 15-bit input   :   B/Write port address
        ,.ADDRENB                   (ADDRENB            ) // 1-bit  input   :   Active-High B/Write port address enable
        ,.CLKBWRCLK                 (CLKBWRCLK          ) // 1-bit  input   :   B/Write port clock
        ,.ENBWREN                   (ENBWREN            ) // 1-bit  input   :   Port B enable/Write enable
        ,.REGCEB                    (0                  ) // 1-bit  input   :   Port B register enable, set to 0 cause DOB is disabled.
        ,.RSTRAMB                   (0                  ) // 1-bit  input   :   Port B set/reset, set to 0 cause the RAMB36E2 is implemented as a SDP RAM.
        ,.RSTREGB                   (0                  ) // 1-bit  input   :   Port B register set/reset, set to 0 cause the RAMB36E2 is implemented as a SDP RAM.
        ,.WEBWE                     (WEBWE              ) // 8-bit  input   :   Port B write enable/Write enable
        ,.DINBDIN                   (DINBDIN            ) // 32-bit input   :   Port B data/MSB data
        ,.DINPBDINP                 (4'b0               ) // 4-bit  input   :   Port B parity/MSB parity
        ,.DOUTBDOUT                 (DOUTBDOUT          ) // 32-bit output  :   Port B data/MSB data
        ,.DOUTPBDOUTP               (                   ) // 4-bit  output  :   Port B parity/MSB parity
        // Misc
        ,.SLEEP                     (0                  ) // 1-bit  input   :   Sleep Mode
        ,.DBITERR                   (                   ) // 1-bit  output  :   Double bit error status
        ,.ECCPARITY                 (                   ) // 8-bit  output  :   Generated error correction parity
        ,.RDADDRECC                 (                   ) // 9-bit  output  :   ECC Read Address
        ,.SBITERR                   (                   ) // 1-bit  output  :   Single bit error status
        ,.ECCPIPECE                 (0                  ) // 1-bit  input   :   ECC Pipeline Register Enable
        ,.INJECTDBITERR             (0                  ) // 1-bit  input   :   Inject a double-bit error
        ,.INJECTSBITERR             (0                  )
    );


endmodule

/*
    ram_sdp_32b_async #(
         .AddrWidth ()
    )ram_sdp_32b_async_inst(
         .clk_rd    ()
        ,.clk_wr    ()
        ,.reset     ()
        ,.wr_addr   ()
        ,.wr_data   ()
        ,.wr_valid  ()
        ,.wr_ready  ()
        ,.rd_addr   ()
        ,.rd_data   ()
        ,.rd_valid  ()
        ,.rd_ready  ()
    );
*/

// Maximum depth : 512.
// module ram_sdp_64b_async #(

// )(

// );


// endmodule

