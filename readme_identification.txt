stage2.m, stage2_r.m

run to fit the parameters after stage 2 is completed (it also saves an image to verify the predicion
power of the model)

stage3.m, stage3_r.m

run to fit the parameters etah, etaq, zeta, alpha(I>Q), psi(I>H), kappaQ(Q>H), kappaH(H>Q)
given a storic series of the infected, the time windows and tau

stage1.m, stage1_r.m

run to find the time windows and estimate rho,tau. Note that the initial guess for the infected
should be changed region per region


id_and_sim.m, id_and_sim_r.m
Identifies and compares model predictions with data collected

INPUT: 	tab_data        (data vector to fit the model)
       	ti              (initial time instant)
       	te              (final time instant)
        initial_guess	(initial guess for the identification)
        N               (Number of residents)
        total_active	(Function of currently active people)
OUTPUT: pars            (parameters of the model (rho*beta, tau, g, I0)
        y               (model prediciton)
        If              (Final number of infected people)

Idendtify_model.m 
Identifies the parameters of the model (nonlinear part)

INPUT:  data            (data vector to fit the model)
        lim_inf         (Inferior limit for the parameters)
        lim_sup         (Superior limit for the parameters)
        times           (Time instants for the identification)
        initial_guess	(initial guess for the identification)
        N               (Number of residents)
        total_active	(Function of currently active people)

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
