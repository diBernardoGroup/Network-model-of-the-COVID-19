function [change,where]=Find_Change(data,fit1,fit2,fitTot,N,total_active,pr)

%Initialization of the variables
sized=size(data,2); 
data=reshape(data,[sized 1]);

%Computation of residuals
N1=length(fit1);
res1=fit1-data(1:N1);
N2=length(fit2);
res2=fit2-data(N1:end);
resTot=fitTot-data;

%SSE
SC=sum(resTot.^2);
S1=sum(res1.^2);
S2=sum(res2.^2);

%Fstat and pvaue computation
Fstat= (SC-S1-S2)/2/(S1+S2)*(N1+N2-4);
prob=fpdf(Fstat,2,N1+N2-4);

change=prob<1e-5; 


if change==1
    
    [v,tau,g,I0]=deal(pr{:});
    initial_guess.v=v;
    initial_guess.tau=tau;
    initial_guess.g=g;
    initial_guess.It0=I0;


    for T=3:sized
        
        [~,y3]=id_and_sim_r(data',1,T,initial_guess,N,total_active);
        
        resTot=y3-data(1:T);

        SC_Vec(T-2)=sum(resTot.^2)/T;      
        
    end
    
    [~,where]=min(SC_Vec);
    where=where+2;
    
else
    
    where=-1;
end








