% https://www.wikiwand.com/en/Regions_of_Italy
population = containers.Map;
population('abruzzo')    = 1311580;
population('aosta')      = 125666;
population('apulia')     = 4029053;
population('basilicata') = 562869;
population('calabria')   = 1947131;
population('campania')   = 5801692;
population('emilia')     = 4459477;
population('friuli')     = 1215220;
population('lazio')      = 5879082;
population('liguria')    = 1550640;
population('lombardy')   = 10060574;
population('marche')     = 1525271;
population('molise')     = 305617;
population('piedmont')   = 4356406;
population('sardinia')   = 1639591;
population('sicily')     = 4999891;
population('tuscany')    = 3729641;
population('trentino')   = 1072276;
population('umbria')     = 882015;
population('veneto')     = 4905854;

% https://www.trovanorme.salute.gov.it/norme/renderNormsanPdf?anno=2020&codLeg=74348&parte=1%20&serie=null
beds_intensive_care = containers.Map;
beds_intensive_care('abruzzo')    = 189;
beds_intensive_care('aosta')      = 18; 
beds_intensive_care('apulia')     = 579;
beds_intensive_care('basilicata') = 81; 
beds_intensive_care('bolzano')    = 77;
beds_intensive_care('calabria')   = 280;
beds_intensive_care('campania')   = 834;
beds_intensive_care('emilia')     = 641;
beds_intensive_care('friuli')     = 175;
beds_intensive_care('lazio')      = 845;
beds_intensive_care('liguria')    = 223;
beds_intensive_care('lombardy')   = 1446;
beds_intensive_care('marche')     = 220;
beds_intensive_care('molise')     = 44;  
beds_intensive_care('piedmont')   = 626;
beds_intensive_care('sardinia')   = 236;
beds_intensive_care('sicily')     = 719;
beds_intensive_care('tuscany')    = 536;
beds_intensive_care('trento')     = 78;
beds_intensive_care('umbria')     = 127; 
beds_intensive_care('veneto')     = 705;

beds_intensive_care('trentino') = beds_intensive_care('trento') + beds_intensive_care('bolzano');

hospitalized = containers.Map;
hospitalized('abruzzo')    = 313 ;
hospitalized('basilicata') = 53  ;
hospitalized('bolzano')    = 123 ;
hospitalized('calabria')   = 108 ;
hospitalized('campania')   = 507 ;
hospitalized('emilia')     = 2309;
hospitalized('friuli')     = 137 ;
hospitalized('lazio')      = 1477;
hospitalized('liguria')    = 734 ;
hospitalized('lombardy')   = 7191;
hospitalized('marche')     = 457 ;
hospitalized('molise')     = 18  ;
hospitalized('piedmont')   = 2684;
hospitalized('apulia')     = 467 ;
hospitalized('sardinia')   = 96  ;
hospitalized('sicily')     = 429 ;
hospitalized('tuscany')    = 644 ;
hospitalized('trento')     = 165 ;
hospitalized('umbria')     = 73  ;
hospitalized('aosta')      = 75  ;
hospitalized('veneto')     = 1087;
%
hospitalized('trentino') = hospitalized('trento') + hospitalized('bolzano');

quarantined = containers.Map;
quarantined('abruzzo')    = 1598 ;
quarantined('basilicata') = 140  ;
quarantined('bolzano')    = 634 ;
quarantined('calabria')   = 619 ;
quarantined('campania')   = 2246 ;
quarantined('emilia')     = 7175;
quarantined('friuli')     = 978 ;
quarantined('lazio')      = 2969 ;
quarantined('liguria')    = 2784 ;
quarantined('lombardy')   = 29282;
quarantined('marche')     = 2754;
quarantined('molise')     = 172  ;
quarantined('piedmont')   = 12878;
quarantined('apulia')     = 2480 ;
quarantined('sardinia')   = 648 ;
quarantined('sicily')     = 1742 ;
quarantined('tuscany')    = 4729 ;
quarantined('trento')     = 1128 ;
quarantined('umbria')     = 131 ;
quarantined('aosta')      = 17 ;
quarantined('veneto')     = 6692;
%
quarantined('trentino') = quarantined('trento') + quarantined('bolzano');

recovered = containers.Map;
recovered('abruzzo')    = 713  ;
recovered('basilicata') = 160   ;
recovered('bolzano')    = 1493   ;
recovered('calabria')   = 299   ;
recovered('campania')   = 1332  ;
recovered('emilia')     = 12581 ;
recovered('friuli')     = 1632  ;
recovered('lazio')      = 1744  ;
recovered('liguria')    = 3424 ;
recovered('lombardy')   = 26136;
recovered('marche')     = 2153   ;
recovered('molise')     = 89   ;
recovered('piedmont')   = 8025   ;
recovered('apulia')     = 731   ;
recovered('sardinia')   = 452   ;
recovered('sicily')     = 786  ;
recovered('tuscany')    = 3218  ;
recovered('trento')     = 2416  ;
recovered('umbria')     = 1121   ;
recovered('aosta')      = 904   ;
recovered('veneto')     = 8840 ;
%
recovered('trentino') = recovered('trento') + recovered('bolzano');

dead = containers.Map;
dead('abruzzo')    = 324;
dead('basilicata') = 25   ;
dead('bolzano')    = 278  ;
dead('calabria')   = 86   ;
dead('campania')   = 359  ;
dead('emilia')     = 3579 ;
dead('friuli')     = 294  ;
dead('lazio')      = 482  ;
dead('liguria')    = 1184 ;
dead('lombardy')   = 13860;
dead('marche')     = 911 ;
dead('molise')     = 21   ;
dead('piedmont')   = 3097 ;
dead('apulia')     = 421  ;
dead('sardinia')   = 117   ;
dead('sicily')     = 237  ;
dead('tuscany')    = 854  ;
dead('trento')     = 423  ;
dead('umbria')     = 68   ;
dead('aosta')      = 137   ;
dead('veneto')     = 1479 ;
%
dead('trentino') = dead('trento') + dead('bolzano');

load('Parameters_Italy_ph2');
order_params = [14 2 11 18 20 8 10 7 17 19 12 9 1 13 6 3 4 5 16 15];

v_identified = containers.Map;
for i = 1:M
    v_identified(index2region(order_params(i))) = v(i);
end

alpha_identified = containers.Map;
for i = 1:M
    alpha_identified(index2region(order_params(i))) = alpha(i);
end

gamma_identified = containers.Map;
for i = 1:M
    gamma_identified(index2region(order_params(i))) = 0.07;
end

psi_identified = containers.Map;
for i = 1:M
    psi_identified(index2region(order_params(i))) = psi(i);
end

kappa_identified = containers.Map;
for i = 1:M
    kappa_identified(index2region(order_params(i))) = kappa(i);
end

kappa_H_identified = containers.Map;
for i = 1:M
    kappa_H_identified(index2region(order_params(i))) = kappah(i);
end

initial_infected_identified = containers.Map;
for i = 1:M
    initial_infected_identified(index2region(order_params(i))) = I0(i);
end

eta_H_identified = containers.Map;
for i = 1:M
    eta_H_identified(index2region(order_params(i))) = etah(i);
end

eta_Q_identified = containers.Map;
for i = 1:M
    eta_Q_identified(index2region(order_params(i))) = etaq(i);
end

zeta_baseline_identified = 0.0168;
zeta_slope_identified = 0.0068;

clear('I0','alpha','etah','etaq','kappa','kappah','v','zeta')
