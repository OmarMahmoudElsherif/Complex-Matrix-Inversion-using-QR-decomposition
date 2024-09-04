// Multiplexer 3x1 using case statement
module mux3x1 #( 
    parameter   INT_LENGTH          =   5, 
    parameter   FRAC_LENGTH         =   12
) (
input      [1:0]                            sel,
input      [INT_LENGTH +FRAC_LENGTH - 1 :0] a, b, c,
output reg [INT_LENGTH +FRAC_LENGTH - 1 :0] outmux
);

always @(*)
begin
case(sel)
2'b00 :  outmux = a;
2'b01 :  outmux = b;
2'b10 :  outmux = c;
2'b11 :  outmux = 'b0;
default: outmux = 'b0;
endcase
end
endmodule