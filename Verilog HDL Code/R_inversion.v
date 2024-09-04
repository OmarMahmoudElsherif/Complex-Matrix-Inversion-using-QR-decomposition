module R_inversion #( 
  parameter   INT_LENGTH        = 7, 
  parameter   FRAC_LENGTH       = 11,
  parameter   NUM_OF_ITERATIONS = 11
)  (

///////////////// Inputs //////////////////////////////////
  input                                              CLK,
  input                                              RST,
  input                                              Enable_recp,
  input                                              Enable_register_R12,
  input                                              Enable_register_R13,
  input                                              Enable_register_Rinv22_44,
  input                                              sel3,sel5,sel7,
  input          [1:0]                               sel1,sel2,sel4,
  input          [2:0]                               sel6,
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_re_11, // real only 
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_re_12,  
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_re_13,  
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_re_14,  
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_re_22,  // real only  
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_re_23,  
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_re_24,  
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_re_33,  // real only
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_re_34, 
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_re_44,  // real only
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_im_12,  
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_im_13,  
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_im_14,   
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_im_23,  
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_im_24,  
  input wire  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_im_34,
  /////////////////// Outputs ////////////////////////////// 
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_11, // real only 
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_12,  
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_13,  
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_14,  
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_22,  // real only
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_23,  
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_24,   
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_33, // real only
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_34, 
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_44,  // real only
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_im_12,  
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_im_13,  
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_im_14,  
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_im_23,  
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_im_24,  
  output reg  signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_im_34,
  output wire                                        valid_recp
);



//////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// Parameters /////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
localparam WORD_LENGTH = INT_LENGTH + FRAC_LENGTH ;
localparam No_of_diagonal_elements = 4;
localparam RECP_SCALE = 5;
localparam No_of_non_zero_R_elements = 16 ;  // 4 real diagonal elements + 6 real , 6 imag of non zero off diagonal elements



/////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
The Design will be based on reuse of hardware.
The inputs of the R input matrix will be stored in a memory and take from it as input to certain
multiplier according to certain flag .
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Signals and Internal Connections /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

// Wires of : R_inv_12 , R_inv_23 , R_inv_34
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinvii_mul_Rinvjj_long; // real
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinvii_jj_mul_Rij_real_long;
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinvii_jj_mul_Rij_img_long;

reg    signed       [WORD_LENGTH-1 : 0]         Rinvii_jj_mul_Rij_real_short_reg;
reg    signed       [WORD_LENGTH-1 : 0]         Rinvii_jj_mul_Rij_img_short_reg;

wire    signed      [WORD_LENGTH-1 : 0]         Rinvii_mul_Rinvjj_short; // real
wire    signed      [WORD_LENGTH-1 : 0]         Rinvii_jj_mul_Rij_real_short;
wire    signed      [WORD_LENGTH-1 : 0]         Rinvii_jj_mul_Rij_img_short;
reg    signed       [WORD_LENGTH-1 : 0]         Rinvii_mul_Rinvjj_short_reg;

// Outputs of a mux to choose from either R_inv_11,R_inv22,R_inv_33
wire    signed      [WORD_LENGTH-1 : 0]         R_inv_ii;
wire    signed      [WORD_LENGTH-1 : 0]         R_inv_jj;
 
reg    signed       [WORD_LENGTH-1 : 0]         R_inv_ii_reg;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv_jj_reg;

// Outputs of a mux to choose from either R12,R23,R34 (real & img)
wire    signed      [WORD_LENGTH-1 : 0]         R_ij_real;
wire    signed      [WORD_LENGTH-1 : 0]         R_ij_img ;

// Register them
reg    signed       [WORD_LENGTH-1 : 0]         R_ij_real_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         R_ij_img_reg ;


// Wires of : R_inv_13
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv11_mul_any_long;
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv11_33_mul_any_long;
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv11_23_r_mul_any_long;
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv11_23_i_mul_any_long;
 
wire    signed      [WORD_LENGTH-1 : 0]         Rinv11_mul_any_short;
wire    signed      [WORD_LENGTH-1 : 0]         Rinv11_33_mul_any_short;
wire    signed      [WORD_LENGTH-1 : 0]         Rinv11_23_r_mul_any_short;
wire    signed      [WORD_LENGTH-1 : 0]         Rinv11_23_i_mul_any_short;
 
reg    signed       [WORD_LENGTH-1 : 0]         R_inv_11_mul_Rinv33_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv_11_mul_R23_r_reg  ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv_11_mul_R23_i_reg  ;
 
reg    signed       [WORD_LENGTH-1 : 0]         Rinv11_33_mul_R13_r_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         Rinv11_33_mul_R13_i_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         Rinv11_23_r_mul_R12_r_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         Rinv11_23_r_mul_R12_i_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         Rinv11_23_i_mul_R12_i_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         Rinv11_23_i_mul_R12_r_short_reg ;

wire    signed      [WORD_LENGTH-1 : 0]         R_inv_re_13_comb ;
wire    signed      [WORD_LENGTH-1 : 0]         R_inv_im_13_comb ;


// Wires of R_inv_24
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv22_mul_any_long;
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv22_44_mul_any_long ;
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv22_34_r_mul_any_long;
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv22_34_i_mul_any_long;
 
wire    signed      [WORD_LENGTH-1 : 0]         Rinv22_mul_any_short;
wire    signed      [WORD_LENGTH-1 : 0]         Rinv22_44_mul_any_short;
wire    signed      [WORD_LENGTH-1 : 0]         Rinv22_34_r_mul_any_short;
wire    signed      [WORD_LENGTH-1 : 0]         Rinv22_34_i_mul_any_short;
 
reg    signed       [WORD_LENGTH-1 : 0]         R_inv_22_mul_Rinv44_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv_22_mul_R34_r_reg  ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv_22_mul_R34_i_reg  ;
  
reg    signed       [WORD_LENGTH-1 : 0]         Rinv22_44_mul_R24_r_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         Rinv22_44_mul_R24_i_short_reg ; 
reg    signed       [WORD_LENGTH-1 : 0]         Rinv22_34_r_mul_R23_r_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         Rinv22_34_r_mul_R23_i_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         Rinv22_34_i_mul_R23_i_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         Rinv22_34_i_mul_R23_r_short_reg ;

wire    signed      [WORD_LENGTH-1 : 0]         R_inv_re_24_comb ;
wire    signed      [WORD_LENGTH-1 : 0]         R_inv_im_24_comb ;


// Wires of R_inv_14
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv11_mul_any_of_five_long ;
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv11_44_mul_any_long;
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv11_24_r_mul_any_long;
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv11_24_i_mul_any_long;
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv11_34_r_mul_any_long;
wire    signed      [WORD_LENGTH*2-1 : 0]       Rinv11_34_i_mul_any_long;
 
wire    signed      [WORD_LENGTH-1 : 0]         Rinv11_mul_any_of_five_short ;
wire    signed      [WORD_LENGTH-1 : 0]         Rinv11_44_mul_any_short;
wire    signed      [WORD_LENGTH-1 : 0]         Rinv11_24_r_mul_any_short;
wire    signed      [WORD_LENGTH-1 : 0]         Rinv11_24_i_mul_any_short;
wire    signed      [WORD_LENGTH-1 : 0]         Rinv11_34_r_mul_any_short;
wire    signed      [WORD_LENGTH-1 : 0]         Rinv11_34_i_mul_any_short;
 
reg    signed       [WORD_LENGTH-1 : 0]         R_inv_11_mul_Rinv44_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv_11_mul_R24_r_reg  ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv_11_mul_R24_i_reg  ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv_11_mul_R34_r_reg  ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv_11_mul_R34_i_reg  ;
reg    signed       [WORD_LENGTH-1 : 0]         Rinv11_mul_any_of_five_short_reg ;
  
reg    signed       [WORD_LENGTH-1 : 0]         R_inv11_44_mul_R14_r_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv11_44_mul_R14_i_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv11_24_r_mul_R12_r_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv11_24_r_mul_R12_i_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv11_24_i_mul_R12_i_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv11_24_i_mul_R12_r_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv11_34_r_mul_R13_r_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv11_34_i_mul_R13_r_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv11_34_i_mul_R13_i_short_reg ;
reg    signed       [WORD_LENGTH-1 : 0]         R_inv11_34_r_mul_R13_i_short_reg ;



wire    signed      [WORD_LENGTH-1 : 0]         R_inv_re_14_comb ;
wire    signed      [WORD_LENGTH-1 : 0]         R_inv_im_14_comb ;


// Take the reciporcal elements and register them
wire    signed      [WORD_LENGTH-1 : 0]         R_inv_re_11_comb ;
wire    signed      [WORD_LENGTH-1 : 0]         R_inv_re_22_comb ;
wire    signed      [WORD_LENGTH-1 : 0]         R_inv_re_33_comb ;
wire    signed      [WORD_LENGTH-1 : 0]         R_inv_re_44_comb ;
 
 
//output of Muxs 
wire    signed      [WORD_LENGTH-1 : 0]         mux_5_out    ;
wire    signed      [WORD_LENGTH-1 : 0]         mux_6_out    ;
wire    signed      [WORD_LENGTH-1 : 0]         mux_7_out    ;
wire    signed      [WORD_LENGTH-1 : 0]         mux_8_out    ;
wire    signed      [WORD_LENGTH-1 : 0]         mux_9_out    ;
wire    signed      [WORD_LENGTH-1 : 0]         mux_10_out   ;
wire    signed      [WORD_LENGTH-1 : 0]         mux_11_out   ;
wire    signed      [WORD_LENGTH-1 : 0]         mux_12_out   ;
wire    signed      [WORD_LENGTH-1 : 0]         mux_13_out   ;
wire    signed      [WORD_LENGTH-1 : 0]         mux_14_out   ;
wire    signed      [WORD_LENGTH-1 : 0]         mux_15_out   ;
wire    signed      [WORD_LENGTH-1 : 0]         mux_16_out   ;
wire    signed      [WORD_LENGTH-1 : 0]         mux_17_out   ;
wire    signed      [WORD_LENGTH-1 : 0]         mux_18_out   ;
 
reg    signed       [WORD_LENGTH-1 : 0]         mux_5_out_reg;
reg    signed       [WORD_LENGTH-1 : 0]         mux_6_out_reg;
reg    signed       [WORD_LENGTH-1 : 0]         mux_7_out_reg;
reg    signed       [WORD_LENGTH-1 : 0]         mux_8_out_reg;
reg    signed       [WORD_LENGTH-1 : 0]         mux_9_out_reg;
reg    signed       [WORD_LENGTH-1 : 0]         mux_10_out_reg;
reg    signed       [WORD_LENGTH-1 : 0]         mux_11_out_reg;
reg    signed       [WORD_LENGTH-1 : 0]         mux_12_out_reg;
reg    signed       [WORD_LENGTH-1 : 0]         mux_13_out_reg;
reg    signed       [WORD_LENGTH-1 : 0]         mux_14_out_reg;
reg    signed       [WORD_LENGTH-1 : 0]         mux_15_out_reg;
reg    signed       [WORD_LENGTH-1 : 0]         mux_16_out_reg;
reg    signed       [WORD_LENGTH-1 : 0]         mux_17_out_reg;
reg    signed       [WORD_LENGTH-1 : 0]         mux_18_out_reg;


reg   Enable_recp_reg;

///////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// Memories///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

// Storing the inputs in a ROM
reg signed [WORD_LENGTH -1:0]  R_elements   [No_of_non_zero_R_elements - 1: 0] ;


///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////// Control Signals //////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
wire valid_recp1,valid_recp2,valid_recp3,valid_recp4;

assign valid_recp = valid_recp1&valid_recp2&valid_recp3&valid_recp4; // status signal to the controller indicating that reciprocals are ready




integer i;

// Assume that I begin the block when all the inputs are ready
// I first store the input R_matrix elements in a memory (ROM)
always @(posedge CLK or negedge RST) begin
  if (!RST) begin
    // reset
     for ( i = 0 ; i <= (No_of_non_zero_R_elements - 1) ; i = i + 1 ) begin
          R_elements [i] <= 'b0;
      end 
  end
  else begin
    R_elements[0]   <= R_re_11 ;
    R_elements[1]   <= R_re_22 ;
    R_elements[2]   <= R_re_33 ;
    R_elements[3]   <= R_re_44 ;
    R_elements[4]   <= R_re_12 ;
    R_elements[5]   <= R_im_12 ;
    R_elements[6]   <= R_re_13 ;
    R_elements[7]   <= R_im_13 ;
    R_elements[8]   <= R_re_14 ;
    R_elements[9]   <= R_im_14 ;
    R_elements[10]  <= R_re_23 ;
    R_elements[11]  <= R_im_23 ;
    R_elements[12]  <= R_re_24 ;
    R_elements[13]  <= R_im_24 ;
    R_elements[14]  <= R_re_34 ;
    R_elements[15]  <= R_im_34 ;
  end
end


// Registering Enable_recip Signal 
always @(posedge CLK or negedge RST) begin
  if (!RST) begin
    Enable_recp_reg <= 'b0;
  end
  else begin
    Enable_recp_reg <= Enable_recp; 
  end
end





// Next step is getting the reciprocal of R11,R22,R33,R44 using the Reciprocal Cordic
// Each reciprocal take 2 cycles to be calculated (output is registered)
// I will use 4 block of hardware to calculate the 4 inverse elemnents at the same time


  Reciprocal_Cordic #( 
     .INT_LENGTH(INT_LENGTH),
     .FRAC_LENGTH(FRAC_LENGTH),
     .NUM_OF_ITERATIONS(NUM_OF_ITERATIONS),
     .SCALE(RECP_SCALE)
    ) recpR11 (
      .CLK(CLK),
      .RST(RST),
      .Enable_recp(Enable_recp_reg),
      .Input_recp(R_elements[0]),
      .reciprocal(R_inv_re_11_comb),
      .Valid_recp(valid_recp1)      
    );

  Reciprocal_Cordic #( 
     .INT_LENGTH(INT_LENGTH),
     .FRAC_LENGTH(FRAC_LENGTH),
     .NUM_OF_ITERATIONS(NUM_OF_ITERATIONS),
     .SCALE(RECP_SCALE)     
    )recpR22(
      .CLK(CLK),
      .RST(RST),
      .Enable_recp(Enable_recp_reg),
      .Input_recp(R_elements[1]),
      .reciprocal(R_inv_re_22_comb),
      .Valid_recp(valid_recp2)    
    );

  Reciprocal_Cordic #( 
     .INT_LENGTH(INT_LENGTH),
     .FRAC_LENGTH(FRAC_LENGTH),
     .NUM_OF_ITERATIONS(NUM_OF_ITERATIONS),
     .SCALE(RECP_SCALE)
    )recpR33(
      .CLK(CLK),
      .RST(RST),
      .Enable_recp(Enable_recp_reg),
      .Input_recp(R_elements[2]),
      .reciprocal(R_inv_re_33_comb),
      .Valid_recp(valid_recp3)      
    );

  Reciprocal_Cordic #( 
     .INT_LENGTH(INT_LENGTH),
     .FRAC_LENGTH(FRAC_LENGTH),
     .NUM_OF_ITERATIONS(NUM_OF_ITERATIONS),
     .SCALE(RECP_SCALE)     
    )recpR44(
      .CLK(CLK),
      .RST(RST),
      .Enable_recp(Enable_recp_reg),
      .Input_recp(R_elements[3]),
      .reciprocal(R_inv_re_44_comb),
      .Valid_recp(valid_recp4)
    );


  // Now the 4 inverse diagonal elemnts are stored in 4 registers.



  // Register the inverse diagonal elements
  // These are the fianal outputs of these 4 elements 
always @(posedge CLK or negedge RST) begin
  if (!RST) begin
     R_inv_re_11 <= 'b0;
     R_inv_re_22 <= 'b0;
     R_inv_re_33 <= 'b0;
     R_inv_re_44 <= 'b0;
  end
  else begin
     R_inv_re_11 <= R_inv_re_11_comb;
     R_inv_re_22 <= R_inv_re_22_comb;
     R_inv_re_33 <= R_inv_re_33_comb;
     R_inv_re_44 <= R_inv_re_44_comb;   
  end
end



/*Before entering the multplication paths, we should know that now all the R inputs coming from
the QR block are registered and the R_inv diagonal elements are also registered,so the inputs of the coming
multiplication paths are all registered */


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// Multiplications //////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////// Getting R_inv_12 , R_inv_23 , R_inv_34 //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Equations :
//Rinv_12_r = - Rinv11 * Rinv22 * R12_r
//Rinv_12_i = - Rinv11 * Rinv22 * R12_i
//Rinv_23_r = - Rinv22 * Rinv33 * R23_r
//Rinv_23_i = - Rinv22 * Rinv33 * R23_i
//Rinv_34_r = - Rinv33 * Rinv44 * R34_r
//Rinv_34_i = - Rinv33 * Rinv44 * R34_i
// where   Rinv11 * Rinv22 or Rinv22 * Rinv33 or Rinv33 * Rinv44 is calculated once
// So direct implementation needs 9 multiplier to calculate these components


/*
I will use the concept of reuse here, will need only 3 multipliers instead of 9 multpliers. -> In vivado it takes 12 DSP
  I will have a mux 3x1,and depending on the value of the selection line that is coming from a controller (F.S.M),
  i will choose certain operands to be multiplied.
  Note: In these 3 elements,no inter-dependence between them, so it is an easy task .
*/

// Muxes to choose operands to enter the 1st multiplier
mux3x1 # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux_1(.sel(sel1),.a(R_inv_re_11),.b(R_inv_re_22),.c(R_inv_re_33),.outmux(R_inv_ii));
mux3x1 # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux_2(.sel(sel1),.a(R_inv_re_22),.b(R_inv_re_33),.c(R_inv_re_44),.outmux(R_inv_jj));


// Register the mux out
always @(posedge CLK  or negedge RST) begin
  if (!RST) begin
      R_inv_ii_reg  <= 'b0;
      R_inv_jj_reg  <= 'b0;

  end
  else  begin
      R_inv_ii_reg  <= R_inv_ii;
      R_inv_jj_reg  <= R_inv_jj;
  end
end

//1st Multiplication
assign   Rinvii_mul_Rinvjj_long  = R_inv_ii_reg* R_inv_jj_reg ;
assign   Rinvii_mul_Rinvjj_short = Rinvii_mul_Rinvjj_long >>> FRAC_LENGTH ;



// Break the critical path by inserting register after the first multiplication
always @(posedge CLK  or negedge RST) begin
  if (!RST) begin
      Rinvii_mul_Rinvjj_short_reg <= 'b0;
  end
  else  begin
      Rinvii_mul_Rinvjj_short_reg <= Rinvii_mul_Rinvjj_short;

  end
end


// output of 1st multiplication will be multiplied by either of R12,R23,R34 (real&img) -> Multiplexer
mux3x1 # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux3(.sel(sel1),.a(R_elements[4]),.b(R_elements[10]),.c(R_elements[14]),.outmux(R_ij_real));
mux3x1 # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux4(.sel(sel1),.a(R_elements[5]),.b(R_elements[11]),.c(R_elements[15]),.outmux(R_ij_img)) ;


// Register the mux out
always @(posedge CLK  or negedge RST) begin
  if (!RST) begin
      R_ij_real_reg <= 'b0;
      R_ij_img_reg  <= 'b0;

  end
  else  begin
      R_ij_real_reg <= R_ij_real;
      R_ij_img_reg  <= R_ij_img;
  end
end


// 2nd Multiplication
// real
assign   Rinvii_jj_mul_Rij_real_long  = Rinvii_mul_Rinvjj_short_reg* R_ij_real_reg;
assign   Rinvii_jj_mul_Rij_real_short = Rinvii_jj_mul_Rij_real_long >>> FRAC_LENGTH ;
// same for img
assign   Rinvii_jj_mul_Rij_img_long  = Rinvii_mul_Rinvjj_short_reg* R_ij_img_reg ;
assign   Rinvii_jj_mul_Rij_img_short = Rinvii_jj_mul_Rij_img_long >>> FRAC_LENGTH ;



// Break the critical path
// The reason i inserted this register before the coming register is that in the next always block i pass the output of a multiplication
// by an alu to invert its sign,so this doesn't pass timing in vivado,so i insert a register immediately after multiplication
always @(posedge CLK  or negedge RST) begin
  if (!RST) begin
      Rinvii_jj_mul_Rij_real_short_reg <= 'b0;
      Rinvii_jj_mul_Rij_img_short_reg  <= 'b0;

  end
  else  begin
      Rinvii_jj_mul_Rij_real_short_reg <= Rinvii_jj_mul_Rij_real_short;
      Rinvii_jj_mul_Rij_img_short_reg  <= Rinvii_jj_mul_Rij_img_short;
  end
end




  // Now we will register these 3 outputs so that now this multiplication path is input output registered

   // These are the final outputs of thsese 3 elements ( 3 real , 3 img) : R_inv_12 , R_inv_23 , R_inv_34
 always @(posedge CLK or negedge RST) begin
 //always @(posedge CLK) begin
    if (!RST) begin
       R_inv_re_12 <= 'b0;
       R_inv_im_12 <= 'b0;
       R_inv_re_23 <= 'b0;
       R_inv_im_23 <= 'b0;
       R_inv_re_34 <= 'b0;
       R_inv_im_34 <= 'b0;          
    end
    else begin
      if (sel1=='d0 && Enable_register_R12)begin  // enabled flip-flop -> register only when the enable is high
                                                  // If this enable doesn't exist,this bus will have wrong data because the default of sel 1 is 0
                                                  // so correct data will be overwritten is this enable doesn't exist
        R_inv_re_12 <= - Rinvii_jj_mul_Rij_real_short_reg;
        R_inv_im_12 <= - Rinvii_jj_mul_Rij_img_short_reg;
      end
      else if (sel1=='d1)begin
        R_inv_re_23 <= - Rinvii_jj_mul_Rij_real_short_reg;
        R_inv_im_23 <= - Rinvii_jj_mul_Rij_img_short_reg;
      end
      else if (sel1=='d2)begin  
        R_inv_im_34 <= - Rinvii_jj_mul_Rij_img_short_reg; 
        R_inv_re_34 <= - Rinvii_jj_mul_Rij_real_short_reg;
    end
  end
  end



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////// Getting R_inv_13 ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Equation :
//Rinv_13_r = -(Rinv11 * Rinv33 * R13_r + Rinv11 * Rinv23_r * R12_r  - Rinv11 * Rinv23_i * R12_i) 
//Rinv_13_i = -(Rinv11 * Rinv33 * R13_i + Rinv11 * Rinv23_r * R12_i  + Rinv11 * Rinv23_i * R12_r)

// Direct Implememtation takes 6 Multipliers for each compenent -> 12 Multiplier Total  -> In vivado it takes 15 DSP

// I notice that Rinv11 is in all 1st multiplication
// SO: Keep it constant on the 1st multiplier and other elements through muxs will be multiplied with it

mux3x1 # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux5(.sel(sel2),.a(R_inv_re_33),.b(R_inv_re_23),.c(R_inv_im_23),.outmux(mux_5_out));

// Register the mux out
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_5_out_reg<= 'b0;
    end
    else begin
       mux_5_out_reg<= mux_5_out;
    end
  end


// 1st Multiplication
assign   Rinv11_mul_any_long  = R_inv_re_11* mux_5_out_reg ;
assign   Rinv11_mul_any_short = Rinv11_mul_any_long >>> FRAC_LENGTH ;


// Register this signal to break path and then store the value according to the variable multiplied by Rinv11


always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       R_inv_11_mul_Rinv33_reg<= 'b0;
       R_inv_11_mul_R23_r_reg <= 'b0;
       R_inv_11_mul_R23_i_reg <= 'b0; 
    end
    else begin

      if (sel2=='d0)begin
       R_inv_11_mul_Rinv33_reg <=  Rinv11_mul_any_short;
      end
      else if (sel2=='d1)begin
       R_inv_11_mul_R23_r_reg  <=  Rinv11_mul_any_short;
      end
      else if (sel2=='d2)begin
       R_inv_11_mul_R23_i_reg  <=  Rinv11_mul_any_short;
       end

    end

end



// I notice that each of the previous terms is multiplied by one of two terms  the 2nd multiplication 
// First is one is either multiplied by R13_r or R13_i
// 2nd is one is either multiplied by R12_r or R12_i
// 3rd is one is either multiplied by R12_i or R12_r


mux2x1  # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux6
 (
  .sel(sel3),
  .a(R_elements[6]),
  .b(R_elements[7]),
  .outmux(mux_6_out)
  );

// Register the mux out
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_6_out_reg<= 'b0;
    end
    else begin
       mux_6_out_reg<= mux_6_out;
    end
  end


// 2nd Multiplication
assign   Rinv11_33_mul_any_long  = R_inv_11_mul_Rinv33_reg* mux_6_out_reg ;
assign   Rinv11_33_mul_any_short = Rinv11_33_mul_any_long >>> FRAC_LENGTH ;


mux2x1  # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux7
 (
  .sel(sel3),
  .a(R_elements[4]),
  .b(R_elements[5]),
  .outmux(mux_7_out)
  );

// Register the mux out
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_7_out_reg<= 'b0;
    end
    else begin
       mux_7_out_reg<= mux_7_out;
    end
  end


// 3rd Multiplication
assign   Rinv11_23_r_mul_any_long  = R_inv_11_mul_R23_r_reg* mux_7_out_reg ;
assign   Rinv11_23_r_mul_any_short = Rinv11_23_r_mul_any_long >>> FRAC_LENGTH ;



mux2x1  # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux8
 (
  .sel(sel3),
  .a(R_elements[5]),
  .b(R_elements[4]),
  .outmux(mux_8_out)
  );

// Register the mux out
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_8_out_reg<= 'b0;
    end
    else begin
       mux_8_out_reg<= mux_8_out;
    end
  end

// 4th Multiplication
assign   Rinv11_23_i_mul_any_long  = R_inv_11_mul_R23_i_reg* mux_8_out_reg ;
assign   Rinv11_23_i_mul_any_short = Rinv11_23_i_mul_any_long >>> FRAC_LENGTH ;


// Register each term of those
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       Rinv11_33_mul_R13_r_short_reg   <= 'b0;
       Rinv11_33_mul_R13_i_short_reg   <= 'b0;
       Rinv11_23_r_mul_R12_r_short_reg <= 'b0;
       Rinv11_23_r_mul_R12_i_short_reg <= 'b0; 
       Rinv11_23_i_mul_R12_i_short_reg <= 'b0;
       Rinv11_23_i_mul_R12_r_short_reg <= 'b0;     
    end

    else begin
      if (sel3=='d0)begin
       Rinv11_33_mul_R13_r_short_reg   <= Rinv11_33_mul_any_short;
       Rinv11_23_r_mul_R12_r_short_reg <= Rinv11_23_r_mul_any_short;
       Rinv11_23_i_mul_R12_i_short_reg <= Rinv11_23_i_mul_any_short;       
      end
      else if (sel3=='d1)begin
       Rinv11_33_mul_R13_i_short_reg   <= Rinv11_33_mul_any_short;
       Rinv11_23_r_mul_R12_i_short_reg <= Rinv11_23_r_mul_any_short;
       Rinv11_23_i_mul_R12_r_short_reg <= Rinv11_23_i_mul_any_short;        
      end
   end
end


 // assigning R_inv_13_combinational
assign R_inv_re_13_comb = Rinv11_33_mul_R13_r_short_reg + Rinv11_23_r_mul_R12_r_short_reg - Rinv11_23_i_mul_R12_i_short_reg ;
assign R_inv_im_13_comb = Rinv11_33_mul_R13_i_short_reg + Rinv11_23_r_mul_R12_i_short_reg + Rinv11_23_i_mul_R12_r_short_reg ;


 //Register the output R_inv_13 : Final outputs
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       R_inv_re_13 <= 'b0;
       R_inv_im_13 <= 'b0;
    end
    else if(Enable_register_R13) begin
       R_inv_re_13 <= - R_inv_re_13_comb;
       R_inv_im_13 <= - R_inv_im_13_comb;
    end
  end



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////// Getting R_inv_24 ///////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Equation :
//Rinv_24_r = -(Rinv22 * Rinv44 * R24_r + Rinv22 * Rinv34_r * R23_r  - Rinv22 * Rinv34_i * R23_i) 
//Rinv_24_i = -(Rinv22 * Rinv44 * R24_i + Rinv22 * Rinv34_r * R23_i  + Rinv22 * Rinv34_i * R23_r)

// Direct Implememtation takes 6 Multipliers for each compenent -> 12 Multiplier Total  -> In vivado it takes 15 DSP

// I notice that Rinv22 is in all 1st multiplication
// SO: Keep it constant on the 1st multiplier and other elements through muxs will be multiplied with it


mux3x1 # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux9(.sel(sel4),.a(R_inv_re_44),.b(R_inv_re_34),.c(R_inv_im_34),.outmux(mux_9_out));

// Register the mux out
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_9_out_reg<= 'b0;
    end
    else begin
       mux_9_out_reg<= mux_9_out;
    end
  end


// 1st Multiplication
assign   Rinv22_mul_any_long  = R_inv_re_22* mux_9_out_reg ;
assign   Rinv22_mul_any_short = Rinv22_mul_any_long >>> FRAC_LENGTH ;

  

// Register this signal to break path and then store the value according to the variable multiplied by Rinv22


  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       R_inv_22_mul_Rinv44_reg<= 'b0;
       R_inv_22_mul_R34_r_reg <= 'b0;
       R_inv_22_mul_R34_i_reg <= 'b0; 
    end

    else begin
      if (sel4=='d0 && Enable_register_Rinv22_44)begin
       R_inv_22_mul_Rinv44_reg <=  Rinv22_mul_any_short;
      end

      else if (sel4=='d1)begin
       R_inv_22_mul_R34_r_reg  <=  Rinv22_mul_any_short;
      end

      else if (sel4=='d2)begin
       R_inv_22_mul_R34_i_reg  <=  Rinv22_mul_any_short;
     end
   end
end



// I notice that each of the previous terms is multiplied by one of two terms  the 2nd multiplication 
// First is one is either multiplied by R24_r or R24_i
// 2nd is one is either multiplied by R23_r or R23_i
// 3rd is one is either multiplied by R23_i or R23_r


mux2x1  # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux10
 (
  .sel(sel5),
  .a(R_elements[12]),
  .b(R_elements[13]),
  .outmux(mux_10_out)
  );


always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_10_out_reg<= 'b0;
    end
    else begin
       mux_10_out_reg<= mux_10_out;
    end
  end

// 2nd Multiplication
assign   Rinv22_44_mul_any_long  = R_inv_22_mul_Rinv44_reg* mux_10_out_reg ;
assign   Rinv22_44_mul_any_short = Rinv22_44_mul_any_long >>> FRAC_LENGTH ;


mux2x1  # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux11
 (
  .sel(sel5),
  .a(R_elements[10]),
  .b(R_elements[11]),
  .outmux(mux_11_out)
  );


always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_11_out_reg<= 'b0;
    end
    else begin
       mux_11_out_reg<= mux_11_out;
    end
  end


// 3rd Multiplication
assign   Rinv22_34_r_mul_any_long  = R_inv_22_mul_R34_r_reg* mux_11_out_reg ;
assign   Rinv22_34_r_mul_any_short = Rinv22_34_r_mul_any_long >>> FRAC_LENGTH ;



mux2x1  # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux12
 (
  .sel(sel5),
  .a(R_elements[11]),
  .b(R_elements[10]),
  .outmux(mux_12_out)
  );


always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_12_out_reg<= 'b0;
    end
    else begin
       mux_12_out_reg<= mux_12_out;
    end
  end


// 4th Multiplication
assign   Rinv22_34_i_mul_any_long  = R_inv_22_mul_R34_i_reg* mux_12_out_reg ;
assign   Rinv22_34_i_mul_any_short = Rinv22_34_i_mul_any_long >>> FRAC_LENGTH ;


// Register each term of those

  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       Rinv22_44_mul_R24_r_short_reg<= 'b0;
       Rinv22_44_mul_R24_i_short_reg<= 'b0;
       Rinv22_34_r_mul_R23_r_short_reg <= 'b0;
       Rinv22_34_r_mul_R23_i_short_reg <= 'b0; 
       Rinv22_34_i_mul_R23_i_short_reg <= 'b0;
       Rinv22_34_i_mul_R23_r_short_reg <= 'b0;     
    end
    else begin
      if (sel5=='d0)begin
       Rinv22_44_mul_R24_r_short_reg<= Rinv22_44_mul_any_short;
       Rinv22_34_r_mul_R23_r_short_reg <= Rinv22_34_r_mul_any_short;
       Rinv22_34_i_mul_R23_i_short_reg <= Rinv22_34_i_mul_any_short;       
      end
      else if (sel5=='d1)begin
       Rinv22_44_mul_R24_i_short_reg<= Rinv22_44_mul_any_short;
       Rinv22_34_r_mul_R23_i_short_reg <= Rinv22_34_r_mul_any_short;
       Rinv22_34_i_mul_R23_r_short_reg <= Rinv22_34_i_mul_any_short;        
      end
    end

  end


 // assigning R_inv_24_combinational
assign R_inv_re_24_comb = Rinv22_44_mul_R24_r_short_reg + Rinv22_34_r_mul_R23_r_short_reg - Rinv22_34_i_mul_R23_i_short_reg ;
assign R_inv_im_24_comb = Rinv22_44_mul_R24_i_short_reg + Rinv22_34_r_mul_R23_i_short_reg + Rinv22_34_i_mul_R23_r_short_reg ;


 //Register the output R_inv_24 : Final output of it
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       R_inv_re_24 <= 'b0;
       R_inv_im_24 <= 'b0;
    end
    else begin
       R_inv_re_24 <= - R_inv_re_24_comb;
       R_inv_im_24 <= - R_inv_im_24_comb;
    end
  end


//////////////////////////////////////////////////////// Last Element //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////// Getting R_inv_14 ///////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Equation :
//Rinv_24_r = -(Rinv11 * Rinv44 * R14_r + Rinv11 * Rinv24_r * R12_r  - Rinv11 * Rinv24_i * R12_i + Rinv11 * Rinv34_r * R13_r  - Rinv11 * Rinv34_i * R13_i) 
//Rinv_24_i = -(Rinv11 * Rinv44 * R14_i + Rinv11 * Rinv24_r * R12_i  + Rinv11 * Rinv24_i * R12_r + Rinv11 * Rinv34_i * R13_r  + Rinv11 * Rinv34_r * R13_i)

// Direct Implememtation takes 10 Multipliers for each compenent -> 20 Multiplier Total  -> In vivado it takes 30 DSP

// I notice that Rinv11 is in all 1st multiplication
// SO: Keep it constant on the 1st multiplier and other elements through muxs will be multiplied with it


// Choose between : Rinv44 , Rinv24_r, Rinv24_i , Rinv13_r , Rinv_13_i
// MUX 5x1
mux5x1  # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux13
 (
  .sel(sel6),
  .a(R_inv_re_44),
  .b(R_inv_re_24),
  .c(R_inv_im_24),
  .d(R_inv_re_34),
  .e(R_inv_im_34),
  .outmux(mux_13_out)
  );

// Register the mux out
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_13_out_reg<= 'b0;
    end
    else begin
       mux_13_out_reg<= mux_13_out;
    end
  end



// 1st Multiplication
assign   Rinv11_mul_any_of_five_long  = R_inv_re_11* mux_13_out_reg ;
assign   Rinv11_mul_any_of_five_short = Rinv11_mul_any_of_five_long >>> FRAC_LENGTH ;


// Register this signal to break path and then store the value according to the variable multiplied by Rinv22

  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       R_inv_11_mul_Rinv44_reg <= 'b0;
       R_inv_11_mul_R24_r_reg  <= 'b0;
       R_inv_11_mul_R24_i_reg  <= 'b0; 
       R_inv_11_mul_R34_r_reg  <= 'b0;
       R_inv_11_mul_R34_i_reg  <= 'b0; 
    end

    else begin

      if (sel6=='d0)begin
       R_inv_11_mul_Rinv44_reg <= Rinv11_mul_any_of_five_short;
      end

      else if (sel6=='d1)begin
       R_inv_11_mul_R24_r_reg <= Rinv11_mul_any_of_five_short;
      end

      else if (sel6=='d2)begin
       R_inv_11_mul_R24_i_reg <= Rinv11_mul_any_of_five_short;
     end
      else if (sel6=='d3)begin
       R_inv_11_mul_R34_r_reg <= Rinv11_mul_any_of_five_short;
     end
      else if (sel6=='d4)begin
       R_inv_11_mul_R34_i_reg <= Rinv11_mul_any_of_five_short;
     end

   end
end



// Try mutiplying the output of the previos mux by one of 6 elements
// R14_r , R14_i , R12_r , R12_i , R34_r, R34_i ;


mux2x1  # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux14
 (
  .sel(sel7),
  .a(R_elements[8]),
  .b(R_elements[9]),
  .outmux(mux_14_out)
  );

// Register the mux out
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_14_out_reg<= 'b0;
    end
    else begin
       mux_14_out_reg<= mux_14_out;
    end
  end


// 2nd Multiplication
assign   Rinv11_44_mul_any_long  = R_inv_11_mul_Rinv44_reg* mux_14_out_reg ;
assign   Rinv11_44_mul_any_short = Rinv11_44_mul_any_long >>> FRAC_LENGTH ;


mux2x1  # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux15
 (
  .sel(sel7),
  .a(R_elements[4]),
  .b(R_elements[5]),
  .outmux(mux_15_out)
  );

// Register the mux out
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_15_out_reg<= 'b0;
    end
    else begin
       mux_15_out_reg<= mux_15_out;
    end
  end


// 3rd Multiplication
assign   Rinv11_24_r_mul_any_long  = R_inv_11_mul_R24_r_reg* mux_15_out_reg ;
assign   Rinv11_24_r_mul_any_short = Rinv11_24_r_mul_any_long >>> FRAC_LENGTH ;



mux2x1  # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux16
 (
  .sel(sel7),
  .a(R_elements[5]),
  .b(R_elements[4]),
  .outmux(mux_16_out)
  );

// Register the mux out
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_16_out_reg<= 'b0;
    end
    else begin
       mux_16_out_reg<= mux_16_out;
    end
  end


// 4th Multiplication
assign   Rinv11_24_i_mul_any_long  = R_inv_11_mul_R24_i_reg* mux_16_out_reg ;
assign   Rinv11_24_i_mul_any_short = Rinv11_24_i_mul_any_long >>> FRAC_LENGTH ;


mux2x1  # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux17
 (
  .sel(sel7),
  .a(R_elements[6]),
  .b(R_elements[7]),
  .outmux(mux_17_out)
  );


// Register the mux out
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_17_out_reg<= 'b0;
    end
    else begin
       mux_17_out_reg<= mux_17_out;
    end
  end

// 5th Multiplication
assign   Rinv11_34_r_mul_any_long  = R_inv_11_mul_R34_r_reg* mux_17_out_reg ;
assign   Rinv11_34_r_mul_any_short = Rinv11_34_r_mul_any_long >>> FRAC_LENGTH ;



mux2x1  # (.INT_LENGTH(INT_LENGTH),.FRAC_LENGTH(FRAC_LENGTH)) mux18
 (
  .sel(sel7),
  .a(R_elements[7]),
  .b(R_elements[6]),
  .outmux(mux_18_out)
  );

// Register the mux out
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       mux_18_out_reg<= 'b0;
    end
    else begin
       mux_18_out_reg<= mux_18_out;
    end
  end


// 6th Multiplication
assign   Rinv11_34_i_mul_any_long  = R_inv_11_mul_R34_i_reg* mux_18_out_reg ;
assign   Rinv11_34_i_mul_any_short = Rinv11_34_i_mul_any_long >>> FRAC_LENGTH ;



// Register each term of those
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       R_inv11_44_mul_R14_r_short_reg  <= 'b0;
       R_inv11_44_mul_R14_i_short_reg  <= 'b0;
       R_inv11_24_r_mul_R12_r_short_reg<= 'b0;
       R_inv11_24_r_mul_R12_i_short_reg<= 'b0;
       R_inv11_24_i_mul_R12_i_short_reg<= 'b0;
       R_inv11_24_i_mul_R12_r_short_reg<= 'b0;
       R_inv11_34_r_mul_R13_r_short_reg<= 'b0;
       R_inv11_34_r_mul_R13_i_short_reg<= 'b0;           
       R_inv11_34_i_mul_R13_i_short_reg<= 'b0;
       R_inv11_34_i_mul_R13_r_short_reg<= 'b0;    
    end
    else begin
      if (sel7=='d0)begin
        R_inv11_44_mul_R14_r_short_reg   <= Rinv11_44_mul_any_short;
        R_inv11_24_r_mul_R12_r_short_reg <= Rinv11_24_r_mul_any_short;
        R_inv11_24_i_mul_R12_i_short_reg <= Rinv11_24_i_mul_any_short;
        R_inv11_34_r_mul_R13_r_short_reg <= Rinv11_34_r_mul_any_short;
        R_inv11_34_i_mul_R13_i_short_reg <= Rinv11_34_i_mul_any_short ;    
      end
      else if (sel7=='d1)begin
       R_inv11_44_mul_R14_i_short_reg   <= Rinv11_44_mul_any_short;
       R_inv11_24_r_mul_R12_i_short_reg <= Rinv11_24_r_mul_any_short;
       R_inv11_24_i_mul_R12_r_short_reg <= Rinv11_24_i_mul_any_short;
       R_inv11_34_r_mul_R13_i_short_reg <= Rinv11_34_r_mul_any_short;         
       R_inv11_34_i_mul_R13_r_short_reg <= Rinv11_34_i_mul_any_short;        

      end
    end

  end


// R_inv_14 comb
assign R_inv_re_14_comb = R_inv11_44_mul_R14_r_short_reg + R_inv11_24_r_mul_R12_r_short_reg - R_inv11_24_i_mul_R12_i_short_reg + R_inv11_34_r_mul_R13_r_short_reg - R_inv11_34_i_mul_R13_i_short_reg ;
assign R_inv_im_14_comb = R_inv11_44_mul_R14_i_short_reg + R_inv11_24_r_mul_R12_i_short_reg + R_inv11_24_i_mul_R12_r_short_reg + R_inv11_34_r_mul_R13_i_short_reg + R_inv11_34_i_mul_R13_r_short_reg ;

                                                                                                                                     
 //Register the output R_inv_14 : Final outputs
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       R_inv_re_14 <= 'b0;
       R_inv_im_14 <= 'b0;
    end
    else begin
       R_inv_re_14 <= - R_inv_re_14_comb;
       R_inv_im_14 <= - R_inv_im_14_comb;
    end
  end


endmodule