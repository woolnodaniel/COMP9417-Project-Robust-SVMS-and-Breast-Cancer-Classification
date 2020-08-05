function [w, gamma, sv] = rob_svm(x,y,lambda,r)
    %problem parameters
    m = size(x,1); 
    n = size(x,2);
    e = ones(m,1);
    
    %variables
    w = sdpvar(n,1);
    gamma = sdpvar(1);
    xi = sdpvar(m,1);
    t = sdpvar(2,1);
    
    %objective
    Obj = 0.5*t(1)^2 + lambda*t(2);
    
    %constraints: socp
    C = [norm(w,2) <= t(1); e'*xi <= t(2); xi >= 0];
    for i = 1:m
        C = [C; y(i)*(x(i,:)*w-gamma) - y(i)*r(i)*t(1) + xi(i) >= 1];
    end
    
    %solve
    optimize(C,Obj,sdpsettings('verbose',0,'solver','mosek'));
    
    w = value(w);
    gamma = value(gamma);
    sv = [];
    for i =1:m
        marg = abs(w'*x(i,:)'-gamma);
        if marg >= 1-(1e-8) && marg <= 1+(1e-8) %support vector, allowing for computer error
            sv = [sv i];
        end
    end
end