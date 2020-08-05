function [] = visualise_robust(m,x,y,w,gamma,sv,r)
    %also includes uncertainty regions
    thetas = linspace(-pi,pi,50);
    for i=1:m
        circle_x = r(i)*cos(thetas)+x(i,1);
        circle_y = r(i)*sin(thetas)+x(i,2);
        plot(circle_x,circle_y,'k--')
        hold on
    end
    visualise(m,x,y,w,gamma,sv)
    hold off
end