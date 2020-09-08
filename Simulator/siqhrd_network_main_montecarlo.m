%{
This is one of the mains, with this script you can run Monte-Carlo 
simulations perturbed parameters starting from their nominal value. 
You can set different senarios with the variables within the scenario 
settings.
%}

clear; clc; close all

% SCENARIO SETTINGS -------------------------------------------------------
scenario_name = 'name';                                                     % Give a name to your scenario to save figure and metrics
flux_selector = 'high';                                                     % Sets intial fluxes to nominal ('high') or reduced by 70% ('low')
test_factor = 1;                                                            % Test capacity multiplier (positive value)
rho_factor = 1;                                                             % Lockdown release modulator (subject to be between 0 and 1)

disp('Loading data...');
data_wrapper

% index = region2index('lombardy');                                         % Stops social distancing (Set select to 0 if you want to activate it)
 
select = 1;                                                                 % 0:no control| 1:regional bang-bang control| 2:social distancing on| 3:social distancing off| 4:national bang-bang control
flux_control_on = 1;                                                        % Flag for flux control activation
min_control_time = 7;                                                       % Control decision can not be undone for at least min_control_time days (minimum value is 1)

final_time = 365;                                                           % Sets simulation horizon (days)

initialiazation
simulate_dynamics

% GENERATION OF HYPERCUBES ------------------------------------------------
disp('Generating Hypercubes...');
N_param_var = 10;                                                        % Sets number of Monte-Carlo simulations
perc = 0.2;                                                                 % Sets variation ratio
orthogonal = 1;                                                             % Flag for Orthogonal Latin Hypercube activation
hypercube_gen;

% SIMULATION --------------------------------------------------------------
disp(strcat('Starting MonteCarlo simulations of scenario ',scenario_name,'...'));
S_hyp = zeros(M, length(time), N_param_var);
I_hyp = zeros(M, length(time), N_param_var);
Q_hyp = zeros(M, length(time), N_param_var);
H_hyp = zeros(M, length(time), N_param_var);
R_hyp = zeros(M, length(time), N_param_var);
D_hyp = zeros(M, length(time), N_param_var);

Costi_montecarlo = zeros(M, length(time), N_param_var);

parfor hyi = 1 : N_param_var
    
    S_hyp_1 = zeros(M, length(time));
    I_hyp_1 = zeros(M, length(time));
    Q_hyp_1 = zeros(M, length(time));
    H_hyp_1 = zeros(M, length(time));
    R_hyp_1 = zeros(M, length(time));
    D_hyp_1 = zeros(M, length(time));

    Q_hyp_1(:,1) = Q0;
    H_hyp_1(:,1) = H0;
    R_hyp_1(:,1) = R0;
    D_hyp_1(:,1) = D0;
    I_hyp_1(:,1) = I0_hyp(:,hyi);
    S_hyp_1(:,1) = N - I_hyp_1(:,1) - Q_hyp_1(:,1) - H_hyp_1(:,1) - R_hyp_1(:,1) - D_hyp_1(:,1);
    
    Phi = zeros(M, M, length(time));
    rho = zeros(M,length(time));
    alpha = zeros(M,length(time));

    Phi(:, :, 1) = Phi_0;
    rho(:,1) = rho_0;
    
    kappa = kappa_hyp(:,hyi);
    kappa_H = kappa_H_hyp(:,hyi);
    eta_Q = eta_Q_hyp(:,hyi);
    eta_H = eta_H_hyp(:,hyi);
    alpha(:,1) = alpha_0_hyp(:,hyi);
    psi = psi_hyp(:,hyi);
    
    Costi_parfor = zeros(M,length(time));
    closed_times_parfor = zeros(M, length(time));
    opened_times_parfor = zeros(M, length(time));
    SD_ON_parfor = ones(M,length(time));
    SD_ON_parfor(:,1) = SD_init;
    
    SD_OFF_parfor = ones(M,length(time));
    SD_OFF_parfor(:,1) = 1 - SD_init;
    
    for t = 1 : length(time) - 1

        if select ~= 0                                                                   
            [rho(:, t+1), SD_OFF_parfor(:,t+1), SD_ON_parfor(:,t+1), closed_times_parfor(:,t+1), opened_times_parfor(:,t+1)] = ...
                control_strategy_rho(rho(:, t),0.1 * H_hyp_1(:, t),H_max,rho_min,rho_max,C_min,C_max,select,closed_times_parfor(:,t),opened_times_parfor(:,t),min_control_time);
        else
            rho(:, t+1) = rho_0;
            SD_ON_parfor(:,t+1) = SD_init;
            SD_OFF_parfor(:,t+1) = 1 - SD_init;
        end
        alpha(:, t+1) = alpha_0_hyp(:,hyi);
        
        if flux_control_on == 1
            Phi(:, :, t+1) = control_strategy_flux(Phi_open,0.3,SD_ON_parfor(:,t),M);
        else
            Phi(:, :, t+1) = Phi_0;
        end

        N_p = Phi(:, :, t)' * (S_hyp_1(:, t) + I_hyp_1(:, t) + R_hyp_1(:, t));

        for i = 1 : M
            s = 0;
            for j = 1 : M
                s = s + rho(j, t) * beta(j) * Phi(i, j, t) * S_hyp_1(i, t) * ...
                    sum(Phi(:, j, t)' * I_hyp_1(:, t) / N_p(j));
            end
            zeta_i = zeta_baseline + zeta_slope * min(0.1 * H_hyp_1(i, t) / H_max(i),1);
            S_hyp_1(i, t+1) = S_hyp_1(i, t) - s;
            I_hyp_1(i, t+1) = I_hyp_1(i, t) + s - (gamma(i) + alpha(i,t) + psi(i)) * I_hyp_1(i, t);
            Q_hyp_1(i, t+1) = Q_hyp_1(i, t) + alpha(i,t) * I_hyp_1(i, t)...
                        - (kappa(i) + eta_Q(i)) * Q_hyp_1(i, t) + kappa_H(i) * H_hyp_1(i, t);
            H_hyp_1(i, t+1) = H_hyp_1(i, t) + psi(i) * I_hyp_1(i, t) - (eta_H(i) + zeta_i) ...
                        * H_hyp_1(i, t) + kappa(i) * Q_hyp_1(i, t) - kappa_H(i) * H_hyp_1(i, t);
            R_hyp_1(i, t+1) = R_hyp_1(i, t) + gamma(i) * I_hyp_1(i, t) + eta_Q(i) * Q_hyp_1(i, t) ...
                        + eta_H(i) * H_hyp_1(i, t);
            D_hyp_1(i, t+1) = D_hyp_1(i, t) + zeta_i * H_hyp_1(i, t);
            if SD_ON_parfor(i,t) == 1
                Costi_parfor(i, t+1) = Costi_parfor(i, t) + cost_l(i);
            else
                Costi_parfor(i, t+1) = Costi_parfor(i, t) ;
            end
        end
    end

    S_hyp(:,:,hyi) = S_hyp_1;
    I_hyp(:,:,hyi) = I_hyp_1;
    Q_hyp(:,:,hyi) = Q_hyp_1;
    H_hyp(:,:,hyi) = H_hyp_1;
    R_hyp(:,:,hyi) = R_hyp_1;
    D_hyp(:,:,hyi) = D_hyp_1;
    Costi_montecarlo(:,:,hyi) = Costi_parfor;
end 
    
% RESULTS -----------------------------------------------------------------
disp('Plotting results...');
show_data_montecarlo

% close all
% save(strcat(scenario_name,'.mat'))