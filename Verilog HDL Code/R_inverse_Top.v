module R_inverse_Top #( 
	parameter 	INT_LENGTH		  	=	7, 
	parameter  	FRAC_LENGTH			  =	11,
	parameter 	NUM_OF_ITERATIONS	=	11
)  (
///////////////// Inputs //////////////////////////////////
  input                                              CLK,
  input                                              RST,
  input                                              Enable_reciprocal,            //external input comes from QR
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
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_11, // real only 
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_12,  
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_13,  
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_14,  
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_22,  // real only
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_23,  
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_24,   
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_33, // real only
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_34, 
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_re_44,  // real only
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_im_12,  
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_im_13,  
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_im_14,  
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_im_23,  
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_im_24,  
  output   signed [INT_LENGTH + FRAC_LENGTH -1:0] R_inv_im_34,
  output wire                                     R_inverse_done
);

//wire Enable_recp;
wire       sel3,sel5,sel7;
wire [1:0] sel1,sel2,sel4;
wire [2:0] sel6;
wire       done_recp;
wire       Enable_register_R12;
wire       Enable_register_R13;
wire       Enable_register_Rinv22_44;



R_inversion #( 
  .INT_LENGTH(INT_LENGTH),
  .FRAC_LENGTH(FRAC_LENGTH),
  .NUM_OF_ITERATIONS(NUM_OF_ITERATIONS)
)  My_R_inverse (
  .CLK(CLK),
  .RST(RST),
  .Enable_recp(Enable_reciprocal),
  .Enable_register_R12(Enable_register_R12),
  .Enable_register_R13(Enable_register_R13),
  .Enable_register_Rinv22_44(Enable_register_Rinv22_44),
  .sel3(sel3),
  .sel5(sel5),
  .sel7(sel7),
  .sel1(sel1),
  .sel2(sel2),
  .sel4(sel4),
  .sel6(sel6),
  .R_re_11(R_re_11), // real only 
  .R_re_12(R_re_12),  
  .R_re_13(R_re_13),  
  .R_re_14(R_re_14),  
  .R_re_22(R_re_22),  // real only  
  .R_re_23(R_re_23),  
  .R_re_24(R_re_24),  
  .R_re_33(R_re_33),  // real only
  .R_re_34(R_re_34), 
  .R_re_44(R_re_44),  // real only
  .R_im_12(R_im_12),  
  .R_im_13(R_im_13),  
  .R_im_14(R_im_14),   
  .R_im_23(R_im_23),  
  .R_im_24(R_im_24),  
  .R_im_34(R_im_34), 
  .R_inv_re_11(R_inv_re_11), 
  .R_inv_re_12(R_inv_re_12),  
  .R_inv_re_13(R_inv_re_13),  
  .R_inv_re_14(R_inv_re_14),  
  .R_inv_re_22(R_inv_re_22),  
  .R_inv_re_23(R_inv_re_23),  
  .R_inv_re_24(R_inv_re_24),   
  .R_inv_re_33(R_inv_re_33), 
  .R_inv_re_34(R_inv_re_34), 
  .R_inv_re_44(R_inv_re_44),  
  .R_inv_im_12(R_inv_im_12),  
  .R_inv_im_13(R_inv_im_13),  
  .R_inv_im_14(R_inv_im_14),  
  .R_inv_im_23(R_inv_im_23),  
  .R_inv_im_24(R_inv_im_24),  
  .R_inv_im_34(R_inv_im_34),
  .valid_recp(done_recp)
);



R_inverse_Control #(
.INT_LENGTH(INT_LENGTH),
.FRAC_LENGTH(FRAC_LENGTH),
.NUM_OF_ITERATIONS(NUM_OF_ITERATIONS)
) Controller_R_inverse  (
.CLK(CLK),
.RST(RST),	
.Done_recp(done_recp),
.Enable_reciprocal(Enable_reciprocal),
.sel1(sel1),
.sel2(sel2),
.sel3(sel3),
.sel4(sel4),
.sel5(sel5),
.sel6(sel6),
.sel7(sel7),
.Enable_register_R12(Enable_register_R12),
.Enable_register_R13(Enable_register_R13),
.Enable_register_Rinv22_44(Enable_register_Rinv22_44),
.R_inverse_done(R_inverse_done)
);

endmodule