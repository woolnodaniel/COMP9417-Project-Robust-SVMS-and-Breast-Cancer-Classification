
function [w,gamma,sv] = dr_svm(x,y,nu)
    %original parameters in desired form
    m = size(x,1); 
    n = size(x,2);
    Y = diag(y);
    X = x;
    e = ones(2*n+m,1);
    eh = [ones(m,1); zeros(2*n,1)];
    I = eye(2*n+m);
    
    %new problem-specific parameters
    Yhat = [Y zeros(m,2*n); zeros(2*n, m + 2*n)];
    Xhat = [zeros(m,m) X -X; zeros(2*n, m + 2*n)];
    C = [zeros(m, 2*n + m); zeros(2*n, m) eye(2*n)];
    V = inv(C+nu*I);
    Q = (Yhat*Xhat+I)*V*(Yhat*Xhat+I)' + Yhat*eh*eh'*Yhat';
    
    %optimisation problem and solution
    u = sdpvar(2*n+m,1);
    
    Obj = 0.5*u'*Q*u - eh'*u;    
    C = [u >= 0];
    
    optimize(C,Obj,sdpsettings('verbose',0,'solver','mosek'));
    
    u = value(u);
    
    sol = V*((Yhat*Xhat)'+I)*u;
    p = sol(m+1:m+n);
    q = sol(m+n+1:end);
    w = p - q;
    gamma = -eh'*Yhat*u;
    sv = [];
    for i =1:m
        marg = abs(w'*x(i,:)'-gamma);
        if marg >= 1-(1e-2) && marg <= 1+(1e-2) %support vector, allowing for computer error
            sv = [sv i];
        end
    end
end