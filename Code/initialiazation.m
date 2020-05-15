% INITIALIZATION-----------------------------------------------------------
assert((flux_control_on == 1 && (select == 1 || select == 4)) || flux_control_on ~= 1, 'Control selection not permitted');
assert(min_control_time > 1, 'minimum closing time permitted is 1');

sampling_time = 1;
time = 1 : sampling_time : final_time;

S = zeros(M, length(time));
I = zeros(M, length(time));
Q = zeros(M, length(time));        
H = zeros(M, length(time));
R = zeros(M, length(time)); 
D = zeros(M, length(time));
Costi = zeros(M, length(time));

H(:,1) = H0;
Q(:,1) = Q0;
R(:,1) = R0;
D(:,1) = D0;
I(:,1) = I0;
S(:,1) = N - I0 - H0 - Q0 - R0 - D0;

Q_max = Q0;

cost_l=[31.4298 4.4681 69.9871 11.9084 29.8356 100.7705 167.5870 36.1239 ...
        158.9877 51.0906 371.3046 44.0760 5.5289 132.8962 29.2866 76.8282 ...
        117.0966 41.5201 22.1100 174.3073];


% Next Generation Matrix settings
K_r = zeros(M, M, length(time));
K_c = zeros(M, M, length(time));
R_0_isolated = zeros(M, length(time));
R_0_connected = zeros(M, length(time));
R_0 = zeros(1,length(time));
mu_1_K = zeros(1, length(time));
mu_2_K = zeros(1, length(time));
mu_inf_K = zeros(1, length(time));

% CONTROL INITIALIZATION --------------------------------------------------
C_min=0.1;
C_max=0.2;

SD_ON = ones(M,length(time));
SD_OFF = zeros(M,length(time));

rho_0(index) = rho_max(index);
SD_ON(index,:) = 0;
SD_OFF(index,:) = 1;

SD_init = SD_ON(:,1);

if strcmp(flux_selector,'high')
    Phi_0 = Phi_open;
elseif strcmp(flux_selector,'low')
    Phi_0 = Phi_closed;
else
    error('FLUX NOT ADMISSIBLE');
end

Phi = zeros(M, M, length(time));
Phi(:, :, 1) = Phi_0;
rho = zeros(M,length(time));
rho(:,1) = rho_0;
alpha = zeros(M,length(time));
alpha(:,1) = alpha_0;

closed_times = zeros(M, length(time));  
opened_times = zeros(M, length(time));  
