# Network-model-of-the-COVID-19: General Introduction
Welcome to the repository related to the paper 'Intermittent yet coordinated regional strategies can alleviate the COVID-19 epidemic: a network model of the Italian case'


https://arxiv.org/abs/2005.07594


**SYSTEM REQUIREMENTS**

All the scripts listed were developed using MATLAB R2018b on Windows 10 (64-bit) OS.
The hardware used for simulations is an Intel Core i7-8750 chip and 16Gb RAM DDR4.
With this system, each of the simulations with 10000 repetitions for Montecarlo campaign takes approximately 10 minutes. 

**REPOSITORY ORGANIZATION** 

The repository is organized as follows:
1. The folder 'Figures' contains the .fig files of the plots showed in the paper as well as two functions to extract final data from them;
2. The folder 'Input Data' contains all the the data collected and their source to conduct the numerical campaign.
3. The folders 'National_Identification' and 'Regional_Identification' contain the scripts for the regional and national identification procedures;
4. Both the above identification folders contain a .txt that can be used to read the data off-line (read_national_data and read_regional_data provide the option to also read the latest data from 'Protezione Civile' github repository-see the corresponding files for more details);
5. Both the above identification folders contain a .mat that can be used to run directly the stage3.m (this .mat file is generated as an output from stage2.m therefore it is not needed if one wants to run the identification from stage1.m).
6. The scripts related to the network model are in located in the folder 'Simulator';

The folder 'Simulator' already contains the parameters from the paper to simulate the network model. If one wants to re-run the identification with more updated parameters one should first launch the identification procedure. In particular, after running the identification procedure as described in the identification section, one should manually format the data as in the example file 'Parameters_Italy_ph2.mat' (check section CUSTOMIZED SCENARIOS' for more info).

**READ ME CONTENTS ORGANIZATION**

This READ ME is organized as follows:
1. Section 'Simulator Description' includes the scripts implementing the simulator used for the model and their functionality;
1. Section 'Identification Description' includes the scripts implementing the identification procedure of the paper and their functionality;
3. Section 'Demo and Code Usage' includes the instruction to repeat the identification procedure and carry numerical simulations.
----------------------------------------------------------------------------------------------------------------------------------------------------
# Simulator Description


The simulations are carried by a time-discrete model where each iteration is meant to be a day.
Here follows a list of all the files contained and their role in the numerical simulations contained in the folder 'Simulator'. 

MAIN SCRIPTS
1.  'siqhrd_network_main.m' runs a simulation with the nominal parameters contained in 'Parameters_Italy_ph2.mat';
2.  'siqhrd_network_main_montecarlo.m' runs Monte-Carlo simulations with perturbation of the nominal parameters contained in 'Parameters_Italy_ph2.mat'.

In both main scripts you can set the following quantities:

1.  flux_selector: you can decide to use pre-lockdown nominal fluxes contained in flux_mat.mat with 'high' attribute or the one with lockdown reduced outfluxes with the 'low' attribute;
2.  select: you can decide to run a simulation with the nominal parameters by setting select to '0', with bang-bang regional control by setting select at  '1', with forced social distancing (increased rho) by setting select to '2', with no social distancing at all by setting select to '3' or with a bang=bang national control by setting select at '4';
3.  index: if you want to individually set one region to deactivate its social distancing you can put the name of such a region and set select to '0';
4.  flux_control_on: you can activate the bang-bang control also on fluxes by setting  flux_control_on to '1'. In this case, you have to set select to '1' or '4' also;
5.  min_control_time: when the bang-bang strategy is activated min_control_time assures that when each region decides to either lockdown or release it keeps its decision for at least min_control_time days;
6.  final_time: number of days to simulate.
    
In siqhrd_network_main_montecarlo you can also select:    

1.  N_param_var: number of Monte-Carlo simulations;
2.  perc: the maximum ratio of parameter variations;
3.  orthogonal: if set to '1' runs an Orthogonal Latin Hypercube for the perturbed parameters generation (each region has its own hypercube).

OTHER SCRIPTS

'data_wrapper.m':
This script loads all the nominal parameters contained in Parameters_Italy_ph2.mat, flux_mat.mat and data_italy_ph2.m.
    
'initialization.m':
This script generates state variables and sets up the simulations. Here you also select:
1.  C_min: lower threshold of bang-bang control;
2.  C_max: higher threshold of bang-bang control.

'hypercube_gen.m':
This script generates the hypercubes for the perturbed parameters according to the selection of the variable 'orthogonal' in the main script.

'simulate_dynamics.m':
This script updates state variables according to the model described in the paper. This is called only from the siqhrd_network_main.m since the Monte-Carlo simulations are run with a parfor loop.  

'show_data.m'/'show_data_montecarlo.m':
They generate plots of the simulation and calculate their metrics outcome which are:

1.  tot_c: total cases during the simulation;
2.  tot_d: total deaths during the simulation;
3.  max_hosp: national peak value of hospitalized during the simulation;
4.  maxNHSSat: maximum consecutive days over ICU capacity of hospitalized in the nation;
5.  sum_reg_ov: number of regions that exceeded their ICU capacity;
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

DATA FILES

'Parameters_Italy_ph2.mat':
This data file contains the parameters obtained from the identification procedure:
1. v (product between rho and beta);
2. alpha;
3. etah; 
4. etaq;
5. I0;
6. kappa;
7. kappah;
8. psi.


Each one of the listed parameters is an array of 20 elements representing the Italian regions in the following order:
1. piedmont;
2. aosta;
3. lombardy;
4. trentino;
5. veneto;
6. friuli;
7. liguria;
8. emilia;
9. tuscany;
10. umbria;
11. marche;
12. lazio;
13. abruzzo;
14. molise;
15. campania;
16. apulia;
17. basilicata;
18. calabria;
19. sicily;
20. sardinia.

Note that this is the order used to generate the parameters through the identification procedure and must be kept for any parameter generation. The simulator then reorders the elements in alphabetical order as shown in the plots. 


'flux_mat.mat':
Contains two matrices:
1. Phi_rsa: Fluxes deriving from railways, seals, and airports; 
2. Phi_add: An estimation of private travels between regions (eg. cars).

These two matrices are used to create the final flux matrix that introduces the diagonal auto fluxes such that the sum on each row is equal to 1. From this matrix is also obtained its post lockdown version with reduced outfluxes by 70%. These operations are carried inside the script 'data_wrapper.m". 

----------------------------------------------------------------------------------------------------------------------------------------------------
# Identification Description


'stage1.m' and 'stage1_r.m' perform the identification of the time windows and of \rho*\beta, \tau, I_0 values in each window using
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

'Regional_stage1.mat' and 'National_stage1.mat' contain the parameters obtained after stage 1 and stage 2 of the identification procedure described in the SI. They embed a numerical matrix organized as follows: Each row corresponds to a time window and each column represents a parameter. Specifically, the columns correspond, in order, to :
1. v (product between rho and beta);
2. tau;
3. gamma;
4. I0;
5. If.

'Regional_stage2.mat' and 'National_stage2.mat' contain the parameters obtained after stage 3 of the identification procedure described in the SI. They embed a numerical matrix organized as follows: Each column corresponds to a time window and each row represents a parameter. Specifically, the columns correspond, in order, to:
1. etaq;
1. etah;
2. zeta;
3. alpha;
4. psi;
5. kappaq;
6. kappa.

read_national_data.m: 
Reads the national data from the Protezione Civile github repository

read_regional_data.m: 
Reads the regional data from the Protezione Civile github repository. Here you need to select:
1. the code of the region you want to analyze;
2. the length of the averaging filter.


id_and_sim.m, id_and_sim_r.m: 
Identifies and compares model predictions with data collected


INPUT:     
1. tab_data        (data vector to fit the model);
2. ti              (initial time instant);
3. te              (final time instant);
4. initial_guess    (initial guess for the identification);
5. N               (Number of residents);
6. total_active    (Function of currently active people).
OUTPUT: 
1. pars            (parameters of the model (rho*beta, tau, g, I0);
2. y               (model prediction);
3. If              (Final number of infected people).

Idendtify_model.m: 
Identifies the parameters of the model (nonlinear part)

INPUT:  
1. data            (data vector to fit the model);
2. lim_inf         (Inferior limit for the parameters);
3. lim_sup         (Superior limit for the parameters);
4. times           (Time instants for the identification);
5. initial_guess    (initial guess for the identification);
6. N               (Number of residents);
7. total_active    (Function of currently active people).

OUTPUT: pars            (Parameters identified from the algorithm)

Find_Change: 
finds if there is a breakpoint in the window and where it happened

INPUT:  
1. data            (data vector to fit the model);
2. fit1            (model prediction in the first half of the window);
3. fit2            (model prediction in the second half of the window);
4. fitTot          (model prediction in the entire window);
5. N               (Number of residents);
6. total_active    (Function of currently active people);
7. pr              (Parameters estimated in the entire window).
 

OUTPUT: 
1. Where           (Point where the parameter change happened);
2. Change          (Boolean advising a change in parameters).

 

Least_Squares_id
Runs the constrained Least square identification (linear part)


INPUT:  
1. In              (Infected time series);
2. total_quar      (Quarantined time series);
3. total_hosp      (Hospitalized time series);
4. eta             (Eta identified);
5. total_dead      (Dead time series);
6. tspan           (Time frame for the identification);
7. tau             (tau identified at stage 2).

OUTPUT: pars            (Parameters identified)

----------------------------------------------------------------------------------------------------------------------------------------------------
# Demo and Code Usage
Here we provide the instruction to correctly use the code to get the results of the paper as well as some rule to follow to generate new parameters and simulations.

**IDENTIFICATION PROCEDURE**

Regional Identification: In this section, we provide instructions to run the identification procedure for a given region

1. Select the region code you want to analyze in 'read_regional_data.m' (movemeanK); 
2. Select the averaging filter length in 'read_regional_data.m'; 
3. Select the initial guess for the parameters in the script 'stage1_r.m';
4. Run 'stage1_r.m';
5. Merge the windows following the procedure described in section S2 of the SI;
6. Run 'stage2_r.m' given the merged time windows obtained at point 5;
7. Run 'stage3_r.m'.

National Identification: In this section, we provide instruction to run the identification procedure of the national data
 
1. Select the averaging filter length in 'read_national_data.m' (movemeanK); 
2. Select the initial guess for the parameters in the script 'stage1_r.m';
3. Run 'stage1.m';
4. Merge the windows following the procedure described in section S2 of the SI;
5. Run 'stage2.m' given the merged time windows obtained at point 4;
6. Run 'stage3.m'.

-----------------------------------------------------------------------------------------------------------------------
**SCENARIO GENERATION**


In this section, we provide a selection of rules to replicate the numerical results showed in the paper.

OPEN LOOP SCENARIOS

To replicate open-loop scenarios you need to run 'siqhrd_network_main_montecarlo.m' with the following quantities:
1.  flux_selector: set this quantity to 'high' (figures S1,S2,S3) or 'low' (figure Fig2);
2.  select: set this quantity to '0' (figures Fig2, S1), to '2' (figure S3), to '3' (figure S2); 
3.  index: put the name the region where you want to force deactivation of social distancing as in figures Fig2, S1 (works only if select is set to '0');
4.  flux_control_on: set this quantity to '0'.

To simulate open-loop scenarios where you want to force lockdown in all regions but one, in 'siqhrd_network_main_montecarlo.m' uncomment the line 'index = region2index('lombardy');'. Then put the region name you want to free from lockdown and follow the same instructions for general open loop scenarios.

CLOSED LOOP SCENARIOS

To replicate closed loop scenarios you need to run 'siqhrd_network_main_montecarlo.m' with the following quantities:
1.  flux_selector: setting this quantity to 'high' or 'low' will determine only initial condition for fluxes if flux_control_on is set '1';
2.  select: set this quantity to '1' (figures Fig3a, Fig3b, Fig4, S5, S7), to '4' (figure Fig3c, S2, S6);
3.  flux_control_on: set this quantity to '1'.

For both closed loop and open loop scenarios, the previous instruction set still holds if you want to generate light simulation with just the nominal parameters instead of the Montecarlo campaign.

LATIN HYPERCUBE GENERATION

If you decided to run the Montecarlo campaign in the 'siqhrd_network_main_montecarlo.m' you can also select:
1.  N_param_var: number of Monte-Carlo simulations;
2.  perc: the maximum ratio of parameter variations;
3.  orthogonal: if set to '1' runs an Orthogonal Latin Hypercube for the perturbed parameters generation (each region has its own hypercube).

If you keep the default values, the code simulates scenarios coherent with the results showed in the paper.

CUSTOMIZED SCENARIOS 

If you want to generate scenarios with customized parameters you can run the identification procedure to get the two files 'Regional_stage1.mat' and 'Regional_stage2.mat' for each of the 20 regions (you can find more details about these .mat files in the section 'Identification Description'). From these matrices, you can extract the parameters to manually overwrite the data of 'Parameters_Italy_ph2.mat' by keeping its structure (you can find more details about this .mat file in the section 'Simulator Description'). After that, you can simply follow the instructions listed in OPEN LOOP SCENARIOS and CLOSED LOOP SCENARIOS sections.
