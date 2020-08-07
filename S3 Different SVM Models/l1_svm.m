
function [w,gamma,sv] = l1_svm(x,y,lambda)
    %define parameters in desired form
    m = size(x,1); 
    n = size(x,2);
    Y = diag(y);
    X = x;
    em = ones(m,1);
    en = ones(n,1);
    
    %define problem variables
    p = sdpvar(n,1);
    q = sdpvar(n,1);
    gamma = sdpvar(1);
    xi = sdpvar(m,1);    
    
    %objective function
    Obj = en'*(p+q) + lambda*em'*xi;
    
    %constraints
    C = [Y*(X*(p-q)-em*gamma)+xi >= em; p >= 0; q >= 0; xi >= 0];
    
    %solve
    optimize(C, Obj, sdpsettings('solver','mosek','verbose',0));
    
    %extract solution
    p = value(p);
    q = value(q);
    w = value(p-q);
    gamma = value(gamma);
    sv = [];
    for i =1:m
        marg = abs(w'*x(i,:)'-gamma);
        if marg >= 1-5*(1e-8) && marg <= 1+5*(1e-8) %support vector, allowing for computer error
            sv = [sv i];
        end
    end
end