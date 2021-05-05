%Question 1
%A is the input image blockA
A=[20 20 10 10;
    20 20 10 10;
    0 0 0 0;
    0 0 0 0]; 
%use dct2 to perform the 2D-DCT transform of this image
B=dct2(A);

%Question 2
%matric is the input 6*6 image B
matric=[0 0 0 0 0 0;
    0 0 1 1 1 2;
    1 1 2 2 1 2;
    1 1 2 4 4 4;
    1 2 2 3 4 4;
    1 2 3 3 4 4];
%2.(a)X is to store the partitioned 4*1 block
X=[];
%partition the image into 2*2 block and order them to form 9 4*1 column vector
for i=1:2:size(matric)
    for j=1:2:size(matric)
        c=reshape(matric(i:i+1,j:j+1)',4,1);
        X=[X;c'];
    end
end
%calculate the mean vector of X
X_mean=mean(X);
%perform zero-mean centering and perform cov(x) to compute the covariance matrix 
x=(X-X_mean);
C=cov(x);
%2.(b)calculate the eigenvalue and eigenvector for the covariance matrix C
%V is eigenvector ; D is eigenvalue
[V,D]=eig(C);

%2.(c) perform reconstruction on an 2*2 block
block=[0 1 1 1 ];

%factor=V'*block
retained_comp=2;
%drop some eigenvector and keep the retained components
new_V=[zeros(size(V,1),size(V,2)-retained_comp)';V(:,size(V,2)-retained_comp+1:size(V,2))']';
%caculate factor ci; the value in corresponding direction after compression 
factor=block*new_V;
%reconstruct block
block_estimate=factor*new_V';
%calculate squared error using 2 dominant principal component
error=sse(block-block_estimate);


   