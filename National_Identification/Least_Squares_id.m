function [pars] = Least_Squares_id(In,total_quar,total_hosp,eta,total_dead,tspan,tau)
    
    %% Initialization of the variables

    % pars= zeta, alpha, psi, kappaQ, kappaH

    Dq=diff(total_quar(tspan));
    Dh=diff(total_hosp(tspan));
    Dm=diff(total_dead(tspan));
   
    
  
    times=tspan(1:end-1)';
    
    %% zeta identification
    
    % Dm = zeta * totale_osp
    Phi=total_hosp(times);
    zeta=lsqlin(Phi,Dm);
    
    %% Identification of alpha psi, kappaQ and kappaH
    
    %definition of Y
    RHS=[Dq+eta(1)*total_quar(times);
         Dh+eta(2)*total_hosp(times)+zeta*total_hosp(times)];
    
    %definition of Phi
    Phi=[In(times),zeros(size(times)),-total_quar(times),total_hosp(times);
         zeros(size(times)),In(times),total_quar(times),-total_hosp(times)]; 
     
    %definition of contraints
    vincoli=-eye(4);    % positiveness 
    vincoliRHS=zeros(4,1);
    vincoli=[vincoli; [1 1 0 0; -1 -1 0 0]]; % Consistency with tau identified
    vincoliRHS=[vincoliRHS;tau*1.1;-tau*0.9];
    vincoli=[vincoli;       % bounddedness    
    0 0 1 0;          
    0 0 0 1];
    vincoliRHS=[vincoliRHS;
    0.1;0.1];

    %Run the identification
    pars=lsqlin(Phi,RHS,vincoli,vincoliRHS);
    pars=[eta;zeta;pars];
end

