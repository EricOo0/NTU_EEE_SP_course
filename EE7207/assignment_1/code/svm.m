load data_train
load label_train
load data_test
train_data=data_train;
sum_accuracy=0;
best_accuracy=0;
cvindex = crossvalind("Kfold",size(train_data,1),10);

for i=1:10
    i
    test_index=(cvindex == i);
    train_index = ~test_index;
    valid_data=train_data(test_index,:);
    valid_label=label_train(test_index,:);
    label=label_train(train_index,:);
    data=train_data(train_index,:);

    svmClassifier = fitcsvm(data,label,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto');
    [predic_labels, scores] = predict(svmClassifier, valid_data);
    count=0;
    for i=1:size(valid_data,1)
       if valid_label(i) == predic_labels(i)
           count=count+1;
       end
    end
    accuracy=count/length(valid_label);
    disp(['validation_accuracy  by svm:= ',num2str(accuracy)]);
    sum_accuracy = sum_accuracy+accuracy;
    if (accuracy > best_accuracy)
        best_accuracy=accuracy;
        best_svm=svmClassifier;
    end
  
end  
disp(['average_accuracy  by svm:= ',num2str(sum_accuracy/10)]);
disp(['best_accuracy  by svm:= ',num2str(best_accuracy)]);
    
all_classify=fitcsvm(data_train,label_train,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto');
all_result=predict(all_classify,data_test);
result=predict(best_svm,data_test);