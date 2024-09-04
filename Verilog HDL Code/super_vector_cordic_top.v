// File : super_vector_cordic_top.v
// Author :
// Date : 28/4/2024
// Version : 1
// Abstract : this file contains a fixed-point implementation of super_vector_cordic_top used in QR decomposition
// 

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// Module ports list, declaration, and data type ///////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

module super_vector_cordic_top #(
        parameter NUMBER_OF_ITERATIONS = 11,
        parameter INT_WIDTH = 7,
        parameter FRACT_WIDTH = 11,
        parameter DATA_WIDTH = INT_WIDTH + FRACT_WIDTH
    )(
        ///////////////////////////// Inputs /////////////////////////////
        input   wire                           clk,
        input   wire                           rst_n,
        input   wire                           super_vector_cordic_enable,
        input   wire signed [DATA_WIDTH-1 : 0] input_1,
        input   wire signed [DATA_WIDTH-1 : 0] input_2_r,
        input   wire signed [DATA_WIDTH-1 : 0] input_2_i,
        
        ///////////////////////////// Outputs /////////////////////////////
        output  wire                            super_vector_cordic_valid,
        output  wire  signed [DATA_WIDTH-1 : 0] super_vector_ouput_mag,
        output  wire  signed [DATA_WIDTH-1 : 0] super_vector_output_angle_ceta,
        output  wire  signed [DATA_WIDTH-1 : 0] super_vector_output_angle_phi
    );
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////// Internal Connections /////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /////////////// connects outputs of 1st vector cordic with inputs of 2nd vector cordic ///////////////
    // valid signal of 1st vector cordic and enable signal of 2nd vector cordic
    wire vector_cordic_valid_1;
    
    // Output magnitude of 1st vector cordic which is magnitude of input 2
    wire  signed [DATA_WIDTH-1 : 0] ouput_mag_of_input_2;
    
    // Register to store input 1
    reg signed [DATA_WIDTH-1 : 0] input_1_reg;
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////// Sequential Logic //////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            
            // Clear register
            input_1_reg <= 'b0;
        end
        else begin
            
            // If enable is high store input 1
            if (super_vector_cordic_enable) begin
                
                // Store input 1
                input_1_reg <= input_1;
            end
        end
    end
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////// Instantiations ///////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////// Vector Cordic Instantiation 1  ///////////////////////////////////
    /*
        First vector cordic:
            Takes Real and Imaginary parts of input 2 and generate their magnitude and phi
    */
    vector_cordic #(
        .NUMBER_OF_ITERATIONS(NUMBER_OF_ITERATIONS),
        .INT_WIDTH(INT_WIDTH),
        .FRACT_WIDTH(FRACT_WIDTH)
    ) vector_cordic_instant_1 (
        ///////////////////////////// Inputs /////////////////////////////
        .clk(clk),
        .rst_n(rst_n),
        .vector_cordic_enable(super_vector_cordic_enable),
        .input_1(input_2_r),
        .input_2(input_2_i),
        
        ///////////////////////////// Outputs /////////////////////////////
        .vector_cordic_valid(vector_cordic_valid_1),
        .vector_ouput_mag(ouput_mag_of_input_2),
        .vector_output_angle(super_vector_output_angle_phi)
    );
    
    /////////////////////////////////// Vector Cordic Instantiation 2  ///////////////////////////////////
    /*
        Second vector cordic:
            1) Takes input 1 with magnitude of input 2 and generate output magnitude and ceta
            2) Set super_vector_cordic_valid when the second cordic finishes
    */
    vector_cordic #(
        .NUMBER_OF_ITERATIONS(NUMBER_OF_ITERATIONS),
        .INT_WIDTH(INT_WIDTH),
        .FRACT_WIDTH(FRACT_WIDTH)
    ) vector_cordic_instant_2 (
        ///////////////////////////// Inputs /////////////////////////////
        .clk(clk),
        .rst_n(rst_n),
        .vector_cordic_enable(vector_cordic_valid_1),
        .input_1(input_1_reg),
        .input_2(ouput_mag_of_input_2),
        
        ///////////////////////////// Outputs /////////////////////////////
        .vector_cordic_valid(super_vector_cordic_valid),
        .vector_ouput_mag(super_vector_ouput_mag),
        .vector_output_angle(super_vector_output_angle_ceta)
    );
    
endmodule
