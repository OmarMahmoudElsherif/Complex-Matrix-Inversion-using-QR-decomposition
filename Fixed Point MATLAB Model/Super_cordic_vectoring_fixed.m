function [phi,theta,x_out] = Super_cordic_vectoring_fixed(x,y_r,y_i,iterations)
%% Inputs:
% 1) x : real number
% 2) y_r : real part  
% 3) y_i : imaginary part 

%% Outputs:
% 1) x_out : real number
% 2) theta 
% 3) phi

[ phi , mag_y ]     = cordic_vectoring_fixed(y_r,y_i,iterations);
[ theta , x_out ]   = cordic_vectoring_fixed(x,mag_y,iterations);
end