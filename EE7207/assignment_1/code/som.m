clc,clear
load data_train
data=data_train;%%330*33 data
m=4;n=4;%%m*n network
rand('seed',5);
disp(size(data,2))
W_som=rand(m*n,size(data,2));%%25*33 weight   -radom generate m*n center  

%normalize to make sure the weights small
W_som=W_som./(sum(W_som,2)*10);
%Self-organizing phase
learning_rate_start=0.1;learning_rate=learning_rate_start;tao1=1000;%% learning rate change
sigma_start=2.121;sigma=sigma_start;tao2=1000/log(sigma);%% variance change
iterations = 1000;
[I,J]=ind2sub([m,n],1:m*n);% change to array index
length(I)
for iter=1:iterations
     for i=1:size(data,1)%330,data
        Sample=data(i,:);%%ith Sampleple
        % Compute W_somining neurons
        [minDist,win_index]=min(dist(Sample,W_som'));
        [win_row,win_col]=ind2sub([m,n],win_index);
        % distance
        for x=1:length(I)% I=m*n 遍历每个nerual 计算hij
            distance(x)=exp(((I(x)-win_row)^2+(J(x)-win_col)^2)/(-2*sigma^2));%gussion distance
        end
        % iterate W_som
        for j=1:m*n
            W_som(j,:)=W_som(j,:)+learning_rate*distance(j)*(Sample-W_som(j,:));%update w

        end
    end
    %change learning_rate and sigma
    learning_rate=learning_rate_start*exp(-iter/tao1);
    sigma=sigma_start*exp(-iter/tao2);
    if (learning_rate<0.01)
        learning_rate=0.01;
    end
end
save W_som;
%Convergence phase
W_som_Con=W_som;
iterations2=size(W_som,1)*500;
learning_rate2=0.01;%fixed
for iter=1:iterations2
     for i=1:size(data,1)%330,data
        Sample=data(i,:);%%ith Sampleple
        % Compute W_somwining neurons
        [minDist,win_index]=min(dist(Sample,W_som_Con'));
%         W_som_Con(win_index,:)=W_som_Con(win_index,:)+learning_rate2*(Sample-W_som_Con(win_index,:));
        [win_row,win_col]=ind2sub([m,n],win_index);
        % distance
        for x=1:length(I)
            if((I(x)==win_row)&&J(x)==win_col)
                distance(x)=1;
            else
                distance(x)=0;
            end              
        end
        % iterate W_som
        for j=1:m*n
            W_som_Con(j,:)=W_som_Con(j,:)+learning_rate2*distance(j)*(Sample-W_som_Con(j,:));
        end
     end
     k=iter/iterations2;
     for i=1:10
         if(k==(i*0.1))
             disp(i)%print i
         end
     end
end
save W_som_Con;
xlswrite('center_vectors_Con.xls',W_som_Con)
[idx,Center_kmeans] = kmeans(data_train,m*n);% choose the number you need 
save  Center_kmeans;
xlswrite('center_vectors_kmeans.xls',Center_kmeans)

 
%         string=sprintf('Numbers:%d',i);
%         title(string);
%         plot(W_som(:,j),W_som(:,i),'ro');hold on;
%         plot(Center_kmeans(:,j),Center_kmeans(:,i),'kx');
%     end
% end