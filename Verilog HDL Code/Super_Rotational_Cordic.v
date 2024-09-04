module Super_Rotational_Cordic #( 
	parameter 	INT_LENGTH			=	7, 
	parameter	FRAC_LENGTH			=	11,
	parameter 	NUM_OF_ITERATIONS	=	11
)  (
///////////////////// Inputs /////////////////////////////////
input  wire                                          CLK,
input  wire                                          RST,
input  wire                                          enable_super_rotational,
input  wire signed  [INT_LENGTH+FRAC_LENGTH-1:0]	 x_r,
input  wire signed  [INT_LENGTH+FRAC_LENGTH-1:0]	 x_i,
input  wire signed  [INT_LENGTH+FRAC_LENGTH-1:0]	 y_r,
input  wire signed  [INT_LENGTH+FRAC_LENGTH-1:0]	 y_i,
input  wire signed  [INT_LENGTH+FRAC_LENGTH-1:0]	 phi,
input  wire signed  [INT_LENGTH+FRAC_LENGTH-1:0]	 theta,
///////////////////// Outputs ////////////////////////////////
output wire signed  [INT_LENGTH+FRAC_LENGTH-1:0]	 x_out_r,
output wire signed  [INT_LENGTH+FRAC_LENGTH-1:0]	 x_out_i,
output wire signed  [INT_LENGTH+FRAC_LENGTH-1:0]	 y_out_r,
output wire signed  [INT_LENGTH+FRAC_LENGTH-1:0]	 y_out_i,
output wire                                          done_super_rotational
);


//////////////////////////////////////////////////////////////
////////////////////////  Parameters /////////////////////////
//////////////////////////////////////////////////////////////

localparam WORD_LENGTH = INT_LENGTH + FRAC_LENGTH ;



//////////////////////////////////////////////////////////////
/////////////////////  Internal Signals  /////////////////////
//////////////////////////////////////////////////////////////
 wire signed  [INT_LENGTH+FRAC_LENGTH-1:0]	 t_r;
 wire signed  [INT_LENGTH+FRAC_LENGTH-1:0]	 t_i;
 wire                                      	 Enable_cordic2;
 wire                                      	 Enable_cordic3;




//////////////////////////////////////////////////////////////////////////////////
///////////////////////  Instance of the 3 Rotational Cordics ////////////////////
//////////////////////////////////////////////////////////////////////////////////

Rotational_Cordic  # (
	.INT_LENGTH(INT_LENGTH),
	.FRAC_LENGTH(FRAC_LENGTH),
	.NUM_OF_ITERATIONS(NUM_OF_ITERATIONS)
	 
	 ) DUT_1 (
	
	.CLK(CLK),
	.RST(RST),
	.ENABLE(enable_super_rotational),
	.Xo(y_r),
	.Yo(y_i),
	.Zo(phi),
	.XN(t_r),
	.YN(t_i),
	.Done(Enable_cordic2)
	);



Rotational_Cordic  # (
	.INT_LENGTH(INT_LENGTH),
	.FRAC_LENGTH(FRAC_LENGTH),
	.NUM_OF_ITERATIONS(NUM_OF_ITERATIONS)
	 
	 ) DUT_2 (	
	
	.CLK(CLK),
	.RST(RST),
	.ENABLE(Enable_cordic2),
	.Xo(x_r),
	.Yo(t_r),
	.Zo(theta),
	.XN(x_out_r),
	.YN(y_out_r),
	.Done(Enable_cordic3)
	);



Rotational_Cordic  # (
	.INT_LENGTH(INT_LENGTH),
	.FRAC_LENGTH(FRAC_LENGTH),
	.NUM_OF_ITERATIONS(NUM_OF_ITERATIONS)
	 
	 ) DUT_3 (
	
	.CLK(CLK),
	.RST(RST),
	.ENABLE(Enable_cordic3),
	.Xo(x_i),
	.Yo(t_i),
	.Zo(theta),
	.XN(x_out_i),
	.YN(y_out_i),
	.Done(done_super_rotational)
	);



endmodule