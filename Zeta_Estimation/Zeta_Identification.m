%% Clear the workspace

clear;
close all;


movmeanK=3;

%% Load the data for zeta identification

ICU_Units_Decree;
load('regional_stage1.mat'); 
load('regional_stage2.mat');


% fid=fopen('data_regional.txt','wt'); 
% fprintf(fid,webread('https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/data-regioni/dpc-covid19-ita-regioni.csv'));
% fclose(fid);
data=readtable('data_regional.txt');


%% Initialization of the variables (estimate and display)

order_params = [13 2 16 17 18 15 8 6 12 7 3 11 14 1 20 19 4 9 10 5];
region_code=1; %Code of the region you want to identify
zeta2=[];
colors=jet(20);
Names={};

%% Estimate of zeta for each of the 20 regions
                         
while (region_code)<=20
    
    
    %Extract data for zeta identification
    movmeanK=regional_stage1(region_code).movmeanK;
    T_C=regional_stage1(region_code).T_C;
    In=regional_stage1(region_code).In;
    read_regional_data;
    Names{region_code}=Namer;
    
    % Find ICU beds in each region (by interpolation)
    ICU_reg=@(t) interp1(ICU_beds(region_code).data+T_C(1),ICU_beds(region_code).number,t,'nearest','extrap');
    TC_S(region_code).tc=[T_C,length(In)-1];
    
    % Prepare data for the identification
    dD=diff(total_dead);
    Phi=total_hosp;
    
    % Identify zeta in each time window and store the data in zeta2
    for i=1:(length(TC_S(region_code).tc)-1)
        
        time_vec=TC_S(region_code).tc(i):1:TC_S(region_code).tc(i+1);
        
        zeta_i=lsqlin(Phi(time_vec),dD(time_vec));
        
        Hosp_sat=total_hosp(time_vec)./ICU_reg(time_vec)';
        
        zeta2=[zeta2; mean(Hosp_sat),zeta_i,region_code];
    end
    
    
    region_code=region_code+1;
end

%% Plot and estimate of the zeta function parameters




% Phantom lines for legend display
figure('pos',[100 100 700 400])
for i=1:20
    line(-1,-1,'marker','.','color',colors(i,:),'markersize',20,'linestyle','none');
end

%Plot of the distribution of zeta coefficients 
for i=1:20
    data_region=zeta2(:,3)==order_params(i);
    line(zeta2(data_region,1),zeta2(data_region,2),'marker','.','color',colors(i,:),'markersize',20,'linestyle','none');
    Name_region{i}=Names{order_params(i)};
end

%estimate of the parameters of zeta function and display of such function
lmzeta=fitlm(zeta2(:,1),zeta2(:,2));
zeta_estimate=lmzeta.Coefficients.Estimate;
line([0 12],zeta_estimate(1)+zeta_estimate(2)*[0,12],'color','k');
xlim([0,10])
box
legend(Name_region,'location','eastoutside');
ylabel('\zeta_i');
xlabel('$\bar H_i$','interpreter','latex');

set(0, 'DefaultFigureRenderer', 'painters');
saveas(gcf,'Fig_S_14.png')

clc;

fprintf('Coefficients of zeta(H/T) : \n zeta_1 = %.5f \n zeta_2 = %.5f \n',zeta_estimate(1),zeta_estimate(2));
