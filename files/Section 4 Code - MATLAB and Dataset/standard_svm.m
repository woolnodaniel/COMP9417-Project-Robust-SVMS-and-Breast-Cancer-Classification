
function [w,gamma,sv] = standard_svm(x,y,lambda)    
    %define parameters in desired form
    m = size(x,1); 
    Y = diag(y);
    X = x;
    e = ones(m,1);
    
    %define problem variables
    u = sdpvar(m,1);
    
    %objective function
    Obj = 0.5*u'*Y*(X*X')*Y'*u - e'*u;
    
    %constraints
    C = [e'*Y'*u == 0; u >= 0; u <= lambda*e];
    
    %solve
    optimize(C, Obj, sdpsettings('solver','mosek','verbose',0));
    
    %extract solution
    u = value(u);
    sv = [];
    for i =1:m
        if u(i) > 5*1e-8 && u(i) < lambda-5*(1e-8) %support vector, allowing for computer error
            sv = [sv i];
        end
    end
    if isempty(sv)
        error('No solution found. Please adjust tuning parameter. ')
    end
    w = X'*Y'*u;
    [~, I] = sort(u(sv),'ascend');
    new_sv = sv(I);
    ind = new_sv(ceil(end/2),2);
    gamma = -(1 - y(ind)*w'*x(ind,:)')/y(ind);
end