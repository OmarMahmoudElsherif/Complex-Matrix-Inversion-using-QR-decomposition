// Multiplexer 4x1 using case statement
module mux2x1 #( 
    parameter   INT_LENGTH          =   5, 
    parameter   FRAC_LENGTH         =   12
) (
input                                       sel,
input      [INT_LENGTH +FRAC_LENGTH - 1 :0] a, b,
output reg [INT_LENGTH +FRAC_LENGTH - 1 :0] outmux
);

always @(*)
begin
case(sel)
1'b0 :   outmux = a;
1'b1 :   outmux = b;
default: outmux = 'b0;
endcase
end
endmodule