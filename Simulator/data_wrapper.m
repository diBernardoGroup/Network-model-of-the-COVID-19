regions = {'abruzzo',  'aosta',   'apulia',   'basilicata', 'calabria', ...
		   'campania', 'emilia',  'friuli',   'lazio',      'liguria', ...
		   'lombardy', 'marche',  'molise',   'piedmont',   'sardinia', ...
		   'sicily',   'tuscany', 'trentino', 'umbria',    'veneto'};
M = length(regions);
region2index = containers.Map(regions, 1:M);
index2region = containers.Map(1:M, regions);

data_italy_ph2

assert(not(rho_factor > 1 || rho_factor < 0), 'rho_factor not permitted.');
assert(not(test_factor < 0), 'test_factor not permitted.');

% MODEL PARAMETERS --------------------------------------------------------
rho_0 = zeros(M, 1);
gamma = zeros(M, 1);
alpha_0 = zeros(M, 1);
kappa = zeros(M, 1);
kappa_H = zeros(M, 1);
psi = zeros(M, 1);
eta_Q = zeros(M, 1);
eta_H = zeros(M, 1);
I0 = zeros(M, 1);
R0 = zeros(M, 1);
Q0 = zeros(M, 1);
D0 = zeros(M, 1);
H0 = zeros(M, 1);
beta  = 0.4 * ones(M, 1);
for i = 1 : M
    rho_0(i) = v_identified(regions{i}) / beta(i);
    gamma(i) = gamma_identified(regions{i});
    alpha_0(i) = test_factor * alpha_identified(regions{i});    
    kappa(i) = kappa_identified(regions{i});
    kappa_H(i) = kappa_H_identified(regions{i});
    psi(i)   = psi_identified(regions{i});
    eta_Q(i) = eta_Q_identified(regions{i});
    eta_H(i) = eta_H_identified(regions{i});
    I0(i)   = initial_infected_identified(regions{i});
    Q0(i)   = quarantined(regions{i});
    H0(i)   = hospitalized(regions{i});
    R0(i)   = recovered(regions{i});
    D0(i)   = dead(regions{i});
end
zeta_baseline = zeta_baseline_identified;
zeta_slope = zeta_slope_identified;

rho_max = min(1,rho_factor * 3 * rho_0);
rho_min = rho_0;

% FLUXES ------------------------------------------------------------------
load('flux_mat')
Phi_self = zeros(M);
for i = 1 : M
    Phi_self(i, i) = 1 - sum(Phi_add(i,:) + Phi_rsa(i,:));
end
Phi_open = Phi_self + Phi_add + Phi_rsa;

Phi_closed = 0.3 * (Phi_open -  diag(Phi_open) .* eye(M));
for i = 1 : M
    Phi_closed(i, i) = 1 - sum(0.3*Phi_add(i,:) + 0.3*Phi_rsa(i,:));
end

assert(not(all(sum(Phi_open, 2) == ones(M, 1))), 'Flux matrix is not normalized.');
assert(not(all(sum(Phi_closed, 2) == ones(M, 1))), 'Flux matrix is not normalized.');

N = zeros(M, 1);		
H_max = zeros(M, 1);
for i = 1 : M
	N(i) = population(regions{i});
	H_max(i) = beds_intensive_care(regions{i});
end

index = false(1,M);