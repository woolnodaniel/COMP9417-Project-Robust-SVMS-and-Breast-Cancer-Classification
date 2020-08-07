
classdef robustSVM < SVM
    properties %(Access = private)
        lambda %regularization parameter 
    end
    
    methods 
        %%% __init__
        function model = robustSVM(lambda)
            model = model@SVM();
            if nargin == 0
                model.lambda = 0.05;
            elseif nargin == 1
                model.lambda = lambda;
            else
                error("Incorrect parameters passed to class SVM. Initialise with either (a) lambda, or (b) no inputs.\n")
            end
        end
        
        %%% fit
        function [] = fit(obj,X,y,r)
            if nargin == 3 %no ro given; make all zeros
                m = size(X,1);
                r = zeros(m,1);
            end
            [obj.w, obj.gamma, ~] = rob_svm(X,y,obj.lambda,r);
        end 
        
        %%$ fit and predict
       function [acc, f1] = run(obj,X_train,y_train,X_test,y_test,r)
           try
               obj.fit(X_train,y_train,r);
               pred = obj.predict(X_test);
               acc = accuracy(y_test,pred);
               f1 = f1_score(y_test,pred);
           catch %i.e. optimisation problem was infeasible
               acc = 0;
               f1 = 0;
           end
       end
        
        %%% display
       function [] = show(obj)
           namestr = obj.getobjname();
           fprintf("%s.w:\n", namestr)
           details(obj.w)
           fprintf("%s.gamma:\n", namestr);
           details(obj.gamma)
           fprintf("%s.lambda:\n", namestr);
           details(obj.lambda)
       end
       
       %%% object name
       function namestr = getobjname(obj)
           namestr = inputname(1);
       end
       
       %%% change regularization parameter
       function [] = retune(obj,new_lambda)
           obj.lambda = new_lambda; 
       end
    end   
end