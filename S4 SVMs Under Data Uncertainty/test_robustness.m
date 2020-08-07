%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Load data and split into training/test sets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

splitVal = 0.2; %percentage of dataset split to test set
%import into a matrix
ds = readmatrix('processed_data.csv');
m = size(ds,1); %number of data points
n = size(ds,2); %number of features (including target)
%shuffle rows for proper randomisation
P = randperm(m);
ds = ds(P,:);
%split into datapoints/target and training/test sets
splitIndex = floor(m*(1-splitVal));
X_train = ds(1:splitIndex,2:end); y_train = ds(1:splitIndex,1);
X_test = ds(splitIndex+1:end,2:end); y_test = ds(splitIndex+1:end,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Run simulation tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_sims = 10;

%to store results
std_accs = zeros(1,num_sims);
std_f1s = zeros(1,num_sims);
l1_accs = zeros(1,num_sims);
l1_f1s = zeros(1,num_sims);
dr_accs = zeros(1,num_sims);
dr_f1s = zeros(1,num_sims);
rob_accs = zeros(1,num_sims);
rob_f1s = zeros(1,num_sims);

%models
std = standardSVM(0.15);
l1 = L1SVM(0.15);
dr = DrSVM(2.0);
rob = robustSVM(0.25);
    
for s = 1:num_sims
    
    %generate uncertainty radii
    p = splitIndex;
    n = size(X_train,2);
    r = 0.5*rand(p,1); %perturbation up to half of a standard deviation
    
    %generate perturbations: for i=1:p, perturbation resides in ball centred at 0, radius r_i
    U = zeros(p,n);
    for i=1:p
        %to generate random points in a ball, generate random point, make unit vector, and multiply by random radius
        u = 2*rand(1,n)-1;
        u = u/norm(u,2);
        U(i,:) = u*r(i)*rand(1);
    end
    
    %new training data
    X_train_perturbed = X_train + U;
    
    %test
    [acc, f1] = std.run(X_train_perturbed,y_train,X_test,y_test);
    std_accs(s) = acc;
    std_f1s(s) = f1;
    
    [acc, f1] = l1.run(X_train_perturbed,y_train,X_test,y_test);
    l1_accs(s) = acc;
    l1_f1s(s) = f1;
    
    [acc, f1] = dr.run(X_train_perturbed,y_train,X_test,y_test);
    dr_accs(s) = acc;
    dr_f1s(s) = f1;
    
    [acc, f1] = rob.run(X_train_perturbed,y_train,X_test,y_test,r);
    rob_accs(s) = acc;
    rob_f1s(s) = f1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Print results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf("Results:\n")

%Standard Model
fprintf("Standard Accuracies: "); 
std_accs
fprintf(" Mean: %.4f\n", mean(std_accs));

fprintf("Standard F1s: "); 
std_f1s
fprintf(" Mean: %.4f\n", mean(std_f1s));

%L1 Model
fprintf("L1SVM Accuracies: "); 
l1_accs
fprintf(" Mean: %.4f\n", mean(l1_accs));

fprintf("L1SVM F1s: "); 
l1_f1s
fprintf(" Mean: %.4f\n", mean(l1_f1s));

%Dr Model
fprintf("DrSVM Accuracies: "); 
dr_accs
fprintf(" Mean: %.4f\n", mean(dr_accs));

fprintf("DrSVM F1s: "); 
dr_f1s
fprintf(" Mean: %.4f\n", mean(dr_f1s));

%Robust Model
fprintf("Robust Accuracies: "); 
rob_accs
fprintf(" Mean: %.4f\n", mean(rob_accs));

fprintf("Robust F1s: "); 
rob_f1s
fprintf(" Mean: %.4f\n", mean(rob_f1s));
