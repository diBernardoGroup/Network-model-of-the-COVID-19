for t = 1 : length(time) - 1
    
    if select ~= 0                                                                   
        [rho(:, t+1), SD_OFF(:,t+1), SD_ON(:,t+1), closed_times(:,t+1), opened_times(:,t+1)] = ...
            control_strategy_rho(rho(:, t),0.1 * H(:, t),H_max,rho_min,rho_max,C_min,C_max,select,closed_times(:,t),opened_times(:,t),min_control_time);
    else
        rho(:, t+1) = rho_0;
    end
    alpha(:, t+1) = alpha_0;

    if flux_control_on == 1
        Phi(:, :, t+1) = control_strategy_flux(Phi_open,0.3,SD_ON(:,t),M);
    else
        Phi(:, :, t+1) = Phi_0;
    end
    
    N_p = Phi(:, :, t)' * (S(:, t) + I(:, t) + R(:, t));
    
    [mu_1_K(t),mu_2_K(t),mu_inf_K(t),R_0(t),R_0_connected(:,t),...
     K_r(:,:,t),K_c(:,:,t)] = next_gen_matrix_update(M,N,N_p,Phi(:,:,t),rho(:,t),beta,alpha(:,t),gamma,psi(:));
    
    R_0_isolated(:,t) = (rho(:,t) .* beta) ./ (gamma + alpha(:,t) + psi(:));
    
    for i = 1 : M
        s = 0;
        for j = 1 : M
            s = s + rho(j, t) * beta(j) * Phi(i, j, t) * S(i, t) * ...
                sum(Phi(:, j, t)' * I(:, t) / N_p(j));
        end
        
        zeta_i = zeta_baseline + zeta_slope * min(0.1 * H(i, t) / H_max(i),1);
        S(i, t+1) = S(i, t) - s;
        I(i, t+1) = I(i, t) + s - (gamma(i) + alpha(i,t) + psi(i)) * I(i, t);
        Q(i, t+1) = Q(i, t) + alpha(i,t) * I(i, t)...
                    - (kappa(i) + eta_Q(i)) * Q(i, t) + kappa_H(i) * H(i,t);
        H(i, t+1) = H(i, t) + psi(i) * I(i, t) - (eta_H(i) + zeta_i) ...
                    * H(i, t) + kappa(i) * Q(i, t) - kappa_H(i) * H(i,t);
        R(i, t+1) = R(i, t) + gamma(i) * I(i, t) + eta_Q(i) * Q(i, t) ...
                    + eta_H(i) * H(i, t);
        D(i, t+1) = D(i, t) + zeta_i * H(i, t);
        
        if SD_ON(i,t) == 1
           Costi(i, t+1) = Costi(i, t) + cost_l(i);
        else
           Costi(i, t+1) = Costi(i, t) ; 
        end
    end
end

R_0_isolated(:,final_time) = (rho(:,final_time) .* beta) ./ (gamma + alpha(:,final_time) + psi(:));

[mu_1_K(final_time),mu_2_K(final_time),mu_inf_K(final_time),...
 R_0(final_time),R_0_connected(:,final_time),K_r(:,:,final_time),...
 K_c(:,:,final_time)] = next_gen_matrix_update(M,N,N_p,Phi(:,:,final_time),rho(:,final_time),beta,alpha(:,final_time),gamma,psi(:));

[H_peak, peak_day_H] = max(H, [], 2);
regions_over_capacity = zeros(M, 1);
for i = 1 : M
	if H_peak(i) > H_max(i)
		regions_over_capacity(i) = 1;
	end
end
