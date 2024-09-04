/////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// Module ports list, declaration, and data type ///////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
module QR_decomposition #(
   	parameter 	WORD_LENGTH			=	18, 
	parameter	FRAC_LENGTH			=	11,
	parameter 	NUM_OF_ITERATIONS	=	11
)   (

///////////////////// Inputs /////////////////////////////////

    input   wire                           CLK,
    input   wire                           RST,
    input   wire                           Enable_QR,
    

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


    // ----- rotational CORDIC Signals ----- //
    input   wire signed [WORD_LENGTH-1:0]  XN_rot_cordic_1,
    input   wire signed [WORD_LENGTH-1:0]  XN_rot_cordic_2,
    input   wire signed [WORD_LENGTH-1:0]  YN_rot_cordic_1,
    input   wire signed [WORD_LENGTH-1:0]  YN_rot_cordic_2,

    // ----- vectoring CORDIC Signals ----- //
    input   wire  signed [WORD_LENGTH-1:0]  output_mag_vec_cordic,
    input   wire  signed [WORD_LENGTH-1:0]  output_angle_vec_cordic,
    
    // -- Super vectoring CORDIC Signals -- //
    input   wire  signed [WORD_LENGTH-1:0]  ouput_mag_super_vec_cordic,
    input   wire  signed [WORD_LENGTH-1:0]  output_angle_ceta_super_vec_cordic,
    input   wire  signed [WORD_LENGTH-1:0]  output_angle_phi_super_vec_cordic,
    
    // -- Super rotational CORDIC Signals -- //
    input   wire  signed [WORD_LENGTH-1:0]  x_out_r_super_rot_cordic_1,
    input   wire  signed [WORD_LENGTH-1:0]  x_out_i_super_rot_cordic_1,
    input   wire  signed [WORD_LENGTH-1:0]  y_out_r_super_rot_cordic_1,
    input   wire  signed [WORD_LENGTH-1:0]  y_out_i_super_rot_cordic_1,
    
    input   wire  signed [WORD_LENGTH-1:0]  x_out_r_super_rot_cordic_2,
    input   wire  signed [WORD_LENGTH-1:0]  x_out_i_super_rot_cordic_2,
    input   wire  signed [WORD_LENGTH-1:0]  y_out_r_super_rot_cordic_2,
    input   wire  signed [WORD_LENGTH-1:0]  y_out_i_super_rot_cordic_2,



    // -------- CORDIC Done Signals -------- //
    input   wire     done_rot_1_cordic,
    input   wire     done_rot_2_cordic,
    input   wire     done_vec_cordic,
    input   wire     done_super_rot_1_cordic,
    input   wire     done_super_rot_2_cordic,
    input   wire     done_super_vec_cordic,



///////////////////// Outputs ////////////////////////////////

    // --------------- R matrix --------------- //
    output   reg signed [WORD_LENGTH-1:0]  R_11_r,
    output   reg signed [WORD_LENGTH-1:0]  R_12_r,
    output   reg signed [WORD_LENGTH-1:0]  R_12_i,
    output   reg signed [WORD_LENGTH-1:0]  R_13_r,
    output   reg signed [WORD_LENGTH-1:0]  R_13_i,
    output   reg signed [WORD_LENGTH-1:0]  R_14_r,
    output   reg signed [WORD_LENGTH-1:0]  R_14_i,
    output   reg signed [WORD_LENGTH-1:0]  R_22_r,
    output   reg signed [WORD_LENGTH-1:0]  R_23_r,
    output   reg signed [WORD_LENGTH-1:0]  R_23_i,
    output   reg signed [WORD_LENGTH-1:0]  R_24_r,
    output   reg signed [WORD_LENGTH-1:0]  R_24_i,
    output   reg signed [WORD_LENGTH-1:0]  R_33_r,
    output   reg signed [WORD_LENGTH-1:0]  R_34_r,
    output   reg signed [WORD_LENGTH-1:0]  R_34_i,
    output   reg signed [WORD_LENGTH-1:0]  R_44_r,

    // --------------- Q matrix --------------- //
    output   reg signed [WORD_LENGTH-1:0]  Q_11_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_11_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_12_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_12_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_13_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_13_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_14_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_14_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_21_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_21_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_22_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_22_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_23_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_23_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_24_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_24_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_31_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_31_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_32_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_32_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_33_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_33_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_34_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_34_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_41_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_41_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_42_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_42_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_43_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_43_i,
    output   reg signed [WORD_LENGTH-1:0]  Q_44_r,
    output   reg signed [WORD_LENGTH-1:0]  Q_44_i,



    // ----- rotational CORDIC Signals ----- //
    output   reg signed [WORD_LENGTH-1:0]  Xo_rot_cordic_1,
    output   reg signed [WORD_LENGTH-1:0]  Xo_rot_cordic_2,
    output   reg signed [WORD_LENGTH-1:0]  Yo_rot_cordic_1,
    output   reg signed [WORD_LENGTH-1:0]  Yo_rot_cordic_2,
    output   reg signed [WORD_LENGTH-1:0]  Zo_rot_cordic_1,
    output   reg signed [WORD_LENGTH-1:0]  Zo_rot_cordic_2,
    
    // ----- vectoring CORDIC Signals ----- //
    output   reg signed [WORD_LENGTH-1:0]  input_1_vec_cordic,
    output   reg signed [WORD_LENGTH-1:0]  input_2_vec_cordic,
    
    // -- Super vectoring CORDIC Signals -- //
    output   reg signed [WORD_LENGTH-1:0]  input_1_super_vec_cordic,
    output   reg signed [WORD_LENGTH-1:0]  input_2_r_super_vec_cordic,
    output   reg signed [WORD_LENGTH-1:0]  input_2_i_super_vec_cordic,
    
    // -- Super rotational CORDIC Signals -- //
    output   reg signed [WORD_LENGTH-1:0]  x_r_super_rot_cordic_1,
    output   reg signed [WORD_LENGTH-1:0]  x_i_super_rot_cordic_1,
    output   reg signed [WORD_LENGTH-1:0]  y_r_super_rot_cordic_1,
    output   reg signed [WORD_LENGTH-1:0]  y_i_super_rot_cordic_1,
    output   reg signed [WORD_LENGTH-1:0]  phi_super_rot_cordic_1,
    output   reg signed [WORD_LENGTH-1:0]  theta_super_rot_cordic_1,
    
    output   reg signed [WORD_LENGTH-1:0]  x_r_super_rot_cordic_2,
    output   reg signed [WORD_LENGTH-1:0]  x_i_super_rot_cordic_2,
    output   reg signed [WORD_LENGTH-1:0]  y_r_super_rot_cordic_2,
    output   reg signed [WORD_LENGTH-1:0]  y_i_super_rot_cordic_2,
    output   reg signed [WORD_LENGTH-1:0]  phi_super_rot_cordic_2,
    output   reg signed [WORD_LENGTH-1:0]  theta_super_rot_cordic_2,
    

    // -------- CORDIC Control Signals -------- //
    output  reg     enable_rot_cordic_1,
    output  reg     enable_rot_cordic_2,
    output  reg     enable_vec_cordic,
    output  reg     enable_super_rot_cordic_1,
    output  reg     enable_super_rot_cordic_2,
    output  reg     enable_super_vec_cordic,
    

    // --------------- Valid Signals --------------- //
    output  reg                            Valid_R

);



//////////////////////////////////////////////////////////////
///////////////  Internal Storage Elements  //////////////////
//////////////////////////////////////////////////////////////


reg     [5:0]   Next_state,
                current_state;



// -- Internal R matrix storage elements -- //

// as this variables will be zero when we finish,so no need to output them :D
reg signed [WORD_LENGTH-1:0]  R_11_i;
reg signed [WORD_LENGTH-1:0]  R_22_i;
reg signed [WORD_LENGTH-1:0]  R_33_i;
reg signed [WORD_LENGTH-1:0]  R_44_i;
reg signed [WORD_LENGTH-1:0]  R_21_r;
reg signed [WORD_LENGTH-1:0]  R_21_i;
reg signed [WORD_LENGTH-1:0]  R_31_r;
reg signed [WORD_LENGTH-1:0]  R_31_i;
reg signed [WORD_LENGTH-1:0]  R_32_r;
reg signed [WORD_LENGTH-1:0]  R_32_i;
reg signed [WORD_LENGTH-1:0]  R_41_r;
reg signed [WORD_LENGTH-1:0]  R_41_i;
reg signed [WORD_LENGTH-1:0]  R_42_r;
reg signed [WORD_LENGTH-1:0]  R_42_i;
reg signed [WORD_LENGTH-1:0]  R_43_r;
reg signed [WORD_LENGTH-1:0]  R_43_i;
    


// -------- CORDIC Control Signals -------- //

//registers version
reg     enable_rot_cordic_1_reg;
reg     enable_rot_cordic_2_reg;
reg     enable_vec_cordic_reg;
reg     enable_super_rot_cordic_1_reg;
reg     enable_super_rot_cordic_2_reg;
reg     enable_super_vec_cordic_reg;

//combinational version
reg     enable_rot_cordic_1_comb;
reg     enable_rot_cordic_2_comb;
reg     enable_vec_cordic_comb;
reg     enable_super_rot_cordic_1_comb;
reg     enable_super_rot_cordic_2_comb;
reg     enable_super_vec_cordic_comb;






//////////////////////////////////////////////////////////////
////////////////////////  FSM States  ////////////////////////
//////////////////////////////////////////////////////////////

localparam      IDLE                =   'd0,      
                R_11_REAL_S1        =   'd1,
                R_11_REAL_S2        =   'd2,
                R_11_REAL_S3        =   'd3,
                Q_1_S1              =   'd4,
                Q_1_S2              =   'd5,
                R_21_NULL_S1        =   'd6,
                R_21_NULL_S2        =   'd7,
                R_21_NULL_S3        =   'd8,
                Q_2_S1              =   'd9,
                Q_2_S2              =   'd10,
                R_31_NULL_S1        =   'd11,
                R_31_NULL_S2        =   'd12,
                R_31_NULL_S3        =   'd13,
                Q_3_S1              =   'd14,
                Q_3_S2              =   'd15,
                R_41_NULL_S1        =   'd16,
                R_41_NULL_S2        =   'd17,
                R_41_NULL_S3        =   'd18,
                Q_4_S1              =   'd19,
                Q_4_S2              =   'd20,  
                R_22_REAL_S1        =   'd21,
                R_22_REAL_S2        =   'd22,
                Q_5_S1              =   'd23,
                Q_5_S2              =   'd24,
                R_32_NULL_S1        =   'd25,
                R_32_NULL_S2        =   'd26,
                Q_6_S1              =   'd27,
                Q_6_S2              =   'd28,
                R_42_NULL_S1        =   'd29,
                R_42_NULL_S2        =   'd30,
                Q_7_S1              =   'd31,
                Q_7_S2              =   'd32,
                R_33_REAL_S1        =   'd33,
                R_33_REAL_S2        =   'd34,
                Q_8_S1              =   'd35,
                Q_8_S2              =   'd36,
                R_43_NULL_S1        =   'd37,
                R_43_NULL_S2        =   'd38,
                Q_9_S1              =   'd39,
                Q_9_S2              =   'd40,
                R_44_REAL_S1        =   'd41,
                Q_10_S1             =   'd42,
                Q_10_S2             =   'd43,
                VALID_R             =   'd44;




//////////////////////////////////////////////////////////////
//////////////////////  Output Registers  ////////////////////
//////////////////////////////////////////////////////////////

always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		// reset
        R_11_r   <=  'b0;
        R_11_i   <=  'b0;
        R_12_r   <=  'b0;
        R_12_i   <=  'b0;
        R_13_r   <=  'b0;
        R_13_i   <=  'b0;
        R_14_r   <=  'b0;
        R_14_i   <=  'b0;
        R_21_r   <=  'b0;
        R_21_i   <=  'b0;
        R_22_r   <=  'b0;
        R_22_i   <=  'b0;
        R_23_r   <=  'b0;
        R_23_i   <=  'b0;
        R_24_r   <=  'b0;
        R_24_i   <=  'b0;
        R_31_r   <=  'b0;
        R_31_i   <=  'b0;
        R_32_r   <=  'b0;
        R_32_i   <=  'b0;
        R_33_r   <=  'b0;
        R_33_i   <=  'b0;
        R_34_r   <=  'b0;
        R_34_i   <=  'b0;
        R_41_r   <=  'b0;
        R_41_i   <=  'b0;
        R_42_r   <=  'b0;
        R_42_i   <=  'b0;
        R_43_r   <=  'b0;
        R_43_i   <=  'b0;
        R_44_r   <=  'b0;
        R_44_i   <=  'b0;

        Q_11_r   <=  'b0;
        Q_11_i   <=  'b0;
        Q_12_r   <=  'b0;
        Q_12_i   <=  'b0;
        Q_13_r   <=  'b0;
        Q_13_i   <=  'b0;
        Q_14_r   <=  'b0;
        Q_14_i   <=  'b0;
        Q_21_r   <=  'b0;
        Q_21_i   <=  'b0;
        Q_22_r   <=  'b0;
        Q_22_i   <=  'b0;
        Q_23_r   <=  'b0;
        Q_23_i   <=  'b0;
        Q_24_r   <=  'b0;
        Q_24_i   <=  'b0;
        Q_31_r   <=  'b0;
        Q_31_i   <=  'b0;
        Q_32_r   <=  'b0;
        Q_32_i   <=  'b0;
        Q_33_r   <=  'b0;
        Q_33_i   <=  'b0;
        Q_34_r   <=  'b0;
        Q_34_i   <=  'b0;
        Q_41_r   <=  'b0;
        Q_41_i   <=  'b0;
        Q_42_r   <=  'b0;
        Q_42_i   <=  'b0;
        Q_43_r   <=  'b0;
        Q_43_i   <=  'b0;
        Q_44_r   <=  'b0;
        Q_44_i   <=  'b0;
    
	end
	else if(Enable_QR) begin
        R_11_r   <=  A_11_r;
        R_11_i   <=  A_11_i;
        R_12_r   <=  A_12_r;
        R_12_i   <=  A_12_i;
        R_13_r   <=  A_13_r;
        R_13_i   <=  A_13_i;
        R_14_r   <=  A_14_r;
        R_14_i   <=  A_14_i;
        R_21_r   <=  A_21_r;
        R_21_i   <=  A_21_i;
        R_22_r   <=  A_22_r;
        R_22_i   <=  A_22_i;
        R_23_r   <=  A_23_r;
        R_23_i   <=  A_23_i;
        R_24_r   <=  A_24_r;
        R_24_i   <=  A_24_i;
        R_31_r   <=  A_31_r;
        R_31_i   <=  A_31_i;
        R_32_r   <=  A_32_r;
        R_32_i   <=  A_32_i;
        R_33_r   <=  A_33_r;
        R_33_i   <=  A_33_i;
        R_34_r   <=  A_34_r;
        R_34_i   <=  A_34_i;
        R_41_r   <=  A_41_r;
        R_41_i   <=  A_41_i;
        R_42_r   <=  A_42_r;
        R_42_i   <=  A_42_i;
        R_43_r   <=  A_43_r;
        R_43_i   <=  A_43_i;
        R_44_r   <=  A_44_r;
        R_44_i   <=  A_44_i;

        Q_11_r   <=  'b1<<FRAC_LENGTH; 
        Q_11_i   <=  'b0;
        Q_12_r   <=  'b0;
        Q_12_i   <=  'b0;
        Q_13_r   <=  'b0;
        Q_13_i   <=  'b0;
        Q_14_r   <=  'b0;
        Q_14_i   <=  'b0;
        Q_21_r   <=  'b0;
        Q_21_i   <=  'b0;
        Q_22_r   <=  'b1<<FRAC_LENGTH;
        Q_22_i   <=  'b0;
        Q_23_r   <=  'b0;
        Q_23_i   <=  'b0;
        Q_24_r   <=  'b0;
        Q_24_i   <=  'b0;
        Q_31_r   <=  'b0;
        Q_31_i   <=  'b0;
        Q_32_r   <=  'b0;
        Q_32_i   <=  'b0;
        Q_33_r   <=  'b1<<FRAC_LENGTH; 
        Q_33_i   <=  'b0;
        Q_34_r   <=  'b0;
        Q_34_i   <=  'b0;
        Q_41_r   <=  'b0;
        Q_41_i   <=  'b0;
        Q_42_r   <=  'b0;
        Q_42_i   <=  'b0;
        Q_43_r   <=  'b0;
        Q_43_i   <=  'b0;
        Q_44_r   <=  'b1<<FRAC_LENGTH; 
        Q_44_i   <=  'b0;
	end
    // updating R and Q matrices //
    else begin
        if(current_state == R_11_REAL_S1 && done_vec_cordic == 'b1)   begin
            R_11_r  <=  output_mag_vec_cordic;
            R_11_i  <=  'b0;
        end 
        else if(current_state == R_11_REAL_S2 && done_rot_1_cordic == 'b1 && done_rot_2_cordic == 'b1) begin
            R_12_r  <=  XN_rot_cordic_1;
            R_12_i  <=  YN_rot_cordic_1;
            R_13_r  <=  XN_rot_cordic_2;
            R_13_i  <=  YN_rot_cordic_2;
        end
        else if(current_state == R_11_REAL_S3 && done_rot_1_cordic == 'b1) begin
            R_14_r  <=  XN_rot_cordic_1;
            R_14_i  <=  YN_rot_cordic_1;
        end
        else if(current_state == Q_1_S1 && done_rot_1_cordic == 'b1 && done_rot_2_cordic == 'b1) begin
            Q_11_r  <=  XN_rot_cordic_1;
            Q_11_i  <=  YN_rot_cordic_1;
            Q_12_r  <=  XN_rot_cordic_2;
            Q_12_i  <=  YN_rot_cordic_2;
        end
        else if(current_state == Q_1_S2 && done_rot_1_cordic == 'b1 && done_rot_2_cordic == 'b1) begin
            Q_13_r  <=  XN_rot_cordic_1;
            Q_13_i  <=  YN_rot_cordic_1;
            Q_14_r  <=  XN_rot_cordic_2;
            Q_14_i  <=  YN_rot_cordic_2;
        end
        else if(current_state == R_21_NULL_S1 && done_super_vec_cordic == 'b1) begin
            R_11_r  <=  ouput_mag_super_vec_cordic;
            R_11_i  <=  'b0;
            R_21_r  <=  'b0;
            R_21_i  <=  'b0;
        end
        else if(current_state == R_21_NULL_S2 && done_super_rot_1_cordic == 'b1 && done_super_rot_2_cordic == 'b1) begin
            R_12_r  <=  x_out_r_super_rot_cordic_1;
            R_12_i  <=  x_out_i_super_rot_cordic_1;
            R_22_r  <=  y_out_r_super_rot_cordic_1;
            R_22_i  <=  y_out_i_super_rot_cordic_1;
            R_13_r  <=  x_out_r_super_rot_cordic_2;
            R_13_i  <=  x_out_i_super_rot_cordic_2;
            R_23_r  <=  y_out_r_super_rot_cordic_2;
            R_23_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == R_21_NULL_S3 && done_super_rot_1_cordic == 'b1) begin
            R_14_r  <=  x_out_r_super_rot_cordic_1;
            R_14_i  <=  x_out_i_super_rot_cordic_1;
            R_24_r  <=  y_out_r_super_rot_cordic_1;
            R_24_i  <=  y_out_i_super_rot_cordic_1;
        end
        else if(current_state == Q_2_S1 && done_super_rot_1_cordic && done_super_rot_2_cordic) begin
            Q_11_r  <=  x_out_r_super_rot_cordic_1;
            Q_11_i  <=  x_out_i_super_rot_cordic_1;
            Q_21_r  <=  y_out_r_super_rot_cordic_1;
            Q_21_i  <=  y_out_i_super_rot_cordic_1;
            Q_12_r  <=  x_out_r_super_rot_cordic_2;
            Q_12_i  <=  x_out_i_super_rot_cordic_2;
            Q_22_r  <=  y_out_r_super_rot_cordic_2;
            Q_22_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == Q_2_S2 && done_super_rot_1_cordic && done_super_rot_2_cordic) begin
            Q_13_r  <=  x_out_r_super_rot_cordic_1;
            Q_13_i  <=  x_out_i_super_rot_cordic_1;
            Q_23_r  <=  y_out_r_super_rot_cordic_1;
            Q_23_i  <=  y_out_i_super_rot_cordic_1;
            Q_14_r  <=  x_out_r_super_rot_cordic_2;
            Q_14_i  <=  x_out_i_super_rot_cordic_2;
            Q_24_r  <=  y_out_r_super_rot_cordic_2;
            Q_24_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == R_31_NULL_S1 && done_super_vec_cordic == 'b1) begin
            R_11_r  <=  ouput_mag_super_vec_cordic;
            R_11_i  <=  'b0;
            R_31_r  <=  'b0;
            R_31_i  <=  'b0;
        end
        else if(current_state == R_31_NULL_S2 && done_super_rot_1_cordic == 'b1 && done_super_rot_2_cordic == 'b1) begin
            R_13_r  <=  x_out_r_super_rot_cordic_1;
            R_13_i  <=  x_out_i_super_rot_cordic_1;
            R_33_r  <=  y_out_r_super_rot_cordic_1;
            R_33_i  <=  y_out_i_super_rot_cordic_1;
            R_12_r  <=  x_out_r_super_rot_cordic_2;
            R_12_i  <=  x_out_i_super_rot_cordic_2;
            R_32_r  <=  y_out_r_super_rot_cordic_2;
            R_32_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == R_31_NULL_S3 && done_super_rot_1_cordic == 'b1) begin
            R_14_r  <=  x_out_r_super_rot_cordic_1;
            R_14_i  <=  x_out_i_super_rot_cordic_1;
            R_34_r  <=  y_out_r_super_rot_cordic_1;
            R_34_i  <=  y_out_i_super_rot_cordic_1;
        end
        else if(current_state == Q_3_S1 && done_super_rot_1_cordic && done_super_rot_2_cordic) begin
            Q_11_r  <=  x_out_r_super_rot_cordic_1;
            Q_11_i  <=  x_out_i_super_rot_cordic_1;
            Q_31_r  <=  y_out_r_super_rot_cordic_1;
            Q_31_i  <=  y_out_i_super_rot_cordic_1;
            Q_12_r  <=  x_out_r_super_rot_cordic_2;
            Q_12_i  <=  x_out_i_super_rot_cordic_2;
            Q_32_r  <=  y_out_r_super_rot_cordic_2;
            Q_32_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == Q_3_S2 && done_super_rot_1_cordic && done_super_rot_2_cordic) begin
            Q_13_r  <=  x_out_r_super_rot_cordic_1;
            Q_13_i  <=  x_out_i_super_rot_cordic_1;
            Q_33_r  <=  y_out_r_super_rot_cordic_1;
            Q_33_i  <=  y_out_i_super_rot_cordic_1;
            Q_14_r  <=  x_out_r_super_rot_cordic_2;
            Q_14_i  <=  x_out_i_super_rot_cordic_2;
            Q_34_r  <=  y_out_r_super_rot_cordic_2;
            Q_34_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == R_41_NULL_S1 && done_super_vec_cordic == 'b1) begin
            R_11_r  <=  ouput_mag_super_vec_cordic;
            R_11_i  <=  'b0;
            R_41_r  <=  'b0;
            R_41_i  <=  'b0;
        end
        else if(current_state == R_41_NULL_S2 && done_super_rot_1_cordic == 'b1 && done_super_rot_2_cordic == 'b1) begin
            R_14_r  <=  x_out_r_super_rot_cordic_1;
            R_14_i  <=  x_out_i_super_rot_cordic_1;
            R_44_r  <=  y_out_r_super_rot_cordic_1;
            R_44_i  <=  y_out_i_super_rot_cordic_1;
            R_12_r  <=  x_out_r_super_rot_cordic_2;
            R_12_i  <=  x_out_i_super_rot_cordic_2;
            R_42_r  <=  y_out_r_super_rot_cordic_2;
            R_42_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == R_41_NULL_S3 && done_super_rot_1_cordic == 'b1) begin
            R_13_r  <=  x_out_r_super_rot_cordic_1;
            R_13_i  <=  x_out_i_super_rot_cordic_1;
            R_43_r  <=  y_out_r_super_rot_cordic_1;
            R_43_i  <=  y_out_i_super_rot_cordic_1;
        end
        else if(current_state == Q_4_S1 && done_super_rot_1_cordic && done_super_rot_2_cordic) begin
            Q_11_r  <=  x_out_r_super_rot_cordic_1;
            Q_11_i  <=  x_out_i_super_rot_cordic_1;
            Q_41_r  <=  y_out_r_super_rot_cordic_1;
            Q_41_i  <=  y_out_i_super_rot_cordic_1;
            Q_12_r  <=  x_out_r_super_rot_cordic_2;
            Q_12_i  <=  x_out_i_super_rot_cordic_2;
            Q_42_r  <=  y_out_r_super_rot_cordic_2;
            Q_42_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == Q_4_S2 && done_super_rot_1_cordic && done_super_rot_2_cordic) begin
            Q_13_r  <=  x_out_r_super_rot_cordic_1;
            Q_13_i  <=  x_out_i_super_rot_cordic_1;
            Q_43_r  <=  y_out_r_super_rot_cordic_1;
            Q_43_i  <=  y_out_i_super_rot_cordic_1;
            Q_14_r  <=  x_out_r_super_rot_cordic_2;
            Q_14_i  <=  x_out_i_super_rot_cordic_2;
            Q_44_r  <=  y_out_r_super_rot_cordic_2;
            Q_44_i  <=  y_out_i_super_rot_cordic_2;
        end
        if(current_state == R_22_REAL_S1 && done_vec_cordic == 'b1)   begin
            R_22_r  <=  output_mag_vec_cordic;
            R_22_i  <=  'b0;
        end 
        else if(current_state == R_22_REAL_S2 && done_rot_1_cordic == 'b1 && done_rot_2_cordic == 'b1) begin
            R_23_r  <=  XN_rot_cordic_1;
            R_23_i  <=  YN_rot_cordic_1;
            R_24_r  <=  XN_rot_cordic_2;
            R_24_i  <=  YN_rot_cordic_2;
        end
        else if(current_state == Q_5_S1 && done_rot_1_cordic == 'b1 && done_rot_2_cordic == 'b1) begin
            Q_21_r  <=  XN_rot_cordic_1;
            Q_21_i  <=  YN_rot_cordic_1;
            Q_22_r  <=  XN_rot_cordic_2;
            Q_22_i  <=  YN_rot_cordic_2;
        end
        else if(current_state == Q_5_S2 && done_rot_1_cordic == 'b1 && done_rot_2_cordic == 'b1) begin
            Q_23_r  <=  XN_rot_cordic_1;
            Q_23_i  <=  YN_rot_cordic_1;
            Q_24_r  <=  XN_rot_cordic_2;
            Q_24_i  <=  YN_rot_cordic_2;
        end
        else if(current_state == R_32_NULL_S1 && done_super_vec_cordic == 'b1) begin
            R_22_r  <=  ouput_mag_super_vec_cordic;
            R_22_i  <=  'b0;
            R_32_r  <=  'b0;
            R_32_i  <=  'b0;
        end
        else if(current_state == R_32_NULL_S2 && done_super_rot_1_cordic == 'b1 && done_super_rot_2_cordic == 'b1) begin
            R_23_r  <=  x_out_r_super_rot_cordic_1;
            R_23_i  <=  x_out_i_super_rot_cordic_1;
            R_33_r  <=  y_out_r_super_rot_cordic_1;
            R_33_i  <=  y_out_i_super_rot_cordic_1;
            R_24_r  <=  x_out_r_super_rot_cordic_2;
            R_24_i  <=  x_out_i_super_rot_cordic_2;
            R_34_r  <=  y_out_r_super_rot_cordic_2;
            R_34_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == Q_6_S1 && done_super_rot_1_cordic && done_super_rot_2_cordic) begin
            Q_21_r  <=  x_out_r_super_rot_cordic_1;
            Q_21_i  <=  x_out_i_super_rot_cordic_1;
            Q_31_r  <=  y_out_r_super_rot_cordic_1;
            Q_31_i  <=  y_out_i_super_rot_cordic_1;
            Q_22_r  <=  x_out_r_super_rot_cordic_2;
            Q_22_i  <=  x_out_i_super_rot_cordic_2;
            Q_32_r  <=  y_out_r_super_rot_cordic_2;
            Q_32_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == Q_6_S2 && done_super_rot_1_cordic && done_super_rot_2_cordic) begin
            Q_23_r  <=  x_out_r_super_rot_cordic_1;
            Q_23_i  <=  x_out_i_super_rot_cordic_1;
            Q_33_r  <=  y_out_r_super_rot_cordic_1;
            Q_33_i  <=  y_out_i_super_rot_cordic_1;
            Q_24_r  <=  x_out_r_super_rot_cordic_2;
            Q_24_i  <=  x_out_i_super_rot_cordic_2;
            Q_34_r  <=  y_out_r_super_rot_cordic_2;
            Q_34_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == R_42_NULL_S1 && done_super_vec_cordic == 'b1) begin
            R_22_r  <=  ouput_mag_super_vec_cordic;
            R_22_i  <=  'b0;
            R_42_r  <=  'b0;
            R_42_i  <=  'b0;
        end
        else if(current_state == R_42_NULL_S2 && done_super_rot_1_cordic == 'b1 && done_super_rot_2_cordic == 'b1) begin
            R_24_r  <=  x_out_r_super_rot_cordic_1;
            R_24_i  <=  x_out_i_super_rot_cordic_1;
            R_44_r  <=  y_out_r_super_rot_cordic_1;
            R_44_i  <=  y_out_i_super_rot_cordic_1;
            R_23_r  <=  x_out_r_super_rot_cordic_2;
            R_23_i  <=  x_out_i_super_rot_cordic_2;
            R_43_r  <=  y_out_r_super_rot_cordic_2;
            R_43_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == Q_7_S1 && done_super_rot_1_cordic && done_super_rot_2_cordic) begin
            Q_21_r  <=  x_out_r_super_rot_cordic_1;
            Q_21_i  <=  x_out_i_super_rot_cordic_1;
            Q_41_r  <=  y_out_r_super_rot_cordic_1;
            Q_41_i  <=  y_out_i_super_rot_cordic_1;
            Q_22_r  <=  x_out_r_super_rot_cordic_2;
            Q_22_i  <=  x_out_i_super_rot_cordic_2;
            Q_42_r  <=  y_out_r_super_rot_cordic_2;
            Q_42_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == Q_7_S2 && done_super_rot_1_cordic && done_super_rot_2_cordic) begin
            Q_23_r  <=  x_out_r_super_rot_cordic_1;
            Q_23_i  <=  x_out_i_super_rot_cordic_1;
            Q_43_r  <=  y_out_r_super_rot_cordic_1;
            Q_43_i  <=  y_out_i_super_rot_cordic_1;
            Q_24_r  <=  x_out_r_super_rot_cordic_2;
            Q_24_i  <=  x_out_i_super_rot_cordic_2;
            Q_44_r  <=  y_out_r_super_rot_cordic_2;
            Q_44_i  <=  y_out_i_super_rot_cordic_2;
        end
        if(current_state == R_33_REAL_S1 && done_vec_cordic == 'b1)   begin
            R_33_r  <=  output_mag_vec_cordic;
            R_33_i  <=  'b0;
        end 
        else if(current_state == R_33_REAL_S2 && done_rot_1_cordic == 'b1) begin
            R_34_r  <=  XN_rot_cordic_1;
            R_34_i  <=  YN_rot_cordic_1;
        end
        else if(current_state == Q_8_S1 && done_rot_1_cordic == 'b1 && done_rot_2_cordic == 'b1) begin
            Q_31_r  <=  XN_rot_cordic_1;
            Q_31_i  <=  YN_rot_cordic_1;
            Q_32_r  <=  XN_rot_cordic_2;
            Q_32_i  <=  YN_rot_cordic_2;
        end
        else if(current_state == Q_8_S2 && done_rot_1_cordic == 'b1 && done_rot_2_cordic == 'b1) begin
            Q_33_r  <=  XN_rot_cordic_1;
            Q_33_i  <=  YN_rot_cordic_1;
            Q_34_r  <=  XN_rot_cordic_2;
            Q_34_i  <=  YN_rot_cordic_2;
        end
        else if(current_state == R_43_NULL_S1 && done_super_vec_cordic == 'b1) begin
            R_33_r  <=  ouput_mag_super_vec_cordic;
            R_33_i  <=  'b0;
            R_43_r  <=  'b0;
            R_43_i  <=  'b0;
        end
        else if(current_state == R_43_NULL_S2 && done_super_rot_1_cordic == 'b1) begin
            R_34_r  <=  x_out_r_super_rot_cordic_1;
            R_34_i  <=  x_out_i_super_rot_cordic_1;
            R_44_r  <=  y_out_r_super_rot_cordic_1;
            R_44_i  <=  y_out_i_super_rot_cordic_1;
        end
        else if(current_state == Q_9_S1 && done_super_rot_1_cordic && done_super_rot_2_cordic) begin
            Q_31_r  <=  x_out_r_super_rot_cordic_1;
            Q_31_i  <=  x_out_i_super_rot_cordic_1;
            Q_41_r  <=  y_out_r_super_rot_cordic_1;
            Q_41_i  <=  y_out_i_super_rot_cordic_1;
            Q_32_r  <=  x_out_r_super_rot_cordic_2;
            Q_32_i  <=  x_out_i_super_rot_cordic_2;
            Q_42_r  <=  y_out_r_super_rot_cordic_2;
            Q_42_i  <=  y_out_i_super_rot_cordic_2;
        end
        else if(current_state == Q_9_S2 && done_super_rot_1_cordic && done_super_rot_2_cordic) begin
            Q_33_r  <=  x_out_r_super_rot_cordic_1;
            Q_33_i  <=  x_out_i_super_rot_cordic_1;
            Q_43_r  <=  y_out_r_super_rot_cordic_1;
            Q_43_i  <=  y_out_i_super_rot_cordic_1;
            Q_34_r  <=  x_out_r_super_rot_cordic_2;
            Q_34_i  <=  x_out_i_super_rot_cordic_2;
            Q_44_r  <=  y_out_r_super_rot_cordic_2;
            Q_44_i  <=  y_out_i_super_rot_cordic_2;
        end
        if(current_state == R_44_REAL_S1 && done_vec_cordic == 'b1)   begin
            R_44_r  <=  output_mag_vec_cordic;
            R_44_i  <=  'b0;
        end 
        else if(current_state == Q_10_S1 && done_rot_1_cordic == 'b1 && done_rot_2_cordic == 'b1) begin
            Q_41_r  <=  XN_rot_cordic_1;
            Q_41_i  <=  YN_rot_cordic_1;
            Q_42_r  <=  XN_rot_cordic_2;
            Q_42_i  <=  YN_rot_cordic_2;
        end
        else if(current_state == Q_10_S2 && done_rot_1_cordic == 'b1 && done_rot_2_cordic == 'b1) begin
            Q_43_r  <=  XN_rot_cordic_1;
            Q_43_i  <=  YN_rot_cordic_1;
            Q_44_r  <=  XN_rot_cordic_2;
            Q_44_i  <=  YN_rot_cordic_2;
        end


    end


end







//////////////////////////////////////////////////////////////
/////////////////////  State Transition  /////////////////////
//////////////////////////////////////////////////////////////

always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		// reset
		 current_state   	<= 	IDLE;
	end
	else begin
		 current_state   	<= 	Next_state;
	end
end






//////////////////////////////////////////////////////////////
////////////////////// Next State Logic  /////////////////////
//////////////////////////////////////////////////////////////

always@(*)	begin
	

	case(current_state) 
		
		IDLE	:	begin
			if(Enable_QR) begin
                Next_state  =  R_11_REAL_S1;
            end
            else begin
                Next_state  =  IDLE;
            end
		end

        R_11_REAL_S1    :   begin
            // if vectroing Cordic finished , we go to next state
            if(done_vec_cordic == 'b1) begin
                Next_state  =  R_11_REAL_S2; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_11_REAL_S1; 
            end
        end
        
        R_11_REAL_S2    :   begin
            // if 1st 2 Rotational Cordics finished , we go to next state
            if(done_rot_1_cordic == 'b1 && done_rot_2_cordic == 'b1) begin
                Next_state  =  R_11_REAL_S3; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_11_REAL_S2; 
            end
        end

        R_11_REAL_S3    :   begin
            // if 3rd Rotational Cordic finished , we go to next state
            if(done_rot_1_cordic == 'b1) begin
                Next_state  =  Q_1_S1; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_11_REAL_S3; 
            end
        end
        
        Q_1_S1  :   begin
        
            if(done_rot_1_cordic && done_rot_2_cordic ) begin
			    Next_state  =   Q_1_S2;
		    end
		    else begin
			    Next_state  = Q_1_S1;
			end
        end

        Q_1_S2  :   begin
            if(done_rot_1_cordic && done_rot_2_cordic ) begin
			    Next_state  =   R_21_NULL_S1;
		    end
		    else begin
			    Next_state  = Q_1_S2;
			end
        end

        R_21_NULL_S1    :   begin
            // if Super_Vectoring Cordic finished , we go to next state
            if(done_super_vec_cordic == 'b1) begin
                Next_state  =  R_21_NULL_S2; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_21_NULL_S1; 
            end
        end

        R_21_NULL_S2    :   begin
            // if 1st 2 Super_Rotational Cordic finished , we go to next state
            if(done_super_rot_1_cordic == 'b1 && done_super_rot_2_cordic == 'b1) begin
                Next_state  =  R_21_NULL_S3; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_21_NULL_S2; 
            end
        end

        R_21_NULL_S3    :   begin
            // if 3rd Super_Rotational Cordic finished , we go to next state
            if(done_super_rot_1_cordic == 'b1 ) begin
                Next_state  =  Q_2_S1; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_21_NULL_S3; 
            end
        end

        Q_2_S1  :   begin
            if(done_super_rot_1_cordic && done_super_rot_2_cordic ) begin
			    Next_state  =   Q_2_S2;
		    end
		    else begin
			    Next_state  = Q_2_S1;
			end
        end

        Q_2_S2  :   begin
            if(done_super_rot_1_cordic && done_super_rot_2_cordic ) begin
			    Next_state  =   R_31_NULL_S1;
		    end
		    else begin
			    Next_state  = Q_2_S2;
			end
        end

        R_31_NULL_S1    :   begin
            // if Super_Vectoring Cordic finished , we go to next state
            if(done_super_vec_cordic == 'b1) begin
                Next_state  =  R_31_NULL_S2; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_31_NULL_S1; 
            end
        end

        R_31_NULL_S2    :   begin
            // if 1st 2 Super_Rotational Cordic finished , we go to next state
            if(done_super_rot_1_cordic == 'b1 && done_super_rot_2_cordic == 'b1) begin
                Next_state  =  R_31_NULL_S3; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_31_NULL_S2; 
            end
        end

        R_31_NULL_S3    :   begin
            // if 3rd Super_Rotational Cordic finished , we go to next state
            if(done_super_rot_1_cordic == 'b1 ) begin
                Next_state  =  Q_3_S1; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_31_NULL_S3; 
            end
        end

        Q_3_S1  :   begin
            if(done_super_rot_1_cordic && done_super_rot_2_cordic ) begin
			    Next_state  =   Q_3_S2;
		    end
		    else begin
			    Next_state  = Q_3_S1;
			end
        end

        Q_3_S2  :   begin
            if(done_super_rot_1_cordic && done_super_rot_2_cordic ) begin
			    Next_state  =   R_41_NULL_S1;
		    end
		    else begin
			    Next_state  = Q_3_S2;
			end
        end

        R_41_NULL_S1    :   begin
            // if Super_Vectoring Cordic finished , we go to next state
            if(done_super_vec_cordic == 'b1) begin
                Next_state  =  R_41_NULL_S2; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_41_NULL_S1; 
            end
        end

        R_41_NULL_S2    :   begin
            // if 1st 2 Super_Rotational Cordic finished , we go to next state
            if(done_super_rot_1_cordic == 'b1 && done_super_rot_2_cordic == 'b1) begin
                Next_state  =  R_41_NULL_S3; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_41_NULL_S2; 
            end
        end

        R_41_NULL_S3    :   begin
            // if 3rd Super_Rotational Cordic finished , we go to next state
            if(done_super_rot_1_cordic == 'b1 ) begin
                Next_state  =  Q_4_S1; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_41_NULL_S3; 
            end
        end

        Q_4_S1  :   begin
            if(done_super_rot_1_cordic && done_super_rot_2_cordic ) begin
			    Next_state  =   Q_4_S2;
		    end
		    else begin
			    Next_state  = Q_4_S1;
			end
        end

        Q_4_S2  :   begin
            if(done_super_rot_1_cordic && done_super_rot_2_cordic ) begin
			    Next_state  =   R_22_REAL_S1;
		    end
		    else begin
			    Next_state  = Q_4_S2;
			end
        end

        R_22_REAL_S1    :   begin
            // if vectroing Cordic finished , we go to next state
            if(done_vec_cordic == 'b1) begin
                Next_state  =  R_22_REAL_S2; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_22_REAL_S1; 
            end
        end
        
        R_22_REAL_S2    :   begin
            // if 2 Rotational Cordics finished , we go to next state
            if(done_rot_1_cordic == 'b1 && done_rot_2_cordic == 'b1) begin
                Next_state  =  Q_5_S1; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_22_REAL_S2; 
            end
        end

        Q_5_S1  :   begin
            if(done_rot_1_cordic && done_rot_2_cordic ) begin
			    Next_state  =   Q_5_S2;
		    end
		    else begin
			    Next_state  = Q_5_S1;
			end
        end

        Q_5_S2  :   begin
            if(done_rot_1_cordic && done_rot_2_cordic ) begin
			    Next_state  =   R_32_NULL_S1;
		    end
		    else begin
			    Next_state  = Q_5_S2;
			end
        end

        R_32_NULL_S1    :   begin
            // if Super_Vectoring Cordic finished , we go to next state
            if(done_super_vec_cordic == 'b1) begin
                Next_state  =  R_32_NULL_S2; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_32_NULL_S1; 
            end
        end

        R_32_NULL_S2    :   begin
            // if 2 Super_Rotational Cordic finished , we go to next state
            if(done_super_rot_1_cordic == 'b1 && done_super_rot_2_cordic == 'b1) begin
                Next_state  =  Q_6_S1; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_32_NULL_S2; 
            end
        end
        
        Q_6_S1  :   begin
            if(done_super_rot_1_cordic && done_super_rot_2_cordic ) begin
			    Next_state  =   Q_6_S2;
		    end
		    else begin
			    Next_state  = Q_6_S1;
			end 
        end

        Q_6_S2  :   begin
            if(done_super_rot_1_cordic && done_super_rot_2_cordic ) begin
			    Next_state  =   R_42_NULL_S1;
		    end
		    else begin
			    Next_state  = Q_6_S2;
			end 
        end

        R_42_NULL_S1    :   begin
            // if Super_Vectoring Cordic finished , we go to next state
            if(done_super_vec_cordic == 'b1) begin
                Next_state  =  R_42_NULL_S2; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_42_NULL_S1; 
            end
        end

        R_42_NULL_S2    :   begin
            // if 2 Super_Rotational Cordic finished , we go to next state
            if(done_super_rot_1_cordic == 'b1 && done_super_rot_2_cordic == 'b1) begin
                Next_state  =  Q_7_S1; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_42_NULL_S2; 
            end
        end
      
        Q_7_S1  :   begin
            if(done_super_rot_1_cordic && done_super_rot_2_cordic ) begin
			    Next_state  =   Q_7_S2;
		    end
		    else begin
			    Next_state  = Q_7_S1;
			end 
        end

        Q_7_S2  :   begin
           if(done_super_rot_1_cordic && done_super_rot_2_cordic ) begin
			    Next_state  =   R_33_REAL_S1;
		    end
		    else begin
			    Next_state  = Q_7_S2;
			end  
        end

        R_33_REAL_S1    :   begin
            // if vectroing Cordic finished , we go to next state
            if(done_vec_cordic == 'b1) begin
                Next_state  =  R_33_REAL_S2; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_33_REAL_S1; 
            end
        end
        
        R_33_REAL_S2    :   begin
            // if Rotational Cordics finished , we go to next state
            if(done_rot_1_cordic == 'b1) begin
                Next_state  =  Q_8_S1; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_33_REAL_S2; 
            end
        end

        Q_8_S1  :   begin
            if(done_rot_1_cordic && done_rot_2_cordic ) begin
			    Next_state  =   Q_8_S2;
		    end
		    else begin
			    Next_state  = Q_8_S1;
			end
        end

        Q_8_S2  :   begin
            if(done_rot_1_cordic && done_rot_2_cordic ) begin
			    Next_state  =   R_43_NULL_S1;
		    end
		    else begin
			    Next_state  = Q_8_S2;
			end 
        end

        R_43_NULL_S1    :   begin
            // if Super_Vectoring Cordic finished , we go to next state
            if(done_super_vec_cordic == 'b1) begin
                Next_state  =  R_43_NULL_S2; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_43_NULL_S1; 
            end
        end

        R_43_NULL_S2    :   begin
            // if Super_Rotational Cordic finished , we go to next state
            if(done_super_rot_1_cordic == 'b1) begin
                Next_state  =  Q_9_S1; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_43_NULL_S2; 
            end
        end

        Q_9_S1  :   begin
            if(done_super_rot_1_cordic && done_super_rot_2_cordic ) begin
			    Next_state  =   Q_9_S2;
		    end
		    else begin
			    Next_state  = Q_9_S1;
			end 
        end

        Q_9_S2  :   begin
            if(done_super_rot_1_cordic && done_super_rot_2_cordic ) begin
			    Next_state  =   R_44_REAL_S1;
		    end
		    else begin
			    Next_state  = Q_9_S2;
			end 
        end
        
        R_44_REAL_S1    :   begin
             // if vectroing Cordic finished , we go to next state
            if(done_vec_cordic == 'b1) begin
                Next_state  =  VALID_R; 
            end
            // otherwise , we stay in same state
            else begin
                Next_state  =  R_44_REAL_S1; 
            end
        end
        
        VALID_R :    begin
            Next_state  =   Q_10_S1;
        end        
        
        Q_10_S1  :   begin
            if(done_rot_1_cordic && done_rot_2_cordic ) begin
			    Next_state  =   Q_10_S2;
		    end
		    else begin
			    Next_state  = Q_10_S1;
			end 
        end

        Q_10_S2  :   begin
            if(done_rot_1_cordic && done_rot_2_cordic ) begin
			    Next_state  =   IDLE;
		    end
		    else begin
			    Next_state  = Q_10_S2;
			end 
        end

		default 	:	begin
			Next_state  =   IDLE;
		end

	endcase

end




//////////////////////////////////////////////////////////////
///////////////// Output State Controls Logic  ///////////////
//////////////////////////////////////////////////////////////



always@(*)	begin

//////////// Reset All Signals ////////////
Xo_rot_cordic_1                   =  'b0;
Xo_rot_cordic_2                   =  'b0;
Yo_rot_cordic_1                   =  'b0;
Yo_rot_cordic_2                   =  'b0;
Zo_rot_cordic_1                   =  'b0;
Zo_rot_cordic_2                   =  'b0;
input_1_vec_cordic                =  'b0;
input_2_vec_cordic                =  'b0;
input_1_super_vec_cordic          =  'b0;
input_2_r_super_vec_cordic        =  'b0;
input_2_i_super_vec_cordic        =  'b0;
x_r_super_rot_cordic_1            =  'b0;
x_i_super_rot_cordic_1            =  'b0;
y_r_super_rot_cordic_1            =  'b0;
y_i_super_rot_cordic_1            =  'b0;
phi_super_rot_cordic_1            =  'b0;
theta_super_rot_cordic_1          =  'b0;    
x_r_super_rot_cordic_2            =  'b0;
x_i_super_rot_cordic_2            =  'b0;
y_r_super_rot_cordic_2            =  'b0;
y_i_super_rot_cordic_2            =  'b0;
phi_super_rot_cordic_2            =  'b0;
theta_super_rot_cordic_2          =  'b0;
enable_rot_cordic_1_comb          =  'b0;
enable_rot_cordic_2_comb          =  'b0;
enable_vec_cordic_comb            =  'b0;
enable_super_rot_cordic_1_comb    =  'b0;
enable_super_rot_cordic_2_comb    =  'b0;
enable_super_vec_cordic_comb      =  'b0;
Valid_R                           =  'b0;


//////////// Assigning Output Signals ////////////

	case(current_state) 
		
		IDLE	:	begin
			Xo_rot_cordic_1                   =  'b0;
            Xo_rot_cordic_2                   =  'b0;
            Yo_rot_cordic_1                   =  'b0;
            Yo_rot_cordic_2                   =  'b0;
            Zo_rot_cordic_1                   =  'b0;
            Zo_rot_cordic_2                   =  'b0;
            input_1_vec_cordic                =  'b0;
            input_2_vec_cordic                =  'b0;
            input_1_super_vec_cordic          =  'b0;
            input_2_r_super_vec_cordic        =  'b0;
            input_2_i_super_vec_cordic        =  'b0;
            x_r_super_rot_cordic_1            =  'b0;
            x_i_super_rot_cordic_1            =  'b0;
            y_r_super_rot_cordic_1            =  'b0;
            y_i_super_rot_cordic_1            =  'b0;
            phi_super_rot_cordic_1            =  'b0;
            theta_super_rot_cordic_1          =  'b0;    
            x_r_super_rot_cordic_2            =  'b0;
            x_i_super_rot_cordic_2            =  'b0; 
            y_r_super_rot_cordic_2            =  'b0;
            y_i_super_rot_cordic_2            =  'b0;
            phi_super_rot_cordic_2            =  'b0;
            theta_super_rot_cordic_2          =  'b0;
            enable_rot_cordic_1_comb          =  'b0;
            enable_rot_cordic_2_comb          =  'b0;
            enable_vec_cordic_comb            =  'b0;
            enable_super_rot_cordic_1_comb    =  'b0;
            enable_super_rot_cordic_2_comb    =  'b0;
            enable_super_vec_cordic_comb      =  'b0;
            Valid_R                           =  'b0;
		end

        R_11_REAL_S1    :   begin

            // enable vectoring Cordic
            enable_vec_cordic_comb       =  'b1;
            // assign vectoring cordic inputs
            input_1_vec_cordic           =  R_11_r;
            input_2_vec_cordic           =  R_11_i;

        end

        R_11_REAL_S2    :   begin

            //enable 1st 2 rotational Cordics
            if(Next_state   != R_11_REAL_S3) begin
                enable_rot_cordic_1_comb     =  'b1;
                enable_rot_cordic_2_comb     =  'b1;
            end
            // assign 1st rotational cordic inputs
            Xo_rot_cordic_1              =  R_12_r;
            Yo_rot_cordic_1              =  R_12_i;
            Zo_rot_cordic_1              =  -output_angle_vec_cordic;
            // assign 2nd rotational cordic inputs
            Xo_rot_cordic_2              =  R_13_r;
            Yo_rot_cordic_2              =  R_13_i  ;
            Zo_rot_cordic_2              =  -output_angle_vec_cordic;

        end

        R_11_REAL_S3    :   begin

            //enable 3rd rotational Cordic
            if(Next_state   != Q_1_S1) begin
                enable_rot_cordic_1_comb     =  'b1;
            end
            // assign 3rd rotational cordic inputs
            Xo_rot_cordic_1              =  R_14_r;
            Yo_rot_cordic_1              =  R_14_i;
            Zo_rot_cordic_1              =  -output_angle_vec_cordic;

        end

        Q_1_S1  :   begin
            
            //enable 1st 2 rotational Cordics
            if(Next_state   != Q_1_S2) begin
                enable_rot_cordic_1_comb     =  'b1;
                enable_rot_cordic_2_comb     =  'b1;
            end
            // assign 1st rotational cordic inputs
            Xo_rot_cordic_1              =  Q_11_r;
            Yo_rot_cordic_1              =  Q_11_i;
            Zo_rot_cordic_1              =  -output_angle_vec_cordic;
            // assign 2nd rotational cordic inputs
            Xo_rot_cordic_2              =  Q_12_r;
            Yo_rot_cordic_2              =  Q_12_i  ;
            Zo_rot_cordic_2              =  -output_angle_vec_cordic;

        end

        Q_1_S2  :   begin
            
            //enable 2nd 2 rotational Cordics
            enable_rot_cordic_1_comb     =  'b1;
            enable_rot_cordic_2_comb     =  'b1;
            // assign 3rd rotational cordic inputs
            Xo_rot_cordic_1              =  Q_13_r;
            Yo_rot_cordic_1              =  Q_13_i;
            Zo_rot_cordic_1              =  -output_angle_vec_cordic;
            // assign 4th rotational cordic inputs
            Xo_rot_cordic_2              =  Q_14_r;
            Yo_rot_cordic_2              =  Q_14_i  ;
            Zo_rot_cordic_2              =  -output_angle_vec_cordic;

        end

        R_21_NULL_S1    :   begin
        
            // enable Super_vectoring Cordic
            enable_super_vec_cordic_comb =  'b1;
            // assign Super_vectoring Cordic inputs
            input_1_super_vec_cordic     =  R_11_r;
            input_2_r_super_vec_cordic   =  R_21_r;
            input_2_i_super_vec_cordic   =  R_21_i;

        end

        R_21_NULL_S2    :   begin
            
            //enable 1st 2 Super_rotational Cordics
            if(Next_state   != R_21_NULL_S3) begin
                enable_super_rot_cordic_1_comb     =  'b1;
                enable_super_rot_cordic_2_comb     =  'b1;
            end
            // assign 1st Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  R_12_r;
            x_i_super_rot_cordic_1       =  R_12_i;
            y_r_super_rot_cordic_1       =  R_22_r;
            y_i_super_rot_cordic_1       =  R_22_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 2nd Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  R_13_r;
            x_i_super_rot_cordic_2       =  R_13_i;
            y_r_super_rot_cordic_2       =  R_23_r;
            y_i_super_rot_cordic_2       =  R_23_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;     
        
        end

        R_21_NULL_S3    :   begin
            
            //enable 3rd Super_rotational Cordics
            if(Next_state   != Q_2_S1) begin
                enable_super_rot_cordic_1_comb     =  'b1;
            end
            // assign 3rd Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  R_14_r;
            x_i_super_rot_cordic_1       =  R_14_i;
            y_r_super_rot_cordic_1       =  R_24_r;
            y_i_super_rot_cordic_1       =  R_24_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;   
        
        end

        Q_2_S1  :   begin
           
            //enable 1st 2 Super_rotational Cordics
            if(Next_state   != Q_2_S2) begin
                enable_super_rot_cordic_1_comb     =  'b1;
                enable_super_rot_cordic_2_comb     =  'b1;
            end
            // assign 1st Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  Q_11_r;
            x_i_super_rot_cordic_1       =  Q_11_i;
            y_r_super_rot_cordic_1       =  Q_21_r;
            y_i_super_rot_cordic_1       =  Q_21_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 2nd Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  Q_12_r;
            x_i_super_rot_cordic_2       =  Q_12_i;
            y_r_super_rot_cordic_2       =  Q_22_r;
            y_i_super_rot_cordic_2       =  Q_22_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;  

        end

        Q_2_S2  :   begin
            
            //enable 2nd 2 Super_rotational Cordics
            enable_super_rot_cordic_1_comb     =  'b1;
            enable_super_rot_cordic_2_comb     =  'b1;
            // assign 3rd Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  Q_13_r;
            x_i_super_rot_cordic_1       =  Q_13_i;
            y_r_super_rot_cordic_1       =  Q_23_r;
            y_i_super_rot_cordic_1       =  Q_23_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 4th Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  Q_14_r;
            x_i_super_rot_cordic_2       =  Q_14_i;
            y_r_super_rot_cordic_2       =  Q_24_r;
            y_i_super_rot_cordic_2       =  Q_24_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;  

        end

        R_31_NULL_S1    :   begin
        
            // enable Super_vectoring Cordic
            enable_super_vec_cordic_comb       =  'b1;
            // assign Super_vectoring Cordic inputs
            input_1_super_vec_cordic     =  R_11_r;
            input_2_r_super_vec_cordic   =  R_31_r;
            input_2_i_super_vec_cordic   =  R_31_i;

        end

        R_31_NULL_S2    :   begin
            
            //enable 1st 2 Super_rotational Cordics
            if(Next_state   != R_31_NULL_S3) begin
                enable_super_rot_cordic_1_comb     =  'b1;
                enable_super_rot_cordic_2_comb     =  'b1;
            end
            // assign 1st Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  R_13_r;
            x_i_super_rot_cordic_1       =  R_13_i;
            y_r_super_rot_cordic_1       =  R_33_r;
            y_i_super_rot_cordic_1       =  R_33_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 2nd Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  R_12_r;
            x_i_super_rot_cordic_2       =  R_12_i;
            y_r_super_rot_cordic_2       =  R_32_r;
            y_i_super_rot_cordic_2       =  R_32_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;     
        
        end

        R_31_NULL_S3    :   begin
            
            //enable 3rd Super_rotational Cordics
            if(Next_state   != Q_3_S1) begin
                enable_super_rot_cordic_1_comb     =  'b1;
            end
            // assign 3rd Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  R_14_r;
            x_i_super_rot_cordic_1       =  R_14_i;
            y_r_super_rot_cordic_1       =  R_34_r;
            y_i_super_rot_cordic_1       =  R_34_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;   
        
        end

        Q_3_S1  :   begin
            
            //enable 1st 2 Super_rotational Cordics
            if(Next_state   != Q_3_S2) begin
                enable_super_rot_cordic_1_comb     =  'b1;
                enable_super_rot_cordic_2_comb     =  'b1;
            end
            // assign 1st Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  Q_11_r;
            x_i_super_rot_cordic_1       =  Q_11_i;
            y_r_super_rot_cordic_1       =  Q_31_r;
            y_i_super_rot_cordic_1       =  Q_31_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 2nd Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  Q_12_r;
            x_i_super_rot_cordic_2       =  Q_12_i;
            y_r_super_rot_cordic_2       =  Q_32_r;
            y_i_super_rot_cordic_2       =  Q_32_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;  

        end

        Q_3_S2  :   begin
            
            //enable 2nd 2 Super_rotational Cordics
            enable_super_rot_cordic_1_comb     =  'b1;
            enable_super_rot_cordic_2_comb     =  'b1;
            // assign 3rd Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  Q_13_r;
            x_i_super_rot_cordic_1       =  Q_13_i;
            y_r_super_rot_cordic_1       =  Q_33_r;
            y_i_super_rot_cordic_1       =  Q_33_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 4th Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  Q_14_r;
            x_i_super_rot_cordic_2       =  Q_14_i;
            y_r_super_rot_cordic_2       =  Q_34_r;
            y_i_super_rot_cordic_2       =  Q_34_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;  

        end

        R_41_NULL_S1    :   begin
        
            // enable Super_vectoring Cordic
            enable_super_vec_cordic_comb       =  'b1;
            // assign Super_vectoring Cordic inputs
            input_1_super_vec_cordic     =  R_11_r;
            input_2_r_super_vec_cordic   =  R_41_r;
            input_2_i_super_vec_cordic   =  R_41_i;

        end

        R_41_NULL_S2    :   begin
            
            //enable 1st 2 Super_rotational Cordics
            if(Next_state   != R_41_NULL_S3) begin
                enable_super_rot_cordic_1_comb     =  'b1;
                enable_super_rot_cordic_2_comb     =  'b1;
            end
            // assign 1st Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  R_14_r;
            x_i_super_rot_cordic_1       =  R_14_i;
            y_r_super_rot_cordic_1       =  R_44_r;
            y_i_super_rot_cordic_1       =  R_44_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 2nd Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  R_12_r;
            x_i_super_rot_cordic_2       =  R_12_i;
            y_r_super_rot_cordic_2       =  R_42_r;
            y_i_super_rot_cordic_2       =  R_42_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;     
        
        end

        R_41_NULL_S3    :   begin
            
            //enable 3rd Super_rotational Cordics
            if(Next_state   != Q_4_S1) begin
                enable_super_rot_cordic_1_comb     =  'b1;
            end
            // assign 3rd Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  R_13_r;
            x_i_super_rot_cordic_1       =  R_13_i;
            y_r_super_rot_cordic_1       =  R_43_r;
            y_i_super_rot_cordic_1       =  R_43_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;   
        
        end

        Q_4_S1  :   begin
                  
            //enable 1st 2 Super_rotational Cordics
            if(Next_state   != Q_4_S2) begin
                enable_super_rot_cordic_1_comb     =  'b1;
                enable_super_rot_cordic_2_comb     =  'b1;
            end
            // assign 1st Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  Q_11_r;
            x_i_super_rot_cordic_1       =  Q_11_i;
            y_r_super_rot_cordic_1       =  Q_41_r;
            y_i_super_rot_cordic_1       =  Q_41_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 2nd Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  Q_12_r;
            x_i_super_rot_cordic_2       =  Q_12_i;
            y_r_super_rot_cordic_2       =  Q_42_r;
            y_i_super_rot_cordic_2       =  Q_42_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;  

        end

        Q_4_S2  :   begin
                
            //enable 2nd 2 Super_rotational Cordics
            enable_super_rot_cordic_1_comb     =  'b1;
            enable_super_rot_cordic_2_comb     =  'b1;
            // assign 3rd Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  Q_13_r;
            x_i_super_rot_cordic_1       =  Q_13_i;
            y_r_super_rot_cordic_1       =  Q_43_r;
            y_i_super_rot_cordic_1       =  Q_43_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 4th Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  Q_14_r;
            x_i_super_rot_cordic_2       =  Q_14_i;
            y_r_super_rot_cordic_2       =  Q_44_r;
            y_i_super_rot_cordic_2       =  Q_44_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;  

        end

        R_22_REAL_S1    :   begin

            // enable vectoring Cordic
            enable_vec_cordic_comb             =  'b1;
            // assign vectoring cordic inputs
            input_1_vec_cordic           =  R_22_r;
            input_2_vec_cordic           =  R_22_i;

        end

        R_22_REAL_S2    :   begin

            //enable 2 rotational Cordics
            if(Next_state   != Q_5_S1) begin
                enable_rot_cordic_1_comb           =  'b1;
                enable_rot_cordic_2_comb           =  'b1;
            end
            // assign 1st rotational cordic inputs
            Xo_rot_cordic_1              =  R_23_r;
            Yo_rot_cordic_1              =  R_23_i;
            Zo_rot_cordic_1              =  -output_angle_vec_cordic;
            // assign 2nd rotational cordic inputs
            Xo_rot_cordic_2              =  R_24_r;
            Yo_rot_cordic_2              =  R_24_i  ;
            Zo_rot_cordic_2              =  -output_angle_vec_cordic;

        end

        Q_5_S1  :   begin
            
            //enable 1st 2 rotational Cordics
            if(Next_state   != Q_5_S2) begin
                enable_rot_cordic_1_comb           =  'b1;
                enable_rot_cordic_2_comb           =  'b1;
            end
            // assign 1st rotational cordic inputs
            Xo_rot_cordic_1              =  Q_21_r;
            Yo_rot_cordic_1              =  Q_21_i;
            Zo_rot_cordic_1              =  -output_angle_vec_cordic;
            // assign 2nd rotational cordic inputs
            Xo_rot_cordic_2              =  Q_22_r;
            Yo_rot_cordic_2              =  Q_22_i  ;
            Zo_rot_cordic_2              =  -output_angle_vec_cordic;

        end

        Q_5_S2  :   begin
            
            //enable 2nd 2 rotational Cordics
            enable_rot_cordic_1_comb           =  'b1;
            enable_rot_cordic_2_comb           =  'b1;
            // assign 3rd rotational cordic inputs
            Xo_rot_cordic_1              =  Q_23_r;
            Yo_rot_cordic_1              =  Q_23_i;
            Zo_rot_cordic_1              =  -output_angle_vec_cordic;
            // assign 4th rotational cordic inputs
            Xo_rot_cordic_2              =  Q_24_r;
            Yo_rot_cordic_2              =  Q_24_i  ;
            Zo_rot_cordic_2              =  -output_angle_vec_cordic;

        end

        R_32_NULL_S1    :   begin
        
            // enable Super_vectoring Cordic
            enable_super_vec_cordic_comb       =  'b1;
            // assign Super_vectoring Cordic inputs
            input_1_super_vec_cordic     =  R_22_r;
            input_2_r_super_vec_cordic   =  R_32_r;
            input_2_i_super_vec_cordic   =  R_32_i;

        end

        R_32_NULL_S2    :   begin
            
            //enable 2 Super_rotational Cordics
            if(Next_state   != Q_6_S1) begin
                enable_super_rot_cordic_1_comb     =  'b1;
                enable_super_rot_cordic_2_comb     =  'b1;
            end
            // assign 1st Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  R_23_r;
            x_i_super_rot_cordic_1       =  R_23_i;
            y_r_super_rot_cordic_1       =  R_33_r;
            y_i_super_rot_cordic_1       =  R_33_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 2nd Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  R_24_r;
            x_i_super_rot_cordic_2       =  R_24_i;
            y_r_super_rot_cordic_2       =  R_34_r;
            y_i_super_rot_cordic_2       =  R_34_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;     
        
        end
      
        Q_6_S1  :   begin
            
            //enable 1st 2 Super_rotational Cordics
            if(Next_state   != Q_6_S2) begin
                enable_super_rot_cordic_1_comb     =  'b1;
                enable_super_rot_cordic_2_comb     =  'b1;
            end
            // assign 1st Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  Q_21_r;
            x_i_super_rot_cordic_1       =  Q_21_i;
            y_r_super_rot_cordic_1       =  Q_31_r;
            y_i_super_rot_cordic_1       =  Q_31_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 2nd Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  Q_22_r;
            x_i_super_rot_cordic_2       =  Q_22_i;
            y_r_super_rot_cordic_2       =  Q_32_r;
            y_i_super_rot_cordic_2       =  Q_32_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;  

        end

        Q_6_S2  :   begin
            
            //enable 2nd 2 Super_rotational Cordics
            enable_super_rot_cordic_1_comb     =  'b1;
            enable_super_rot_cordic_2_comb     =  'b1;
            // assign 3rd Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  Q_23_r;
            x_i_super_rot_cordic_1       =  Q_23_i;
            y_r_super_rot_cordic_1       =  Q_33_r;
            y_i_super_rot_cordic_1       =  Q_33_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 4th Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  Q_24_r;
            x_i_super_rot_cordic_2       =  Q_24_i;
            y_r_super_rot_cordic_2       =  Q_34_r;
            y_i_super_rot_cordic_2       =  Q_34_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;  

        end

        R_42_NULL_S1    :   begin
        
            // enable Super_vectoring Cordic
            enable_super_vec_cordic_comb       =  'b1;
            // assign Super_vectoring Cordic inputs
            input_1_super_vec_cordic     =  R_22_r;
            input_2_r_super_vec_cordic   =  R_42_r;
            input_2_i_super_vec_cordic   =  R_42_i;

        end

        R_42_NULL_S2    :   begin
            
            //enable 2 Super_rotational Cordics
            if(Next_state   != Q_7_S1) begin
                enable_super_rot_cordic_1_comb     =  'b1;
                enable_super_rot_cordic_2_comb     =  'b1;
            end
            // assign 1st Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  R_24_r;
            x_i_super_rot_cordic_1       =  R_24_i;
            y_r_super_rot_cordic_1       =  R_44_r;
            y_i_super_rot_cordic_1       =  R_44_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 2nd Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  R_23_r;
            x_i_super_rot_cordic_2       =  R_23_i;
            y_r_super_rot_cordic_2       =  R_43_r;
            y_i_super_rot_cordic_2       =  R_43_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;     
        
        end

        Q_7_S1  :   begin
            
            //enable 1st 2 Super_rotational Cordics
            if(Next_state   != Q_7_S2) begin
                enable_super_rot_cordic_1_comb     =  'b1;
                enable_super_rot_cordic_2_comb     =  'b1;
            end
            // assign 1st Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  Q_21_r;
            x_i_super_rot_cordic_1       =  Q_21_i;
            y_r_super_rot_cordic_1       =  Q_41_r;
            y_i_super_rot_cordic_1       =  Q_41_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 2nd Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  Q_22_r;
            x_i_super_rot_cordic_2       =  Q_22_i;
            y_r_super_rot_cordic_2       =  Q_42_r;
            y_i_super_rot_cordic_2       =  Q_42_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic; 

        end

        Q_7_S2  :   begin

            //enable 2nd 2 Super_rotational Cordics
            enable_super_rot_cordic_1_comb     =  'b1;
            enable_super_rot_cordic_2_comb     =  'b1;
            // assign 3rd Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  Q_23_r;
            x_i_super_rot_cordic_1       =  Q_23_i;
            y_r_super_rot_cordic_1       =  Q_43_r;
            y_i_super_rot_cordic_1       =  Q_43_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 4th Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  Q_24_r;
            x_i_super_rot_cordic_2       =  Q_24_i;
            y_r_super_rot_cordic_2       =  Q_44_r;
            y_i_super_rot_cordic_2       =  Q_44_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;  
        
        end

        R_33_REAL_S1    :   begin

            // enable vectoring Cordic
            enable_vec_cordic_comb             =  'b1;
            // assign vectoring cordic inputs
            input_1_vec_cordic           =  R_33_r;
            input_2_vec_cordic           =  R_33_i;

        end

        R_33_REAL_S2    :   begin

            //enable rotational Cordic
            if(Next_state   != Q_8_S1) begin
                enable_rot_cordic_1_comb           =  'b1;
            end
            // assign rotational cordic inputs
            Xo_rot_cordic_1              =  R_34_r;
            Yo_rot_cordic_1              =  R_34_i;
            Zo_rot_cordic_1              =  -output_angle_vec_cordic;
          
        end
       
        Q_8_S1  :   begin
            
            //enable 1st 2 rotational Cordics
            if(Next_state   != Q_8_S2) begin
                enable_rot_cordic_1_comb           =  'b1;
                enable_rot_cordic_2_comb           =  'b1;
            end
            // assign 1st rotational cordic inputs
            Xo_rot_cordic_1              =  Q_31_r;
            Yo_rot_cordic_1              =  Q_31_i;
            Zo_rot_cordic_1              =  -output_angle_vec_cordic;
            // assign 2nd rotational cordic inputs
            Xo_rot_cordic_2              =  Q_32_r;
            Yo_rot_cordic_2              =  Q_32_i  ;
            Zo_rot_cordic_2              =  -output_angle_vec_cordic;

        end

        Q_8_S2  :   begin
                    
            //enable 2nd 2 rotational Cordics
            enable_rot_cordic_1_comb           =  'b1;
            enable_rot_cordic_2_comb           =  'b1;
            // assign 3rd rotational cordic inputs
            Xo_rot_cordic_1              =  Q_33_r;
            Yo_rot_cordic_1              =  Q_33_i;
            Zo_rot_cordic_1              =  -output_angle_vec_cordic;
            // assign 4th rotational cordic inputs
            Xo_rot_cordic_2              =  Q_34_r;
            Yo_rot_cordic_2              =  Q_34_i  ;
            Zo_rot_cordic_2              =  -output_angle_vec_cordic;

        end

        R_43_NULL_S1    :   begin
        
            // enable Super_vectoring Cordic
            enable_super_vec_cordic_comb       =  'b1;
            // assign Super_vectoring Cordic inputs
            input_1_super_vec_cordic     =  R_33_r;
            input_2_r_super_vec_cordic   =  R_43_r;
            input_2_i_super_vec_cordic   =  R_43_i;

        end

        R_43_NULL_S2    :   begin
            
            //enable Super_rotational Cordic
            if(Next_state   != Q_9_S1) begin
                enable_super_rot_cordic_1_comb     =  'b1;
            end
            // assign Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  R_34_r;
            x_i_super_rot_cordic_1       =  R_34_i;
            y_r_super_rot_cordic_1       =  R_44_r;
            y_i_super_rot_cordic_1       =  R_44_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            
        end

        Q_9_S1  :   begin
            //enable 1st 2 Super_rotational Cordics
            if(Next_state   != Q_9_S2) begin
                enable_super_rot_cordic_1_comb     =  'b1;
                enable_super_rot_cordic_2_comb     =  'b1;
            end
            // assign 1st Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  Q_31_r;
            x_i_super_rot_cordic_1       =  Q_31_i;
            y_r_super_rot_cordic_1       =  Q_41_r;
            y_i_super_rot_cordic_1       =  Q_41_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 2nd Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  Q_32_r;
            x_i_super_rot_cordic_2       =  Q_32_i;
            y_r_super_rot_cordic_2       =  Q_42_r;
            y_i_super_rot_cordic_2       =  Q_42_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic; 

        end

        Q_9_S2  :   begin
            //enable 2nd 2 Super_rotational Cordics
            enable_super_rot_cordic_1_comb     =  'b1;
            enable_super_rot_cordic_2_comb     =  'b1;
            // assign 3rd Super_rotational cordic inputs
            x_r_super_rot_cordic_1       =  Q_33_r;
            x_i_super_rot_cordic_1       =  Q_33_i;
            y_r_super_rot_cordic_1       =  Q_43_r;
            y_i_super_rot_cordic_1       =  Q_43_i;
            phi_super_rot_cordic_1       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_1     =  -output_angle_ceta_super_vec_cordic;    
            // assign 4th Super_rotational cordic inputs
            x_r_super_rot_cordic_2       =  Q_34_r;
            x_i_super_rot_cordic_2       =  Q_34_i;
            y_r_super_rot_cordic_2       =  Q_44_r;
            y_i_super_rot_cordic_2       =  Q_44_i;
            phi_super_rot_cordic_2       =  -output_angle_phi_super_vec_cordic;
            theta_super_rot_cordic_2     =  -output_angle_ceta_super_vec_cordic;  
        
        end

        R_44_REAL_S1    :   begin
            // enable vectoring Cordic
            enable_vec_cordic_comb             =  'b1;
            // assign vectoring cordic inputs
            input_1_vec_cordic           =  R_44_r;
            input_2_vec_cordic           =  R_44_i;
        end
        
        VALID_R  :   begin
            Valid_R    =   'b1;
        end

        Q_10_S1  :   begin
            //enable 1st 2 rotational Cordics
            if(Next_state   != Q_10_S2) begin
                enable_rot_cordic_1_comb           =  'b1;
                enable_rot_cordic_2_comb           =  'b1;
            end
            // assign 1st rotational cordic inputs
            Xo_rot_cordic_1              =  Q_41_r;
            Yo_rot_cordic_1              =  Q_41_i;
            Zo_rot_cordic_1              =  -output_angle_vec_cordic;
            // assign 2nd rotational cordic inputs
            Xo_rot_cordic_2              =  Q_42_r;
            Yo_rot_cordic_2              =  Q_42_i  ;
            Zo_rot_cordic_2              =  -output_angle_vec_cordic;

        end

        Q_10_S2  :   begin
            //enable 2nd 2 rotational Cordics
            enable_rot_cordic_1_comb           =  'b1;
            enable_rot_cordic_2_comb           =  'b1;
            // assign 3rd rotational cordic inputs
            Xo_rot_cordic_1              =  Q_43_r;
            Yo_rot_cordic_1              =  Q_43_i;
            Zo_rot_cordic_1              =  -output_angle_vec_cordic;
            // assign 4th rotational cordic inputs
            Xo_rot_cordic_2              =  Q_44_r;
            Yo_rot_cordic_2              =  Q_44_i  ;
            Zo_rot_cordic_2              =  -output_angle_vec_cordic;

        end
		
        default 	:	begin
			Xo_rot_cordic_1                   =  'b0;
            Xo_rot_cordic_2                   =  'b0;
            Yo_rot_cordic_1                   =  'b0;
            Yo_rot_cordic_2                   =  'b0;
            Zo_rot_cordic_1                   =  'b0;
            Zo_rot_cordic_2                   =  'b0;
            input_1_vec_cordic                =  'b0;
            input_2_vec_cordic                =  'b0;
            input_1_super_vec_cordic          =  'b0;
            input_2_r_super_vec_cordic        =  'b0;
            input_2_i_super_vec_cordic        =  'b0;
            x_r_super_rot_cordic_1            =  'b0;
            x_i_super_rot_cordic_1            =  'b0;
            y_r_super_rot_cordic_1            =  'b0;
            y_i_super_rot_cordic_1            =  'b0;
            phi_super_rot_cordic_1            =  'b0;
            theta_super_rot_cordic_1          =  'b0;    
            x_r_super_rot_cordic_2            =  'b0;
            x_i_super_rot_cordic_2            =  'b0; 
            y_r_super_rot_cordic_2            =  'b0;
            y_i_super_rot_cordic_2            =  'b0;
            phi_super_rot_cordic_2            =  'b0;
            theta_super_rot_cordic_2          =  'b0;
            enable_rot_cordic_1_comb          =  'b0;
            enable_rot_cordic_2_comb          =  'b0;
            enable_vec_cordic_comb            =  'b0;
            enable_super_rot_cordic_1_comb    =  'b0;
            enable_super_rot_cordic_2_comb    =  'b0;
            enable_super_vec_cordic_comb      =  'b0;
            Valid_R                           =  'b0;
		end

	endcase

end



//////////////////////////////////////////////////////////////
///////////  Pulse Generator for Enable Signals  /////////////
//////////////////////////////////////////////////////////////

// registering enable_comb signals
always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		// reset
		enable_rot_cordic_1_reg   	        <= 	'b0;
        enable_rot_cordic_2_reg   	        <= 	'b0;
		enable_vec_cordic_reg   	        <= 	'b0;
		enable_super_rot_cordic_1_reg   	<= 	'b0;
		enable_super_rot_cordic_2_reg   	<= 	'b0;
		enable_super_vec_cordic_reg   	    <= 	'b0;
	end
	else begin
        enable_rot_cordic_1_reg   	        <= 	enable_rot_cordic_1_comb;
        enable_rot_cordic_2_reg   	        <= 	enable_rot_cordic_2_comb;
		enable_vec_cordic_reg   	        <= 	enable_vec_cordic_comb;
		enable_super_rot_cordic_1_reg   	<= 	enable_super_rot_cordic_1_comb;
		enable_super_rot_cordic_2_reg   	<= 	enable_super_rot_cordic_2_comb;
		enable_super_vec_cordic_reg   	    <= 	enable_super_vec_cordic_comb;	
    end
end





// generating pulse
always @(*) begin
    enable_rot_cordic_1           =   enable_rot_cordic_1_comb & (~enable_rot_cordic_1_reg);
    enable_rot_cordic_2           =   enable_rot_cordic_2_comb & (~enable_rot_cordic_2_reg);
    enable_vec_cordic             =   enable_vec_cordic_comb & (~enable_vec_cordic_reg);
    enable_super_rot_cordic_1     =   enable_super_rot_cordic_1_comb & (~enable_super_rot_cordic_1_reg);
    enable_super_rot_cordic_2     =   enable_super_rot_cordic_2_comb & (~enable_super_rot_cordic_2_reg);
    enable_super_vec_cordic       =   enable_super_vec_cordic_comb & (~enable_super_vec_cordic_reg);
end








endmodule