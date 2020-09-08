my_line_width = 1.2;
set(0, 'DefaultFigureRenderer', 'painters');

% Regional Plot
fig = figure('name', 'regions', 'color', 'w');
reg_ov = sum(squeeze(max(0.1 * H_hyp,[],2)>H_max),1);
reg_ov_1 = max(0.1 * mean(H_hyp,3),[],2)>H_max;
set(fig,'defaultAxesColorOrder',[[1 0 0]; [0 0 0]])
for i = 1 : M
    subplot(5, 4, i);
    hold on; grid on;
    y_max = max([mean(squeeze(I_hyp(i, :, :)/N(i)),2); mean(squeeze(Q_hyp(i, :, :)/N(i)),2)] + ...
        [std(squeeze(I_hyp(i, :, :)/N(i)),0,2); std(squeeze(Q_hyp(i, :, :)/N(i)),0,2)]);          
%     y_max = max([mean(squeeze(I_hyp(i, :, :)/N(i)),2); mean(squeeze(Q_hyp(i, :, :)/N(i)),2); mean(squeeze(D_hyp(i, :, :)/N(i)),2)] + ...
%         [std(squeeze(I_hyp(i, :, :)/N(i)),0,2); std(squeeze(Q_hyp(i, :, :)/N(i)),0,2); std(squeeze(D_hyp(i, :, :)/N(i)),0,2)]);             %uncomment to display deaths in regional panels

    yyaxis left
    stdshade(squeeze(0.1 * H_hyp(i, :, :)/N(i))',0.2,'r',time,1);
    
    yline(H_max(i)/N(i), 'r--', 'linewidth', my_line_width);
    ylim([0 max([max(mean(squeeze(0.1 * H_hyp(i, :, :)/N(i)),2) + std(squeeze(0.1 * H_hyp(i, :, :)/N(i)),0,2)),1.05*H_max(i)/N(i)])]);
    yyaxis right
    stdshade(squeeze(I_hyp(i, :, :)/N(i))',0.2,'b',time,1);
    stdshade(squeeze(Q_hyp(i, :, :)/N(i))',0.2,'m',time,1);
%     stdshade(squeeze(D_hyp(i, :, :)/N(i))',0.2,'k',time,1);       %uncomment to display deaths in regional panels

    ylim([0 y_max]);
    xlim([0 final_time]);
    if reg_ov_1(i) > 0
        title(regions{i}, 'color', 'r');
    else
        title(regions{i});
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
    
    box on
    hold off
end

set( gcf, 'Position', [100 100 900 600])
saveas(gcf,strcat('.\',scenario_name,'_a.pdf'))
savefig(strcat('.\',scenario_name,'_a'))

% National Plot
I_national_hyp = squeeze(sum(I_hyp, 1));
Q_national_hyp = squeeze(sum(Q_hyp, 1));
H_national_hyp = squeeze(sum(H_hyp, 1));
R_national_hyp = squeeze(sum(R_hyp, 1));
D_national_hyp = squeeze(sum(D_hyp, 1));

H_max_national = sum(H_max, 1);
N_national = sum(N);

fig = figure('name', 'nation', 'color', 'w');
set(fig,'defaultAxesColorOrder',[[1 0 0]; [0 0 0]])
hold on; grid on;
y_max = max([max(mean(squeeze(I_national_hyp/N_national),2)+std(squeeze(I_national_hyp/N_national),0,2)),...
             max(mean(squeeze(R_national_hyp/N_national),2)+std(squeeze(R_national_hyp/N_national),0,2)),...
             max(mean(squeeze(D_national_hyp/N_national),2)+std(squeeze(D_national_hyp/N_national),0,2)),...
             max(mean(squeeze(Q_national_hyp/N_national),2)+std(squeeze(Q_national_hyp/N_national),0,2))]);
% y_max = 3e-3;
yyaxis right
stdshade(squeeze(I_national_hyp/N_national)',0.2,'b',time,1);
stdshade(squeeze(Q_national_hyp/N_national)',0.2,'m',time,1);
stdshade(squeeze(R_national_hyp/N_national)',0.2,'g',time,1);
stdshade(squeeze(D_national_hyp/N_national)',0.2,'k',time,1);
ylim([0 y_max]);

yyaxis left
y_max = max([max(mean(squeeze(0.1*H_national_hyp/N_national),2)+std(squeeze(0.1*H_national_hyp/N_national),0,2)),1.05*H_max_national/N_national]);
stdshade(squeeze(0.1 * H_national_hyp/N_national)',0.2,'r',time,1);
yline(H_max_national/N_national, 'r--', 'linewidth', my_line_width);
ylim([0 y_max]);
xlim([0 final_time]);
title('Italy');
box on

set( gcf, 'Position', [100 100 400 250])
saveas(gcf,strcat('.\',scenario_name,'_b.pdf'))
savefig(strcat('.\',scenario_name,'_b'))

% Metrics
avg_case = zeros(1,N_param_var);
avg_d = zeros(1,N_param_var);
max_hosp = zeros(1,N_param_var);
maxNHSsat = zeros(1,N_param_var);

for i = 1 : N_param_var
    avg_case(i)=(I_national_hyp(end,i)+Q_national_hyp(end,i)+R_national_hyp(end,i)+D_national_hyp(end,i)+H_national_hyp(end,i));
    avg_d(i)= D_national_hyp(end,i);
    max_hosp(i)=max(0.1 * H_national_hyp(:,i));

    temp = 0;
    for t = time
        if 0.1 * H_national_hyp(t,i)>H_max_national
            temp = temp + 1;
        else
            maxNHSsat(i) = max(maxNHSsat(i),temp);
            temp = 0;
        end
    end
end

cost_2 = [2.029803247, 0.268100617, 6.787101988, 1.008410882, 3.468888478, 7.237139529, ...
          7.320320813, 1.390605779, 8.621076943, 2.62389461, 13.47127556, 2.77603884, ...
          0.428948376, 5.696180067, 2.386577225, 6.594914702, 6.963288786, 1.853465814, ...
          1.510031545, 8.040596114];
costi_new = squeeze(Costi_montecarlo(:,end,:));
times = costi_new./cost_l';
costi_new = times.*(cost_l' + cost_2');

costi_mean = mean(sum(costi_new,1));
reg_ov_mean = mean(reg_ov);
avg_case_mean = mean(avg_case);
avg_d_mean = mean(avg_d);
max_hosp_mean = mean(max_hosp);
maxNHSsat_mean = mean(maxNHSsat);

costi_std = std(sum(costi_new,1));
reg_ov_std = std(reg_ov);
avg_case_std = std(avg_case);
avg_d_std = std(avg_d);
max_hosp_std = std(max_hosp);
maxNHSsat_std = std(maxNHSsat);

fprintf('total cases (mean) = %d,\ntotal deaths (mean) = %d,\nnational peak of hospitalized (mean)= %d,\nmaximum days of saturation of healthcare system (mean) = %d,\nregion saturating the healthcare system (mean) = %d,\nnational cost (mean) = %d M\n',...
       avg_case_mean, avg_d_mean, max_hosp_mean, maxNHSsat_mean, reg_ov_mean, costi_mean);
   
fileID = fopen(strcat('.\',scenario_name,'.txt'),'w');
fprintf(fileID,'avg_cases_mean = %d,\navg_deaths_mean = %d,\nmax_hosp_mean = %d,\nmaxNHSsat_mean = %d,\nn_reg_sat_mean = %d,\ncost_nat_mean = %d\n',...
        avg_case_mean, avg_d_mean, max_hosp_mean, maxNHSsat_mean, reg_ov_mean, costi_mean);
fprintf(fileID,'avg_cases_std = %d,\navg_deaths_std = %d,\nmax_hosp_std = %d,\nmaxNHSsat_std = %d,\nn_reg_sat_std = %d,\ncost_nat_std = %d\n',...
        avg_case_std, avg_d_std, max_hosp_std, maxNHSsat_std, reg_ov_std, costi_std);
fclose(fileID);
