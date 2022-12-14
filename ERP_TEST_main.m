clc; clear; close all;

%% load data
load('data.mat'); 

%% Initialization
Maxiters = 500;  % Pre-defined maximum iterations 
e = 1e-5;
lam = 0.01; 

%% Training stage: run ERP estimation on the training set
num_train = length(Y_train);
lambda = lam*num_train;
disp('Running SBLEST_ERP');
[W,SF,TF,alpha] = SBLEST_ERP(X_train, Y_train, Maxiters, e, 2*lambda);

%% Test stage : predict labels in the test set
[X_all_test] = compute_X_all(X_test);
predict_Y = X_all_test'*vec(W);
accuracy = compute_acc(predict_Y, Y_test);
disp(['Test    Accuracy: ', num2str(accuracy)]);

%% reshape the dataset into two dimension
function [X_all,C,T] = compute_X_all(X)
M = length(X);
[C,T] = size(X{1,1});
X_all = zeros(C*T,M);
for m = 1:M
X_all(:,m) = vec(X{m});
end
end

%% Compute classification accuracy for test set
function accuracy = compute_acc (predict_Y, Y_test)
Y_predict = zeros(length(predict_Y),1);
for i = 1:length(predict_Y)
    if (predict_Y(i) > 0)
        Y_predict(i) = 1;
    else
        Y_predict(i) = -1;
    end
end
% Compute classification accuracy
error_num = 0;
total_num = length(predict_Y);
for i = 1:total_num
    if (Y_predict(i) ~= Y_test(i))
        error_num = error_num + 1;
    end
end
accuracy = (total_num-error_num)/total_num;
end
