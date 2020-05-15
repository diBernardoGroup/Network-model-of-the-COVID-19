# Network-model-of-the-COVID-19
Network model of the COVID-19 epidemic in Italy to design and investigate regional containment and mitigation strategies

The simulations are carried by a time-discrete model where each iteration is meant to be a day.
Here follows a list of all the files contained and their role in the numerical simulation. 

Main Scripts
1.  siqhrd_network_main.m runs a simulation with the nominal parameters contained in Parameters_Italy_ph2.mat.
2.  siqhrd_network_main_montecarlo runs Monte-Carlo simulations with perturbation of the nominal parameters contained in Parameters_Italy_ph2.mat.

In both main scripts you can set the following quantities:

1.  flux_selector: you can decide to use pre-lockdown nominal fluxes contained in flux_mat.mat with 'high' attribute or the one with lockdown reduced outfluxes with the 'low' attribute.
2.  select: you can decide to run a simulation with the nominal parameters by setting select to '0', with bang-bang regional control by setting select at  '1', with forced social distancing (increased rho) by setting select to '2', with no social distancing at all by setting select to '3' or with a bang=bang national control by setting select at '4'.
3.  index: if you want to individually set one region to deactivate its social distancing you can put the name of such a region and set select to '0'.
4.  flux_control_on: you can activate the bang-bang control also on fluxes by setting  flux_control_on to '1'. In this case, you have to set select to '1' or '4' also.
5.  min_control_time: when the bang-bang strategy is activated min_control_time assures that when each region decides to either lockdown or release it keeps its decision for at least min_control_time days.
6.  final_time: number of days to simulate.
    
In siqhrd_network_main_montecarlo you can also select:    

1.  N_param_var: number of Monte-Carlo simulations.
2.  perc: maximum ratio of parameter variations.
3.  orthogonal: if set to '1' runs an Orthogonal Latin Hypercube for the perturbed parameters generation (each region has its own hypercube).

data_wrapper.m
This script loads all the nominal parameters contained in Parameters_Italy_ph2.mat, flux_mat.mat and data_italy_ph2.m.
    
initialization.m
This script generates state variables and sets up the simulations. Here you also select:
1.  C_min: lower threshold of bang-bang control.
2.  C_max: higher threshold of bang-bang control.

hypercube_gen.m
This script generates the hypercubes for the perturbed parameters according to the selection of the variable 'orthogonal' in the main script.

simulate_dynamics.m
This script updates state variables according to the model described in the paper. This is called only from the siqhrd_network_main.m since the Monte-Carlo simulations are run with a parfor loop.  

show_data.m/show_data_montecarlo.m
They generate plots of the simulation and calculate their metrics outcome which are:

1.  tot_c: total cases during the simulation.
2.  tot_d: total deaths during the simulation.
3.  max_hosp: national peak value of hospitalized during the simulation.
4.  maxNHSSat: maximum consecutive days over ICU capacity of hospitalized in the nation.
5.  sum_reg_ov: number of regions that exceeded their ICU capacity.
6.  final_costs: economic costs due to lockdown days.

If a Monte-Carlo simulation is run the average and standard deviation of such quantities is calculated.

contol_strategy_rho.m
This function updates the social distancing factor (rho) according to the selection of the variable 'select' of the main scripts. If the bang-bang strategy is selected the social distancing is activated every time the ratio between current ICU used and the maximum value is greater than the upper threshold 'C-max' (which is set by default at 0.2 inside the script 'initialization') and a number of days at least equal to the one set in 'min_control_time' (see main scripts) has passed since the last decision.

control_strategy_flux.m
This function updates the flux matrix according to the selection of the variables 'flux_selector' and 'flux_control_on' of the main scripts.

next_gen_matrix_update.m
This function calculates the next-generation matrix alongside the basic reproduction number both national and regional (only for nominal simulations). 

data_italy_ph2.m
This script contains the initial condition of the simulations and loads the model parameters contained in Parameters_Italy_ph2.mat.
