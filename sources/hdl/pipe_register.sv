module pipe_register #(
	parameter type T           = logic,
	parameter bit  Bypass      = 1'b0
)(
	input  logic clk   		,
	input  logic reset  	,
	
	input  logic valid_i 	,	// Input data valid.
	output logic ready_o 	,	// Back pressure for the last stage.
	input  T     data_i  	,	// Input data.

	output logic valid_o 	,	// Output data valid.
	input  logic ready_i 	,	// Back pressure from the next stage.
	output T     data_o			// Output data.
);

	generate
		if (Bypass) begin : bypass_gen
			assign valid_o = valid_i;
			assign ready_o = ready_i;
			assign data_o  = data_i;
		end 
		else begin : pipe_gen
			// The A register.
			T a_data;
			logic a_full;
			logic a_fill, a_drain;

			T b_data;
			logic b_full;
			logic b_fill, b_drain;

			assign a_fill  = valid_i && ready_o      	;
			assign a_drain = a_full && !b_full       	;
			assign b_fill  = a_drain && !ready_i     	;
			assign b_drain = b_full && ready_i       	;
			assign ready_o = !a_full || !b_full      	;
			assign valid_o = a_full | b_full         	;
			assign data_o  = b_full ? b_data : a_data	;


			always_ff@(posedge clk) begin
				if(reset) begin
					a_data <= T'(0);
					b_data <= T'(0);
					a_full <= '0;
					b_full <= '0;
				end
				else begin
					if(a_fill)
						a_data <= data_i;
					else
						a_data <= a_data;

					if(b_fill)
						b_data <= a_data;
					else
						b_data <= b_data;
					
					if(a_fill || a_drain)
						a_full <= a_fill;
					else	
						a_full <= a_full;
					
					if(b_fill || b_drain)
						b_full <= b_fill;
					else
						b_full <= b_full;
				end
			end
		end
	endgenerate
	
endmodule
