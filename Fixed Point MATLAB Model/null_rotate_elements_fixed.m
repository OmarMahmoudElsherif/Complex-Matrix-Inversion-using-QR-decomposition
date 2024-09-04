function [theta,phi,R] = null_rotate_elements_fixed(R,r,c, iterations)

%% Null Rji , and rotating rest elements of (c)th and (r)th rows  %%


% Step 1: Null Rji
%  - get theta (angle between Rji and Rii)
%  - get phi (angle of Rji)
[phi,theta,R(c,c)] = Super_cordic_vectoring_fixed(R(c,c),real(R(r,c)),imag(R(r,c)),iterations);
R(r,c)=0;
% rotate Rij by phi_ji and theta_ji
%        Rjj
[temp1_r,temp1_i,temp2_r,temp2_i]= Super_cordic_rotation_fixed(real(R(c,r)),imag(R(c,r)),real(R(r,r)),imag(R(r,r)),-theta,-phi,iterations);
R(c,r) = temp1_r + temp1_i*1i;
R(r,r) = temp2_r + temp2_i*1i;

% First Column
if(c==1)
    if(r==2)
        % Step 2: rotate    R13  R14   by phi_21 and theta_21
        %                   R23  R24
        [temp1_r,temp1_i,temp2_r,temp2_i]= Super_cordic_rotation_fixed(real(R(c,r+1)),imag(R(c,r+1)),real(R(r,r+1)),imag(R(r,r+1)),-theta,-phi,iterations);
        R(c,r+1) = temp1_r + temp1_i*1i;
        R(r,r+1) = temp2_r + temp2_i*1i;
        [temp1_r,temp1_i,temp2_r,temp2_i]= Super_cordic_rotation_fixed(real(R(c,r+2)),imag(R(c,r+2)),real(R(r,r+2)),imag(R(r,r+2)),-theta,-phi,iterations);
        R(c,r+2) = temp1_r + temp1_i*1i;
        R(r,r+2) = temp2_r + temp2_i*1i;

    elseif(r==3)
        % Step 2: rotate  R12  R14   by phi_31 and theta_31
        %                 R32  R34
        [temp1_r,temp1_i,temp2_r,temp2_i]= Super_cordic_rotation_fixed(real(R(c,r-1)),imag(R(c,r-1)),real(R(r,r-1)),imag(R(r,r-1)),-theta,-phi,iterations);
        R(c,r-1) = temp1_r + temp1_i*1i;
        R(r,r-1) = temp2_r + temp2_i*1i;
        [temp1_r,temp1_i,temp2_r,temp2_i]= Super_cordic_rotation_fixed(real(R(c,r+1)),imag(R(c,r+1)),real(R(r,r+1)),imag(R(r,r+1)),-theta,-phi,iterations);
        R(c,r+1) = temp1_r + temp1_i*1i;
        R(r,r+1) = temp2_r + temp2_i*1i;

    elseif(r==4)
        % Step 2: rotate  R12  R13  by phi_41 and theta_41
        %                 R42  R43
        [temp1_r,temp1_i,temp2_r,temp2_i]= Super_cordic_rotation_fixed(real(R(c,r-2)),imag(R(c,r-2)),real(R(r,r-2)),imag(R(r,r-2)),-theta,-phi,iterations);
        R(c,r-2) = temp1_r + temp1_i*1i;
        R(r,r-2) = temp2_r + temp2_i*1i;
        [temp1_r,temp1_i,temp2_r,temp2_i]= Super_cordic_rotation_fixed(real(R(c,r-1)),imag(R(c,r-1)),real(R(r,r-1)),imag(R(r,r-1)),-theta,-phi,iterations);
        R(c,r-1) = temp1_r + temp1_i*1i;
        R(r,r-1) = temp2_r + temp2_i*1i;
    end

% Second Column
elseif(c==2)
    if(r==3)
        % Step 2: rotate  R24    by phi_32 and theta_32
        %                 R34
        [temp1_r,temp1_i,temp2_r,temp2_i]= Super_cordic_rotation_fixed(real(R(c,r+1)),imag(R(c,r+1)),real(R(r,r+1)),imag(R(r,r+1)),-theta,-phi,iterations);
        R(c,r+1) = temp1_r + temp1_i*1i;
        R(r,r+1) = temp2_r + temp2_i*1i;
    elseif(r==4)
        % Step 2: rotate  R23 by phi_42 and theta_42
        %                 R43
        [temp1_r,temp1_i,temp2_r,temp2_i]= Super_cordic_rotation_fixed(real(R(c,r-1)),imag(R(c,r-1)),real(R(r,r-1)),imag(R(r,r-1)),-theta,-phi,iterations);
        R(c,r-1) = temp1_r + temp1_i*1i;
        R(r,r-1) = temp2_r + temp2_i*1i;
    end

end

end