function [avgs,stds] = get_national_data(fig_name)
    %Takes as input the name of the figure to open.
    %Outputs a matrix of values of mean values and standard deviations.
    %First index corresponds to time
    %Second index correspond to the varibles ordered as:
    %1. H
    %2. I
    %3. Q
    %4. R
    %5. D
    
    close all
    openfig(fig_name);

    yyaxis left
    a = get(gca,'Children');
    x = get(a(3), 'XData');
    ydata_left = get(a(2:3), 'YData');

    yyaxis right
    a = get(gca,'Children');
    ydata_right = flip(get(a, 'YData'));
    right_l = length(ydata_right);

    avgs = zeros(length(x),1 + right_l/2);
    stds = zeros(length(x),1 + right_l/2);

    avgs(:,1) = ydata_left{2};
    temp = ydata_left{1};
    stds(:,1) = abs(avgs(:,1)-temp(1:length(avgs(:,1))));

    for i =1:right_l/2
        avgs(:,i+1) = ydata_right{2*i - 1};
        temp = ydata_right{2*i};
        stds(:,i+1) = abs(avgs(:,i+1)-temp(1:length(avgs(:,i+1))));
    end
end