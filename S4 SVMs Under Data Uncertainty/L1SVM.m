
classdef L1SVM < SVM
    properties %(Access = private)
        lambda %regularization parameter 
    end
    
    methods 
        %%% __init__
        function model = L1SVM(lambda)
            model = model@SVM();
            if nargin == 0
                model.lambda = 0.5;
            elseif nargin == 1
                model.lambda = lambda;
            else
                error("Incorrect parameters passed to class SVM. Initialise with either (a) lambda, or (b) no inputs.\n")
            end
        end
        
        %%% fit
        function [] = fit(obj,X,y)
            [obj.w, obj.gamma, ~] = l1_svm(X,y,obj.lambda);
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