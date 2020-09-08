function [rho_out,SD_off,SD_on,closed_times_out,opened_times_out] = control_strategy_rho(rho,H,H_max,rho_min,rho_max,C_min,C_max,select,closed_times,opened_times,min_days)
%{
Takes as input:
 1 - rho: array of regional social distancing factors,
 2 - H: array of current regional ICU beds in use,
 3 - H_max: array of maximum regional ICU beds, 
 4 - rho_min: array of regional social distancing factors with lockdown, 
 5 - rho_min: array of regional social distancing factors without lockdown, 
 6 - C_max: upper control threshold,
 7 - C_min: lower control threshold,
 8 - select: control strategy to apply the arrays of times
 9 - closed_times: array of the number of consecutive days each region has been in lockdown,
 10 - opened_times: array of the number of consecutive days each region has not been in lockdown,
 11 - min_days: minumum number of days between each change of control action. 

Gives as output:
 1 - rho_out: updated array of regional social distancing factors, 
 2 - SD_on: array containing '1' if the region is in lockdown '0' otherwise,
 3 - SD_off: array containing '1' if the region is not lockdown '0' otherwise,
 4 - closed_times_out: the updated array of consecutive days of lockdown, 
 4 - opened_times_out: the updated array of consecutive days of no lockdown, 
%}  
    if select == 1
        Capt = H./H_max;
        rho_out = rho;
        
        SD_on = (Capt>=C_max) & (opened_times > min_days | opened_times == 0);   
        
        SD_off = (Capt<C_min) & (closed_times > min_days | closed_times == 0);
        
        rho_out(SD_on) = rho_min(SD_on);
        rho_out(SD_off) = rho_max(SD_off);
        
        temp_SD = (rho_out == rho_min);
        SD_on(temp_SD) = 1;
        SD_off = (~SD_on);
        
        closed_times = closed_times + SD_on;
        closed_times(SD_off) = 0;
        opened_times = opened_times + SD_off;
        opened_times(SD_on) = 0;
        
    elseif select == 2
        rho_out = rho_min;
        SD_on = ones(size(rho));
        SD_off = zeros(size(rho));
        
    elseif select == 3
        rho_out = rho_max;
        SD_on = zeros(size(rho));
        SD_off = ones(size(rho));
        
    elseif select == 4
        H_n = sum(H,1);
        H_n_max = sum(H_max);
        Capt = H_n/H_n_max;
        rho_out = rho;
        
        SD_on = (true(size(rho)) & (Capt>=C_max)) & (opened_times > min_days | opened_times == 0);   
        SD_off = (true(size(rho)) & (Capt<C_min)) & (closed_times > min_days | closed_times == 0);
        
        rho_out(SD_on) = rho_min(SD_on);
        rho_out(SD_off) = rho_max(SD_off);
        
        temp_SD = (rho_out == rho_min);
        SD_on(temp_SD) = 1;
        SD_off = (~SD_on);
        
        closed_times = closed_times + SD_on;
        closed_times(SD_off) = 0;
        opened_times = opened_times + SD_off;
        opened_times(SD_on) = 0;
    end
    
    closed_times_out = closed_times;
    opened_times_out = opened_times;

end