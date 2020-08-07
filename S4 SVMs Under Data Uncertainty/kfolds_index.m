
function [train_ind, val_ind] = kfolds_index(X, kf_splits)
    % X: training instances to apply k-Folds to
    % kf_splits: Number of folds to create
    % Returns: ??_ind: cell of size kf_splits, each cell contains array of indices
    train_ind = cell(kf_splits,1);
    val_ind = cell(kf_splits,1);
    m = size(X,1);
    for i = 1:kf_splits
        split_index = [floor(m*(i-1)/kf_splits) floor(m*i/kf_splits)];
        train_ind{i} = [1:split_index(1) split_index(2)+1:m];
        val_ind{i} = split_index(1)+1:split_index(2);
    end
end