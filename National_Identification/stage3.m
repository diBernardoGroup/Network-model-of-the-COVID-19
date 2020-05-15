clear all;clc;close all;


%% Load, read ande filter data

read_national_data;

total_positive  =   total_positive';
total_rec       =   total_rec';
total_dead      =   total_dead';
total_hosp      =   total_hosp';
total_quar      =   total_quar';

load National_stage1; %Load results from stage1,2 

%% Initialize the variables

t00=737844;

t_end=length(total_active);
total_active  = @(t) interp1(1:t_end,total_active,t); 
t_change=[T_C,t_end+1];
parameters_t=[parameters_t;parameters_t(end,:)];
parameters2=[];

%% Identification of eta
% etaq deos not change over time. Instead, etah depends on time
% Dg = etaq*total_positive + etah*total_hosp 
Dg=diff(total_rec);
Phi=[total_quar];
for i=1:(length(t_change)-1)
    times=[zeros(t_change(i)-1,1);
           ones(t_change(i+1)-t_change(i),1);
           zeros(t_change(end)-t_change(i+1),1)];

    Phi=[Phi,total_hosp.*times]; 
end

Phi(end,:)=[];
etaV=lsqlin(Phi,Dg,-eye(length(t_change)),zeros(length(t_change),1));

%% Identification of the remaining parameters


figure('pos',[100 100 800 400]);
for i=1:(length(t_change)-1)
    
    times=t_change(i):(t_change(i+1)-1);
    % pars=zeta, alpha(I>Q), psi(I>H), kappaQ(Q>H), kappaH(H>Q)
    
    %Identification
    [pars]=Least_Squares_id(In,total_quar,total_hosp,[etaV(1);etaV(i+1)],total_dead,times,parameters_t(i,2));
    parameters2=[parameters2,pars];
    eta=pars(1:2); pars=pars(3:end);
    tspan=times(1:end-1)';
    
    %Comparison plot between data and predictions (recovered)
    subplot(1,4,1); 
    Phi=[total_quar,total_hosp];
    line(times,[0;cumsum(Phi(tspan,:)*eta)]+total_rec(times(1)),'linewidth',2);
    line(times,total_rec(times),'marker','o','linestyle','none','color','r'); title('recovered');
    
    
    %Comparison plot between data and predictions (dead)
    subplot(1,4,2); 
    line(times,[0;cumsum(total_hosp(tspan)*pars(1))]+total_dead(times(1)),'linewidth',2);
    line(times,total_dead(times),'marker','o','linestyle','none','color','r'); title('dead');
    
    
    %Comparison plot between data and predictions (hospitalized)
    subplot(1,4,3);
    Phi=[-total_hosp,zeros(t_end,1),In,total_quar,-total_hosp,-total_hosp];
    line(times,[0;cumsum(Phi(tspan,:)*[pars;eta(2)])]+total_hosp(times(1)),'linewidth',2);
    line(times,total_hosp(times),'marker','o','linestyle','none','color','r');  title('hospitalized');
    
    
    %Comparison plot between data and predictions (quarantined)
    subplot(1,4,4);
    Phi=[zeros(t_end,1),In,zeros(t_end,1),-total_quar,total_hosp,-total_quar];
    line(times,[0;cumsum(Phi(tspan,:)*[pars;eta(1)])]+total_quar(times(1)),'linewidth',2);
    line(times,total_quar(times),'marker','o','linestyle','none','color','r');  title('quarantined');
end

clc;
%% Table of parameter printed on screen
fprintf('etaQ\t etaH\t zeta\t alpha(I>Q)\t psi(I>H)\t kappaQ(Q>H) kappaH(H>Q)\n')
fprintf('%.3f\t %.3f\t %.3f\t %.3f\t\t %.3f\t\t %.3f\t\t %.3f\n',parameters2)
