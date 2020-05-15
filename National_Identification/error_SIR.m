function [costo]=error_SIR(data,pars,tempi,N,totale_attivi)

%Assign the parameters
pars=num2cell(pars);
[v,tau,g,I0]=deal(pars{:});

%Simulate the model
T=size(data,2);
Q0=data(1,1);
S0=N-I0-Q0;
[~,y]=ode45(@(t,x) SIR(t,x,v,tau,g,totale_attivi),tempi,[S0;I0;Q0]);
if length(tempi)==2
    y=[y(1,:);y(end,:)];
end

%Identify on the normalized data (Data/mean data)
costo=sum(((diff(sum(data,1))./sum(data(:,2:end),1))-(diff(sum(y(:,3),2))./sum(y(2:end,3),2))').^2);%+0.05*(pars{1}+pars{2})^2;

end