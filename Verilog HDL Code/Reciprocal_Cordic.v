/////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// Module ports list, declaration, and data type ///////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
module Reciprocal_Cordic #( 
	parameter 	INT_LENGTH			=	17, 
	parameter	FRAC_LENGTH			=	12,
	parameter 	NUM_OF_ITERATIONS	=	11,
	parameter	SCALE				=	5
)(

input   wire                           CLK,
input   wire                           RST,
input   wire                            Enable_recp,
input   wire signed [INT_LENGTH + FRAC_LENGTH -1:0]   Input_recp,
output  reg  signed [INT_LENGTH + FRAC_LENGTH -1:0]   reciprocal,
output  reg                            Valid_recp

);


///////////////////////////////// Parameters /////////////////////////////////////////////
localparam WORD_LENGTH = INT_LENGTH + FRAC_LENGTH ;





//////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Signals and Internal Connections /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////


reg    signed      [INT_LENGTH + FRAC_LENGTH -1:0]   Y;
// 1 in fixed point
wire    signed      [INT_LENGTH + FRAC_LENGTH -1:0]    one_fixed_point;
// 0.5 in fixed point
wire    signed      [INT_LENGTH + FRAC_LENGTH -1:0]    half_fixed_point;

//wire    signed      [INT_LENGTH + FRAC_LENGTH -1:0]    Input_scaled_c;
reg 	signed	[$clog2(NUM_OF_ITERATIONS):0] iterations;

reg		flag_reg;
wire	scale_flag;

reg    	signed      [INT_LENGTH + FRAC_LENGTH -1:0]    Input_reg;
wire    signed       [INT_LENGTH + FRAC_LENGTH -1:0]   Input_shifted;






//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// Implementation //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////


always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		// reset
		reciprocal 	<=	'b0;
		iterations 	<=	'b0;
		Y 			<=	one_fixed_point;
		flag_reg	<=	'b0;
		Valid_recp 	<=	'b0;
		Input_reg 	<=	'b0;
	end
	else if ( Enable_recp) begin
		Valid_recp 	<=	'b0;
		iterations 	<=	'b0;
		reciprocal 	<=	'b0;

		// Scaling Input in order to obtain reciprocals for numbers less than 0.5
		if(Input_recp < half_fixed_point) begin
			Input_reg	<=	(Input_recp<<SCALE);
		end
		else begin
			Input_reg	<=	Input_recp;
		end
		flag_reg	    <=	'b1;
	end

	else if (flag_reg) begin

		if(Y =='b0) begin
			Y 			<= 	Y;
			reciprocal	<=	reciprocal;
		end
		
		else if(Y[WORD_LENGTH-1] == 'b1) begin  // y<0
			Y 			<= 	Y + Input_shifted;
			reciprocal	<=	reciprocal - (one_fixed_point>>iterations);
		end
		
		else begin 	// y>0
			Y 			<= 	Y - Input_shifted;
			reciprocal	<=	reciprocal + (one_fixed_point>>iterations);			
		end

		

		// increment iterations
		if(iterations == NUM_OF_ITERATIONS) begin
			iterations 	<=	'b0;
			Valid_recp 	<=	'b1;
			flag_reg	<=	'b0;
			Y 			<= 	one_fixed_point;

			// scaling output by same input scale		
			if(scale_flag) begin
				reciprocal 	<=	(reciprocal<<SCALE);
			end
			else begin
				reciprocal 	<=	reciprocal;
			end
			
		end
		else begin
			iterations 	<=	iterations 	+ 'b1;
			Valid_recp 	<=	'b0;
		
		end

	end

	else begin
		Y 			<= 	one_fixed_point;
		//reciprocal 	<=	'b0;
		flag_reg	<=	'b0;
		iterations 	<=	'b0;
		Valid_recp 	<=	'b0;
		Input_reg 	<=	'b0;
	end

end






//////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// assign  statements ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

assign one_fixed_point = { {(INT_LENGTH-1){1'b0}} , 1'b1 , {FRAC_LENGTH{1'b0}} }; // 1 - fixed_point

assign half_fixed_point = { {(INT_LENGTH){1'b0}} , 1'b1 , {(FRAC_LENGTH-1){1'b0}} }; // 0.5 - fixed_point

assign Input_shifted =  Input_reg>>iterations;

assign scale_flag = (Input_recp < half_fixed_point) ? 'b1 : 'b0;





endmodule