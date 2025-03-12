`timescale 1ns/1ps
`include "sgbus_pkgs.svh"
`include "sgbus_defines.svh"
import sgbus_pkg::*;

module stream_data_scaling #(
     parameter  int             SlvStreamWidth  = 64
    ,parameter  int             MstStreamWidth  = 64
    ,parameter  int             DivisionWidth   = 64
    ,parameter  int             BufferSize      = 16
    ,parameter  int             FIFOThreshold   = 8
    ,parameter  type            s_axis_req_t    = logic     
    ,parameter  type            s_axis_resp_t   = logic
    ,parameter  type            m_axis_req_t    = logic
    ,parameter  type            m_axis_resp_t   = logic
)(
     input      logic           clk     
    ,input      logic           reset
    ,input      s_axis_req_t    s_axis_req
    ,output     s_axis_resp_t   s_axis_resp
    ,output     s_axis_resp_t   s_axis_hf_resp
    ,output     m_axis_req_t    m_axis_req
    ,input      m_axis_resp_t   m_axis_resp
);

    typedef     logic   [DivisionWidth - 1 : 0]     inter_data_t    ;

    `AXIS_TYPEDEF_ALL(inter, inter_axis_req_t, inter_axis_resp_t, inter_data_t)

    inter_axis_req_t    inter_axis_req  ; 
    inter_axis_resp_t   inter_axis_resp ;

    // generate
        
    //     // downsize first
    //     if(SlvStreamWidth > DivisionWidth) begin

            stream_downsizer #(
                 .SlvStreamWidth(SlvStreamWidth     )
                ,.MstStreamWidth(DivisionWidth      )
                ,.BufferSize    (BufferSize         )
                ,.FIFOThreshold (FIFOThreshold      )
                ,.s_axis_req_t  (s_axis_req_t       )
                ,.s_axis_resp_t (s_axis_resp_t      )
                ,.m_axis_req_t  (inter_axis_req_t   )
                ,.m_axis_resp_t (inter_axis_resp_t  )
                ,.m_axis_data_t (inter_data_t       )
            )stream_downsizer_inst(
                 .clk           (clk                )
                ,.reset         (reset              )        
                ,.s_axis_req    (s_axis_req         )   
                ,.s_axis_resp   (s_axis_resp        )
                ,.s_axis_hf_resp(s_axis_hf_resp     )
                ,.m_axis_req    (inter_axis_req     )   
                ,.m_axis_resp   (inter_axis_resp    )  
            );

            stream_upsizer #(
                 .SlvStreamWidth(DivisionWidth      )
                ,.MstStreamWidth(MstStreamWidth     )
                ,.BufferSize    (2                  )
                ,.s_axis_req_t  (inter_axis_req_t   )
                ,.s_axis_resp_t (inter_axis_resp_t  )
                ,.s_axis_data_t (inter_data_t       )
                ,.m_axis_req_t  (m_axis_req_t       )
                ,.m_axis_resp_t (m_axis_resp_t      )  
            )stream_upsizer_inst(
                 .clk           (clk                )
                ,.reset         (reset              )        
                ,.s_axis_req    (inter_axis_req     )   
                ,.s_axis_resp   (inter_axis_resp    )  
                ,.m_axis_req    (m_axis_req         )   
                ,.m_axis_resp   (m_axis_resp        )  
            );

        // end
        // upsize first
    //     else begin

    //         stream_upsizer #(
    //              .SlvStreamWidth(SlvStreamWidth     )
    //             ,.MstStreamWidth(DivisionWidth      )
    //             ,.BufferSize    (BufferSize         )
    //             ,.s_axis_req_t  (s_axis_req_t       )
    //             ,.s_axis_resp_t (s_axis_resp_t      )
    //             ,.s_axis_data_t (inter_data_t       )
    //             ,.m_axis_req_t  (inter_axis_req_t   )
    //             ,.m_axis_resp_t (inter_axis_resp_t  )  
    //         )stream_upsizer_inst(
    //              .clk           (clk                )
    //             ,.reset         (reset              )        
    //             ,.s_axis_req    (s_axis_req         )   
    //             ,.s_axis_resp   (s_axis_resp        )  
    //             ,.m_axis_req    (inter_axis_req     )   
    //             ,.m_axis_resp   (inter_axis_resp    )  
    //         );

    //         stream_downsizer #(
    //              .SlvStreamWidth(DivisionWidth      )
    //             ,.MstStreamWidth(MstStreamWidth     )
    //             ,.BufferSize    (2                  )
    //             ,.s_axis_req_t  (inter_axis_req_t   )
    //             ,.s_axis_resp_t (inter_axis_resp_t  )
    //             ,.m_axis_req_t  (m_axis_req_t       )
    //             ,.m_axis_resp_t (m_axis_resp_t      )
    //             ,.m_axis_data_t (inter_data_t       )
    //         )stream_downsizer_inst(
    //              .clk           (clk                )
    //             ,.reset         (reset              )        
    //             ,.s_axis_req    (inter_axis_req     )   
    //             ,.s_axis_resp   (inter_axis_resp    )  
    //             ,.m_axis_req    (m_axis_req         )   
    //             ,.m_axis_resp   (m_axis_resp        )  
    //         );

    //     end

    // endgenerate

    

endmodule