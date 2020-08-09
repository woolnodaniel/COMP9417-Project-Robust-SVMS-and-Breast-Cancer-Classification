
function [] = parameter_tune(model, kf_split, X, y)
    if isa(model, 'DrSVM')
        param = 2.^[-5:5];
    else
        param = [0:0.05:1];
        param(1) = 0.01;
    end
    best_acc = 0;
    best_p = 0;
    for p = param
        model.retune(p);
        accs = zeros(kf_split,1);
        [t, v] = kfolds_index(X, kf_split);
        for i = 1:kf_split
            train_index = t{i};
            val_index = v{i};
            X_train = X(train_index,:);
            X_val = X(val_index,:);
            y_train = y(train_index);
            y_val = y(val_index);
            try
                model.fit(X_train, y_train);
                accs(i) = accuracy(y_val, model.predict(X_val));
            catch
                accs(i) = 0;
            end
        end
        if mean(accs) > best_acc
            best_acc = mean(accs);
            best_p = p;
        end
    end
    fprintf("Highest Mean Accuracy of %.2f achieved by p = %.2f\n", best_acc, best_p)
end