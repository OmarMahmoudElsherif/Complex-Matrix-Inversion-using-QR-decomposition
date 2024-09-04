function [x_out,y_out] = cordic_rotation_fixed(x,y,theta_in,iterations)

%Note that : theta is passed as a radian

%% Fixed Point Parameters
nt = numerictype(x);
Word_length = nt.WordLength;
Fraction_length = nt.FractionLength;
Fixed_arrtibutes = fimath('SumMode', 'SpecifyPrecision', 'SumWordLength', Word_length,'SumFractionLength', Fraction_length, 'ProductMode', 'SpecifyPrecision', 'ProductWordLength', Word_length,'ProductFractionLength', Fraction_length, 'RoundingMethod', 'Floor', 'OverflowAction', 'Wrap');


%% Fixed Point Constants

two_pi      = fi(2*pi,1,Word_length,Fraction_length,Fixed_arrtibutes);
neg_two_pi  = fi(-2*pi,1,Word_length,Fraction_length,Fixed_arrtibutes);
half_pi     = fi(pi/2,1,Word_length,Fraction_length,Fixed_arrtibutes);
neg_half_pi = fi(-pi/2,1,Word_length,Fraction_length,Fixed_arrtibutes);
one_pi      = fi(pi,1,Word_length,Fraction_length,Fixed_arrtibutes);
one_half_pi = fi(3*pi/2,1,Word_length,Fraction_length,Fixed_arrtibutes);
neg_one_half_pi = fi(-3*pi/2,1,Word_length,Fraction_length,Fixed_arrtibutes);
% scale value
Kn = fi(0.6073,1,Word_length,Fraction_length,Fixed_arrtibutes);

%% Fixed Point Variables

x_new = fi(0,1,Word_length,Fraction_length,Fixed_arrtibutes);
y_new = fi(0,1,Word_length,Fraction_length,Fixed_arrtibutes);


%% LUT for tan^-1 
tan_inv_lut = fi(zeros(1,iterations),1,Word_length,Fraction_length,Fixed_arrtibutes);
for L = 1:iterations 
    tan_inv_lut(1,L) = atan(bitsra(1,L-1)); 
end


%% Quadrant Corrector %%

if(theta_in >= two_pi)
    theta = theta_in - two_pi;
end
if(theta_in <= neg_two_pi)
    theta = theta_in + two_pi;
end

if(theta_in >= (half_pi) && theta_in <= (one_half_pi))
    theta = theta_in - one_pi;
elseif(theta_in <= (two_pi) && theta_in > (one_half_pi))
    theta = theta_in - two_pi;
elseif(theta_in <= (neg_half_pi) && theta_in >= (neg_one_half_pi))
    theta = theta_in + one_pi;
elseif(theta_in >= (neg_two_pi) && theta_in < (neg_one_half_pi))
    theta = theta_in + two_pi;
else
    theta = theta_in;
end



%% Implemetation
for k = 0:iterations-1

    % determine sign for next iteration
    if(theta<0)
        direction = -1;
    else
        direction =  1;
    end

    x_new = (x - direction*bitsra(y,k) );
    y_new = (y + direction*bitsra(x,k));
    % calculating new theta
    theta = theta-direction*tan_inv_lut(1,k+1);

    x = x_new;
    y = y_new;
end

%% Quadrant Sign Corrector %%

if(theta_in >= (half_pi) && theta_in <= (one_half_pi))
    x_out = -(x_new * Kn);
    y_out = -(y_new * Kn);
elseif(theta_in <= (two_pi) && theta_in > (one_half_pi))
    x_out = x_new * Kn;
    y_out = y_new * Kn;
elseif(theta_in <= (neg_half_pi) && theta_in >= (neg_one_half_pi))
    x_out = -(x_new * Kn);
    y_out = -(y_new * Kn);
else
    x_out = x_new * Kn;
    y_out = y_new * Kn;
end


end

