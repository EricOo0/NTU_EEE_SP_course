function [R]=fuzzymm(A,B)
%模糊矩阵合成运算(模糊矩阵相乘)的Matlab实现
%运算规则，先"取小后取大"
%输入必须为二阶矩阵A为m行n列, B为n行p列;
[m,n]=size(A);[q,p]=size(B);%获得输入矩阵的维度信息
if n~=q
    disp('第一个矩阵的列数和第二个矩阵的行数不相同！');
else
    R=zeros(m,p);%初始化矩阵
for k =1:m    
    for j=1:p
        temp=[];
        for i =1:n
            Min = min(A(k,i),B(i,j)); %求出第i对的最小值
            temp=[temp Min]; %将求出的最小值加入的数组中
        end
        R(k,j)=max(temp);
    end
end
end
end