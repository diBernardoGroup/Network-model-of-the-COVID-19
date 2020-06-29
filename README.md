# Network-model-of-the-COVID-19
Network model of the COVID-19 epidemic in Italy to design and investigate regional containment and mitigation strategies

----------------------------------------------------------------------------------------------------------------------------------------------------
SIMULATOR DESCRIPTION


The simulations are carried by a time-discrete model where each iteration is meant to be a day.
Here follows a list of all the files contained and their role in the numerical simulations contained in the folder 'Code'. 

MAIN SCRIPTS
1.  'siqhrd_network_main.m' runs a simulation with the nominal parameters contained in 'Parameters_Italy_ph2.mat'.
2.  'siqhrd_network_main_montecarlo.m' runs Monte-Carlo simulations with perturbation of the nominal parameters contained in 'Parameters_Italy_ph2.mat'.

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

'data_wrapper.m':
This script loads all the nominal parameters contained in Parameters_Italy_ph2.mat, flux_mat.mat and data_italy_ph2.m.
    
'initialization.m':
This script generates state variables and sets up the simulations. Here you also select:
1.  C_min: lower threshold of bang-bang control.
2.  C_max: higher threshold of bang-bang control.

'hypercube_gen.m':
This script generates the hypercubes for the perturbed parameters according to the selection of the variable 'orthogonal' in the main script.

'simulate_dynamics.m':
This script updates state variables according to the model described in the paper. This is called only from the siqhrd_network_main.m since the Monte-Carlo simulations are run with a parfor loop.  

'show_data.m'/'show_data_montecarlo.m':
They generate plots of the simulation and calculate their metrics outcome which are:

1.  tot_c: total cases during the simulation.
2.  tot_d: total deaths during the simulation.
3.  max_hosp: national peak value of hospitalized during the simulation.
4.  maxNHSSat: maximum consecutive days over ICU capacity of hospitalized in the nation.
5.  sum_reg_ov: number of regions that exceeded their ICU capacity.
6.  final_costs: economic costs due to lockdown days.

If a Monte-Carlo simulation is run the average and standard deviation of such quantities is calculated.

'contol_strategy_rho.m':
This function updates the social distancing factor (rho) according to the selection of the variable 'select' of the main scripts. If the bang-bang strategy is selected the social distancing is activated every time the ratio between current ICU used and the maximum value is greater than the upper threshold 'C-max' (which is set by default at 0.2 inside the script 'initialization') and a number of days at least equal to the one set in 'min_control_time' (see main scripts) has passed since the last decision.

'control_strategy_flux.m':
This function updates the flux matrix according to the selection of the variables 'flux_selector' and 'flux_control_on' of the main scripts.

'next_gen_matrix_update.m':
This function calculates the next-generation matrix alongside the basic reproduction number both national and regional (only for nominal simulations). 

'data_italy_ph2.m':
This script contains the initial condition of the simulations and loads the model parameters contained in Parameters_Italy_ph2.mat.

SCENARIO GENERATION ISTRUCTIONS


In this secition we provide a slection of rules to replicate the numerical results showed in the paper.

OPEN LOOP SCENARIOS


To replcate open loop scenarios you need to run 'siqhrd_network_main_montecarlo.m' with the followiing quantities:
1.  flux_selector: set this quantity to 'high' (figures S1,S2,S3) or 'low' (figure Fig2). 
2.  select: set this quantity to '0' (figures Fig2, S1), to '2' (figure S3), to '3' (figure S2) 
3.  index: put the name the region where you want to force deactivation of social distancing as in figures Fig2, S1 (works only if select is set to '0').
4.  flux_control_on: set this quantity to '0'.

CLOSED LOOP SCENARIOS


To replcate closed loop scenarios you need to run 'siqhrd_network_main_montecarlo.m' with the followiing quantities:
1.  flux_selector: setting this quantity to 'high' or 'low' will determine only initial condition for fluxes if flux_control_on is set '1'. 
2.  select: set this quantity to '1' (figures Fig3a, Fig3b, Fig4, S5, S7), to '4' (figure Fig3c, S2, S6) 
3.  flux_control_on: set this quantity to '1'.

----------------------------------------------------------------------------------------------------------------------------------------------------
IDENTIFICATION DESCRIPTION


Here is a list of the scripts used for the identification procedure alongside the procedure to reproduce the system identification.

IDENTIFICATION SCRIPTS


'stage1.m' and 'stage1_r.m' perform the identification of the time time windows and of \rho*\beta, \tau, I_0 values in each window using
national and regional data, respectively. The identification is performed using an ad hoc nonlinear identification
procedure.


'stage2.m' and 'stage2_r.m' identify \rho*\beta, \tau and I_0 values, given the time windows using an ad hoc nonlinear 
identification algorithm. 'stage2.m' is designed to work with national aggregate data while 'stage2_r.m' works with regional data.


'stage3.m' and 'stage3_r.m' identify the remaining parameters using an ordinary least squares algorithm on national
and regional data, respectively.
 
in 'stage2.m', 'stage2_r.m', 'stage1.m' and 'stage1_r.m' you need to select:
1. the initial guess for each parameter

Moreover, in 'stage2.m' and 'stage2_r.m' you need to select:
2. the time windows specified as an array whose elements are the starting points of each time window

read_national_data.m
Reads the national data from the Protezione Civile github repository

read_regional_data.m
Reads the regional data from the Protezione Civile github repository. Here you need to select:
1. the code of the region you want to analyse
2. the legth of the averaging filter


id_and_sim.m, id_and_sim_r.m
Identifies and compares model predictions with data collected


INPUT:     tab_data        (data vector to fit the model)
           ti              (initial time instant)
           te              (final time instant)
        initial_guess    (initial guess for the identification)
        N               (Number of residents)
        total_active    (Function of currently active people)
OUTPUT: pars            (parameters of the model (rho*beta, tau, g, I0)
        y               (model prediciton)
        If              (Final number of infected people)

Idendtify_model.m 
Identifies the parameters of the model (nonlinear part)

INPUT:  data            (data vector to fit the model)
        lim_inf         (Inferior limit for the parameters)
        lim_sup         (Superior limit for the parameters)
        times           (Time instants for the identification)
        initial_guess    (initial guess for the identification)
        N               (Number of residents)
        total_active    (Function of currently active people)

OUTPUT: pars            (Parameters identidied from the algorithm)

Find_Change
finds if there is a breakpoint in the window and where it happened

INPUT:  data            (data vector to fit the model)
        fit1            (model prediction in the first half of the window)
        fit2            (model prediction in the second half of the window)
        fitTot          (model prediction in the entire window)
        N               (Number of residents)
        total_active    (Function of currently active people)
        pr              (Parameters estimated in the entire window)
 

OUTPUT: Where           (Point where the parameter change happened)
        Change          (Boolean adivising a change in parameters)

 

Least_Squares_id
Runs the constrainde Least square identification (linear part)


INPUT:  In              (Infected time series)
        total_quar      (Quarantined time series)
        total_hosp      (Hospitalized time series)
        eta             (Eta identified)
        total_dead      (Dead time series)
        tspan           (Time frame for the identification)
        tau             (tau identified at stage 2)

OUTPUT: pars            (Parameters identified)

IDENTIFICATION PROCEDURE 

Regional Identification: In this section we provide instruction to run the identification procedure, given a region

1. Select the region code you want to analyse in 'read_regional_data.m' (movemeanK). 
2. Select the averaging filter length in 'read_regional_data.m'. 
3. Select the initial guess for the parameters in the script 'stage1_r.m'.
4. Run 'stage1_r.m'.
5. Merge the windows following the procedure described in the Section S2 of the SI.
6. Run 'stage2_r.m' given the time meged time windows obtained at point 5. .
7. Run 'stage3_r.m' .

National Identification: In this section we provide instruction to run the identification procedure of the national data
 
1. Select the averaging filter length in 'read_national_data.m' (movemeanK). 
2. Select the initial guess for the parameters in the script 'stage1_r.m'.
3. Run 'stage1.m'.
4. Merge the windows following the procedure described in the Section S2 of the SI.
5. Run 'stage2.m' given the time meged time windows obtained at point 4. .
6. Run 'stage3.m' .
