function y=SIR(t,x,v,tau,g,totale_attivi)
    y=zeros(3,1);
    y(1)=-v*x(1)*x(2)/totale_attivi(t);           % S
    y(2)=v*x(1)*x(2)/totale_attivi(t)-(tau+g)*x(2);   % I
    y(3)=tau*x(2);      % C
end