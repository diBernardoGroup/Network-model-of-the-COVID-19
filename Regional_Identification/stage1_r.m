clear all; clc;



%% Load and read the data form GitHub

read_regional_data;

total_active_data  = N-total_quar-total_hosp-total_dead;
     
    

%% Initailization of varaibles

t00=737844;



parameters_t=[];

t_init=1;
t_curr=6;
t_end=length(total_rec);
t_change=[1]; %Time window start vector
total_active  = @(t) interp1(1:t_end,total_active_data,t); 

%Definition of the initial guess
initial_guess.It0=1200;
initial_guess.v=0.97;
initial_guess.g=0.07;  
initial_guess.tau=0.066;
It0=initial_guess.It0;

parameters=[];


%% Identify the time windows


while t_curr<=t_end
    
    
    %Compute the middle point of the current interval
    Data_sep=t_init+floor((t_curr-t_init)/2);
    
    %Identify the parameters in first the half of the window
    [pars,y,If]=id_and_sim_r(tab_data,t_init,Data_sep,initial_guess,N,total_active);
    
    %Update the initial guess
    [v,tau,g,I0]=deal(pars{:});
    initial_guess.g=g;
    initial_guess.It0=If;
    
    %Identify the parameters in the second half of the window
    [~,y2]=id_and_sim_r(tab_data,Data_sep,t_curr,initial_guess,N,total_active);
    
    %Update the initial guess
    initial_guess.It0=It0;
    
    
    %Identify the parameters in the entire window
    [p3,y3]=id_and_sim_r(tab_data,t_init,t_curr,initial_guess,N,total_active);   
    
    
    %Find if there is a change and where it occurred
    [Change,Where]=Find_Change_r(tab_data(:,t_init:t_curr),y,y2,y3,N,@(t) interp1(1:t_end-t_init+1,total_active_data(t_init:t_end),t),p3);
    
    
    if(Change==1)
       
       
       t_change=[t_change, t_init+Where];
       
       %Identify the model again
       [pars,~,If]=id_and_sim_r(tab_data,t_init,t_change(end),initial_guess,N,total_active);   
       It0=If;
       
       
       %Update the initial guess for the next window
       initial_guess.It0=If;
       initial_guess.v=v;  %new
       initial_guess.tau=tau;
       
       %save the parameters found
       [v,tau,g,I0]=deal(pars{:});
       parameters=[parameters;[v,tau,g,I0,If]];
       
       
       %Update the new guess of the endpoint of the time window
       t_init=t_change(end)+1;
       if t_curr-t_init<7
          t_curr=t_change(end)+7;
       else
          t_curr=t_curr+1;
       end
    else
       
       %Update the estimate of the length
       t_curr=t_curr+1;
    
    end
    
end


% Identify the parameters in the last time window
if t_change(end)<t_end
    
    
    [pars,~,If]=id_and_sim_r(tab_data,t_change(end),t_end,initial_guess,N,total_active);   
    [v,tau,g,I0]=deal(pars{:});

    
    parameters=[parameters;[v,tau,g,I0,If]];
    
end

fprintf('Parameters changed at times: \n');
disp(t_change);

%%  PLOT

%Model prediction plot
close;
figure('pos',[100 100 400 250]); clf;
In=zeros(t_end,1);
t_change=[t_change,t_end];
for i=1:length(t_change)-1

    times=t_change(i):t_change(i+1); 
    par_curr=num2cell(parameters(i,:));
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
ylim([0,tab_data(end)])
xtickangle(30)
% set(gca,'FontSize',14);
set( gcf, 'Position', [100 100 400 250])

%Save the data needed for the next stage
% save National_stage1 In parameters_t T_C





