function [reciprocal] = cordic_reciprocal_fixed(x,iterations)

%% Fixed Point Parameters
nt = numerictype(x);
Word_length = nt.WordLength;
Fraction_length = nt.FractionLength;
Fixed_arrtibutes = fimath('SumMode', 'SpecifyPrecision', 'SumWordLength', Word_length,'SumFractionLength', Fraction_length, 'ProductMode', 'SpecifyPrecision', 'ProductWordLength', Word_length,'ProductFractionLength', Fraction_length, 'RoundingMethod', 'Floor', 'OverflowAction', 'Wrap');

%% initializations
y = fi(1,1,Word_length,Fraction_length,Fixed_arrtibutes);
theta = fi(0,1,Word_length,Fraction_length,Fixed_arrtibutes);


%% Implemetation  
for k = 0:iterations-1
        
    % determine sign for next iteration
    if(y == 0) 
        direction = 0;
    elseif (y < 0)
        direction = 1;
    else 
        direction = -1;  
    end

    % Reciprocal CORDIC Equations
    y_new = y + direction*bitsra(x,k);
    theta = theta-direction*bitsra(1,k);

    y = y_new;
end


%% K = iterations-1
reciprocal= theta;
   
end
