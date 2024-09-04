function R_inv = R_inverse_fixed(R,iterations)

%% This Function is used to get the Inverse of R Matrix %%


%% Fixed Point Parameters
nt = numerictype(R);
Word_length = nt.WordLength;
Fraction_length = nt.FractionLength;
Fixed_arrtibutes = fimath('SumMode', 'SpecifyPrecision', 'SumWordLength', Word_length,'SumFractionLength', Fraction_length, 'ProductMode', 'SpecifyPrecision', 'ProductWordLength', Word_length,'ProductFractionLength', Fraction_length, 'RoundingMethod', 'Floor', 'OverflowAction', 'Wrap');


%% Fixed Point Variables

R_inv = fi(complex(eye(4)),1,Word_length,Fraction_length,Fixed_arrtibutes);


%% Implementation

% Range of Reciprocal CORDIC is from [0.5,infinity)
% So if it is below 0.5 we scale it up in order to get reciprocal properly
if R(1,1) < 0.5
    R_inv(1,1) = bitsll(real(R(1,1)),5);  % <<5
    R_inv(1,1) = cordic_reciprocal_fixed(real(R_inv(1,1)),iterations);
    R_inv(1,1) = bitsll(real(R_inv(1,1)),5);  % <<5
else
    R_inv(1,1) = cordic_reciprocal_fixed(real(R(1,1)),iterations);
end
if R(2,2) < 0.5
    R_inv(2,2) = bitsll(real(R(2,2)),5);  % <<5
    R_inv(2,2) = cordic_reciprocal_fixed(real(R_inv(2,2)),iterations);
    R_inv(2,2) = bitsll(real(R_inv(2,2)),5);  % <<5
else
    R_inv(2,2) = cordic_reciprocal_fixed(real(R(2,2)),iterations);
end
if R(3,3) < 0.5
    R_inv(3,3) = bitsll(real(R(3,3)),5);  % <<5
    R_inv(3,3) = cordic_reciprocal_fixed(real(R_inv(3,3)),iterations);
    R_inv(3,3) = bitsll(real(R_inv(3,3)),5);  % <<5
else
    R_inv(3,3) = cordic_reciprocal_fixed(real(R(3,3)),iterations);
end
if R(4,4) < 0.5
    R_inv(4,4) = bitsll(real(R(4,4)),5);  % <<5
    R_inv(4,4) = cordic_reciprocal_fixed(real(R_inv(4,4)),iterations);
    R_inv(4,4) = bitsll(real(R_inv(4,4)),5);  % <<5
else
    R_inv(4,4) = cordic_reciprocal_fixed(real(R(4,4)),iterations);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rinv_12 & Rinv_23 % Rinv_34

R_inv_12_tmp = R_inv(1,1)*R_inv(2,2) ;
R_inv(1,2) = - ( R_inv_12_tmp*R(1,2) );

R_inv_23_tmp = R_inv(2,2)*R_inv(3,3) ;
R_inv(2,3) = - ( R_inv_23_tmp*R(2,3) );


R_inv_34_tmp =    R_inv(3,3)*R_inv(4,4);
R_inv(3,4) = - (R_inv_34_tmp*R(3,4) );             
%%%%%%%%%%%%%%%%%%%%%%%% Different than RTL eqn, change it %%%%%%%%%%%  
% if(R_inv(4,4)>= 2^(Word_length-Fraction_length-3))
%     R_inv_34_tmp =    R_inv(3,3)*bitsra(R_inv(4,4),Scale); % scaling multiplication to prevent overflow , scale = 3
%     R_inv(3,4) = - (R_inv_34_tmp*R(3,4) );       
%     R_inv(3,4) = bitsll(R_inv(3,4),Scale);
% else
%     R_inv_34_tmp =    R_inv(3,3)*R_inv(4,4);
%     R_inv(3,4) = - (R_inv_34_tmp*R(3,4) );
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% R_inv_13
R_inv_13_par1_r_tmp=R_inv(1,1)*R_inv(3,3);
R_inv_13_par1_r=R_inv_13_par1_r_tmp*real(R(1,3));
R_inv_13_par2_r_tmp=R_inv(1,1)*real(R_inv(2,3));
R_inv_13_par2_r=R_inv_13_par2_r_tmp*real(R(1,2));
R_inv_13_par3_r_tmp=R_inv(1,1)*imag(R_inv(2,3));
R_inv_13_par3_r=R_inv_13_par3_r_tmp*imag(R(1,2));
R_inv_13_r = -  (R_inv_13_par1_r + R_inv_13_par2_r - R_inv_13_par3_r);

R_inv_13_par1_i_tmp=R_inv(1,1)*R_inv(3,3);
R_inv_13_par1_i=R_inv_13_par1_i_tmp*imag(R(1,3));
R_inv_13_par2_i_tmp=R_inv(1,1)*real(R_inv(2,3));
R_inv_13_par2_i=R_inv_13_par2_i_tmp*imag(R(1,2));
R_inv_13_par3_i_tmp=R_inv(1,1)*imag(R_inv(2,3));
R_inv_13_par3_i=R_inv_13_par3_i_tmp*real(R(1,2));
R_inv_13_i = - (R_inv_13_par1_i + R_inv_13_par2_i + R_inv_13_par3_i);

R_inv(1,3) = R_inv_13_r + 1i*R_inv_13_i;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% R_inv_24
R_inv_24_par1_r_tmp=R_inv(2,2)*R_inv(4,4);
R_inv_24_par1_r=R_inv_24_par1_r_tmp*real(R(2,4));
R_inv_24_par2_r_tmp=R_inv(2,2)*real(R_inv(3,4));
R_inv_24_par2_r=R_inv_24_par2_r_tmp*real(R(2,3));
R_inv_24_par3_r_tmp=R_inv(2,2)*imag(R_inv(3,4));
R_inv_24_par3_r=R_inv_24_par3_r_tmp*imag(R(2,3));
R_inv_24_r = -  (R_inv_24_par1_r + R_inv_24_par2_r - R_inv_24_par3_r);

R_inv_24_par1_i_tmp=R_inv(2,2)*R_inv(4,4);
R_inv_24_par1_i=R_inv_24_par1_i_tmp*imag(R(2,4));
R_inv_24_par2_i_tmp=R_inv(2,2)*real(R_inv(3,4));
R_inv_24_par2_i=R_inv_24_par2_i_tmp*imag(R(2,3));
R_inv_24_par3_i_tmp=R_inv(2,2)*imag(R_inv(3,4));
R_inv_24_par3_i=R_inv_24_par3_i_tmp*real(R(2,3));
R_inv_24_i = - (R_inv_24_par1_i + R_inv_24_par2_i + R_inv_24_par3_i);

R_inv(2,4) = R_inv_24_r + 1i*R_inv_24_i;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% R_inv_14
R_inv_14_par1_r_tmp=R_inv(1,1)*R_inv(4,4);
R_inv_14_par1_r=R_inv_14_par1_r_tmp*real(R(1,4));
R_inv_14_par2_r_tmp=R_inv(1,1)*real(R_inv(2,4));
R_inv_14_par2_r=R_inv_14_par2_r_tmp*real(R(1,2));
R_inv_14_par3_r_tmp=R_inv(1,1)*imag(R_inv(2,4));
R_inv_14_par3_r=R_inv_14_par3_r_tmp*imag(R(1,2));
R_inv_14_par4_r_tmp=R_inv(1,1)*real(R_inv(3,4));
R_inv_14_par4_r=R_inv_14_par4_r_tmp*real(R(1,3));
R_inv_14_par5_r_tmp=R_inv(1,1)*imag(R_inv(3,4));
R_inv_14_par5_r=R_inv_14_par5_r_tmp*imag(R(1,3));
R_inv_14_r = -  (R_inv_14_par1_r + R_inv_14_par2_r - R_inv_14_par3_r +R_inv_14_par4_r  - R_inv_14_par5_r);

R_inv_14_par1_i_tmp=R_inv(1,1)*R_inv(4,4);
R_inv_14_par1_i=R_inv_14_par1_i_tmp*imag(R(1,4));
R_inv_14_par2_i_tmp=R_inv(1,1)*real(R_inv(2,4));
R_inv_14_par2_i=R_inv_14_par2_i_tmp*imag(R(1,2));
R_inv_14_par3_i_tmp=R_inv(1,1)*imag(R_inv(2,4));
R_inv_14_par3_i=R_inv_14_par3_i_tmp*real(R(1,2));
R_inv_14_par4_i_tmp=R_inv(1,1)*real(R_inv(3,4));
R_inv_14_par4_i=R_inv_14_par4_i_tmp*imag(R(1,3));
R_inv_14_par5_i_tmp=R_inv(1,1)*imag(R_inv(3,4));
R_inv_14_par5_i=R_inv_14_par5_i_tmp*real(R(1,3));
R_inv_14_i = - (R_inv_14_par1_i + R_inv_14_par2_i + R_inv_14_par3_i + R_inv_14_par4_i + R_inv_14_par5_i);

R_inv(1,4) = R_inv_14_r + 1i*R_inv_14_i;


end
