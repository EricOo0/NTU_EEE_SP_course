clear
clc
load label_train
load data_test
load data_train
load W_som_Con
train_data=data_train;%% 330*33
cvindex = crossvalind("Kfold",size(train_data,1),10);
% center=W_som_Con;%% 16*33
% [idx,C] = kmeans(data_train,16);
center=W_som_Con;
sum_accuracy=0;
accuracy_best=0;
a=[];
%10-fold
for i=1:10
    test_index=(cvindex == i);
    train_index = ~test_index;
    valid_data=train_data(test_index,:);
    valid_label=label_train(test_index,:);
    label=label_train(train_index,:);
    data=train_data(train_index,:);
%label=label_train;
 %data=train_data;
    max_disance=0;
    %Compute the max distance
    for i=1:size(data,1)
        for j=1:size(data,1)
            if max_disance<norm(data(i,:)-data(j,:))
                max_disance=norm(data(i,:)-data(j,:));
            end
        end
    end
    %Compute sigma
    sigma=max_disance/sqrt(2*size(center,1));
    %computer fhi %330*16
    for i=1:size(data,1)
        xk=data(i,:);%% 1*33
        for j=1:size(center,1)%16
            sum=0;
            for k=1:size(center,2)%33
                sum=sum+(xk(k)-center(j,k))^2;
            fhi(i,j)=exp(sum/(-2*sigma^2));
            end
        end
    end
    %compute w
    d=label;%% 330*1
    %W_RBF=pinv(fhi'*fhi)*fhi'*d*10
    W_RBF=pinv(fhi'*fhi)*fhi'*d;
    Predict_result=fhi*W_RBF;
    length(Predict_result);
    for i=1:length(Predict_result)
        if (Predict_result(i)>=0)
            Predict_result(i)=1;
        else
            Predict_result(i)=-1;
        end
    end
    sum_Predict_result=0;
    for i=1:length(label)
        if(Predict_result(i)==label(i))
            sum_Predict_result=sum_Predict_result+1;
        end
    end
    accuracy=sum_Predict_result/length(label);
    disp(['traning_accuracy while RBF centers is computed by SOM:= ',num2str(accuracy)]);
    
    %validation
    size(valid_data,1);
    for i=1:size(valid_data,1)
        xk=valid_data(i,:);%% 1*33
        for j=1:size(center,1)%16
            sum=0;
            for k=1:size(center,2)%33
                sum=sum+(xk(k)-center(j,k))^2;
            fhi2(i,j)=exp(sum/(-2*sigma^2));
            end
        end
    end
   validation_result=fhi2*W_RBF;
    for i=1:length(validation_result)
        if (validation_result(i)>=0)
            validation_result(i)=1;
        else
           validation_result(i)=-1;
        end
    end
    sum_Valid_result=0;
   for i=1:length(valid_label)
        if(validation_result(i)==valid_label(i))
            sum_Valid_result=sum_Valid_result+1;
        end
    end
    accuracy=sum_Valid_result/length(valid_label);
    a=[a;accuracy];
    disp(['validation_accuracy while RBF centers is computed by SOM:= ',num2str(accuracy)]);
    sum_accuracy = sum_accuracy+accuracy;
    if (accuracy > accuracy_best)
        accuracy_best=accuracy;
        best_w=W_RBF;
    end
end
disp(['average_accuracy while RBF centers is computed by SOM:= ',num2str(sum_accuracy/10)]);
disp(['best_accuracy while RBF centers is computed by SOM:= ',num2str(accuracy_best)]);
W_RBF=best_w;%用最好的w



%test data
size(data_test,1)
for i=1:size(data_test,1)
    xk=data_test(i,:);%% 1*33
    for j=1:size(center,1)%16
        sum=0;
        for k=1:size(center,2)%33
            sum=sum+(xk(k)-center(j,k))^2;
        fhi3(i,j)=exp(sum/(-2*sigma^2));
        end
    end
end
Predict_result2=fhi3*W_RBF;
xlswrite('Predict_result_test_data_before.xls',Predict_result2)
for i=1:length(Predict_result2)
    if (Predict_result2(i)>=0)
        Predict_result2(i)=1;
    else
        Predict_result2(i)=-1;
    end
end

Predict_result2;
plot(Predict_result2,'rx')
xlswrite('Predict_result_test_data.xls',Predict_result2)
    
