splitVal = 0.2;
ds = readmatrix('processed_data.csv');
m = size(ds,1) %number of data points
n = size(ds,2) %number of features (including target)
%recall: class distribution is slightly unbalanced
fprintf("Proportion of classes that are negative: %.1f%%\n", sum(ds(:,1)==-1)/m*100)
%shuffle rows for proper randomisation
P = randperm(m);
ds = ds(P,:);
%split into datapoints/target and training/test sets
splitIndex = floor(m*(1-splitVal));
X_train = ds(1:splitIndex,2:end); y_train = ds(1:splitIndex,1);
X_test = ds(splitIndex+1:end,2:end); y_test = ds(splitIndex+1:end,1);

kf_split = 5;
lambda = [0:0.05:1];
lambda(1) = 0.01;
best_acc = 0;
best_l = 0;
for l = lambda
    model = standardSVM(l);
    accs = zeros(kf_split,1);
    [t, v] = kfolds_index(X_train, kf_split);
    for i = 1:kf_split
        train_index = t{i};
        val_index = v{i};
        X_train_kf = X_train(train_index,:);
        X_val_kf = X_train(val_index,:);
        y_train_kf = y_train(train_index);
        y_val_kf = y_train(val_index);
        try
            model.fit(X_train_kf, y_train_kf);
            accs(i) = accuracy(y_val_kf, model.predict(X_val_kf));
        catch
            accs(i) = 0;
        end
    end
    if mean(accs) > best_acc
        best_acc = mean(accs);
        best_l = l;
    end
    fprintf("Here\n");
end
fprintf("Highest Mean Accuracy of %.2f achieved by r = %.2f\n", best_acc, best_l)