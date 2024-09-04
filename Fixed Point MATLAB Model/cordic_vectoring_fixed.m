function [theta,mag] = cordic_vectoring_fixed(x,y,iterations)


%% Fixed Point Parameters

nt = numerictype(x);
Word_length = nt.WordLength;
Fraction_length = nt.FractionLength;
Fixed_arrtibutes = fimath('SumMode', 'SpecifyPrecision', 'SumWordLength', Word_length,'SumFractionLength', Fraction_length, 'ProductMode', 'SpecifyPrecision', 'ProductWordLength', Word_length,'ProductFractionLength', Fraction_length, 'RoundingMethod', 'Floor', 'OverflowAction', 'Wrap');


%% Fixed Point Variables

x_new   = fi(0,1,Word_length,Fraction_length,Fixed_arrtibutes);
y_new   = fi(0,1,Word_length,Fraction_length,Fixed_arrtibutes);
theta_temp = fi(0,1,Word_length,Fraction_length,Fixed_arrtibutes);
mag = fi(0,1,Word_length,Fraction_length,Fixed_arrtibutes);

one_pi  = fi(pi,1,Word_length,Fraction_length,Fixed_arrtibutes);
Kn      = fi(0.6073,1,Word_length,Fraction_length,Fixed_arrtibutes);

%% LUT for tan^-1 
tan_inv_lut = fi(zeros(1,iterations),1,Word_length,Fraction_length,Fixed_arrtibutes);
for L = 1:iterations 
    tan_inv_lut(1,L) = atan(bitsra(1,L-1)); 
end



%% determine which Quadrant we are in
if (x < 0)
    negative_flag =1;
    x = -x;
else
    negative_flag =0;
    x   =  x;
end
if(y > 0)
   sign_y =  1;
else
   sign_y =  -1;
end



    %% Implemetation
for k = 0:iterations-1

% determine sign for next iteration
if(y >= 0)
    a = -1;
else
    a =  1;
end

x_new = (x - a*bitsra(y,k) );
y_new = (y + a*bitsra(x,k));
% calculating new theta
theta_temp = theta_temp-a*tan_inv_lut(1,k+1);

x = x_new;
y = y_new;
end

%% K = iterations-1

mag = x_new*Kn;

% get correct theta depending on the Quadrant
if(negative_flag==0)
   theta = theta_temp;
else
   theta = (one_pi - sign_y*theta_temp)*sign_y;
end

%Note that : theta is generated as a radian
end



