% REGIONAL PARAMETER PERTURBATION -----------------------------------------
nominal_param_values = [I0, kappa, kappa_H, eta_Q, alpha_0, psi];
N_param = length(nominal_param_values(1,:));

params = zeros(M, N_param_var, N_param);
max_percs = perc * ones(M,N_param);
min_percs = -perc * ones(M,N_param);
amplitudes = (max_percs - min_percs);

if orthogonal ==1
    % orthogonal latin hypercube
    for i = 1 : M
        cube = lhsdesign(N_param_var, N_param);
        for k = 1 : N_param
            params(i,:,k) = (cube(:,k) * amplitudes(i,k) + ...
                            min_percs(i,k) + 1) * nominal_param_values(i,k) ;
        end
    end
else
    
    % complete latin hypercube
    cube = lhsdesign(N_param_var, M * N_param);
    for i = 1 : M
        for k = 1 : N_param
            params(i,:,k) = (cube(:, k*i) * amplitudes(i, k) + ...
                            min_percs(i, k) + 1) * nominal_param_values(i,k) ;
        end
    end
end

I0_hyp = squeeze(params(:,:,1));
kappa_hyp = squeeze(params(:,:,2));
kappa_H_hyp = squeeze(params(:,:,3));
eta_Q_hyp = squeeze(params(:,:,4));
alpha_0_hyp = squeeze(params(:,:,5));
psi_hyp = squeeze(params(:,:,6));

clear('params')