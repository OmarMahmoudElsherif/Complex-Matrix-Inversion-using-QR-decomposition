module R_inverse_Control #(
    parameter   INT_LENGTH          =   5, 
    parameter     FRAC_LENGTH       =   12,
    parameter   NUM_OF_ITERATIONS   =   12
)  (
input                           CLK,
input                           RST,    
input                           Done_recp,
input                           Enable_reciprocal,
output  reg       [1:0]         sel1,
output  reg       [1:0]         sel2,
output  reg                     sel3,
output  reg       [1:0]         sel4,
output  reg                     sel5,
output  reg       [2:0]         sel6,
output  reg                     sel7,
output  reg                     Enable_register_R12,
output  reg                     Enable_register_R13,
output  reg                     Enable_register_Rinv22_44,
output  reg                     R_inverse_done
);



reg [5:0] current_state,next_state;


localparam IDLE = 'd0;
localparam RECP_CORDIC = 'd1; 
localparam R_INV_12 = 'd2; 
localparam R_INV_23 = 'd3; 
localparam R_INV_34 = 'd4; 
localparam RINV11_MUL_RINV23_r = 'd5;
localparam RINV11_MUL_RINV23_i = 'd6;
localparam RINV13_SEL_0= 'd7;
localparam RINV13_SEL_1= 'd8;
localparam RINV22_MUL_RINV34_r = 'd9;
localparam RINV22_MUL_RINV34_i = 'd10;
localparam RINV24_SEL_0= 'd11;
localparam RINV24_SEL_1= 'd12;
//localparam RINV11_MUL_RINV44 = 'd28;
localparam RINV11_MUL_RINV24_r = 'd13;
localparam RINV11_MUL_RINV24_i = 'd14;
localparam RINV11_MUL_RINV34_r = 'd15;
localparam RINV11_MUL_RINV34_i = 'd16;
localparam RINV14_SEL_0= 'd17;
localparam RINV14_SEL_1= 'd18;
//localparam STOP= 'd42;

/*

typedef enum {
IDLE,
RECP_CORDIC,
R_INV_12,
R_INV_23,
R_INV_34,
RINV11_MUL_RINV33,
FOLLOW_RINV11_MUL_RINV33,
RINV11_MUL_RINV23_r,
FOLLOW_RINV11_MUL_RINV23_r,
RINV11_MUL_RINV23_i,
FOLLOW_RINV11_MUL_RINV23_i,
RINV13_SEL_0,
FOLLOW_RINV13_SEL_0,
RINV13_SEL_1,
FOLLOW_RINV13_SEL_1,
RINV22_MUL_RINV44,
FOLLOW_RINV22_MUL_RINV44,
RINV22_MUL_RINV34_r,
FOLLOW_RINV22_MUL_RINV34_r,
RINV22_MUL_RINV34_i,
FOLLOW_RINV22_MUL_RINV34_i,
RINV24_SEL_0,
FOLLOW_RINV24_SEL_0,
RINV24_SEL_1,
FOLLOW_RINV24_SEL_1,
RINV11_MUL_RINV44,
FOLLOW_RINV11_MUL_RINV44,
RINV11_MUL_RINV24_r,
FOLLOW_RINV11_MUL_RINV24_r,
RINV11_MUL_RINV24_i,
FOLLOW_RINV11_MUL_RINV24_i,
RINV11_MUL_RINV34_r,
FOLLOW_RINV11_MUL_RINV34_r,
RINV11_MUL_RINV34_i,
FOLLOW_RINV11_MUL_RINV34_i,
RINV14_SEL_0,
FOLLOW_RINV14_SEL_0,
RINV14_SEL_1,
FOLLOW_RINV14_SEL_1,
STOP
} state_ ;

state_ current_state,next_state;

*/




reg [2:0] counter,counter_reg;



// current state logic
always @(posedge CLK or negedge RST) 
begin
    if (!RST) 
        begin
             current_state<=IDLE;
             counter_reg      <='b0;
             //counter      <='b0;

        end
    else
        begin
             current_state<=next_state;
             counter_reg      <=counter ;        
             // counter     <=counter + 'b1;                  
        end
end




// next state logic and output logic together
always@(*)
begin      

    //Initial values
    sel1=2'b00;
    sel2=2'b00;
    sel3=1'b0;
    sel4=2'b00;
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;
    R_inverse_done = 'b0;


  case(current_state)
    
    IDLE:
    begin
    sel1=2'b00;
    sel2=2'b00;
    sel3=1'b0;
    sel4=2'b00;
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    counter='b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

    if(Enable_reciprocal)begin
    next_state=RECP_CORDIC;
    end
    else begin
    next_state=IDLE;
    end

    end

  
    RECP_CORDIC:
    begin
    sel1=2'b00;
    sel2=2'b00;
    sel3=1'b0;
    sel4=2'b00;
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    counter='b0;         
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;     
 
    if(Done_recp)begin
     next_state=R_INV_12; 
    end
    else begin
     next_state=RECP_CORDIC; 
    end

    end
       

    R_INV_12:
    begin
    sel1=2'b00; // calculate R_INV_12
    sel2=2'b00;
    sel3=1'b0;
    sel4=2'b00;
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    Enable_register_R12=1'b1;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;
    
    counter = counter_reg + 'b1;

    if(counter=='d3)begin
     next_state=R_INV_23; 
     counter='b0;         
    end
    else begin
     next_state=R_INV_12;
    end

    end


    R_INV_23:
    begin
    sel1=2'b01; // calculate R_INV_23
    sel2=2'b00;
    sel3=1'b0;
    sel4=2'b00;
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

    counter = counter_reg + 'b1;

    if(counter=='d4)begin
     next_state=R_INV_34; 
     counter='b0;         
    end
    else begin
     next_state=R_INV_23;
    end

    end


    R_INV_34:
    begin
    sel1=2'b10; // calculate R_INV_34
    sel2=2'b00;
    sel3=1'b0;
    sel4=2'b00;
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

    counter = counter_reg + 'b1;

    if(counter=='d4)begin
     next_state=RINV11_MUL_RINV23_r; 
     counter='b0;         
    end
    else begin
     next_state=R_INV_34;
    end    

    end


   ///////////////////////////////////////////////////////////////////////////////////////////////////////////
   //////////////////////////////////// Get Rinv_13 ////////////////////////////////////////////////////////// 
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

/*

// Is not important,as its function already finished in the previous states.remove ///////////////////
    RINV11_MUL_RINV33:
    begin
    sel1=2'b00; 
    sel2=2'b00; // Rinv11*Rinv33
    sel3=1'b0;
    sel4=2'b00;
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    Enable_reciprocal=0;
    next_state=RINV11_MUL_RINV23_r;
    end
*/

    RINV11_MUL_RINV23_r:
    begin
    sel1=2'b00; 
    sel2=2'b01; // Rinv11*Rinv_23_r
    sel3=1'b0;
    sel4=2'b00;
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

    counter = counter_reg + 'b1;

    if(counter=='d3)begin
     next_state=RINV11_MUL_RINV23_i; 
     counter='b0;         
    end
    else begin
     next_state=RINV11_MUL_RINV23_r;
    end
    end



    RINV11_MUL_RINV23_i:
    begin
    sel1=2'b00; 
    sel2=2'b10; // Rinv11*Rinv_23_i
    sel3=1'b0;
    sel4=2'b00;
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

    counter = counter_reg + 'b1;


    if(counter=='d3)begin
     next_state=RINV13_SEL_0; 
     counter='b0;         
    end
    else begin
     next_state=RINV11_MUL_RINV23_i;
    end    


    //next_state=FOLLOW_RINV11_MUL_RINV23_i;
    end


    RINV13_SEL_0:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0; // Get Rinv_13_sel_0
    sel4=2'b00;
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    counter='b0;  
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

    next_state=RINV13_SEL_1;
    end



    RINV13_SEL_1:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b1; // Get Rinv_13_sel_1
    sel4=2'b00;
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    Enable_register_R12=1'b0;    
    Enable_register_R13=1'b1;
    Enable_register_Rinv22_44=1'b1;
    counter='b0;         

    counter = counter_reg + 'b1;

    if(counter=='d3)begin
     next_state=RINV22_MUL_RINV34_r; 
     counter='b0;         
    end
    else begin
     next_state=RINV13_SEL_1;
    end

    end

   ///////////////////////////////////////////////////////////////////////////////////////////////////////////
   //////////////////////////////////// Get Rinv_24 ////////////////////////////////////////////////////////// 
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

// Is not important,as its function already finished in the previous states.remove ///////////////////

/*
    RINV22_MUL_RINV44:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0;
    sel4=2'b00; // Rinv22*Rinv44
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    
    counter = counter_reg + 'b1;

    if(counter=='d2)begin
     next_state=RINV22_MUL_RINV34_r; 
     counter='b0;         
    end
    else begin
     next_state=RINV22_MUL_RINV44;
    end 

    end
*/


    RINV22_MUL_RINV34_r:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0;
    sel4=2'b01; // Rinv22*Rinv_34_r
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

    counter = counter_reg + 'b1;

    if(counter=='d3)begin
     next_state=RINV22_MUL_RINV34_i; 
     counter='b0;         
    end
    else begin
     next_state=RINV22_MUL_RINV34_r;
    end 

    end


    RINV22_MUL_RINV34_i:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0;
    sel4=2'b10; // Rinv22*Rinv_34_i
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

    counter = counter_reg + 'b1;

    if(counter=='d3)begin
     next_state=RINV24_SEL_0; 
     counter='b0;         
    end
    else begin
     next_state=RINV22_MUL_RINV34_i;
    end

    end


    RINV24_SEL_0:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0; 
    sel4=2'b00;
    sel5=1'b0; // Get Rinv_24_sel_0
    sel6=3'b000;
    sel7=1'b0;
    counter = 'b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

    counter = counter_reg + 'b1;

    if(counter=='d2)begin
     next_state=RINV24_SEL_1; 
     counter='b0;         
    end
    else begin
     next_state=RINV24_SEL_0;
    end

    end


    RINV24_SEL_1:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0; 
    sel4=2'b00;
    sel5=1'b1; // Get Rinv_24_sel_1
    sel6=3'b000;
    sel7=1'b0;
    counter='b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

    counter = counter_reg + 'b1;

    if(counter=='d3)begin
     next_state=RINV11_MUL_RINV24_r; 
     counter='b0;         
    end
    else begin
     next_state=RINV24_SEL_1;
    end

    end



     ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////// Get Rinv_14 ////////////////////////////////////////////////////////// 
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

   // Is not important,as its function already finished in the previous states.remove ////////////////////
/*
    RINV11_MUL_RINV44:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0;
    sel4=2'b00; 
    sel5=1'b0;
    sel6=3'b000; // Rinv11*Rinv44
    sel7=1'b0;
    Enable_reciprocal=0;
    next_state=RINV11_MUL_RINV24_r;
    end
*/


    RINV11_MUL_RINV24_r:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0;
    sel4=2'b00; 
    sel5=1'b0;
    sel6=3'b001; // Rinv11*Rinv24_r
    sel7=1'b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

     counter = counter_reg + 'b1;

    if(counter=='d3)begin
     next_state=RINV11_MUL_RINV24_i; 
     counter='b0;         
    end
    else begin
     next_state=RINV11_MUL_RINV24_r;
    end

    end


    RINV11_MUL_RINV24_i:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0;
    sel4=2'b00; 
    sel5=1'b0;
    sel6=3'b010; // Rinv11*Rinv24_i
    sel7=1'b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

     counter = counter_reg + 'b1;

    if(counter=='d3)begin
     next_state=RINV11_MUL_RINV34_r; 
     counter='b0;         
    end
    else begin
     next_state=RINV11_MUL_RINV24_i;
    end

    end


    RINV11_MUL_RINV34_r:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0;
    sel4=2'b00; 
    sel5=1'b0;
    sel6=3'b011; // Rinv11*Rinv34_r
    sel7=1'b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

    counter = counter_reg + 'b1;

    if(counter=='d3)begin
     next_state=RINV11_MUL_RINV34_i; 
     counter='b0;         
    end
    else begin
     next_state=RINV11_MUL_RINV34_r;
     end

    end


    RINV11_MUL_RINV34_i:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0;
    sel4=2'b00; 
    sel5=1'b0;
    sel6=3'b100; // Rinv11*Rinv34_i
    sel7=1'b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

     counter = counter_reg + 'b1;

     if(counter=='d3)begin
     next_state=RINV14_SEL_0; 
     counter='b0;         
    end
    else begin
     next_state=RINV11_MUL_RINV34_i;
     end

    end



    RINV14_SEL_0:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0; 
    sel4=2'b00;
    sel5=1'b0; 
    sel6=3'b000;
    sel7=1'b0;  // Get Rinv_14_sel_0
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

    counter = counter_reg + 'b1;

    if(counter=='d3)begin
     next_state=RINV14_SEL_1; 
     counter='b0;         
    end
    else begin
     next_state=RINV14_SEL_0;
     end

    end



    RINV14_SEL_1:
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0; 
    sel4=2'b00;
    sel5=1'b0; 
    sel6=3'b000;
    sel7=1'b1; // Get Rinv_14_sel_1
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;

    counter = counter_reg + 'b1;

    if(counter=='d4)begin
     R_inverse_done=1'b1;   
     next_state=IDLE; // return to the beginning,if i want to begin another cylce,i must send an enable,else i will remain in idle
     counter='b0;         
    end
    else begin
     next_state=RINV14_SEL_1;
     end

    end

/*
    STOP: // waste a cycle
    begin
    sel1=2'b00; 
    sel2=2'b00; 
    sel3=1'b0; 
    sel4=2'b00;
    sel5=1'b0; 
    sel6=3'b000;
    sel7=1'b0; //store Rinv_24_sel_1
    //Enable_reciprocal=0;
    counter='b0;
    next_state=STOP;
    end 
*/
    default:
    begin
    next_state=IDLE;                 
    sel1=2'b00;
    sel2=2'b00;
    sel3=1'b0;
    sel4=2'b00;
    sel5=1'b0;
    sel6=3'b000;
    sel7=1'b0; 
    counter='b0;
    Enable_register_R12=1'b0;
    Enable_register_R13=1'b0;
    Enable_register_Rinv22_44=1'b0;
    end

    endcase
end

endmodule