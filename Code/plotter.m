function [] = plotter(res,title1)
    figure
    plot(res(:,1),res(:,6),':k')
    title(title1)
    xlabel('Number of Features')
    ylabel('Accuracy');
end