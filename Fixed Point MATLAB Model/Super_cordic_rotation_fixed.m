function [x_out_r,x_out_i,y_out_r,y_out_i] = Super_cordic_rotation_fixed(x_r,x_i,y_r,y_i,theta,phi,iterations)
%% Inputs:
% 1) x_r : real part of 1st input
% 2) x_i : imaginary part of 1st input
% 3) y_r : real part of 2nd input 
% 4) y_i : imaginary part of 2nd input
% 5) theta
% 6) phi

%% Outputs:
% 1) x_out_r : real part of 1st output
% 2) x_out_i : imaginary part of 1st output
% 3) y_out_r : real part of 2nd output
% 4) y_out_i : imaginary part of 2nd output

[t_r,t_i] = cordic_rotation_fixed(y_r,y_i,phi,iterations);
[x_out_r,y_out_r] = cordic_rotation_fixed(x_r,t_r,theta,iterations);
[x_out_i,y_out_i] = cordic_rotation_fixed(x_i,t_i,theta,iterations);

end