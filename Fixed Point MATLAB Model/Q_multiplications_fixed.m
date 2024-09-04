function [Q] = Q_multiplications_fixed(A,condition,row,col,theta,phi,iterations)
% row and column refers to the row and column of the leading element
if condition == 0 
    [A1_r,A1_i] = cordic_rotation_fixed(real(A(row,1)),imag(A(row,1)),-theta,iterations);
    [A2_r,A2_i] = cordic_rotation_fixed(real(A(row,2)),imag(A(row,2)),-theta,iterations);
    [A3_r,A3_i] = cordic_rotation_fixed(real(A(row,3)),imag(A(row,3)),-theta,iterations);
    [A4_r,A4_i] = cordic_rotation_fixed(real(A(row,4)),imag(A(row,4)),-theta,iterations);
    A(row,1)= A1_r+A1_i*1i;
    A(row,2)= A2_r+A2_i*1i;
    A(row,3) = A3_r+A3_i*1i;
    A(row,4)= A4_r+A4_i*1i;

else
    % shof hnakhod ay action 3ala (1,1) w 2,1) wala laa
%[m,n,o,p]= Super_cordic_rotation_fun(real(R(row,2)),imag(R(row,2)),real(R(column,2)),imag(R(column,2)),-theta1,-phi1,iterations);
% R(1,2)=m+n*1i;
% R(2,2)=o+p*1i;
[m,n,o,p]= Super_cordic_rotation_fixed(real(A(col,1)),imag(A(col,1)),real(A(row,1)),imag(A(row,1)),-theta,-phi,iterations);
A(col,1)=m+n*1i;
A(row,1)=o+p*1i;
%[real(R(1,2)),imag(R(1,2)),real(R(2,2)),imag(R(2,2))]
[m,n,o,p]= Super_cordic_rotation_fixed(real(A(col,2)),imag(A(col,2)),real(A(row,2)),imag(A(row,2)),-theta,-phi,iterations);
A(col,2)=m+n*1i;
A(row,2)=o+p*1i;
[m,n,o,p]= Super_cordic_rotation_fixed(real(A(col,3)),imag(A(col,3)),real(A(row,3)),imag(A(row,3)),-theta,-phi,iterations);
A(col,3)=m+n*1i;
A(row,3)=o+p*1i;
[m,n,o,p]= Super_cordic_rotation_fixed(real(A(col,4)),imag(A(col,4)),real(A(row,4)),imag(A(row,4)),-theta,-phi,iterations);
A(col,4)=m+n*1i;
A(row,4)=o+p*1i;
end
Q=A;
end


% [Q_temp(1,1), Q_temp(2,1)] = cordic_rotation_fun(1,0,-theta1, iterations); % 1,0 to get sin and cos "first column"
% [Q1_r,Q1_i,Q2_r,Q2_i] = Super_cordic_rotation_fun(0,0,1,0,-theta1,-phi1,iterations); % 0,1 to get sin exp and cos exp "sec column"
% Q_temp(1,2)=Q1_r+Q1_i*1i;
% Q_temp(2,2)=Q2_r+Q2_i*1i;
    