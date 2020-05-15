my_line_width = 1.2;

reg_ov=max(0.1 * H,[],2)>H_max;
fig = figure('name', 'regions', 'color', 'w');
for i = 1 : M
	subplot(5, 4, i);
	hold on; grid on;
    y_max = max([I(i, :), Q(i, :), 0.1 * H(i, :),D(i, :)]);
	plot(time, I(i, :)/N(i),'b','linewidth', my_line_width);
	plot(time, Q(i, :)/N(i),'m','linewidth', my_line_width);
	plot(time, D(i, :)/N(i),'k','linewidth', my_line_width);
	plot(time, 0.1 * H(i, :)/N(i),'r','linewidth', my_line_width);
 	yline(H_max(i)/N(i), '--', 'linewidth', my_line_width);
    xlim([0 final_time]);
    ylim([0 y_max/N(i)]);
    if reg_ov(i) > 0
        title(regions{i}, 'color', 'r');
    else
        title(regions{i});
    end
    
	if ismember(i, 17 : 20)
		xlabel('days')
    end
    
	if i == 1
        axP = get(gca,'Position');
		legend('\itI', '\itQ', '\itD', '\itH', '{\itH}_{max}','Location','northwestoutside');
        set(gca, 'Position', axP)
    end

    %Marks intervals of social distancing
    jchange=1;
    for j = 1:length(time)
        if SD_OFF(i, jchange)~=SD_OFF(i,j)
            xBox = [time(jchange), time(jchange), time(j - 1), time(j - 1)];
            yBox = [0  1 1 0];
            if SD_OFF(i, j-1)==1
                patch(xBox', yBox',1,'FaceAlpha',.1,'EdgeColor','none','Facecolor','green')
            end
            jchange=j-1;
        end
    end
    xBox = [time(jchange), time(jchange), time(end), time(end)];
    yBox = [0  1 1 0];
    
    if SD_OFF(i, end)==1
        patch(xBox', yBox',2,'FaceAlpha',.1,'EdgeColor','none','Facecolor','green')
    end
    
    
    jchange=1;
    for j = 1:length(time) 
        if SD_ON(i, jchange)~=SD_ON(i,j)
            xBox = [time(jchange), time(jchange), time(j - 1), time(j - 1)];
            yBox = [0  1 1 0];
            if SD_ON(i, j-1)==1
                patch(xBox', yBox',1,'FaceAlpha',.1,'EdgeColor','none','Facecolor','red')
            end
            jchange=j-1;
        end
    end
    
    xBox = [time(jchange), time(jchange), time(end), time(end)];
    yBox = [0  1 1 0];
    
    if SD_ON(i, end)==1
        patch(xBox', yBox',2,'FaceAlpha',.1,'EdgeColor','none','Facecolor','red')
    end
end

S_national = sum(S, 1);
I_national = sum(I, 1);
Q_national = sum(Q, 1);
R_national = sum(R, 1);
D_national = sum(D, 1);
H_national = sum(H, 1);
H_max_national = sum(H_max);
N_national = sum(N);

figure('name', 'nation', 'color', 'w');
hold on; grid on;
y_max = max([I_national, Q_national, D_national, H_national]);
plot(time, I_national/N_national,'b', 'linewidth', my_line_width); 
plot(time, Q_national/N_national,'m', 'linewidth', my_line_width); 
plot(time, R_national/N_national,'g', 'linewidth', my_line_width); 
plot(time, D_national/N_national,'k', 'linewidth', my_line_width); 
plot(time, 0.1 * H_national/N_national,'r', 'linewidth', my_line_width);
yline(H_max_national/N_national, '--', 'linewidth', my_line_width);
xlim([0 final_time]);
title('Italy');
xlabel('days');
legend('\itI', '\itQ', '\itR', '\itD', '\itH', '{\itH}_{max}','Location','northwest');


%METRICS
tot_c=(I_national(end)+Q_national(end)+R_national(end)+D_national(end)+H_national(end))/final_time;
tot_d=(D_national(end))/final_time;
max_hosp=max(0.1 * H_national);
final_costs=sum(Costi(:,end));
sum_reg_ov=sum(reg_ov);

temp = 0;
maxNHSSat = 0;
for t = time
    if 0.1 * H_national(t)>H_max_national
        temp = temp + 1;
    else
        maxNHSSat = max(maxNHSSat,temp);
        temp = 0;
    end
end

fprintf('total cases = %d,\ntotal deaths = %d,\nnational peak of hospitalized = %d,\nmaximum days of saturation of healthcare system = %d,\nregions with saturated healthcare system = %d,\nnational cost = %d M\n',...
        tot_c, tot_d, max_hosp, maxNHSSat, sum_reg_ov, final_costs);
