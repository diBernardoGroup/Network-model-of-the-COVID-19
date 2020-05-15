clear all;clc;close;
movmeanK=3;

read_national_data;

%% Initialization of the variables

t00=737844;

T_C=[1 13 29]; % time windows befor the offline merging

% T_C=[1 11 14 20 25 31 33 38]; % time windows after the offline merging

t_end=length(total_active);
total_active  = @(t) interp1(1:t_end,total_active,t); 
t_change=[T_C,t_end];
parameters_t=[];
initial_guess.It0=1200;
initial_guess.v=0.97;
initial_guess.g=0.07;  
initial_guess.tau=0.066;

%% Identify the model parameters in the different time windows

for i=1:(length(t_change)-1)
    
    [pars,y,If]=id_and_sim(tab_data,t_change(i),t_change(i+1),initial_guess,N,total_active);
    It0=If;    
    
    [v,tau,g,I0]=deal(pars{:});
    parameters=[[v,tau,g,I0,If]];

    initial_guess.v=v;
    initial_guess.It0=If;
    initial_guess.tau=tau;
    
    parameters_t=[parameters_t;parameters];
    
 end



%%  PLOT

%Model prediction plot
close;
figure('pos',[100 100 400 250]); clf;
In=zeros(t_end,1);
for i=1:length(t_change)-1

    times=t_change(i):t_change(i+1); 
    par_curr=num2cell(parameters_t(i,:));
    [v,tau,g,I0,If]=deal(par_curr{:});
    Q0=tab_data(1,t_change(i));
    S0=N-I0-Q0;
    [t,y]=ode45(@(t,x) SIR(t,x,v,tau,g,total_active),times,[S0;I0;Q0]);
    In(times)=y(:,2);
    
    figure(1);
    plot(t,y(:,3),'linewidth',2,'Color',[0 0 1]);hold on;
    line([times(end),times(end)],[0,2.5e5],'color','k')
end

%Registered data plot
plot(1:2:t_end,tab_data(1:2:end),'linewidth',1,'marker','o','MarkerSize',5,'color',[1 0 0 0.1]);
xlabel('Days');
ylabel('C_i');
set(gca,'xticklabel',datestr(t00+get(gca,'xtick')))
% ylim([0,0.15])
xtickangle(30)
% set(gca,'FontSize',14);
set( gcf, 'Position', [100 100 400 250])
% print(gcf,'National_Fitting_After_Merging.png','-dpng','-r600');

%Save the data needed for the next stage
save National_stage1 In parameters_t T_C

waitforbuttonpress()
%% prediction power test


%% Initialization of the variables
clf
Nest=0.3; %fraction of the data to estimate the data

initial_guess.It0=1200;
initial_guess.v=0.97;
initial_guess.g=0.07;  
initial_guess.tau=0.066;

parameters_ts=[];


%% Estimation of the model parameters using a restricted set of data

for i=1:(length(t_change)-1)
    
    initial_guess.v=parameters_t(i,1);
    initial_guess.It0=parameters_t(i,4);
    initial_guess.tau=parameters_t(i,2);

    [pars,y,If]=id_and_sim(tab_data,t_change(i),t_change(i)+ceil((t_change(i+1)-t_change(i))*Nest),initial_guess,N,total_active);  
    [v,tau,g,I0]=deal(pars{:});
    parameters=[[v, tau,g,I0,If]];
    
    parameters_ts=[parameters_ts;parameters];
%     waitforbuttonpress();


 end




%%  PLOT


% model predictions plot
figure(1); clf;
for i=1:length(t_change)-1

    times=t_change(i):t_change(i+1); 
    par_curr=num2cell(parameters_ts(i,:));
    [v,tau,g,I0,If]=deal(par_curr{:});
    Q0=tab_data(1,t_change(i));
    S0=N-I0-Q0;
    [t,y]=ode45(@(t,x) SIR(t,x,v,tau,g,total_active),times,[S0;I0;Q0]);
  
    figure(1);
    stimati=t<t_change(i)+ceil((t_change(i+1)-t_change(i))*Nest);
    plot(t,y(:,3),'linewidth',2,'Color',[0 0 1]);hold on;
    plot(t(stimati),y(stimati,3),'linewidth',2,'Color',[0 1 0]);
    line([times(end),times(end)],[0,2.5e5],'color','k')
end

% Registered data plot

plot(1:2:t_end,tab_data(1:2:end),'linewidth',1,'marker','o','MarkerSize',5,'color',[1 0 0 0.1]);

% plot settings 
set(gca,'xticklabel',datestr(t00+get(gca,'xtick')))
% ylim([0,0.15])
xtickangle(30)
xlabel('Days');
ylabel('C_i');
set( gcf, 'Position', [100 100 400 250])

%Save the image (vectorial .svg format)
print(gcf,'National_Fitting_Before_Merging_prediction.svg','-dsvg','-painters')

