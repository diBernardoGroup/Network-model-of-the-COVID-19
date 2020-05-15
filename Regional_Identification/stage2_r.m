clear all;clc;close;
movmeanK=3;

read_regional_data;

%% Initialization of the variables

t00=737844;

T_C=[1 21]; % time windows befor the offline merging

% T_C=[1 11 14 20 25 31 33 38]; % time windows after the offline merging

t_end=length(total_active);
total_active  = @(t) interp1(1:t_end,total_active,t); 
t_change=[T_C,t_end];
parameters_t=[];
initial_guess.It0=1200;
initial_guess.v=0.77;
initial_guess.g=0.07;  
initial_guess.tau=0.066;

%% Identify the model parameters in the different time windows

for i=1:(length(t_change)-1)
    
    [pars,y,If]=id_and_sim_r(tab_data,t_change(i),t_change(i+1),initial_guess,N,total_active);
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
set(gca,'xticklabel',datestr(t00+start_count+get(gca,'xtick')))
ylim([0,tab_data(end)])
xtickangle(30)
% set(gca,'FontSize',14);
set( gcf, 'Position', [100 100 400 250])

%Save the data needed for the next stage
save Regional_stage1 In parameters_t T_C

