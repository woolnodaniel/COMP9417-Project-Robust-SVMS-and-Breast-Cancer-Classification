
classdef DrSVM < SVM
    properties %(Access = private)
        nu %regularization parameter 
    end
    
    methods 
        %%% __init__
        function model = DrSVM(nu)
            model = model@SVM();
            if nargin == 0
                model.nu = 10;
            elseif nargin == 1
                model.nu = nu;
            else
                error("Incorrect parameters passed to class SVM. Initialise with either (a) nu, or (b) no inputs.\n")
            end
        end
        
        %%% fit
        function [] = fit(obj,X,y)
            [obj.w, obj.gamma, ~] = l1_svm(X,y,obj.nu);
        end 
        
        %%% display
       function [] = show(obj)
           namestr = obj.getobjname();
           fprintf("%s.w:\n", namestr)
           details(obj.w)
           fprintf("%s.gamma:\n", namestr);
           details(obj.gamma)
           fprintf("%s.nu:\n", namestr);
           details(obj.nu)
       end
       
       %%% object name
       function namestr = getobjname(obj)
           namestr = inputname(1);
       end
       
       %%% change regularization parameter
       function [] = retune(obj,new_nu)
           obj.nu = new_nu; 
       end
    end   
end