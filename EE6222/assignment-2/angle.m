clc
clear
% 10 Degree
% normalized matrix A 
f = 112*29;
A1 = [747,583,f]; NA1 = A1./norm(A1);
A2 = [1900,694,f]; NA2 = A2./norm(A2);
A3 = [2371,1841,f]; NA3 = A3./norm(A3);
A4 = [2680,1846,f]; NA4 = A4./norm(A4);
A5 = [907,2443,f]; NA5 = A5./norm(A5);
A6 = [1416,2422,f]; NA6 = A6./norm(A6);
A7 = [1992,294,f]; NA7 = A7./norm(A7);
A8 = [3010,314,f]; NA8 = A8./norm(A8);

% normalized matrix B 
B1 = [21,370,f]; NB1 = B1./norm(B1);
B2 = [1330,560,f]; NB2 = B2./norm(B2);
B3 = [1841,1746,f]; NB3 = B3./norm(B3);
B4 = [2113,1747,f]; NB4 = B4./norm(B4);
B5 = [216,2412,f]; NB5 = B5./norm(B5);
B6 = [797,2371,f]; NB6 = B6./norm(B6);
B7 = [1433,156,f]; NB7 = B7./norm(B7);
B8 = [2440,254,f]; NB8 = B8./norm(B8);

%calculate the mean of two image matrixs
A=[[NA1(1),NA2(1),NA3(1),NA4(1),NA5(1),NA6(1),NA7(1),NA8(1)];
[NA1(2),NA2(2),NA3(2),NA4(2),NA5(2),NA6(2),NA7(2),NA8(2)];
[NA1(3),NA2(3),NA3(3),NA4(3),NA5(3),NA6(3),NA7(3),NA8(3)]];

B=[[NB1(1),NB2(1),NB3(1),NB4(1),NB5(1),NB6(1),NB7(1),NB8(1)];
[NB1(2),NB2(2),NB3(2),NB4(2),NB5(2),NB6(2),NB7(2),NB8(2)];
[NB1(3),NB2(3),NB3(3),NB4(3),NB5(3),NB6(3),NB7(3),NB8(3)]];

% Shift to center
mean_A = mean(A');
mean_B = mean(B');

A(1,:) = A(1,:)-mean_A(1);
A(2,:) = A(2,:)-mean_A(2);
A(3,:) = A(3,:)-mean_A(3);
B(1,:) = B(1,:)-mean_B(1);
B(2,:) = B(2,:)-mean_B(2);
B(3,:) = B(3,:)-mean_B(3);

% calculate SVD
W = A*B';
[U,S,V] = svd(W);
R = U*V';
thi = acos((trace(R)-1)/2);
rad2deg(thi)

% quaternion
K=[[W(1,1)+W(2,2)+W(3,3),W(3,2)-W(2,3),W(1,3)-W(3,1),W(2,1)-W(1,2)];
    [W(3,2)-W(2,3),W(1,1)-W(2,2)-W(3,3),W(1,2)+W(2,1),W(3,1)+W(1,3)];
    [W(1,3)-W(3,1),W(1,2)+W(2,1),-W(1,1)+W(2,2)-W(3,3),W(2,3)+W(3,2)];
    [W(2,1)-W(1,2),W(3,1)+W(1,3),W(2,3)+W(3,2),-W(1,1)-W(2,2)+W(3,3)]];
[m,v]=eig(K);
ev=diag(v);
[absv,abse]=sort(ev,'descend');
eigen_ve=m(:,abse);
thi_quternion=rad2deg(2*acos(eigen_ve(1,1)))