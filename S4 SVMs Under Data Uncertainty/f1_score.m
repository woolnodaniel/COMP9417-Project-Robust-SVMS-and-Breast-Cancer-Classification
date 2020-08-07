
function acc = f1_score(targ, pred)
    % need to map -1 to 0 in both target and prediction to use MATLABs roc
    %targ = 0.5*(targ+1);
    %pred = 0.5*(pred+1);
    C = confusionmat(targ, pred);
    TP = C(1,1); 
    FP = C(2,1);
    FN = C(1,2);
    acc = TP/(TP + 0.5*(FP + FN));
end