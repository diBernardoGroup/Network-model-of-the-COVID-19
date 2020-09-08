%{
This is one of the mains, with this script you can run simulation with
nominal parameters. You can set different senarios with the variables
within the scenario settings.
%}

clear; clc; close all

% SCENARIO SETTINGS -------------------------------------------------------
flux_selector = 'high';                                                     % Sets intial fluxes to nominal ('high') or reduced by 70% ('low')
test_factor = 1;                                                            % Test capacity multiplier (positive value)
rho_factor = 1;                                                             % Lockdown release modulator (subject to be between 0 and 1)


disp('Loading data...');
data_wrapper

% index = region2index('lombardy');                                         % Stops social distancing (Set select to 0 if you want to activate it)
 
select = 1;                                                                 % 0:no control| 1:regional bang-bang control| 2:social distancing on| 3:social distancing off| 4:national bang-bang control
flux_control_on = 1;                                                        % flag for flux control activation
min_control_time = 7;                                                       % control decision can not be undone for at least min_control_time days (minimum value is 1)

final_time = 365;                                                           % sets simulation horizon (days)

initialiazation

% SIMULATION --------------------------------------------------------------
disp('Starting simulation...');
simulate_dynamics

% RESULTS -----------------------------------------------------------------
disp('Plotting results...');
show_data
