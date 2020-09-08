
codes_Regions=data.codice_regione;

%Load the data
total_positive= data.totale_positivi';
total_rec = data.dimessi_guariti';
total_dead =   data.deceduti';
total_hosp = data.totale_ospedalizzati';
total_quar = data.isolamento_domiciliare';
total_tamp = data.tamponi';

%Select only the ones belonging to the current region
total_positive=total_positive((codes_Regions==region_code));
total_rec=total_rec((codes_Regions==region_code));
total_dead=total_dead((codes_Regions==region_code));
total_hosp = total_hosp((codes_Regions==region_code));
total_quar = total_quar((codes_Regions==region_code));
total_tamp = total_tamp((codes_Regions==region_code));

% Merge data from PA Bolzano and PA Trento
if region_code==4 
    total_positive=total_positive(1:2:end)+total_positive(2:2:end);
    total_rec=total_rec(1:2:end)+total_rec(2:2:end);
    total_dead=total_dead(1:2:end)+total_dead(2:2:end);
    total_hosp=total_hosp(1:2:end)+total_hosp(2:2:end);
    total_quar=total_quar(1:2:end)+total_quar(2:2:end);
    total_tamp=total_tamp(1:2:end)+total_tamp(2:2:end);
end


%Retrieve the population and the name of the region
[N,Namer]=Set_Population(region_code);




%Average data
total_positive= movmean(total_positive,movmeanK);
total_rec = movmean(total_rec,movmeanK);
total_dead   = movmean(total_dead,movmeanK)';
total_hosp     = movmean(total_hosp,movmeanK)';
total_quar     = movmean(total_quar,movmeanK);
tab_data       = [total_positive+total_rec+total_dead];
total_active  = N-total_quar-total_hosp-total_dead;
In             = movmean(In,movmeanK,'omitnan');