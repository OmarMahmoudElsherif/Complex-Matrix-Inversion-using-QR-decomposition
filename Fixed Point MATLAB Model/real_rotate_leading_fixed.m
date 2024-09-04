function [theta,R] = real_rotate_leading_fixed(R,i, iterations)

%% Convert the leading element to real value and rotate rest of elements %% 

% First Step : get the angle of the leading element 
[theta,R(i,i)] = cordic_vectoring_fixed(real(R(i,i)),imag(R(i,i)),iterations);
% Second Step : Rotate the row with angle of leading element
if(i==1)
    [R12_r,R12_i] = cordic_rotation_fixed(real(R(i,i+1)),imag(R(i,i+1)),-theta,iterations);
    [R13_r,R13_i] = cordic_rotation_fixed(real(R(i,i+2)),imag(R(i,i+2)),-theta,iterations);
    [R14_r,R14_i] = cordic_rotation_fixed(real(R(i,i+3)),imag(R(i,i+3)),-theta,iterations);
    R(i,i+1) = R12_r + R12_i*1i;    
    R(i,i+2) = R13_r + R13_i*1i;
    R(i,i+3) = R14_r + R14_i*1i;
elseif(i==2) 
    [R23_r,R23_i] = cordic_rotation_fixed(real(R(i,i+1)),imag(R(i,i+1)),-theta,iterations);
    [R24_r,R24_i] = cordic_rotation_fixed(real(R(i,i+2)),imag(R(i,i+2)),-theta,iterations);
    R(i,i+1) = R23_r + R23_i*1i;
    R(i,i+2) = R24_r + R24_i*1i;
elseif(i==3)
    [R34_r,R34_i] = cordic_rotation_fixed(real(R(i,i+1)),imag(R(i,i+1)),-theta,iterations);
    R(i,i+1) = R34_r + R34_i*1i;
end


end