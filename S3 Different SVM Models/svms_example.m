%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script carries out the work done in the corresponding Live script, 
% Different_SVM_Models
% Simply run the file to produce four plots, one per model.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m = 16;
sv_dr = []
while isempty(sv_dr)

%Simple Dataset (usually not linearly separable)
x = [2*rand(8,2) + 2;
     2*rand(8,2) + 3];
y = [ones(8,1);
    -ones(8,1)];

% Standard Model
[w, gamma, sv] = standard_svm(x,y,0.5);
figure();
visualise(m,x,y,w,gamma,sv);
title('Standard SVM');

%L1-Norm Model
[w, gamma, sv] = l1_svm(x,y,0.5);
figure();
visualise(m,x,y,w,gamma,sv);
title('L1-SVM');

% DrSVM Model
[w, gamma, sv_dr] = dr_svm(x,y,1024);
figure();
visualise(m,x,y,w,gamma,sv_dr);
title('DrSVM')

%Robust Model
r = zeros(m,1);
for i=1:m
    r(i) = 0.2*rand(1);
end
[w, gamma, sv] = rob_svm(x,y,0.8,r) ;
figure();
visualise_robust(m,x,y,w,gamma,sv,r);
title('Robust SVM');

end