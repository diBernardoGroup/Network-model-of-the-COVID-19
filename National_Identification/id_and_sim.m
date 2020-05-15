function [pars,y,If] = id_and_sim(tab_data,ti,te,initial_guess,N,total_active)

%Take data needed for identification
data=tab_data(:,ti:te);
g=initial_guess.g;
It0=initial_guess.It0;
v=initial_guess.v;
tau=initial_guess.tau;

%Define the constrints for the identification
lim_sup=[v*10, tau*1.5, It0*1.3];
lim_inf=[v*0, tau*0.9, It0*0.7];


times=ti:te;

%identify the model parameters
pars=Identify_Model(data,initial_guess,lim_inf,lim_sup,times,N,total_active);
[v,tau,g,I0]=deal(pars{:});
clc;


%Simulate the model 
Q0=tab_data(1,ti);
S0=N-I0-Q0;
[t,y]=ode45(@(t,x) SIR(t,x,v,tau,g,total_active),times,[S0;I0;Q0]);
if length(times)==2
    t=[t(1),t(end)];
    y=[y(1,:);y(end,:)];
end


%Compare model predictions with the data recodeded (see how good the
%fitting is
figure(1);
plot(t,y(:,3)), line(t',data(1,:),'marker','o','color','red'); hold off;
drawnow;


%Save the outpus in the form needed for the next steps
If=y(end-1,2);

y=reshape(y(:,3)',[size(y(:,3),1) 1]);

end

