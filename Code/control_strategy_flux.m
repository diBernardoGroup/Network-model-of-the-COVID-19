function Phi_out = control_strategy_flux(Phi_open,perc,SD_ON,M)
%{
Takes as input:
 1 - Phi_open: nominal flux matrix,
 2 - perc: the reduction ratio of outfluxes (perc), 
 3 - SD_ON: array containing '1' if the region is in lockdown and 0 otherwise,
 4 - M: the number of regions.
Gives as output:
 1 - Phi_out: the updated flux matrix.
%}
    Phi_out = Phi_open;
    for i = 1 : M
        if SD_ON(i) == 1
            Phi_out(i,:) = perc * Phi_open(i,:);
            Phi_out(:,i) = perc * Phi_open(:,i);
        end
    end
    
    for i = 1 : M
        Phi_out(i, i) = 1 - (sum(Phi_out(i,:)) - Phi_out(i,i));
    end
end