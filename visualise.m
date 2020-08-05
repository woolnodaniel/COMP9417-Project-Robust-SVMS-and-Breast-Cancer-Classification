function [] = visualise(m,x,y,w,gamma,sv)
    for i=1:m
        if y(i) == 1
            if isempty(sv(sv==i))
                scatter(x(i,1),x(i,2),'rx')
                hold on
            else
                scatter(x(i,1),x(i,2),'gx')
                hold on
            end
        else
            if isempty(sv(sv==i))
                scatter(x(i,1),x(i,2),'b^')
                hold on
            else
                scatter(x(i,1),x(i,2),'g^')
                hold on
            end
        end
    end
    fimplicit(@(X,Y) w(1)*X + w(2)*Y - gamma, 'r-')
    hold on
    fimplicit(@(X,Y) w(1)*X + w(2)*Y - gamma - 1, 'b--')
    hold on
    fimplicit(@(X,Y) w(1)*X + w(2)*Y - gamma + 1, 'b--')
    xlim([1,5])
    ylim([1,5])
    hold off
end