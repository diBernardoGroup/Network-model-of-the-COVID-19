my_line_width = 1.2;

% Calculating regions that exceeded ICU capacits
figure('name', 'regions', 'color', 'w');
reg_ov = sum(squeeze(max(0.1 * H_hyp,[],2)>H_max),1);
reg_ov_1 = max(0.1 * mean(H_hyp,3),[],2)>H_max;

% Plotting regional trajectories
for i = 1 : M
    subplot(5, 4, i);
    hold on; grid on;
    set(0,'DefaultLegendAutoUpdate','off')
    y_max = 1.2 * max([mean(max(squeeze(D_hyp(i, :, :)/N(i)))),mean(max(squeeze(Q_hyp(i, :, :)/N(i)))),mean(max(squeeze(I_hyp(i, :, :)/N(i)))),mean(max(squeeze(H_hyp(i, :, :)/N(i))))]);
    stdshade(squeeze(I_hyp(i, :, :)/N(i))',0.2,'b',time,1);
    stdshade(squeeze(Q_hyp(i, :, :)/N(i))',0.2,'m',time,1);
    stdshade(squeeze(D_hyp(i, :, :)/N(i))',0.2,'k',time,1);
    stdshade(squeeze(0.1 * H_hyp(i, :, :)/N(i))',0.2,'r',time,1);
    yline(H_max(i)/N(i), '--', 'linewidth', my_line_width);
    ylim([0 y_max]);
    xlim([0 final_time]);
    if reg_ov_1(i) > 0
        title(regions{i}, 'color', 'r');
    else
        title(regions{i});
    end
    if ismember(i, 17 : 20)
        xlabel('days');
    end
    
    if i == 1
        axP = get(gca,'Position');
        legend('\itI-range', '\itI-mean',...
                '\itQ-range', '\itQ-mean',...
                '\itD-range', '\itD-mean',...
                '\itH-range', '\itH-mean', '\itH-max','Location','northwestoutside');
         set(gca, 'Position', axP)
    end

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

% Plotting national trajectory
I_national_hyp = squeeze(sum(I_hyp, 1));
Q_national_hyp = squeeze(sum(Q_hyp, 1));
H_national_hyp = squeeze(sum(H_hyp, 1));
R_national_hyp = squeeze(sum(R_hyp, 1));
D_national_hyp = squeeze(sum(D_hyp, 1));

H_max_national = sum(H_max, 1);
N_national = sum(N);

figure('name', 'nation', 'color', 'w');
hold on; grid on;
y_max = max([max(D_national_hyp/N_national),max(R_national_hyp/N_national),max(I_national_hyp/N_national), max(Q_national_hyp/N_national), max(H_national_hyp/N_national)]);
stdshade(squeeze(I_national_hyp/N_national)',0.2,'b',time,1);
stdshade(squeeze(Q_national_hyp/N_national)',0.2,'m',time,1);
stdshade(squeeze(R_national_hyp/N_national)',0.2,'g',time,1);
stdshade(squeeze(D_national_hyp/N_national)',0.2,'k',time,1);
stdshade(squeeze(0.1 * H_national_hyp/N_national)',0.2,'r',time,1);
yline(H_max_national/N_national, '--', 'linewidth', my_line_width);
ylim([0 y_max]);
xlim([0 final_time]);
title('Italy');
xlabel('days');
legend('\itI-range', '\itI-mean',...
       '\itQ-range', '\itQ-mean',...
       '\itR-range', '\itR-mean',...
       '\itD-range', '\itD-mean',...
       '\itH-range', '\itH-mean','Location','northwest');

%Calculating metrics
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

costi_mean = mean(sum(Costi_montecarlo(:,end,:),1));
reg_ov_mean = mean(reg_ov);
tot_c_mean = mean(avg_case);
tot_d_mean = mean(avg_d);
max_hosp_mean = mean(max_hosp);
maxNHSsat_mean = mean(maxNHSsat);

costi_std = std(sum(sum(Costi_montecarlo,2)/final_time,1)/M);
reg_ov_std = std(reg_ov);
avg_case_std = std(avg_case);
avg_d_std = std(avg_d);
max_hosp_std = std(max_hosp);
maxNHSsat_std = std(maxNHSsat);

fprintf('total cases (mean) = %d,\ntotal deaths (mean) = %d,\nnational peak of hospitalized (mean)= %d,\nmaximum days of saturation of healthcare system (mean) = %d,\nregion saturating the healthcare system (mean) = %d,\nnational cost (mean) = %d M\n',...
        tot_c_mean, tot_d_mean, max_hosp_mean, maxNHSsat_mean, reg_ov_mean, costi_mean);