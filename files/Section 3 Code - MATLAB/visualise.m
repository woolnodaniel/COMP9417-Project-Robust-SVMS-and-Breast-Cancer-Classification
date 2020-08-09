
function [] = visualise(m,x,y,w,gamma,sv)
    sz = 40;
    for i=1:m
        if y(i) == 1
            if isempty(sv(sv==i))
                scatter(x(i,1),x(i,2),sz,'s','MarkerEdgeColor',rgb('Crimson'),'MarkerFaceColor',rgb('Red'))
                hold on
            else
                scatter(x(i,1),x(i,2),sz,'s','MarkerEdgeColor',rgb('Green'),'MarkerFaceColor',rgb('LimeGreen'))
                hold on
            end
        else
            if isempty(sv(sv==i))
                scatter(x(i,1),x(i,2),sz,'^','MarkerEdgeColor',rgb('Blue'),'MarkerFaceColor',rgb('DodgerBlue'))
                hold on
            else
                scatter(x(i,1),x(i,2),sz,'^','MarkerEdgeColor',rgb('Green'),'MarkerFaceColor',rgb('LimeGreen'))
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
    axis square
end