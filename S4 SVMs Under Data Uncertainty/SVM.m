
classdef SVM < handle
    
   properties 
       w;      %weight
       gamma;  %bias
   end
   
   methods
       
       %%% __init__
       function model = SVM(w,gamma)
           model.w = [];
           model.gamma = [];
       end
       
       %%% fit to data
       function [] = fit(obj,X,y)
           %%% overriden by children classes 
           n = size(X,2);
           obj.w = zeros(n,1);
           obj.gamma = 0;
       end
       
       %%% predict from data
       function pred = predict(obj,X)
           m = size(X,1);
           pred = zeros(m,1);
           for i = 1:m
               pred(i) = sign(obj.w'*X(i,:)' - obj.gamma);
           end
       end
       
       %%$ fit and predict
       function [acc, f1] = run(obj,X_train,y_train,X_test,y_test)
           try
               obj.fit(X_train,y_train);
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
           obj.w
           obj.gamma
       end
   end
end