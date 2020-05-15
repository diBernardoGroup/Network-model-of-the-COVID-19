function [pars] = Identify_Model(data,initial_guess,lim_inf,lim_sup,times,N,total_active)

scalefac=100;

%Initialize the initial guess for each parameter
v=initial_guess.v;
It0=initial_guess.It0;
tau=initial_guess.tau;
g=0.07;

lim_inf(3)=lim_inf(3)/scalefac;
lim_sup(3)=lim_sup(3)/scalefac;


%Identify the model parameters
options=optimset('MaxIter',100,'TolFun',1e-6,'TolX',1e-6);
parmin=fmincon(@(pars) error_SIR(data,[pars(1),pars(2),g,scalefac*pars(3)],times,N,total_active),[v,tau,It0],[],[],[],[],lim_inf,lim_sup,[],options);
pars=num2cell([parmin(1:2),scalefac*parmin(3)]);

pars=[pars(1),pars(2),g,pars(3)];

end

