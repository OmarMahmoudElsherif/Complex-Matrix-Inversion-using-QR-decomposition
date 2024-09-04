/////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// Module ports list, declaration, and data type ///////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
module Q_T_Rinv_wrapper #(
   	parameter 	WORD_LENGTH			=	18, 
	parameter	FRAC_LENGTH			=	11,
	parameter 	NUM_OF_ITERATIONS	=	11
)   (
///////////////////// Inputs /////////////////////////////////
    input   wire                           CLK,
    input   wire                           RST,
    input   wire                           Enable_Q_T_Rinv,
    // --------------- A matrix --------------- //
    input   wire signed [WORD_LENGTH-1:0]  A_11_r,
    input   wire signed [WORD_LENGTH-1:0]  A_11_i,
    input   wire signed [WORD_LENGTH-1:0]  A_12_r,
    input   wire signed [WORD_LENGTH-1:0]  A_12_i,
    input   wire signed [WORD_LENGTH-1:0]  A_13_r,
    input   wire signed [WORD_LENGTH-1:0]  A_13_i,
    input   wire signed [WORD_LENGTH-1:0]  A_14_r,
    input   wire signed [WORD_LENGTH-1:0]  A_14_i,
    input   wire signed [WORD_LENGTH-1:0]  A_21_r,
    input   wire signed [WORD_LENGTH-1:0]  A_21_i,
    input   wire signed [WORD_LENGTH-1:0]  A_22_r,
    input   wire signed [WORD_LENGTH-1:0]  A_22_i,
    input   wire signed [WORD_LENGTH-1:0]  A_23_r,
    input   wire signed [WORD_LENGTH-1:0]  A_23_i,
    input   wire signed [WORD_LENGTH-1:0]  A_24_r,
    input   wire signed [WORD_LENGTH-1:0]  A_24_i,
    input   wire signed [WORD_LENGTH-1:0]  A_31_r,
    input   wire signed [WORD_LENGTH-1:0]  A_31_i,
    input   wire signed [WORD_LENGTH-1:0]  A_32_r,
    input   wire signed [WORD_LENGTH-1:0]  A_32_i,
    input   wire signed [WORD_LENGTH-1:0]  A_33_r,
    input   wire signed [WORD_LENGTH-1:0]  A_33_i,
    input   wire signed [WORD_LENGTH-1:0]  A_34_r,
    input   wire signed [WORD_LENGTH-1:0]  A_34_i,
    input   wire signed [WORD_LENGTH-1:0]  A_41_r,
    input   wire signed [WORD_LENGTH-1:0]  A_41_i,
    input   wire signed [WORD_LENGTH-1:0]  A_42_r,
    input   wire signed [WORD_LENGTH-1:0]  A_42_i,
    input   wire signed [WORD_LENGTH-1:0]  A_43_r,
    input   wire signed [WORD_LENGTH-1:0]  A_43_i,
    input   wire signed [WORD_LENGTH-1:0]  A_44_r,
    input   wire signed [WORD_LENGTH-1:0]  A_44_i,
///////////////////// Outputs ////////////////////////////////
    // ------------- R inverse matrix ------------- //
    output   wire signed [WORD_LENGTH-1:0]  R_inv_11_r,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_12_r,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_12_i,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_13_r,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_13_i,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_14_r,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_14_i,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_22_r,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_23_r,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_23_i,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_24_r,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_24_i,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_33_r,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_34_r,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_34_i,
    output   wire signed [WORD_LENGTH-1:0]  R_inv_44_r,
    // ------------ Q transpose matrix ------------ //
    output   wire signed [WORD_LENGTH-1:0]  Q_T_11_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_11_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_12_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_12_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_13_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_13_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_14_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_14_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_21_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_21_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_22_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_22_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_23_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_23_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_24_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_24_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_31_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_31_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_32_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_32_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_33_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_33_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_34_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_34_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_41_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_41_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_42_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_42_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_43_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_43_i,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_44_r,
    output   wire signed [WORD_LENGTH-1:0]  Q_T_44_i,

    // --------------- Valid Signal --------------- //
    output  wire                            valid_Q_T_Rinv

);


//////////////////////////////////////////////////////////////
////////////////////////  Parameters /////////////////////////
//////////////////////////////////////////////////////////////

localparam INT_LENGTH   = WORD_LENGTH - FRAC_LENGTH ;
localparam SCALE_ROW_1  = 1; //  /2
localparam SCALE_ROW_3  = 2; //  *4
localparam SCALE_ROW_4  = 4; //  *16




//////////////////////////////////////////////////////////////
////////////////////  Internal Signals  //////////////////////
//////////////////////////////////////////////////////////////


wire     enable_rot_cordic_1;
wire     enable_rot_cordic_2;
wire     enable_vec_cordic;
wire     enable_super_rot_cordic_1;
wire     enable_super_rot_cordic_2;
wire     enable_super_vec_cordic;
    
wire     done_rot_cordic_1;
wire     done_rot_cordic_2;
wire     done_vec_cordic;
wire     done_super_rot_cordic_1;
wire     done_super_rot_cordic_2;
wire     done_super_vec_cordic;

// ----- rotational CORDIC Signals ----- //
wire signed [WORD_LENGTH-1:0]  XN_rot_cordic_1;
wire signed [WORD_LENGTH-1:0]  XN_rot_cordic_2;
wire signed [WORD_LENGTH-1:0]  YN_rot_cordic_1;
wire signed [WORD_LENGTH-1:0]  YN_rot_cordic_2;

// ----- vectoring CORDIC Signals ----- //
wire  signed [WORD_LENGTH-1:0]  output_mag_vec_cordic;
wire  signed [WORD_LENGTH-1:0]  output_angle_vec_cordic;

// -- Super vectoring CORDIC Signals -- //
wire  signed [WORD_LENGTH-1:0]  ouput_mag_super_vec_cordic;
wire  signed [WORD_LENGTH-1:0]  output_angle_ceta_super_vec_cordic;
wire  signed [WORD_LENGTH-1:0]  output_angle_phi_super_vec_cordic;
    
// -- Super rotational CORDIC Signals -- //
wire  signed [WORD_LENGTH-1:0]  x_out_r_super_rot_cordic_1;
wire  signed [WORD_LENGTH-1:0]  x_out_i_super_rot_cordic_1;
wire  signed [WORD_LENGTH-1:0]  y_out_r_super_rot_cordic_1;
wire  signed [WORD_LENGTH-1:0]  y_out_i_super_rot_cordic_1;
    
wire  signed [WORD_LENGTH-1:0]  x_out_r_super_rot_cordic_2;
wire  signed [WORD_LENGTH-1:0]  x_out_i_super_rot_cordic_2;
wire  signed [WORD_LENGTH-1:0]  y_out_r_super_rot_cordic_2;
wire  signed [WORD_LENGTH-1:0]  y_out_i_super_rot_cordic_2;


// ----- rotational CORDIC Signals ----- //
wire signed [WORD_LENGTH-1:0]  Xo_rot_cordic_1;
wire signed [WORD_LENGTH-1:0]  Xo_rot_cordic_2;
wire signed [WORD_LENGTH-1:0]  Yo_rot_cordic_1;
wire signed [WORD_LENGTH-1:0]  Yo_rot_cordic_2;
wire signed [WORD_LENGTH-1:0]  Zo_rot_cordic_1;
wire signed [WORD_LENGTH-1:0]  Zo_rot_cordic_2;

// ----- vectoring CORDIC Signals ----- //
wire signed [WORD_LENGTH-1:0]  input_1_vec_cordic;
wire signed [WORD_LENGTH-1:0]  input_2_vec_cordic;
    
// -- Super vectoring CORDIC Signals -- //
wire signed [WORD_LENGTH-1:0]  input_1_super_vec_cordic;
wire signed [WORD_LENGTH-1:0]  input_2_r_super_vec_cordic;
wire signed [WORD_LENGTH-1:0]  input_2_i_super_vec_cordic;
    
// -- Super rotational CORDIC Signals -- //
wire signed [WORD_LENGTH-1:0]  x_r_super_rot_cordic_1;
wire signed [WORD_LENGTH-1:0]  x_i_super_rot_cordic_1;
wire signed [WORD_LENGTH-1:0]  y_r_super_rot_cordic_1;
wire signed [WORD_LENGTH-1:0]  y_i_super_rot_cordic_1;
wire signed [WORD_LENGTH-1:0]  phi_super_rot_cordic_1;
wire signed [WORD_LENGTH-1:0]  theta_super_rot_cordic_1;
    
wire signed [WORD_LENGTH-1:0]  x_r_super_rot_cordic_2;
wire signed [WORD_LENGTH-1:0]  x_i_super_rot_cordic_2;
wire signed [WORD_LENGTH-1:0]  y_r_super_rot_cordic_2;
wire signed [WORD_LENGTH-1:0]  y_i_super_rot_cordic_2;
wire signed [WORD_LENGTH-1:0]  phi_super_rot_cordic_2;
wire signed [WORD_LENGTH-1:0]  theta_super_rot_cordic_2;


// ----------- Valid Signal ----------- //
wire                            Valid_R;


// --------------- R matrix --------------- //
wire signed [WORD_LENGTH-1:0]  R_11_r;
wire signed [WORD_LENGTH-1:0]  R_12_r;
wire signed [WORD_LENGTH-1:0]  R_12_i;
wire signed [WORD_LENGTH-1:0]  R_13_r;
wire signed [WORD_LENGTH-1:0]  R_13_i;
wire signed [WORD_LENGTH-1:0]  R_14_r;
wire signed [WORD_LENGTH-1:0]  R_14_i;
wire signed [WORD_LENGTH-1:0]  R_22_r;
wire signed [WORD_LENGTH-1:0]  R_23_r;
wire signed [WORD_LENGTH-1:0]  R_23_i;
wire signed [WORD_LENGTH-1:0]  R_24_r;
wire signed [WORD_LENGTH-1:0]  R_24_i;
wire signed [WORD_LENGTH-1:0]  R_33_r;
wire signed [WORD_LENGTH-1:0]  R_34_r;
wire signed [WORD_LENGTH-1:0]  R_34_i;
wire signed [WORD_LENGTH-1:0]  R_44_r;


// ------------ R inverse matrix ------------ //
wire signed [WORD_LENGTH-1:0]  R_inv_11_r_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_12_r_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_12_i_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_13_r_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_13_i_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_14_r_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_14_i_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_22_r_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_23_r_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_23_i_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_24_r_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_24_i_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_33_r_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_34_r_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_34_i_scaled;
wire signed [WORD_LENGTH-1:0]  R_inv_44_r_scaled;

wire                           Valid_R_inverse;




//////////////////////////////////////////////////////////////
///////////////////  DUT Instantiations  /////////////////////
//////////////////////////////////////////////////////////////




// --------------------------------------------------------- //
// ---------------- rotational cordic DUT 1 ---------------- //
// --------------------------------------------------------- //

Rotational_Cordic #( 
	.INT_LENGTH(INT_LENGTH), 
	.FRAC_LENGTH(FRAC_LENGTH),
	.NUM_OF_ITERATIONS(NUM_OF_ITERATIONS)
) rot_cordic_DUT_1 (
///////////////////// Inputs /////////////////////////////////
    .CLK(CLK),
    .RST(RST),
    .ENABLE(enable_rot_cordic_1),
    .Xo(Xo_rot_cordic_1),
    .Yo(Yo_rot_cordic_1),
    .Zo(Zo_rot_cordic_1),
///////////////////// Outputs ////////////////////////////////
    .XN(XN_rot_cordic_1),
    .YN(YN_rot_cordic_1),
    .Done(done_rot_cordic_1)
);





// --------------------------------------------------------- //
// ---------------- rotational cordic DUT 2 ---------------- //
// --------------------------------------------------------- //

Rotational_Cordic #( 
	.INT_LENGTH(INT_LENGTH), 
	.FRAC_LENGTH(FRAC_LENGTH),
	.NUM_OF_ITERATIONS(NUM_OF_ITERATIONS)
) rot_cordic_DUT_2 (
///////////////////// Inputs /////////////////////////////////
    .CLK(CLK),
    .RST(RST),
    .ENABLE(enable_rot_cordic_2),
    .Xo(Xo_rot_cordic_2),
    .Yo(Yo_rot_cordic_2),
    .Zo(Zo_rot_cordic_2),
///////////////////// Outputs ////////////////////////////////
    .XN(XN_rot_cordic_2),
    .YN(YN_rot_cordic_2),
    .Done(done_rot_cordic_2)
);


// --------------------------------------------------------- //
// ----------------- vectoring cordic DUT  ----------------- //
// --------------------------------------------------------- //

vector_cordic #(
    .NUMBER_OF_ITERATIONS(NUM_OF_ITERATIONS),
    .INT_WIDTH(INT_LENGTH),
    .FRACT_WIDTH(FRAC_LENGTH),
    .DATA_WIDTH(WORD_LENGTH)
) vec_cordic_DUT (
///////////////////////////// Inputs /////////////////////////////
    .clk(CLK),
    .rst_n(RST),
    .vector_cordic_enable(enable_vec_cordic),
    .input_1(input_1_vec_cordic),
    .input_2(input_2_vec_cordic),        
///////////////////////////// Outputs /////////////////////////////
    .vector_cordic_valid(done_vec_cordic),
    .vector_ouput_mag(output_mag_vec_cordic),
    .vector_output_angle(output_angle_vec_cordic)
);




// --------------------------------------------------------- //
// -------------- Super vectoring cordic DUT  -------------- //
// --------------------------------------------------------- //

super_vector_cordic_top #(
    .NUMBER_OF_ITERATIONS(NUM_OF_ITERATIONS),
    .INT_WIDTH(INT_LENGTH),
    .FRACT_WIDTH(FRAC_LENGTH),
    .DATA_WIDTH(WORD_LENGTH)
) super_vec_cordic_DUT (
///////////////////////////// Inputs /////////////////////////////
    .clk(CLK),
    .rst_n(RST),
    .super_vector_cordic_enable(enable_super_vec_cordic),
    .input_1(input_1_super_vec_cordic),
    .input_2_r(input_2_r_super_vec_cordic),
    .input_2_i(input_2_i_super_vec_cordic),        
///////////////////////////// Outputs /////////////////////////////
    .super_vector_cordic_valid(done_super_vec_cordic),
    .super_vector_ouput_mag(ouput_mag_super_vec_cordic),
    .super_vector_output_angle_ceta(output_angle_ceta_super_vec_cordic),
    .super_vector_output_angle_phi(output_angle_phi_super_vec_cordic)
);




// --------------------------------------------------------- //
// ------------- Super rotational cordic DUT 1 ------------- //
// --------------------------------------------------------- //

Super_Rotational_Cordic #( 
	.INT_LENGTH(INT_LENGTH), 
	.FRAC_LENGTH(FRAC_LENGTH),
	.NUM_OF_ITERATIONS(NUM_OF_ITERATIONS)
) super_rot_cordic_DUT_1 (
///////////////////// Inputs /////////////////////////////////
    .CLK(CLK),
    .RST(RST),
    .enable_super_rotational(enable_super_rot_cordic_1),
    .x_r(x_r_super_rot_cordic_1),
    .x_i(x_i_super_rot_cordic_1),
    .y_r(y_r_super_rot_cordic_1),
    .y_i(y_i_super_rot_cordic_1),
    .phi(phi_super_rot_cordic_1),
    .theta(theta_super_rot_cordic_1),
///////////////////// Outputs ////////////////////////////////
    .x_out_r(x_out_r_super_rot_cordic_1),
    .x_out_i(x_out_i_super_rot_cordic_1),
    .y_out_r(y_out_r_super_rot_cordic_1),
    .y_out_i(y_out_i_super_rot_cordic_1),
    .done_super_rotational(done_super_rot_cordic_1)
);



// --------------------------------------------------------- //
// ------------- Super rotational cordic DUT 2 ------------- //
// --------------------------------------------------------- //

Super_Rotational_Cordic #( 
	.INT_LENGTH(INT_LENGTH), 
	.FRAC_LENGTH(FRAC_LENGTH),
	.NUM_OF_ITERATIONS(NUM_OF_ITERATIONS)
) super_rot_cordic_DUT_2 (
///////////////////// Inputs /////////////////////////////////
    .CLK(CLK),
    .RST(RST),
    .enable_super_rotational(enable_super_rot_cordic_2),
    .x_r(x_r_super_rot_cordic_2),
    .x_i(x_i_super_rot_cordic_2),
    .y_r(y_r_super_rot_cordic_2),
    .y_i(y_i_super_rot_cordic_2),
    .phi(phi_super_rot_cordic_2),
    .theta(theta_super_rot_cordic_2),
///////////////////// Outputs ////////////////////////////////
    .x_out_r(x_out_r_super_rot_cordic_2),
    .x_out_i(x_out_i_super_rot_cordic_2),
    .y_out_r(y_out_r_super_rot_cordic_2),
    .y_out_i(y_out_i_super_rot_cordic_2),
    .done_super_rotational(done_super_rot_cordic_2)
);





// --------------------------------------------------------- //
// ----------------- QR decomposition DUT  ----------------- //
// --------------------------------------------------------- //

QR_decomposition #(
   	.WORD_LENGTH(WORD_LENGTH), 
	.FRAC_LENGTH(FRAC_LENGTH),
	.NUM_OF_ITERATIONS(NUM_OF_ITERATIONS)
) QR_decomposition_DUT  (
///////////////////// Inputs /////////////////////////////////
    .CLK(CLK),
    .RST(RST),
    .Enable_QR(Enable_Q_T_Rinv),
    .A_11_r(A_11_r),
    .A_11_i(A_11_i),
    .A_12_r(A_12_r),
    .A_12_i(A_12_i),
    .A_13_r(A_13_r),
    .A_13_i(A_13_i),
    .A_14_r(A_14_r),
    .A_14_i(A_14_i),
    .A_21_r(A_21_r),
    .A_21_i(A_21_i),
    .A_22_r(A_22_r),
    .A_22_i(A_22_i),
    .A_23_r(A_23_r),
    .A_23_i(A_23_i),
    .A_24_r(A_24_r),
    .A_24_i(A_24_i),
    .A_31_r(A_31_r),
    .A_31_i(A_31_i),
    .A_32_r(A_32_r),
    .A_32_i(A_32_i),
    .A_33_r(A_33_r),
    .A_33_i(A_33_i),
    .A_34_r(A_34_r),
    .A_34_i(A_34_i),
    .A_41_r(A_41_r),
    .A_41_i(A_41_i),
    .A_42_r(A_42_r),
    .A_42_i(A_42_i),
    .A_43_r(A_43_r),
    .A_43_i(A_43_i),
    .A_44_r(A_44_r),
    .A_44_i(A_44_i),
    // ----- rotational CORDIC Signals ----- //
    .XN_rot_cordic_1(XN_rot_cordic_1),
    .XN_rot_cordic_2(XN_rot_cordic_2),
    .YN_rot_cordic_1(YN_rot_cordic_1),
    .YN_rot_cordic_2(YN_rot_cordic_2),
    // ----- vectoring CORDIC Signals ----- //
    .output_mag_vec_cordic(output_mag_vec_cordic),
    .output_angle_vec_cordic(output_angle_vec_cordic),
    // -- Super vectoring CORDIC Signals -- //
    .ouput_mag_super_vec_cordic(ouput_mag_super_vec_cordic),
    .output_angle_ceta_super_vec_cordic(output_angle_ceta_super_vec_cordic),
    .output_angle_phi_super_vec_cordic(output_angle_phi_super_vec_cordic),
    // -- Super rotational CORDIC Signals -- //
    .x_out_r_super_rot_cordic_1(x_out_r_super_rot_cordic_1),
    .x_out_i_super_rot_cordic_1(x_out_i_super_rot_cordic_1),
    .y_out_r_super_rot_cordic_1(y_out_r_super_rot_cordic_1),
    .y_out_i_super_rot_cordic_1(y_out_i_super_rot_cordic_1),
    .x_out_r_super_rot_cordic_2(x_out_r_super_rot_cordic_2),
    .x_out_i_super_rot_cordic_2(x_out_i_super_rot_cordic_2),
    .y_out_r_super_rot_cordic_2(y_out_r_super_rot_cordic_2),
    .y_out_i_super_rot_cordic_2(y_out_i_super_rot_cordic_2),
    // -------- CORDIC Done Signals -------- //
    .done_rot_1_cordic(done_rot_cordic_1),
    .done_rot_2_cordic(done_rot_cordic_2),
    .done_vec_cordic(done_vec_cordic),
    .done_super_rot_1_cordic(done_super_rot_cordic_1),
    .done_super_rot_2_cordic(done_super_rot_cordic_2),
    .done_super_vec_cordic(done_super_vec_cordic),
///////////////////// Outputs ////////////////////////////////
    // --------------- R matrix --------------- //
    .R_11_r(R_11_r),
    .R_12_r(R_12_r),
    .R_12_i(R_12_i),
    .R_13_r(R_13_r),
    .R_13_i(R_13_i),
    .R_14_r(R_14_r),
    .R_14_i(R_14_i),
    .R_22_r(R_22_r),
    .R_23_r(R_23_r),
    .R_23_i(R_23_i),
    .R_24_r(R_24_r),
    .R_24_i(R_24_i),
    .R_33_r(R_33_r),
    .R_34_r(R_34_r),
    .R_34_i(R_34_i),
    .R_44_r(R_44_r),
    // --------------- Q matrix --------------- //
    .Q_11_r(Q_T_11_r),
    .Q_11_i(Q_T_11_i),
    .Q_12_r(Q_T_12_r),
    .Q_12_i(Q_T_12_i),
    .Q_13_r(Q_T_13_r),
    .Q_13_i(Q_T_13_i),
    .Q_14_r(Q_T_14_r),
    .Q_14_i(Q_T_14_i),
    .Q_21_r(Q_T_21_r),
    .Q_21_i(Q_T_21_i),
    .Q_22_r(Q_T_22_r),
    .Q_22_i(Q_T_22_i),
    .Q_23_r(Q_T_23_r),
    .Q_23_i(Q_T_23_i),
    .Q_24_r(Q_T_24_r),
    .Q_24_i(Q_T_24_i),
    .Q_31_r(Q_T_31_r),
    .Q_31_i(Q_T_31_i),
    .Q_32_r(Q_T_32_r),
    .Q_32_i(Q_T_32_i),
    .Q_33_r(Q_T_33_r),
    .Q_33_i(Q_T_33_i),
    .Q_34_r(Q_T_34_r),
    .Q_34_i(Q_T_34_i),
    .Q_41_r(Q_T_41_r),
    .Q_41_i(Q_T_41_i),
    .Q_42_r(Q_T_42_r),
    .Q_42_i(Q_T_42_i),
    .Q_43_r(Q_T_43_r),
    .Q_43_i(Q_T_43_i),
    .Q_44_r(Q_T_44_r),
    .Q_44_i(Q_T_44_i),
    // ----- rotational CORDIC Signals ----- //
    .Xo_rot_cordic_1(Xo_rot_cordic_1),
    .Xo_rot_cordic_2(Xo_rot_cordic_2),
    .Yo_rot_cordic_1(Yo_rot_cordic_1),
    .Yo_rot_cordic_2(Yo_rot_cordic_2),
    .Zo_rot_cordic_1(Zo_rot_cordic_1),
    .Zo_rot_cordic_2(Zo_rot_cordic_2),
    // ----- vectoring CORDIC Signals ----- //
    .input_1_vec_cordic(input_1_vec_cordic),
    .input_2_vec_cordic(input_2_vec_cordic),
    // -- Super vectoring CORDIC Signals -- //
    .input_1_super_vec_cordic(input_1_super_vec_cordic),
    .input_2_r_super_vec_cordic(input_2_r_super_vec_cordic),
    .input_2_i_super_vec_cordic(input_2_i_super_vec_cordic),
    // -- Super rotational CORDIC Signals -- //
    .x_r_super_rot_cordic_1(x_r_super_rot_cordic_1),
    .x_i_super_rot_cordic_1(x_i_super_rot_cordic_1),
    .y_r_super_rot_cordic_1(y_r_super_rot_cordic_1),
    .y_i_super_rot_cordic_1(y_i_super_rot_cordic_1),
    .phi_super_rot_cordic_1(phi_super_rot_cordic_1),
    .theta_super_rot_cordic_1(theta_super_rot_cordic_1),
    .x_r_super_rot_cordic_2(x_r_super_rot_cordic_2),
    .x_i_super_rot_cordic_2(x_i_super_rot_cordic_2),
    .y_r_super_rot_cordic_2(y_r_super_rot_cordic_2),
    .y_i_super_rot_cordic_2(y_i_super_rot_cordic_2),
    .phi_super_rot_cordic_2(phi_super_rot_cordic_2),
    .theta_super_rot_cordic_2(theta_super_rot_cordic_2),
    // -------- CORDIC Control Signals -------- //
    .enable_rot_cordic_1(enable_rot_cordic_1),
    .enable_rot_cordic_2(enable_rot_cordic_2),
    .enable_vec_cordic(enable_vec_cordic),
    .enable_super_rot_cordic_1(enable_super_rot_cordic_1),
    .enable_super_rot_cordic_2(enable_super_rot_cordic_2),
    .enable_super_vec_cordic(enable_super_vec_cordic),
    // --------------- Valid Signal --------------- //
    .Valid_R(Valid_R)
);
    



// --------------------------------------------------------- //
// --------------------- R inverse DUT  -------------------- //
// --------------------------------------------------------- //

R_inverse_Top #( 
	.INT_LENGTH(INT_LENGTH), 
	.FRAC_LENGTH(FRAC_LENGTH),
	.NUM_OF_ITERATIONS(NUM_OF_ITERATIONS)
) R_inverse_Top_DUT (
///////////////// Inputs //////////////////////////////////
  .CLK(CLK),
  .RST(RST),
  .Enable_reciprocal(Valid_R),
  // --------------------- Scaling Inputs  -------------------- //            
  .R_re_11({{SCALE_ROW_1{R_11_r[WORD_LENGTH-1]}}, R_11_r[WORD_LENGTH-1:SCALE_ROW_1]}),  
  .R_re_12({{SCALE_ROW_1{R_12_r[WORD_LENGTH-1]}}, R_12_r[WORD_LENGTH-1:SCALE_ROW_1]}),  
  .R_im_12({{SCALE_ROW_1{R_12_i[WORD_LENGTH-1]}}, R_12_i[WORD_LENGTH-1:SCALE_ROW_1]}),
  .R_re_13({{SCALE_ROW_1{R_13_r[WORD_LENGTH-1]}}, R_13_r[WORD_LENGTH-1:SCALE_ROW_1]}),  
  .R_im_13({{SCALE_ROW_1{R_13_i[WORD_LENGTH-1]}}, R_13_i[WORD_LENGTH-1:SCALE_ROW_1]}),
  .R_re_14({{SCALE_ROW_1{R_14_r[WORD_LENGTH-1]}}, R_14_r[WORD_LENGTH-1:SCALE_ROW_1]}),  
  .R_im_14({{SCALE_ROW_1{R_14_i[WORD_LENGTH-1]}}, R_14_i[WORD_LENGTH-1:SCALE_ROW_1]}),
  .R_re_22(R_22_r),    
  .R_re_23(R_23_r),  
  .R_im_23(R_23_i),
  .R_re_24(R_24_r),  
  .R_im_24(R_24_i),
  .R_re_33({R_33_r[WORD_LENGTH-SCALE_ROW_3-1:0], {SCALE_ROW_3{1'b0}}}),  
  .R_re_34({R_34_r[WORD_LENGTH-SCALE_ROW_3-1:0], {SCALE_ROW_3{1'b0}}}), 
  .R_im_34({R_34_i[WORD_LENGTH-SCALE_ROW_3-1:0], {SCALE_ROW_3{1'b0}}}),
  .R_re_44({R_44_r[WORD_LENGTH-SCALE_ROW_4-1:0], {SCALE_ROW_4{1'b0}}}),  
/////////////////// Outputs ////////////////////////////// 
  .R_inv_re_11(R_inv_11_r_scaled),  
  .R_inv_re_12(R_inv_12_r_scaled),  
  .R_inv_im_12(R_inv_12_i_scaled),
  .R_inv_re_13(R_inv_13_r_scaled),  
  .R_inv_im_13(R_inv_13_i_scaled),
  .R_inv_re_14(R_inv_14_r_scaled),  
  .R_inv_im_14(R_inv_14_i_scaled),
  .R_inv_re_22(R_inv_22_r_scaled),  
  .R_inv_re_23(R_inv_23_r_scaled),  
  .R_inv_im_23(R_inv_23_i_scaled),
  .R_inv_re_24(R_inv_24_r_scaled),   
  .R_inv_im_24(R_inv_24_i_scaled),
  .R_inv_re_33(R_inv_33_r_scaled), 
  .R_inv_re_34(R_inv_34_r_scaled), 
  .R_inv_im_34(R_inv_34_i_scaled),
  .R_inv_re_44(R_inv_44_r_scaled), 
  .R_inverse_done(valid_Q_T_Rinv)
);


// --------------------- de-Scaling Outputs  -------------------- //            
assign  R_inv_11_r  =  {{SCALE_ROW_1{R_inv_11_r_scaled[WORD_LENGTH-1]}}, R_inv_11_r_scaled[WORD_LENGTH-1:SCALE_ROW_1]};
assign  R_inv_12_r  =   R_inv_12_r_scaled;
assign  R_inv_12_i  =   R_inv_12_i_scaled;
assign  R_inv_13_r  =   {R_inv_13_r_scaled[WORD_LENGTH-SCALE_ROW_3-1:0], {SCALE_ROW_3{1'b0}}};
assign  R_inv_13_i  =   {R_inv_13_i_scaled[WORD_LENGTH-SCALE_ROW_3-1:0], {SCALE_ROW_3{1'b0}}};
assign  R_inv_23_r  =   {R_inv_23_r_scaled[WORD_LENGTH-SCALE_ROW_3-1:0], {SCALE_ROW_3{1'b0}}};
assign  R_inv_23_i  =   {R_inv_23_i_scaled[WORD_LENGTH-SCALE_ROW_3-1:0], {SCALE_ROW_3{1'b0}}};
assign  R_inv_33_r  =   {R_inv_33_r_scaled[WORD_LENGTH-SCALE_ROW_3-1:0], {SCALE_ROW_3{1'b0}}};
assign  R_inv_22_r  =   R_inv_22_r_scaled;
assign  R_inv_14_r  =   {R_inv_14_r_scaled[WORD_LENGTH-SCALE_ROW_4-1:0], {SCALE_ROW_4{1'b0}}};
assign  R_inv_14_i  =   {R_inv_14_i_scaled[WORD_LENGTH-SCALE_ROW_4-1:0], {SCALE_ROW_4{1'b0}}};
assign  R_inv_24_r  =   {R_inv_24_r_scaled[WORD_LENGTH-SCALE_ROW_4-1:0], {SCALE_ROW_4{1'b0}}};
assign  R_inv_24_i  =   {R_inv_24_i_scaled[WORD_LENGTH-SCALE_ROW_4-1:0], {SCALE_ROW_4{1'b0}}};
assign  R_inv_34_r  =   {R_inv_34_r_scaled[WORD_LENGTH-SCALE_ROW_4-1:0], {SCALE_ROW_4{1'b0}}};
assign  R_inv_34_i  =   {R_inv_34_i_scaled[WORD_LENGTH-SCALE_ROW_4-1:0], {SCALE_ROW_4{1'b0}}};
assign  R_inv_44_r  =   {R_inv_44_r_scaled[WORD_LENGTH-SCALE_ROW_4-1:0], {SCALE_ROW_4{1'b0}}};






















endmodule