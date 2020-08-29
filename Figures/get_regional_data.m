function [avgs,stds] = get_regional_data(fig_name)
    %Takes as input the name of the figure to open.
    %Outputs a matrix of values of mean values and standard deviations.
    %First index corresponds to time
    %Second index correspond to the varibles ordered as:
    %1. H
    %2. I
    %3. Q
    %4. D
    %Third index correspond to the region
    
    close all
    fig = openfig(fig_name);

    N = numel(fig.Children);

    subplot(5, 4, 1);
    yyaxis left
    a = get(gca,'Children');
    x = get(a(3), 'XData');
    ydata_left = get(a(2:3), 'YData');

    yyaxis right
    a = get(gca,'Children');
    ydata_right = flip(get(a, 'YData'));
    right_l = length(ydata_right);
    temp = 0;
    for  i = 1:right_l
        if length(ydata_right{i})==4
            temp = temp + 1;
        end
    end
    right_l = right_l - temp;
    ydata_right = get(a(temp+1:end), 'YData');

    avgs = zeros(length(x),1 + right_l/2,N);
    stds = zeros(length(x),1 + right_l/2,N);

    avgs(:,1,1) = ydata_left{2};
    temp = ydata_left{1};
    stds(:,1,1) = abs(avgs(:,1,1)-temp(1:length(avgs(:,1,1))));

    for i =1:right_l/2
        avgs(:,i+1,1) = ydata_right{2*i};
        temp = ydata_right{1 + 2*(i-1)};
        stds(:,i+1,1) = abs(avgs(:,i+1,1)-temp(1:length(avgs(:,i+1,1))));
    end

    for j = 2:N
        subplot(5, 4, j);
        yyaxis left
        a = get(gca,'Children');
        ydata_left = get(a(2:3), 'YData');

        yyaxis right
        a = get(gca,'Children');
        ydata_right = get(a, 'YData');
        right_l = length(ydata_right);
        temp = 0;
        for  i = 1:right_l
            if length(ydata_right{i})==4
                temp = temp + 1;
            end
        end
        right_l = right_l - temp;
        ydata_right = get(a(temp+1:end), 'YData');

        avgs(:,1,j) = ydata_left{2};
        temp = ydata_left{1};
        stds(:,1,j) = abs(avgs(:,1,j)-temp(1:length(avgs(:,1,j))));

        for i =1:right_l/2
            avgs(:,i+1,j) = ydata_right{2*i};
            temp = ydata_right{1 + 2*(i-1)};
            stds(:,i+1,j) = abs(avgs(:,i+1,j)-temp(1:length(avgs(:,i+1,j))));
        end 
    end
end