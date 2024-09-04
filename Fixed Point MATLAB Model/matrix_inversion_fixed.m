function [Q_transpose, R] = matrix_inversion_fixed(A, iterations)
%% The Following Code is for 4x4 Matrix Inversion using QR Decomposition and Given Rotations %%

%% Fixed Point Parameters
nt = numerictype(A);
Word_length = nt.WordLength;
Fraction_length = nt.FractionLength;
Fixed_arrtibutes = fimath('SumMode', 'SpecifyPrecision', 'SumWordLength', Word_length,'SumFractionLength', Fraction_length, 'ProductMode', 'SpecifyPrecision', 'ProductWordLength', Word_length,'ProductFractionLength', Fraction_length, 'RoundingMethod', 'Floor', 'OverflowAction', 'Wrap');


%% Fixed Point Variables

Q_transpose = fi(complex(eye(4)),1,Word_length,Fraction_length,Fixed_arrtibutes);
R = A;


%% Convert the First leading element (R11) to real value %% 

[theta,R] = real_rotate_leading_fixed(R,1, iterations);


%% Get Q1 %%

%       [ exp(-phi_11)      0           0       0   ]
% Q_1 = [   0               1           0       0   ]
%       [   0               0           1       0   ]
%       [   0               0           0       1   ]
               
Q_transpose = Q_multiplications_fixed(Q_transpose,0,1,1,theta,0,iterations);


%% Null R21 , and rotating rest elements of 1st and 2nd rows  %% 

[theta,phi,R] = null_rotate_elements_fixed(R,2,1, iterations);

%% Get Q2 %%

%       [   cos(theta_21)  -sin(theta_21).exp(-phi_21)   0   0   ]
% Q_2 = [   sin(theta_21)   cos(theta_21).exp(-phi_21)   0   0   ]
%       [       0                        0               1   0   ]
%       [       0                        0               0   1   ]

Q_transpose = Q_multiplications_fixed(Q_transpose,1,2,1,theta,phi,iterations);


%% Null R31 , and rotating rest elements of 1st and 3rd rows  %% 

[theta,phi,R] = null_rotate_elements_fixed(R,3,1, iterations);


%% Get Q3 %%

%       [   cos(theta_31)    0   -sin(theta_31).exp(-phi_31)    0   ]
% Q_3 = [        0           1                 0                0   ]
%       [   sin(theta_31)    0    cos(theta_31).exp(-phi_31)    0   ]
%       [        0           0                 0                1   ]

Q_transpose = Q_multiplications_fixed(Q_transpose,1,3,1,theta,phi,iterations);

%% Null R41 , and rotating rest elements of 1st and 4th rows  %% 

[theta,phi,R] = null_rotate_elements_fixed(R,4,1, iterations);

%% Get Q4 %%

%       [   cos(theta_41)    0     0    -sin(theta_41).exp(-phi_41)   ]
% Q_4 = [        0           1     0                  0               ]
%       [        0           0     1                  0               ]
%       [   sin(theta_41)    0     0     cos(theta_41).exp(-phi_41)   ]

Q_transpose = Q_multiplications_fixed(Q_transpose,1,4,1,theta,phi,iterations);
                     
%% Convert the Second leading element (R22) to real value %% 

[theta,R] = real_rotate_leading_fixed(R,2, iterations);

%% Get Q5 %%

%       [   1       0           0       0   ]
% Q_5 = [   0  exp(-phi_22)     0       0   ]
%       [   0       0           1       0   ]
%       [   0       0           0       1   ]

Q_transpose = Q_multiplications_fixed(Q_transpose,0,2,2,theta,phi,iterations);

%% Null R32 , and rotating rest elements of 2nd and 3rd rows  %% 

[theta,phi,R] = null_rotate_elements_fixed(R,3,2, iterations);

%% Get Q6 %%

%       [   1         0                      0                  0   ]
% Q_6 = [   0   cos(theta_32)  -sin(theta_32).exp(-phi_32)      0   ]
%       [   0   sin(theta_32)   cos(theta_32).exp(-phi_32)      0   ]
%       [   0         0                      0                  1   ]

Q_transpose = Q_multiplications_fixed(Q_transpose,1,3,2,theta,phi,iterations);
            
%% Null R42 , and rotating rest elements of 2nd and 4th rows  %% 

[theta,phi,R] = null_rotate_elements_fixed(R,4,2, iterations);

%% Get Q7 %%

%       [   1         0          0                 0                ]
% Q_7 = [   0   cos(theta_42)    0   -sin(theta_42).exp(-phi_42)    ]
%       [   0        0           1                 0                ]
%       [   0   sin(theta_42)    0    cos(theta_42).exp(-phi_42)    ]

Q_transpose = Q_multiplications_fixed(Q_transpose,1,4,2,theta,phi,iterations);
                    
%% Convert the Third leading element (R33) to real value %% 

[theta,R] = real_rotate_leading_fixed(R,3, iterations);

%% Get Q8 %%

%       [   1       0         0       0   ]
% Q_8 = [   0       1         0       0   ]
%       [   0       0   exp(-phi_33)  0   ]
%       [   0       0         0       1   ]

Q_transpose = Q_multiplications_fixed(Q_transpose,0,3,3,theta,phi,iterations);

%% Null R43 , and rotating rest elements of 3rd and 4th rows  %% 

[theta,phi,R] = null_rotate_elements_fixed(R,4,3, iterations);

%% Get Q9 %%

%       [   1    0         0                         0              ]
% Q_9 = [   0    1         0                         0              ]
%       [   0    0    cos(theta_43)    -sin(theta_43).exp(-phi_43)  ]
%       [   0    0    sin(theta_43)     cos(theta_43).exp(-phi_43)  ]

Q_transpose = Q_multiplications_fixed(Q_transpose,1,4,3,theta,phi,iterations);
           
%% Convert the Fourth leading element (R44) to real value %% 

[theta,R] = real_rotate_leading_fixed(R,4, iterations);

%% Get Q10 %%

%        [   1       0      0       0          ]    
% Q_10 = [   0       1      0       0          ]
%        [   0       0      1       0          ]
%        [   0       0      0   exp(-phi_33)   ]

Q_transpose = Q_multiplications_fixed(Q_transpose,0,4,4,theta,phi,iterations);

end