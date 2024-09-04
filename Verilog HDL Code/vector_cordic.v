// File : vector_cordic.v
// Author :
// Date : 28/4/2024
// Version : 1
// Abstract : this file contains a fixed-point implementation of vector_cordic used in QR decomposition
// 

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// Module ports list, declaration, and data type ///////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

module vector_cordic #(
        parameter NUMBER_OF_ITERATIONS = 11,
        parameter INT_WIDTH = 7,
        parameter FRACT_WIDTH = 11,
        parameter DATA_WIDTH = INT_WIDTH + FRACT_WIDTH
    )(
        ///////////////////////////// Inputs /////////////////////////////
        input   wire                           clk,
        input   wire                           rst_n,
        input   wire                           vector_cordic_enable,
        input   wire signed [DATA_WIDTH-1 : 0] input_1,
        input   wire signed [DATA_WIDTH-1 : 0] input_2,
        
        ///////////////////////////// Outputs /////////////////////////////
        output  reg                            vector_cordic_valid,
        output  reg  signed [DATA_WIDTH-1 : 0] vector_ouput_mag,
        output  reg  signed [DATA_WIDTH-1 : 0] vector_output_angle
    );
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////             Constants            ///////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // pi in radian
    localparam PI = 'h01921; // pi with integer part = 7 && fraction part = 11
    
    // Number of Quadriants is 4
    localparam NUM_OF_QUADRANTS = 'd4;
    
    // Kn
    // since we will work with Number of iterations = 11 --> therefore Kn = 0.6072
    localparam Kn = 'h004db; // Kn with integer part = 7 && fraction part = 11
    
    //////////////////////////////////////// arctan memory //////////////////////////////////////// 
    // WIDTH = DATA_WIDTH
    // DEPTH = Number_of_Iterations
    reg [DATA_WIDTH-1 : 0] arctan_mem [0 : NUMBER_OF_ITERATIONS-1];
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// Signals and Internal Connections ///////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //////////////////////////// Inputs Registers ////////////////////////////
    reg signed [DATA_WIDTH-1 : 0] input_1_reg;
    reg signed [DATA_WIDTH-1 : 0] input_2_reg;
    
    //////////////////////////// Operands ////////////////////////////
    // Operands of CORDIC
    reg signed [DATA_WIDTH-1 : 0] opr_1_reg;
    reg signed [DATA_WIDTH-1 : 0] opr_2_reg;
    
    // Shifted operands
    wire signed [DATA_WIDTH-1 : 0] opr_1_shifted_wire;
    wire signed [DATA_WIDTH-1 : 0] opr_2_shifted_wire;
    
    // Multiply Operand 1 by Kn
    wire    signed      [DATA_WIDTH*2-1 : 0]      output_mag_long;
    wire    signed      [DATA_WIDTH-1 : 0]        output_mag_short;
    
    //////////////////////////// Quadriant Value ////////////////////////////
    // To determine quadriant where we are
    wire [$clog2(NUM_OF_QUADRANTS)-1 : 0] quadr_wire;
    
    //////////////////////////// operate register ////////////////////////////
    // register == 1 for cordic to operate and counter < NUMBER_OF_ITERATIONS
    reg operate_reg;
    
    //////////////////////////// Done Signals ////////////////////////////
    // Used to determine whether CORDIC finished or not
    wire done_wire;
    
    // done register to make valid signal pulse
    reg done_reg;
    
    //////////////////////////// Counter register ////////////////////////////
    reg [$clog2(NUMBER_OF_ITERATIONS)-1 : 0] count_reg;
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////// Sequential Logic //////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    always@(posedge clk or negedge rst_n)
    begin
        // if reset clear the registers
        if (!rst_n)
        begin
            // Clear outputs
            vector_ouput_mag    <= 'b0;
            vector_output_angle <= 'b0;
            vector_cordic_valid <= 'b0;
            
            // Clear input registers
            input_1_reg <= 'b0;
            input_2_reg <= 'b0;
            
            // Clear CORDIC operands
            opr_1_reg <= 'b0;
            opr_2_reg <= 'b0;
            
            // Clear counter register
            count_reg <= 'b0;
            
            // Clear operate register
            operate_reg <= 'b0;
            
            // Clear done register
            done_reg <= 'b0;
            
            //////////////////////////////////////// arctan memory ////////////////////////////////////////
            arctan_mem[0]  <= 'b000000011001001000; // value of arctan with integer part = 7 && fraction part = 11
            arctan_mem[1]  <= 'b000000001110110101; // value of arctan with integer part = 7 && fraction part = 11
            arctan_mem[2]  <= 'b000000000111110101; // value of arctan with integer part = 7 && fraction part = 11
            arctan_mem[3]  <= 'b000000000011111110; // value of arctan with integer part = 7 && fraction part = 11
            arctan_mem[4]  <= 'b000000000001111111; // value of arctan with integer part = 7 && fraction part = 11
            arctan_mem[5]  <= 'b000000000000111111; // value of arctan with integer part = 7 && fraction part = 11
            arctan_mem[6]  <= 'b000000000000011111; // value of arctan with integer part = 7 && fraction part = 11
            arctan_mem[7]  <= 'b000000000000001111; // value of arctan with integer part = 7 && fraction part = 11
            arctan_mem[8]  <= 'b000000000000000111; // value of arctan with integer part = 7 && fraction part = 11
            arctan_mem[9]  <= 'b000000000000000011; // value of arctan with integer part = 7 && fraction part = 11
            arctan_mem[10] <= 'b000000000000000001; // value of arctan with integer part = 7 && fraction part = 11
        end
        else
        begin
            
            // initailizations for CORDIC
            if (vector_cordic_enable)
            begin
                
                // Store inputs
                input_1_reg <= input_1;
                input_2_reg <= input_2;
                
                // Clear counter
                count_reg <= 'b0;
                
                // Activate Cordic
                operate_reg <= 'b1;
                
                // operand 2 = input 2
                opr_2_reg <= input_2;
                
                // Clear outputs
                vector_ouput_mag <= 'b0;
                vector_output_angle <= 'b0;
                vector_cordic_valid <= 'b0;
                
                // If input 1 is negative
                if(input_1[DATA_WIDTH-1])
                begin
                    
                    // operand 1 equals -ve input 1
                    opr_1_reg <= -input_1;
                end
                // else input 1 is positive
                else begin
                    
                    // operand 1 equal input 1
                    opr_1_reg <= input_1;
                end
            end
            
            // CORDIC Operation
            if((operate_reg) && (count_reg != NUMBER_OF_ITERATIONS))
            begin
                
                // Increment counter
                count_reg <= count_reg + 'b1;
                
                // determine direction from sign of operand 2
                /*
                    if Operand 2 is -ve:
                        operand 1 = operand 1 - operand 2 * 2^(-i)
                        operand 2 = operand 2 + operand 1 * 2^(-i)
                        angle = angle - atan(2^(-i))
                */
                if (opr_2_reg[DATA_WIDTH-1])
                begin
                    
                    // Operand 1
                    opr_1_reg <= opr_1_reg - opr_2_shifted_wire;
                    
                    // Operand 2
                    opr_2_reg <= opr_2_reg + opr_1_shifted_wire;
                    
                    // Angle
                    vector_output_angle <= vector_output_angle - arctan_mem[count_reg];
                end
                /*
                    if Operand 2 is +ve:
                        operand 1 = operand 1 + operand 2 * 2^(-i)
                        operand 2 = operand 2 - operand 1 * 2^(-i)
                        angle = angle + atan(2^(-i))
                */
                else
                begin
                    
                    // Operand 1
                    opr_1_reg <= opr_1_reg + opr_2_shifted_wire;
                    
                    // Operand 2
                    opr_2_reg <= opr_2_reg - opr_1_shifted_wire;
                    
                    // Angle
                    vector_output_angle <= vector_output_angle + arctan_mem[count_reg];
                end
                
            end
            
            // done_reg used to make valid signal pulse
            done_reg <= done_wire;
            
            /*
                If done_wire == 1 && done_reg == 0
                    1) Set Valid Signal
                    2) Deactivate cordic: Clear operate register
                    2) multply operand 1 by scale to get output magnitude
                    3) determine the quadriant to determine final value of ceta
                else
                    1) Clear Valid signal
                    2) output angle & output magnitude don't change them
            */
            if(done_wire && !(done_reg))
            begin
                
                // Clear Operate register
                operate_reg <= 'b0;
                
                // Set output done signal
                vector_cordic_valid <= 'b1;
                
                // Multply the magnitude by Kn
                vector_ouput_mag <= output_mag_short;
                
                // Determine Which quadriant using Case statement
                /*
                    Quadriant where we are:
                        if x is +ve and y +ve ---> 1st quadriant ---> quadr_wire = 'b00
                        if x is -ve and y +ve ---> 2nd quadriant ---> quadr_wire = 'b10
                        if x is -ve and y -ve ---> 3rd quadriant ---> quadr_wire = 'b11
                        if x is +ve and y -ve ---> 4th quadriant ---> quadr_wire = 'b01
                */
                case (quadr_wire)
                    
                    // If we are at 3rd quadriant
                    'b11:
                    begin
                        
                        // Ceta = -(pi + Ceta)
                        vector_output_angle <= -(PI + vector_output_angle);
                    end
                    // If we are at 2nd quadriant
                    'b10:
                    begin
                        
                        // Ceta = (pi - Ceta)
                        vector_output_angle <= PI - vector_output_angle;
                    end
                    // If we are 1st or 4th quadriant
                    default:
                    begin
                        
                        // Ceta = Ceta
                        vector_output_angle <= vector_output_angle;
                    end
                endcase
            end
            else begin
                
                // Clear valid signal
                vector_cordic_valid <= 'b0;
            end
        end
    end
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////// Combinational Logic ////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //////////////////////////// Done Wire ////////////////////////////
    // Rise done signal if counter == Number of iterations
    assign done_wire = (count_reg == NUMBER_OF_ITERATIONS)? 'b1 : 'b0;
    
    //////////////////////////// Shifting the operands ////////////////////////////
    assign opr_1_shifted_wire = opr_1_reg >>> count_reg;
    assign opr_2_shifted_wire = opr_2_reg >>> count_reg;
    
    //////////////////////////// Multiplying Operand 1 by Kn ////////////////////////////
    assign output_mag_long = opr_1_reg * Kn;
    assign output_mag_short = output_mag_long >>> FRACT_WIDTH;
    
    //////////////////////////// Quadriant Wire ////////////////////////////
    /*
        Quadriant where we are:
            if x is +ve and y +ve ---> 1st quadriant ---> quadr_wire = 'b00
            if x is -ve and y +ve ---> 2nd quadriant ---> quadr_wire = 'b10
            if x is -ve and y -ve ---> 3rd quadriant ---> quadr_wire = 'b11
            if x is +ve and y -ve ---> 4th quadriant ---> quadr_wire = 'b01
    */
    assign quadr_wire = {input_1_reg[DATA_WIDTH-1], input_2_reg[DATA_WIDTH-1]};
    
endmodule
